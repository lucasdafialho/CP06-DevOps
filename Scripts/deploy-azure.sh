#!/bin/bash

# =============================================
# Script de Deploy Azure - Sistema Biblioteca
# =============================================

# Variáveis de configuração
RESOURCE_GROUP="rg-biblioteca-app"
LOCATION="eastus"
SQL_SERVER_NAME="sqlserver-biblioteca-app"
SQL_DB_NAME="BibliotecaDB"
SQL_ADMIN_USER="sqladmin"
SQL_ADMIN_PASSWORD="SuaSenhaSegura@123"
APP_SERVICE_PLAN="plan-biblioteca-app"
WEB_APP_NAME="webapp-biblioteca-api"
APP_INSIGHTS_NAME="appinsights-biblioteca"

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}Iniciando Deploy da Aplicação Biblioteca${NC}"
echo -e "${BLUE}==============================================${NC}"

# 1. Login no Azure
echo -e "\n${GREEN}1. Realizando login no Azure...${NC}"
az login

# 2. Criar Resource Group
echo -e "\n${GREEN}2. Criando Resource Group...${NC}"
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION

# 3. Criar SQL Server
echo -e "\n${GREEN}3. Criando SQL Server...${NC}"
az sql server create \
    --name $SQL_SERVER_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --admin-user $SQL_ADMIN_USER \
    --admin-password $SQL_ADMIN_PASSWORD

# 4. Configurar Firewall do SQL Server (permitir serviços do Azure)
echo -e "\n${GREEN}4. Configurando Firewall do SQL Server...${NC}"
az sql server firewall-rule create \
    --resource-group $RESOURCE_GROUP \
    --server $SQL_SERVER_NAME \
    --name AllowAzureServices \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 0.0.0.0

# 5. Criar SQL Database
echo -e "\n${GREEN}5. Criando SQL Database...${NC}"
az sql db create \
    --resource-group $RESOURCE_GROUP \
    --server $SQL_SERVER_NAME \
    --name $SQL_DB_NAME \
    --service-objective S0

# 6. Criar Application Insights
echo -e "\n${GREEN}6. Criando Application Insights...${NC}"
az monitor app-insights component create \
    --app $APP_INSIGHTS_NAME \
    --location $LOCATION \
    --resource-group $RESOURCE_GROUP \
    --application-type web

# 7. Obter Connection String do Application Insights
echo -e "\n${GREEN}7. Obtendo Connection String do Application Insights...${NC}"
APP_INSIGHTS_CONNECTION_STRING=$(az monitor app-insights component show \
    --app $APP_INSIGHTS_NAME \
    --resource-group $RESOURCE_GROUP \
    --query connectionString \
    --output tsv)

# 8. Criar App Service Plan
echo -e "\n${GREEN}8. Criando App Service Plan...${NC}"
az appservice plan create \
    --name $APP_SERVICE_PLAN \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku B1 \
    --is-linux

# 9. Criar Web App
echo -e "\n${GREEN}9. Criando Web App...${NC}"
az webapp create \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --plan $APP_SERVICE_PLAN \
    --runtime "DOTNET|8.0"

# 10. Configurar Connection String no Web App
echo -e "\n${GREEN}10. Configurando Connection String no Web App...${NC}"
SQL_CONNECTION_STRING="Server=tcp:${SQL_SERVER_NAME}.database.windows.net,1433;Initial Catalog=${SQL_DB_NAME};Persist Security Info=False;User ID=${SQL_ADMIN_USER};Password=${SQL_ADMIN_PASSWORD};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

az webapp config connection-string set \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --connection-string-type SQLAzure \
    --settings DefaultConnection="$SQL_CONNECTION_STRING"

# 11. Configurar Application Insights no Web App
echo -e "\n${GREEN}11. Configurando Application Insights no Web App...${NC}"
az webapp config appsettings set \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --settings ApplicationInsights__ConnectionString="$APP_INSIGHTS_CONNECTION_STRING"

# 12. Habilitar logs do Web App
echo -e "\n${GREEN}12. Habilitando logs do Web App...${NC}"
az webapp log config \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --application-logging filesystem \
    --detailed-error-messages true \
    --failed-request-tracing true \
    --web-server-logging filesystem

# 13. Deploy da aplicação
echo -e "\n${GREEN}13. Realizando deploy da aplicação...${NC}"
cd ..
dotnet publish -c Release -o ./publish
cd publish
zip -r ../deploy.zip .
cd ..

az webapp deployment source config-zip \
    --resource-group $RESOURCE_GROUP \
    --name $WEB_APP_NAME \
    --src deploy.zip

# Limpar arquivo zip
rm deploy.zip

# 14. Exibir informações importantes
echo -e "\n${BLUE}==============================================${NC}"
echo -e "${GREEN}Deploy concluído com sucesso!${NC}"
echo -e "${BLUE}==============================================${NC}"
echo -e "\n${GREEN}Informações importantes:${NC}"
echo -e "Resource Group: ${BLUE}$RESOURCE_GROUP${NC}"
echo -e "SQL Server: ${BLUE}${SQL_SERVER_NAME}.database.windows.net${NC}"
echo -e "Database: ${BLUE}$SQL_DB_NAME${NC}"
echo -e "Web App URL: ${BLUE}https://${WEB_APP_NAME}.azurewebsites.net${NC}"
echo -e "Application Insights: ${BLUE}$APP_INSIGHTS_NAME${NC}"
echo -e "\n${GREEN}Connection Strings:${NC}"
echo -e "SQL: ${BLUE}$SQL_CONNECTION_STRING${NC}"
echo -e "App Insights: ${BLUE}$APP_INSIGHTS_CONNECTION_STRING${NC}"
echo -e "\n${RED}IMPORTANTE: Execute o script DDL_Script.sql no banco de dados para criar as tabelas!${NC}"
echo -e "${BLUE}==============================================${NC}"

