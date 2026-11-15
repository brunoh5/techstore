# Teoria — Módulo 09: Window Functions

## 1. Introdução às Window Functions

Window Functions, ou funções de janela, são recursos SQL que permitem realizar cálculos considerando um conjunto de linhas relacionadas à linha atual.

Elas são utilizadas para análises que precisam observar outras linhas sem eliminar os registros individuais.

Isso permite construir:

- Rankings.
- Classificações.
- Totais acumulados.
- Médias móveis.
- Comparações entre registros.
- Variações temporais.
- Participação percentual.
- Identificação de primeiro e último registro.
- Análises por grupos.

### 1.1 Diferença entre GROUP BY e Window Functions

Uma das diferenças mais importantes do SQL analítico está na forma como os resultados são apresentados.

Considere uma tabela de pedidos.

Com `GROUP BY`, podemos calcular a quantidade de pedidos por cliente:

```sql
SELECT
    cliente_id,
    COUNT(*) AS quantidade_pedidos
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL
GROUP BY cliente_id;
```

O resultado apresenta uma linha por cliente que possui pedidos.

Agora considere uma Window Function:

```sql
SELECT
    id,
    cliente_id,
    data_pedido,
    COUNT(*) OVER (
        PARTITION BY cliente_id
    ) AS quantidade_pedidos
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

Nesse caso, cada pedido continua aparecendo individualmente.

A quantidade total de pedidos do cliente é adicionada a cada linha correspondente.

| Característica | GROUP BY | Window Function |
|---|---|---|
| Agrupa linhas | Sim | Não |
| Preserva registros individuais | Não necessariamente | Sim |
| Calcula agregações | Sim | Sim |
| Permite ranking | Não diretamente | Sim |
| Permite acessar linhas anteriores | Não | Sim |
| Permite acumulados | Com outras técnicas | Sim |

**Regra fundamental:** `GROUP BY` reduz a granularidade do resultado, enquanto uma Window Function normalmente preserva a granularidade das linhas de entrada.

---

## 2. Estrutura da cláusula OVER

A cláusula `OVER` define a janela utilizada pela função.

Estrutura básica:

```sql
FUNCAO() OVER (
    PARTITION BY coluna
    ORDER BY coluna
    ROWS BETWEEN ...
)
```

Os componentes são:

| Componente | Função |
|---|---|
| `OVER` | Define a janela |
| `PARTITION BY` | Divide os registros em grupos |
| `ORDER BY` | Define a ordem dentro da janela |
| Frame | Define quais linhas participam do cálculo |

Nem todos os componentes são obrigatórios.

Uma Window Function pode utilizar apenas:

```sql
COUNT(*) OVER ()
```

Nesse caso, todas as linhas pertencem à mesma janela, sem particionamento ou ordenação.

### 2.1 Window Function sem particionamento

```sql
SELECT
    id,
    nome,
    preco,
    AVG(preco) OVER () AS media_geral
FROM techstore.produtos;
```

A média considera todos os produtos retornados pela consulta.

Cada produto recebe a mesma média geral.

### 2.2 Window Function com particionamento

```sql
SELECT
    id,
    nome,
    categoria_id,
    preco,
    AVG(preco) OVER (
        PARTITION BY categoria_id
    ) AS media_categoria
FROM techstore.produtos;
```

Agora cada produto recebe a média de preço da sua categoria.

---

## 3. PARTITION BY

`PARTITION BY` divide os registros em grupos independentes para o cálculo da janela.

É semelhante à ideia de agrupamento do `GROUP BY`, mas não reduz o número de linhas.

### 3.1 Particionamento por uma coluna

```sql
SELECT
    id,
    nome,
    categoria_id,
    preco,
    MAX(preco) OVER (
        PARTITION BY categoria_id
    ) AS maior_preco_categoria
FROM techstore.produtos;
```

Cada produto recebe o maior preço encontrado na sua categoria.

### 3.2 Particionamento por múltiplas colunas

```sql
SELECT
    cliente_id,
    status,
    id,
    COUNT(*) OVER (
        PARTITION BY cliente_id, status
    ) AS quantidade
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

Nesse exemplo, cada janela considera a combinação de cliente e status.

