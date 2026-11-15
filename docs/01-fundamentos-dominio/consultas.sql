/*
===============================================================================
TECHSTORE — CURSO DE SQL
MÓDULO 01 — FUNDAMENTOS E DOMÍNIO DO AMBIENTE POSTGRESQL
===============================================================================

Arquivo: consultas.sql
SGBD: PostgreSQL 16
Banco: techstore
Schema principal: techstore

OBJETIVO
---------
Reunir consultas demonstrativas para explorar o ambiente PostgreSQL,
identificar objetos e investigar metadados.

REGRAS
------
1. Todas as consultas deste arquivo são de leitura.
2. Não executar novamente o seed.
3. Não modificar tabelas ou registros.
4. Não executar comandos destrutivos.
5. Observar os comentários antes de executar cada bloco.
6. Executar os blocos individualmente durante as aulas.

IMPORTANTE
----------
Este arquivo contém ferramentas de investigação e demonstrações.
Não representa o gabarito das atividades.md.

===============================================================================
*/


/*
===============================================================================
01. IDENTIFICAÇÃO DO AMBIENTE
===============================================================================

Objetivo:
Identificar informações básicas da conexão atual.

Conceitos:
- Banco conectado
- Usuário atual
- Versão do PostgreSQL
- Schema atual
- Configurações da sessão

Resultado esperado:
Informações que permitam identificar a sessão e o ambiente de execução.
*/


-- 01.1 — Versão do PostgreSQL
SELECT version();


-- 01.2 — Banco de dados conectado
SELECT current_database();


-- 01.3 — Usuário da sessão
SELECT current_user;


-- 01.4 — Schema atual
SELECT current_schema();


-- 01.5 — Data e horário da sessão
SELECT
    CURRENT_DATE AS data_atual,
    CURRENT_TIMESTAMP AS horario_atual;


-- 01.6 — Configurações básicas da sessão
SHOW search_path;


/*
===============================================================================
02. EXPLORAÇÃO DE BANCOS E SCHEMAS
===============================================================================

Objetivo:
Compreender a organização lógica do PostgreSQL.

Conceitos:
- Database
- Schema
- Namespace
- search_path

Resultado esperado:
Identificação dos bancos e schemas disponíveis conforme as permissões
do usuário conectado.
*/


-- 02.1 — Bancos de dados disponíveis
SELECT
    datname AS banco,
    pg_encoding_to_char(encoding) AS codificacao,
    datcollate AS collate,
    datctype AS ctype,
    datallowconn AS permite_conexao
FROM pg_database
ORDER BY datname;


-- 02.2 — Schemas disponíveis
SELECT
    schema_name,
    schema_owner
FROM information_schema.schemata
ORDER BY schema_name;


-- 02.3 — Schemas e seus proprietários
SELECT
    n.nspname AS schema,
    r.rolname AS proprietario
FROM pg_namespace n
JOIN pg_roles r
    ON r.oid = n.nspowner
ORDER BY n.nspname;


/*
===============================================================================
03. INVENTÁRIO DE TABELAS
===============================================================================

Objetivo:
Investigar as tabelas existentes no schema TechStore.

Conceitos:
- Tabela
- Schema
- Relkind
- Catálogo pg_class

Resultado esperado:
Relação dos objetos identificados no schema selecionado.
*/


-- 03.1 — Tabelas do schema TechStore
SELECT
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'techstore'
ORDER BY table_name;


-- 03.2 — Quantidade de tabelas por schema
SELECT
    table_schema,
    COUNT(*) AS quantidade_tabelas
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
GROUP BY table_schema
ORDER BY table_schema;


-- 03.3 — Objetos do schema através do catálogo PostgreSQL
SELECT
    n.nspname AS schema,
    c.relname AS objeto,
    c.relkind AS tipo_objeto
FROM pg_class c
JOIN pg_namespace n
    ON n.oid = c.relnamespace
WHERE n.nspname = 'techstore'
ORDER BY c.relkind, c.relname;


/*
===============================================================================
04. ESTRUTURA DAS COLUNAS
===============================================================================

Objetivo:
Investigar a definição das colunas das tabelas.

Conceitos:
- Nome da coluna
- Tipo de dado
- Nulabilidade
- Valor padrão
- Ordem das colunas

Resultado esperado:
Descrição estrutural das colunas disponíveis no schema.
*/


-- 04.1 — Colunas de todas as tabelas do schema TechStore
SELECT
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'techstore'
ORDER BY table_name, ordinal_position;


-- 04.2 — Tipos de dados utilizados no schema
SELECT
    data_type,
    COUNT(*) AS quantidade_colunas
FROM information_schema.columns
WHERE table_schema = 'techstore'
GROUP BY data_type
ORDER BY quantidade_colunas DESC, data_type;


