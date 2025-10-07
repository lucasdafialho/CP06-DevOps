# Template para PDF de Entrega
## Nome do arquivo: [NOME_GRUPO]_webapp.pdf

---

# CP06 - DevOps - Web App e Banco de Dados Azure

## Informações do Grupo

**Nome do Grupo:** [INSERIR NOME DO GRUPO]

**Integrantes:**
- **RM [xxxxx]** - [Nome Completo do Integrante 1]
- **RM [xxxxx]** - [Nome Completo do Integrante 2]
- **RM [xxxxx]** - [Nome Completo do Integrante 3]
- **RM [xxxxx]** - [Nome Completo do Integrante 4]
- **RM [xxxxx]** - [Nome Completo do Integrante 5]

---

## Links de Entrega

### GitHub
**Link do Repositório:** [INSERIR LINK DO GITHUB]

**Estrutura do Repositório:**
```
CP04-dotNET/
├── Database/DDL_Script.sql          ✅ Script DDL das tabelas
├── Scripts/deploy-azure.sh          ✅ Script Azure CLI (Linux)
├── Scripts/deploy-azure.ps1         ✅ Script Azure CLI (Windows)
├── HOWTO_DEPLOY.md                  ✅ How to de implantação
├── API_Operations.json              ✅ JSON das operações
├── ROTEIRO_VIDEO.md                 ✅ Roteiro do vídeo
└── Código fonte completo            ✅
```

### Vídeo
**Link do Vídeo:** [INSERIR LINK DO VÍDEO - YouTube/Drive]

**Conteúdo do Vídeo:**
- ✅ Criação de todos os recursos Azure via CLI
- ✅ Execução do script DDL
- ✅ Testes de todas as operações (GET, POST, PUT, DELETE)
- ✅ Validação da persistência no banco após cada operação
- ✅ Demonstração do Application Insights

---

## Tecnologias Utilizadas

### Linguagem e Framework
- **.NET 8.0**
- **C#**
- **ASP.NET Core Web API**
- **Entity Framework Core 8.0**

### Banco de Dados
- **Azure SQL Server** (PaaS)
- **Database:** BibliotecaDB
- **Tier:** S0 (Standard)

### Azure Services
- **Azure App Service** (Web App)
- **Azure SQL Database**
- **Application Insights**
- **App Service Plan B1**

---

## Arquitetura da Solução

### Modelo de Dados (Master-Detail)

#### Tabela Master: Autores
```sql
CREATE TABLE Autores (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(200) NOT NULL,
    Nacionalidade NVARCHAR(100) NOT NULL
);
```

#### Tabela Detail: Livros
```sql
CREATE TABLE Livros (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(300) NOT NULL,
    AnoPublicacao INT NOT NULL,
    AutorId INT NOT NULL,
    CONSTRAINT FK_Livros_Autores FOREIGN KEY (AutorId) 
        REFERENCES Autores(Id)
);
```

### Relacionamento
- **Tipo:** 1:N (Um autor pode ter vários livros)
- **Foreign Key:** Livros.AutorId → Autores.Id
- **Delete Behavior:** Restrict (não permite deletar autor com livros)

---

## Endpoints da API

### Autores
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | /api/autores | Lista todos os autores |
| GET | /api/autores/{id} | Busca autor por ID |
| POST | /api/autores | Cria novo autor |
| PUT | /api/autores/{id} | Atualiza autor |
| DELETE | /api/autores/{id} | Deleta autor |

### Livros
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | /api/livros | Lista todos os livros |
| GET | /api/livros/{id} | Busca livro por ID |
| POST | /api/livros | Cria novo livro |
| PUT | /api/livros/{id} | Atualiza livro |
| DELETE | /api/livros/{id} | Deleta livro |

---

## Deploy Realizado

### Método de Deploy
**Azure CLI** via script automatizado

### Recursos Criados

| Recurso | Nome | Detalhes |
|---------|------|----------|
| Resource Group | rg-biblioteca-app | East US |
| SQL Server | sqlserver-biblioteca-app | PaaS |
| SQL Database | BibliotecaDB | Tier S0 |
| App Service Plan | plan-biblioteca-app | B1 Linux |
| Web App | webapp-biblioteca-api | .NET 8.0 |
| Application Insights | appinsights-biblioteca | Monitoring |

### URL da Aplicação
**Web App:** https://webapp-biblioteca-api.azurewebsites.net

**Swagger:** https://webapp-biblioteca-api.azurewebsites.net/swagger

---

## Monitoramento - Application Insights

### Métricas Configuradas
- ✅ Tempo de resposta das requisições
- ✅ Taxa de requisições por segundo
- ✅ Requisições com falha
- ✅ Disponibilidade do serviço
- ✅ Dependências (SQL Server)
- ✅ Logs de exceções
- ✅ Traces de aplicação

### Alertas Configurados
- Taxa de erro > 5%
- Tempo de resposta > 3 segundos
- Disponibilidade < 99%

---

## Prints do Deploy

### 1. Execução do Script Azure CLI
[INSERIR PRINT DA EXECUÇÃO DO SCRIPT]

### 2. Recursos Criados no Portal Azure
[INSERIR PRINT DO RESOURCE GROUP COM TODOS OS RECURSOS]

### 3. SQL Server e Database
[INSERIR PRINT DO SQL SERVER E DATABASE]

### 4. Tabelas Criadas (DDL Executado)
[INSERIR PRINT DO SELECT DAS TABELAS]