### 3.3 Partições independentes

Cada partição é processada separadamente.

Uma alteração no conteúdo de uma partição não modifica diretamente o resultado das outras.

### 3.4 PARTITION BY versus GROUP BY

Exemplo com `GROUP BY`:

```sql
SELECT
    categoria_id,
    AVG(preco) AS media
FROM techstore.produtos
GROUP BY categoria_id;
```

Exemplo com Window Function:

```sql
SELECT
    id,
    nome,
    categoria_id,
    preco,
    AVG(preco) OVER (
        PARTITION BY categoria_id
    ) AS media
FROM techstore.produtos;
```

A primeira consulta retorna uma linha por categoria.

A segunda retorna uma linha por produto, adicionando a média da categoria.

---

## 4. ORDER BY dentro de OVER

O `ORDER BY` dentro da janela define a ordem em que os registros serão considerados pelas funções.

Isso é especialmente importante para:

- Rankings.
- Acumulados.
- Médias móveis.
- `LAG`.
- `LEAD`.
- `FIRST_VALUE`.
- `LAST_VALUE`.

Exemplo:

```sql
SELECT
    id,
    cliente_id,
    data_pedido,
    ROW_NUMBER() OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS ordem_pedido
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

Cada pedido recebe uma posição dentro da sequência de compras do cliente.

### 4.1 Ordenação crescente e decrescente

```sql
ROW_NUMBER() OVER (
    ORDER BY preco ASC
)
```

Ordena do menor para o maior.

```sql
ROW_NUMBER() OVER (
    ORDER BY preco DESC
)
```

Ordena do maior para o menor.

### 4.2 Ordenação por múltiplas colunas

```sql
ROW_NUMBER() OVER (
    PARTITION BY categoria_id
    ORDER BY preco DESC, id ASC
)
```

O preço define a ordenação principal.

O identificador funciona como critério adicional de desempate.

### 4.3 Determinismo

Quando existem valores iguais na coluna de ordenação, pode haver mais de uma ordem válida.

Para obter resultados reproduzíveis, utilize critérios adicionais quando a lógica exigir uma ordem única.

Exemplo:

```sql
ORDER BY data_pedido, id
```

O identificador fornece um desempate estável dentro do conjunto consultado.

### 4.4 ORDER BY da janela versus ORDER BY final

São elementos diferentes.

```sql
SELECT
    id,
    preco,
    ROW_NUMBER() OVER (
        ORDER BY preco DESC
    ) AS posicao
FROM techstore.produtos
ORDER BY id;
```

A janela calcula a posição pelo preço.

A consulta externa apresenta os registros ordenados pelo identificador.

O `ORDER BY` dentro de `OVER` não garante a ordenação final do resultado.

---

## 5. ROW_NUMBER

`ROW_NUMBER()` atribui um número sequencial para cada linha da janela.

A numeração começa em 1.

Exemplo:

```sql
SELECT
    id,
    nome,
    preco,
    ROW_NUMBER() OVER (
        ORDER BY preco DESC, id
    ) AS posicao
FROM techstore.produtos;
```

Resultado conceitual:

| Produto | Preço | Posição |
|---|---:|---:|
| Produto A | 900 | 1 |
| Produto B | 750 | 2 |
| Produto C | 750 | 3 |
| Produto D | 500 | 4 |

Mesmo quando existem valores iguais, cada linha recebe um número diferente.

### 5.1 ROW_NUMBER por categoria

```sql
SELECT
    id,
    nome,
    categoria_id,
    preco,
    ROW_NUMBER() OVER (
        PARTITION BY categoria_id
        ORDER BY preco DESC, id
    ) AS posicao
