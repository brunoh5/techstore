/*
===============================================================================
CURSO SQL — MÓDULO 08
CTEs (COMMON TABLE EXPRESSIONS)
===============================================================================

Banco: PostgreSQL 16
Schema principal: techstore

OBJETIVO
--------
Demonstrar o uso de CTEs para organizar consultas, separar etapas de análise,
combinar resultados, executar consultas recursivas e investigar desempenho.

REGRAS DE SEGURANÇA
-------------------
1. Este arquivo contém consultas de leitura.
2. Não executar novamente o seed.
3. Não modificar registros da TechStore.
4. Não criar objetos permanentes.
5. Executar os exemplos individualmente.
6. EXPLAIN ANALYZE executa a consulta analisada.
7. Consultas recursivas devem possuir condições de encerramento.

OBSERVAÇÃO
----------
Os exemplos são materiais de estudo, não soluções das atividades.
Os resultados dependem dos dados existentes no banco.
===============================================================================
*/


/*
===============================================================================
01. CTE SIMPLES
===============================================================================

WITH permite declarar uma expressão de tabela que poderá ser utilizada
pela consulta principal.

Neste exemplo, a CTE seleciona produtos ativos.
*/

WITH produtos_ativos AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
    WHERE ativo = TRUE
)
SELECT *
FROM produtos_ativos;


/*
===============================================================================
02. CTE COM ALIASES
===============================================================================

É possível declarar os nomes das colunas diretamente após o nome da CTE.

Observe a correspondência entre a quantidade de aliases e as colunas
retornadas pela consulta interna.
*/

WITH resumo_produto (
    produto_id,
    descricao,
    valor
) AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT *
FROM resumo_produto
LIMIT 20;


/*
===============================================================================
03. CTE COM EXPRESSÕES
===============================================================================

As expressões podem ser calculadas dentro da CTE e utilizadas posteriormente.
*/

WITH produtos AS (
    SELECT
        id,
        nome,
        preco,
        custo,
        preco - custo AS lucro_bruto
    FROM techstore.produtos
)
SELECT
    produto_id,
    nome,
    preco,
    custo,
    lucro_bruto
FROM (
    SELECT
        id AS produto_id,
        nome,
        preco,
        custo,
        lucro_bruto
    FROM produtos
) AS resultado
ORDER BY lucro_bruto DESC
LIMIT 20;


/*
===============================================================================
04. CTE COM CASE
===============================================================================

CASE permite classificar os registros.

As faixas de preço utilizadas aqui são apenas demonstrativas.
*/

WITH classificacao AS (
    SELECT
        id,
        nome,
        preco,
        CASE
            WHEN preco < 100 THEN 'Baixo'
            WHEN preco < 500 THEN 'Médio'
            ELSE 'Alto'
        END AS faixa_preco
    FROM techstore.produtos
)
SELECT
    faixa_preco,
    COUNT(*) AS quantidade_produtos
FROM classificacao
GROUP BY faixa_preco
ORDER BY quantidade_produtos DESC;


/*
===============================================================================
05. CTE COM TRATAMENTO DE NULL
===============================================================================

COALESCE retorna o primeiro valor não nulo.

O exemplo utiliza cliente_id, que pode ser NULL em acessos.
*/

WITH acessos AS (
    SELECT
        id,
        cliente_id,
        data_acesso,
        COALESCE(cliente_id, 0) AS cliente_id_tratado
    FROM techstore.acessos
)
SELECT
    COUNT(*) AS total_acessos,
    COUNT(cliente_id) AS acessos_identificados,
    COUNT(*) FILTER (
        WHERE cliente_id IS NULL
    ) AS acessos_sem_cliente
FROM acessos;


/*
===============================================================================
06. CTE COM ORDER BY E LIMIT
===============================================================================

A ordenação interna pode ser utilizada para selecionar um subconjunto.

Importante:
A ordenação dentro da CTE não garante a ordem final da consulta externa.
Para garantir a apresentação ordenada, utilize ORDER BY na consulta principal.
*/

WITH produtos_caros AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
    ORDER BY preco DESC
    LIMIT 20
)
SELECT *
FROM produtos_caros
ORDER BY preco DESC;


/*
===============================================================================
07. MÚLTIPLAS CTEs
===============================================================================

Uma CTE pode utilizar outra CTE declarada anteriormente.

A consulta abaixo separa a análise em três etapas:

1. Seleciona os pedidos.
2. Agrupa a quantidade por cliente.
3. Classifica os clientes.
*/

WITH pedidos_base AS (
    SELECT
        id,
        cliente_id
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL
),

