/*
===============================================================================
TECHSTORE — MÓDULO 04
AGREGAÇÕES SQL
===============================================================================

Objetivo:
Apresentar exemplos demonstrativos de funções agregadas, agrupamentos,
filtragem de grupos e construção de indicadores.

Banco: PostgreSQL 16
Schema: techstore

IMPORTANTE:
- Este arquivo contém somente consultas de leitura.
- Não modifica tabelas ou registros.
- Não contém respostas das atividades.
- Execute os exemplos individualmente.
- Observe os resultados e tente explicar o comportamento de cada consulta.

===============================================================================
*/

-- ============================================================================
-- 01. COUNT — CONTAGEM
-- ============================================================================

-- COUNT(*) conta todas as linhas do resultado.
SELECT
    COUNT(*) AS total_clientes
FROM techstore.clientes;


-- COUNT(coluna) conta somente os valores não nulos daquela coluna.
SELECT
    COUNT(telefone) AS clientes_com_telefone,
    COUNT(*) AS total_clientes
FROM techstore.clientes;


-- COUNT(DISTINCT coluna) conta valores únicos e não nulos.
SELECT
    COUNT(DISTINCT genero) AS generos_diferentes
FROM techstore.clientes;


-- ============================================================================
-- 02. SUM — SOMA
-- ============================================================================

-- Soma todos os valores de uma coluna numérica.
SELECT
    SUM(preco) AS soma_precos
FROM techstore.produtos;


-- Expressões também podem ser utilizadas dentro de funções agregadas.
SELECT
    SUM(quantidade * preco_unitario) AS valor_bruto_itens
FROM techstore.itens_pedido;


-- COALESCE permite definir um valor alternativo caso a agregação retorne NULL.
SELECT
    COALESCE(SUM(orcamento), 0) AS orcamento_total
FROM techstore.campanhas;


-- ============================================================================
-- 03. AVG — MÉDIA
-- ============================================================================

-- Calcula a média aritmética dos valores não nulos.
SELECT
    AVG(preco) AS preco_medio
FROM techstore.produtos;


-- ROUND permite controlar a quantidade de casas decimais.
SELECT
    ROUND(AVG(preco), 2) AS preco_medio
FROM techstore.produtos;


-- Exemplo de média ponderada.
-- A quantidade representa o peso de cada preço no cálculo.
SELECT
    SUM(quantidade * preco_unitario)
        / NULLIF(SUM(quantidade), 0) AS preco_medio_ponderado
FROM techstore.itens_pedido;


-- ============================================================================
-- 04. MIN E MAX — EXTREMOS
-- ============================================================================

-- Identifica os menores e maiores valores.
SELECT
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM techstore.produtos;


-- Também podem ser utilizados com datas.
SELECT
    MIN(data_pedido) AS primeiro_pedido,
    MAX(data_pedido) AS ultimo_pedido
FROM techstore.pedidos;


-- ============================================================================
-- 05. GROUP BY — AGRUPAMENTO
-- ============================================================================

-- Agrupa os registros por uma coluna.
SELECT
    status,
    COUNT(*) AS quantidade
FROM techstore.pedidos
GROUP BY status;


-- Agrupa por mais de uma coluna.
SELECT
    nivel,
    modulo,
    COUNT(*) AS total_logs
FROM techstore.logs_sistema
GROUP BY
    nivel,
    modulo;


-- Combina agrupamento com múltiplas funções agregadas.
SELECT
    departamento_id,
    COUNT(*) AS total_funcionarios,
    ROUND(AVG(salario), 2) AS salario_medio,
    MIN(salario) AS menor_salario,
    MAX(salario) AS maior_salario
FROM techstore.funcionarios
GROUP BY departamento_id;


-- ============================================================================
-- 06. ORDER BY COM AGREGAÇÕES
-- ============================================================================

-- Os resultados agrupados também podem ser ordenados.
SELECT
    status,
    COUNT(*) AS quantidade
FROM techstore.pedidos
GROUP BY status
ORDER BY quantidade DESC;


-- Ordenação por mais de um critério.
SELECT
    dispositivo,
    origem,
    COUNT(*) AS total_acessos
