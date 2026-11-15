# Teoria — Módulo 06: Subconsultas SQL

# 1. Introdução às subconsultas

## 1.1 O que são subconsultas?

Uma subconsulta (*subquery*) é uma instrução SQL inserida dentro de outra instrução SQL.

Ela permite que o resultado de uma consulta seja utilizado por outra consulta.

Imagine o seguinte problema:

**Encontrar todos os produtos cujo preço seja superior à média de preços dos produtos da TechStore.**

Para resolver esse problema, precisamos de duas operações:

1. Calcular a média dos preços.
2. Encontrar os produtos com preço superior à média calculada.

Uma subconsulta permite realizar essas operações dentro de uma única instrução SQL.

Conceitualmente:

```sql
SELECT produtos
FROM produtos
WHERE preco > (
    SELECT media_dos_precos
    FROM produtos
);
```

A consulta interna produz um resultado utilizado pela consulta externa.

## 1.2 Consulta externa e consulta interna

Uma subconsulta possui dois componentes conceituais:

- Consulta externa (*outer query*): consulta principal.
- Consulta interna (*inner query*): consulta executada dentro da principal.

A consulta interna pode fornecer:

- Um único valor.
- Uma coluna com vários valores.
- Uma tabela derivada.
- Uma condição de existência.

A forma de utilização depende do resultado que a subconsulta produz.

## 1.3 Quando utilizar subconsultas?

São particularmente úteis quando precisamos:

- Comparar registros com uma média.
- Filtrar registros com base em outra tabela.
- Verificar a existência de relacionamentos.
- Encontrar registros sem correspondência.
- Calcular indicadores intermediários.
- Criar conjuntos de resultados derivados.
- Separar etapas lógicas de uma consulta complexa.

Uma subconsulta não é necessariamente melhor que um JOIN. A escolha depende do problema, da clareza e do plano de execução.

---

# 2. Tipos de subconsultas

As subconsultas podem ser classificadas de acordo com o resultado produzido e sua relação com a consulta externa.

## 2.1 Subconsulta escalar

Uma subconsulta escalar retorna exatamente um valor: uma linha e uma coluna.

Exemplo:

```sql
SELECT
    nome,
    preco
FROM produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos
);
```

A subconsulta:

```sql
SELECT AVG(preco)
FROM produtos;
```

Retorna um único valor numérico.

A consulta externa compara o preço de cada produto com esse valor.

### Características

- Retorna uma coluna.
- Deve retornar no máximo uma linha quando utilizada em um contexto escalar.
- Pode ser utilizada em expressões e comparações.
- Pode retornar NULL, dependendo da consulta interna.

**Atenção:** no PostgreSQL, se uma subconsulta escalar retornar mais de uma linha, ocorrerá um erro.

Uma subconsulta agregada sem `GROUP BY`, como `AVG`, normalmente retorna uma linha, mesmo quando a tabela não possui registros correspondentes. Nesse caso, o resultado da média será NULL.

## 2.2 Subconsulta de múltiplas linhas

Retorna uma coluna com vários valores.

Normalmente é utilizada com operadores como:

- `IN`
- `NOT IN`
- `ANY`
- `ALL`

Exemplo:

```sql
SELECT
    id,
    nome
FROM produtos
WHERE categoria_id IN (
    SELECT id
    FROM categorias
);
```

A consulta interna fornece uma lista de identificadores de categorias.

A consulta externa verifica se cada produto pertence a uma das categorias retornadas.

## 2.3 Subconsulta correlacionada

É uma subconsulta que utiliza valores da consulta externa.

Exemplo:

```sql
SELECT
    p.id,
    p.nome,
    p.preco
FROM produtos AS p
WHERE p.preco > (
    SELECT AVG(p2.preco)
    FROM produtos AS p2
    WHERE p2.categoria_id = p.categoria_id
);
```

Observe:

```sql
p2.categoria_id = p.categoria_id
```

A subconsulta utiliza a categoria do produto que está sendo avaliado pela consulta externa.

