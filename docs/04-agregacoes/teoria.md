# Teoria — Módulo 04: Agregações SQL

## 1. Fundamentos de agregação

### 1.1 O que são agregações?

Agregações são operações que recebem um conjunto de registros e produzem um resultado consolidado.

Até agora, a maior parte das consultas retornava informações individuais.

Exemplo conceitual:

| Pedido | Valor |
|---|---:|
| 101 | 150,00 |
| 102 | 250,00 |
| 103 | 300,00 |
| 104 | 100,00 |

Uma consulta convencional apresenta os registros individualmente.

Uma agregação pode transformar esses quatro registros em um único resultado:

| Total de pedidos | Valor total |
|---:|---:|
| 4 | 800,00 |

A principal diferença é que a agregação resume um conjunto de valores.

### 1.2 Funções agregadoras

As principais funções agregadoras do SQL são:

| Função | Finalidade |
|---|---|
| COUNT | Contar registros ou valores |
| SUM | Somar valores |
| AVG | Calcular médias |
| MIN | Identificar o menor valor |
| MAX | Identificar o maior valor |

Essas funções podem trabalhar sobre tabelas inteiras ou sobre subconjuntos definidos por filtros.

### 1.3 Agregação sem agrupamento

Quando uma consulta utiliza uma função agregadora sem `GROUP BY`, normalmente produz uma única linha de resultado.

Exemplo:

```sql
SELECT
    COUNT(*) AS quantidade_produtos,
    AVG(preco) AS preco_medio,
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM techstore.produtos;
```

Nesse exemplo, o PostgreSQL analisa os registros da tabela e calcula quatro indicadores.

Observe que não estamos solicitando uma linha por produto, mas um resumo da tabela inteira.

### 1.4 Agregações e conjuntos vazios

É importante compreender o comportamento das agregações quando nenhum registro atende aos critérios da consulta.

Considere uma consulta que não encontra registros.

| Função | Resultado |
|---|---|
| COUNT(*) | 0 |
| COUNT(coluna) | 0 |
| SUM(coluna) | NULL |
| AVG(coluna) | NULL |
| MIN(coluna) | NULL |
| MAX(coluna) | NULL |

Essa diferença é importante.

Uma contagem pode retornar zero, enquanto uma soma sem valores retorna `NULL`.

Não se deve interpretar automaticamente `NULL` como zero.

---

## 2. COUNT — Contagem de registros

### 2.1 COUNT(*)

`COUNT(*)` contabiliza todas as linhas que fazem parte do conjunto analisado.

Exemplo:

```sql
SELECT
    COUNT(*) AS total_clientes
FROM techstore.clientes;
```

O resultado representa a quantidade de registros da tabela, independentemente de alguma coluna específica possuir `NULL`.

### 2.2 COUNT(coluna)

`COUNT(coluna)` contabiliza somente os valores não nulos daquela coluna.

Exemplo:

```sql
SELECT
    COUNT(telefone) AS clientes_com_telefone
FROM techstore.clientes;
```

Nesse caso, registros com `telefone IS NULL` não entram na contagem.

### 2.3 Diferença entre COUNT(*) e COUNT(coluna)

Considere:

| ID | Telefone |
|---:|---|
| 1 | 31999990000 |
| 2 | NULL |
| 3 | 31988880000 |
| 4 | NULL |

Resultados:

- `COUNT(*)` = 4
- `COUNT(telefone)` = 2

Essa diferença é fundamental para análises que envolvem campos opcionais.

### 2.4 COUNT(DISTINCT coluna)

Permite contar quantos valores diferentes existem em uma coluna.

Exemplo:

```sql
SELECT
    COUNT(DISTINCT cliente_id) AS clientes_identificados
FROM techstore.acessos;
```

Se um cliente realizou vários acessos, ele será contabilizado apenas uma vez.

Importante: `COUNT(DISTINCT coluna)` também ignora valores `NULL`.