-- 04.3 — Colunas obrigatórias
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'techstore'
  AND is_nullable = 'NO'
ORDER BY table_name, ordinal_position;


/*
===============================================================================
05. CHAVES PRIMÁRIAS
===============================================================================

Objetivo:
Investigar as constraints de chave primária.

Conceitos:
- Primary Key
- Constraint
- Unicidade
- Identificação de registros

Resultado esperado:
Relação das chaves primárias e suas respectivas colunas.
*/


-- 05.1 — Constraints de chave primária
SELECT
    tc.table_name,
    tc.constraint_name,
    kcu.column_name,
    kcu.ordinal_position
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON kcu.constraint_catalog = tc.constraint_catalog
   AND kcu.constraint_schema = tc.constraint_schema
   AND kcu.constraint_name = tc.constraint_name
   AND kcu.table_schema = tc.table_schema
   AND kcu.table_name = tc.table_name
WHERE tc.constraint_schema = 'techstore'
  AND tc.constraint_type = 'PRIMARY KEY'
ORDER BY tc.table_name, kcu.ordinal_position;


/*
===============================================================================
06. CHAVES ESTRANGEIRAS E RELACIONAMENTOS
===============================================================================

Objetivo:
Investigar os relacionamentos definidos entre as tabelas.

Conceitos:
- Foreign Key
- Integridade referencial
- Tabela referenciadora
- Tabela referenciada

Resultado esperado:
Mapeamento das relações estruturais encontradas no banco.
*/


-- 06.1 — Constraints de chave estrangeira
SELECT
    tc.table_name AS tabela_origem,
    kcu.column_name AS coluna_origem,
    ccu.table_name AS tabela_referenciada,
    ccu.column_name AS coluna_referenciada,
    tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON kcu.constraint_catalog = tc.constraint_catalog
   AND kcu.constraint_schema = tc.constraint_schema
   AND kcu.constraint_name = tc.constraint_name
   AND kcu.table_schema = tc.table_schema
   AND kcu.table_name = tc.table_name
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_catalog = tc.constraint_catalog
   AND ccu.constraint_schema = tc.constraint_schema
   AND ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.constraint_schema = 'techstore'
ORDER BY
    tc.table_name,
    tc.constraint_name,
    kcu.ordinal_position;


/*
===============================================================================
07. CONSTRAINTS
===============================================================================

Objetivo:
Investigar as regras estruturais aplicadas às tabelas.

Conceitos:
- PRIMARY KEY
- FOREIGN KEY
- UNIQUE
- CHECK
- NOT NULL

Resultado esperado:
Inventário das constraints declaradas no schema.
*/


-- 07.1 — Constraints das tabelas
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.constraint_schema = 'techstore'
ORDER BY tc.table_name, tc.constraint_type, tc.constraint_name;


-- 07.2 — Definições das constraints no PostgreSQL
SELECT
    n.nspname AS schema,
    t.relname AS tabela,
    c.conname AS constraint,
    c.contype AS tipo,
    pg_get_constraintdef(c.oid) AS definicao
FROM pg_constraint c
JOIN pg_class t
    ON t.oid = c.conrelid
JOIN pg_namespace n
    ON n.oid = t.relnamespace
WHERE n.nspname = 'techstore'
ORDER BY t.relname, c.conname;


/*
===============================================================================
08. ÍNDICES
===============================================================================

Objetivo:
Reconhecer os índices existentes e sua relação com as tabelas.

Conceitos:
- Index
- Índice de chave primária
- Índice secundário
- Estrutura de acesso

Resultado esperado:
Relação dos índices existentes no schema.
*/


-- 08.1 — Índices do schema TechStore
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'techstore'
ORDER BY tablename, indexname;


/*
===============================================================================
09. CATÁLOGOS E METADADOS
===============================================================================

Objetivo:
Explorar os catálogos internos do PostgreSQL.

Conceitos:
- pg_class
- pg_namespace
- pg_attribute
- pg_constraint
- pg_type

Resultado esperado:
Compreensão de como o PostgreSQL armazena informações sobre seus objetos.
*/


-- 09.1 — Tabelas e seus identificadores internos
SELECT
    c.oid,
    n.nspname AS schema,
    c.relname AS tabela,
    c.reltuples AS estimativa_linhas
FROM pg_class c
JOIN pg_namespace n
    ON n.oid = c.relnamespace
WHERE n.nspname = 'techstore'
  AND c.relkind IN ('r', 'p')
ORDER BY c.relname;


-- 09.2 — Colunas e tipos internos
SELECT
    c.relname AS tabela,
    a.attname AS coluna,
    format_type(a.atttypid, a.atttypmod) AS tipo,
    a.attnotnull AS obrigatoria
