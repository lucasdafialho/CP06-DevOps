#!/bin/bash

set -e
    
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

echo -e "${YELLOW}Etapa 1: Configurando variáveis...${NC}"

RESOURCE_GROUP="rg-biblioteca-app"
LOCATION="brazilsouth"
DB_SERVER_NAME="sqlserver-biblioteca-app"
DB_NAME="BibliotecaDB"
APP_SERVICE_PLAN="plan-biblioteca-app"
WEB_APP_NAME="webapp-biblioteca-api"
DB_ADMIN_USER="sqladmin"
DB_ADMIN_PASSWORD="SuaSenhaSegura@123"
APP_INSIGHTS_NAME="appinsights-biblioteca"

echo -e "${GREEN}✓ Variáveis configuradas${NC}\n"

# --- Registrar Resource Providers ---

echo -e "${YELLOW}Etapa 2: Verificando Resource Providers...${NC}"

# Registrar providers
az provider register --namespace Microsoft.Sql --output none
az provider register --namespace Microsoft.Web --output none
az provider register --namespace Microsoft.Storage --output none
az provider register --namespace Microsoft.Insights --output none
az provider register --namespace Microsoft.OperationalInsights --output none

echo "Aguardando registro completo dos providers..."

# Aguardar até que todos estejam registrados
while true; do
    SQL_STATE=$(az provider show --namespace Microsoft.Sql --query "registrationState" -o tsv 2>/dev/null)
    WEB_STATE=$(az provider show --namespace Microsoft.Web --query "registrationState" -o tsv 2>/dev/null)
    STORAGE_STATE=$(az provider show --namespace Microsoft.Storage --query "registrationState" -o tsv 2>/dev/null)
    INSIGHTS_STATE=$(az provider show --namespace Microsoft.Insights --query "registrationState" -o tsv 2>/dev/null)
    OPINSIGHTS_STATE=$(az provider show --namespace Microsoft.OperationalInsights --query "registrationState" -o tsv 2>/dev/null)

    if [ "$SQL_STATE" = "Registered" ] && [ "$WEB_STATE" = "Registered" ] && [ "$STORAGE_STATE" = "Registered" ] && [ "$INSIGHTS_STATE" = "Registered" ] && [ "$OPINSIGHTS_STATE" = "Registered" ]; then
        break
    fi

    echo "  Aguardando... (SQL: $SQL_STATE, Web: $WEB_STATE, Storage: $STORAGE_STATE, Insights: $INSIGHTS_STATE, OpInsights: $OPINSIGHTS_STATE)"
    sleep 10
done

echo -e "${GREEN}✓ Todos os Resource Providers registrados com sucesso${NC}\n"

# --- Criar Infraestrutura ---

echo -e "${YELLOW}Etapa 3: Criando Grupo de Recursos...${NC}"
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION \
    --output none
echo -e "${GREEN}✓ Grupo de Recursos criado${NC}\n"

echo -e "${YELLOW}Etapa 4: Criando Servidor SQL...${NC}"
az sql server create \
    --name $DB_SERVER_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --admin-user $DB_ADMIN_USER \
    --admin-password $DB_ADMIN_PASSWORD \
    --output none
echo -e "${GREEN}✓ Servidor SQL criado${NC}\n"

echo -e "${YELLOW}Etapa 5: Configurando Firewall...${NC}"
az sql server firewall-rule create \
    --resource-group $RESOURCE_GROUP \
    --server $DB_SERVER_NAME \
    --name AllowAzureServices \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 0.0.0.0 \
    --output none
az sql server firewall-rule create \
    --resource-group $RESOURCE_GROUP \
    --server $DB_SERVER_NAME \
    --name AllowAll \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 255.255.255.255 \
    --output none
echo -e "${GREEN}✓ Firewall configurado${NC}\n"

echo -e "${YELLOW}Etapa 6: Criando Banco de Dados...${NC}"
az sql db create \
    --resource-group $RESOURCE_GROUP \
    --server $DB_SERVER_NAME \
    --name $DB_NAME \
    --service-objective S0 \
    --backup-storage-redundancy Local \
    --output none
echo -e "${GREEN}✓ Banco de Dados criado${NC}\n"

# 6. Criar Application Insights (usando método alternativo)
echo -e "\n${GREEN}6. Criando Application Insights...${NC}"
echo -e "${YELLOW}Instalando extensão application-insights...${NC}"

# Configurar para aceitar extensões preview
az config set extension.dynamic_install_allow_preview=true

# Instalar extensão se necessário
az extension add --name application-insights --allow-preview true 2>/dev/null || true

# Criar Application Insights
az monitor app-insights component create \
    --app $APP_INSIGHTS_NAME \
    --location $LOCATION \
    --resource-group $RESOURCE_GROUP \
    --application-type web \
    --output table

echo -e "${YELLOW}Etapa 7: Criando App Service Plan...${NC}"
az appservice plan create \
    --name $APP_SERVICE_PLAN \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku B1 \
    --is-linux \
    --output none