### 2.5 Contagens condicionais

É possível contar registros que atendam a determinada condição.

Uma abordagem utiliza `CASE`:

```sql
SELECT
    COUNT(
        CASE
            WHEN status = 'entregue' THEN 1
        END
    ) AS pedidos_entregues
FROM techstore.pedidos;
```

Outra possibilidade é utilizar `FILTER`:

```sql
SELECT
    COUNT(*) FILTER (
        WHERE status = 'entregue'
    ) AS pedidos_entregues
FROM techstore.pedidos;
```

O `FILTER` será estudado mais detalhadamente no tema de agregações condicionais.

---

## 3. SUM — Soma de valores

### 3.1 Funcionamento

`SUM` calcula a soma dos valores de uma expressão numérica.

Exemplo:

```sql
SELECT
    SUM(preco) AS soma_precos
FROM techstore.produtos;
```

A consulta soma os preços de todos os produtos.

### 3.2 Aplicação financeira

Na TechStore, podemos analisar valores comercializados.

Por exemplo:

```sql
SELECT
    SUM(quantidade * preco_unitario) AS valor_bruto_itens
FROM techstore.itens_pedido;
```

A expressão calcula o valor de cada item e depois soma os resultados.

Esse exemplo representa o valor bruto dos itens, antes de considerar descontos.

É importante compreender que uma agregação pode receber uma expressão, e não somente o nome de uma coluna.

### 3.3 SUM e NULL

`SUM` ignora valores `NULL`.

Considere:

| Valor |
|---:|
| 100 |
| 200 |
| NULL |
| 300 |

Resultado:

`SUM(valor) = 600`

Entretanto, se todos os valores forem `NULL`, ou se não existir nenhum registro, o resultado será `NULL`.

### 3.4 SUM com COALESCE

Caso a regra de negócio determine que a ausência de valores deve ser representada por zero, podemos utilizar:

```sql
SELECT
    COALESCE(SUM(preco), 0) AS total_precos
FROM techstore.produtos
WHERE id < 0;
```

Nesse exemplo, a consulta não encontra produtos e substitui o resultado ausente por zero.

Atenção: essa substituição deve representar uma decisão consciente de negócio. Nem todo `NULL` significa zero.

### 3.5 Cuidados com duplicidades

Uma das maiores fontes de erros em relatórios financeiros é somar valores repetidos indevidamente.

Imagine que um pedido possua três itens.

Se o valor total do pedido for repetido em cada linha dos itens, somar essa coluna depois de combinar as tabelas pode multiplicar artificialmente o faturamento.

O problema não está necessariamente na função `SUM`, mas no conjunto de registros que está sendo agregado.

Esse assunto será aprofundado no módulo de JOINs.

---

## 4. AVG — Cálculo de médias

### 4.1 Funcionamento

`AVG` calcula a média aritmética dos valores não nulos.

A fórmula é:

\[
\text{Média} =
\frac{\text{Soma dos valores}}{\text{Quantidade de valores considerados}}
\]

Exemplo:

```sql
SELECT
    AVG(preco) AS preco_medio
FROM techstore.produtos;
```

O PostgreSQL soma os preços válidos e divide pela quantidade de valores não nulos.

### 4.2 AVG e NULL

Considere:

| Valor |
|---:|
| 100 |
| 200 |
| NULL |
| 300 |

A média será:

\[
\frac{100+200+300}{3}=200
\]

O `NULL` não participa da soma nem do divisor.

Isso é diferente de substituir o `NULL` por zero antes de calcular a média.

Se fosse utilizado zero:

\[
\frac{100+200+0+300}{4}=150
\]

Portanto, tratar valores ausentes como zero pode alterar significativamente um indicador.

### 4.3 Média simples e média ponderada

Uma média simples considera cada valor com o mesmo peso.

Uma média ponderada considera o peso ou a quantidade associada a cada valor.

Exemplo:

| Produto | Quantidade | Preço unitário |
|---|---:|---:|
| A | 10 | 20,00 |
| B | 2 | 100,00 |

Média simples:

\[
\frac{20+100}{2}=60
\]

Média ponderada:

\[
\frac{(10 \times 20)+(2 \times 100)}{10+2}
\]

\[
\frac{400}{12}=33,33
\]

A média ponderada representa melhor o preço médio por unidade comercializada nesse cenário.

Uma implementação conceitual:

```sql
SELECT
    SUM(quantidade * preco_unitario)
    / NULLIF(SUM(quantidade), 0) AS preco_medio_ponderado
FROM techstore.itens_pedido;
```

O `NULLIF` protege a operação contra uma divisão por zero.

### 4.4 Precisão numérica

O tipo de retorno de `AVG` depende do tipo de entrada.

No PostgreSQL:

| Tipo de entrada | Tipo de retorno de AVG |
|---|---|
| SMALLINT | NUMERIC |
| INTEGER | NUMERIC |
| BIGINT | NUMERIC |
| NUMERIC | NUMERIC |
| REAL | DOUBLE PRECISION |
| DOUBLE PRECISION | DOUBLE PRECISION |

É importante compreender que o resultado de uma média pode possuir casas decimais mesmo quando os valores originais são inteiros.

---

## 5. MIN e MAX

### 5.1 MIN

Retorna o menor valor encontrado no conjunto analisado.

```sql
SELECT
    MIN(preco) AS menor_preco
FROM techstore.produtos;
```

### 5.2 MAX

Retorna o maior valor encontrado.

```sql
SELECT
    MAX(preco) AS maior_preco
FROM techstore.produtos;
```

### 5.3 Aplicação em datas

As funções também trabalham com datas.

```sql
SELECT
    MIN(data_pedido) AS primeiro_pedido,
    MAX(data_pedido) AS ultimo_pedido
FROM techstore.pedidos;
```

Isso permite identificar os limites temporais dos registros.

### 5.4 Aplicação em textos

`MIN` e `MAX` também podem operar sobre textos.

Nesse caso, o resultado depende das regras de ordenação e collation aplicáveis.

Não significa necessariamente o menor ou maior texto em quantidade de caracteres.

### 5.5 Comportamento com NULL

Valores `NULL` são ignorados por `MIN` e `MAX`.

Se todos os valores forem `NULL`, o resultado será `NULL`.

---

## 6. GROUP BY — Agrupamento de registros

### 6.1 Conceito

`GROUP BY` divide os registros em grupos conforme os valores de uma ou mais expressões.

Em vez de produzir um único resultado para toda a tabela, podemos obter um resultado para cada grupo.

Exemplo:

```sql
SELECT
    status,
    COUNT(*) AS quantidade
FROM techstore.pedidos
GROUP BY status;
```

A consulta produz uma linha para cada status encontrado.

O resultado conceitual:

| Status | Quantidade |
|---|---:|
| entregue | 120000 |
| em transporte | 80000 |
| cancelado | 50000 |
| processando | 250000 |

Os números acima são ilustrativos, não resultados medidos do banco.

### 6.2 Agrupamento por uma coluna

```sql
SELECT
    categoria_id,
    COUNT(*) AS quantidade_produtos
FROM techstore.produtos
GROUP BY categoria_id;
```

Cada categoria terá uma linha consolidada.

### 6.3 Agrupamento por múltiplas colunas

É possível agrupar por mais de uma coluna.

```sql
SELECT
    status,
    funcionario_id,
    COUNT(*) AS quantidade_pedidos
FROM techstore.pedidos
GROUP BY
    status,
    funcionario_id;
```

Nesse caso, cada grupo representa uma combinação de status e funcionário.

Por exemplo:

- pedidos entregues pelo funcionário 10;
- pedidos cancelados pelo funcionário 10;
- pedidos entregues pelo funcionário 20.

