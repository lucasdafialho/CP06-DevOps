# =============================================
# Script de Deploy Azure - Sistema Biblioteca
# PowerShell Version
# =============================================

# Variáveis de configuração
$RESOURCE_GROUP = "rg-biblioteca-app"
$LOCATION = "eastus"
$SQL_SERVER_NAME = "sqlserver-biblioteca-app"
$SQL_DB_NAME = "BibliotecaDB"
$SQL_ADMIN_USER = "sqladmin"
$SQL_ADMIN_PASSWORD = "SuaSenhaSegura@123"
$APP_SERVICE_PLAN = "plan-biblioteca-app"
$WEB_APP_NAME = "webapp-biblioteca-api"
$APP_INSIGHTS_NAME = "appinsights-biblioteca"

Write-Host "=============================================="
Write-Host "Iniciando Deploy da Aplicação Biblioteca" -ForegroundColor Blue
Write-Host "=============================================="

# 1. Login no Azure
Write-Host "`n1. Realizando login no Azure..." -ForegroundColor Green
az login

# 2. Criar Resource Group
Write-Host "`n2. Criando Resource Group..." -ForegroundColor Green
az group create `
    --name $RESOURCE_GROUP `
    --location $LOCATION

# 3. Criar SQL Server
Write-Host "`n3. Criando SQL Server..." -ForegroundColor Green
az sql server create `
    --name $SQL_SERVER_NAME `
    --resource-group $RESOURCE_GROUP `
    --location $LOCATION `
    --admin-user $SQL_ADMIN_USER `
    --admin-password $SQL_ADMIN_PASSWORD

# 4. Configurar Firewall do SQL Server
Write-Host "`n4. Configurando Firewall do SQL Server..." -ForegroundColor Green
az sql server firewall-rule create `
    --resource-group $RESOURCE_GROUP `
    --server $SQL_SERVER_NAME `
    --name AllowAzureServices `
    --start-ip-address 0.0.0.0 `
    --end-ip-address 0.0.0.0

# 5. Criar SQL Database
Write-Host "`n5. Criando SQL Database..." -ForegroundColor Green
az sql db create `
    --resource-group $RESOURCE_GROUP `
    --server $SQL_SERVER_NAME `
    --name $SQL_DB_NAME `
    --service-objective S0

# 6. Criar Application Insights
Write-Host "`n6. Criando Application Insights..." -ForegroundColor Green
az monitor app-insights component create `
    --app $APP_INSIGHTS_NAME `
    --location $LOCATION `
    --resource-group $RESOURCE_GROUP `
    --application-type web

# 7. Obter Connection String do Application Insights
Write-Host "`n7. Obtendo Connection String do Application Insights..." -ForegroundColor Green
$APP_INSIGHTS_CONNECTION_STRING = az monitor app-insights component show `
    --app $APP_INSIGHTS_NAME `
    --resource-group $RESOURCE_GROUP `
    --query connectionString `
    --output tsv

# 8. Criar App Service Plan
Write-Host "`n8. Criando App Service Plan..." -ForegroundColor Green
az appservice plan create `
    --name $APP_SERVICE_PLAN `
    --resource-group $RESOURCE_GROUP `
    --location $LOCATION `
    --sku B1 `
    --is-linux

# 9. Criar Web App
Write-Host "`n9. Criando Web App..." -ForegroundColor Green
az webapp create `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --plan $APP_SERVICE_PLAN `
    --runtime "DOTNET:8.0"

# 10. Configurar Connection String no Web App
Write-Host "`n10. Configurando Connection String no Web App..." -ForegroundColor Green
$SQL_CONNECTION_STRING = "Server=tcp:${SQL_SERVER_NAME}.database.windows.net,1433;Initial Catalog=${SQL_DB_NAME};Persist Security Info=False;User ID=${SQL_ADMIN_USER};Password=${SQL_ADMIN_PASSWORD};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

az webapp config connection-string set `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --connection-string-type SQLAzure `
    --settings DefaultConnection="$SQL_CONNECTION_STRING"

# 11. Configurar Application Insights no Web App
Write-Host "`n11. Configurando Application Insights no Web App..." -ForegroundColor Green
az webapp config appsettings set `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --settings ApplicationInsights__ConnectionString="$APP_INSIGHTS_CONNECTION_STRING"

# 12. Habilitar logs do Web App
Write-Host "`n12. Habilitando logs do Web App..." -ForegroundColor Green
az webapp log config `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --application-logging filesystem `
    --detailed-error-messages true `
    --failed-request-tracing true `
    --web-server-logging filesystem

# 13. Deploy da aplicação
Write-Host "`n13. Realizando deploy da aplicação..." -ForegroundColor Green
Set-Location ..
dotnet publish -c Release -o ./publish
Compress-Archive -Path ./publish/* -DestinationPath ./deploy.zip -Force

az webapp deployment source config-zip `
    --resource-group $RESOURCE_GROUP `
    --name $WEB_APP_NAME `
    --src deploy.zip

# Limpar arquivo zip
Remove-Item deploy.zip
Remove-Item -Recurse -Force ./publish

# 14. Exibir informações importantes
Write-Host "`n=============================================="
Write-Host "Deploy concluído com sucesso!" -ForegroundColor Green
Write-Host "=============================================="
Write-Host "`nInformações importantes:" -ForegroundColor Green
Write-Host "Resource Group: $RESOURCE_GROUP" -ForegroundColor Blue
Write-Host "SQL Server: ${SQL_SERVER_NAME}.database.windows.net" -ForegroundColor Blue
Write-Host "Database: $SQL_DB_NAME" -ForegroundColor Blue
Write-Host "Web App URL: https://${WEB_APP_NAME}.azurewebsites.net" -ForegroundColor Blue
Write-Host "Application Insights: $APP_INSIGHTS_NAME" -ForegroundColor Blue
Write-Host "`nConnection Strings:" -ForegroundColor Green
Write-Host "SQL: $SQL_CONNECTION_STRING" -ForegroundColor Blue
Write-Host "App Insights: $APP_INSIGHTS_CONNECTION_STRING" -ForegroundColor Blue
Write-Host "`nIMPORTANTE: Execute o script DDL_Script.sql no banco de dados para criar as tabelas!" -ForegroundColor Red
Write-Host "=============================================="

