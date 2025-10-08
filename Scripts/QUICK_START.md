# 🚀 Quick Start - Deploy Azure

## Em 3 passos simples:

### 1️⃣ Edite o repositório GitHub

Abra `Scripts/deploy-azure.sh` e mude:

```bash
export GITHUB_REPO="SEU_USUARIO/SEU_REPOSITORIO"  # ⚠️ Coloque seu repo aqui!
```

Exemplo:
```bash
export GITHUB_REPO="joaosilva/biblioteca-dotnet"
```

### 2️⃣ Execute o script

```bash
cd Scripts
chmod +x deploy-azure.sh
./deploy-azure.sh
```

### 3️⃣ Aguarde e acesse

Quando terminar, acesse:
- 🌐 **App**: https://biblioteca-dotnet-app-rm554513.azurewebsites.net
- 📖 **Swagger**: https://biblioteca-dotnet-app-rm554513.azurewebsites.net/swagger

---

## ⚡ O que foi criado?

| Item | Valor |
|------|-------|
| Web App | biblioteca-dotnet-app-rm554513 |
| SQL Server | biblioteca-dotnet-app-rm554513.database.windows.net |
| Database | BibliotecaDB |
| Usuário | sqladmin |
| Senha | SenhaForte123! |

---

## 🎯 Próximo passo: Execute o DDL

Crie as tabelas no banco:

```bash
sqlcmd -S biblioteca-dotnet-app-rm554513.database.windows.net \
  -d BibliotecaDB \
  -U sqladmin \
  -P "SenhaForte123!" \
  -i Database/DDL_Script.sql
```

---

## 🔄 Deploy Automático

Agora qualquer push no GitHub fará deploy automático!

```bash
git add .
git commit -m "Minha mudança"
git push origin main
```

O GitHub Actions irá:
1. Compilar seu código .NET
2. Fazer deploy no Azure
3. Reiniciar a aplicação

---

## 📚 Quer entender melhor?

Leia os arquivos:
- `README_DEPLOY.md` - Documentação completa
- `COMPARATIVO.md` - Diferenças Java vs .NET
- `github-actions-example.yml` - Exemplo do workflow

---

## 🆘 Problemas?

### App name já existe?
Mude no script:
```bash
export APP_NAME="biblioteca-dotnet-app-SEU-RM"
export DB_SERVER_NAME="biblioteca-dotnet-app-SEU-RM"
```

### GitHub Actions não funciona?
Verifique se você executou `az login` com GitHub:
```bash
az login
```

### SQL não conecta?
Verifique o firewall:
```bash
az sql server firewall-rule create \
  --resource-group rg-biblioteca \
  --server biblioteca-dotnet-app-rm554513 \
  --name MeuIP \
  --start-ip-address SEU-IP \
  --end-ip-address SEU-IP
```

---

## 🎉 Pronto!

Seu Sistema Biblioteca está no Azure com:
- ✅ Deploy automático via GitHub Actions
- ✅ Monitoramento com Application Insights
- ✅ Banco SQL Database configurado
- ✅ Runtime .NET 8.0
- ✅ HTTPS habilitado
- ✅ Logs e diagnósticos ativos
