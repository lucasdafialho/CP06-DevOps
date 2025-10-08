#!/bin/bash

export RESOURCE_GROUP="rg-biblioteca-557884"
export LOCATION="brazilsouth"

export APP_NAME="biblioteca-dotnet-app-rm557884"
export APP_RUNTIME="DOTNETCORE:8.0"
export APP_INSIGHTS="ai-biblioteca-557884"

export DB_SERVER_NAME="biblioteca-dotnet-app-rm557884"
export DB_NAME="BibliotecaDB"
export DB_USER="bibliotecaadmin"
export DB_PASS="SenhaForte557884!"

az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.Insights
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.ServiceLinker
az provider register --namespace Microsoft.Sql

az group create --name $RESOURCE_GROUP --location $LOCATION

az monitor app-insights component create \
  --app $APP_INSIGHTS \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP \
  --application-type web

az appservice plan create \
  --name $APP_NAME-plan \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku B1 \
  --is-linux

az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_NAME-plan \
  --name $APP_NAME \
  --runtime $APP_RUNTIME

az resource update \
  --resource-group $RESOURCE_GROUP \
  --namespace Microsoft.Web \
  --resource-type basicPublishingCredentialsPolicies \
  --name scm \
  --parent sites/$APP_NAME \
  --set properties.allow=true

az sql server create \
  --resource-group $RESOURCE_GROUP \
  --name $DB_SERVER_NAME \
  --location $LOCATION \
  --admin-user $DB_USER \
  --admin-password $DB_PASS \
  --enable-public-network true

az sql db create \
  --resource-group $RESOURCE_GROUP \
  --server $DB_SERVER_NAME \
  --name $DB_NAME \
  --service-objective Basic \
  --backup-storage-redundancy Local \
  --zone-redundant false

az sql server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server $DB_SERVER_NAME \
  --name AllowAll \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

CONNECTION_STRING=$(az monitor app-insights component show \
  --app $APP_INSIGHTS \
  --resource-group $RESOURCE_GROUP \
  --query connectionString \
  --output tsv)

DB_CONNECTION_STRING="Server=tcp:$DB_SERVER_NAME.database.windows.net,1433;Initial Catalog=$DB_NAME;User ID=$DB_USER;Password=$DB_PASS;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

az webapp config connection-string set \
  --resource-group $RESOURCE_GROUP \
  --name $APP_NAME \
  --settings DefaultConnection="$DB_CONNECTION_STRING" \
  --connection-string-type SQLAzure

az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $APP_NAME \
  --settings \
    APPLICATIONINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING" \
    ApplicationInsightsAgent_EXTENSION_VERSION="~3" \
    XDT_MicrosoftApplicationInsights_Mode="Recommended" \
    XDT_MicrosoftApplicationInsights_PreemptSdk="1" \
    ASPNETCORE_ENVIRONMENT="Production"

az monitor app-insights component connect-webapp \
  --app $APP_INSIGHTS \
  --web-app $APP_NAME \
  --resource-group $RESOURCE_GROUP

az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --application-logging filesystem \
  --detailed-error-messages true \
  --failed-request-tracing true \
  --web-server-logging filesystem

az webapp restart \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

echo "=============================================="
echo "DEPLOY CONCLUÍDO COM SUCESSO!"
echo "=============================================="
echo "URL da Aplicação: https://$APP_NAME.azurewebsites.net"
echo "Servidor SQL: $DB_SERVER_NAME.database.windows.net"
echo "Banco de Dados: $DB_NAME"
echo "Usuário: $DB_USER"
echo ""
echo "IMPORTANTE: Execute o script DDL_Script.sql no banco de dados para criar as tabelas!"
echo ""
echo "Aguarde 2-3 minutos para a aplicação iniciar completamente."
echo "=============================================="
