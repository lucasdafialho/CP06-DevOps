# Roteiro para Vídeo - Deploy Sistema Biblioteca Azure

## Informações do Vídeo
- **Duração estimada**: 10-15 minutos
- **Objetivo**: Demonstrar criação de recursos Azure, deploy da aplicação e validação da persistência
- **Requisitos**: Tela compartilhada, áudio claro

---

## PARTE 1: INTRODUÇÃO (1 minuto)

### Apresentação
**[FALAR]**
> "Olá, somos o grupo [NOME DO GRUPO] e vamos apresentar o CP06 da disciplina de DevOps. Nosso projeto é um sistema de biblioteca desenvolvido em .NET 8.0 com deploy no Azure."

### Mostrar Estrutura do Projeto
**[MOSTRAR NA TELA]**
- Abrir VS Code com o projeto
- Mostrar estrutura de pastas:
  - Models (Autor e Livro)
  - Controllers (AutoresController e LivrosController)
  - Data (BibliotecaDbContext)
  - Database (DDL_Script.sql)
  - Scripts (deploy-azure.sh/ps1)

**[FALAR]**
> "Como podem ver, temos uma arquitetura master-detail com as entidades Autor e Livro, relacionadas por Foreign Key. Agora vamos fazer o deploy no Azure."

---

## PARTE 2: CRIAÇÃO DOS RECURSOS AZURE (4-5 minutos)

### 2.1. Executar Script de Deploy
**[MOSTRAR NA TELA]**
- Abrir terminal
- Navegar até a pasta Scripts

**[EXECUTAR E FALAR]**
```bash
cd Scripts
./deploy-azure.sh
```

> "Vamos executar nosso script automatizado de deploy que vai criar todos os recursos necessários no Azure."

### 2.2. Acompanhar Criação dos Recursos
**[MOSTRAR NO TERMINAL]**
À medida que o script executa, comentar cada etapa:

**1. Login no Azure**
```
[FALAR] "Primeiro fazemos login no Azure..."
```

**2. Resource Group**
```
[FALAR] "Criando o Resource Group 'rg-biblioteca-app' na região East US..."
```

**3. SQL Server**
```
[FALAR] "Agora criamos o SQL Server. Este será nosso servidor de banco de dados PaaS..."
```

**4. SQL Database**
```
[FALAR] "Criando o banco de dados 'BibliotecaDB' no tier S0..."
```

**5. Firewall Rules**
```
[FALAR] "Configurando regras de firewall para permitir acesso dos serviços do Azure..."
```

**6. Application Insights**
```
[FALAR] "Criando o Application Insights para monitoramento da aplicação..."
```

**7. App Service Plan e Web App**
```
[FALAR] "Criando o App Service Plan B1 e o Web App para hospedar nossa API..."
```

**8. Deploy da Aplicação**
```
[FALAR] "Fazendo o deploy da aplicação compilada para o Web App..."
```

### 2.3. Mostrar Recursos no Portal Azure
**[ABRIR PORTAL AZURE]**
- Acessar: https://portal.azure.com
- Navegar até Resource Group 'rg-biblioteca-app'

**[MOSTRAR NA TELA E FALAR]**
> "Aqui no portal Azure podemos ver todos os recursos criados:"
- SQL Server
- SQL Database
- App Service Plan
- Web App
- Application Insights

---

## PARTE 3: CONFIGURAÇÃO DO BANCO DE DADOS (2 minutos)

### 3.1. Executar Script DDL
**[MOSTRAR NA TELA]**
- Abrir Azure Data Studio ou SSMS
- Conectar ao servidor SQL: `sqlserver-biblioteca-app.database.windows.net`

**[FALAR]**
> "Agora vamos criar as tabelas no banco de dados executando nosso script DDL."

**[EXECUTAR]**
- Abrir arquivo: `Database/DDL_Script.sql`
- Executar o script completo
- Mostrar mensagens de sucesso

### 3.2. Validar Estrutura das Tabelas
**[EXECUTAR E MOSTRAR]**
```sql
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
```

**[FALAR]**
> "Como podemos ver, as duas tabelas foram criadas: Autores (master) e Livros (detail)."

**[EXECUTAR E MOSTRAR]**
```sql
SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    tr.name AS ReferencedTable
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
WHERE tp.name = 'Livros';
```

**[FALAR]**
> "E aqui está nossa Foreign Key FK_Livros_Autores que relaciona as duas tabelas."

---

## PARTE 4: TESTES DA API E VALIDAÇÃO (5-6 minutos)

### 4.1. Acessar Swagger
**[ABRIR NAVEGADOR]**
- Acessar: `https://webapp-biblioteca-api.azurewebsites.net/swagger`

**[FALAR]**
> "Nossa API está no ar! Vamos testar todas as operações CRUD e validar a persistência no banco após cada operação."

### 4.2. Teste POST - Criar Autor 1
**[EXECUTAR NO SWAGGER]**
- POST `/api/autores`
- Body:
```json
{
  "nome": "Machado de Assis",
  "nacionalidade": "Brasileira"
}
```

