-- ============================================================
-- TECHSTORE
-- MODULO 09 - WINDOW FUNCTIONS
-- PostgreSQL 16
-- ============================================================
--
-- Objetivo:
-- Estudar funções de janela, rankings, particionamento,
-- ordenacao, frames, navegacao e agregacoes analiticas.
--
-- IMPORTANTE:
-- 1. Todos os exemplos sao consultas de leitura.
-- 2. Nenhum exemplo modifica dados.
-- 3. Nao executar novamente a seed.
-- 4. EXPLAIN ANALYZE executa a consulta analisada.
-- 5. Executar os exemplos individualmente.
--
-- ============================================================


-- ============================================================
-- 01. COUNT OVER - CONTAGEM GLOBAL
-- ============================================================

SELECT
    id,
    nome,
    COUNT(*) OVER () AS total_produtos
FROM techstore.produtos;


-- ============================================================
-- 02. AVG OVER - MEDIA GLOBAL
-- ============================================================

SELECT
    id,
    nome,
    preco,
    AVG(preco) OVER () AS media_geral
FROM techstore.produtos;


-- ============================================================
-- 03. MIN E MAX OVER
-- ============================================================

SELECT
    id,
    nome,
    preco,
    MIN(preco) OVER () AS menor_preco,
    MAX(preco) OVER () AS maior_preco
FROM techstore.produtos;


-- ============================================================
-- 04. PARTITION BY - MEDIA POR CATEGORIA
-- ============================================================

SELECT
    id,
    nome,
    categoria_id,
    preco,
    AVG(preco) OVER (
        PARTITION BY categoria_id
    ) AS media_categoria
FROM techstore.produtos;


-- ============================================================
-- 05. PARTITION BY - MAIOR PRECO POR CATEGORIA
-- ============================================================

SELECT
    id,
    nome,
    categoria_id,
    preco,
    MAX(preco) OVER (
        PARTITION BY categoria_id
    ) AS maior_preco_categoria
FROM techstore.produtos;


-- ============================================================
-- 06. PARTITION BY - MULTIPLAS COLUNAS
-- ============================================================

SELECT
    id,
    cliente_id,
    status,
    COUNT(*) OVER (
        PARTITION BY cliente_id, status
    ) AS quantidade_por_cliente_status
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- ============================================================
-- 07. ORDER BY DENTRO DE OVER
-- ============================================================

SELECT
    id,
    nome,
    preco,
    ROW_NUMBER() OVER (
        ORDER BY preco DESC, id
    ) AS posicao_preco
FROM techstore.produtos;


-- ============================================================
-- 08. ORDER BY DA JANELA E ORDER BY FINAL
-- ============================================================

SELECT
    id,
    nome,
    preco,
    ROW_NUMBER() OVER (
        ORDER BY preco DESC, id
    ) AS ranking
FROM techstore.produtos
ORDER BY id;


-- ============================================================
-- 09. ROW_NUMBER - RANKING GLOBAL
-- ============================================================

SELECT
    id,
    nome,
    preco,
    ROW_NUMBER() OVER (
        ORDER BY preco DESC, id
    ) AS posicao
FROM techstore.produtos;


-- ============================================================
-- 10. ROW_NUMBER - RANKING POR CATEGORIA
-- ============================================================

SELECT
    id,
    nome,
    categoria_id,
    preco,
    ROW_NUMBER() OVER (
        PARTITION BY categoria_id
        ORDER BY preco DESC, id
    ) AS posicao_categoria
FROM techstore.produtos;


-- ============================================================
-- 11. RANK - RANKING COM EMPATES
-- ============================================================

SELECT
    id,
    nome,
    preco,
    RANK() OVER (
        ORDER BY preco DESC
    ) AS classificacao
FROM techstore.produtos;


-- ============================================================
-- 12. DENSE_RANK - RANKING SEM LACUNAS
-- ============================================================

SELECT
    id,
    nome,
    preco,
    DENSE_RANK() OVER (
        ORDER BY preco DESC
    ) AS classificacao
FROM techstore.produtos;


-- ============================================================
-- 13. COMPARACAO ENTRE OS TRES RANKINGS
-- ============================================================