### 6.4 GROUP BY e SELECT

Existe uma regra fundamental:

Quando uma consulta utiliza agregações e agrupamentos, as colunas selecionadas precisam ser compatíveis com a definição dos grupos.

Exemplo válido:

```sql
SELECT
    categoria_id,
    COUNT(*) AS quantidade
FROM techstore.produtos
GROUP BY categoria_id;
```

Exemplo inválido:

```sql
SELECT
    categoria_id,
    nome,
    COUNT(*)
FROM techstore.produtos
GROUP BY categoria_id;
```

O problema é que podem existir vários nomes de produtos dentro de uma mesma categoria.

O PostgreSQL não sabe qual nome individual deveria apresentar para representar todo o grupo.

Para resolver corretamente, seria necessário rever o agrupamento ou aplicar outra operação que represente a intenção da consulta.

### 6.5 GROUP BY com expressões

Também é possível agrupar por expressões.

Exemplo:

```sql
SELECT
    DATE_TRUNC('month', data_pedido) AS mes,
    COUNT(*) AS quantidade_pedidos
FROM techstore.pedidos
GROUP BY DATE_TRUNC('month', data_pedido)
ORDER BY mes;
```

Essa consulta consolida os pedidos por mês.

O agrupamento não precisa utilizar somente colunas originais da tabela.

### 6.6 Agrupamento e NULL

Valores `NULL` são considerados equivalentes para a formação dos grupos.

Assim, se várias linhas possuírem `NULL` na coluna utilizada no agrupamento, elas formarão um único grupo correspondente a esse valor ausente.

---

## 7. HAVING — Filtragem de grupos

### 7.1 Conceito

`HAVING` permite filtrar os grupos produzidos pelo `GROUP BY`.

Enquanto `WHERE` filtra registros individuais, `HAVING` filtra os resultados agrupados.

### 7.2 WHERE

Exemplo:

```sql
SELECT
    status,
    COUNT(*) AS quantidade
FROM techstore.pedidos
WHERE status = 'entregue'
GROUP BY status;
```

Primeiro são considerados somente os registros que atendem à condição.

Depois ocorre o agrupamento.

### 7.3 HAVING

Exemplo:

```sql
SELECT
    funcionario_id,
    COUNT(*) AS quantidade_pedidos
FROM techstore.pedidos
GROUP BY funcionario_id
HAVING COUNT(*) > 100;
```

Nesse caso, todos os grupos são formados e somente os grupos com mais de 100 pedidos são retornados.

### 7.4 WHERE e HAVING juntos

```sql
SELECT
    funcionario_id,
    COUNT(*) AS quantidade_pedidos
FROM techstore.pedidos
WHERE status = 'entregue'
GROUP BY funcionario_id
HAVING COUNT(*) > 50
ORDER BY quantidade_pedidos DESC;
```

A consulta:

1. Considera somente pedidos entregues.
2. Agrupa os registros por funcionário.
3. Conta os pedidos de cada funcionário.
4. Mantém apenas os grupos com mais de 50 pedidos.
5. Ordena os resultados.

### 7.5 Diferença fundamental

| WHERE | HAVING |
|---|---|
| Filtra registros | Filtra grupos |
| Atua antes da agregação | Atua depois da formação dos grupos |
| Normalmente utiliza condições sobre colunas | Pode utilizar funções agregadoras |
| Reduz os registros considerados | Reduz os grupos retornados |

É possível utilizar `HAVING` sem `GROUP BY`, quando a intenção é filtrar o resultado de uma agregação global.

---

## 8. Agregações com DISTINCT

### 8.1 Conceito

`DISTINCT` dentro de uma função agregadora faz com que somente valores distintos participem daquela agregação.

### 8.2 COUNT(DISTINCT)

```sql
SELECT
    COUNT(DISTINCT cliente_id) AS clientes_com_acessos
FROM techstore.acessos;
```

