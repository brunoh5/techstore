/*
===============================================================================
CURSO SQL — TECHSTORE
MÓDULO 05 — JOINS
Arquivo: consultas.sql
Banco: PostgreSQL 16

OBJETIVO
Estudar os diferentes tipos de JOIN, relacionamentos entre tabelas,
cardinalidade, agregações e análise de execução.

IMPORTANTE
- Todos os exemplos são somente leitura.
- Nenhum comando modifica os dados.
- Os exemplos são demonstrações, não gabaritos das atividades.
- Execute uma consulta por vez.
- Observe a quantidade de linhas retornadas.
- Não presuma que uma junção 1:N produzirá uma linha por entidade principal.
- EXPLAIN ANALYZE executa a consulta e pode consumir recursos.

===============================================================================
*/


/*
===============================================================================
01. INNER JOIN
===============================================================================

Retorna somente os registros que possuem correspondência nos dois lados.

Estudo:
- condição de relacionamento;
- chave primária;
- chave estrangeira;
- aliases.
*/

SELECT
    c.id AS cliente_id,
    c.nome AS cliente,
    p.id AS pedido_id,
    p.data_pedido,
    p.status
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.cliente_id = c.id
ORDER BY
    p.data_pedido DESC
LIMIT 20;


/*
===============================================================================
02. INNER JOIN ENTRE PRODUTOS E ITENS DE PEDIDO
===============================================================================

Estudo:
- relacionamento entre produtos e itens;
- cardinalidade 1:N;
- repetição de produtos em diferentes itens.
*/

SELECT
    pr.id AS produto_id,
    pr.nome AS produto,
    ip.id AS item_id,
    ip.pedido_id,
    ip.quantidade,
    ip.preco_unitario
FROM produtos AS pr
INNER JOIN itens_pedido AS ip
    ON ip.produto_id = pr.id
ORDER BY
    pr.id,
    ip.pedido_id
LIMIT 30;


/*
===============================================================================
03. LEFT JOIN
===============================================================================

Preserva todos os registros da tabela à esquerda.

Quando não existe correspondência, as colunas da tabela à direita
aparecem como NULL.
*/

SELECT
    c.id AS cliente_id,
    c.nome AS cliente,
    p.id AS pedido_id,
    p.data_pedido
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.cliente_id = c.id
ORDER BY
    c.id
LIMIT 30;


/*
===============================================================================
04. LEFT JOIN COM COUNT
===============================================================================

Demonstra uma contagem de registros relacionados.

Observe:
- COUNT(*) conta as linhas do resultado da junção.
- COUNT(p.id) conta somente os pedidos correspondentes.
*/

SELECT
    c.id,
    c.nome,
    COUNT(*) AS linhas_resultantes,
    COUNT(p.id) AS quantidade_pedidos
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.cliente_id = c.id
GROUP BY
    c.id,
    c.nome
ORDER BY
    quantidade_pedidos DESC,
    c.id
LIMIT 30;


/*
===============================================================================
05. RIGHT JOIN
===============================================================================

Preserva todos os registros da tabela à direita.

Estude como a ordem das tabelas influencia a preservação dos registros.
*/

SELECT
    p.id AS pedido_id,
    p.data_pedido,
    c.id AS cliente_id,
    c.nome AS cliente
FROM clientes AS c
RIGHT JOIN pedidos AS p
    ON p.cliente_id = c.id
ORDER BY
    p.id DESC
LIMIT 20;


/*
===============================================================================
06. FULL OUTER JOIN
===============================================================================

Preserva os registros dos dois lados:
- correspondentes;
- exclusivos da tabela esquerda;
- exclusivos da tabela direita.

As chaves estrangeiras do banco podem fazer com que não existam
registros sem correspondência nesse relacionamento específico.
*/

SELECT
    c.id AS cliente_id,
    c.nome AS cliente,
    p.id AS pedido_id,
    p.data_pedido
FROM clientes AS c
FULL OUTER JOIN pedidos AS p
    ON p.cliente_id = c.id
ORDER BY
    c.id NULLS LAST,
    p.id NULLS LAST
LIMIT 30;


/*
===============================================================================
07. CROSS JOIN
===============================================================================

Produz o produto cartesiano entre as tabelas.

Quantidade de linhas:
quantidade da tabela A × quantidade da tabela B.

Atenção:
O resultado pode crescer rapidamente.
*/

SELECT
    cat.id AS categoria_id,
    cat.nome AS categoria,
    m.id AS marca_id,
    m.nome AS marca
FROM categorias AS cat
CROSS JOIN marcas AS m
ORDER BY
    cat.id,
    m.id
LIMIT 50;


/*
===============================================================================
08. MÚLTIPLAS TABELAS
===============================================================================

Relacionamento:
clientes → pedidos → itens_pedido → produtos

Observe como cada JOIN percorre uma relação diferente.
A granularidade final é de itens de pedidos, não de clientes.
*/

SELECT
    c.id AS cliente_id,
    c.nome AS cliente,
    p.id AS pedido_id,
    p.data_pedido,
    ip.id AS item_id,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.cliente_id = c.id
INNER JOIN itens_pedido AS ip
    ON ip.pedido_id = p.id
INNER JOIN produtos AS pr
    ON pr.id = ip.produto_id
ORDER BY
    p.id,
    ip.id
LIMIT 40;


/*
===============================================================================
09. PRODUTOS, CATEGORIAS E MARCAS
===============================================================================

Relacionamento entre tabelas de dimensão.

Observe como os dados descritivos são combinados com a tabela principal.
*/

SELECT
    pr.id AS produto_id,
    pr.nome AS produto,
    pr.preco,
    cat.nome AS categoria,
    m.nome AS marca
FROM produtos AS pr
INNER JOIN categorias AS cat
    ON cat.id = pr.categoria_id
INNER JOIN marcas AS m
    ON m.id = pr.marca_id
ORDER BY
    cat.nome,
    pr.nome
LIMIT 40;


/*
===============================================================================
10. FUNCIONÁRIOS E DEPARTAMENTOS
===============================================================================
*/

SELECT
    f.id AS funcionario_id,
    f.nome AS funcionario,
    f.email,
    d.id AS departamento_id,
    d.nome AS departamento
FROM funcionarios AS f
INNER JOIN departamentos AS d
    ON d.id = f.departamento_id
ORDER BY
    d.nome,
    f.nome;


/*
===============================================================================
11. PRODUTOS E ESTOQUE
===============================================================================

Relacionamento entre produto e estoque.

O relacionamento utiliza a chave produto_id da tabela estoque.
*/

SELECT
    pr.id AS produto_id,
    pr.nome AS produto,
    pr.preco,
    e.quantidade,
    e.estoque_minimo,
    e.atualizado_em
FROM produtos AS pr
LEFT JOIN estoque AS e
    ON e.produto_id = pr.id
ORDER BY
    pr.id
LIMIT 40;


/*
===============================================================================
12. LEFT JOIN COM FILTRO NO ON
===============================================================================

Demonstra uma condição adicional na junção.

O filtro restringe quais registros da tabela direita podem corresponder,
mas preserva os registros da tabela esquerda.
*/

SELECT
    c.id,
    c.nome,
    p.id AS pedido_id,
    p.status
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.cliente_id = c.id
    AND p.status = 'entregue'
ORDER BY
    c.id
LIMIT 30;


/*
===============================================================================
13. LEFT JOIN COM FILTRO NO WHERE
===============================================================================

Compare com o exemplo anterior.

O WHERE é aplicado ao resultado da consulta e pode eliminar linhas
nas quais as colunas da tabela direita são NULL.
*/

SELECT
    c.id,
    c.nome,
    p.id AS pedido_id,
    p.status
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.cliente_id = c.id
WHERE
    p.status = 'entregue'
ORDER BY
    c.id
LIMIT 30;


/*
===============================================================================
14. JOIN COM GROUP BY
===============================================================================

Agrega itens por produto.

A consulta trabalha com a granularidade dos itens relacionados
a cada produto.
*/

SELECT
    pr.id AS produto_id,
    pr.nome AS produto,
    COUNT(ip.id) AS quantidade_itens,
    SUM(ip.quantidade) AS unidades_vendidas
FROM produtos AS pr
LEFT JOIN itens_pedido AS ip
    ON ip.produto_id = pr.id
GROUP BY
    pr.id,
    pr.nome
ORDER BY
    unidades_vendidas DESC NULLS LAST,
    pr.id
LIMIT 30;


/*
===============================================================================
15. JOIN COM HAVING
===============================================================================

HAVING filtra os grupos depois da agregação.
*/

SELECT
    c.id,
    c.nome,
    COUNT(p.id) AS quantidade_pedidos
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.cliente_id = c.id
GROUP BY
    c.id,
    c.nome
HAVING
    COUNT(p.id) > 5
ORDER BY
    quantidade_pedidos DESC
LIMIT 30;


/*
===============================================================================
16. ENCONTRANDO REGISTROS SEM CORRESPONDÊNCIA
===============================================================================

Padrão conhecido como anti-join.

O LEFT JOIN preserva os registros da tabela esquerda.
A condição IS NULL identifica os que não encontraram correspondência.
*/

SELECT
    c.id,
    c.nome,
    c.email
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.cliente_id = c.id
WHERE
    p.id IS NULL
ORDER BY
    c.id
LIMIT 30;


/*
===============================================================================
17. ANTI-JOIN COM NOT EXISTS
===============================================================================

A mesma ideia pode ser expressa com NOT EXISTS.

Compare a leitura e os planos de execução com a consulta anterior.
*/

SELECT
    c.id,
    c.nome,
    c.email
FROM clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos AS p
    WHERE p.cliente_id = c.id
)
ORDER BY
    c.id
LIMIT 30;


/*
===============================================================================
18. GRANULARIDADE E CARDINALIDADE
===============================================================================

A consulta retorna uma linha por item de pedido.

Um pedido pode possuir vários itens.
Por isso, o mesmo pedido pode aparecer em várias linhas.

Não interprete a quantidade de linhas como quantidade de pedidos.
*/

SELECT
    p.id AS pedido_id,
    p.data_pedido,
    COUNT(ip.id) AS quantidade_itens
FROM pedidos AS p
INNER JOIN itens_pedido AS ip
    ON ip.pedido_id = p.id
GROUP BY
    p.id,
    p.data_pedido
ORDER BY
    quantidade_itens DESC,
    p.id
LIMIT 30;


/*
===============================================================================
19. EXEMPLO DE DUPLA CONTAGEM
===============================================================================

ATENÇÃO: exemplo conceitual de risco.

Quando duas relações 1:N são combinadas, as linhas podem se multiplicar.
Uma métrica pertencente a uma das relações pode ser repetida no resultado.

Não utilize SUM de valores de tabelas diferentes sem verificar
a granularidade da junção.
*/

SELECT
    p.id AS pedido_id,
    COUNT(DISTINCT ip.id) AS quantidade_itens,
    COUNT(DISTINCT pg.id) AS quantidade_registros_pagamento
FROM pedidos AS p
LEFT JOIN itens_pedido AS ip
    ON ip.pedido_id = p.id
LEFT JOIN pagamentos AS pg
    ON pg.pedido_id = p.id
GROUP BY
    p.id
ORDER BY
    p.id
LIMIT 30;


/*
===============================================================================
20. AGREGAÇÃO PRÉVIA COM CTE
===============================================================================

Uma maneira de controlar a granularidade é agregar uma relação antes
de combiná-la com outra tabela.

Este exemplo calcula a quantidade de itens por pedido antes da junção.
*/

WITH itens_por_pedido AS (
    SELECT
        pedido_id,
        COUNT(*) AS quantidade_itens,
        SUM(quantidade) AS unidades
    FROM itens_pedido
    GROUP BY
        pedido_id
)
SELECT
    p.id AS pedido_id,
    p.data_pedido,
    ipp.quantidade_itens,
    ipp.unidades
FROM pedidos AS p
LEFT JOIN itens_por_pedido AS ipp
    ON ipp.pedido_id = p.id
ORDER BY
    p.id DESC
LIMIT 30;


/*
===============================================================================
21. JOIN COM SUBCONSULTA
===============================================================================

A subconsulta agrega os itens antes de relacioná-los aos produtos.
*/