SELECT
    id,
    nome,
    preco,

    ROW_NUMBER() OVER (
        ORDER BY preco DESC, id
    ) AS row_number,

    RANK() OVER (
        ORDER BY preco DESC
    ) AS rank,

    DENSE_RANK() OVER (
        ORDER BY preco DESC
    ) AS dense_rank

FROM techstore.produtos
ORDER BY preco DESC, id;


-- ============================================================
-- 14. NTILE - DIVISAO EM QUARTIS
-- ============================================================

SELECT
    id,
    nome,
    preco,
    NTILE(4) OVER (
        ORDER BY preco, id
    ) AS quartil
FROM techstore.produtos;


-- ============================================================
-- 15. RANKING COM FILTRO EXTERNO
-- ============================================================

WITH ranking AS (
    SELECT
        id,
        nome,
        categoria_id,
        preco,
        ROW_NUMBER() OVER (
            PARTITION BY categoria_id
            ORDER BY preco DESC, id
        ) AS posicao
    FROM techstore.produtos
)
SELECT
    id,
    nome,
    categoria_id,
    preco,
    posicao
FROM ranking
WHERE posicao <= 3
ORDER BY categoria_id, posicao;


-- ============================================================
-- 16. COUNT POR CLIENTE
-- ============================================================

SELECT
    id,
    cliente_id,
    data_pedido,
    COUNT(*) OVER (
        PARTITION BY cliente_id
    ) AS quantidade_pedidos
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- ============================================================
-- 17. ROW_NUMBER - SEQUENCIA DE PEDIDOS
-- ============================================================

SELECT
    id,
    cliente_id,
    data_pedido,
    ROW_NUMBER() OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido, id
    ) AS ordem_pedido
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- ============================================================
-- 18. RANKING DE AVALIACOES
-- ============================================================

SELECT
    id,
    produto_id,
    nota,
    RANK() OVER (
        PARTITION BY produto_id
        ORDER BY nota DESC
    ) AS ranking_nota
FROM techstore.avaliacoes;


-- ============================================================
-- 19. COUNT DE AVALIACOES POR PRODUTO
-- ============================================================

SELECT
    id,
    produto_id,
    nota,
    COUNT(*) OVER (
        PARTITION BY produto_id
    ) AS quantidade_avaliacoes
FROM techstore.avaliacoes;


-- ============================================================
-- 20. ROW_NUMBER - MOVIMENTACOES POR FUNCIONARIO
-- ============================================================

SELECT
    id,
    funcionario_id,
    tipo,
    data_movimentacao,
    ROW_NUMBER() OVER (
        PARTITION BY funcionario_id
        ORDER BY data_movimentacao, id
    ) AS sequencia
FROM techstore.movimentacoes_estoque;


-- ============================================================
-- 21. SUM OVER - SOMA GLOBAL
-- ============================================================

SELECT
    id,
    valor_frete,
    SUM(valor_frete) OVER () AS total_frete
FROM techstore.pedidos;


-- ============================================================
-- 22. SUM OVER - SOMA POR CLIENTE
-- ============================================================

SELECT
    id,
    cliente_id,
    valor_frete,
    SUM(valor_frete) OVER (
        PARTITION BY cliente_id
    ) AS frete_cliente
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- ============================================================
-- 23. SUM OVER - ACUMULADO GLOBAL
-- ============================================================

SELECT
    id,
    data_pedido,
    valor_frete,
    SUM(valor_frete) OVER (
        ORDER BY data_pedido, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS frete_acumulado
FROM techstore.pedidos;


-- ============================================================
-- 24. SUM OVER - ACUMULADO POR CLIENTE
-- ============================================================

SELECT
    id,
    cliente_id,
    data_pedido,
    valor_frete,
    SUM(valor_frete) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS frete_acumulado_cliente
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- ============================================================
-- 25. FRAME MOVEL - ULTIMAS TRES LINHAS
-- ============================================================

SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    AVG(preco_novo) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
        ROWS BETWEEN 2 PRECEDING
                 AND CURRENT ROW
    ) AS media_movel
FROM techstore.historico_precos;


-- ============================================================
-- 26. RANGE - ACUMULADO COM PARES
-- ============================================================

WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1, 10),
            (2, 20),
            (3, 20),
            (4, 30)
    ) AS v(id, valor)
)
SELECT
    id,
    valor,
    SUM(valor) OVER (
        ORDER BY valor
        RANGE BETWEEN UNBOUNDED PRECEDING
                  AND CURRENT ROW
    ) AS acumulado
FROM dados
ORDER BY valor, id;


-- ============================================================
-- 27. ROWS - ACUMULADO INDIVIDUAL
-- ============================================================

WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1, 10),
            (2, 20),
            (3, 20),
            (4, 30)
    ) AS v(id, valor)
)
SELECT
    id,
    valor,
    SUM(valor) OVER (
        ORDER BY valor, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS acumulado
FROM dados
ORDER BY valor, id;


-- ============================================================
-- 28. GROUPS - FRAME POR GRUPOS
-- ============================================================

WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1, 10),
            (2, 20),
            (3, 20),
            (4, 30),
            (5, 30),
            (6, 30)
    ) AS v(id, valor)
)
SELECT
    id,
    valor,
    SUM(valor) OVER (
        ORDER BY valor
        GROUPS BETWEEN 1 PRECEDING
                   AND CURRENT ROW
    ) AS soma_grupos
FROM dados
ORDER BY valor, id;


-- ============================================================
-- 29. LAST_VALUE - FRAME PADRAO
-- ============================================================

SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    LAST_VALUE(preco_novo) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
    ) AS ultimo_valor_frame
FROM techstore.historico_precos;


-- ============================================================
-- 30. LAST_VALUE - ULTIMO VALOR DA PARTICAO
-- ============================================================

SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    LAST_VALUE(preco_novo) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS ultimo_preco_produto
FROM techstore.historico_precos;


-- ============================================================
-- 31. FIRST_VALUE - PRIMEIRO PRECO
-- ============================================================

SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    FIRST_VALUE(preco_novo) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS primeiro_preco
FROM techstore.historico_precos;


-- ============================================================
-- 32. NTH_VALUE - SEGUNDO PRECO
-- ============================================================

SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    NTH_VALUE(preco_novo, 2) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS segundo_preco
FROM techstore.historico_precos;


-- ============================================================
-- 33. LAG - PRECO ANTERIOR
-- ============================================================

SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    LAG(preco_novo) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
    ) AS preco_anterior
FROM techstore.historico_precos;


-- ============================================================
-- 34. LEAD - PROXIMO PRECO
-- ============================================================

SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    LEAD(preco_novo) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
    ) AS proximo_preco
FROM techstore.historico_precos;


-- ============================================================
-- 35. LAG - VARIACAO ABSOLUTA E PERCENTUAL
-- ============================================================

WITH historico AS (
    SELECT
        id,
        produto_id,
        alterado_em,
        preco_novo,
        LAG(preco_novo) OVER (
            PARTITION BY produto_id
            ORDER BY alterado_em, id
        ) AS preco_anterior
    FROM techstore.historico_precos
)
SELECT
    id,
    produto_id,
    alterado_em,
    preco_anterior,
    preco_novo,
    preco_novo - preco_anterior AS variacao_absoluta,
    ROUND(
        100.0 * (preco_novo - preco_anterior)
        / NULLIF(preco_anterior, 0),
        2
    ) AS variacao_percentual
FROM historico
WHERE preco_anterior IS NOT NULL;


-- ============================================================
-- 36. LAG - INTERVALO ENTRE PEDIDOS
-- ============================================================

WITH pedidos_ordenados AS (
    SELECT
        id,
        cliente_id,
        data_pedido,
        LAG(data_pedido) OVER (
            PARTITION BY cliente_id
            ORDER BY data_pedido, id
        ) AS pedido_anterior
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL
)
SELECT
    id,
    cliente_id,
    data_pedido,
    pedido_anterior,
    data_pedido - pedido_anterior AS intervalo
FROM pedidos_ordenados;


-- ============================================================
-- 37. LEAD - INTERVALO ATE O PROXIMO PEDIDO
-- ============================================================

WITH pedidos_ordenados AS (
    SELECT
        id,
        cliente_id,
        data_pedido,
        LEAD(data_pedido) OVER (
            PARTITION BY cliente_id
            ORDER BY data_pedido, id
        ) AS proximo_pedido
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL
)
SELECT
    id,
    cliente_id,
    data_pedido,
    proximo_pedido,
    proximo_pedido - data_pedido AS intervalo_proximo
