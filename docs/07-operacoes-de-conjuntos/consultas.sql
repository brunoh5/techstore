/*
===============================================================================
MÓDULO 07 — OPERAÇÕES DE CONJUNTOS
Banco: TechStore
SGBD: PostgreSQL 16

Arquivo: consultas.sql

Objetivo:
Apresentar exemplos de operações de conjuntos, suas diferenças,
comportamentos, aplicações e análise de desempenho.

IMPORTANTE:
- Este arquivo contém consultas de leitura.
- Não modifica tabelas ou registros.
- Não execute novamente os arquivos de seed.
- Execute os exemplos individualmente.
- EXPLAIN ANALYZE executa a consulta analisada.
===============================================================================
*/


/*
===============================================================================
01. UNION
===============================================================================

Combina resultados e elimina linhas duplicadas.

As consultas precisam possuir:
- A mesma quantidade de colunas.
- Tipos de dados compatíveis.
- Correspondência posicional entre as colunas.
*/

SELECT cliente_id AS pessoa_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

UNION

SELECT cliente_id AS pessoa_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;


/*
===============================================================================
02. UNION ALL
===============================================================================

Combina resultados preservando todas as ocorrências.

Diferentemente de UNION, não elimina duplicidades.
*/

SELECT cliente_id AS pessoa_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

UNION ALL

SELECT cliente_id AS pessoa_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;


/*
===============================================================================
03. UNION COM IDENTIFICAÇÃO DA ORIGEM
===============================================================================

Quando combinamos entidades de tabelas diferentes, devemos identificar
a origem dos registros.

O ID de um cliente não representa necessariamente a mesma entidade
que um ID de funcionário com o mesmo valor.
*/

SELECT
    id,
    nome,
    'cliente' AS tipo_entidade
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome,
    'funcionario' AS tipo_entidade
FROM techstore.funcionarios;


/*
===============================================================================
04. UNION COM ORDER BY
===============================================================================

A ordenação abaixo é aplicada ao resultado combinado.

Os nomes das colunas do resultado são definidos pela primeira consulta.
*/

SELECT
    id AS identificador,
    nome
FROM techstore.clientes

UNION

SELECT
    id,
    nome
FROM techstore.funcionarios

ORDER BY identificador;


/*
===============================================================================
05. UNION COM LIMIT
===============================================================================

O LIMIT abaixo restringe o resultado final da operação.
*/

SELECT
    id,
    nome
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome
FROM techstore.funcionarios

ORDER BY nome
LIMIT 20;


/*
===============================================================================
06. INTERSECT
===============================================================================

Retorna linhas presentes nos dois resultados.

As duplicidades são eliminadas.
*/

SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

INTERSECT

SELECT cliente_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;


/*
===============================================================================
07. INTERSECT COM PRODUTOS
===============================================================================

Identifica produtos que possuem vendas e avaliações.
*/

SELECT produto_id
FROM techstore.itens_pedido

INTERSECT

SELECT produto_id
FROM techstore.avaliacoes;


/*
===============================================================================
08. INTERSECT ALL
===============================================================================

Preserva a quantidade de ocorrências compartilhadas entre os resultados.

Exemplo conceitual utilizando conjuntos pequenos.
*/

SELECT valor
FROM (
    VALUES
        (10),
        (10),
        (10),
        (20),
        (30)
) AS conjunto_a(valor)

INTERSECT ALL

SELECT valor
FROM (
    VALUES
        (10),
        (10),
        (20),
        (40)
) AS conjunto_b(valor);


/*
===============================================================================
09. EXCEPT
===============================================================================

Retorna linhas presentes na primeira consulta e ausentes na segunda.

A ordem das consultas importa.
*/

SELECT id
FROM techstore.clientes

EXCEPT

SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


/*
===============================================================================
10. EXCEPT PARA PRODUTOS
===============================================================================

Identifica produtos avaliados que não aparecem nos itens de pedidos.
*/

SELECT produto_id
FROM techstore.avaliacoes

EXCEPT

SELECT produto_id
FROM techstore.itens_pedido;


/*
===============================================================================
11. EXCEPT ALL
===============================================================================

Subtrai as multiplicidades das linhas.

Exemplo conceitual com valores repetidos.
*/