pedidos_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade_pedidos
    FROM pedidos_base
    GROUP BY cliente_id
),

classificacao AS (
    SELECT
        cliente_id,
        quantidade_pedidos,
        CASE
            WHEN quantidade_pedidos >= 10 THEN 'Recorrente'
            WHEN quantidade_pedidos >= 5 THEN 'Frequente'
            ELSE 'Ocasional'
        END AS perfil
    FROM pedidos_por_cliente
)

SELECT *
FROM classificacao
ORDER BY quantidade_pedidos DESC;


/*
===============================================================================
08. CTE COM AGREGAÇÃO
===============================================================================

Exemplo de cálculo de indicadores de pedidos.

O agrupamento ocorre por status.
*/

WITH indicadores AS (
    SELECT
        status,
        COUNT(*) AS quantidade_pedidos,
        SUM(valor_frete) AS total_frete,
        AVG(valor_frete) AS frete_medio,
        MIN(valor_frete) AS menor_frete,
        MAX(valor_frete) AS maior_frete
    FROM techstore.pedidos
    GROUP BY status
)
SELECT *
FROM indicadores
ORDER BY quantidade_pedidos DESC;


/*
===============================================================================
09. CTE COM HAVING
===============================================================================

HAVING filtra grupos depois da agregação.
*/

WITH vendas_por_produto AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT
    produto_id,
    unidades_vendidas
FROM vendas_por_produto
WHERE unidades_vendidas > 100
ORDER BY unidades_vendidas DESC;


/*
===============================================================================
10. CTE COM INNER JOIN
===============================================================================

Combinação entre produtos e categorias.
*/

WITH catalogo AS (
    SELECT
        p.id AS produto_id,
        p.nome AS produto,
        p.preco,
        c.id AS categoria_id,
        c.nome AS categoria
    FROM techstore.produtos AS p
    INNER JOIN techstore.categorias AS c
        ON c.id = p.categoria_id
)
SELECT *
FROM catalogo
ORDER BY categoria, produto
LIMIT 50;


/*
===============================================================================
11. CTE COM LEFT JOIN
===============================================================================

Identificação de produtos sem vendas.

A consulta preserva os produtos que não possuem correspondência em
itens_pedido.
*/

WITH produtos_vendidos AS (
    SELECT DISTINCT
        produto_id
    FROM techstore.itens_pedido
)
SELECT
    p.id,
    p.nome,
    p.preco
FROM techstore.produtos AS p
LEFT JOIN produtos_vendidos AS v
    ON v.produto_id = p.id
WHERE v.produto_id IS NULL
ORDER BY p.nome;


/*
===============================================================================
12. CTE COM AGREGAÇÃO PRÉVIA E JOIN
===============================================================================

É importante agregar cada fonte antes de combinar relações que podem
possuir múltiplas linhas por produto.

Neste exemplo:

- A primeira CTE calcula unidades e faturamento bruto.
- A segunda calcula a média e a quantidade de avaliações.
- A consulta final combina os indicadores.

A agregação prévia evita a multiplicação de valores causada pelo JOIN
direto entre itens de pedido e avaliações.
*/

WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas,
        SUM(quantidade * preco_unitario) AS faturamento_bruto
    FROM techstore.itens_pedido
    GROUP BY produto_id
),

avaliacoes AS (
    SELECT
        produto_id,
        COUNT(*) AS quantidade_avaliacoes,
        AVG(nota) AS nota_media
    FROM techstore.avaliacoes
    GROUP BY produto_id
)

SELECT
    p.id,
    p.nome,
    COALESCE(v.unidades_vendidas, 0) AS unidades_vendidas,
    COALESCE(v.faturamento_bruto, 0) AS faturamento_bruto,
    COALESCE(a.quantidade_avaliacoes, 0) AS quantidade_avaliacoes,
    a.nota_media
FROM techstore.produtos AS p
LEFT JOIN vendas AS v
    ON v.produto_id = p.id
LEFT JOIN avaliacoes AS a
    ON a.produto_id = p.id
ORDER BY faturamento_bruto DESC;


/*
===============================================================================
13. CTE COM OPERAÇÕES DE CONJUNTOS
===============================================================================

Combina identificadores de clientes presentes em pedidos e acessos.

UNION elimina duplicidades considerando a linha completa.
*/

WITH clientes_ativos AS (
    SELECT cliente_id
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL

    UNION

    SELECT cliente_id
    FROM techstore.acessos
    WHERE cliente_id IS NOT NULL
)
SELECT
    cliente_id
FROM clientes_ativos
ORDER BY cliente_id;


