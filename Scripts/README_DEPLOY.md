# Script de Deploy Azure - Sistema Biblioteca (.NET 8.0)

## 📋 Descrição

Script bash adaptado para fazer deploy automático da aplicação **Sistema Biblioteca** no Azure, seguindo o padrão do exemplo Java fornecido.

## 🔧 O que foi adaptado do exemplo Java

### Mudanças principais:

1. **Runtime**: Alterado de `JAVA|17-java17` para `DOTNETCORE:8.0`
2. **Nome da aplicação**: `biblioteca-dotnet-app-rm554513` (ao invés de Java)
3. **Resource Group**: `rg-biblioteca` 
4. **Banco de Dados**: `BibliotecaDB` (ao invés de osmaismais)
5. **Connection String**: Formato SQL Server para .NET (ao invés de JDBC)
6. **Application Insights**: Configurado para ASP.NET Core

### O que mantém do exemplo:

- ✅ Registro de Resource Providers
- ✅ Criação de Application Insights
- ✅ Configuração de GitHub Actions
- ✅ SQL Server com firewall configurado
- ✅ App Service com runtime adequado
- ✅ Connection Strings e App Settings
- ✅ Integração completa com monitoramento

## ⚙️ Configurações

### Variáveis que você DEVE alterar:

```bash
export GITHUB_REPO="SEU_USUARIO/SEU_REPOSITORIO"  # ⚠️ OBRIGATÓRIO
export BRANCH="main"                               # Ou sua branch principal
```

### Variáveis opcionais (já configuradas):

```bash
export RESOURCE_GROUP="rg-biblioteca"
export LOCATION="brazilsouth"
export APP_NAME="biblioteca-dotnet-app-rm554513"
export APP_RUNTIME="DOTNETCORE:8.0"
export APP_INSIGHTS="ai-biblioteca"
export DB_SERVER_NAME="biblioteca-dotnet-app-rm554513"
export DB_NAME="BibliotecaDB"
export DB_USER="sqladmin"
export DB_PASS="SenhaForte123!"
```

## 🚀 Como usar

### 1. Pré-requisitos

- Azure CLI instalado e configurado (`az login`)
- Conta GitHub com acesso ao repositório
- Permissões para criar recursos no Azure

### 2. Editar o script

Abra o arquivo e altere a variável `GITHUB_REPO`:

```bash
nano Scripts/deploy-azure.sh
```

Mude esta linha:
```bash
export GITHUB_REPO="SEU_USUARIO/SEU_REPOSITORIO"
```

Para algo como:
```bash
export GITHUB_REPO="seunome/CP06-DevOps"
```

### 3. Executar o script

```bash
cd Scripts
chmod +x deploy-azure.sh
./deploy-azure.sh
```

## 📦 O que o script faz

1. **Registra Resource Providers** no Azure
2. **Cria Resource Group** na região Brazil South
3. **Cria Application Insights** para monitoramento
4. **Cria App Service Plan** (SKU B1, Linux)
5. **Cria Web App** com runtime .NET 8.0
6. **Cria SQL Server** com banco BibliotecaDB
7. **Configura Firewall** do SQL (permite todos os IPs)
8. **Configura Connection Strings** para o banco
9. **Configura Application Insights** no Web App
10. **Configura GitHub Actions** para CI/CD automático

## 🔗 Recursos Criados

Após executar o script, você terá:

| Recurso | Nome | URL/Endpoint |
|---------|------|--------------|
| Resource Group | `rg-biblioteca` | - |
| Web App | `biblioteca-dotnet-app-rm554513` | `https://biblioteca-dotnet-app-rm554513.azurewebsites.net` |
| SQL Server | `biblioteca-dotnet-app-rm554513` | `biblioteca-dotnet-app-rm554513.database.windows.net` |
| Database | `BibliotecaDB` | - |
| Application Insights | `ai-biblioteca` | - |
| App Service Plan | `biblioteca-dotnet-app-rm554513-plan` | - |

## 🔐 Credenciais do Banco de Dados

```
Servidor: biblioteca-dotnet-app-rm554513.database.windows.net
Banco: BibliotecaDB
Usuário: sqladmin
Senha: SenhaForte123!
```

**Connection String:**
```
Server=tcp:biblioteca-dotnet-app-rm554513.database.windows.net,1433;Initial Catalog=BibliotecaDB;Persist Security Info=False;User ID=sqladmin;Password=SenhaForte123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
```

## 🤖 GitHub Actions

O script configura automaticamente o GitHub Actions para fazer deploy contínuo. Quando você fizer push para a branch `main`, o GitHub Actions irá:

1. Compilar a aplicação .NET
2. Fazer deploy no Azure App Service
3. Aplicar as configurações automaticamente

O arquivo de workflow será criado automaticamente em: `.github/workflows/`

## 📊 Application Insights

O monitoramento está configurado com:

- **Connection String**: Configurada automaticamente
- **Version**: ~3 (mais recente)
- **Mode**: Recommended
- **Tipo**: Web Application

Acesse o Azure Portal para visualizar:
- Requisições HTTP
- Performance da aplicação
- Erros e exceções
- Dependências (SQL)

## 🗄️ Próximos Passos

Após executar o script:

1. **Execute o script DDL** para criar as tabelas:
   ```bash
   sqlcmd -S biblioteca-dotnet-app-rm554513.database.windows.net \
     -d BibliotecaDB -U sqladmin -P "SenhaForte123!" \
     -i Database/DDL_Script.sql
   ```

2. **Faça push no GitHub** para testar o CI/CD:
   ```bash
   git add .
   git commit -m "Deploy automático configurado"
   git push origin main
   ```

3. **Teste a aplicação**:
   - Swagger: `https://biblioteca-dotnet-app-rm554513.azurewebsites.net/swagger`
   - API: `https://biblioteca-dotnet-app-rm554513.azurewebsites.net/api/autores`

## ⚠️ Observações Importantes

### Diferenças do Java para .NET:

| Aspecto | Java | .NET |
|---------|------|------|
| Runtime | `JAVA\|17-java17` | `DOTNETCORE:8.0` |
| Connection String | JDBC format | SQL Server format |
| Variável de ambiente | `SPRING_DATASOURCE_*` | Connection Strings |
| Build | Maven/Gradle | dotnet publish |

### Segurança:

⚠️ **IMPORTANTE**: Este script está configurado para desenvolvimento/testes:
- Firewall SQL Server aceita TODOS os IPs (0.0.0.0-255.255.255.255)
- Senha em texto plano no script

Para produção:
- Use Azure Key Vault para senhas
- Restrinja o firewall aos IPs necessários
- Use Managed Identity quando possível

## 🐛 Troubleshooting

### Erro: "GitHub login required"
Execute `az login` novamente com `--login-with-github`

### Erro: "SQL Server name already exists"
Altere a variável `DB_SERVER_NAME` para um nome único

### Erro: "App name already exists"
Altere a variável `APP_NAME` para um nome único

### Deploy do GitHub Actions falha
Verifique se as credenciais foram configuradas corretamente no repositório

## 📚 Referências

- [Azure CLI Documentation](https://docs.microsoft.com/cli/azure/)
- [ASP.NET Core no Azure](https://docs.microsoft.com/aspnet/core/host-and-deploy/azure-apps/)
- [Application Insights para .NET](https://docs.microsoft.com/azure/azure-monitor/app/asp-net-core)
- [GitHub Actions para Azure](https://docs.microsoft.com/azure/app-service/deploy-github-actions)
