# ✅ Script de Deploy Atualizado

## O que foi feito

Seu script de deploy foi adaptado do exemplo Java para funcionar com seu projeto **.NET 8.0** (Sistema Biblioteca).

---

## 📝 Principais Mudanças

### 1. Runtime
- ❌ Java: `JAVA|17-java17`
- ✅ .NET: `DOTNETCORE:8.0`

### 2. Connection String
- ❌ Java: Formato JDBC com variáveis SPRING
- ✅ .NET: Formato ADO.NET com `connection-string set`

### 3. Nomes dos Recursos
- `rg-biblioteca` (Resource Group)
- `biblioteca-dotnet-app-rm554513` (App Name e SQL Server)
- `BibliotecaDB` (Database)
- `ai-biblioteca` (Application Insights)

### 4. Região
- `brazilsouth` (mais próxima do Brasil)

---

## 📂 Arquivos Criados/Modificados

```
Scripts/
├── deploy-azure.sh          ⭐ Script principal (ATUALIZADO)
├── deploy-azure.ps1         📌 Script PowerShell (mantido)
├── INDEX.md                 📚 Índice da documentação
├── QUICK_START.md           🚀 Guia rápido (3 passos)
├── README_DEPLOY.md         📖 Documentação completa
├── COMPARATIVO.md           🔄 Java vs .NET
└── github-actions-example.yml  🤖 Exemplo de workflow
```

---

## 🎯 Como Usar

### Passo 1: Edite o repositório
```bash
nano Scripts/deploy-azure.sh
```

Mude:
```bash
export GITHUB_REPO="SEU_USUARIO/SEU_REPOSITORIO"
```

### Passo 2: Execute
```bash
cd Scripts
chmod +x deploy-azure.sh
./deploy-azure.sh
```

### Passo 3: Aguarde
O script irá criar automaticamente:
- ✅ Web App com .NET 8.0
- ✅ SQL Server + Database
- ✅ Application Insights
- ✅ GitHub Actions

---

## 🔗 URLs da Aplicação

Após o deploy:
- **App**: https://biblioteca-dotnet-app-rm554513.azurewebsites.net
- **Swagger**: https://biblioteca-dotnet-app-rm554513.azurewebsites.net/swagger

---

## 🗄️ Banco de Dados

```
Servidor: biblioteca-dotnet-app-rm554513.database.windows.net
Database: BibliotecaDB
Usuário: sqladmin
Senha: SenhaForte123!
```

**Próximo passo**: Execute o script DDL para criar as tabelas!

```bash
sqlcmd -S biblioteca-dotnet-app-rm554513.database.windows.net \
  -d BibliotecaDB -U sqladmin -P "SenhaForte123!" \
  -i Database/DDL_Script.sql
```

---

## 🤖 GitHub Actions

O script configura automaticamente o CI/CD. Qualquer push na branch `main` fará deploy automático!

```bash
git add .
git commit -m "Deploy automático"
git push origin main
```

---

## 📚 Documentação

Para mais detalhes, veja:
- **[Scripts/QUICK_START.md](Scripts/QUICK_START.md)** - Início rápido
- **[Scripts/README_DEPLOY.md](Scripts/README_DEPLOY.md)** - Documentação completa
- **[Scripts/COMPARATIVO.md](Scripts/COMPARATIVO.md)** - Java vs .NET

---

## ✅ O que Manter do Exemplo

- ✅ Estrutura do script (mesma ordem)
- ✅ Comandos Azure CLI (iguais)
- ✅ Application Insights
- ✅ GitHub Actions
- ✅ SQL Server + Database
- ✅ Firewall configuration

## 🔄 O que Mudou do Exemplo

- 🔄 Runtime: DOTNETCORE:8.0
- 🔄 Connection String: Formato .NET
- 🔄 Nomes dos recursos
- 🔄 Região: brazilsouth
- 🔄 Configuração: connection-string set

---

## 🎓 Resumo Executivo

Seu script agora:

1. ✅ **Funciona com .NET 8.0** ao invés de Java
2. ✅ **Usa connection string correto** para Entity Framework
3. ✅ **Mantém a estrutura** do exemplo fornecido
4. ✅ **Configura GitHub Actions** automaticamente
5. ✅ **Cria todos os recursos** necessários no Azure
6. ✅ **Está pronto para produção** (com ajustes de segurança)

---

## 🚨 IMPORTANTE

Antes de executar, você **DEVE** editar:

```bash
export GITHUB_REPO="SEU_USUARIO/SEU_REPOSITORIO"
```

Coloque o nome correto do seu repositório GitHub!

---

## 🎉 Pronto!

Seu script está adaptado e pronto para uso. Execute e faça deploy do seu Sistema Biblioteca no Azure! 🚀

**Quer começar?** Vá para: [Scripts/QUICK_START.md](Scripts/QUICK_START.md)
