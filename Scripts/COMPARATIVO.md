# 📊 Comparativo: Script Java vs Script .NET

## Visão Geral

Este documento mostra as diferenças entre o script de exemplo (Java) e o script adaptado (.NET) para o Sistema Biblioteca.

---

## 🔄 Mudanças nas Variáveis

| Variável | Java (Exemplo) | .NET (Biblioteca) | Motivo |
|----------|----------------|-------------------|--------|
| `RESOURCE_GROUP` | `rg-osmaismais` | `rg-biblioteca` | Nome do projeto |
| `APP_NAME` | `osmaismais-java-app-rm554513` | `biblioteca-dotnet-app-rm554513` | Linguagem e projeto |
| `APP_RUNTIME` | `JAVA\|17-java17` | `DOTNETCORE:8.0` | ⚠️ **Runtime da linguagem** |
| `APP_INSIGHTS` | `ai-sprint3` | `ai-biblioteca` | Nome do projeto |
| `GITHUB_REPO` | `omininola/cp5_cloud_java_project` | `SEU_USUARIO/SEU_REPOSITORIO` | Seu repositório |
| `DB_SERVER_NAME` | `osmaismais-java-app-rm554513` | `biblioteca-dotnet-app-rm554513` | Nome do projeto |
| `DB_NAME` | `osmaismais` | `BibliotecaDB` | Nome do banco |
| `DB_USER` | `omininola` | `sqladmin` | Usuário admin |
| `LOCATION` | `westus` | `brazilsouth` | Região mais próxima |

---

## 🔧 Mudanças Técnicas Importantes

### 1. Runtime / Stack

**Java:**
```bash
export APP_RUNTIME="JAVA|17-java17"
```

**.NET:**
```bash
export APP_RUNTIME="DOTNETCORE:8.0"
```

### 2. Connection String Format

**Java (JDBC):**
```bash
SPRING_DATASOURCE_URL="jdbc:sqlserver://servidor:1433;database=db;..."
SPRING_DATASOURCE_USERNAME="usuario@servidor"
SPRING_DATASOURCE_PASSWORD="senha"
```

**.NET (ADO.NET/Entity Framework):**
```bash
az webapp config connection-string set \
  --settings DefaultConnection="Server=tcp:servidor,1433;Initial Catalog=db;User ID=usuario;Password=senha;..." \
  --connection-string-type SQLAzure
```

---

## 🎯 O que NÃO mudou

- ✅ Infraestrutura Azure (mesmos recursos)
- ✅ SQL Server e Database
- ✅ Application Insights
- ✅ GitHub Actions
- ✅ Firewall e segurança

---

## 🚨 Principal Diferença

### Java usa variáveis de ambiente:
```bash
SPRING_DATASOURCE_URL
SPRING_DATASOURCE_USERNAME  
SPRING_DATASOURCE_PASSWORD
```

### .NET usa Connection String:
```bash
az webapp config connection-string set --settings DefaultConnection="..."
```

---

## ✅ Resumo

Se você está adaptando de Java para .NET:

1. Mude `APP_RUNTIME` para `DOTNETCORE:8.0`
2. Use `connection-string set` ao invés de variáveis SPRING
3. Formato da connection string é diferente (ADO.NET vs JDBC)
4. Resto é igual!