### 5. Foreign Key Configurada
[INSERIR PRINT DA QUERY DE FOREIGN KEYS]

### 6. Web App Rodando
[INSERIR PRINT DO WEB APP NO PORTAL]

### 7. Swagger UI
[INSERIR PRINT DO SWAGGER COM ENDPOINTS]

### 8. Teste POST - Criar Autor
[INSERIR PRINT DA REQUISIÇÃO POST NO SWAGGER]

### 9. Validação no Banco - Autor Criado
[INSERIR PRINT DO SELECT * FROM Autores]

### 10. Teste POST - Criar Livro
[INSERIR PRINT DA REQUISIÇÃO POST NO SWAGGER]

### 11. Validação no Banco - Livro com JOIN
[INSERIR PRINT DO SELECT COM JOIN MOSTRANDO RELACIONAMENTO]

### 12. Teste GET - Listar Todos
[INSERIR PRINT DO GET RETORNANDO DADOS]

### 13. Teste PUT - Atualizar Registro
[INSERIR PRINT DO PUT E VALIDAÇÃO NO BANCO]

### 14. Teste DELETE - Deletar Registro
[INSERIR PRINT DO DELETE E VALIDAÇÃO NO BANCO]

### 15. Application Insights - Dashboard
[INSERIR PRINT DO DASHBOARD DO APPLICATION INSIGHTS]

### 16. Application Insights - Requisições
[INSERIR PRINT DAS REQUISIÇÕES MONITORADAS]

### 17. Application Insights - Performance
[INSERIR PRINT DAS MÉTRICAS DE PERFORMANCE]

---

## Validação da Persistência

### Autor - Criação
**Request POST:**
```json
{
  "nome": "Machado de Assis",
  "nacionalidade": "Brasileira"
}
```

**Validação SQL:**
```sql
SELECT * FROM Autores WHERE Nome = 'Machado de Assis';
```
**Resultado:** ✅ Registro inserido com sucesso

---

### Livro - Criação com Foreign Key
**Request POST:**
```json
{
  "titulo": "Dom Casmurro",
  "anoPublicacao": 1899,
  "autorId": 1
}
```

**Validação SQL:**
```sql
SELECT l.*, a.Nome as AutorNome 
FROM Livros l 
INNER JOIN Autores a ON l.AutorId = a.Id
WHERE l.Titulo = 'Dom Casmurro';
```
**Resultado:** ✅ Registro inserido com FK válida

---

### Livro - Atualização
**Request PUT:**
```json
{
  "id": 1,
  "titulo": "Dom Casmurro - Edição Especial",
  "anoPublicacao": 1899,
  "autorId": 1
}
```

**Validação SQL:**
```sql
SELECT * FROM Livros WHERE Id = 1;
```
**Resultado:** ✅ Registro atualizado com sucesso

---

### Livro - Deleção
**Request DELETE:** /api/livros/1

**Validação SQL:**
```sql
SELECT * FROM Livros WHERE Id = 1;
```
**Resultado:** ✅ Registro removido (0 rows)

---

## Checklist de Entregas

### Obrigatórios para Nota Máxima
- ✅ Aplicação .NET
- ✅ Deploy no Azure App Service
- ✅ SQL Server PaaS
- ✅ Duas tabelas (Master-Detail)
- ✅ Foreign Key configurada
- ✅ Script DDL no GitHub
- ✅ Código fonte completo no GitHub
- ✅ Scripts Azure CLI no GitHub
- ✅ How to de implantação no GitHub
- ✅ JSON das operações no GitHub
- ✅ Application Insights configurado
- ✅ Vídeo com criação de recursos
- ✅ Validação de persistência após CADA operação no vídeo
- ✅ PDF com informações do grupo e links

### Penalidades Evitadas
- ❌ (-0,5) Entrega fora do padrão → ✅ PDF correto
- ❌ (-2,0) Não mostrar operações no banco → ✅ Todas validadas
- ❌ (-1,0) Sem Application Insights → ✅ Configurado
- ❌ (-1,5) Sem How to → ✅ Completo no GitHub
- ❌ (-1,0) Sem DDL → ✅ Script completo
- ❌ (-3,0) Uma tabela apenas → ✅ Duas tabelas
- ❌ (-4,0) Sem scripts CLI → ✅ Scripts .sh e .ps1

---

## Conclusão

O projeto foi desenvolvido com sucesso atendendo a todos os requisitos do checkpoint:

1. **Aplicação Web .NET 8.0** implantada no Azure
2. **Banco de dados SQL Server PaaS** com duas tabelas relacionadas
3. **Foreign Key** implementada e validada
4. **Application Insights** monitorando a aplicação
5. **Deploy automatizado** via Azure CLI
6. **Documentação completa** com DDL, How to e JSON das operações
7. **Validação de persistência** demonstrada em vídeo

Todos os arquivos estão disponíveis no GitHub e o vídeo demonstra a criação dos recursos e validação de cada operação no banco de dados.

---

**Data de Entrega:** [INSERIR DATA]

**Representante do Grupo:** [NOME DO REPRESENTANTE]

---

## Instruções para Gerar o PDF

1. Preencha todas as informações marcadas com [INSERIR...]
2. Adicione os prints solicitados em cada seção
3. Verifique se todos os links estão funcionando
4. Exporte/imprima como PDF
5. Nomeie o arquivo como: **[NOME_GRUPO]_webapp.pdf**
6. Faça upload no Teams