FROM techstore.produtos;
```

Cada categoria possui sua própria sequência.

### 5.2 Aplicações

- Selecionar o registro mais recente por grupo.
- Identificar duplicidades.
- Criar numeração sequencial.
- Selecionar os primeiros registros.
- Construir rankings sem empates.

### 5.3 Filtrando ROW_NUMBER

Não podemos utilizar diretamente uma Window Function na cláusula `WHERE` da mesma etapa de consulta.

Utilizamos uma CTE ou subconsulta:

```sql
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
SELECT *
FROM ranking
WHERE posicao <= 3;
```

O resultado contém até três produtos por categoria.

---

## 6. RANK

`RANK()` atribui posições considerando os empates.

Quando duas linhas possuem a mesma classificação, recebem a mesma posição.

As posições seguintes podem apresentar lacunas.

Exemplo:

| Produto | Preço | RANK |
|---|---:|---:|
| Produto A | 900 | 1 |
| Produto B | 750 | 2 |
| Produto C | 750 | 2 |
| Produto D | 500 | 4 |

Observe que a posição 3 não aparece.

Exemplo SQL:

```sql
SELECT
    id,
    nome,
    preco,
    RANK() OVER (
        ORDER BY preco DESC
    ) AS posicao
FROM techstore.produtos;
```

### 6.1 RANK por categoria

```sql
SELECT
    id,
    nome,
    categoria_id,
    preco,
    RANK() OVER (
        PARTITION BY categoria_id
        ORDER BY preco DESC
    ) AS ranking_categoria
FROM techstore.produtos;
```

Produtos com preços iguais recebem a mesma posição dentro da categoria.

### 6.2 Aplicações

- Rankings competitivos.
- Classificações com empate.
- Comparações de desempenho.
- Posições em relatórios analíticos.

---

## 7. DENSE_RANK

`DENSE_RANK()` também considera empates, mas não deixa lacunas nas posições seguintes.

Exemplo:

| Produto | Preço | DENSE_RANK |
|---|---:|---:|
| Produto A | 900 | 1 |
| Produto B | 750 | 2 |
| Produto C | 750 | 2 |
| Produto D | 500 | 3 |

Exemplo SQL:

```sql
SELECT
    id,
    nome,
    preco,
    DENSE_RANK() OVER (
        ORDER BY preco DESC
    ) AS classificacao
FROM techstore.produtos;
```

### 7.1 Diferenças entre rankings

Considere os valores:

```text
100
90
90
80
70
```

| Valor | ROW_NUMBER | RANK | DENSE_RANK |
|---:|---:|---:|---:|
| 100 | 1 | 1 | 1 |
| 90 | 2 | 2 | 2 |
| 90 | 3 | 2 | 2 |
| 80 | 4 | 4 | 3 |
| 70 | 5 | 5 | 4 |

**Resumo:**

- `ROW_NUMBER`: sempre gera posições únicas.
- `RANK`: preserva empates e deixa lacunas.
- `DENSE_RANK`: preserva empates sem deixar lacunas.

A escolha depende da regra de negócio.

---

## 8. NTILE

`NTILE(n)` divide as linhas de uma partição em aproximadamente `n` grupos.

É útil para segmentações e análises por distribuição.

Exemplo:

```sql
SELECT
    id,
    nome,
    preco,
    NTILE(4) OVER (
        ORDER BY preco
    ) AS faixa
FROM techstore.produtos;
```

Os produtos serão distribuídos em quatro grupos, com quantidades de linhas tão equilibradas quanto possível.

### 8.1 Aplicações

- Quartis.
- Segmentação de clientes.
- Divisão de produtos por faixa de preço.
- Análise de distribuição.

### 8.2 Atenção

`NTILE` distribui linhas, não necessariamente valores distintos.

Produtos com o mesmo preço podem acabar em grupos diferentes se estiverem próximos de uma fronteira entre grupos.

---

## 9. Window Frames

Um frame define quais linhas participam de uma função de janela em relação à linha atual.

Esse conceito é essencial para acumulados, médias móveis e funções de valor.

Uma janela pode considerar:

- Todas as linhas da partição.
- A linha atual e anteriores.
- A linha atual e posteriores.
- Uma quantidade limitada de linhas.
- Grupos de valores equivalentes.

### 9.1 Estrutura

```sql
ROWS BETWEEN
    limite_inicial
    AND
    limite_final
```

Exemplo:

```sql
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
```

Considera:

- Duas linhas anteriores.
- A linha atual.

### 9.2 UNBOUNDED PRECEDING

Representa o início da partição.

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
         AND CURRENT ROW
```