**[MOSTRAR RESPOSTA]**
```json
{
  "id": 1,
  "nome": "Machado de Assis",
  "nacionalidade": "Brasileira",
  "livros": []
}
```

**[VALIDAR NO BANCO]**
```sql
SELECT * FROM Autores WHERE Id = 1;
```

**[FALAR]**
> "Operação POST executada com sucesso! Retornou status 201 Created. Agora vamos validar no banco... Como podem ver, o autor foi persistido com ID 1."

### 4.3. Teste POST - Criar Autor 2
**[EXECUTAR NO SWAGGER]**
- POST `/api/autores`
- Body:
```json
{
  "nome": "Clarice Lispector",
  "nacionalidade": "Brasileira"
}
```

**[VALIDAR NO BANCO]**
```sql
SELECT * FROM Autores;
```

**[FALAR]**
> "Segundo autor criado. Agora temos 2 registros na tabela Autores."

### 4.4. Teste GET - Listar Autores
**[EXECUTAR NO SWAGGER]**
- GET `/api/autores`

**[MOSTRAR RESPOSTA E FALAR]**
> "A operação GET retorna todos os autores cadastrados com seus livros relacionados."

### 4.5. Teste POST - Criar Livro 1
**[EXECUTAR NO SWAGGER]**
- POST `/api/livros`
- Body:
```json
{
  "titulo": "Dom Casmurro",
  "anoPublicacao": 1899,
  "autorId": 1
}
```

**[VALIDAR NO BANCO COM JOIN]**
```sql
SELECT l.*, a.Nome as AutorNome 
FROM Livros l 
INNER JOIN Autores a ON l.AutorId = a.Id
WHERE l.Id = 1;
```

**[FALAR]**
> "Livro criado com sucesso! Veja que usamos autorId = 1, que é a Foreign Key para Machado de Assis. O JOIN mostra a relação entre as tabelas funcionando perfeitamente."

### 4.6. Teste POST - Criar Livro 2
**[EXECUTAR NO SWAGGER]**
- POST `/api/livros`
- Body:
```json
{
  "titulo": "Memórias Póstumas de Brás Cubas",
  "anoPublicacao": 1881,
  "autorId": 1
}
```

**[FALAR]**
> "Criando segundo livro do mesmo autor para demonstrar o relacionamento 1:N."

### 4.7. Teste POST - Criar Livro 3
**[EXECUTAR NO SWAGGER]**
- POST `/api/livros`
- Body:
```json
{
  "titulo": "A Hora da Estrela",
  "anoPublicacao": 1977,
  "autorId": 2
}
```

**[VALIDAR NO BANCO]**
```sql
SELECT * FROM Livros;
```

**[FALAR]**
> "Agora temos 3 livros cadastrados, relacionados a diferentes autores."

### 4.8. Teste GET - Listar Livros
**[EXECUTAR NO SWAGGER]**
- GET `/api/livros`

**[MOSTRAR RESPOSTA E FALAR]**
> "O GET retorna todos os livros com as informações completas do autor através do relacionamento."

### 4.9. Teste PUT - Atualizar Livro
**[EXECUTAR NO SWAGGER]**
- PUT `/api/livros/1`
- Body:
```json
{
  "id": 1,
  "titulo": "Dom Casmurro - Edição Especial",
  "anoPublicacao": 1899,
  "autorId": 1
}
```

**[VALIDAR NO BANCO]**
```sql
SELECT * FROM Livros WHERE Id = 1;
```

**[FALAR]**
> "Operação PUT executada com sucesso! Status 204 No Content. Validando no banco... O título foi atualizado para 'Dom Casmurro - Edição Especial'."

### 4.10. Teste DELETE - Deletar Livro
**[EXECUTAR NO SWAGGER]**
- DELETE `/api/livros/1`

**[VALIDAR NO BANCO]**
```sql
SELECT * FROM Livros WHERE Id = 1;
```

**[FALAR]**
> "Operação DELETE executada! Status 204. Validando no banco... O registro foi removido com sucesso."

### 4.11. Validação do Relacionamento
**[EXECUTAR NO BANCO]**
```sql
SELECT a.Nome, COUNT(l.Id) as TotalLivros 
FROM Autores a 
LEFT JOIN Livros l ON a.Id = l.AutorId 
GROUP BY a.Id, a.Nome;
```

**[FALAR]**
> "Esta query mostra o relacionamento master-detail funcionando: Machado de Assis tem 1 livro, Clarice tem 1 livro."

---

## PARTE 5: APPLICATION INSIGHTS (2 minutos)

### 5.1. Acessar Application Insights
**[ABRIR PORTAL AZURE]**
- Navegar até Application Insights: `appinsights-biblioteca`

**[MOSTRAR E FALAR]**
> "Agora vamos verificar o monitoramento da aplicação com Application Insights."

### 5.2. Mostrar Métricas
**[NAVEGAR PELAS ABAS]**