/*
===============================================================================
14. CTE COM UNION ALL
===============================================================================

UNION ALL preserva todas as ocorrências.

O marcador origem permite distinguir de onde veio cada registro.
*/

WITH eventos AS (
    SELECT
        id,
        cliente_id,
        data_acesso AS ocorrido_em,
        'acesso'::TEXT AS origem
    FROM techstore.acessos
    WHERE cliente_id IS NOT NULL

    UNION ALL

    SELECT
        id,
        cliente_id,
        data_pedido AS ocorrido_em,
        'pedido'::TEXT AS origem
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL
)
SELECT *
FROM eventos
ORDER BY ocorrido_em DESC
LIMIT 100;


/*
===============================================================================
15. CTE COM INTERSECT
===============================================================================

Identifica clientes que aparecem tanto em pedidos quanto em acessos.

INTERSECT retorna apenas valores presentes nos dois conjuntos.
*/

WITH clientes_com_pedidos AS (
    SELECT cliente_id
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL
),

clientes_com_acessos AS (
    SELECT cliente_id
    FROM techstore.acessos
    WHERE cliente_id IS NOT NULL
)

SELECT cliente_id
FROM clientes_com_pedidos

INTERSECT

SELECT cliente_id
FROM clientes_com_acessos;


/*
===============================================================================
16. CTE COM EXCEPT
===============================================================================

Identifica clientes que fizeram pedidos, mas não possuem acessos registrados.

O resultado considera os identificadores distintos.
*/

WITH clientes_com_pedidos AS (
    SELECT DISTINCT cliente_id
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL
),

clientes_com_acessos AS (
    SELECT DISTINCT cliente_id
    FROM techstore.acessos
    WHERE cliente_id IS NOT NULL
)

SELECT cliente_id
FROM clientes_com_pedidos

EXCEPT

SELECT cliente_id
FROM clientes_com_acessos;


/*
===============================================================================
17. CTE COM SUBCONSULTA
===============================================================================

Calcula a média geral de preços e seleciona produtos acima dela.
*/

WITH referencia AS (
    SELECT AVG(preco) AS preco_medio
    FROM techstore.produtos
)
SELECT
    p.id,
    p.nome,
    p.preco,
    r.preco_medio
FROM techstore.produtos AS p
CROSS JOIN referencia AS r
WHERE p.preco > r.preco_medio
ORDER BY p.preco DESC;


/*
===============================================================================
18. CTE COM WINDOW FUNCTION
===============================================================================

Exemplo de classificação de produtos por preço dentro de cada categoria.

O aprofundamento de Window Functions será realizado no Módulo 09.
*/

WITH ranking_produtos AS (
    SELECT
        id,
        nome,
        categoria_id,
        preco,
        RANK() OVER (
            PARTITION BY categoria_id
            ORDER BY preco DESC
        ) AS posicao
    FROM techstore.produtos
)
SELECT *
FROM ranking_produtos
WHERE posicao <= 3
ORDER BY categoria_id, posicao;


/*
===============================================================================
19. CTE COM MÚLTIPLAS FONTES DE INDICADORES
===============================================================================

Cada fonte é agregada separadamente.

Isso evita que o relacionamento entre pedidos, acessos e movimentações
multiplique os valores de cada indicador.
*/

WITH indicadores_pedidos AS (
    SELECT
        COUNT(*) AS quantidade_pedidos,
        COUNT(DISTINCT cliente_id) AS clientes_com_pedidos
    FROM techstore.pedidos
),

indicadores_acessos AS (
    SELECT
        COUNT(*) AS quantidade_acessos,
        COUNT(DISTINCT cliente_id) AS clientes_com_acessos
    FROM techstore.acessos
),

indicadores_movimentacoes AS (
    SELECT
        COUNT(*) AS quantidade_movimentacoes,
        COUNT(DISTINCT funcionario_id) AS funcionarios_identificados
    FROM techstore.movimentacoes_estoque
)

SELECT
    p.quantidade_pedidos,
    p.clientes_com_pedidos,
    a.quantidade_acessos,
    a.clientes_com_acessos,
    m.quantidade_movimentacoes,
    m.funcionarios_identificados
FROM indicadores_pedidos AS p
CROSS JOIN indicadores_acessos AS a
CROSS JOIN indicadores_movimentacoes AS m;


/*
===============================================================================
20. CTE COM ESTOQUE
===============================================================================

Combina produtos e estoque.

A classificação utiliza quantidade e estoque mínimo.
*/