Considera todas as linhas desde o início da partição até a linha atual.

### 9.3 UNBOUNDED FOLLOWING

Representa o final da partição.

```sql
ROWS BETWEEN CURRENT ROW
         AND UNBOUNDED FOLLOWING
```

Considera a linha atual e todas as linhas seguintes.

### 9.4 CURRENT ROW

Representa a linha atual ou o grupo de pares atual, dependendo do tipo de frame.

### 9.5 PRECEDING

Representa linhas ou grupos anteriores.

Exemplo:

```sql
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
```

Considera até quatro linhas: três anteriores e a atual.

### 9.6 FOLLOWING

Representa linhas ou grupos posteriores.

Exemplo:

```sql
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
```

Considera a linha atual e até duas linhas seguintes.

---

## 10. ROWS, RANGE e GROUPS

O PostgreSQL oferece três modalidades de frame.

### 10.1 ROWS

Trabalha com posições físicas das linhas na ordenação da janela.

```sql
SUM(quantidade) OVER (
    ORDER BY data_pedido, id
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)
```

Considera até três linhas.

### 10.2 RANGE

Trabalha com valores da ordenação e seus grupos de pares.

Com `CURRENT ROW`, considera os valores equivalentes da ordenação conforme o comportamento de pares.

Exemplo:

```sql
SUM(preco) OVER (
    ORDER BY preco
    RANGE BETWEEN UNBOUNDED PRECEDING
              AND CURRENT ROW
)
```

Produtos com o mesmo preço participam do mesmo limite de pares.

Com frames de deslocamento, `RANGE` possui regras próprias e restrições sobre a expressão de ordenação. No PostgreSQL, o deslocamento deve ser compatível com o tipo da chave de ordenação.

### 10.3 GROUPS

Trabalha com grupos de linhas equivalentes na ordenação.

Exemplo:

```sql
SUM(preco) OVER (
    ORDER BY preco
    GROUPS BETWEEN 1 PRECEDING AND CURRENT ROW
)
```

Considera o grupo de preços anterior e o grupo atual.

### 10.4 Comparação

| Tipo | Unidade considerada |
|---|---|
| ROWS | Linhas individuais |
| RANGE | Valores e grupos de pares |
| GROUPS | Grupos de pares |

### 10.5 Quando utilizar

- `ROWS`: acumulados e médias móveis por quantidade de registros.
- `RANGE`: cálculos por intervalo de valores.
- `GROUPS`: cálculos por grupos de valores equivalentes.

A escolha errada pode alterar os resultados.

---

## 11. Frame padrão do PostgreSQL

Quando uma função de janela utiliza `ORDER BY` e não especifica um frame, o PostgreSQL utiliza um frame padrão que vai do início da partição até a linha atual, incluindo os pares da linha atual.

Esse comportamento é especialmente importante para funções agregadas e funções de valor.

Considere:

```sql
SUM(preco) OVER (
    ORDER BY preco
)
```

Os valores acumulados consideram também as linhas empatadas na ordenação.

Para um acumulado linha a linha, com desempate definido, prefira:

```sql
SUM(preco) OVER (
    ORDER BY preco, id
    ROWS BETWEEN UNBOUNDED PRECEDING
             AND CURRENT ROW
)
```

### 11.1 Por que isso importa?

Imagine três registros com o mesmo valor de ordenação.

Com o frame padrão baseado em `RANGE`, os três podem receber o mesmo acumulado.

Com `ROWS` e uma ordenação única, o acumulado pode avançar individualmente a cada registro.

---

## 12. LAG

`LAG()` permite acessar o valor de uma linha anterior dentro da janela.

Estrutura:

```sql
LAG(expressao, deslocamento, valor_padrao)
OVER (
    PARTITION BY ...
    ORDER BY ...
)
```

Parâmetros:

- Expressão: coluna ou valor desejado.
- Deslocamento: quantidade de linhas anteriores.
- Valor padrão: retorno quando não existe a linha anterior.

Exemplo:

```sql
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
```

O preço anterior é obtido considerando o histórico de cada produto.

### 12.1 Comparação entre valores