Isso significa que a comparação considera a média da categoria correspondente, e não a média geral de todos os produtos.

### Características

- Depende de valores da consulta externa.
- É avaliada semanticamente para cada contexto da linha externa.
- Pode ser transformada pelo otimizador em outra estratégia de execução.
- Pode apresentar custo elevado dependendo da estrutura e do plano escolhido.

**Importante:** não significa necessariamente que o PostgreSQL executará fisicamente a subconsulta uma vez para cada linha. O otimizador pode transformar a operação.

## 2.4 Subconsulta não correlacionada

Não depende de valores da consulta externa.

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos
);
```

A consulta interna não referencia nenhuma coluna da consulta externa.

Ela calcula um valor independente.

O PostgreSQL pode executar esse tipo de operação como um `InitPlan`, dependendo do contexto e do plano escolhido.

---

# 3. Subconsultas no WHERE

O `WHERE` é um dos locais mais comuns para utilizar subconsultas.

A consulta interna fornece valores ou condições utilizados para filtrar os registros externos.

## 3.1 Comparações escalares

Podemos utilizar operadores tradicionais:

- `=`
- `<>`
- `>`
- `>=`
- `<`
- `<=`

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos
);
```

A consulta retorna produtos com preço superior à média geral.

## 3.2 Comparação com outra tabela

Exemplo conceitual:

```sql
SELECT
    id,
    nome
FROM clientes
WHERE id IN (
    SELECT cliente_id
    FROM pedidos
);
```

A consulta interna identifica clientes que possuem pedidos.

A consulta externa retorna esses clientes.

## 3.3 Subconsultas com filtros

A consulta interna também pode possuir condições próprias.

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos
    WHERE ativo = TRUE
);
```

Nesse caso, a média considera apenas produtos ativos.

A consulta externa, entretanto, não possui obrigatoriamente o mesmo filtro.

Isso demonstra que as condições da consulta interna e externa são independentes, salvo quando existe correlação.

---

# 4. Subconsultas no SELECT

Uma subconsulta pode aparecer na lista de colunas do `SELECT`.

Nesse contexto, normalmente deve produzir um valor escalar.

Exemplo:

```sql
SELECT
    pr.id,
    pr.nome,
    pr.preco,
    (
        SELECT AVG(pr2.preco)
        FROM produtos AS pr2
    ) AS media_geral
FROM produtos AS pr
ORDER BY pr.id
LIMIT 20;
```

Cada linha retornada apresenta:

- Identificador do produto.
- Nome.
- Preço.
- Média geral dos preços.

A média é independente do produto.

## 4.1 Subconsulta correlacionada no SELECT

Podemos calcular um indicador relacionado a cada registro externo.

Exemplo:

```sql
SELECT
    c.id,
    c.nome,
    (
        SELECT COUNT(*)
        FROM pedidos AS p
        WHERE p.cliente_id = c.id
    ) AS quantidade_pedidos
FROM clientes AS c
ORDER BY c.id
LIMIT 30;
```

A subconsulta calcula a quantidade de pedidos de cada cliente.

A correlação ocorre em:

```sql
p.cliente_id = c.id
```

### Atenção ao desempenho

Uma consulta correlacionada no `SELECT` pode ser conveniente para expressar um cálculo individual, mas não deve ser considerada automaticamente mais rápida ou mais lenta que um JOIN com agregação.

O plano de execução deve ser analisado.

---

# 5. Subconsultas no FROM

Uma subconsulta no `FROM` produz uma relação derivada, também chamada de tabela derivada (*derived table*).

Ela precisa receber um alias no PostgreSQL.

Exemplo:

```sql
SELECT
    resumo.produto_id,
    resumo.unidades_vendidas
FROM (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM itens_pedido
    GROUP BY produto_id
) AS resumo
ORDER BY resumo.unidades_vendidas DESC
LIMIT 20;
```

A consulta interna calcula as unidades vendidas por produto.

A consulta externa utiliza esse resultado como se fosse uma tabela.

## 5.1 Características

- A subconsulta gera um conjunto de linhas e colunas.
- O resultado pode ser utilizado como uma relação.
- É obrigatório fornecer um alias para a tabela derivada no PostgreSQL.
- Pode ser combinada com outras tabelas.
- Pode realizar agregações antes de uma junção.

## 5.2 Por que utilizar?

Uma tabela derivada pode separar uma etapa complexa da consulta principal.

Também permite controlar a granularidade de um resultado antes de combiná-lo com outras relações.

Isso é especialmente importante quando existem múltiplos relacionamentos 1:N.

---

# 6. IN e NOT IN

## 6.1 IN

O operador `IN` verifica se um valor pertence a um conjunto.

Exemplo:

```sql
SELECT
    id,
    nome
FROM clientes
WHERE id IN (
    SELECT cliente_id
    FROM pedidos
);
```

O resultado contém clientes cujos identificadores aparecem na consulta interna.

É uma forma comum de filtrar registros com base em um conjunto produzido por outra consulta.

## 6.2 NOT IN

O operador `NOT IN` verifica se um valor não pertence ao conjunto retornado.

Exemplo:

```sql
SELECT
    id,
    nome
FROM produtos
WHERE id NOT IN (
    SELECT produto_id
    FROM itens_pedido
);
```

A intenção é encontrar produtos que não aparecem nos itens de pedidos.

### Atenção especial ao NULL

`NOT IN` possui um comportamento importante quando o conjunto contém `NULL`.

Considere:

```sql
SELECT 10
WHERE 10 NOT IN (1, 2, NULL);
```

O resultado não será verdadeiro.

A comparação produz `UNKNOWN`, pois não é possível determinar se o valor é diferente de todos os elementos quando um deles é desconhecido.

No SQL, `WHERE` mantém somente condições verdadeiras. Condições `FALSE` e `UNKNOWN` não são retornadas.

### Regra prática

Antes de utilizar `NOT IN`, verifique se a subconsulta pode retornar `NULL`.

Quando o objetivo for encontrar registros sem correspondência, `NOT EXISTS` frequentemente representa uma alternativa mais segura.

---

# 7. EXISTS e NOT EXISTS

## 7.1 EXISTS

O operador `EXISTS` verifica se a subconsulta retorna pelo menos uma linha.

Exemplo:

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
WHERE EXISTS (
    SELECT 1
    FROM pedidos AS p
    WHERE p.cliente_id = c.id
);
```

A consulta retorna clientes para os quais existe pelo menos um pedido.

Observe:

```sql
SELECT 1
```

O valor selecionado não é o objetivo principal. O operador verifica a existência de linhas.

## 7.2 NOT EXISTS

Verifica se a subconsulta não retorna nenhuma linha.

Exemplo:

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos AS p
    WHERE p.cliente_id = c.id
);
```

A consulta retorna clientes sem pedidos.

## 7.3 EXISTS versus IN

Ambos podem resolver problemas semelhantes.

Entretanto, possuem diferenças conceituais:

| IN | EXISTS |
|---|---|
| Verifica pertencimento a um conjunto | Verifica existência de linhas |
| Compara valores | Avalia a existência de correspondência |
| Pode apresentar problemas com NULL em `NOT IN` | `NOT EXISTS` evita esse problema específico |
| Pode ser adequado para listas de valores | É especialmente expressivo para relacionamentos |

O PostgreSQL pode transformar ambas as estratégias em planos semelhantes.

Não existe uma regra universal de que `EXISTS` sempre será mais rápido.

## 7.4 NOT EXISTS versus LEFT JOIN

Encontrar registros sem correspondência também pode ser feito com `LEFT JOIN` e uma verificação de `IS NULL`.

Exemplo:

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.cliente_id = c.id
WHERE p.id IS NULL;
```