WITH situacao_estoque AS (
    SELECT
        p.id AS produto_id,
        p.nome,
        e.quantidade,
        e.estoque_minimo,
        CASE
            WHEN e.produto_id IS NULL THEN 'Sem registro de estoque'
            WHEN e.quantidade <= e.estoque_minimo THEN 'Estoque baixo'
            ELSE 'Estoque adequado'
        END AS situacao
    FROM techstore.produtos AS p
    LEFT JOIN techstore.estoque AS e
        ON e.produto_id = p.id
)
SELECT *
FROM situacao_estoque
ORDER BY situacao, nome;


/*
===============================================================================
21. CTE COM FUNCIONÁRIOS
===============================================================================

Agrega movimentações por funcionário antes de combinar com funcionários.

Funcionários sem movimentações também aparecem.
*/

WITH movimentacoes AS (
    SELECT
        funcionario_id,
        COUNT(*) AS quantidade_movimentacoes,
        SUM(quantidade) AS quantidade_total
    FROM techstore.movimentacoes_estoque
    WHERE funcionario_id IS NOT NULL
    GROUP BY funcionario_id
)
SELECT
    f.id,
    f.nome,
    COALESCE(m.quantidade_movimentacoes, 0) AS quantidade_movimentacoes,
    COALESCE(m.quantidade_total, 0) AS quantidade_total
FROM techstore.funcionarios AS f
LEFT JOIN movimentacoes AS m
    ON m.funcionario_id = f.id
ORDER BY quantidade_movimentacoes DESC;


/*
===============================================================================
22. CTE COM ENTREGAS
===============================================================================

Calcula o tempo entre envio e entrega.

Registros sem data de entrega permanecem identificáveis.
*/

WITH prazos AS (
    SELECT
        id,
        pedido_id,
        transportadora_id,
        data_envio,
        data_entrega,
        status,
        CASE
            WHEN data_envio IS NOT NULL
             AND data_entrega IS NOT NULL
            THEN data_entrega - data_envio
            ELSE NULL
        END AS duracao
    FROM techstore.entregas
)
SELECT
    COUNT(*) AS total_entregas,
    COUNT(duracao) AS entregas_com_duracao,
    AVG(duracao) AS duracao_media,
    MIN(duracao) AS menor_duracao,
    MAX(duracao) AS maior_duracao
FROM prazos;


/*
===============================================================================
23. CTE RECURSIVA — SEQUÊNCIA NUMÉRICA
===============================================================================

Uma CTE recursiva possui:

1. Parte âncora.
2. Operador UNION ALL.
3. Parte recursiva.

A condição numero < 10 controla a expansão.
*/

WITH RECURSIVE numeros AS (
    SELECT 1 AS numero

    UNION ALL

    SELECT numero + 1
    FROM numeros
    WHERE numero < 10
)
SELECT *
FROM numeros
ORDER BY numero;


/*
===============================================================================
24. CTE RECURSIVA — CONTAGEM REGRESSIVA
===============================================================================
*/

WITH RECURSIVE contagem AS (
    SELECT 10 AS numero

    UNION ALL

    SELECT numero - 1
    FROM contagem
    WHERE numero > 1
)
SELECT *
FROM contagem
ORDER BY numero DESC;


/*
===============================================================================
25. CTE RECURSIVA — ESTRUTURA HIERÁRQUICA
===============================================================================

Exemplo independente do schema TechStore.

Não existe pressuposto de uma coluna gestor_id na tabela funcionarios.

A estrutura hierárquica é criada com VALUES.
*/

WITH RECURSIVE estrutura AS (
    SELECT *
    FROM (
        VALUES
            (1, 'Diretoria', NULL::INTEGER),
            (2, 'Comercial', 1),
            (3, 'Operações', 1),
            (4, 'Vendas', 2),
            (5, 'Marketing', 2),
            (6, 'Logística', 3),
            (7, 'Estoque', 3)
    ) AS dados(id, nome, pai_id)
),

hierarquia AS (
    SELECT
        id,
        nome,
        pai_id,
        0 AS nivel
    FROM estrutura
    WHERE pai_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.nome,
        e.pai_id,
        h.nivel + 1
    FROM estrutura AS e
    INNER JOIN hierarquia AS h
        ON e.pai_id = h.id
)

SELECT
    id,
    nome,
    pai_id,
    nivel
FROM hierarquia
ORDER BY nivel, id;


/*
===============================================================================
26. CTE RECURSIVA — CAMINHO HIERÁRQUICO
===============================================================================

ARRAY permite armazenar o caminho percorrido.

O caminho facilita a identificação de elementos visitados.
*/

WITH RECURSIVE estrutura AS (
    SELECT *
    FROM (
        VALUES
            (1, 'Raiz', NULL::INTEGER),
            (2, 'Filho A', 1),
            (3, 'Filho B', 1),
            (4, 'Neto A1', 2),
            (5, 'Neto A2', 2),
            (6, 'Neto B1', 3)
    ) AS dados(id, nome, pai_id)
),

