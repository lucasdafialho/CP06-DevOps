# Sistema de Biblioteca - Azure Web App

Sistema de gerenciamento de biblioteca desenvolvido em .NET 8.0 com deploy no Microsoft Azure. Projeto desenvolvido para o CP06 da disciplina de DevOps.

## Tecnologias Utilizadas

- **.NET 8.0**: Framework principal
- **Entity Framework Core**: ORM para acesso a dados
- **SQL Server Azure**: Banco de dados PaaS
- **Application Insights**: Monitoramento e observabilidade
- **Azure App Service**: Hospedagem da aplicação
- **Swagger/OpenAPI**: Documentação da API

## Arquitetura

### Modelo de Dados (Master-Detail)

**Tabela Master: Autores**
- Id (PK)
- Nome
- Nacionalidade
- Livros (Navigation Property)

**Tabela Detail: Livros**
- Id (PK)
- Titulo
- AnoPublicacao
- AutorId (FK → Autores.Id)
- Autor (Navigation Property)

### Relacionamento
Um Autor pode ter múltiplos Livros (1:N), implementado através de Foreign Key.

## Estrutura do Projeto

```
CP04-dotNET/
├── Controllers/
│   ├── AutoresController.cs      # CRUD de Autores
│   └── LivrosController.cs       # CRUD de Livros
├── Models/
│   ├── Autor.cs                  # Entidade Autor
│   └── Livro.cs                  # Entidade Livro
├── Data/
│   └── BibliotecaDbContext.cs    # Contexto EF Core
├── Database/
│   └── DDL_Script.sql            # Script de criação das tabelas
├── Scripts/
│   ├── deploy-azure.sh           # Script deploy Linux/Mac
│   └── deploy-azure.ps1          # Script deploy Windows
├── HOWTO_DEPLOY.md               # Guia completo de implantação
├── API_Operations.json           # JSON das operações da API
├── ROTEIRO_VIDEO.md              # Roteiro para vídeo
└── README.md                     # Este arquivo
```

## Funcionalidades

### API REST - Autores
- **GET** `/api/autores` - Lista todos os autores
- **GET** `/api/autores/{id}` - Busca autor por ID
- **POST** `/api/autores` - Cria novo autor
- **PUT** `/api/autores/{id}` - Atualiza autor
- **DELETE** `/api/autores/{id}` - Deleta autor

### API REST - Livros
- **GET** `/api/livros` - Lista todos os livros
- **GET** `/api/livros/{id}` - Busca livro por ID
- **POST** `/api/livros` - Cria novo livro
- **PUT** `/api/livros/{id}` - Atualiza livro
- **DELETE** `/api/livros/{id}` - Deleta livro

## Deploy no Azure

### Opção 1: Script Automatizado (Recomendado)

**Linux/Mac:**
```bash
cd Scripts
chmod +x deploy-azure.sh
./deploy-azure.sh
```

**Windows (PowerShell):**
```powershell
cd Scripts
.\deploy-azure.ps1
```

### Opção 2: Passo a Passo Manual

Consulte o arquivo [HOWTO_DEPLOY.md](HOWTO_DEPLOY.md) para instruções detalhadas.

## Configuração Local

### Pré-requisitos
- .NET 8.0 SDK
- SQL Server (local ou Azure)

### Passos

1. Clone o repositório
```bash
git clone [URL_DO_REPOSITORIO]
cd CP04-dotNET
```

2. Configure a Connection String em `appsettings.json`
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "SUA_CONNECTION_STRING"
  }
}
```

3. Execute as migrations (ou execute o DDL_Script.sql)
```bash
dotnet ef database update
```

4. Execute a aplicação
```bash
dotnet run
```

5. Acesse o Swagger
```
https://localhost:7000/swagger
```

## Monitoramento

A aplicação está integrada com **Azure Application Insights** para:
- Rastreamento de requisições
- Monitoramento de performance
- Detecção de erros e exceções
- Métricas em tempo real
- Análise de dependências (SQL)

### Acessar Métricas
1. Portal Azure → Application Insights
2. Visualizar dashboards de performance
3. Analisar logs e traces
4. Configurar alertas

## Validação da Persistência

Após cada operação da API, valide a persistência executando queries SQL:

```sql
-- Listar autores
SELECT * FROM Autores;

-- Listar livros com autores
SELECT l.*, a.Nome as AutorNome 
FROM Livros l 
INNER JOIN Autores a ON l.AutorId = a.Id;

-- Contar livros por autor
SELECT a.Nome, COUNT(l.Id) as TotalLivros 
FROM Autores a 
LEFT JOIN Livros l ON a.Id = l.AutorId 
GROUP BY a.Id, a.Nome;
```

## Documentação Adicional

- **[HOWTO_DEPLOY.md](HOWTO_DEPLOY.md)**: Guia completo de implantação no Azure
- **[API_Operations.json](API_Operations.json)**: Detalhes de todas as operações da API
- **[ROTEIRO_VIDEO.md](ROTEIRO_VIDEO.md)**: Roteiro para gravação do vídeo de demonstração
- **[DDL_Script.sql](Database/DDL_Script.sql)**: Script de criação do banco de dados

## Recursos Azure Criados

Após o deploy, os seguintes recursos são criados:
- **Resource Group**: rg-biblioteca-app
- **SQL Server**: sqlserver-biblioteca-app
- **SQL Database**: BibliotecaDB (Tier S0)
- **App Service Plan**: plan-biblioteca-app (B1)
- **Web App**: webapp-biblioteca-api
- **Application Insights**: appinsights-biblioteca

## Segurança

- Connection Strings armazenadas em Application Settings (Azure)
- Firewall do SQL Server configurado
- Conexões SQL criptografadas (Encrypt=True)
- Senhas não versionadas no código

## Testes

### Sequência Recomendada
1. POST Autor 1 → Validar no banco
2. POST Autor 2 → Validar no banco
3. GET Autores → Verificar lista
4. POST Livro 1 (FK Autor 1) → Validar com JOIN
5. POST Livro 2 (FK Autor 1) → Validar com JOIN
6. POST Livro 3 (FK Autor 2) → Validar com JOIN
7. GET Livros → Verificar lista
8. PUT Livro 1 → Validar atualização
9. DELETE Livro 1 → Validar remoção
10. Verificar Application Insights

## Solução de Problemas

### Erro de Conexão com SQL Server
Verifique as regras de firewall e a Connection String.

### Aplicação não inicia
Verifique os logs:
```bash
az webapp log tail --name webapp-biblioteca-api --resource-group rg-biblioteca-app
```

### Application Insights não mostra dados
Verifique a Connection String e reinicie o Web App.

## Requisitos Atendidos

- ✅ Aplicação Web em .NET 8.0
- ✅ Deploy no Azure App Service
- ✅ Banco SQL Server PaaS
- ✅ Duas tabelas relacionadas (Master-Detail)
- ✅ Foreign Key (Livros → Autores)
- ✅ Application Insights configurado
- ✅ Scripts Azure CLI
- ✅ DDL das tabelas
- ✅ How to de implantação
- ✅ JSON das operações (GET, POST, PUT, DELETE)
- ✅ Roteiro para vídeo

## Licença

Projeto acadêmico desenvolvido para a disciplina de DevOps - FIAP

## Autores

Grupo: [NOME_DO_GRUPO]
- [RM - Nome do Integrante 1]
- [RM - Nome do Integrante 2]
- [RM - Nome do Integrante 3]