Compare com:

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos AS p
    WHERE p.cliente_id = c.id
);
```

As duas formas expressam a ausência de correspondência nesse relacionamento.

A escolha deve considerar legibilidade, semântica e plano de execução.

---

# 8. ANY e ALL

Esses operadores permitem comparar um valor com os resultados de uma subconsulta.

## 8.1 ANY

`ANY` verifica se a comparação é verdadeira para pelo menos um dos valores retornados.

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco > ANY (
    SELECT preco
    FROM produtos
    WHERE categoria_id = 1
);
```

A condição será verdadeira se o preço do produto externo for superior ao preço de pelo menos um produto da categoria selecionada.

## 8.2 ALL

`ALL` exige que a comparação seja verdadeira para todos os valores retornados.

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco > ALL (
    SELECT preco
    FROM produtos
    WHERE categoria_id = 1
);
```

A condição exige que o preço do produto externo seja superior a todos os preços retornados pela subconsulta.

## 8.3 ANY e ALL com NULL

Os valores `NULL` também afetam a lógica de comparação.

Quando uma comparação não pode ser determinada, o resultado pode ser `UNKNOWN`.

Portanto, é necessário compreender:

- Se a subconsulta pode retornar NULL.
- Se o conjunto está vazio.
- Qual operador de comparação está sendo utilizado.

## 8.4 Conjunto vazio

No PostgreSQL:

- `ANY` sobre um conjunto vazio resulta em falso.
- `ALL` sobre um conjunto vazio resulta em verdadeiro.

Essa diferença é importante em situações com subconsultas que podem não retornar registros.

---

# 9. Subconsultas correlacionadas

## 9.1 Funcionamento

Uma subconsulta correlacionada depende de uma ou mais colunas da consulta externa.

Exemplo:

```sql
SELECT
    pr.id,
    pr.nome,
    pr.preco
FROM produtos AS pr
WHERE pr.preco > (
    SELECT AVG(pr2.preco)
    FROM produtos AS pr2
    WHERE pr2.categoria_id = pr.categoria_id
);
```

A consulta compara cada produto com a média de sua própria categoria.

O valor externo:

```sql
pr.categoria_id
```

é utilizado na consulta interna.

## 9.2 Diferença entre correlacionada e não correlacionada

| Característica | Não correlacionada | Correlacionada |
|---|---|---|
| Depende da consulta externa | Não | Sim |
| Referencia colunas externas | Não | Sim |
| Resultado independente | Sim | Não necessariamente |
| Pode ser otimizada | Sim | Sim |
| Pode utilizar valores diferentes por linha externa | Não diretamente | Sim |

## 9.3 Quando utilizar?

São úteis quando precisamos comparar cada registro com informações específicas relacionadas a ele.

Exemplos:

- Produto comparado à média de sua categoria.
- Cliente comparado à quantidade média de pedidos.
- Funcionário comparado à média salarial do departamento.
- Pedido comparado a outros pedidos do mesmo cliente.

## 9.4 Atenção ao desempenho

Subconsultas correlacionadas podem gerar planos com operações repetidas.

Entretanto, o PostgreSQL possui mecanismos de otimização e pode transformar determinadas consultas em operações de JOIN, semi-join ou outras estratégias.

Por isso, a análise do plano é essencial.

---

# 10. Subconsultas aninhadas

Uma subconsulta aninhada ocorre quando uma subconsulta contém outra subconsulta.

Exemplo conceitual:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE categoria_id IN (
    SELECT id
    FROM categorias
    WHERE id IN (
        SELECT categoria_id
        FROM produtos
        GROUP BY categoria_id
        HAVING COUNT(*) > 10
    )
);
```

A estrutura possui três níveis:

1. Consulta externa: seleciona produtos.
2. Subconsulta intermediária: seleciona categorias.
3. Subconsulta interna: identifica categorias com determinada quantidade de produtos.

## 10.1 Cuidados

Subconsultas aninhadas podem tornar a consulta difícil de interpretar.

Problemas frequentes:

- Excesso de níveis.
- Aliases confusos.
- Repetição de lógica.
- Dificuldade de depuração.
- Complexidade desnecessária.