Um cliente com cem acessos será contado uma única vez.

Valores `NULL` não são contabilizados.

### 8.3 SUM(DISTINCT)

```sql
SELECT
    SUM(DISTINCT preco) AS soma_precos_distintos
FROM techstore.produtos;
```

Essa consulta soma cada valor de preço somente uma vez.

Atenção: isso não significa que seja uma maneira correta de eliminar duplicidades de registros.

Imagine dois produtos diferentes que custam R$ 100,00.

Com `SUM(preco)`, os dois produtos contribuem para a soma.

Com `SUM(DISTINCT preco)`, o valor de R$ 100,00 participa somente uma vez.

A função está eliminando valores repetidos, não identificando registros duplicados.

Essa diferença é extremamente importante em indicadores financeiros.

---

## 9. Agregações condicionais

### 9.1 Conceito

Agregações condicionais permitem calcular indicadores diferentes dentro da mesma consulta.

Podemos, por exemplo, contar pedidos por status sem executar uma consulta separada para cada situação.

### 9.2 Utilizando CASE

```sql
SELECT
    COUNT(*) AS total_pedidos,

    COUNT(
        CASE
            WHEN status = 'entregue' THEN 1
        END
    ) AS entregues,

    COUNT(
        CASE
            WHEN status = 'cancelado' THEN 1
        END
    ) AS cancelados

FROM techstore.pedidos;
```

Cada expressão realiza uma contagem específica.

O `CASE` retorna um valor para as linhas que atendem à condição e `NULL` para as demais.

Como `COUNT(expressão)` ignora `NULL`, somente os registros correspondentes são contabilizados.

### 9.3 Utilizando FILTER

O PostgreSQL oferece a cláusula `FILTER` para aplicar condições diretamente a funções agregadoras.

```sql
SELECT
    COUNT(*) AS total_pedidos,

    COUNT(*) FILTER (
        WHERE status = 'entregue'
    ) AS entregues,

    COUNT(*) FILTER (
        WHERE status = 'cancelado'
    ) AS cancelados,

    COUNT(*) FILTER (
        WHERE status = 'em transporte'
    ) AS em_transporte

FROM techstore.pedidos;
```

A vantagem é deixar explícita a condição de cada indicador.

### 9.4 Somas condicionais

Também podemos utilizar `FILTER` com `SUM`.

```sql
SELECT
    SUM(valor_frete) AS frete_total,

    SUM(valor_frete) FILTER (
        WHERE status = 'entregue'
    ) AS frete_entregue,

    SUM(valor_frete) FILTER (
        WHERE status = 'cancelado'
    ) AS frete_cancelado

FROM techstore.pedidos;
```

Isso permite construir diferentes indicadores em uma única consulta.

### 9.5 CASE ou FILTER?

Ambos podem resolver diversos problemas de agregação condicional.

| Característica | CASE | FILTER |
|---|---|---|
| Compatibilidade SQL | Ampla | Recurso padronizado em versões modernas do SQL |
| Condição | Dentro da expressão | Associada à agregação |
| Legibilidade | Depende da complexidade | Geralmente mais direta |
| Aplicação | Muito flexível | Especializada em filtrar entradas da agregação |

A escolha deve considerar legibilidade, compatibilidade e objetivo da consulta.

---

## 10. Agregações compostas

### 10.1 Múltiplas agregações

Uma consulta pode calcular diversos indicadores ao mesmo tempo.

```sql
SELECT
    COUNT(*) AS quantidade_produtos,
    SUM(preco) AS soma_precos,
    AVG(preco) AS preco_medio,
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM techstore.produtos;
```

Cada função trabalha sobre o conjunto de registros considerado pela consulta.

### 10.2 Expressões dentro de agregações

As funções agregadoras podem receber expressões.

Exemplo:

```sql
SELECT
    SUM(quantidade * preco_unitario) AS valor_bruto,
    SUM(quantidade * desconto_item) AS desconto_total
FROM techstore.itens_pedido;
```