SELECT valor
FROM (
    VALUES
        (10),
        (10),
        (10),
        (20),
        (30)
) AS conjunto_a(valor)

EXCEPT ALL

SELECT valor
FROM (
    VALUES
        (10),
        (20),
        (40)
) AS conjunto_b(valor);


/*
===============================================================================
12. COMPARAÇÃO DOS SEIS OPERADORES
===============================================================================

Os exemplos utilizam os mesmos conjuntos para permitir a comparação.

Observe:
- UNION: combina e elimina duplicidades.
- UNION ALL: combina preservando duplicidades.
- INTERSECT: linhas comuns sem duplicidades.
- INTERSECT ALL: linhas comuns considerando multiplicidades.
- EXCEPT: diferença sem duplicidades.
- EXCEPT ALL: subtração de multiplicidades.
*/

-- UNION
SELECT valor
FROM (VALUES (1), (1), (2), (3)) AS a(valor)

UNION

SELECT valor
FROM (VALUES (1), (2), (2), (4)) AS b(valor);


-- UNION ALL
SELECT valor
FROM (VALUES (1), (1), (2), (3)) AS a(valor)

UNION ALL

SELECT valor
FROM (VALUES (1), (2), (2), (4)) AS b(valor);


-- INTERSECT
SELECT valor
FROM (VALUES (1), (1), (2), (3)) AS a(valor)

INTERSECT

SELECT valor
FROM (VALUES (1), (2), (2), (4)) AS b(valor);


-- INTERSECT ALL
SELECT valor
FROM (VALUES (1), (1), (2), (3)) AS a(valor)

INTERSECT ALL

SELECT valor
FROM (VALUES (1), (2), (2), (4)) AS b(valor);


-- EXCEPT
SELECT valor
FROM (VALUES (1), (1), (2), (3)) AS a(valor)

EXCEPT

SELECT valor
FROM (VALUES (1), (2), (2), (4)) AS b(valor);


-- EXCEPT ALL
SELECT valor
FROM (VALUES (1), (1), (2), (3)) AS a(valor)

EXCEPT ALL

SELECT valor
FROM (VALUES (1), (2), (2), (4)) AS b(valor);


/*
===============================================================================
13. TRATAMENTO DE NULL
===============================================================================

Nas operações de conjuntos, valores NULL são tratados como equivalentes
para fins de comparação de linhas, deduplicação e correspondência.

Isso não significa que NULL passe a ser igual a NULL em uma comparação
convencional utilizando o operador =.
*/

SELECT valor
FROM (
    VALUES
        (NULL::INTEGER),
        (NULL::INTEGER),
        (10),
        (20)
) AS a(valor)

UNION

SELECT valor
FROM (
    VALUES
        (NULL::INTEGER),
        (10),
        (30)
) AS b(valor);


/*
===============================================================================
14. INTERSECT COM NULL
===============================================================================
*/

SELECT valor
FROM (
    VALUES
        (NULL::INTEGER),
        (10),
        (20)
) AS a(valor)

INTERSECT

SELECT valor
FROM (
    VALUES
        (NULL::INTEGER),
        (10),
        (30)
) AS b(valor);


/*
===============================================================================
15. EXCEPT COM NULL
===============================================================================
*/

SELECT valor
FROM (
    VALUES
        (NULL::INTEGER),
        (10),
        (20)
) AS a(valor)

EXCEPT

SELECT valor
FROM (
    VALUES
        (NULL::INTEGER),
        (30)
) AS b(valor);


/*
===============================================================================
16. OPERAÇÕES ENCADEADAS
===============================================================================

É possível combinar mais de duas consultas.

A precedência dos operadores deve ser considerada:

- INTERSECT possui precedência maior.
- UNION e EXCEPT possuem a mesma precedência e são avaliados da esquerda
  para a direita.

Parênteses podem ser utilizados para deixar a intenção explícita.
*/

SELECT valor
FROM (VALUES (1), (2), (3), (4)) AS a(valor)

UNION

SELECT valor
FROM (VALUES (3), (4), (5)) AS b(valor)

INTERSECT

SELECT valor
FROM (VALUES (4), (5), (6)) AS c(valor);


/*
===============================================================================
17. OPERAÇÕES COM PARÊNTESES
===============================================================================

Os parênteses permitem controlar a ordem de avaliação.
Compare este exemplo com o anterior.
*/

(
    SELECT valor
    FROM (VALUES (1), (2), (3), (4)) AS a(valor)

    UNION

    SELECT valor
    FROM (VALUES (3), (4), (5)) AS b(valor)
)

INTERSECT

SELECT valor
FROM (VALUES (4), (5), (6)) AS c(valor);


/*
===============================================================================
18. UNION COM FILTROS
===============================================================================

Cada consulta pode possuir seus próprios filtros.
*/

SELECT
    id AS produto_id
FROM techstore.produtos
WHERE ativo = TRUE

UNION

SELECT
    produto_id
FROM techstore.estoque
WHERE quantidade <= estoque_minimo;


/*
===============================================================================
19. OPERAÇÕES DE CONJUNTOS COM AGREGAÇÕES
===============================================================================

As consultas participantes podem utilizar funções agregadas.

É importante manter a mesma estrutura e granularidade.
*/

SELECT
    'clientes' AS origem,
    COUNT(*) AS quantidade
FROM techstore.clientes

UNION ALL

SELECT
    'funcionarios' AS origem,
    COUNT(*) AS quantidade
FROM techstore.funcionarios

UNION ALL

SELECT
    'produtos' AS origem,
    COUNT(*) AS quantidade
FROM techstore.produtos;


/*
===============================================================================
20. OPERAÇÕES DE CONJUNTOS COM AGRUPAMENTO
===============================================================================

Exemplo de combinação de quantidades de produtos por categoria.

A coluna de origem diferencia os resultados.
*/

SELECT
    categoria_id,
    COUNT(*) AS quantidade,
    'todos' AS origem
FROM techstore.produtos
GROUP BY categoria_id

UNION ALL

SELECT
    categoria_id,
    COUNT(*) AS quantidade,
    'ativos' AS origem
FROM techstore.produtos
WHERE ativo = TRUE
GROUP BY categoria_id

ORDER BY categoria_id, origem;


/*
===============================================================================
21. OPERAÇÃO DE CONJUNTOS EM CTE
===============================================================================

CTEs ajudam a organizar consultas compostas.
*/

WITH clientes_ativos AS (
    SELECT id
    FROM techstore.clientes
    WHERE ativo = TRUE
),
clientes_com_pedidos AS (
    SELECT cliente_id AS id
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL
),
clientes_relacionados AS (
    SELECT id
    FROM clientes_ativos

    INTERSECT

    SELECT id
    FROM clientes_com_pedidos
)
SELECT id
FROM clientes_relacionados
ORDER BY id;


/*
===============================================================================
22. OPERAÇÃO DE CONJUNTOS EM SUBCONSULTA
===============================================================================

O resultado de uma operação pode ser utilizado como fonte de outra consulta.
*/

SELECT
    p.id,
    p.nome,
    p.preco
FROM techstore.produtos AS p
WHERE p.id IN (
    SELECT produto_id
    FROM techstore.itens_pedido

    INTERSECT

    SELECT produto_id
    FROM techstore.avaliacoes
);


/*
===============================================================================
23. COMPARAÇÃO: INTERSECT E INNER JOIN
===============================================================================

A primeira consulta utiliza INTERSECT.
A segunda utiliza INNER JOIN.

Como itens_pedido pode possuir várias linhas para o mesmo produto,
o JOIN pode produzir repetições.

O DISTINCT permite comparar o conjunto de identificadores.
*/

-- INTERSECT
SELECT produto_id
FROM techstore.itens_pedido

INTERSECT

SELECT produto_id
FROM techstore.avaliacoes;


-- INNER JOIN com DISTINCT
SELECT DISTINCT
    ip.produto_id
FROM techstore.itens_pedido AS ip
INNER JOIN techstore.avaliacoes AS a
    ON a.produto_id = ip.produto_id;


/*
===============================================================================
24. COMPARAÇÃO: EXCEPT E NOT EXISTS
===============================================================================

Ambas as abordagens podem identificar clientes sem pedidos.

A consulta utiliza a chave primária de clientes como referência.
*/