FROM techstore.acessos
GROUP BY
    dispositivo,
    origem
ORDER BY
    total_acessos DESC,
    dispositivo ASC;


-- ============================================================================
-- 07. HAVING — FILTRAGEM DE GRUPOS
-- ============================================================================

-- HAVING filtra os grupos depois da agregação.
SELECT
    nivel,
    COUNT(*) AS total_logs
FROM techstore.logs_sistema
GROUP BY nivel
HAVING COUNT(*) > 100;


-- HAVING pode utilizar outras funções agregadas.
SELECT
    departamento_id,
    ROUND(AVG(salario), 2) AS salario_medio
FROM techstore.funcionarios
GROUP BY departamento_id
HAVING AVG(salario) > 5000;


-- ============================================================================
-- 08. WHERE E HAVING
-- ============================================================================

-- WHERE filtra registros antes do agrupamento.
-- HAVING filtra grupos depois do agrupamento.
SELECT
    status,
    COUNT(*) AS quantidade
FROM techstore.pedidos
WHERE data_pedido >= DATE '2025-01-01'
GROUP BY status
HAVING COUNT(*) > 10
ORDER BY quantidade DESC;


-- ============================================================================
-- 09. DISTINCT EM AGREGAÇÕES
-- ============================================================================

-- Conta clientes diferentes que aparecem nos acessos.
SELECT
    COUNT(cliente_id) AS total_referencias_cliente,
    COUNT(DISTINCT cliente_id) AS clientes_distintos
FROM techstore.acessos;


-- DISTINCT também pode ser aplicado em SUM.
-- Compare os dois resultados e observe que eles representam métricas diferentes.
SELECT
    SUM(preco_unitario) AS soma_das_ocorrencias,
    SUM(DISTINCT preco_unitario) AS soma_dos_precos_unicos
FROM techstore.itens_pedido;


-- ============================================================================
-- 10. AGREGAÇÕES CONDICIONAIS COM CASE
-- ============================================================================

-- CASE permite calcular indicadores diferentes na mesma consulta.
SELECT
    COUNT(*) AS total_pedidos,

    COUNT(
        CASE
            WHEN status = 'entregue' THEN 1
        END
    ) AS pedidos_entregues,

    COUNT(
        CASE
            WHEN status = 'cancelado' THEN 1
        END
    ) AS pedidos_cancelados

FROM techstore.pedidos;


-- SUM também pode trabalhar com condições.
SELECT
    SUM(
        CASE
            WHEN status = 'entregue' THEN 1
            ELSE 0
        END
    ) AS entregues,

    SUM(
        CASE
            WHEN status = 'cancelado' THEN 1
            ELSE 0
        END
    ) AS cancelados

FROM techstore.pedidos;


-- ============================================================================
-- 11. AGREGAÇÕES CONDICIONAIS COM FILTER
-- ============================================================================

-- FILTER aplica uma condição individual a uma função agregada.
SELECT
    COUNT(*) AS total_pedidos,

    COUNT(*) FILTER (
        WHERE status = 'entregue'
    ) AS pedidos_entregues,

    COUNT(*) FILTER (
        WHERE status = 'cancelado'
    ) AS pedidos_cancelados,

    COUNT(*) FILTER (
        WHERE status = 'processando'
    ) AS pedidos_processando

FROM techstore.pedidos;


-- FILTER também funciona com SUM.
SELECT
    SUM(quantidade) AS unidades_totais,

    SUM(quantidade) FILTER (
        WHERE tipo = 'entrada'
    ) AS unidades_entrada,

    SUM(quantidade) FILTER (
        WHERE tipo = 'saida'
    ) AS unidades_saida

FROM techstore.movimentacoes_estoque;


-- ============================================================================
-- 12. AGREGAÇÕES POR PERÍODO
-- ============================================================================

-- DATE_TRUNC agrupa datas por período.
SELECT
    DATE_TRUNC('month', data_pedido) AS mes,
    COUNT(*) AS total_pedidos
FROM techstore.pedidos
GROUP BY DATE_TRUNC('month', data_pedido)
ORDER BY mes;


-- Agrupamento por ano e mês.
SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS total_pedidos
FROM techstore.pedidos
GROUP BY
    EXTRACT(YEAR FROM data_pedido),
    EXTRACT(MONTH FROM data_pedido)
