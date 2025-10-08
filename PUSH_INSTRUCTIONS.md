# Como Fazer Push do Workflow

## Execute este comando no terminal:

```bash
cd "/home/lucas.fialho/Área de trabalho/CP06-DevOps/CP04-dotNET"
git push origin main
```

Você vai precisar inserir suas credenciais do GitHub:
- **Username**: seu usuário do GitHub
- **Password**: use um Personal Access Token (não sua senha)

## Como Criar um Personal Access Token

1. Vá em: https://github.com/settings/tokens
2. Clique em "Generate new token" > "Generate new token (classic)"
3. Dê um nome como "CP06-DevOps"
4. Selecione os escopos:
   - `repo` (acesso completo aos repositórios)
   - `workflow` (atualizar workflows do GitHub Actions)
5. Clique em "Generate token"
6. **COPIE O TOKEN** (você não verá ele novamente!)
7. Use o token como senha ao fazer push

## Alternativamente: Usar SSH

Se você já tem chave SSH configurada no GitHub, pode mudar a URL do remote:

```bash
cd "/home/lucas.fialho/Área de trabalho/CP06-DevOps/CP04-dotNET"
git remote set-url origin git@github.com:lucasdafialho/CP06-DevOps.git
git push origin main
```

## Verificar se Funcionou

Após o push, vá em:

https://github.com/lucasdafialho/CP06-DevOps/actions

Você deve ver o workflow "Deploy to Azure" rodando!