SELECT
    pr.id,
    pr.nome,
    resumo.total_unidades,
    resumo.total_itens
FROM produtos AS pr
LEFT JOIN (
    SELECT
        produto_id,
        SUM(quantidade) AS total_unidades,
        COUNT(*) AS total_itens
    FROM itens_pedido
    GROUP BY
        produto_id
) AS resumo
    ON resumo.produto_id = pr.id
ORDER BY
    resumo.total_unidades DESC NULLS LAST,
    pr.id
LIMIT 30;


/*
===============================================================================
22. JOIN COM FUNÇÕES DE AGREGAÇÃO E FILTROS
===============================================================================

Demonstra a combinação de:
- JOIN;
- WHERE;
- GROUP BY;
- HAVING;
- ORDER BY.
*/

SELECT
    pr.id,
    pr.nome,
    SUM(ip.quantidade) AS unidades_vendidas,
    AVG(ip.preco_unitario) AS preco_medio_praticado
FROM produtos AS pr
INNER JOIN itens_pedido AS ip
    ON ip.produto_id = pr.id
WHERE
    ip.quantidade > 0
GROUP BY
    pr.id,
    pr.nome
HAVING
    SUM(ip.quantidade) > 10
ORDER BY
    unidades_vendidas DESC
LIMIT 30;


/*
===============================================================================
23. EXPLAIN
===============================================================================

Mostra o plano estimado sem executar a consulta.

Observe:
- tipo de junção;
- estimativa de linhas;
- custo estimado;
- condições de acesso.
*/

EXPLAIN
SELECT
    c.id,
    c.nome,
    p.id AS pedido_id
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.cliente_id = c.id
WHERE
    c.ativo = TRUE;


/*
===============================================================================
24. EXPLAIN ANALYZE E BUFFERS
===============================================================================

Executa a consulta e apresenta informações reais de execução.

Observe:
- Planning Time;
- Execution Time;
- Actual Rows;
- Rows Removed by Filter;
- Shared Hit Blocks;
- Shared Read Blocks;
- método de junção.

Atenção:
A consulta pode acessar uma quantidade significativa de registros.
Execute individualmente e não a repita desnecessariamente.
*/

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.id,
    c.nome,
    p.id AS pedido_id,
    p.data_pedido
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.cliente_id = c.id
WHERE
    p.data_pedido >= CURRENT_DATE - INTERVAL '90 days';


/*
===============================================================================
25. COMPARAÇÃO DE ESTRATÉGIAS
===============================================================================

Compare os planos das duas consultas:

A) LEFT JOIN + IS NULL
B) NOT EXISTS

Objetivo:
- verificar se os planos são semelhantes;
- observar os métodos de execução;
- comparar estimativas e linhas reais;
- evitar conclusões baseadas apenas no tempo de uma execução.

Não existe garantia de que uma forma será sempre mais rápida.
O PostgreSQL pode transformar ambas em estratégias de execução semelhantes.
*/


/*
===============================================================================
26. CONSULTA DE INSPEÇÃO DE ÍNDICES
===============================================================================

Permite observar índices existentes nas tabelas utilizadas nos estudos.

Não cria nem modifica índices.
*/

SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'techstore'
  AND tablename IN (
      'clientes',
      'pedidos',
      'itens_pedido',
      'produtos',
      'estoque'
  )
ORDER BY
    tablename,
    indexname;


/*
===============================================================================
FIM DO ARQUIVO
===============================================================================

RECOMENDAÇÕES DE ESTUDO

1. Execute cada exemplo individualmente.
2. Antes de executar, tente prever o tipo de resultado.
3. Observe a quantidade de linhas retornadas.
4. Identifique a granularidade de cada consulta.
5. Compare INNER JOIN com LEFT JOIN.
6. Compare LEFT JOIN + IS NULL com NOT EXISTS.
7. Analise os efeitos de ON e WHERE.
8. Observe como agregações podem ser afetadas pela cardinalidade.
9. Utilize EXPLAIN antes de EXPLAIN ANALYZE.
10. Não altere o banco principal durante os estudos.

Este arquivo é uma referência de demonstração.
As atividades e os desafios devem ser resolvidos de maneira independente.
===============================================================================
*/