hierarquia AS (
    SELECT
        id,
        nome,
        pai_id,
        0 AS nivel,
        ARRAY[id] AS caminho
    FROM estrutura
    WHERE pai_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.nome,
        e.pai_id,
        h.nivel + 1,
        h.caminho || e.id
    FROM estrutura AS e
    INNER JOIN hierarquia AS h
        ON e.pai_id = h.id
)

SELECT *
FROM hierarquia
ORDER BY caminho;


/*
===============================================================================
27. PREVENÇÃO DE CICLOS COM ARRAY
===============================================================================

A estrutura abaixo contém um ciclo:

1 -> 2 -> 3 -> 1

A condição impede que um identificador já presente no caminho seja visitado
novamente.
*/

WITH RECURSIVE estrutura AS (
    SELECT *
    FROM (
        VALUES
            (1, 2),
            (2, 3),
            (3, 1)
    ) AS dados(id, proximo_id)
),

caminhos AS (
    SELECT
        id,
        proximo_id,
        ARRAY[id] AS caminho
    FROM estrutura
    WHERE id = 1

    UNION ALL

    SELECT
        e.id,
        e.proximo_id,
        c.caminho || e.id
    FROM estrutura AS e
    INNER JOIN caminhos AS c
        ON e.id = c.proximo_id
    WHERE NOT e.id = ANY(c.caminho)
)

SELECT *
FROM caminhos;


/*
===============================================================================
28. RECURSIVIDADE COM CYCLE
===============================================================================

PostgreSQL 16 suporta a cláusula CYCLE.

Ela permite detectar ciclos e produzir colunas de marcação e caminho.

A cláusula deve ser posicionada após a definição da consulta recursiva
e antes da consulta principal.
*/

WITH RECURSIVE estrutura(id, proximo_id) AS (
    VALUES
        (1, 2),
        (2, 3),
        (3, 1)
),

caminhos AS (
    SELECT
        id,
        proximo_id
    FROM estrutura
    WHERE id = 1

    UNION ALL

    SELECT
        e.id,
        e.proximo_id
    FROM estrutura AS e
    INNER JOIN caminhos AS c
        ON e.id = c.proximo_id
)
CYCLE id SET ciclo USING caminho

SELECT
    id,
    proximo_id,
    ciclo,
    caminho
FROM caminhos;


/*
===============================================================================
29. RECURSIVIDADE COM SEARCH DEPTH FIRST
===============================================================================

SEARCH DEPTH FIRST cria uma coluna de ordenação para representar
um percurso em profundidade.

A coluna gerada pode ser utilizada no ORDER BY externo.
*/

WITH RECURSIVE estrutura(id, nome, pai_id) AS (
    VALUES
        (1, 'Raiz', NULL::INTEGER),
        (2, 'Filho A', 1),
        (3, 'Filho B', 1),
        (4, 'Neto A1', 2),
        (5, 'Neto B1', 3)
),

hierarquia AS (
    SELECT
        id,
        nome,
        pai_id
    FROM estrutura
    WHERE pai_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.nome,
        e.pai_id
    FROM estrutura AS e
    INNER JOIN hierarquia AS h
        ON e.pai_id = h.id
)
SEARCH DEPTH FIRST BY id SET ordem

SELECT *
FROM hierarquia
ORDER BY ordem;


/*
===============================================================================
30. RECURSIVIDADE COM SEARCH BREADTH FIRST
===============================================================================

SEARCH BREADTH FIRST cria uma coluna de ordenação para representar
um percurso em largura.
*/

WITH RECURSIVE estrutura(id, nome, pai_id) AS (
    VALUES
        (1, 'Raiz', NULL::INTEGER),
        (2, 'Filho A', 1),
        (3, 'Filho B', 1),
        (4, 'Neto A1', 2),
        (5, 'Neto B1', 3)
),

hierarquia AS (
    SELECT
        id,
        nome,
        pai_id
    FROM estrutura
    WHERE pai_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.nome,
        e.pai_id
    FROM estrutura AS e
    INNER JOIN hierarquia AS h
        ON e.pai_id = h.id
)
SEARCH BREADTH FIRST BY id SET ordem

SELECT *
FROM hierarquia
ORDER BY ordem;


/*
===============================================================================
31. SEARCH E CYCLE JUNTOS
===============================================================================

É possível combinar a geração de uma coluna de ordenação com a detecção
de ciclos.
*/