```sql
WITH historico AS (
    SELECT
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
    produto_id,
    alterado_em,
    preco_anterior,
    preco_novo,
    preco_novo - preco_anterior AS variacao
FROM historico
WHERE preco_anterior IS NOT NULL;
```

### 12.2 Aplicações

- Comparar preços.
- Identificar alterações.
- Comparar compras consecutivas.
- Detectar mudanças de status.
- Analisar intervalos entre eventos.

---

## 13. LEAD

`LEAD()` permite acessar o valor de uma linha posterior.

Sua estrutura é semelhante à de `LAG`.

Exemplo:

```sql
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
```

O resultado permite visualizar o próximo preço registrado para cada produto.

### 13.1 LAG versus LEAD

| Função | Direção |
|---|---|
| LAG | Linha anterior |
| LEAD | Linha posterior |

Ambas respeitam a ordenação definida na janela.

---

## 14. FIRST_VALUE

`FIRST_VALUE()` retorna o valor da primeira linha do frame.

Exemplo:

```sql
SELECT
    id,
    nome,
    categoria_id,
    preco,
    FIRST_VALUE(nome) OVER (
        PARTITION BY categoria_id
        ORDER BY preco DESC, id
    ) AS produto_mais_caro
FROM techstore.produtos;
```

Cada produto recebe o nome do primeiro produto da ordenação dentro da categoria.

### 14.1 Atenção ao frame

O resultado depende do frame da janela.

Com uma ordenação crescente, a primeira linha do frame pode ser diferente da primeira linha da partição quando o frame começa depois do início.

---

## 15. LAST_VALUE

`LAST_VALUE()` retorna o valor da última linha do frame.

Um erro frequente é esperar que a função retorne automaticamente o último registro de toda a partição.

Exemplo:

```sql
SELECT
    id,
    produto_id,
    alterado_em,
    preco_novo,
    LAST_VALUE(preco_novo) OVER (
        PARTITION BY produto_id
        ORDER BY alterado_em, id
    ) AS ultimo_preco
FROM techstore.historico_precos;
```

Essa consulta utiliza o frame padrão.

Por isso, o valor retornado pode ser o valor da linha atual ou do último par dentro do frame, e não necessariamente o último preço histórico do produto.

### 15.1 Último valor da partição

Para obter o último valor de toda a partição:

```sql
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
    ) AS ultimo_preco
FROM techstore.historico_precos;
```

**Regra importante:** compreender o frame é indispensável ao utilizar `LAST_VALUE`.

---

## 16. NTH_VALUE

`NTH_VALUE()` retorna o valor localizado na posição solicitada dentro do frame.

Exemplo:

```sql
SELECT
    id,
    nome,
    categoria_id,
    preco,
    NTH_VALUE(nome, 2) OVER (
        PARTITION BY categoria_id
        ORDER BY preco DESC, id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS segundo_produto
FROM techstore.produtos;
```

A função retorna o segundo produto da ordenação dentro da categoria.

Se o frame não possuir a posição solicitada, o resultado será `NULL`.

---

## 17. Agregações como Window Functions

Funções agregadas podem ser utilizadas como funções de janela.

Exemplos:

- `COUNT`.
- `SUM`.
- `AVG`.
- `MIN`.
- `MAX`.

A diferença está na utilização da cláusula `OVER`.

### 17.1 COUNT OVER

```sql
SELECT
    id,
    cliente_id,
    COUNT(*) OVER (
        PARTITION BY cliente_id
    ) AS pedidos_cliente
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

### 17.2 SUM OVER

```sql
SELECT
    id,
    cliente_id,
    valor_frete,
    SUM(valor_frete) OVER (
        PARTITION BY cliente_id
    ) AS total_frete_cliente
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

### 17.3 AVG OVER

```sql
SELECT
    id,
    produto_id,
    preco_unitario,
    AVG(preco_unitario) OVER (
        PARTITION BY produto_id
    ) AS preco_medio_praticado
FROM techstore.itens_pedido;
```

### 17.4 MIN e MAX OVER

```sql
SELECT
    id,
    categoria_id,
    preco,
    MIN(preco) OVER (
        PARTITION BY categoria_id
    ) AS menor_preco_categoria,
    MAX(preco) OVER (
        PARTITION BY categoria_id
    ) AS maior_preco_categoria
FROM techstore.produtos;
```