ORDER BY
    ano,
    mes;


-- ============================================================================
-- 13. AGREGAÇÕES EM ETAPAS
-- ============================================================================

-- Primeiro nível: calcula o valor bruto de cada pedido.
-- Segundo nível: calcula indicadores sobre os valores por pedido.
--
-- A subconsulta cria um conjunto intermediário com uma linha por pedido.

SELECT
    COUNT(*) AS total_pedidos,
    ROUND(AVG(valor_bruto), 2) AS media_por_pedido,
    MIN(valor_bruto) AS menor_valor,
    MAX(valor_bruto) AS maior_valor
FROM (
    SELECT
        pedido_id,
        SUM(quantidade * preco_unitario) AS valor_bruto
    FROM techstore.itens_pedido
    GROUP BY pedido_id
) AS valores_por_pedido;


-- ============================================================================
-- 14. CTE COM AGREGAÇÃO
-- ============================================================================

-- WITH permite nomear uma etapa intermediária.
-- A consulta principal utiliza o resultado produzido pela CTE.

WITH indicadores_produtos AS (
    SELECT
        ativo,
        COUNT(*) AS total_produtos,
        ROUND(AVG(preco), 2) AS preco_medio,
        MIN(preco) AS menor_preco,
        MAX(preco) AS maior_preco
    FROM techstore.produtos
    GROUP BY ativo
)
SELECT
    ativo,
    total_produtos,
    preco_medio,
    menor_preco,
    maior_preco
FROM indicadores_produtos
ORDER BY ativo;


-- ============================================================================
-- 15. CUIDADOS COM NULL
-- ============================================================================

-- COUNT(*) conta linhas.
-- COUNT(coluna) ignora valores NULL.
-- COUNT(DISTINCT coluna) também ignora NULL.

SELECT
    COUNT(*) AS total_acessos,
    COUNT(cliente_id) AS acessos_com_cliente,
    COUNT(*) - COUNT(cliente_id) AS acessos_sem_cliente,
    COUNT(DISTINCT cliente_id) AS clientes_distintos
FROM techstore.acessos;


-- Entregas podem não possuir data de entrega preenchida.
SELECT
    COUNT(*) AS total_entregas,
    COUNT(data_entrega) AS entregas_com_data,
    COUNT(*) - COUNT(data_entrega) AS entregas_sem_data
FROM techstore.entregas;


-- ============================================================================
-- 16. EXPLAIN — ANÁLISE DE EXECUÇÃO
-- ============================================================================

-- EXPLAIN mostra o plano estimado sem executar a consulta.
EXPLAIN
SELECT
    status,
    COUNT(*)
FROM techstore.pedidos
GROUP BY status;


-- EXPLAIN ANALYZE executa a consulta e apresenta tempos reais.
-- BUFFERS apresenta informações sobre acesso a blocos de dados.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    status,
    COUNT(*)
FROM techstore.pedidos
GROUP BY status;


-- Compare o plano de uma agregação simples com uma agregação filtrada.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    DATE_TRUNC('month', data_acesso) AS mes,
    COUNT(*) AS total_acessos
FROM techstore.acessos
WHERE data_acesso >= TIMESTAMP '2025-01-01'
GROUP BY DATE_TRUNC('month', data_acesso)
ORDER BY mes;


-- ============================================================================
-- FIM DO ARQUIVO
-- ============================================================================

/*
RECOMENDAÇÕES DE ESTUDO:

1. Execute uma consulta por vez.
2. Antes de executar, tente prever o tipo de resultado.
3. Observe a diferença entre COUNT(*), COUNT(coluna) e COUNT(DISTINCT).
4. Compare WHERE e HAVING.
5. Compare CASE e FILTER.
6. Observe como GROUP BY altera a granularidade.
7. Analise as consultas compostas e suas etapas intermediárias.
8. Utilize EXPLAIN ANALYZE para observar o comportamento real.

Não memorize apenas a sintaxe.
Procure compreender o significado de cada resultado.

As atividades oficiais estão no arquivo atividades.md.
A validação de domínio está no arquivo validacao.md.
*/