A expressão é avaliada para cada linha considerada e seus resultados são agregados.

### 10.3 Indicadores derivados

Podemos utilizar diferentes agregações para construir indicadores.

Exemplo conceitual:

```sql
SELECT
    SUM(quantidade * preco_unitario) AS valor_bruto,
    SUM(quantidade) AS unidades,
    SUM(quantidade * preco_unitario)
        / NULLIF(SUM(quantidade), 0) AS preco_medio_ponderado
FROM techstore.itens_pedido;
```

Essa consulta calcula:

- Valor bruto comercializado.
- Quantidade total de unidades.
- Preço médio ponderado por unidade.

### 10.4 Agregações aninhadas

Uma função agregadora normalmente não pode conter outra função agregadora diretamente no mesmo nível de consulta.

Por exemplo, uma construção conceitual como `AVG(SUM(valor))` não é permitida diretamente dessa maneira.

Para agregar resultados de outra agregação, será necessário utilizar uma estrutura intermediária, como uma subconsulta ou CTE.

Esse assunto será desenvolvido nos módulos posteriores.

---

## 11. Agregações e análise de dados

Agregações são uma das principais ferramentas utilizadas na análise de dados.

Elas permitem transformar registros operacionais em indicadores úteis para decisões.

### 11.1 Análise comercial

Exemplos de indicadores:

- Quantidade de pedidos.
- Valor bruto dos itens.
- Total de descontos.
- Valor médio dos pedidos.
- Quantidade de unidades comercializadas.
- Distribuição de pedidos por status.

### 11.2 Análise de clientes

Indicadores possíveis:

- Total de clientes.
- Clientes com registros de acesso.
- Quantidade de acessos.
- Média de acessos por cliente.
- Distribuição de clientes por características cadastrais.

### 11.3 Análise de produtos

Indicadores possíveis:

- Quantidade de produtos.
- Preço médio.
- Menor e maior preço.
- Soma de custos.
- Distribuição de preços.
- Produtos com maior quantidade comercializada.

### 11.4 Análise de estoque

Indicadores possíveis:

- Quantidade total em estoque.
- Quantidade de produtos.
- Estoque médio.
- Distribuição de movimentações.
- Volume movimentado por tipo.

### 11.5 Análise temporal

Podemos utilizar funções temporais em conjunto com agrupamentos para produzir indicadores por:

- Ano.
- Mês.
- Dia.
- Semana.
- Período específico.

É importante escolher corretamente a granularidade temporal.

Uma análise mensal, por exemplo, não deve agrupar registros por timestamp completo, pois isso pode produzir grupos excessivamente específicos.

### 11.6 Média não significa distribuição

Uma média pode esconder diferenças importantes entre registros.

Considere:

| Funcionário | Salário |
|---|---:|
| A | 2.000 |
| B | 2.000 |
| C | 2.000 |
| D | 14.000 |

A média é:

\[
\frac{2000+2000+2000+14000}{4}=5000
\]

Entretanto, três dos quatro funcionários recebem R$ 2.000.

Portanto, a média não representa necessariamente a situação da maioria.

Uma análise profissional deve considerar o contexto e, quando necessário, outras medidas estatísticas.

---

## 12. Desempenho e otimização de agregações

### 12.1 Por que agregações podem ser custosas?

Uma agregação pode exigir que o PostgreSQL processe uma quantidade muito grande de registros.

Por exemplo, a tabela `logs_sistema` possui milhões de registros.

Uma consulta que agrupa todos esses registros por nível de ocorrência pode exigir bastante processamento.

O custo depende de fatores como:

- Quantidade de linhas.
- Número de grupos.
- Complexidade das expressões.
- Distribuição dos dados.
- Memória disponível.
- Estratégia de execução.
- Necessidade de ordenação.

### 12.2 HashAggregate

