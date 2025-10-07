# Guia Completo de Implantação - Sistema Biblioteca Azure

## Índice
1. [Pré-requisitos](#pré-requisitos)
2. [Opção 1: Deploy via Azure CLI (Recomendado)](#opção-1-deploy-via-azure-cli-recomendado)
3. [Opção 2: Deploy via Visual Studio Code](#opção-2-deploy-via-visual-studio-code)
4. [Configuração do Banco de Dados](#configuração-do-banco-de-dados)
5. [Validação da Aplicação](#validação-da-aplicação)
6. [Monitoramento com Application Insights](#monitoramento-com-application-insights)
7. [Solução de Problemas](#solução-de-problemas)

---

## Pré-requisitos

### Software Necessário
- **Azure CLI**: [Download](https://docs.microsoft.com/cli/azure/install-azure-cli)
- **.NET 8.0 SDK**: [Download](https://dotnet.microsoft.com/download/dotnet/8.0)
- **Visual Studio Code** (opcional): [Download](https://code.visualstudio.com/)
- **Azure Extension for VS Code** (opcional): [Install](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice)

### Conta Azure
- Conta ativa do Azure
- Permissões para criar recursos
- Assinatura válida

---

## Opção 1: Deploy via Azure CLI (Recomendado)

### 1.1. Configurar Variáveis

Antes de executar o script, edite as variáveis no arquivo conforme sua necessidade:

**Para Linux/Mac:**
```bash
nano Scripts/deploy-azure.sh
```

**Para Windows (PowerShell):**
```powershell
notepad Scripts\deploy-azure.ps1
```

Personalize as seguintes variáveis:
```bash
RESOURCE_GROUP="rg-biblioteca-app"          # Nome do Resource Group
LOCATION="eastus"                            # Região do Azure
SQL_SERVER_NAME="sqlserver-biblioteca-app"   # Nome do SQL Server (deve ser único)
WEB_APP_NAME="webapp-biblioteca-api"         # Nome do Web App (deve ser único)
SQL_ADMIN_PASSWORD="SuaSenhaSegura@123"      # Senha do SQL Server
```

### 1.2. Executar Script de Deploy

**Linux/Mac:**
```bash
cd Scripts
chmod +x deploy-azure.sh
./deploy-azure.sh
```

**Windows (PowerShell como Administrador):**
```powershell
cd Scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
.\deploy-azure.ps1
```

### 1.3. O que o Script Faz

O script automaticamente:
1. Faz login no Azure
2. Cria Resource Group
3. Cria SQL Server e Database
4. Configura Firewall do SQL Server
5. Cria Application Insights
6. Cria App Service Plan
7. Cria Web App
8. Configura Connection Strings
9. Realiza o deploy da aplicação
10. Habilita logs e monitoramento

---

## Opção 2: Deploy via Visual Studio Code

### 2.1. Instalar Extensões

1. Abra o VS Code
2. Instale a extensão: **Azure App Service**
3. Instale a extensão: **Azure Databases**

### 2.2. Criar Recursos no Azure Portal

#### Criar Resource Group
```bash
az group create --name rg-biblioteca-app --location eastus
```

#### Criar SQL Server e Database
```bash
az sql server create \
    --name sqlserver-biblioteca-app \
    --resource-group rg-biblioteca-app \
    --location eastus \
    --admin-user sqladmin \
    --admin-password SuaSenhaSegura@123

az sql db create \
    --resource-group rg-biblioteca-app \
    --server sqlserver-biblioteca-app \
    --name BibliotecaDB \
    --service-objective S0
```

#### Criar Application Insights
```bash
az monitor app-insights component create \
    --app appinsights-biblioteca \
    --location eastus \
    --resource-group rg-biblioteca-app \
    --application-type web
```

### 2.3. Deploy pelo VS Code

1. Abra o projeto no VS Code
2. Clique com botão direito na pasta do projeto
3. Selecione **Deploy to Web App**
4. Siga o assistente:
   - Selecione ou crie um Web App
   - Selecione o Runtime: **.NET 8.0**
   - Selecione o Pricing Tier: **B1**
   - Confirme o deploy

### 2.4. Configurar Connection Strings no Portal Azure

1. Acesse o [Portal Azure](https://portal.azure.com)
2. Navegue até o Web App criado
3. Vá em **Configuration** > **Connection Strings**
4. Adicione:
   - **Name**: `DefaultConnection`
   - **Value**: `Server=tcp:sqlserver-biblioteca-app.database.windows.net,1433;Initial Catalog=BibliotecaDB;Persist Security Info=False;User ID=sqladmin;Password=SuaSenhaSegura@123;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;`
   - **Type**: `SQLAzure`

5. Vá em **Configuration** > **Application Settings**
6. Adicione:
   - **Name**: `ApplicationInsights__ConnectionString`
   - **Value**: (obter do Application Insights criado)

---

## Configuração do Banco de Dados

### 3.1. Executar Script DDL

Após criar o SQL Database, execute o script para criar as tabelas:

#### Opção A: Via Azure Data Studio / SQL Server Management Studio
1. Conecte-se ao servidor: `sqlserver-biblioteca-app.database.windows.net`
2. Usuário: `sqladmin`
3. Senha: `SuaSenhaSegura@123`
4. Abra o arquivo: `Database/DDL_Script.sql`
5. Execute o script

#### Opção B: Via Azure CLI
```bash
az sql db show-connection-string --client sqlcmd --name BibliotecaDB --server sqlserver-biblioteca-app

sqlcmd -S sqlserver-biblioteca-app.database.windows.net -d BibliotecaDB -U sqladmin -P SuaSenhaSegura@123 -i Database/DDL_Script.sql
```

### 3.2. Verificar Tabelas Criadas

Execute no SQL:
```sql
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
```

Resultado esperado:
- Tabela: **Autores**
- Tabela: **Livros**

### 3.3. Verificar Foreign Keys

```sql
SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    tr.name AS ReferencedTable
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id;
```

---

## Validação da Aplicação

### 4.1. Acessar Swagger UI

1. Abra o navegador
2. Acesse: `https://webapp-biblioteca-api.azurewebsites.net/swagger`
3. Você verá a documentação da API

### 4.2. Testar Endpoints

#### Criar um Autor (POST)
```bash
curl -X POST "https://webapp-biblioteca-api.azurewebsites.net/api/autores" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Machado de Assis",
    "nacionalidade": "Brasileira"
  }'
```

#### Listar Autores (GET)
```bash
curl -X GET "https://webapp-biblioteca-api.azurewebsites.net/api/autores"
```

#### Criar um Livro (POST)
```bash
curl -X POST "https://webapp-biblioteca-api.azurewebsites.net/api/livros" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Dom Casmurro",
    "anoPublicacao": 1899,
    "autorId": 1
  }'
```

#### Listar Livros (GET)
```bash
curl -X GET "https://webapp-biblioteca-api.azurewebsites.net/api/livros"
```

### 4.3. Validar Persistência no Banco

Após cada operação, verifique no SQL:

```sql
SELECT * FROM Autores;
SELECT * FROM Livros;
SELECT l.*, a.Nome as AutorNome 
FROM Livros l 
INNER JOIN Autores a ON l.AutorId = a.Id;
```

---

## Monitoramento com Application Insights

### 5.1. Acessar Application Insights

1. Acesse o [Portal Azure](https://portal.azure.com)
2. Navegue até: **appinsights-biblioteca**
3. Visualize métricas em tempo real

### 5.2. Principais Métricas a Monitorar

#### Performance
- Tempo de resposta das requisições
- Taxa de requisições por segundo
- Requisições com falha

#### Disponibilidade
- Status do serviço
- Uptime percentage

#### Logs
- Exceptions e erros
- Traces de aplicação
- Consultas SQL

### 5.3. Criar Alertas

1. Em Application Insights, vá em **Alerts**
2. Crie alertas para:
   - Taxa de erro > 5%
   - Tempo de resposta > 3 segundos
   - Disponibilidade < 99%

### 5.4. Queries Úteis (Log Analytics)

```kusto
// Requisições com erro
requests 
| where success == false
| summarize count() by resultCode, operation_Name
| order by count_ desc

// Tempo médio de resposta
requests
| summarize avg(duration) by bin(timestamp, 5m), operation_Name
| render timechart

// Top 10 operações mais lentas
requests
| top 10 by duration desc
| project timestamp, operation_Name, duration, resultCode
```

---

## Solução de Problemas

### Erro: "Cannot connect to SQL Server"

**Solução:**
1. Verifique o firewall do SQL Server:
```bash
az sql server firewall-rule create \
    --resource-group rg-biblioteca-app \
    --server sqlserver-biblioteca-app \
    --name AllowMyIP \
    --start-ip-address <SEU_IP> \
    --end-ip-address <SEU_IP>
```

### Erro: "Application Insights not sending data"

**Solução:**
1. Verifique a Connection String no Web App
2. Reinicie o Web App:
```bash
az webapp restart --name webapp-biblioteca-api --resource-group rg-biblioteca-app
```

### Erro: "500 Internal Server Error"

**Solução:**
1. Habilite logs detalhados:
```bash
az webapp log config \
    --name webapp-biblioteca-api \
    --resource-group rg-biblioteca-app \
    --detailed-error-messages true \
    --failed-request-tracing true
```

2. Visualize os logs:
```bash
az webapp log tail --name webapp-biblioteca-api --resource-group rg-biblioteca-app
```

### Erro: "Foreign Key constraint failed"

**Solução:**
1. Certifique-se de criar um Autor antes de criar um Livro
2. Verifique se o AutorId existe na tabela Autores

---

## Comandos Úteis

### Visualizar logs em tempo real
```bash
az webapp log tail --name webapp-biblioteca-api --resource-group rg-biblioteca-app
```

### Reiniciar aplicação
```bash
az webapp restart --name webapp-biblioteca-api --resource-group rg-biblioteca-app
```

### Verificar status
```bash
az webapp show --name webapp-biblioteca-api --resource-group rg-biblioteca-app --query state
```

### Deletar todos os recursos
```bash
az group delete --name rg-biblioteca-app --yes --no-wait
```

---

## Checklist de Deploy

- [ ] Azure CLI instalado e configurado
- [ ] .NET 8.0 SDK instalado
- [ ] Resource Group criado
- [ ] SQL Server e Database criados
- [ ] Firewall do SQL Server configurado
- [ ] Application Insights criado
- [ ] Web App criado
- [ ] Connection Strings configuradas
- [ ] Script DDL executado
- [ ] Tabelas criadas (Autores e Livros)
- [ ] Foreign Key configurada
- [ ] Application Insights recebendo dados
- [ ] Testes de API realizados (GET, POST, PUT, DELETE)
- [ ] Persistência validada no banco
- [ ] Logs habilitados
- [ ] Alertas configurados

---

## Suporte

Para problemas ou dúvidas:
- Documentação Azure: https://docs.microsoft.com/azure
- Documentação .NET: https://docs.microsoft.com/dotnet
- Application Insights: https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview

