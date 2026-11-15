-- ============================================================
-- TECHSTORE
-- MODULO 06 - SUBCONSULTAS
-- Arquivo: consultas.sql
-- PostgreSQL 16
-- ============================================================
--
-- OBJETIVO
--
-- Demonstrar diferentes formas de utilização de subconsultas:
--
-- 1. Subconsultas escalares
-- 2. Subconsultas de múltiplas linhas
-- 3. IN e NOT IN
-- 4. EXISTS e NOT EXISTS
-- 5. ANY e ALL
-- 6. Subconsultas correlacionadas
-- 7. Subconsultas no SELECT
-- 8. Subconsultas no FROM
-- 9. Subconsultas aninhadas
-- 10. Subconsultas com agregações
-- 11. Comparações com JOIN e CTE
-- 12. Análise de desempenho
--
-- IMPORTANTE
--
-- Todas as consultas deste arquivo são de leitura.
-- Não modificar dados ou estruturas da TechStore.
-- Não executar novamente os arquivos de seed.
--
-- Execute os exemplos individualmente.
-- Alguns exemplos podem consumir mais recursos dependendo
-- do plano de execução escolhido pelo PostgreSQL.
--
-- ============================================================
-- 01. SUBCONSULTA ESCALAR
-- ============================================================
--
-- Uma subconsulta escalar retorna um único valor.
--
-- O exemplo abaixo compara o preço de cada produto com
-- a média geral dos preços cadastrados.
--
-- Observe:
-- - A subconsulta está dentro do WHERE.
-- - A consulta interna retorna um único valor.
-- - A consulta externa utiliza esse valor na comparação.
--
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM techstore.produtos
)
ORDER BY preco DESC;


-- ============================================================
-- 02. SUBCONSULTA ESCALAR NO SELECT
-- ============================================================
--
-- Uma subconsulta escalar também pode aparecer no SELECT.
--
-- Aqui, a média geral dos preços é apresentada junto
-- com cada produto.
--
-- Observe que a subconsulta não depende da linha externa.
--
SELECT
    p.id,
    p.nome,
    p.preco,
    (
        SELECT AVG(preco)
        FROM techstore.produtos
    ) AS media_geral
FROM techstore.produtos AS p
ORDER BY p.id
LIMIT 20;


-- ============================================================
-- 03. SUBCONSULTA COM IN
-- ============================================================
--
-- IN verifica se um valor pertence ao conjunto retornado
-- pela subconsulta.
--
-- O exemplo encontra clientes que possuem pedidos.
--
SELECT
    c.id,
    c.nome,
    c.email
FROM techstore.clientes AS c
WHERE c.id IN (
    SELECT p.cliente_id
    FROM techstore.pedidos AS p
)
ORDER BY c.id
LIMIT 50;


-- ============================================================
-- 04. SUBCONSULTA COM NOT IN
-- ============================================================
--
-- NOT IN verifica se um valor não pertence ao conjunto.
--
-- ATENÇÃO:
-- Se o conjunto retornado contiver NULL, o resultado
-- poderá ser diferente do esperado.
--
-- Neste exemplo, cliente_id é uma chave estrangeira
-- que pode ser NULL em pedidos? Não se deve presumir.
--
-- A consulta utiliza uma condição explícita para excluir
-- possíveis NULLs do conjunto interno.
--
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE c.id NOT IN (
    SELECT p.cliente_id
    FROM techstore.pedidos AS p
    WHERE p.cliente_id IS NOT NULL
)
ORDER BY c.id
LIMIT 50;


-- ============================================================
-- 05. COMPARAÇÃO ENTRE NOT IN E NOT EXISTS
-- ============================================================
--
-- NOT EXISTS verifica a ausência de registros relacionados.
--
-- A consulta abaixo identifica clientes sem pedidos.
--
-- A condição de correlação conecta o cliente da consulta
-- externa aos pedidos da consulta interna.
--
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM techstore.pedidos AS p
    WHERE p.cliente_id = c.id
)
ORDER BY c.id
LIMIT 50;


-- ============================================================
-- 06. EXISTS
-- ============================================================
--
-- EXISTS verifica se a subconsulta retorna pelo menos
-- uma linha.
--
-- O valor selecionado dentro da subconsulta não é o foco.
-- O que importa é a existência de registros.
--
-- Exemplo: produtos que possuem avaliações.
--
SELECT
    pr.id,
    pr.nome
FROM techstore.produtos AS pr
WHERE EXISTS (
    SELECT 1
    FROM techstore.avaliacoes AS a
    WHERE a.produto_id = pr.id
)
ORDER BY pr.id
LIMIT 50;


-- ============================================================
-- 07. EXISTS COM MAIS DE UMA CONDIÇÃO
-- ============================================================
--
-- A subconsulta pode possuir múltiplas condições.
--
-- Exemplo: clientes que possuem pedidos entregues.
--
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE EXISTS (
    SELECT 1
    FROM techstore.pedidos AS p
    WHERE p.cliente_id = c.id
      AND p.status = 'entregue'
)
ORDER BY c.id
LIMIT 50;


-- ============================================================
-- 08. ANY
-- ============================================================
--
-- ANY compara um valor com os valores retornados
-- pela subconsulta.
--
-- A condição será verdadeira se pelo menos uma
-- comparação for verdadeira.
--
-- Exemplo: produtos cujo preço é superior ao preço
-- de pelo menos um produto da categoria 1.
--
SELECT
    p.id,
    p.nome,
    p.preco
FROM techstore.produtos AS p
WHERE p.preco > ANY (
    SELECT p2.preco
    FROM techstore.produtos AS p2
    WHERE p2.categoria_id = 1
)
ORDER BY p.preco DESC
LIMIT 50;


-- ============================================================
-- 09. ALL
-- ============================================================
--
-- ALL compara um valor com todos os valores retornados
-- pela subconsulta.
--
-- A condição somente será verdadeira se todas as
-- comparações forem verdadeiras.
--
-- Exemplo: produtos cujo preço é superior ao preço
-- de todos os produtos da categoria 1.
--
SELECT
    p.id,
    p.nome,
    p.preco
FROM techstore.produtos AS p
WHERE p.preco > ALL (
    SELECT p2.preco
    FROM techstore.produtos AS p2
    WHERE p2.categoria_id = 1
)
ORDER BY p.preco DESC
LIMIT 50;


-- ============================================================
-- 10. SUBCONSULTA CORRELACIONADA
-- ============================================================
--
-- Uma subconsulta correlacionada utiliza valores
-- provenientes da consulta externa.
--
-- Neste exemplo, cada produto é comparado com a média
-- de preços dos produtos da mesma categoria.
--
-- A condição p2.categoria_id = p.categoria_id
-- cria a correlação.
--
SELECT
    p.id,
    p.nome,
    p.categoria_id,
    p.preco
FROM techstore.produtos AS p
WHERE p.preco > (
    SELECT AVG(p2.preco)
    FROM techstore.produtos AS p2
    WHERE p2.categoria_id = p.categoria_id
)
ORDER BY p.categoria_id, p.preco DESC;


-- ============================================================
-- 11. SUBCONSULTA CORRELACIONADA COM COUNT
-- ============================================================
--
-- A subconsulta calcula a quantidade de pedidos
-- de cada cliente.
--
-- O resultado depende do cliente da consulta externa.
--
SELECT
    c.id,
    c.nome,
    (
        SELECT COUNT(*)
        FROM techstore.pedidos AS p
        WHERE p.cliente_id = c.id
    ) AS quantidade_pedidos
FROM techstore.clientes AS c
ORDER BY quantidade_pedidos DESC
LIMIT 30;


-- ============================================================
-- 12. SUBCONSULTA CORRELACIONADA COM AVG
-- ============================================================
--
-- Compara o salário de cada funcionário com a média
-- salarial do respectivo departamento.
--
-- A subconsulta é executada conceitualmente para cada
-- funcionário, considerando seu departamento.
--
SELECT
    f.id,
    f.nome,
    f.departamento_id,
    f.salario
FROM techstore.funcionarios AS f
WHERE f.salario > (
    SELECT AVG(f2.salario)
    FROM techstore.funcionarios AS f2
    WHERE f2.departamento_id = f.departamento_id
)
ORDER BY f.departamento_id, f.salario DESC;


-- ============================================================
-- 13. SUBCONSULTA NO FROM
-- ============================================================
--
-- Uma subconsulta no FROM funciona como uma tabela derivada.
--
-- Ela precisa receber um alias.
--
-- Primeiro, a consulta interna calcula a quantidade
-- de pedidos por cliente.
--
-- Depois, a consulta externa filtra esses resultados.
--
SELECT
    resultado.cliente_id,
    resultado.quantidade_pedidos
FROM (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade_pedidos
    FROM techstore.pedidos
    GROUP BY cliente_id
) AS resultado
WHERE resultado.quantidade_pedidos > 5
ORDER BY resultado.quantidade_pedidos DESC;


-- ============================================================
-- 14. SUBCONSULTA NO FROM COM AGREGAÇÃO
-- ============================================================
--
-- A tabela derivada calcula a quantidade de produtos
-- e o preço médio por categoria.
--
-- A consulta externa utiliza esses resultados.
--
SELECT
    resumo.categoria_id,
    resumo.quantidade_produtos,
    resumo.preco_medio
FROM (
    SELECT
        categoria_id,
        COUNT(*) AS quantidade_produtos,
        AVG(preco) AS preco_medio
    FROM techstore.produtos
    GROUP BY categoria_id
) AS resumo
ORDER BY resumo.preco_medio DESC;


-- ============================================================
-- 15. SUBCONSULTA ANINHADA
-- ============================================================
--
-- Uma subconsulta pode conter outra subconsulta.
--
-- A consulta mais interna calcula uma média geral.
-- A intermediária identifica categorias com média
-- superior a essa média geral.
-- A externa recupera produtos dessas categorias.
--
SELECT
    p.id,
    p.nome,
    p.categoria_id,
    p.preco
FROM techstore.produtos AS p
WHERE p.categoria_id IN (
    SELECT p2.categoria_id
    FROM techstore.produtos AS p2
    GROUP BY p2.categoria_id
    HAVING AVG(p2.preco) > (
        SELECT AVG(preco)
        FROM techstore.produtos
    )
)
ORDER BY p.categoria_id, p.preco DESC;


-- ============================================================
-- 16. SUBCONSULTA COM MAX
-- ============================================================
--
-- Identifica produtos que possuem o maior preço
-- cadastrado na tabela.
--
-- A subconsulta retorna o maior preço.
--
-- Observe que a consulta pode retornar mais de um produto
-- caso exista empate.
--
SELECT
    p.id,
    p.nome,
    p.preco
FROM techstore.produtos AS p
WHERE p.preco = (
    SELECT MAX(preco)
    FROM techstore.produtos
);


-- ============================================================
-- 17. SUBCONSULTA COM MIN
-- ============================================================
--
-- Identifica produtos que possuem o menor preço
-- cadastrado na tabela.
--
-- Também pode retornar mais de um produto em caso de empate.
--
SELECT
    p.id,
    p.nome,
    p.preco
FROM techstore.produtos AS p
WHERE p.preco = (
    SELECT MIN(preco)
    FROM techstore.produtos
);


-- ============================================================
-- 18. SUBCONSULTA COM SUM
-- ============================================================
--
-- Calcula o total de unidades vendidas por produto.
--
-- A subconsulta é correlacionada com cada produto.
--
-- A quantidade é multiplicada pela quantidade de unidades
-- de cada item vendido.
--
SELECT
    p.id,
    p.nome,
    (
        SELECT COALESCE(SUM(ip.quantidade), 0)
        FROM techstore.itens_pedido AS ip
        WHERE ip.produto_id = p.id
    ) AS unidades_vendidas
FROM techstore.produtos AS p
ORDER BY unidades_vendidas DESC
LIMIT 30;


-- ============================================================
-- 19. SUBCONSULTA COM HAVING
-- ============================================================
--
-- A consulta interna agrupa os pedidos por cliente.
-- O HAVING filtra os grupos.
--
-- A consulta externa utiliza os clientes identificados.
--
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE c.id IN (
    SELECT p.cliente_id
    FROM techstore.pedidos AS p
    WHERE p.cliente_id IS NOT NULL
    GROUP BY p.cliente_id
    HAVING COUNT(*) > 5
)
ORDER BY c.id;


-- ============================================================
-- 20. JOIN VERSUS EXISTS
-- ============================================================
--
-- As duas consultas abaixo identificam clientes que possuem
-- pelo menos um pedido.
--
-- Primeira abordagem: EXISTS.
--
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE EXISTS (
    SELECT 1
    FROM techstore.pedidos AS p
    WHERE p.cliente_id = c.id
)
ORDER BY c.id
LIMIT 50;


-- Segunda abordagem: JOIN com DISTINCT.
--
-- O DISTINCT é necessário para eliminar repetições
-- causadas por clientes com vários pedidos.
--
SELECT DISTINCT
    c.id,
    c.nome
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
ORDER BY c.id
LIMIT 50;


-- ============================================================
-- 21. CTE VERSUS SUBCONSULTA
-- ============================================================
--
-- Uma subconsulta no FROM pode ser substituída por uma CTE.
--
-- Abaixo, as duas abordagens calculam a quantidade
-- de pedidos por cliente e filtram os resultados.
--
-- Abordagem com subconsulta:
--
SELECT
    resultado.cliente_id,
    resultado.quantidade
FROM (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade
    FROM techstore.pedidos
    GROUP BY cliente_id
) AS resultado
WHERE resultado.quantidade > 5
ORDER BY resultado.quantidade DESC;


-- Abordagem com CTE:
--
WITH pedidos_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade
    FROM techstore.pedidos
    GROUP BY cliente_id
)
SELECT
    cliente_id,
    quantidade
FROM pedidos_por_cliente
WHERE quantidade > 5
ORDER BY quantidade DESC;


-- ============================================================
-- 22. SUBCONSULTA E TRATAMENTO DE NULL
-- ============================================================
--
-- A subconsulta retorna registros de acessos associados
-- a clientes.
--
-- cliente_id pode ser NULL na tabela acessos.
--
-- O filtro explícito evita que valores NULL façam parte
-- do conjunto utilizado por NOT IN.
--
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE c.id NOT IN (
    SELECT a.cliente_id
    FROM techstore.acessos AS a
    WHERE a.cliente_id IS NOT NULL
)
ORDER BY c.id
LIMIT 50;


-- ============================================================
-- 23. SUBCONSULTA COM DISTINCT
-- ============================================================
--
-- DISTINCT pode ser utilizado dentro de uma subconsulta
-- quando o conjunto de valores únicos é relevante.
--
-- Neste exemplo, são recuperados produtos associados
-- a categorias que possuem produtos ativos.
--
SELECT
    p.id,
    p.nome,
    p.categoria_id
FROM techstore.produtos AS p
WHERE p.categoria_id IN (
    SELECT DISTINCT p2.categoria_id
    FROM techstore.produtos AS p2
    WHERE p2.ativo = TRUE
)
ORDER BY p.categoria_id, p.id
LIMIT 50;


-- ============================================================
-- 24. SUBCONSULTA COM DATA
-- ============================================================
--
-- A consulta interna calcula a data mais recente
-- de pedido de cada cliente.
--
-- A consulta externa apresenta clientes cujo último
-- pedido ocorreu dentro dos últimos 30 dias em relação
-- à data atual do servidor.
--
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE (
    SELECT MAX(p.data_pedido)
    FROM techstore.pedidos AS p
    WHERE p.cliente_id = c.id
) >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY c.id;


-- ============================================================
-- 25. EXPLAIN
-- ============================================================
--
-- EXPLAIN mostra o plano estimado da consulta.
--
-- Não executa a consulta.
--
-- Utilize para observar:
-- - Tipo de operação.
-- - Estimativa de linhas.
-- - Custo estimado.
-- - Possíveis acessos por índice.
--
EXPLAIN
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE EXISTS (
    SELECT 1
    FROM techstore.pedidos AS p
    WHERE p.cliente_id = c.id
);