WITH RECURSIVE estrutura(id, proximo_id) AS (
    VALUES
        (1, 2),
        (2, 3),
        (3, 1)
),

caminhos AS (
    SELECT
        id,
        proximo_id
    FROM estrutura
    WHERE id = 1

    UNION ALL

    SELECT
        e.id,
        e.proximo_id
    FROM estrutura AS e
    INNER JOIN caminhos AS c
        ON e.id = c.proximo_id
)
SEARCH DEPTH FIRST BY id SET ordem
CYCLE id SET ciclo USING caminho

SELECT
    id,
    proximo_id,
    ciclo,
    caminho
FROM caminhos
ORDER BY ordem;


/*
===============================================================================
32. CTE MATERIALIZED
===============================================================================

MATERIALIZED solicita que o resultado da CTE seja materializado.

O comportamento pode evitar a repetição de trabalho quando o resultado
é reutilizado.

Entretanto, pode impedir que determinados filtros sejam empurrados para
dentro da consulta original.
*/

WITH produtos AS MATERIALIZED (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT *
FROM produtos
WHERE preco > 500;


/*
===============================================================================
33. CTE NOT MATERIALIZED
===============================================================================

NOT MATERIALIZED solicita que a CTE elegível seja incorporada à consulta
principal, permitindo que o otimizador considere filtros e outras
transformações em conjunto.

Pode melhorar determinadas consultas, mas também pode provocar repetição
de trabalho quando a CTE é referenciada várias vezes.
*/

WITH produtos AS NOT MATERIALIZED (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT *
FROM produtos
WHERE preco > 500;


/*
===============================================================================
34. CTE COM MÚLTIPLAS REFERÊNCIAS
===============================================================================

Uma CTE não recursiva referenciada mais de uma vez normalmente é
materializada por padrão no PostgreSQL 16, quando elegível.

Compare os planos das diferentes estratégias.
*/

WITH produtos AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT
    'precos_altos' AS grupo,
    COUNT(*) AS quantidade
FROM produtos
WHERE preco > 500

UNION ALL

SELECT
    'precos_baixos' AS grupo,
    COUNT(*) AS quantidade
FROM produtos
WHERE preco <= 500;


/*
===============================================================================
35. COMPARAÇÃO: CTE PADRÃO E MATERIALIZED
===============================================================================

Executar separadamente e comparar os planos.

Não assumir que a presença de materialização representa uma melhoria.
*/

EXPLAIN (ANALYZE, BUFFERS)
WITH produtos AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT *
FROM produtos
WHERE preco > 500;


/*
-------------------------------------------------------------------------------
Versão com MATERIALIZED
-------------------------------------------------------------------------------
*/

EXPLAIN (ANALYZE, BUFFERS)
WITH produtos AS MATERIALIZED (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT *
FROM produtos
WHERE preco > 500;


/*
-------------------------------------------------------------------------------
Versão com NOT MATERIALIZED
-------------------------------------------------------------------------------
*/

EXPLAIN (ANALYZE, BUFFERS)
WITH produtos AS NOT MATERIALIZED (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT *
FROM produtos
WHERE preco > 500;


/*
===============================================================================
36. CTE COM FILTRO EXTERNO
===============================================================================

Comparar o comportamento de filtros dentro e fora de uma CTE.

A consulta abaixo utiliza uma CTE materializada para tornar explícita
a separação entre as etapas.
*/

WITH produtos AS MATERIALIZED (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT *
FROM produtos
WHERE preco > 500;


/*
===============================================================================
37. CTE COM FILTRO INTERNO
===============================================================================

Nesta versão, o filtro é aplicado durante a construção da CTE.
*/

WITH produtos AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
    WHERE preco > 500
)
SELECT *
FROM produtos;


/*
===============================================================================
38. EXPLAIN — CTE COM AGREGAÇÃO
===============================================================================

EXPLAIN apresenta o plano estimado sem executar a consulta.
*/

EXPLAIN
WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT *
FROM vendas
WHERE unidades > 100;


/*
===============================================================================
39. EXPLAIN ANALYZE — CTE COM AGREGAÇÃO
===============================================================================

EXPLAIN ANALYZE executa a consulta e apresenta métricas reais.

Observe:

- Planning Time.
- Execution Time.
- Actual Rows.
- Loops.
- Node Type.
- Shared Hit Blocks.
- Shared Read Blocks.
*/

EXPLAIN (ANALYZE, BUFFERS)
WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT *
FROM vendas
WHERE unidades > 100;


/*
===============================================================================
40. EXPLAIN ANALYZE — MÚLTIPLAS CTEs
===============================================================================

Consulta com etapas independentes de agregação.

Compare os nós do plano e verifique se os resultados são equivalentes
a uma implementação alternativa.
*/

EXPLAIN (ANALYZE, BUFFERS)
WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade * preco_unitario) AS faturamento_bruto
    FROM techstore.itens_pedido
    GROUP BY produto_id
),

avaliacoes AS (
    SELECT
        produto_id,
        AVG(nota) AS nota_media
    FROM techstore.avaliacoes
    GROUP BY produto_id
)

SELECT
    p.id,
    p.nome,
    v.faturamento_bruto,
    a.nota_media
FROM techstore.produtos AS p
LEFT JOIN vendas AS v
    ON v.produto_id = p.id
LEFT JOIN avaliacoes AS a
    ON a.produto_id = p.id;


/*
===============================================================================
41. EXPLAIN ANALYZE — CTE RECURSIVA
===============================================================================

Analise a estrutura do plano de uma CTE recursiva.

Observe especialmente:

- Recursive Union.
- WorkTable Scan.
- Quantidade de loops.
- Quantidade de linhas produzidas.
- Tempo de execução.
*/

EXPLAIN (ANALYZE, BUFFERS)
WITH RECURSIVE numeros AS (
    SELECT 1 AS numero

    UNION ALL

    SELECT numero + 1
    FROM numeros
    WHERE numero < 1000
)
SELECT *
FROM numeros;


/*
===============================================================================
42. CTE COM RELATÓRIO DE CLIENTES
===============================================================================

Exemplo de relatório com uma linha por cliente.

A agregação dos pedidos ocorre antes do JOIN, preservando clientes
sem pedidos.
*/

WITH pedidos_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade_pedidos,
        SUM(valor_frete) AS total_frete
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL
    GROUP BY cliente_id
)
SELECT
    c.id,
    c.nome,
    COALESCE(p.quantidade_pedidos, 0) AS quantidade_pedidos,
    COALESCE(p.total_frete, 0) AS total_frete
FROM techstore.clientes AS c
LEFT JOIN pedidos_cliente AS p
    ON p.cliente_id = c.id
ORDER BY quantidade_pedidos DESC;


/*
===============================================================================
43. CTE COM RELATÓRIO DE CATEGORIAS
===============================================================================

Calcula quantidade de produtos e preço médio por categoria.
*/

WITH indicadores_categoria AS (
    SELECT
        categoria_id,
        COUNT(*) AS quantidade_produtos,
        AVG(preco) AS preco_medio,
        MIN(preco) AS menor_preco,
        MAX(preco) AS maior_preco
    FROM techstore.produtos
    GROUP BY categoria_id
)
SELECT
    c.id,
    c.nome,
    COALESCE(i.quantidade_produtos, 0) AS quantidade_produtos,
    i.preco_medio,
    i.menor_preco,
    i.maior_preco
FROM techstore.categorias AS c
LEFT JOIN indicadores_categoria AS i
    ON i.categoria_id = c.id
ORDER BY quantidade_produtos DESC;


/*
===============================================================================
44. CTE COM RELATÓRIO DE ACESSOS
===============================================================================

Acessos sem cliente identificado são contabilizados separadamente.
*/

WITH acessos_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade_acessos,
        MIN(data_acesso) AS primeiro_acesso,
        MAX(data_acesso) AS ultimo_acesso
    FROM techstore.acessos
    WHERE cliente_id IS NOT NULL
    GROUP BY cliente_id
)
SELECT
    c.id,
    c.nome,
    COALESCE(a.quantidade_acessos, 0) AS quantidade_acessos,
    a.primeiro_acesso,
    a.ultimo_acesso