FROM pedidos_ordenados;


-- ============================================================
-- 38. PRIMEIRO E ULTIMO PEDIDO POR CLIENTE
-- ============================================================

SELECT
    id,
    cliente_id,
    data_pedido,

    FIRST_VALUE(data_pedido) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS primeiro_pedido,

    LAST_VALUE(data_pedido) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS ultimo_pedido

FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- ============================================================
-- 39. AVG OVER - MEDIA DAS AVALIACOES
-- ============================================================

SELECT
    id,
    produto_id,
    nota,
    AVG(nota) OVER (
        PARTITION BY produto_id
    ) AS media_produto
FROM techstore.avaliacoes;


-- ============================================================
-- 40. AGREGACOES DE AVALIACOES POR PRODUTO
-- ============================================================

SELECT
    id,
    produto_id,
    nota,

    COUNT(*) OVER (
        PARTITION BY produto_id
    ) AS quantidade_avaliacoes,

    AVG(nota) OVER (
        PARTITION BY produto_id
    ) AS media_nota,

    MIN(nota) OVER (
        PARTITION BY produto_id
    ) AS menor_nota,

    MAX(nota) OVER (
        PARTITION BY produto_id
    ) AS maior_nota

FROM techstore.avaliacoes;


-- ============================================================
-- 41. FILTER - CONTAGEM CONDICIONAL
-- ============================================================

SELECT
    id,
    status,
    COUNT(*) FILTER (
        WHERE status = 'entregue'
    ) OVER () AS total_entregues
FROM techstore.pedidos;


-- ============================================================
-- 42. FILTER - SOMA CONDICIONAL
-- ============================================================

SELECT
    id,
    status,
    valor_frete,
    SUM(valor_frete) FILTER (
        WHERE status = 'entregue'
    ) OVER () AS frete_pedidos_entregues
FROM techstore.pedidos;


-- ============================================================
-- 43. PARTICIPACAO PERCENTUAL POR CATEGORIA
-- ============================================================

SELECT
    id,
    nome,
    categoria_id,
    preco,

    SUM(preco) OVER (
        PARTITION BY categoria_id
    ) AS soma_precos_categoria,

    ROUND(
        100.0 * preco
        / NULLIF(
            SUM(preco) OVER (
                PARTITION BY categoria_id
            ),
            0
        ),
        2
    ) AS participacao_percentual

FROM techstore.produtos;


-- ============================================================
-- 44. FATURAMENTO BRUTO POR PRODUTO
-- ============================================================

