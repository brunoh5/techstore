-- ============================================================
-- CURSO SQL PROFISSIONAL
-- MODULO 10 - DML E TRANSACOES
-- Arquivo: consultas.sql
-- Banco principal: TechStore
-- PostgreSQL 16
-- ============================================================
--
-- OBJETIVO:
-- Demonstrar comandos de manipulacao de dados e controle
-- transacional em ambiente isolado.
--
-- IMPORTANTE:
-- 1. Este arquivo NAO deve modificar as tabelas originais
--    do banco TechStore.
-- 2. Os exemplos abaixo utilizam tabelas TEMPORARIAS.
-- 3. Tabelas temporarias existem somente na sessao atual.
-- 4. Execute os blocos individualmente e observe os resultados.
-- 5. Nao execute novamente o seed do projeto.
-- 6. Os exemplos de EXPLAIN ANALYZE executam a operacao.
-- 7. Os exemplos de concorrencia exigem um laboratorio
--    permanente em banco de testes separado.
--
-- ============================================================
-- 01. PREPARACAO DO LABORATORIO
-- ============================================================

-- Criacao das tabelas temporarias.
-- Os dados abaixo sao ficticios e independentes da TechStore.

DROP TABLE IF EXISTS tmp_itens_pedido;
DROP TABLE IF EXISTS tmp_pedidos;
DROP TABLE IF EXISTS tmp_estoque;
DROP TABLE IF EXISTS tmp_produtos;
DROP TABLE IF EXISTS tmp_clientes;
DROP TABLE IF EXISTS tmp_categorias;