-- ============================================================
-- 26. EXPLAIN ANALYZE
-- ============================================================
--
-- EXPLAIN ANALYZE executa a consulta e apresenta
-- informações reais da execução.
--
-- Pode consumir recursos de CPU, memória e I/O.
--
-- Execute individualmente e compare com EXPLAIN.
--
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
WHERE EXISTS (
    SELECT 1
    FROM techstore.pedidos AS p
    WHERE p.cliente_id = c.id
);


-- ============================================================
-- 27. COMPARAÇÃO DE PLANOS
-- ============================================================
--
-- Compare as duas abordagens abaixo.
--
-- Observe:
-- - Planning Time.
-- - Execution Time.
-- - Actual Rows.
-- - Estimated Rows.
-- - Shared Hit Blocks.
-- - Shared Read Blocks.
-- - Nós de execução.
--
-- Não presuma que EXISTS, IN ou JOIN será sempre mais rápido.
-- O resultado depende do contexto, dos índices e do plano
-- escolhido pelo PostgreSQL.
--
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.id,
    p.nome
FROM techstore.produtos AS p
WHERE p.id IN (
    SELECT ip.produto_id
    FROM techstore.itens_pedido AS ip
);


-- ============================================================
-- 28. SUBCONSULTA COM AGREGAÇÃO PRÉVIA
-- ============================================================
--
-- Uma subconsulta derivada pode agregar dados antes
-- de relacioná-los com outras tabelas.
--
-- Aqui, a quantidade de itens é calculada por produto.
--
-- Isso permite trabalhar com uma linha por produto
-- na tabela derivada.
--
SELECT
    p.id,
    p.nome,
    COALESCE(v.unidades_vendidas, 0) AS unidades_vendidas
FROM techstore.produtos AS p
LEFT JOIN (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
) AS v
    ON v.produto_id = p.id
ORDER BY unidades_vendidas DESC
LIMIT 30;


-- ============================================================
-- 29. SUBCONSULTA PARA COMPARAÇÃO DE AVALIAÇÕES
-- ============================================================
--
-- Compara a nota de cada avaliação com a média geral
-- das avaliações.
--
-- A subconsulta é independente da linha externa.
--
SELECT
    a.id,
    a.produto_id,
    a.cliente_id,
    a.nota
FROM techstore.avaliacoes AS a
WHERE a.nota > (
    SELECT AVG(nota)
    FROM techstore.avaliacoes
)
ORDER BY a.nota DESC, a.id
LIMIT 50;


-- ============================================================
-- 30. SUBCONSULTA CORRELACIONADA COM NOT EXISTS
-- ============================================================
--
-- Identifica produtos que não possuem avaliações.
--
-- NOT EXISTS permite verificar a ausência de registros
-- relacionados sem depender de uma lista de valores.
--
SELECT
    p.id,
    p.nome
FROM techstore.produtos AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM techstore.avaliacoes AS a
    WHERE a.produto_id = p.id
)
ORDER BY p.id;


-- ============================================================
-- FIM DO ARQUIVO
-- ============================================================
--
-- ORIENTAÇÃO DE ESTUDO
--
-- Para cada exemplo:
--
-- 1. Identifique a consulta principal.
-- 2. Identifique a subconsulta.
-- 3. Verifique o que a subconsulta retorna.
-- 4. Identifique se existe correlação.
-- 5. Explique o operador utilizado.
-- 6. Pense no comportamento diante de NULL.
-- 7. Considere resultados vazios e múltiplas linhas.
-- 8. Verifique a granularidade do resultado.
-- 9. Compare alternativas quando possível.
-- 10. Analise o plano de execução nos exemplos indicados.
--
-- Este arquivo é material de estudo.
-- As atividades e os desafios devem ser resolvidos
-- independentemente, sem copiar estes exemplos como gabarito.
-- ============================================================