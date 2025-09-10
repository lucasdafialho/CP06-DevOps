# Sistema de Gerenciamento de Biblioteca

[![.NET](https://img.shields.io/badge/.NET-8.0-blue.svg)](https://dotnet.microsoft.com/download)
[![MongoDB](https://img.shields.io/badge/MongoDB-6.0-green.svg)](https://www.mongodb.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Uma aplicação web moderna e robusta desenvolvida em ASP.NET Core MVC para gerenciamento completo de bibliotecas, utilizando MongoDB como banco de dados NoSQL e implementando arquitetura de microserviços com documentação automática via Swagger.

 ## Equipe de Desenvolvimento

- **Julia Monteiro** - RM 557023
- **Lucas de Assis Fialho** - RM 557884
- **Samuel Patrick Yariwake** - RM 556461

## Características Principais

- **Arquitetura Moderna**: Desenvolvido com ASP.NET Core 8 e padrões de desenvolvimento limpo
- **Banco NoSQL**: Integração completa com MongoDB para alta performance e escalabilidade
- **API RESTful**: Endpoints bem estruturados seguindo as melhores práticas REST
- **Documentação Automática**: Swagger integrado para documentação interativa da API
- **Embedding de Documentos**: Modelagem otimizada com dados aninhados para melhor performance
- **Tratamento de Erros**: Sistema robusto de tratamento de exceções e validações
- **Código Limpo**: Implementação seguindo princípios SOLID e Clean Code

## Stack Tecnológica

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| **.NET** | 8.0 | Framework principal da aplicação |
| **ASP.NET Core** | 8.0 | Framework web para APIs RESTful |
| **MongoDB** | 6.0+ | Banco de dados NoSQL |
| **MongoDB.Driver** | 2.22.0 | Driver oficial para .NET |
| **Swashbuckle** | 6.5.0 | Geração automática de documentação Swagger |

## Estrutura do Projeto

```
SistemaBiblioteca/
├── Controllers/
│   └── LivrosController.cs          # API Controller com operações CRUD
├── Models/
│   ├── Livro.cs                     # Modelo principal com mapeamento BSON
│   └── Autor.cs                     # Modelo aninhado para embedding
├── Services/
│   ├── IMongoDbService.cs           # Interface do serviço MongoDB
│   └── MongoDbService.cs            # Implementação do serviço
├── Properties/
│   └── launchSettings.json          # Configurações de execução
├── appsettings.json                 # Configurações da aplicação
├── appsettings.Development.json     # Configurações de desenvolvimento
├── Program.cs                       # Ponto de entrada da aplicação
├── SistemaBiblioteca.csproj         # Arquivo de projeto
└── README.md                        # Documentação do projeto
```

## Arquitetura

### Modelo de Dados

O sistema utiliza a técnica de **embedding de documentos** do MongoDB, onde as informações do autor são armazenadas diretamente no documento do livro, otimizando consultas e melhorando a performance.

```json
{
  "_id": "ObjectId",
  "Titulo": "Nome do Livro",
  "AnoPublicacao": 2024,
  "Autor": {
    "Nome": "Nome do Autor",
    "Nacionalidade": "Brasil"
  }
}
```

### Padrões Implementados

- **Repository Pattern**: Abstração da camada de dados
- **Dependency Injection**: Injeção de dependências nativa do .NET
- **Interface Segregation**: Separação clara de responsabilidades
- **Single Responsibility**: Cada classe tem uma responsabilidade específica

## Configuração e Instalação

### Pré-requisitos

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [MongoDB](https://www.mongodb.com/try/download/community) (versão 6.0 ou superior)
- [Visual Studio 2022](https://visualstudio.microsoft.com/) ou [VS Code](https://code.visualstudio.com/)

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/sistema-biblioteca.git
   cd sistema-biblioteca
   ```

2. **Instale as dependências**
   ```bash
   dotnet restore
   ```

3. **Configure o MongoDB**
   - Instale e inicie o MongoDB
   - A connection string padrão é: `mongodb://localhost:27017`
   - O banco será criado automaticamente: `SistemaBiblioteca`
   - A coleção será criada automaticamente: `Livros`

4. **Configure as variáveis de ambiente** (opcional)
   ```json
   {
     "MongoDB": {
       "ConnectionString": "mongodb://localhost:27017",
       "DatabaseName": "SistemaBiblioteca",
       "CollectionName": "Livros"
     }
   }
   ```

5. **Execute a aplicação**
   ```bash
   dotnet run
   ```

6. **Acesse a documentação**
   - Swagger UI: `https://localhost:7000/swagger`
   - API Base: `https://localhost:7000/api`

## Documentação da API

### Endpoints Disponíveis

| Método | Endpoint | Descrição | Parâmetros |
|--------|----------|-----------|------------|
| `POST` | `/api/livros` | Criar novo livro | Body: `Livro` |
| `GET` | `/api/livros` | Listar todos os livros | - |
| `GET` | `/api/livros/{id}` | Buscar livro por ID | Path: `id` |
| `PUT` | `/api/livros/{id}` | Atualizar livro existente | Path: `id`, Body: `Livro` |
| `DELETE` | `/api/livros/{id}` | Deletar livro | Path: `id` |

### Modelo de Dados

#### Livro
```json
{
  "id": "string (ObjectId)",
  "titulo": "string",
  "anoPublicacao": "number",
  "autor": {
    "nome": "string",
    "nacionalidade": "string"
  }
}
```

### Exemplos de Uso

#### Criar um novo livro
```bash
curl -X POST "https://localhost:7000/api/livros" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Clean Code",
    "anoPublicacao": 2008,
    "autor": {
      "nome": "Robert C. Martin",
      "nacionalidade": "Estados Unidos"
    }
  }'
```

#### Listar todos os livros
```bash
curl -X GET "https://localhost:7000/api/livros"
```

#### Buscar livro por ID
```bash
curl -X GET "https://localhost:7000/api/livros/507f1f77bcf86cd799439011"
```

## Testes

### Executando Testes via Swagger

1. Acesse `https://localhost:7000/swagger`
2. Use a interface interativa para testar todos os endpoints
3. Visualize os modelos de dados e códigos de resposta

### Testes Manuais

```bash
# Teste de conectividade
curl -X GET "https://localhost:7000/api/livros"

# Teste de criação
curl -X POST "https://localhost:7000/api/livros" \
  -H "Content-Type: application/json" \
  -d '{"titulo":"Teste","anoPublicacao":2024,"autor":{"nome":"Autor Teste","nacionalidade":"Brasil"}}'
```

## Desenvolvimento

### Estrutura de Branches

- `main`: Branch principal com código estável
- `develop`: Branch de desenvolvimento
- `feature/*`: Branches para novas funcionalidades
- `hotfix/*`: Branches para correções urgentes

### Padrões de Commit

```
feat: adiciona nova funcionalidade
fix: corrige bug
docs: atualiza documentação
style: formatação de código
refactor: refatoração de código
test: adiciona ou corrige testes
chore: tarefas de manutenção
```

### Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Performance e Escalabilidade

- **MongoDB**: Suporte nativo a sharding e replicação
- **Connection Pooling**: Gerenciamento eficiente de conexões
- **Async/Await**: Operações assíncronas para melhor throughput
- **Embedding**: Redução de joins e melhor performance de consultas

## Segurança

- Validação de entrada em todos os endpoints
- Sanitização de dados de entrada
- Tratamento seguro de ObjectIds do MongoDB
- Headers de segurança configurados

## Roadmap

- [ ] Autenticação e autorização
- [ ] Cache com Redis
- [ ] Logs estruturados
- [ ] Métricas e monitoramento
- [ ] Testes automatizados
- [ ] CI/CD pipeline
- [ ] Containerização com Docker
- [ ] Rate limiting
- [ ] Paginação de resultados

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

