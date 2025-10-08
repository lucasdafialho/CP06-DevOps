# 📚 Documentação de Deploy - Sistema Biblioteca

## 🎯 Início Rápido

👉 **Comece aqui**: [QUICK_START.md](QUICK_START.md)

---

## 📖 Documentação Completa

### 1. Para Começar
- **[QUICK_START.md](QUICK_START.md)** - Guia rápido em 3 passos

### 2. Documentação Detalhada
- **[README_DEPLOY.md](README_DEPLOY.md)** - Documentação completa do deploy

### 3. Entendendo as Mudanças
- **[COMPARATIVO.md](COMPARATIVO.md)** - Java vs .NET: o que mudou?

### 4. GitHub Actions
- **[github-actions-example.yml](github-actions-example.yml)** - Exemplo do workflow

---

## 🚀 Scripts Disponíveis

### deploy-azure.sh
Script principal de deploy (Linux/Mac/WSL)
```bash
chmod +x deploy-azure.sh
./deploy-azure.sh
```

### deploy-azure.ps1
Script de deploy para PowerShell (Windows)
```powershell
.\deploy-azure.ps1
```

---

## ⚙️ Configurações do Projeto

| Configuração | Valor |
|--------------|-------|
| **Linguagem** | .NET 8.0 (C#) |
| **Runtime** | DOTNETCORE:8.0 |
| **Região** | Brazil South |
| **Resource Group** | rg-biblioteca |
| **App Name** | biblioteca-dotnet-app-rm554513 |
| **Database** | BibliotecaDB |
| **SQL Server** | biblioteca-dotnet-app-rm554513 |

---

## 🔑 Credenciais

```
Servidor: biblioteca-dotnet-app-rm554513.database.windows.net
Banco: BibliotecaDB
Usuário: sqladmin
Senha: SenhaForte123!
```

---

## 🌐 URLs da Aplicação

Após o deploy:
- **App**: https://biblioteca-dotnet-app-rm554513.azurewebsites.net
- **Swagger**: https://biblioteca-dotnet-app-rm554513.azurewebsites.net/swagger
- **API**: https://biblioteca-dotnet-app-rm554513.azurewebsites.net/api/

---

## 📋 Checklist de Deploy

- [ ] Editar `GITHUB_REPO` no script
- [ ] Executar `./deploy-azure.sh`
- [ ] Aguardar conclusão do script
- [ ] Executar DDL no banco de dados
- [ ] Fazer push no GitHub para testar CI/CD
- [ ] Acessar a aplicação no navegador
- [ ] Testar os endpoints da API

---

## 🆘 Suporte

### Problemas Comuns

1. **App name já existe**: Mude `APP_NAME` e `DB_SERVER_NAME`
2. **GitHub Actions falha**: Execute `az login` novamente
3. **SQL não conecta**: Verifique firewall rules

### Links Úteis

- [Azure CLI Docs](https://docs.microsoft.com/cli/azure/)
- [ASP.NET Core no Azure](https://docs.microsoft.com/aspnet/core/host-and-deploy/azure-apps/)
- [Entity Framework Core](https://docs.microsoft.com/ef/core/)

---

## 📝 Notas

### Diferenças do Exemplo Java

✅ Runtime: `DOTNETCORE:8.0` (ao invés de `JAVA|17-java17`)  
✅ Connection String: Formato ADO.NET (ao invés de JDBC)  
✅ Configuração: Connection String do Azure (ao invés de variáveis SPRING)  
✅ Deploy: GitHub Actions para .NET  

### O que é Igual

✅ Estrutura de recursos Azure  
✅ Application Insights  
✅ SQL Server e Database  
✅ GitHub Actions automático  
✅ Firewall e segurança  

---

## 🎓 Para Estudantes

Este script foi adaptado do exemplo Java fornecido. As principais mudanças foram:

1. **Runtime** de Java para .NET
2. **Connection String** de JDBC para ADO.NET
3. **Nomes** dos recursos (projeto Biblioteca)
4. **Região** para Brazil South

Todo o resto permanece igual, pois a infraestrutura Azure é a mesma!

---

## ✨ Recursos Criados

Ao executar o script, serão criados:

- ✅ Resource Group
- ✅ App Service Plan (Linux B1)
- ✅ Web App (.NET 8.0)
- ✅ SQL Server
- ✅ SQL Database (BibliotecaDB)
- ✅ Application Insights
- ✅ Firewall Rules
- ✅ GitHub Actions Workflow

---

**Pronto para começar? Vá para [QUICK_START.md](QUICK_START.md)!** 🚀
