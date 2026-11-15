# Consultas SQL — Módulo 02
## SELECT e filtros

**Banco:** TechStore  
**SGBD:** PostgreSQL 16  
**Schema:** `techstore`  
**Objetivo:** Material de demonstração e consulta para os conteúdos do Módulo 02.

---

## Orientações

- Todas as consultas deste arquivo são de leitura (`SELECT`).
- Não execute comandos de alteração de estrutura ou dados durante este módulo.
- Execute uma consulta por vez para observar os resultados.
- Antes de alterar uma consulta, tente prever o resultado.
- Observe a diferença entre quantidade de linhas retornadas e quantidade de registros existentes.

```sql
-- ============================================================
-- TECHSTORE SQL LAB
-- MODULO 02 - SELECT E FILTROS
-- PostgreSQL 16
-- ============================================================

-- Schema utilizado:
-- techstore

-- ============================================================
-- 01. SELECT - CONSULTAS BASICAS
-- ============================================================

-- 01.1 Todas as colunas de uma tabela.
SELECT *
FROM techstore.produtos
LIMIT 10;

-- 01.2 Selecionando somente as colunas necessárias.
SELECT
    id,
    nome,
    sku,
    preco
FROM techstore.produtos
LIMIT 10;

-- 01.3 Consultando clientes.
SELECT
    id,
    nome,
    email,
    data_cadastro,
    ativo
FROM techstore.clientes
LIMIT 10;


-- ============================================================
-- 02. DISTINCT - VALORES DISTINTOS
-- ============================================================

-- 02.1 Categorias cadastradas.
SELECT DISTINCT
    categoria_id
FROM techstore.produtos
ORDER BY categoria_id;

-- 02.2 Status existentes nos pedidos.
SELECT DISTINCT
    status
FROM techstore.pedidos
ORDER BY status;

-- 02.3 Combinações de dispositivo e origem dos acessos.
SELECT DISTINCT
    dispositivo,
    origem
FROM techstore.acessos
ORDER BY dispositivo, origem;


-- ============================================================
-- 03. WHERE - FILTRANDO REGISTROS
-- ============================================================

-- 03.1 Produtos ativos.
SELECT
    id,
    nome,
    preco,
    ativo
FROM techstore.produtos
WHERE ativo = TRUE
LIMIT 20;

-- 03.2 Produtos inativos.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE ativo = FALSE
LIMIT 20;

-- 03.3 Pedidos cancelados.
SELECT
    id,
    cliente_id,
    data_pedido,
    status
FROM techstore.pedidos
WHERE status = 'cancelado'
LIMIT 20;


-- ============================================================
-- 04. OPERADORES DE COMPARACAO
-- ============================================================

-- 04.1 Produtos com preço superior a 1000.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco > 1000
ORDER BY preco DESC
LIMIT 20;

-- 04.2 Produtos com preço menor ou igual a 500.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco <= 500
ORDER BY preco;

-- 04.3 Funcionários com salário superior a 5000.
SELECT
    id,
    nome,
    salario
FROM techstore.funcionarios
WHERE salario > 5000
ORDER BY salario DESC;

-- 04.4 Pedidos realizados a partir de uma data.
SELECT
    id,
    cliente_id,
    data_pedido
FROM techstore.pedidos
WHERE data_pedido >= TIMESTAMP '2025-01-01 00:00:00'
LIMIT 20;


-- ============================================================
-- 05. OPERADORES LOGICOS
-- ============================================================

-- 05.1 AND:
-- As duas condições precisam ser verdadeiras.
SELECT
    id,
    nome,
    preco,
    ativo
FROM techstore.produtos
WHERE ativo = TRUE
  AND preco > 1000
LIMIT 20;

-- 05.2 OR:
-- Pelo menos uma condição precisa ser verdadeira.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco < 100
   OR preco > 3000
LIMIT 20;

-- 05.3 NOT:
-- Inverte o resultado lógico da condição.
SELECT
    id,
    nome,
    ativo
FROM techstore.produtos
WHERE NOT ativo
LIMIT 20;

-- 05.4 Precedência dos operadores.
SELECT
    id,
    nome,
    preco,
    ativo
FROM techstore.produtos
WHERE ativo = TRUE
  AND (preco < 100 OR preco > 3000)
LIMIT 20;


-- ============================================================
-- 06. IN E BETWEEN
-- ============================================================

-- 06.1 IN:
-- Compara um valor com uma lista de possibilidades.
SELECT
    id,
    status,
    cliente_id,
    data_pedido
FROM techstore.pedidos
WHERE status IN ('entregue', 'cancelado')
LIMIT 20;

-- 06.2 NOT IN:
-- Exclui os valores informados.
SELECT
    id,
    status
FROM techstore.pedidos
WHERE status NOT IN ('entregue', 'cancelado')
LIMIT 20;

-- 06.3 BETWEEN:
-- Intervalo inclusivo.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco BETWEEN 500 AND 1500
ORDER BY preco;

-- 06.4 BETWEEN com datas.
SELECT
    id,
    cliente_id,
    data_pedido
FROM techstore.pedidos
WHERE data_pedido BETWEEN
      TIMESTAMP '2025-01-01 00:00:00'
      AND TIMESTAMP '2025-01-31 23:59:59'
ORDER BY data_pedido;


-- ============================================================
-- 07. LIKE E ILIKE
-- ============================================================

-- 07.1 LIKE:
-- Busca nomes que começam com determinado texto.
SELECT
    id,
    nome
FROM techstore.produtos
WHERE nome LIKE 'Produto Tech 1%'
LIMIT 20;

-- 07.2 ILIKE:
-- Busca sem diferenciar letras maiúsculas e minúsculas.
SELECT
    id,
    nome
FROM techstore.produtos
WHERE nome ILIKE '%TECH%'
LIMIT 20;

-- 07.3 Busca por trecho de e-mail.
SELECT
    id,
    nome,
    email
FROM techstore.clientes
WHERE email LIKE '%@email.test'
LIMIT 20;

-- 07.4 Busca por trecho em uma mensagem.
SELECT
    id,
    nivel,
    modulo,
    mensagem
FROM techstore.logs_sistema
WHERE mensagem ILIKE '%evento%'
LIMIT 20;


-- ============================================================
-- 08. NULL - VALORES AUSENTES
-- ============================================================

-- 08.1 IS NULL:
-- Acessos sem cliente associado.
SELECT
    id,
    data_acesso,
    pagina,
    dispositivo
FROM techstore.acessos
WHERE cliente_id IS NULL
LIMIT 20;

-- 08.2 IS NOT NULL:
-- Acessos com cliente associado.
SELECT
    id,
    cliente_id,
    data_acesso,
    pagina
FROM techstore.acessos
WHERE cliente_id IS NOT NULL
LIMIT 20;

-- 08.3 Funcionários sem departamento associado.
SELECT
    id,
    nome,
    departamento_id
FROM techstore.funcionarios
WHERE departamento_id IS NULL;

-- 08.4 Comparação conceitual:
-- NULL não deve ser testado usando = ou <>.
-- Utilize IS NULL ou IS NOT NULL.


-- ============================================================
-- 09. ORDER BY - ORDENACAO
-- ============================================================

-- 09.1 Ordem crescente.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
ORDER BY preco ASC
LIMIT 20;

-- 09.2 Ordem decrescente.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
ORDER BY preco DESC
LIMIT 20;

-- 09.3 Ordenação por múltiplas colunas.
SELECT
    id,
    status,
    data_pedido
FROM techstore.pedidos
ORDER BY status ASC, data_pedido DESC
LIMIT 30;

-- 09.4 Tratamento explícito de NULL na ordenação.
SELECT
    id,
    cliente_id,
    data_acesso
FROM techstore.acessos
ORDER BY cliente_id ASC NULLS LAST
LIMIT 30;


-- ============================================================
-- 10. LIMIT E OFFSET - PAGINACAO
-- ============================================================

-- 10.1 Primeiros 10 produtos.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
ORDER BY id
LIMIT 10;

-- 10.2 Próximos 10 produtos.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
ORDER BY id
LIMIT 10 OFFSET 10;

-- 10.3 Terceira página com 10 registros.
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
ORDER BY id
LIMIT 10 OFFSET 20;

-- 10.4 Paginação determinística:
-- Utilize uma ordenação que permita identificar
-- a posição dos registros sem ambiguidades.


-- ============================================================
-- 11. CONSTRUINDO CONSULTAS COMPOSTAS
-- ============================================================

-- 11.1 Consulta com múltiplas condições.
SELECT
    id,
    nome,
    preco,
    ativo,
    data_cadastro
FROM techstore.produtos
WHERE ativo = TRUE
  AND preco BETWEEN 500 AND 2500
  AND data_cadastro >= DATE '2023-01-01'
ORDER BY preco DESC, id ASC
LIMIT 30;

-- 11.2 Consulta sobre pedidos.
SELECT
    id,
    cliente_id,
    data_pedido,
    status,
    desconto,
    valor_frete
FROM techstore.pedidos
WHERE status IN ('entregue', 'em transporte')
  AND data_pedido >= TIMESTAMP '2025-01-01 00:00:00'
ORDER BY data_pedido DESC
LIMIT 30;

-- 11.3 Consulta sobre avaliações.
SELECT
    id,
    cliente_id,
    produto_id,
    nota,
    data_avaliacao
FROM techstore.avaliacoes
WHERE nota >= 4
  AND data_avaliacao BETWEEN DATE '2024-01-01'
                         AND DATE '2025-12-31'
ORDER BY nota DESC, data_avaliacao DESC
LIMIT 30;


-- ============================================================
-- 12. EXPLAIN - ANALISE DE CONSULTAS
-- ============================================================

-- 12.1 Plano estimado:
-- Não executa a consulta.
EXPLAIN
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE id = 100;

-- 12.2 Plano com execução real:
-- Executa a consulta e apresenta métricas.
EXPLAIN ANALYZE
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE id = 100;

-- 12.3 Plano com estatísticas de buffers.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    cliente_id,
    data_pedido,
    status
FROM techstore.pedidos
WHERE cliente_id = 100
ORDER BY data_pedido DESC;

-- 12.4 Comparação de filtros:
-- Observe os planos e os registros examinados.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    data_acesso,
    pagina
FROM techstore.acessos
WHERE data_acesso >= TIMESTAMP '2025-01-01 00:00:00'
ORDER BY data_acesso DESC
LIMIT 50;


-- ============================================================
-- FIM DO ARQUIVO
-- ============================================================
```

---

## Observações importantes

1. `SELECT *` é útil para exploração, mas evite utilizá-lo indiscriminadamente em consultas de produção.
2. `BETWEEN` inclui os dois extremos do intervalo. Para intervalos de timestamp, fique atento aos horários.
3. `NULL` não é igual a zero, string vazia ou `FALSE`.
4. `ORDER BY` deve ser utilizado com critério, especialmente em paginação.
5. `LIMIT` restringe o resultado, mas não significa necessariamente que o PostgreSQL examinou apenas aquela quantidade de registros.
6. `EXPLAIN ANALYZE` executa a consulta. Utilize-o com cautela em tabelas grandes.

**Este arquivo não contém o gabarito das atividades.** Ele serve como laboratório de exemplos para consulta, experimentação e comparação dos resultados.