FROM techstore.clientes AS c
LEFT JOIN acessos_cliente AS a
    ON a.cliente_id = c.id
ORDER BY quantidade_acessos DESC;


/*
===============================================================================
45. CTE COM RELATÓRIO DE TRANSPORTADORAS
===============================================================================

Cada transportadora aparece mesmo que não possua entregas associadas.
*/

WITH entregas_transportadora AS (
    SELECT
        transportadora_id,
        COUNT(*) AS quantidade_entregas,
        COUNT(data_entrega) AS entregas_com_data
    FROM techstore.entregas
    GROUP BY transportadora_id
)
SELECT
    t.id,
    t.nome,
    COALESCE(e.quantidade_entregas, 0) AS quantidade_entregas,
    COALESCE(e.entregas_com_data, 0) AS entregas_com_data
FROM techstore.transportadoras AS t
LEFT JOIN entregas_transportadora AS e
    ON e.transportadora_id = t.id
ORDER BY quantidade_entregas DESC;


/*
===============================================================================
46. CTE COM LOGS POR FUNCIONÁRIO
===============================================================================

Funcionários sem logs também são apresentados.
*/

WITH logs_funcionario AS (
    SELECT
        funcionario_id,
        COUNT(*) AS quantidade_logs
    FROM techstore.logs_sistema
    WHERE funcionario_id IS NOT NULL
    GROUP BY funcionario_id
)
SELECT
    f.id,
    f.nome,
    COALESCE(l.quantidade_logs, 0) AS quantidade_logs
