#!/bin/bash

export RESOURCE_GROUP="rg-biblioteca"
export LOCATION="brazilsouth"

export APP_NAME="biblioteca-dotnet-app-rm554513"
export APP_RUNTIME="DOTNETCORE:8.0"
export APP_INSIGHTS="ai-biblioteca"

export GITHUB_REPO="SEU_USUARIO/SEU_REPOSITORIO"
export BRANCH="main"

export DB_SERVER_NAME="biblioteca-dotnet-app-rm554513"
export DB_NAME="BibliotecaDB"
export DB_USER="sqladmin"
export DB_PASS="SenhaForte123!"

# CONNECTION_STRING = Server=tcp:biblioteca-dotnet-app-rm554513.database.windows.net,1433;Initial Catalog=BibliotecaDB;Persist Security Info=False;User ID=sqladmin@biblioteca-dotnet-app-rm554513;Password=SenhaForte123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;

# Registra os Providers
az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.Insights
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.ServiceLinker
az provider register --namespace Microsoft.Sql

# Criar o Resource Group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Criar o Application Insights
az monitor app-insights component create \
  --app $APP_INSIGHTS \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP \
  --application-type web

# Criar o Plano de Serviço
az appservice plan create \
  --name $APP_NAME-plan \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku B1 \
  --is-linux

# Criar o Serviço de Aplicativo
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_NAME-plan \
  --name $APP_NAME \
  --runtime $APP_RUNTIME

# Habilita a autenticação básica (SCM)
az resource update \
  --resource-group $RESOURCE_GROUP \
  --namespace Microsoft.Web \
  --resource-type basicPublishingCredentialsPolicies \
  --name scm \
  --parent sites/$APP_NAME \
  --set properties.allow=true

# Recuperar a String de Conexão do Application Insights
CONNECTION_STRING=$(az monitor app-insights component show \
  --app $APP_INSIGHTS \
  --resource-group $RESOURCE_GROUP \
  --query connectionString \
  --output tsv)

# Criar SQL Server 
az sql server create \
  --resource-group $RESOURCE_GROUP \
  --name $DB_SERVER_NAME \
  --location $LOCATION \
  --admin-user $DB_USER \
  --admin-password $DB_PASS \
  --enable-public-network true

# Criar o banco
az sql db create \
  --resource-group $RESOURCE_GROUP \
  --server $DB_SERVER_NAME \
  --name $DB_NAME \
  --service-objective Basic \
  --backup-storage-redundancy Local \
  --zone-redundant false

# Liberar os IPS de acesso ao banco
az sql server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server $DB_SERVER_NAME \
  --name AllowAll \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

# Configurar as Variáveis de Ambiente
az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $APP_NAME \
  --settings \
    APPLICATIONINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING" \
    ApplicationInsightsAgent_EXTENSION_VERSION="~3" \
    XDT_MicrosoftApplicationInsights_Mode="Recommended" \
    XDT_MicrosoftApplicationInsights_PreemptSdk="1" \
    ASPNETCORE_ENVIRONMENT="Production"

# Configurar Connection String do Banco de Dados
az webapp config connection-string set \
  --resource-group $RESOURCE_GROUP \
  --name $APP_NAME \
  --settings DefaultConnection="Server=tcp:${DB_SERVER_NAME}.database.windows.net,1433;Initial Catalog=${DB_NAME};Persist Security Info=False;User ID=${DB_USER};Password=${DB_PASS};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" \
  --connection-string-type SQLAzure

# Reiniciar o App
az webapp restart \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# Criar a conexão App com o Application Insights
az monitor app-insights component connect-webapp \
  --app $APP_INSIGHTS \
  --web-app $APP_NAME \
  --resource-group $RESOURCE_GROUP

# Configurar Github Actions
az webapp deployment github-actions add \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --repo $GITHUB_REPO \
  --branch $BRANCH \
  --login-with-github