`HashAggregate` é uma estratégia de agregação que utiliza uma estrutura de hash para organizar os grupos.

Conceitualmente:

1. O PostgreSQL lê os registros.
2. Identifica o grupo de cada registro.
3. Atualiza os resultados correspondentes.
4. Produz os resultados consolidados.

Pode ser eficiente quando a estrutura de hash cabe adequadamente na memória disponível.

Entretanto, agregações grandes podem exigir operações adicionais quando a memória não é suficiente.

### 12.3 GroupAggregate

`GroupAggregate` processa registros organizados conforme as chaves de agrupamento.

Para isso, os dados precisam chegar ordenados de maneira compatível com os grupos.

Essa organização pode ser obtida por:

- Uma ordenação executada pelo plano.
- Um caminho de acesso que já forneça a ordenação necessária.

O custo de ordenação pode ser significativo, especialmente em grandes conjuntos.

### 12.4 Diferenças entre estratégias

| HashAggregate | GroupAggregate |
|---|---|
| Utiliza estrutura de hash | Processa grupos ordenados |
| Não exige ordenação prévia dos registros | Precisa de entrada ordenada |
| Pode utilizar memória significativa | Pode depender de operações de ordenação |
| Pode dividir o processamento em lotes | Processa grupos conforme a sequência ordenada |

Não existe uma estratégia universalmente melhor.

A escolha depende dos dados, da consulta e das condições de execução.

### 12.5 EXPLAIN

`EXPLAIN` permite observar o plano estimado pelo PostgreSQL.

Exemplo:

```sql
EXPLAIN
SELECT
    status,
    COUNT(*)
FROM techstore.pedidos
GROUP BY status;
```

Entre as informações que podem aparecer:

- Tipo de operação.
- Custo estimado.
- Quantidade estimada de registros.
- Estratégia de agregação.
- Operações de leitura e ordenação.

### 12.6 EXPLAIN ANALYZE

`EXPLAIN ANALYZE` executa a consulta e apresenta informações reais da execução.

Exemplo:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    status,
    COUNT(*)