CREATE TEMP TABLE tmp_categorias (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TEMP TABLE tmp_produtos (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categoria_id INTEGER REFERENCES tmp_categorias(id),
    nome VARCHAR(120) NOT NULL,
    preco NUMERIC(12,2) NOT NULL CHECK (preco >= 0),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    sku VARCHAR(30) NOT NULL UNIQUE
);

CREATE TEMP TABLE tmp_clientes (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TEMP TABLE tmp_estoque (
    produto_id INTEGER PRIMARY KEY REFERENCES tmp_produtos(id),
    quantidade INTEGER NOT NULL CHECK (quantidade >= 0),
    estoque_minimo INTEGER NOT NULL DEFAULT 5
        CHECK (estoque_minimo >= 0)
);

CREATE TEMP TABLE tmp_pedidos (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES tmp_clientes(id),
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'processando',
    valor_total NUMERIC(12,2) NOT NULL DEFAULT 0
        CHECK (valor_total >= 0)
);

CREATE TEMP TABLE tmp_itens_pedido (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES tmp_pedidos(id),
    produto_id INTEGER NOT NULL REFERENCES tmp_produtos(id),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(12,2) NOT NULL
        CHECK (preco_unitario >= 0)
);

-- ============================================================
-- 02. INSERCAO DE DADOS
-- ============================================================

-- 02.01 - INSERT de um registro.

INSERT INTO tmp_categorias (nome)
VALUES ('Informatica');

-- 02.02 - INSERT de multiplos registros.

INSERT INTO tmp_categorias (nome)
VALUES
    ('Perifericos'),
    ('Acessorios'),
    ('Armazenamento');

-- 02.03 - INSERT utilizando DEFAULT.

INSERT INTO tmp_clientes (nome, email)
VALUES ('Ana Silva', 'ana@example.com');

-- A coluna ativo recebe seu valor DEFAULT.

-- 02.04 - INSERT informando NULL explicitamente.

INSERT INTO tmp_clientes (nome, email, ativo)
VALUES ('Carlos Lima', 'carlos@example.com', NULL);

-- OBSERVACAO:
-- A operacao acima deve falhar porque ativo possui NOT NULL.
-- Execute isoladamente se desejar observar a violacao.
-- Apos o erro, utilize ROLLBACK se estiver em uma transacao.

-- 02.05 - INSERT com RETURNING.

INSERT INTO tmp_produtos (
    categoria_id,
    nome,
    preco,
    sku
)
VALUES (
    1,
    'Teclado mecanico',
    299.90,
    'TEC-001'
)
RETURNING *;

-- 02.06 - Insercao de varios produtos.

INSERT INTO tmp_produtos (
    categoria_id,
    nome,
    preco,
    sku
)
VALUES
    (2, 'Mouse sem fio', 129.90, 'MOU-001'),
    (2, 'Teclado compacto', 189.90, 'TEC-002'),
    (3, 'Cabo USB-C', 39.90, 'CAB-001'),
    (4, 'SSD 1TB', 499.90, 'SSD-001')
RETURNING id, nome, preco;

-- 02.07 - INSERT utilizando SELECT.

INSERT INTO tmp_estoque (
    produto_id,
    quantidade,
    estoque_minimo
)
SELECT
    id,
    20,
    5
FROM tmp_produtos
RETURNING *;

-- 02.08 - Verificacao dos dados inseridos.

SELECT *
FROM tmp_produtos
ORDER BY id;

SELECT *
FROM tmp_clientes
ORDER BY id;

SELECT *
FROM tmp_estoque
ORDER BY produto_id;

-- ============================================================
-- 03. UPDATE
-- ============================================================

-- 03.01 - Atualizacao simples.

UPDATE tmp_produtos
SET preco = 319.90
WHERE sku = 'TEC-001'
RETURNING *;

-- 03.02 - Atualizacao de multiplas colunas.

UPDATE tmp_produtos
SET
    preco = 139.90,
    ativo = FALSE
WHERE sku = 'MOU-001'
RETURNING *;

-- 03.03 - Atualizacao utilizando expressao.

UPDATE tmp_estoque
SET quantidade = quantidade + 10
WHERE produto_id = 1
RETURNING *;

-- 03.04 - Atualizacao condicional com CASE.

UPDATE tmp_produtos
SET preco =
    CASE
        WHEN preco < 100 THEN preco * 1.10
        WHEN preco < 300 THEN preco * 1.05
        ELSE preco
    END
RETURNING id, nome, preco;

-- 03.05 - UPDATE utilizando subconsulta.

UPDATE tmp_produtos
SET ativo = FALSE
WHERE id IN (
    SELECT produto_id
    FROM tmp_estoque
    WHERE quantidade = 0
)
RETURNING *;

-- 03.06 - UPDATE FROM.

UPDATE tmp_estoque AS e
SET estoque_minimo = 10
FROM tmp_produtos AS p
WHERE p.id = e.produto_id
  AND p.categoria_id = 2
RETURNING e.*, p.nome;

-- 03.07 - Atualizacao condicional para evitar estoque negativo.

UPDATE tmp_estoque
SET quantidade = quantidade - 2
WHERE produto_id = 1
  AND quantidade >= 2
RETURNING *;

-- Observe a quantidade de linhas retornadas.
-- Zero linhas pode indicar que o produto nao existe
-- ou que a quantidade disponivel e insuficiente.

-- 03.08 - Exemplo de UPDATE sem WHERE.
-- NAO EXECUTE fora de uma transacao controlada.
-- Demonstra que todas as linhas podem ser alteradas.

BEGIN;

UPDATE tmp_produtos
SET ativo = FALSE
RETURNING id, nome, ativo;

-- Verificacao.

SELECT *
FROM tmp_produtos;

-- Desfaz a operacao.

ROLLBACK;

-- ============================================================
-- 04. DELETE
-- ============================================================

-- 04.01 - DELETE de um registro especifico.

DELETE FROM tmp_produtos
WHERE sku = 'CAB-001'
RETURNING *;

-- OBSERVACAO:
-- Este comando pode falhar se existir uma referencia
-- correspondente em tmp_estoque.

-- 04.02 - DELETE utilizando subconsulta.
-- Execute somente se a condicao fizer sentido no laboratorio.

DELETE FROM tmp_clientes
WHERE id IN (
    SELECT id
    FROM tmp_clientes
    WHERE ativo = FALSE
)
RETURNING *;

-- OBSERVACAO:
-- O exemplo pode falhar caso existam pedidos vinculados
-- ao cliente, devido a FOREIGN KEY.

-- 04.03 - DELETE sem WHERE.
-- Demonstracao controlada.

BEGIN;

DELETE FROM tmp_estoque
RETURNING *;

SELECT COUNT(*) AS registros_restantes
FROM tmp_estoque;

ROLLBACK;

-- 04.04 - Comparacao conceitual:
--
-- DELETE:
-- Remove registros.
--
-- TRUNCATE:
-- Remove todos os registros da tabela.
--
-- DROP:
-- Remove o objeto do banco.
--
-- O PostgreSQL permite executar TRUNCATE dentro de
-- transacoes. Entretanto, ele possui comportamento de
-- bloqueio e triggers diferente de DELETE.

-- 04.05 - TRUNCATE em tabela temporaria.

BEGIN;

TRUNCATE TABLE tmp_estoque
RESTART IDENTITY;

SELECT COUNT(*) AS registros
FROM tmp_estoque;

ROLLBACK;

-- ============================================================
-- 05. UPSERT
-- ============================================================

-- 05.01 - ON CONFLICT DO NOTHING.

INSERT INTO tmp_clientes (nome, email)
VALUES ('Ana Silva', 'ana@example.com')
ON CONFLICT (email) DO NOTHING
RETURNING *;

-- 05.02 - ON CONFLICT DO UPDATE.

INSERT INTO tmp_clientes (nome, email, ativo)
VALUES ('Ana Silva Atualizada', 'ana@example.com', TRUE)
ON CONFLICT (email)
DO UPDATE SET
    nome = EXCLUDED.nome,
    ativo = EXCLUDED.ativo
RETURNING *;

-- EXCLUDED representa os valores que seriam inseridos.

-- 05.03 - UPSERT com atualizacao condicional.

INSERT INTO tmp_produtos (
    categoria_id,
    nome,
    preco,
    sku
)
VALUES (
    1,
    'Teclado mecanico',
    349.90,
    'TEC-001'
)
ON CONFLICT (sku)
DO UPDATE SET
    preco = EXCLUDED.preco
WHERE tmp_produtos.preco <> EXCLUDED.preco
RETURNING *;

-- 05.04 - Comparacao entre registro existente e novo valor.

SELECT
    sku,
    nome,
    preco
FROM tmp_produtos
ORDER BY sku;

-- OBSERVACAO:
-- ON CONFLICT trata conflitos de unicidade.
-- Ele nao corrige automaticamente erros de CHECK,
-- NOT NULL ou FOREIGN KEY.

-- ============================================================
-- 06. TRANSACOES
-- ============================================================

-- 06.01 - BEGIN e COMMIT.

BEGIN;

UPDATE tmp_estoque
SET quantidade = quantidade + 5
WHERE produto_id = 1;

SELECT *
FROM tmp_estoque
WHERE produto_id = 1;

COMMIT;

-- 06.02 - BEGIN e ROLLBACK.

BEGIN;

UPDATE tmp_estoque
SET quantidade = quantidade + 100
WHERE produto_id = 1;

SELECT *
FROM tmp_estoque
WHERE produto_id = 1;

ROLLBACK;

-- 06.03 - Verificacao apos ROLLBACK.

SELECT *
FROM tmp_estoque
WHERE produto_id = 1;

-- 06.04 - Transacao com multiplas operacoes.

BEGIN;

UPDATE tmp_estoque
SET quantidade = quantidade - 1
WHERE produto_id = 1
  AND quantidade >= 1;

UPDATE tmp_produtos
SET ativo = TRUE
WHERE id = 1;

SELECT
    p.nome,
    p.ativo,
    e.quantidade
FROM tmp_produtos AS p
JOIN tmp_estoque AS e
    ON e.produto_id = p.id
WHERE p.id = 1;

-- Escolha COMMIT ou ROLLBACK apos validar.

ROLLBACK;

-- ============================================================
-- 07. SAVEPOINT
-- ============================================================

-- 07.01 - Recuperacao parcial.

BEGIN;

UPDATE tmp_estoque
SET quantidade = quantidade + 10
WHERE produto_id = 1;

SAVEPOINT ponto_1;

UPDATE tmp_estoque
SET quantidade = quantidade + 50
WHERE produto_id = 2;

-- Recupera somente a operacao posterior ao ponto 1.

ROLLBACK TO SAVEPOINT ponto_1;

SELECT *
FROM tmp_estoque
ORDER BY produto_id;

COMMIT;

-- 07.02 - Multiplos SAVEPOINTs.

BEGIN;

UPDATE tmp_estoque
SET quantidade = quantidade + 1
WHERE produto_id = 1;

SAVEPOINT ponto_a;

UPDATE tmp_estoque
SET quantidade = quantidade + 2
WHERE produto_id = 2;

SAVEPOINT ponto_b;

UPDATE tmp_estoque
SET quantidade = quantidade + 3
WHERE produto_id = 3;

ROLLBACK TO SAVEPOINT ponto_b;

RELEASE SAVEPOINT ponto_a;

SELECT *
FROM tmp_estoque
ORDER BY produto_id;

ROLLBACK;

-- ============================================================
-- 08. CONSTRAINTS E INTEGRIDADE
-- ============================================================

-- 08.01 - Consultar constraints das tabelas do laboratorio.

SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints AS tc
WHERE tc.table_schema LIKE 'pg_temp%'
ORDER BY tc.table_name, tc.constraint_name;

-- OBSERVACAO:
-- A visibilidade de tabelas temporarias em views de catalogo
-- pode variar conforme a consulta e a sessao.
-- Para inspecionar objetos temporarios, tambem consulte
-- pg_catalog.pg_tables e os catalogos de constraints.

-- 08.02 - Exemplo de violacao CHECK.
-- Execute isoladamente para observar o erro.

INSERT INTO tmp_produtos (
    categoria_id,
    nome,
    preco,
    sku
)
VALUES (
    1,
    'Produto invalido',
    -10,
    'INV-001'
);

-- Codigo esperado: 23514.

-- 08.03 - Exemplo de violacao FOREIGN KEY.
-- Execute isoladamente para observar o erro.

INSERT INTO tmp_estoque (
    produto_id,
    quantidade,
    estoque_minimo
)
VALUES (
    999999,
    10,
    5
);

-- Codigo esperado: 23503.

-- 08.04 - Exemplo de violacao NOT NULL.
-- Execute isoladamente para observar o erro.

INSERT INTO tmp_clientes (nome, email)
VALUES (NULL, 'invalido@example.com');

-- Codigo esperado: 23502.

-- IMPORTANTE:
-- Um erro dentro de uma transacao pode deixa-la abortada.
-- Execute cada teste isoladamente ou utilize ROLLBACK
-- antes de continuar.

-- ============================================================
-- 09. CONSULTAS PARA CONFERENCIA
-- ============================================================

-- 09.01 - Quantidade de registros por tabela.

SELECT 'categorias' AS tabela, COUNT(*) AS registros
FROM tmp_categorias

UNION ALL

SELECT 'produtos', COUNT(*)
FROM tmp_produtos

UNION ALL

SELECT 'clientes', COUNT(*)
FROM tmp_clientes

UNION ALL

SELECT 'estoque', COUNT(*)
FROM tmp_estoque

UNION ALL

SELECT 'pedidos', COUNT(*)
FROM tmp_pedidos

UNION ALL

SELECT 'itens_pedido', COUNT(*)
FROM tmp_itens_pedido;

-- 09.02 - Verificacao de integridade entre produtos e estoque.

SELECT
    p.id,
    p.nome,
    e.quantidade,
    e.estoque_minimo
FROM tmp_produtos AS p
LEFT JOIN tmp_estoque AS e
    ON e.produto_id = p.id
ORDER BY p.id;

-- 09.03 - Verificacao de produtos abaixo do estoque minimo.

SELECT
    p.nome,
    e.quantidade,
    e.estoque_minimo
FROM tmp_produtos AS p
JOIN tmp_estoque AS e
    ON e.produto_id = p.id
WHERE e.quantidade < e.estoque_minimo
ORDER BY e.quantidade;

-- ============================================================
-- 10. EXPLAIN E DESEMPENHO
-- ============================================================

-- 10.01 - EXPLAIN sem executar a operacao.

EXPLAIN
SELECT *
FROM tmp_produtos
WHERE sku = 'TEC-001';

-- 10.02 - EXPLAIN ANALYZE em consulta SELECT.

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.nome,
    p.preco,
    e.quantidade
FROM tmp_produtos AS p
JOIN tmp_estoque AS e
    ON e.produto_id = p.id
WHERE p.ativo = TRUE;

-- 10.03 - EXPLAIN ANALYZE em UPDATE.
-- Executa a operacao: utilize uma transacao controlada.

BEGIN;

EXPLAIN (ANALYZE, BUFFERS)
UPDATE tmp_estoque
SET quantidade = quantidade + 1
WHERE produto_id = 1;

ROLLBACK;

-- 10.04 - EXPLAIN ANALYZE em DELETE.
-- Executa a operacao: utilize uma transacao controlada.

BEGIN;

EXPLAIN (ANALYZE, BUFFERS)
DELETE FROM tmp_estoque
WHERE quantidade < 0;

ROLLBACK;

-- 10.05 - Comparacao de insercoes em lote.
-- Execute em laboratorio com volume maior e repita os testes.
-- Mantenha as mesmas condicoes para comparar resultados.

CREATE TEMP TABLE tmp_benchmark (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    valor INTEGER NOT NULL
);

BEGIN;

INSERT INTO tmp_benchmark (valor)
SELECT generate_series(1, 10000);

ROLLBACK;

-- O exemplo acima demonstra uma insercao em lote.
-- Para comparar com insercoes individuais, mantenha:
-- - Mesmo numero de registros.
-- - Mesmas constraints.
-- - Mesmas condicoes de transacao.
-- - Mesmo estado inicial.
-- - Repeticoes e comparacao de medianas.

-- ============================================================
-- 11. MONITORAMENTO DE BLOQUEIOS
-- ============================================================

-- Execute em uma sessao separada enquanto outra sessao
-- estiver realizando uma operacao que mantenha um bloqueio.

-- 11.01 - Sessoes ativas.

SELECT
    pid,
    usename,
    state,
    wait_event_type,
    wait_event,
    query_start,
    query
FROM pg_stat_activity
WHERE datname = current_database()
ORDER BY query_start;

-- 11.02 - Bloqueadores e sessoes bloqueadas.

SELECT
    blocked.pid AS pid_bloqueado,
    blocked.query AS consulta_bloqueada,
    blocker.pid AS pid_bloqueador,
    blocker.query AS consulta_bloqueadora
FROM pg_stat_activity AS blocked
CROSS JOIN LATERAL
    unnest(pg_blocking_pids(blocked.pid)) AS blocking_pid(pid)
JOIN pg_stat_activity AS blocker
    ON blocker.pid = blocking_pid.pid;

-- ============================================================
-- 12. TESTES DE CONCORRENCIA
-- ============================================================

-- IMPORTANTE:
-- Os exemplos desta secao sao orientacoes para um laboratorio
-- permanente em banco de testes separado.
--
-- NAO execute estes testes utilizando as tabelas temporarias
-- deste arquivo.
--
-- Uma tabela temporaria pertence a uma sessao e nao pode ser
-- compartilhada entre duas conexoes independentes.
--
-- Para testar:
-- 1. Prepare uma tabela permanente no banco de testes.
-- 2. Abra dois Query Tools independentes no pgAdmin.
-- 3. Execute cada parte na sessao indicada.
-- 4. Observe os bloqueios e a visibilidade.
-- 5. Finalize todas as transacoes.

-- 12.01 - Roteiro de SELECT FOR UPDATE.
--
-- SESSAO A:
-- BEGIN;
-- SELECT * FROM tabela_laboratorio WHERE id = 1 FOR UPDATE;
--
-- SESSAO B:
-- BEGIN;
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 1;
--
-- Observe o comportamento de espera.
--
-- SESSAO A:
-- COMMIT;
--
-- Observe a continuidade da sessao B.
--
-- 12.02 - Roteiro de READ COMMITTED.
--
-- SESSAO A:
-- BEGIN;
-- SELECT * FROM tabela_laboratorio WHERE id = 1;
-- SELECT * FROM tabela_laboratorio WHERE id = 1;
-- COMMIT;
--
-- SESSAO B:
-- BEGIN;
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 1;
-- COMMIT;
--
-- Execute as consultas em momentos controlados e compare
-- os resultados observados na sessao A.
--
-- 12.03 - Roteiro de REPEATABLE READ.
--
-- SESSAO A:
-- BEGIN ISOLATION LEVEL REPEATABLE READ;
-- SELECT * FROM tabela_laboratorio WHERE id = 1;
--
-- SESSAO B:
-- BEGIN;
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 1;
-- COMMIT;
--
-- SESSAO A:
-- SELECT * FROM tabela_laboratorio WHERE id = 1;
-- COMMIT;
--
-- Compare a visibilidade dos dados com READ COMMITTED.
--
-- 12.04 - Roteiro de SERIALIZABLE.
--
-- SESSAO A:
-- BEGIN ISOLATION LEVEL SERIALIZABLE;
-- SELECT SUM(quantidade)
-- FROM tabela_laboratorio;
--
-- SESSAO B:
-- BEGIN ISOLATION LEVEL SERIALIZABLE;
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 1;
-- COMMIT;
--
-- SESSAO A:
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 2;
-- COMMIT;
--
-- O resultado depende do cenário e da ordem das operações.
-- O PostgreSQL pode abortar uma transacao para preservar
-- a serializacao.
--
-- 12.05 - Roteiro de deadlock.
--
-- Realizar somente em laboratorio isolado.
--
-- SESSAO A:
-- BEGIN;
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 1;
--
-- SESSAO B:
-- BEGIN;
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 2;
--
-- SESSAO A:
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 2;
--
-- SESSAO B:
-- UPDATE tabela_laboratorio
-- SET quantidade = quantidade + 1
-- WHERE id = 1;
--
-- O PostgreSQL devera detectar o deadlock e abortar uma
-- das transacoes.
--
-- Codigo de referencia: 40P01.
--
-- Nao dependa de um tempo exato para a deteccao.
-- Finalize a sessao restante com COMMIT ou ROLLBACK.

-- ============================================================
-- 13. NIVEIS DE ISOLAMENTO
-- ============================================================

-- 13.01 - Consultar o nivel de isolamento atual.

SHOW transaction_isolation;

-- 13.02 - READ COMMITTED.

BEGIN ISOLATION LEVEL READ COMMITTED;

SHOW transaction_isolation;

ROLLBACK;

-- 13.03 - REPEATABLE READ.

BEGIN ISOLATION LEVEL REPEATABLE READ;

SHOW transaction_isolation;

ROLLBACK;

-- 13.04 - SERIALIZABLE.

BEGIN ISOLATION LEVEL SERIALIZABLE;

SHOW transaction_isolation;

ROLLBACK;

-- 13.05 - READ UNCOMMITTED.
-- No PostgreSQL, apresenta comportamento equivalente
-- a READ COMMITTED.

BEGIN ISOLATION LEVEL READ UNCOMMITTED;

SHOW transaction_isolation;

ROLLBACK;

-- ============================================================
-- 14. ENCERRAMENTO DO LABORATORIO
-- ============================================================

-- Conferencia final.

SELECT
    p.id,
    p.nome,
    p.preco,
    p.ativo,
    e.quantidade,
    e.estoque_minimo
FROM tmp_produtos AS p
LEFT JOIN tmp_estoque AS e
    ON e.produto_id = p.id
ORDER BY p.id;

-- As tabelas temporarias serao removidas automaticamente
-- quando a sessao PostgreSQL for encerrada.
--
-- Tambem podem ser removidas manualmente:

DROP TABLE IF EXISTS tmp_itens_pedido;
DROP TABLE IF EXISTS tmp_pedidos;
DROP TABLE IF EXISTS tmp_estoque;
DROP TABLE IF EXISTS tmp_produtos;
DROP TABLE IF EXISTS tmp_clientes;
DROP TABLE IF EXISTS tmp_categorias;

-- ============================================================
-- FIM DO MODULO 10
-- ============================================================