WITH vendas_produto AS (
    SELECT
        produto_id,
        SUM(quantidade * preco_unitario) AS faturamento_bruto,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT
    p.id,
    p.nome,
    v.unidades_vendidas,
    v.faturamento_bruto
FROM vendas_produto AS v
INNER JOIN techstore.produtos AS p
    ON p.id = v.produto_id
ORDER BY v.faturamento_bruto DESC;


-- ============================================================
-- 45. RANKING DE FATURAMENTO
-- ============================================================

WITH vendas_produto AS (
    SELECT
        produto_id,
        SUM(quantidade * preco_unitario) AS faturamento
    FROM techstore.itens_pedido
    GROUP BY produto_id
),
ranking AS (
    SELECT
        produto_id,
        faturamento,
        RANK() OVER (
            ORDER BY faturamento DESC
        ) AS posicao
    FROM vendas_produto
)
SELECT
    p.id,
    p.nome,
    r.faturamento,
    r.posicao
FROM ranking AS r
INNER JOIN techstore.produtos AS p
    ON p.id = r.produto_id
ORDER BY r.posicao, p.id;


-- ============================================================
-- 46. PARTICIPACAO NO FATURAMENTO TOTAL
-- ============================================================

WITH vendas_produto AS (
    SELECT
        produto_id,
        SUM(quantidade * preco_unitario) AS faturamento
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT
    produto_id,
    faturamento,
    ROUND(
        100.0 * faturamento
        / NULLIF(SUM(faturamento) OVER (), 0),
        2
    ) AS participacao_percentual
FROM vendas_produto
ORDER BY faturamento DESC;


-- ============================================================
-- 47. MEDIA DE ESTOQUE POR CATEGORIA
-- ============================================================

SELECT
    p.id,
    p.nome,
    p.categoria_id,
    e.quantidade,
    e.estoque_minimo,

    AVG(e.quantidade) OVER (
        PARTITION BY p.categoria_id
    ) AS media_estoque_categoria

FROM techstore.produtos AS p
LEFT JOIN techstore.estoque AS e
    ON e.produto_id = p.id;


-- ============================================================
-- 48. RANKING DE ESTOQUE POR CATEGORIA
-- ============================================================

SELECT
    p.id,
    p.nome,
    p.categoria_id,
    e.quantidade,

    RANK() OVER (
        PARTITION BY p.categoria_id
        ORDER BY e.quantidade DESC NULLS LAST
    ) AS ranking_estoque

FROM techstore.produtos AS p
LEFT JOIN techstore.estoque AS e
    ON e.produto_id = p.id;


-- ============================================================
-- 49. AVALIACOES - INCLUIR PRODUTOS SEM AVALIACOES
-- ============================================================

WITH indicadores AS (
    SELECT
        produto_id,
        COUNT(*) AS quantidade_avaliacoes,
        AVG(nota) AS media_nota
    FROM techstore.avaliacoes
    GROUP BY produto_id
),
ranking AS (
    SELECT
        p.id AS produto_id,
        p.nome,
        p.categoria_id,
        COALESCE(i.quantidade_avaliacoes, 0) AS quantidade_avaliacoes,
        i.media_nota,
        RANK() OVER (
            PARTITION BY p.categoria_id
            ORDER BY i.media_nota DESC NULLS LAST
        ) AS ranking_categoria
    FROM techstore.produtos AS p
    LEFT JOIN indicadores AS i
        ON i.produto_id = p.id
)
SELECT *
FROM ranking
ORDER BY categoria_id, ranking_categoria, produto_id;


-- ============================================================
-- 50. EVENTOS TEMPORAIS - PEDIDOS POR DIA
-- ============================================================

WITH pedidos_dia AS (
    SELECT
        data_pedido::DATE AS dia,
        COUNT(*) AS quantidade_pedidos
    FROM techstore.pedidos
    GROUP BY data_pedido::DATE
)
SELECT
    dia,
    quantidade_pedidos,

    LAG(quantidade_pedidos) OVER (
        ORDER BY dia
    ) AS quantidade_dia_anterior,

    quantidade_pedidos
    - LAG(quantidade_pedidos) OVER (
        ORDER BY dia
    ) AS diferenca

FROM pedidos_dia
ORDER BY dia;


-- ============================================================
-- 51. VARIACAO PERCENTUAL ENTRE DIAS
-- ============================================================

WITH pedidos_dia AS (
    SELECT
        data_pedido::DATE AS dia,
        COUNT(*) AS quantidade_pedidos
    FROM techstore.pedidos
    GROUP BY data_pedido::DATE
),
comparacao AS (
    SELECT
        dia,
        quantidade_pedidos,
        LAG(quantidade_pedidos) OVER (
            ORDER BY dia
        ) AS pedidos_anterior
    FROM pedidos_dia
)
SELECT
    dia,
    quantidade_pedidos,
    pedidos_anterior,
    ROUND(
        100.0 * (quantidade_pedidos - pedidos_anterior)
        / NULLIF(pedidos_anterior, 0),
        2
    ) AS variacao_percentual
FROM comparacao
ORDER BY dia;


-- ============================================================
-- 52. NAMED WINDOW - JANELA NOMEADA
-- ============================================================

SELECT
    id,
    cliente_id,
    data_pedido,
    valor_frete,

    SUM(valor_frete) OVER janela_cliente AS frete_acumulado,

    AVG(valor_frete) OVER janela_cliente AS media_frete

FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

WINDOW janela_cliente AS (
    PARTITION BY cliente_id
    ORDER BY data_pedido, id
    ROWS BETWEEN UNBOUNDED PRECEDING
             AND CURRENT ROW
);


-- ============================================================
-- 53. COMPARACAO GROUP BY E WINDOW FUNCTION
-- ============================================================

-- Agregacao tradicional: uma linha por cliente.

SELECT
    cliente_id,
    COUNT(*) AS quantidade_pedidos
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL
GROUP BY cliente_id
ORDER BY cliente_id;


-- Funcao de janela: uma linha por pedido.

SELECT
    id,
    cliente_id,
    COUNT(*) OVER (
        PARTITION BY cliente_id
    ) AS quantidade_pedidos
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL
ORDER BY cliente_id, id;


-- ============================================================
-- 54. EXPLAIN - RANKING
-- ============================================================

EXPLAIN
SELECT
    id,
    cliente_id,
    data_pedido,
    ROW_NUMBER() OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido, id
    ) AS posicao
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- ============================================================
-- 55. EXPLAIN ANALYZE - RANKING
-- ============================================================
--
-- ATENCAO:
-- EXPLAIN ANALYZE executa a consulta.
-- Execute individualmente e observe o custo.
--

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    cliente_id,
    data_pedido,
    ROW_NUMBER() OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido, id
    ) AS posicao
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- ============================================================
-- 56. EXPLAIN ANALYZE - RANKING DE PRODUTOS
-- ============================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    categoria_id,
    preco,
    RANK() OVER (
        PARTITION BY categoria_id
        ORDER BY preco DESC
    ) AS ranking