FROM techstore.pedidos
GROUP BY status;
```

É possível observar:

- Planning Time.
- Execution Time.
- Actual Rows.
- Loops.
- Shared Hit Blocks.
- Shared Read Blocks.
- Tempo de execução dos nós.
- Diferenças entre estimativas e resultados reais.

### 12.7 Estimativa versus realidade

O PostgreSQL utiliza estatísticas para estimar quantos registros serão processados.

Quando a estimativa está muito distante da quantidade real, a escolha do plano pode não ser ideal.

Por isso, comparar `Plan Rows` e `Actual Rows` é importante.

Uma diferença grande pode indicar estatísticas desatualizadas, distribuição de dados difícil de estimar ou condições complexas.

### 12.8 Índices e agregações

Índices podem ajudar em determinadas consultas agregadas, especialmente quando existem filtros seletivos ou quando a ordenação necessária pode ser aproveitada.

Entretanto, um índice não garante que uma agregação será executada mais rapidamente.

Se uma consulta precisar ler grande parte de uma tabela, uma leitura sequencial pode ser mais eficiente.

A decisão deve ser baseada em evidências do plano de execução.

### 12.9 Memória e operações de ordenação

Ordenações e agregações podem consumir memória.

Quando os recursos disponíveis não são suficientes, o PostgreSQL pode utilizar arquivos temporários em disco.

Nos planos de execução, determinadas operações podem apresentar informações de:

- Batches.
- Disk Usage.
- Sort Method.
- Memory Usage.
- Temporary Blocks.

Esses indicadores ajudam a identificar operações que estão utilizando recursos adicionais.

---

## 13. Erros frequentes

### Erro 01 — Confundir COUNT(*) com COUNT(coluna)

As duas expressões possuem comportamentos diferentes quando existem valores `NULL`.

### Erro 02 — Interpretar NULL como zero

Uma soma sem valores pode retornar `NULL`, não zero.

### Erro 03 — Utilizar WHERE para filtrar agregações

Condições sobre resultados agregados normalmente devem ser aplicadas com `HAVING`.

### Erro 04 — Selecionar colunas incompatíveis com GROUP BY

O PostgreSQL exige que as expressões selecionadas sejam compatíveis com o agrupamento ou estejam agregadas.

### Erro 05 — Utilizar SUM(DISTINCT) para corrigir duplicidades

Isso elimina valores numéricos repetidos, não registros duplicados.

### Erro 06 — Calcular média ponderada incorretamente

Uma média simples não representa necessariamente o valor médio por unidade comercializada.

### Erro 07 — Somar valores após multiplicação de registros

Combinações de tabelas podem aumentar artificialmente a quantidade de linhas consideradas por uma agregação.

### Erro 08 — Ignorar grupos com NULL

Valores ausentes podem formar grupos próprios no `GROUP BY`.

### Erro 09 — Confiar somente na execução da consulta

Uma consulta pode executar sem erros e produzir um indicador incorreto.

### Erro 10 — Otimizar sem medir

Não se deve adicionar índices ou modificar configurações apenas por suposição.

---

## 14. Boas práticas profissionais

1. Defina claramente o que cada indicador representa.
2. Verifique o conjunto de registros antes de agregar.
3. Diferencie contagem de linhas e contagem de valores.
4. Considere o comportamento de `NULL`.
5. Evite `DISTINCT` sem compreender seu efeito.
6. Utilize aliases descritivos.
7. Organize os agrupamentos de forma legível.
8. Não misture indicadores com significados diferentes.
9. Valide totais e médias por métodos independentes.
10. Utilize `EXPLAIN ANALYZE` para investigar desempenho.
11. Compare estimativas e resultados reais.
12. Não considere uma consulta correta apenas porque ela executou.

---

## 15. Referência rápida

| Recurso | Sintaxe |
|---|---|
| Contagem de linhas | `COUNT(*)` |
| Contagem de valores | `COUNT(coluna)` |
| Contagem distinta | `COUNT(DISTINCT coluna)` |
| Soma | `SUM(coluna)` |
| Média | `AVG(coluna)` |
| Menor valor | `MIN(coluna)` |
| Maior valor | `MAX(coluna)` |
| Agrupamento | `GROUP BY coluna` |
| Filtro de grupos | `HAVING condição` |
| Agregação condicional | `FILTER (WHERE condição)` |
| Agregação com expressão | `SUM(expressão)` |
| Agrupamento múltiplo | `GROUP BY coluna1, coluna2` |

---

## 16. Referências oficiais

Documentação do PostgreSQL 16:

- Funções agregadoras: https://www.postgresql.org/docs/16/functions-aggregate.html
- Expressões e funções: https://www.postgresql.org/docs/16/functions.html
- SELECT: https://www.postgresql.org/docs/16/sql-select.html
- GROUP BY e HAVING: https://www.postgresql.org/docs/16/queries-table-expressions.html
- EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html
- Utilização de índices: https://www.postgresql.org/docs/16/indexes.html
- Estatísticas do planejador: https://www.postgresql.org/docs/16/planner-stats.html

---

## 17. Resultados esperados

Ao concluir a teoria e as atividades deste módulo, o estudante deverá conseguir:

- Explicar o funcionamento das funções agregadoras.
- Diferenciar contagem de linhas e contagem de valores.
- Calcular somas e médias corretamente.
- Agrupar registros por diferentes critérios.
- Filtrar grupos utilizando HAVING.
- Construir agregações condicionais.
- Identificar distorções causadas por duplicidades.
- Compreender o tratamento de NULL nas agregações.
- Construir indicadores analíticos.
- Interpretar operações de agregação nos planos de execução.
- Validar os resultados independentemente da consulta utilizada.

**Fim da teoria do Módulo 04 — Agregações SQL.**