**Performance**
> "Aqui podemos ver o tempo de resposta das requisições. Todas as operações que acabamos de executar estão sendo monitoradas."

**Requisições**
> "Total de requisições, taxa de sucesso... Podemos ver todas as chamadas POST, GET, PUT e DELETE que fizemos."

**Logs/Transações**
> "E aqui temos os logs detalhados de cada operação, incluindo as queries SQL executadas."

**[CLICAR EM ALGUMAS REQUISIÇÕES]**
> "Veja que podemos ver detalhes de cada operação: duração, resultado, dependencies (banco de dados)..."

### 5.3. Live Metrics
**[ABRIR LIVE METRICS]**

**[EXECUTAR ALGUMAS REQUISIÇÕES NO SWAGGER ENQUANTO MOSTRA]**
> "E aqui no Live Metrics conseguimos ver as requisições em tempo real chegando na aplicação."

---

## PARTE 6: CONCLUSÃO (1 minuto)

### Resumo das Entregas
**[VOLTAR PARA O VS CODE]**

**[MOSTRAR E FALAR]**
> "Para finalizar, vamos revisar todas as entregas do checkpoint:"

**[MOSTRAR CADA ARQUIVO]**
- ✅ DDL_Script.sql - Script completo das tabelas
- ✅ Código fonte da aplicação (.NET 8.0)
- ✅ Scripts Azure CLI (deploy-azure.sh e .ps1)
- ✅ HOWTO_DEPLOY.md - Guia completo de implantação
- ✅ API_Operations.json - JSON de todas as operações

**[FALAR]**
> "Demonstramos:"
- ✅ Deploy completo no Azure usando CLI
- ✅ Banco de dados SQL Server PaaS
- ✅ Duas tabelas relacionadas (Autores e Livros)
- ✅ Foreign Key funcionando corretamente
- ✅ Todas as operações CRUD (GET, POST, PUT, DELETE)
- ✅ Persistência validada no banco após cada operação
- ✅ Application Insights monitorando a aplicação

### Encerramento
**[FALAR]**
> "Isso conclui nossa apresentação do CP06. A aplicação está em produção, totalmente funcional, monitorada e todas as validações de persistência foram demonstradas. Obrigado!"

---

## CHECKLIST PRÉ-GRAVAÇÃO

Antes de gravar, verificar:

### Ambiente
- [ ] Azure CLI instalado e autenticado
- [ ] .NET 8.0 SDK instalado
- [ ] Azure Data Studio ou SSMS configurado
- [ ] Navegador com abas preparadas (Portal Azure, Swagger)
- [ ] VS Code com projeto aberto

### Recursos Azure
- [ ] Sem recursos existentes com mesmo nome
- [ ] Subscription ativa
- [ ] Créditos suficientes

### Scripts e Arquivos
- [ ] deploy-azure.sh ou .ps1 com variáveis corretas
- [ ] DDL_Script.sql revisado
- [ ] Código compilando sem erros

### Gravação
- [ ] Ferramenta de gravação testada (OBS, Zoom, etc)
- [ ] Áudio claro
- [ ] Tela com resolução adequada (1920x1080)
- [ ] Notificações desabilitadas

### Durante a Gravação
- [ ] Falar claramente e em ritmo adequado
- [ ] Mostrar cada comando antes de executar
- [ ] Aguardar operações completarem
- [ ] Sempre validar no banco após cada operação
- [ ] Destacar pontos importantes (FK, persistência, Application Insights)

---

## DICAS IMPORTANTES

### O que NÃO esquecer de mostrar:
1. **Foreign Key**: Destacar o relacionamento entre tabelas
2. **Persistência**: SEMPRE mostrar SELECT no banco após cada operação
3. **Application Insights**: Demonstrar monitoramento funcionando
4. **Todas as operações**: GET, POST, PUT, DELETE para ter nota máxima

### Pontos que garantem nota máxima:
- ✅ Mostrar criação de TODOS os recursos
- ✅ Mostrar DDL das tabelas com FK
- ✅ Validar CADA operação no banco
- ✅ Demonstrar Application Insights funcionando
- ✅ Mostrar relacionamento master-detail
- ✅ Executar scripts CLI documentados

### Se algo der errado:
- Manter a calma
- Verificar logs: `az webapp log tail --name webapp-biblioteca-api --resource-group rg-biblioteca-app`
- Verificar Connection Strings no Portal Azure
- Reiniciar Web App se necessário
- Ter backup: recursos podem ser criados manualmente pelo portal se o script falhar

---

## TEMPO ESTIMADO POR SEÇÃO

| Seção | Tempo | Acumulado |
|-------|-------|-----------|
| Introdução | 1 min | 1 min |
| Criação recursos Azure | 4-5 min | 5-6 min |
| Configuração banco | 2 min | 7-8 min |
| Testes API e validação | 5-6 min | 12-14 min |
| Application Insights | 2 min | 14-16 min |
| Conclusão | 1 min | 15-17 min |

**Total estimado: 15-17 minutos**