FROM pg_attribute a
JOIN pg_class c
    ON c.oid = a.attrelid
JOIN pg_namespace n
    ON n.oid = c.relnamespace
WHERE n.nspname = 'techstore'
  AND c.relkind IN ('r', 'p')
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY c.relname, a.attnum;


/*
===============================================================================
10. ESTATÍSTICAS E TAMANHO DAS TABELAS
===============================================================================

Objetivo:
Conhecer informações físicas e estatísticas das tabelas.

Conceitos:
- pg_stat_user_tables
- pg_total_relation_size
- pg_relation_size
- pg_size_pretty
- Estimativas de linhas

Resultado esperado:
Visão geral do tamanho e das estatísticas disponíveis.

Observação:
Estimativas de linhas não equivalem necessariamente à contagem exata.
*/


-- 10.1 — Estatísticas das tabelas
SELECT
    schemaname,
    relname AS tabela,
    n_live_tup AS estimativa_registros,
    n_dead_tup AS estimativa_registros_mortos,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
WHERE schemaname = 'techstore'
ORDER BY relname;


-- 10.2 — Espaço ocupado pelas tabelas
SELECT
    schemaname,
    tablename,
    pg_size_pretty(
        pg_total_relation_size(
            quote_ident(schemaname) || '.' || quote_ident(tablename)
        )
    ) AS tamanho_total
FROM pg_tables
WHERE schemaname = 'techstore'
ORDER BY pg_total_relation_size(
    quote_ident(schemaname) || '.' || quote_ident(tablename)
) DESC;


-- 10.3 — Tamanho total do banco conectado
SELECT
    current_database() AS banco,
    pg_size_pretty(
        pg_database_size(current_database())
    ) AS tamanho_total;


/*
===============================================================================
11. VISUALIZAÇÃO DE DADOS
===============================================================================

Objetivo:
Familiarizar-se com a leitura de registros reais.

Conceitos:
- SELECT
- LIMIT
- ORDER BY
- Schema qualificado

Resultado esperado:
Visualização controlada de registros sem alterar o banco.

Observação:
Estas são demonstrações iniciais de SELECT.
O estudo aprofundado de consultas ocorrerá no Módulo 02.
*/


-- 11.1 — Visualização limitada de categorias
SELECT *
FROM techstore.categorias
LIMIT 10;


-- 11.2 — Visualização limitada de produtos
SELECT *
FROM techstore.produtos
LIMIT 10;


-- 11.3 — Visualização limitada de clientes
SELECT *
FROM techstore.clientes
LIMIT 10;


-- 11.4 — Visualização limitada de pedidos
SELECT *
FROM techstore.pedidos
LIMIT 10;


-- 11.5 — Visualização dos registros mais recentes de acessos
SELECT *
FROM techstore.acessos
ORDER BY data_acesso DESC
LIMIT 10;


/*
===============================================================================
12. CONSULTAS DE CONFERÊNCIA
===============================================================================

Objetivo:
Conferir informações gerais sem modificar os dados.

Conceitos:
- COUNT
- COUNT(*)
- Contagem de registros

Resultado esperado:
Quantidade de registros por tabela selecionada.

Observação:
Contagens exatas em tabelas grandes podem exigir leitura significativa
de dados. Execute quando necessário, evitando repetições desnecessárias.
*/


-- 12.1 — Quantidade de categorias
SELECT COUNT(*) AS total_categorias
FROM techstore.categorias;


-- 12.2 — Quantidade de produtos
SELECT COUNT(*) AS total_produtos
FROM techstore.produtos;


-- 12.3 — Quantidade de clientes
SELECT COUNT(*) AS total_clientes
FROM techstore.clientes;


-- 12.4 — Quantidade de pedidos
SELECT COUNT(*) AS total_pedidos
FROM techstore.pedidos;


-- 12.5 — Quantidade de registros de acessos
SELECT COUNT(*) AS total_acessos
FROM techstore.acessos;


/*
===============================================================================
13. ENCERRAMENTO
===============================================================================

Ao concluir a exploração, o estudante deverá conseguir explicar:

1. Como identificar o banco conectado.
2. Como localizar schemas e tabelas.
3. Como investigar colunas e tipos.
4. Como identificar chaves primárias e estrangeiras.
5. Como interpretar constraints.
6. Como consultar os catálogos do PostgreSQL.
7. Como identificar índices.
8. Como consultar estatísticas e tamanhos.
9. Como visualizar registros sem modificar os dados.

Este arquivo é material de apoio e demonstração.
Não substitui as atividades.md nem a avaliação definida em validacao.md.

===============================================================================
FIM DO ARQUIVO
===============================================================================
*/