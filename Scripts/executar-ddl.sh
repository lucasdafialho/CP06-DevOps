#!/bin/bash

DB_SERVER_NAME="biblioteca-dotnet-app-rm557884"
DB_NAME="BibliotecaDB"
DB_USER="bibliotecaadmin"
DB_PASS="SenhaForte557884!"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DDL_FILE="$SCRIPT_DIR/../Database/DDL_Script.sql"

echo "=============================================="
echo "Executando Script DDL no Banco de Dados"
echo "=============================================="
echo "Servidor: $DB_SERVER_NAME.database.windows.net"
echo "Banco: $DB_NAME"
echo ""

az sql db show \
  --resource-group rg-biblioteca-557884 \
  --server $DB_SERVER_NAME \
  --name $DB_NAME \
  --query "name" -o tsv > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Erro: Banco de dados não encontrado. Execute o deploy primeiro!"
    exit 1
fi

echo "Instalando extensão Azure SQL..."
az extension add --name rdbms-connect --allow-preview true 2>/dev/null || true

echo ""
echo "Executando script DDL..."
echo ""

az sql db execute \
  --server $DB_SERVER_NAME \
  --name $DB_NAME \
  --admin-user $DB_USER \
  --admin-password "$DB_PASS" \
  --file "$DDL_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "=============================================="
    echo "✓ Script DDL executado com sucesso!"
    echo "=============================================="
else
    echo ""
    echo "=============================================="
    echo "Erro ao executar o script DDL"
    echo "=============================================="
    echo ""
    echo "Tente executar manualmente via Azure Portal:"
    echo "1. Acesse: https://portal.azure.com"
    echo "2. Navegue até: SQL databases > BibliotecaDB"
    echo "3. Clique em 'Query editor'"
    echo "4. Login com:"
    echo "   User: $DB_USER"
    echo "   Password: $DB_PASS"
    echo "5. Cole e execute o conteúdo do arquivo:"
    echo "   $DDL_FILE"
    exit 1
fi