echo -e "${GREEN}✓ App Service Plan criado${NC}\n"

echo -e "${YELLOW}Etapa 8: Criando Web App...${NC}"
az webapp create \
    --resource-group $RESOURCE_GROUP \
    --plan $APP_SERVICE_PLAN \
    --name $WEB_APP_NAME \
    --runtime "DOTNETCORE:8.0" \
    --output none
echo -e "${GREEN}✓ Web App criado${NC}\n"

echo -e "${YELLOW}Etapa 9: Configurando Connection String...${NC}"
CONNECTION_STRING="Server=tcp:${DB_SERVER_NAME}.database.windows.net,1433;Initial Catalog=${DB_NAME};Persist Security Info=False;User ID=${DB_ADMIN_USER};Password=${DB_ADMIN_PASSWORD};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

az webapp config connection-string set \
    --resource-group $RESOURCE_GROUP \
    --name $WEB_APP_NAME \
    --settings DefaultConnection="$CONNECTION_STRING" \
    --connection-string-type SQLAzure \
    --output none
echo -e "${GREEN}✓ Connection String configurada${NC}\n"

echo -e "${YELLOW}Etapa 10: Configurando App Settings...${NC}"
az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $WEB_APP_NAME \
    --settings \
        ASPNETCORE_ENVIRONMENT="Production" \
        WEBSITE_RUN_FROM_PACKAGE="1" \
        SCM_DO_BUILD_DURING_DEPLOYMENT="false" \
        WEBSITE_ENABLE_SYNC_UPDATE_SITE="true" \
    --output none
echo -e "${GREEN}✓ App Settings configurado${NC}\n"

# --- Deploy da Aplicação ---

echo -e "${YELLOW}Etapa 11: Preparando projeto .NET...${NC}"

# Volta para o diretório raiz do projeto
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."

# Remove clone antigo se existir (para evitar conflitos)
if [ -d "Scripts/CP06-DevOps" ]; then
    echo "Removendo clone anterior em Scripts/CP06-DevOps..."
    rm -rf Scripts/CP06-DevOps
fi

PROJECT_FILE=$(find . -maxdepth 1 -name "*.csproj" | head -n 1)

if [ -z "$PROJECT_FILE" ]; then
    echo -e "${YELLOW}Erro: Não foi possível encontrar projeto .NET (*.csproj).${NC}"
    exit 1
fi

echo "Projeto encontrado: $PROJECT_FILE"
echo -e "${YELLOW}Compilando aplicação...${NC}"
dotnet publish "$PROJECT_FILE" -c Release -o ./publish
echo -e "${GREEN}✓ Aplicação compilada${NC}\n"

echo -e "${YELLOW}Etapa 12: Fazendo deploy para Azure...${NC}"
cd publish
rm -f ../app.zip

# Criar zip usando PowerShell (compatível com Windows)
powershell.exe -Command "Compress-Archive -Path ./* -DestinationPath ../app.zip -Force"

cd ..

echo "Enviando pacote para Azure via Kudu API..."

# Criar script PowerShell temporário para fazer o deploy
cat > temp_deploy.ps1 <<'PWSH'
$creds = az webapp deployment list-publishing-credentials --resource-group rg-biblioteca-app --name webapp-biblioteca-api --query "{username:publishingUserName, password:publishingPassword}" | ConvertFrom-Json
$pair = "$($creds.username):$($creds.password)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$Headers = @{Authorization = "Basic $encodedCreds"}
$apiUrl = "https://webapp-biblioteca-api.scm.azurewebsites.net/api/zipdeploy"
Invoke-RestMethod -Uri $apiUrl -Headers $Headers -Method POST -InFile "app.zip" -ContentType "application/zip" -TimeoutSec 300
PWSH

powershell.exe -ExecutionPolicy Bypass -File temp_deploy.ps1
rm -f temp_deploy.ps1

rm -f app.zip
rm -rf ./publish

echo -e "${GREEN}✓ Deploy concluído${NC}\n"

echo -e "${YELLOW}Etapa 13: Reiniciando Web App...${NC}"
az webapp restart \
    --resource-group $RESOURCE_GROUP \
    --name $WEB_APP_NAME \
    --output none

sleep 5

echo -e "${GREEN}✓ Web App reiniciado${NC}\n"

# --- Finalização ---

WEBAPP_URL="https://$WEB_APP_NAME.azurewebsites.net"

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}DEPLOY CONCLUÍDO COM SUCESSO!${NC}"
echo -e "${GREEN}======================================================${NC}"
echo -e "URL da Aplicação: ${YELLOW}$WEBAPP_URL${NC}"
echo -e "Servidor SQL: ${YELLOW}${DB_SERVER_NAME}.database.windows.net${NC}"
echo -e "Banco de Dados: ${YELLOW}$DB_NAME${NC}"
echo -e "Usuário: ${YELLOW}$DB_ADMIN_USER${NC}"
echo ""
echo "Aguarde 2-3 minutos para a aplicação iniciar completamente."
echo -e "${GREEN}======================================================${NC}"