### 17.5 FILTER com Window Functions

O PostgreSQL permite utilizar `FILTER` em funções agregadas de janela.

Exemplo:

```sql
SELECT
    id,
    status,
    COUNT(*) FILTER (
        WHERE status = 'entregue'
    ) OVER () AS total_entregues
FROM techstore.pedidos;
```

A condição do `FILTER` controla quais linhas participam daquela agregação.

---

## 18. Totais acumulados

Um acumulado representa a soma progressiva dos registros conforme uma ordenação.

Exemplo:

```sql
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
```

O resultado representa a soma progressiva dos valores de frete.

### 18.1 Acumulado por cliente

```sql
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
    ) AS frete_acumulado
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

Cada cliente possui seu próprio acumulado.

### 18.2 Importância do ORDER BY

Sem ordenação, não existe uma sequência lógica para construir um acumulado progressivo.

Sem um critério de desempate, registros com a mesma data podem não apresentar uma sequência individual determinística.

---

## 19. Médias móveis

Uma média móvel considera um conjunto limitado de registros em torno da linha atual.

Exemplo:

```sql
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
```

A média considera até três registros:

- Dois anteriores.
- O atual.

### 19.1 Aplicações

- Evolução de preços.
- Tendências de vendas.
- Variação de indicadores.
- Análise de comportamento.
- Suavização de oscilações.

### 19.2 Média móvel por tempo

Uma média móvel por período de tempo não é necessariamente igual a uma média móvel por quantidade de registros.

Com `ROWS`, são consideradas posições de linhas.

Com `RANGE`, é possível definir intervalos baseados na expressão de ordenação, respeitando as regras de tipos e deslocamentos do PostgreSQL.

Essa diferença deve ser considerada em análises temporais.

---

## 20. Comparação percentual dentro de grupos

Window Functions permitem comparar o valor individual com o total de uma partição.

Exemplo:

```sql
SELECT
    id,
    categoria_id,
    nome,
    preco,
    SUM(preco) OVER (
        PARTITION BY categoria_id
    ) AS total_categoria,
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
```

A participação percentual representa a contribuição do preço de cada produto para a soma dos preços da categoria.

Atenção: isso não representa participação no faturamento. Para calcular participação no faturamento, seria necessário utilizar os valores vendidos.

---

## 21. Análises temporais com LAG

As funções de janela permitem comparar períodos consecutivos.

Exemplo conceitual de pedidos por dia:

```sql
WITH vendas_dia AS (
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
        ) AS pedidos_dia_anterior
    FROM vendas_dia
)

SELECT
    dia,
    quantidade_pedidos,
    pedidos_dia_anterior,
    quantidade_pedidos - pedidos_dia_anterior AS diferenca
FROM comparacao
ORDER BY dia;
```

### 21.1 Crescimento percentual

É possível calcular a variação percentual entre períodos.

A fórmula é:

\[
\text{Variação \%} =
\frac{\text{Valor atual} - \text{Valor anterior}}
{\text{Valor anterior}} \times 100
\]

No SQL, é importante utilizar `NULLIF` para evitar divisão por zero.

Também é necessário decidir como tratar o primeiro período, que não possui período anterior.

---

## 22. Combinação com CTEs e subconsultas

Window Functions são frequentemente utilizadas em conjunto com CTEs.

Isso permite dividir uma análise em etapas.

Exemplo:

```sql
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
WHERE r.posicao <= 10
ORDER BY r.posicao, p.id;
```

A primeira CTE calcula o faturamento.

A segunda cria o ranking.

A consulta principal apresenta os produtos correspondentes.

---

## 23. Filtragem de Window Functions

Window Functions não podem ser utilizadas diretamente na cláusula `WHERE` da mesma etapa de consulta.

Isso acontece porque o processamento lógico da consulta realiza o filtro `WHERE` antes da avaliação das funções de janela.

Para filtrar resultados analíticos, utilizamos:

- CTE.
- Subconsulta.

Exemplo:

```sql
WITH ranking AS (
    SELECT
        id,
        nome,
        preco,
        ROW_NUMBER() OVER (
            ORDER BY preco DESC, id
        ) AS posicao
    FROM techstore.produtos
)
SELECT *
FROM ranking
WHERE posicao <= 10;
```

### 23.1 QUALIFY no PostgreSQL

O PostgreSQL 16 não oferece a cláusula `QUALIFY`.

Em bancos que possuem essa cláusula, ela pode ser utilizada para filtrar resultados de funções de janela.

No PostgreSQL, CTEs e subconsultas são as alternativas habituais.

---

## 24. Window Functions e agregações tradicionais

É possível combinar agregações e funções de janela em etapas distintas.

Exemplo:

```sql
WITH vendas_categoria AS (
    SELECT
        p.categoria_id,
        SUM(i.quantidade * i.preco_unitario) AS faturamento
    FROM techstore.produtos AS p
    INNER JOIN techstore.itens_pedido AS i
        ON i.produto_id = p.id
    GROUP BY p.categoria_id
)
SELECT
    categoria_id,
    faturamento,
    SUM(faturamento) OVER () AS faturamento_total,
    ROUND(
        100.0 * faturamento
        / NULLIF(SUM(faturamento) OVER (), 0),
        2
    ) AS participacao_percentual