FROM techstore.produtos;


-- ============================================================
-- 57. EXPLAIN ANALYZE - HISTORICO DE PRECOS
-- ============================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    LAG(preco_novo) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
    ) AS preco_anterior
FROM techstore.historico_precos;


-- ============================================================
-- 58. ANALISE DE GRANULARIDADE
-- ============================================================

-- Primeiro: agregue os itens por produto.
-- Depois: aplique a Window Function sobre o resultado agregado.

WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade * preco_unitario) AS faturamento
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT
    produto_id,
    faturamento,
    SUM(faturamento) OVER () AS faturamento_total,
    RANK() OVER (
        ORDER BY faturamento DESC
    ) AS ranking
FROM vendas
ORDER BY ranking, produto_id;


-- ============================================================
-- 59. COMPARACAO DE PRECO COM MEDIA DA CATEGORIA
-- ============================================================

SELECT
    id,
    nome,
    categoria_id,
    preco,
    AVG(preco) OVER (
        PARTITION BY categoria_id
    ) AS media_categoria,
    preco - AVG(preco) OVER (
        PARTITION BY categoria_id
    ) AS diferenca_media
FROM techstore.produtos;


-- ============================================================
-- 60. RELATORIO ANALITICO INTEGRADO
-- ============================================================

WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas,
        SUM(quantidade * preco_unitario) AS faturamento
    FROM techstore.itens_pedido
    GROUP BY produto_id
),
avaliacoes AS (
    SELECT
        produto_id,
        COUNT(*) AS quantidade_avaliacoes,
        AVG(nota) AS media_nota
    FROM techstore.avaliacoes
    GROUP BY produto_id
),
indicadores AS (
    SELECT
        p.id,
        p.nome,
        p.categoria_id,
        COALESCE(v.unidades_vendidas, 0) AS unidades_vendidas,
        COALESCE(v.faturamento, 0) AS faturamento,
        COALESCE(a.quantidade_avaliacoes, 0) AS quantidade_avaliacoes,
        a.media_nota
    FROM techstore.produtos AS p
    LEFT JOIN vendas AS v
        ON v.produto_id = p.id
    LEFT JOIN avaliacoes AS a
        ON a.produto_id = p.id
),
analise AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY faturamento DESC
        ) AS ranking_global,
        RANK() OVER (
            PARTITION BY categoria_id
            ORDER BY faturamento DESC
        ) AS ranking_categoria,
        AVG(faturamento) OVER (
            PARTITION BY categoria_id
        ) AS media_faturamento_categoria
    FROM indicadores
)
SELECT
    id,
    nome,
    categoria_id,
    unidades_vendidas,
    faturamento,
    quantidade_avaliacoes,
    media_nota,
    ranking_global,
    ranking_categoria,
    media_faturamento_categoria
FROM analise
ORDER BY ranking_global, id;


-- ============================================================
-- FIM DO MODULO 09
-- ============================================================