FROM techstore.funcionarios AS f
LEFT JOIN logs_funcionario AS l
    ON l.funcionario_id = f.id
ORDER BY quantidade_logs DESC;


/*
===============================================================================
47. CTE COM HISTÓRICO DE PREÇOS
===============================================================================

Calcula a variação absoluta e percentual de preço.

NULLIF evita divisão por zero.
*/

WITH variacoes AS (
    SELECT
        produto_id,
        preco_anterior,
        preco_novo,
        preco_novo - preco_anterior AS variacao_absoluta,
        (
            (preco_novo - preco_anterior)
            / NULLIF(preco_anterior, 0)
        ) * 100 AS variacao_percentual
    FROM techstore.historico_precos
)
SELECT *
FROM variacoes
ORDER BY ABS(variacao_absoluta) DESC
LIMIT 50;


/*
===============================================================================
48. CTE COM MOVIMENTAÇÕES DE ESTOQUE
===============================================================================

Resumo por tipo de movimentação.
*/

WITH resumo_movimentacoes AS (
    SELECT
        tipo,
        COUNT(*) AS quantidade_movimentacoes,
        SUM(quantidade) AS quantidade_total
    FROM techstore.movimentacoes_estoque
    GROUP BY tipo
)
SELECT *
FROM resumo_movimentacoes
ORDER BY quantidade_movimentacoes DESC;


/*
===============================================================================
49. CTE COM EVENTOS DE CLIENTES
===============================================================================

Consolida eventos de pedidos e acessos.

A coluna origem permite distinguir os eventos.
*/

WITH eventos AS (
    SELECT
        cliente_id,
        data_pedido AS ocorrido_em,
        'pedido'::TEXT AS origem
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL

    UNION ALL

    SELECT
        cliente_id,
        data_acesso AS ocorrido_em,
        'acesso'::TEXT AS origem
    FROM techstore.acessos
    WHERE cliente_id IS NOT NULL
)
SELECT
    cliente_id,
    origem,
    COUNT(*) AS quantidade_eventos,
    MIN(ocorrido_em) AS primeiro_evento,
    MAX(ocorrido_em) AS ultimo_evento
FROM eventos
GROUP BY cliente_id, origem
ORDER BY cliente_id, origem;


/*
===============================================================================
50. CTE COM CONSULTA DE VERIFICAÇÃO DE GRANULARIDADE
===============================================================================

O objetivo é comparar a quantidade de linhas do catálogo com o resultado
do relatório.

A consulta externa deve continuar apresentando uma linha por produto.
*/

WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades
    FROM techstore.itens_pedido
    GROUP BY produto_id
),

avaliacoes AS (
    SELECT
        produto_id,
        COUNT(*) AS quantidade
    FROM techstore.avaliacoes
    GROUP BY produto_id
),

relatorio AS (
    SELECT
        p.id AS produto_id,
        COALESCE(v.unidades, 0) AS unidades,
        COALESCE(a.quantidade, 0) AS quantidade_avaliacoes
    FROM techstore.produtos AS p
    LEFT JOIN vendas AS v
        ON v.produto_id = p.id
    LEFT JOIN avaliacoes AS a
        ON a.produto_id = p.id
)

SELECT
    COUNT(*) AS total_linhas,
    COUNT(DISTINCT produto_id) AS produtos_distintos,
    COUNT(*) - COUNT(DISTINCT produto_id) AS linhas_duplicadas
FROM relatorio;


/*
===============================================================================
FIM DO MÓDULO 08
===============================================================================

PRÓXIMOS CONTEÚDOS:

Módulo 09 — Window Functions.

RECOMENDAÇÃO DE ESTUDO
----------------------
1. Leia a teoria.
2. Execute os exemplos individualmente.
3. Modifique os filtros e expressões.
4. Compare os resultados.
5. Observe a granularidade.
6. Experimente EXPLAIN.
7. Utilize EXPLAIN ANALYZE somente quando necessário.
8. Resolva as atividades sem consultar soluções prontas.

Este arquivo é um material de referência e não substitui as atividades
ou a validação independente.
===============================================================================
*/