-- EXCEPT
SELECT id
FROM techstore.clientes

EXCEPT

SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;


-- NOT EXISTS
SELECT
    c.id
FROM techstore.clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM techstore.pedidos AS p
    WHERE p.cliente_id = c.id
);


/*
===============================================================================
25. COMPARAÇÃO: INTERSECT E EXISTS
===============================================================================

As duas abordagens identificam clientes que possuem pedidos e acessos.

A comparação considera somente os identificadores de clientes.
*/

-- INTERSECT
SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

INTERSECT

SELECT cliente_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;


-- EXISTS
SELECT DISTINCT
    p.cliente_id
FROM techstore.pedidos AS p
WHERE p.cliente_id IS NOT NULL
  AND EXISTS (
      SELECT 1
      FROM techstore.acessos AS a
      WHERE a.cliente_id = p.cliente_id
  );


/*
===============================================================================
26. GRANULARIDADE E ORIGEM
===============================================================================

Exemplo de consolidação de atividades.

A coluna tipo_evento evita misturar eventos de naturezas diferentes.
*/

SELECT
    cliente_id AS entidade_id,
    data_pedido AS ocorrido_em,
    'pedido' AS tipo_evento
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

UNION ALL

SELECT
    cliente_id,
    data_acesso,
    'acesso'
FROM techstore.acessos
WHERE cliente_id IS NOT NULL

ORDER BY ocorrido_em DESC;


/*
===============================================================================
27. EXPLAIN
===============================================================================

EXPLAIN apresenta o plano estimado sem executar a consulta.

Observe os nós relacionados à operação de conjuntos.
*/

EXPLAIN
SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

UNION

SELECT cliente_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;


/*
===============================================================================
28. EXPLAIN ANALYZE E BUFFERS
===============================================================================

EXPLAIN ANALYZE executa a consulta e apresenta métricas reais.

Observe:
- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Nós de execução.

Execute individualmente e compare com o EXPLAIN anterior.
*/

EXPLAIN (ANALYZE, BUFFERS)
SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

UNION

SELECT cliente_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;


/*
===============================================================================
29. COMPARAÇÃO DE DESEMPENHO: UNION E UNION ALL
===============================================================================

Compare os planos e os tempos das duas consultas.

A diferença semântica deve ser considerada antes de qualquer conclusão
de desempenho.

UNION elimina duplicidades.
UNION ALL preserva duplicidades.

Execute as consultas separadamente.
*/

EXPLAIN (ANALYZE, BUFFERS)
SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

UNION

SELECT cliente_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;


EXPLAIN (ANALYZE, BUFFERS)
SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

UNION ALL

SELECT cliente_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;


/*
===============================================================================
30. CONSULTA FINAL DE EXPLORAÇÃO
===============================================================================

Consolidação de produtos que possuem vendas, avaliações ou estoque abaixo
do mínimo.

O uso de UNION ALL preserva a origem de cada ocorrência.

Um produto pode aparecer mais de uma vez, pois pode satisfazer mais de
uma condição. Isso é intencional neste exemplo.
*/

SELECT
    produto_id,
    'vendido' AS situacao
FROM techstore.itens_pedido

UNION ALL

SELECT
    produto_id,
    'avaliado'
FROM techstore.avaliacoes

UNION ALL

SELECT
    produto_id,
    'estoque_baixo'
FROM techstore.estoque
WHERE quantidade <= estoque_minimo

ORDER BY produto_id, situacao;


/*
===============================================================================
FIM DO ARQUIVO
===============================================================================

Orientação de estudo:

1. Execute cada exemplo individualmente.
2. Observe os resultados.
3. Compare os operadores.
4. Altere os conjuntos de VALUES para testar duplicidades e multiplicidades.
5. Teste NULL e conjuntos vazios.
6. Explique o resultado antes de executar.
7. Utilize EXPLAIN para estudar os planos.
8. Utilize EXPLAIN ANALYZE somente quando necessário.

Não considere o fato de uma consulta executar sem erro como prova de
que seu resultado está semanticamente correto.

A validação do módulo está descrita em validacao.md.
===============================================================================
*/