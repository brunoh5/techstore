# TechStore SQL Lab — PostgreSQL

## Requisitos
- PostgreSQL 14 ou superior.
- pgAdmin ou `psql`.
- Aproximadamente 5–8 GB livres recomendados para a carga completa (o espaço real depende da versão, índices e configuração).

## Ordem de execução
1. Abra o pgAdmin e conecte-se ao servidor PostgreSQL.
2. Crie um banco vazio chamado `techstore_lab`.
3. Abra `techstore_schema.sql` nesse banco e execute.
4. Abra `techstore_seed.sql` no mesmo banco e execute.
5. Aguarde a carga terminar. Ela gera milhões de registros sintéticos.

Pelo terminal, a partir da pasta dos arquivos:
```bash
createdb -U postgres techstore_lab
psql -U postgres -d techstore_lab -f techstore_schema.sql
psql -U postgres -d techstore_lab -f techstore_seed.sql
```

## Conferência inicial
```sql
SET search_path TO techstore, public;
SELECT 'clientes' AS tabela, COUNT(*) FROM clientes
UNION ALL SELECT 'produtos', COUNT(*) FROM produtos
UNION ALL SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL SELECT 'itens_pedido', COUNT(*) FROM itens_pedido
UNION ALL SELECT 'acessos', COUNT(*) FROM acessos
UNION ALL SELECT 'logs_sistema', COUNT(*) FROM logs_sistema;
```

## Observações
- Os dados são fictícios e gerados para estudo; não representam pessoas ou empresas reais.
- A carga completa é intencionalmente grande e pode demorar. Execute em um computador com memória e armazenamento suficientes.
- `techstore_schema.sql` cria a estrutura. `techstore_seed.sql` popula os dados.
- Para começar do zero novamente, crie outro banco vazio e execute os dois arquivos na ordem. O script de carga não foi projetado para ser executado repetidamente no mesmo banco.
- A base inclui tabelas relacionadas por chaves primárias e estrangeiras, além de índices iniciais para exercícios de performance.