Uma consulta mais profunda não é necessariamente mais sofisticada ou melhor.

Em determinadas situações, uma CTE torna a estrutura mais legível.

---

# 11. Subconsultas com agregações

Subconsultas são frequentemente utilizadas para comparar registros com indicadores calculados.

## 11.1 COUNT

Exemplo:

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
WHERE (
    SELECT COUNT(*)
    FROM pedidos AS p
    WHERE p.cliente_id = c.id
) > 5;
```

Seleciona clientes cuja quantidade de pedidos ultrapassa determinado limite.

## 11.2 AVG

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos
);
```

Compara o preço individual com a média geral.

## 11.3 MAX

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco = (
    SELECT MAX(preco)
    FROM produtos
);
```

Retorna produtos que possuem o maior preço.

Observe que a consulta pode retornar mais de um produto caso exista empate.

## 11.4 MIN

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco = (
    SELECT MIN(preco)
    FROM produtos
);
```

Retorna produtos com o menor preço.

## 11.5 SUM

Exemplo:

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
WHERE (
    SELECT COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0)
    FROM pedidos AS p
    INNER JOIN itens_pedido AS ip
        ON ip.pedido_id = p.id
    WHERE p.cliente_id = c.id
) > 100;
```

O objetivo é comparar o valor calculado dos itens dos pedidos de cada cliente com um limite.

Observe que esse cálculo é demonstrativo: ele utiliza quantidade e preço unitário, sem descontar `desconto_item`, frete ou outros ajustes comerciais.

---

# 12. Subconsultas com GROUP BY e HAVING

Uma subconsulta pode utilizar agrupamentos para produzir conjuntos de resultados mais elaborados.

Exemplo:

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
WHERE c.id IN (
    SELECT p.cliente_id
    FROM pedidos AS p
    GROUP BY p.cliente_id
    HAVING COUNT(*) > 5
);
```

A consulta interna:

1. Agrupa pedidos por cliente.
2. Conta os pedidos de cada cliente.
3. Mantém grupos com mais de cinco pedidos.

A consulta externa utiliza os identificadores retornados.

## 12.1 Diferença entre WHERE e HAVING

- `WHERE` filtra linhas antes do agrupamento.
- `HAVING` filtra grupos depois do agrupamento.

Essa distinção continua válida dentro das subconsultas.

---

# 13. CTEs versus subconsultas

CTEs (*Common Table Expressions*) são expressões de tabela comuns, definidas com `WITH`.

Elas permitem estruturar consultas em etapas nomeadas.

Exemplo com subconsulta:

```sql
SELECT
    resumo.produto_id,
    resumo.unidades
FROM (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades
    FROM itens_pedido
    GROUP BY produto_id
) AS resumo;
```

A mesma lógica utilizando CTE:

```sql
WITH resumo AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades
    FROM itens_pedido
    GROUP BY produto_id
)
SELECT
    produto_id,
    unidades
FROM resumo;
```

## 13.1 Comparação

| Característica | Subconsulta | CTE |
|---|---|---|
| Definição | Dentro da consulta | Com `WITH` |
| Organização | Pode ficar aninhada | Etapas nomeadas |
| Reutilização | Depende da estrutura | Pode ser referenciada mais de uma vez |
| Recursividade | Não é a forma própria | Suporta CTE recursiva |
| Legibilidade | Boa em consultas pequenas | Boa em consultas por etapas |

## 13.2 Materialização no PostgreSQL

CTEs não devem ser consideradas automaticamente tabelas temporárias materializadas.

No PostgreSQL, CTEs não recursivas e sem efeitos colaterais podem ser incorporadas à consulta principal em determinadas situações.

Também existem os modificadores:

- `MATERIALIZED`
- `NOT MATERIALIZED`

Eles influenciam o tratamento da CTE pelo otimizador.

A escolha deve ser fundamentada na necessidade de execução e no plano obtido.

---

# 14. JOINs versus subconsultas