FROM vendas_categoria
ORDER BY faturamento DESC;
```

A agregação produz uma linha por categoria.

A Window Function calcula o total geral sem eliminar as categorias individuais.

---

## 25. Named WINDOW

O PostgreSQL permite declarar uma janela nomeada utilizando a cláusula `WINDOW`.

Isso é útil quando várias funções utilizam a mesma configuração.

Exemplo:

```sql
SELECT
    id,
    cliente_id,
    data_pedido,
    valor_frete,
    SUM(valor_frete) OVER janela_cliente AS acumulado,
    AVG(valor_frete) OVER janela_cliente AS media
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL
WINDOW janela_cliente AS (
    PARTITION BY cliente_id
    ORDER BY data_pedido, id
    ROWS BETWEEN UNBOUNDED PRECEDING
             AND CURRENT ROW
);
```

A janela pode ser reutilizada por diferentes funções.

Isso reduz repetição e facilita a manutenção.

---

## 26. Erros frequentes

### 26.1 Confundir GROUP BY com Window Functions

Uma função de janela não substitui automaticamente uma agregação tradicional.

É necessário compreender a granularidade desejada.

### 26.2 Esquecer PARTITION BY

Sem particionamento, todas as linhas participam da mesma janela.

Isso pode produzir rankings ou acumulados globais quando a intenção era calcular por cliente ou categoria.

### 26.3 Utilizar ORDER BY sem desempate

Empates podem produzir posições ou sequências não determinísticas.

Adicione uma coluna de desempate quando necessário.

### 26.4 Utilizar LAST_VALUE sem frame adequado

O frame padrão pode fazer a função retornar o valor atual ou o último valor do grupo de pares, em vez do último valor da partição.

### 26.5 Confundir ROWS com RANGE

`ROWS` trabalha com posições individuais.

`RANGE` considera os valores de ordenação e seus pares.

Os resultados podem ser diferentes.

### 26.6 Filtrar antes da Window Function

Um filtro aplicado antes da função pode remover linhas necessárias ao cálculo.

É necessário decidir se a filtragem deve ocorrer antes ou depois da janela.

### 26.7 Ignorar NULL

Funções agregadas normalmente ignoram valores `NULL`, enquanto funções de navegação e valor podem retornar `NULL` conforme a linha acessada.

O tratamento precisa ser definido de acordo com a análise.

### 26.8 Confundir ranking com posição física

`RANK` e `DENSE_RANK` podem atribuir a mesma posição a múltiplas linhas.

Se a necessidade é selecionar exatamente uma linha por posição, `ROW_NUMBER` com desempate pode ser mais adequado.

---

## 27. Desempenho e planos de execução

Window Functions podem exigir ordenação e processamento de grandes conjuntos de dados.

Os principais nós e operações que deverão ser observados incluem:

### WindowAgg

Nó responsável pelo processamento das funções de janela.

### Sort

Pode ser necessário ordenar os dados para atender ao particionamento e à ordenação da janela.

### Incremental Sort

Pode aparecer quando o PostgreSQL consegue aproveitar uma ordenação parcial existente.

### Index Scan

Pode ser utilizado quando um índice atende aos filtros ou à ordenação e o planner considera essa estratégia vantajosa.

### Seq Scan

Pode ser mais eficiente quando uma grande parte da tabela precisa ser lida.

### 27.1 EXPLAIN

```sql
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
```

O objetivo é observar a estrutura estimada do plano.

### 27.2 EXPLAIN ANALYZE

```sql
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
```

O comando executa a consulta.

Observe:

- Planning Time.
- Execution Time.
- Actual Rows.
- Sort Method.
- WindowAgg.
- Shared Hit Blocks.
- Shared Read Blocks.

### 27.3 Índices

Um índice pode ajudar em filtros e ordenações, dependendo da consulta.

Entretanto, sua presença não garante que o PostgreSQL o utilizará.

O planner considera:

- Seletividade.
- Quantidade de registros.
- Custo de leitura.
- Ordenação necessária.
- Custo de acesso ao índice.

Não será necessário criar índices durante este módulo.

---

## 28. Boas práticas

1. Defina claramente a granularidade do resultado.
2. Utilize `PARTITION BY` somente quando necessário.
3. Escolha corretamente a função de ranking.
4. Defina critérios de desempate.
5. Especifique o frame quando o comportamento padrão não for o desejado.
6. Utilize `ROWS` para acumulados por quantidade de registros.
7. Utilize `RANGE` quando a lógica depender de valores da ordenação.
8. Verifique o comportamento de `LAST_VALUE`.
9. Trate divisão por zero.
10. Analise valores `NULL`.
11. Utilize CTEs para organizar cálculos complexos.
12. Compare resultados antes de comparar desempenho.
13. Utilize `EXPLAIN` antes de propor otimizações.
14. Evite adicionar Window Functions quando uma agregação simples resolve o problema.

---

## 29. Referência rápida

| Função | Finalidade |
|---|---|
| `ROW_NUMBER()` | Numeração individual |
| `RANK()` | Ranking com lacunas |
| `DENSE_RANK()` | Ranking sem lacunas |
| `NTILE(n)` | Divisão em grupos |
| `LAG()` | Acessar linha anterior |
| `LEAD()` | Acessar linha posterior |
| `FIRST_VALUE()` | Primeiro valor do frame |
| `LAST_VALUE()` | Último valor do frame |
| `NTH_VALUE()` | Valor de uma posição do frame |
| `COUNT() OVER` | Contagem por janela |
| `SUM() OVER` | Soma por janela |
| `AVG() OVER` | Média por janela |
| `MIN() OVER` | Menor valor por janela |
| `MAX() OVER` | Maior valor por janela |

### Estrutura geral

```sql
SELECT
    colunas,
    FUNCAO() OVER (
        PARTITION BY coluna
        ORDER BY coluna
        ROWS BETWEEN ...
    ) AS resultado
FROM tabela;
```

---

## 30. Documentação oficial

Referências para aprofundamento:

- PostgreSQL 16 — Window Functions: https://www.postgresql.org/docs/16/functions-window.html
- PostgreSQL 16 — Window Function Calls: https://www.postgresql.org/docs/16/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS
- PostgreSQL 16 — SELECT: https://www.postgresql.org/docs/16/sql-select.html
- PostgreSQL 16 — EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html

---

## 31. Resultados esperados

Ao concluir a teoria, o aluno deverá compreender:

- Como uma Window Function é executada conceitualmente.
- Como `OVER` define a janela.
- Como `PARTITION BY` separa grupos.
- Como `ORDER BY` influencia os cálculos.
- Como os frames alteram os resultados.
- Como funcionam os rankings.
- Como acessar registros anteriores e posteriores.
- Como calcular acumulados e médias móveis.
- Como preservar a granularidade.
- Como combinar funções de janela com CTEs e agregações.
- Como interpretar os principais nós do plano de execução.

**Próxima etapa:** realizar as atividades práticas do Módulo 09.