Um mesmo problema pode ser resolvido de diferentes maneiras.

Exemplo: encontrar clientes que possuem pedidos.

### Com JOIN

```sql
SELECT DISTINCT
    c.id,
    c.nome
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.cliente_id = c.id;
```

### Com IN

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
WHERE c.id IN (
    SELECT p.cliente_id
    FROM pedidos AS p
);
```

### Com EXISTS

```sql
SELECT
    c.id,
    c.nome
FROM clientes AS c
WHERE EXISTS (
    SELECT 1
    FROM pedidos AS p
    WHERE p.cliente_id = c.id
);
```

As três consultas expressam a intenção de retornar clientes que possuem pedidos.

Entretanto, existe uma diferença importante:

- O JOIN pode produzir várias linhas para um cliente com vários pedidos.
- O `DISTINCT` elimina duplicações no resultado projetado.
- O `IN` verifica pertencimento.
- O `EXISTS` verifica existência.

O `DISTINCT` não deve ser usado como solução automática para problemas de cardinalidade.

Se o objetivo é retornar somente clientes que possuem pedidos, `EXISTS` expressa diretamente essa intenção.

## 14.1 Como escolher?

Considere:

1. Qual resultado precisa ser retornado?
2. A consulta precisa de colunas da tabela relacionada?
3. O objetivo é verificar existência?
4. O resultado precisa preservar uma linha por entidade?
5. Existe risco de multiplicação de registros?
6. Qual plano de execução apresenta melhor comportamento?

---

# 15. Desempenho e otimização

## 15.1 O PostgreSQL otimiza subconsultas

O PostgreSQL pode transformar subconsultas em estratégias diferentes.

Alguns elementos que podem aparecer nos planos:

- `InitPlan`.
- `SubPlan`.
- `Nested Loop`.
- `Hash Join`.
- `Merge Join`.
- `Semi Join`.
- `Anti Join`.

A presença de uma subconsulta no SQL não determina necessariamente como o banco irá executá-la internamente.

## 15.2 InitPlan

Um `InitPlan` é uma operação auxiliar cujo resultado pode ser calculado uma vez e utilizado por outra parte do plano.

É comum em subconsultas independentes que produzem resultados escalares.

## 15.3 SubPlan

Um `SubPlan` representa uma subconsulta incorporada ao plano de execução.

Dependendo do plano, ela pode ser executada repetidamente ou de outra forma otimizada.

Observe principalmente:

- Quantidade de loops.
- Linhas processadas.
- Tempo de execução.
- Custos estimados.

## 15.4 EXPLAIN

Exemplo:

```sql
EXPLAIN
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos
);
```

O `EXPLAIN` apresenta o plano estimado sem executar a consulta.

## 15.5 EXPLAIN ANALYZE

Exemplo:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    nome,
    preco
FROM produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos
);
```

O comando executa a consulta e apresenta informações reais.

Observe:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Loops.
- Shared Hit Blocks.
- Shared Read Blocks.

**Atenção:** não execute repetidamente consultas pesadas apenas para obter um tempo menor. Cache, concorrência e condições do sistema podem alterar os resultados.

---

# 16. Erros frequentes

## 16.1 Subconsulta escalar retornando várias linhas

Problema:

Utilizar `=` com uma subconsulta que retorna mais de uma linha.

Consequência:

Erro de execução no PostgreSQL.

Correção conceitual:

Avaliar se o problema exige `IN`, `ANY`, `ALL` ou uma agregação que produza um valor único.

## 16.2 Uso inadequado de NOT IN

Problema:

A subconsulta pode retornar NULL.

Consequência:

O resultado da comparação pode ser `UNKNOWN`, eliminando registros inesperadamente.

Correção conceitual:

Verificar a possibilidade de NULL e considerar `NOT EXISTS`.

## 16.3 Confundir correlação com execução física

Problema:

Acreditar que toda subconsulta correlacionada obrigatoriamente executa uma vez para cada linha externa.

Consequência:

Interpretação incorreta do plano e decisões de otimização inadequadas.

Correção:

Analisar o plano real e os loops apresentados.

## 16.4 Subconsulta desnecessariamente complexa

Problema:

Criar vários níveis de subconsultas para uma operação simples.

Consequência:

Dificuldade de manutenção e compreensão.

Correção:

Avaliar JOINs, CTEs e expressões mais diretas.

## 16.5 Usar DISTINCT para esconder duplicações

Problema:

Adicionar `DISTINCT` sem compreender a multiplicação de linhas.

Consequência:

O resultado pode parecer correto, mas esconder um erro de modelagem da consulta.

Correção:

Identificar a granularidade e a cardinalidade de cada relacionamento.

## 16.6 Ignorar NULL em agregações

Problema:

Presumir que `SUM`, `AVG` ou comparações sempre produzirão valores não nulos.

Consequência:

Filtros podem não retornar registros esperados.

Correção:

Compreender o comportamento das funções de agregação e utilizar `COALESCE` quando a regra de negócio exigir.

---

# 17. Boas práticas

1. Identifique o tipo de resultado produzido pela subconsulta.
2. Utilize aliases claros.
3. Evite níveis de aninhamento desnecessários.
4. Verifique se a subconsulta escalar retorna no máximo uma linha.
5. Analise o comportamento de NULL.
6. Prefira EXISTS quando o objetivo for verificar existência.
7. Utilize NOT EXISTS quando precisar verificar ausência de correspondência, especialmente quando NULL pode interferir em NOT IN.
8. Compare estratégias equivalentes.
9. Não presuma que uma subconsulta será mais rápida que um JOIN.
10. Utilize EXPLAIN para entender o plano.
11. Utilize EXPLAIN ANALYZE para medir a execução real, com cautela.
12. Valide os resultados independentemente.

---

# 18. Referência rápida

| Recurso | Finalidade |
|---|---|
| Subconsulta escalar | Retornar um único valor |
| Subconsulta de múltiplas linhas | Retornar um conjunto de valores |
| Subconsulta correlacionada | Utilizar valores da consulta externa |
| Subconsulta não correlacionada | Produzir resultado independente |
| `IN` | Verificar pertencimento |
| `NOT IN` | Verificar ausência no conjunto, considerando NULL |
| `EXISTS` | Verificar existência de linhas |
| `NOT EXISTS` | Verificar ausência de linhas |
| `ANY` | Comparar com pelo menos um valor |
| `ALL` | Comparar com todos os valores |
| Subconsulta no SELECT | Produzir valor para uma coluna |
| Subconsulta no FROM | Produzir uma relação derivada |
| CTE | Organizar etapas de uma consulta |

---

# 19. Documentação oficial

Documentação do PostgreSQL:

- Subqueries: https://www.postgresql.org/docs/current/functions-subquery.html
- Expressões SQL: https://www.postgresql.org/docs/current/sql-expressions.html
- SELECT: https://www.postgresql.org/docs/current/sql-select.html
- WITH Queries: https://www.postgresql.org/docs/current/queries-with.html
- EXPLAIN: https://www.postgresql.org/docs/current/using-explain.html

---

# 20. Resultados esperados

Ao finalizar a teoria, o aluno deverá compreender:

- A estrutura das subconsultas.
- A diferença entre subconsultas escalares e de múltiplas linhas.
- A diferença entre consultas correlacionadas e não correlacionadas.
- A utilização de subconsultas no WHERE, SELECT e FROM.
- O funcionamento de IN, NOT IN, EXISTS e NOT EXISTS.
- O comportamento de ANY e ALL.
- O uso de subconsultas com agregações.
- A construção de subconsultas aninhadas.
- As diferenças entre subconsultas, JOINs e CTEs.
- Os fundamentos de análise de desempenho.

**Conclusão:** o objetivo não é apenas aprender a escrever subconsultas, mas compreender quando utilizá-las, como validar seus resultados e como avaliar sua execução no PostgreSQL.