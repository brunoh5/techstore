# Atividades — Módulo 04: Agregações SQL

## 1. Orientações gerais

Este documento contém os exercícios práticos do Módulo 04 — Agregações SQL.

O objetivo é desenvolver autonomia na construção de consultas analíticas utilizando o banco TechStore.

As atividades seguem uma progressão de dificuldade. Cada etapa utiliza os conhecimentos anteriores e introduz novas possibilidades de análise.

### Regras de execução

- Utilize PostgreSQL 16.
- Execute as consultas no pgAdmin.
- Utilize o schema `techstore`.
- Não modifique tabelas ou registros.
- Não execute `INSERT`, `UPDATE`, `DELETE`, `CREATE`, `ALTER` ou `DROP`.
- Utilize somente consultas de leitura.
- Não consulte gabaritos externos para resolver as atividades.
- Registre os resultados relevantes e as decisões tomadas.

### Como entregar as atividades

Para cada exercício, apresente:

1. A consulta SQL desenvolvida.
2. Uma explicação breve da lógica utilizada.
3. O resultado obtido.
4. A validação realizada, quando solicitada.
5. Observações sobre possíveis dificuldades.

Não basta apresentar uma consulta que executa. É necessário demonstrar que o resultado está correto.

---

# ETAPA 01 — Fundamentos de agregação

**Objetivo:** compreender o funcionamento das funções agregadoras e consolidar registros em indicadores.

### AT-01 — Quantidade de registros

Determine a quantidade total de:

- Clientes.
- Produtos.
- Pedidos.
- Funcionários.
- Avaliações.

Cada resultado deverá ser apresentado como um indicador identificado por um alias.

### AT-02 — Contagem de valores não nulos

Na tabela `acessos`, determine:

- Quantidade total de registros.
- Quantidade de registros com `cliente_id` preenchido.
- Quantidade de registros sem `cliente_id`.

Compare os resultados e explique a diferença entre contar linhas e contar valores não nulos.

### AT-03 — Valores distintos

Na tabela `acessos`, determine:

- Quantidade de clientes distintos identificados.
- Quantidade de páginas distintas acessadas.
- Quantidade de dispositivos distintos registrados.
- Quantidade de origens distintas registradas.

Explique por que a quantidade de clientes distintos não necessariamente corresponde à quantidade de acessos.

### AT-04 — Indicadores de preços

Na tabela `produtos`, determine:

- Menor preço.
- Maior preço.
- Preço médio.
- Quantidade de produtos.

Apresente todos os indicadores em uma única consulta.

### AT-05 — Indicadores de funcionários

Na tabela `funcionarios`, determine:

- Quantidade de funcionários.
- Menor salário.
- Maior salário.
- Salário médio.

Explique por que a média salarial não necessariamente representa o salário recebido pela maioria dos funcionários.

---

# ETAPA 02 — SUM e AVG

**Objetivo:** trabalhar com somas, médias e cálculos ponderados.

### AT-06 — Valor bruto comercializado

Na tabela `itens_pedido`, calcule o valor bruto total dos itens comercializados.

Considere:

- Quantidade de unidades.
- Preço unitário.
- Multiplicação dos valores antes da soma.

Apresente o resultado como indicador financeiro.

### AT-07 — Quantidade de unidades comercializadas

Determine a soma das quantidades registradas em `itens_pedido`.

Explique a diferença entre:

- Quantidade de registros da tabela.
- Quantidade total de unidades comercializadas.

### AT-08 — Média dos preços

Na tabela `produtos`, determine:

- Preço médio.
- Custo médio.
- Menor preço.
- Maior preço.
- Menor custo.
- Maior custo.

Organize os indicadores em uma única consulta.

### AT-09 — Média ponderada de preços

Utilizando `itens_pedido`, calcule o preço médio ponderado por quantidade.

A análise deverá considerar que um produto vendido em maior quantidade possui maior participação no indicador.

Compare conceitualmente o resultado com uma média aritmética simples dos preços unitários dos itens.

Explique por que os dois indicadores podem ser diferentes.

### AT-10 — Valor médio por pedido

Utilizando exclusivamente a tabela `itens_pedido`, determine:

1. O valor bruto dos itens de cada pedido.
2. A quantidade de pedidos representados na tabela.
3. O valor médio bruto por pedido.

Nesta atividade, você deverá construir uma estrutura que permita calcular o valor de cada pedido antes de calcular a média entre os pedidos.

Não utilize JOINs. O objetivo é trabalhar a agregação em etapas.

### AT-11 — Indicadores de estoque

Na tabela `estoque`, determine:

- Quantidade total de unidades disponíveis.
- Quantidade média por produto.
- Menor quantidade registrada.
- Maior quantidade registrada.
- Quantidade de produtos registrados no estoque.

Explique a diferença entre a quantidade média de unidades e a quantidade de registros de estoque.

### AT-12 — Análise de avaliações

Na tabela `avaliacoes`, determine:

- Quantidade total de avaliações.
- Nota média.
- Menor nota.
- Maior nota.
- Quantidade de clientes distintos que avaliaram.
- Quantidade de produtos distintos avaliados.

Explique quais indicadores representam volume e quais representam diversidade.

---

# ETAPA 03 — GROUP BY

**Objetivo:** aprender a segmentar registros e produzir indicadores por grupo.

### AT-13 — Pedidos por status

Na tabela `pedidos`, determine a quantidade de pedidos para cada status.

Apresente:

- Status.
- Quantidade de pedidos.

Ordene o resultado pela quantidade de pedidos em ordem decrescente.

### AT-14 — Produtos por categoria

Na tabela `produtos`, determine:

- Quantidade de produtos por categoria.
- Preço médio por categoria.
- Menor preço por categoria.
- Maior preço por categoria.

Cada categoria deverá aparecer em uma única linha.

### AT-15 — Funcionários por departamento

Na tabela `funcionarios`, determine:

- Quantidade de funcionários por departamento.
- Salário médio por departamento.
- Menor salário por departamento.
- Maior salário por departamento.

Utilize `departamento_id` como critério de agrupamento.

### AT-16 — Movimentações de estoque por tipo

Na tabela `movimentacoes_estoque`, determine:

- Quantidade de movimentações por tipo.
- Soma das quantidades movimentadas por tipo.
- Quantidade média movimentada por operação.

Explique por que contar movimentações é diferente de somar as quantidades movimentadas.

### AT-17 — Acessos por dispositivo

Na tabela `acessos`, determine:

- Quantidade de acessos por dispositivo.
- Quantidade de clientes distintos por dispositivo.
- Participação de cada dispositivo no conjunto de acessos.

A participação percentual deverá ser calculada em relação ao total de acessos.

### AT-18 — Avaliações por nota

Na tabela `avaliacoes`, determine:

- Quantidade de avaliações para cada nota.
- Quantidade de clientes distintos por nota.
- Quantidade de produtos distintos por nota.

Organize o resultado em ordem crescente de nota.

### AT-19 — Agrupamento por mês

Na tabela `pedidos`, determine:

- Quantidade de pedidos por mês.
- Primeiro pedido registrado em cada mês.
- Último pedido registrado em cada mês.

Utilize uma expressão temporal para representar o mês.

Não agrupe pelo timestamp completo.

### AT-20 — Agrupamento por múltiplas colunas

Na tabela `pedidos`, determine a quantidade de pedidos agrupada por:

- Status.
- Funcionário responsável.

O resultado deverá apresentar cada combinação de status e funcionário em uma linha.

Explique por que o número de grupos pode ser maior do que a quantidade de status existentes.

---

# ETAPA 04 — HAVING

**Objetivo:** filtrar grupos utilizando condições sobre os resultados agregados.

### AT-21 — Funcionários com maior volume de pedidos

Na tabela `pedidos`, identifique os funcionários que possuem mais de 100 pedidos registrados.

Apresente:

- Identificador do funcionário.
- Quantidade de pedidos.

Ordene pelo volume de pedidos.

### AT-22 — Categorias com quantidade mínima de produtos

Na tabela `produtos`, identifique as categorias que possuem mais de 500 produtos.

Apresente a quantidade de produtos de cada categoria.

### AT-23 — Produtos com muitas avaliações

Na tabela `avaliacoes`, identifique os produtos que possuem mais de 100 avaliações.

Apresente:

- Identificador do produto.
- Quantidade de avaliações.
- Nota média.

### AT-24 — Dispositivos com volume significativo de acessos

Na tabela `acessos`, identifique os dispositivos que possuem mais de 100.000 acessos.

Apresente:

- Dispositivo.
- Quantidade de acessos.
- Quantidade de clientes distintos.

### AT-25 — Combinação de WHERE e HAVING

Na tabela `pedidos`, considere somente os pedidos com status `entregue`.

Depois, agrupe os resultados por funcionário e mantenha somente os grupos com mais de 100 pedidos entregues.

Explique a função de cada filtro utilizado.

### AT-26 — Grupos com média elevada

Na tabela `produtos`, agrupe os registros por categoria.

Retorne somente as categorias cuja média de preço seja superior a 500.

Apresente também:

- Quantidade de produtos.
- Preço médio.
- Maior preço.

---

# ETAPA 05 — DISTINCT e agregações condicionais

**Objetivo:** construir indicadores segmentados e compreender os efeitos de valores repetidos.

### AT-27 — COUNT DISTINCT

Na tabela `itens_pedido`, determine:

- Quantidade total de registros.
- Quantidade de pedidos distintos.
- Quantidade de produtos distintos.
- Quantidade de combinações distintas entre pedido e produto.

Compare os indicadores e explique o que cada um representa.

### AT-28 — SUM e SUM DISTINCT

Na tabela `produtos`, calcule:

- Soma de todos os preços.
- Soma dos preços distintos.
- Quantidade de produtos.
- Quantidade de preços distintos.

Explique por que a soma distinta pode ser diferente da soma convencional.

Não considere `SUM(DISTINCT)` uma ferramenta automática de correção de duplicidades.

### AT-29 — Pedidos por situação em uma única consulta

Na tabela `pedidos`, construa uma consulta que apresente simultaneamente:

- Quantidade total de pedidos.
- Quantidade de pedidos entregues.
- Quantidade de pedidos cancelados.
- Quantidade de pedidos em transporte.
- Quantidade de pedidos em processamento.

Utilize agregações condicionais.

### AT-30 — Valores financeiros por situação

Na tabela `pedidos`, calcule os valores totais de frete separados por status.

A consulta deverá apresentar:

- Frete total.
- Frete associado a pedidos entregues.
- Frete associado a pedidos cancelados.
- Frete associado a pedidos em transporte.
- Frete associado a pedidos em processamento.

Utilize `FILTER` ou uma abordagem equivalente com `CASE`.

### AT-31 — Avaliações positivas e negativas

Na tabela `avaliacoes`, construa indicadores condicionais para:

- Quantidade total de avaliações.
- Quantidade de avaliações com nota igual ou superior a 4.
- Quantidade de avaliações com nota igual ou inferior a 2.
- Nota média geral.

Apresente os indicadores em uma única consulta.

### AT-32 — Movimentações por tipo e período

Na tabela `movimentacoes_estoque`, construa indicadores de quantidade de movimentações para cada tipo, separados por ano.

Utilize agrupamento temporal e agregação condicional quando necessário.

---

# ETAPA 06 — Agregações compostas e análises profissionais

**Objetivo:** combinar conhecimentos e construir indicadores próximos de situações reais de negócio.

### AT-33 — Painel de produtos

Construa uma consulta analítica sobre `produtos` contendo:

- Quantidade total de produtos.
- Preço médio.
- Custo médio.
- Menor preço.
- Maior preço.
- Soma dos preços.
- Quantidade de produtos com preço superior a 500.
- Quantidade de produtos com preço inferior a 100.

Todos os indicadores deverão aparecer em uma única linha.

### AT-34 — Painel de pedidos

Construa um resumo da tabela `pedidos` contendo:

- Quantidade total de pedidos.
- Valor total de frete.
- Frete médio.
- Menor valor de frete.
- Maior valor de frete.
- Quantidade de pedidos entregues.
- Quantidade de pedidos cancelados.

### AT-35 — Análise comercial por produto

Utilizando `itens_pedido`, determine por produto:

- Quantidade de registros de venda.
- Quantidade total de unidades.
- Valor bruto comercializado.
- Preço unitário médio.
- Maior preço unitário.
- Menor preço unitário.

Ordene os produtos pelo valor bruto comercializado.

### AT-36 — Análise de desempenho de funcionários

Na tabela `pedidos`, construa um relatório por funcionário contendo:

- Quantidade total de pedidos.
- Quantidade de pedidos entregues.
- Quantidade de pedidos cancelados.
- Quantidade de pedidos em transporte.
- Percentual de pedidos entregues em relação ao total de pedidos do funcionário.

Explique a importância de definir corretamente o denominador do percentual.

### AT-37 — Análise de logs do sistema

A tabela `logs_sistema` possui milhões de registros.

Construa uma análise por nível de ocorrência contendo:

- Quantidade de registros.
- Quantidade de módulos distintos.
- Primeiro registro observado.
- Último registro observado.

Ordene pelo volume de registros.

### AT-38 — Análise de acessos por período

Na tabela `acessos`, construa um relatório mensal contendo:

- Quantidade total de acessos.
- Quantidade de clientes distintos.
- Quantidade de páginas distintas.
- Quantidade de dispositivos distintos.

Organize cronologicamente.

### AT-39 — Análise de estoque

Utilizando `estoque`, construa um relatório que apresente:

- Quantidade de produtos registrados.
- Quantidade total em estoque.
- Quantidade média por produto.
- Quantidade de registros abaixo do estoque mínimo.
- Quantidade de registros iguais ao estoque mínimo.
- Quantidade de registros acima do estoque mínimo.

Utilize agregações condicionais.

### AT-40 — Análise de notas por produto

Na tabela `avaliacoes`, construa uma análise por produto contendo:

- Quantidade de avaliações.
- Nota média.
- Menor nota.
- Maior nota.
- Quantidade de avaliações com nota 5.
- Quantidade de avaliações com nota 1.

Ordene pela nota média e depois pela quantidade de avaliações.

---

# ETAPA 07 — Desafios profissionais

Os desafios abaixo exigem autonomia para interpretar problemas e construir consultas completas.

Não serão fornecidas instruções detalhadas de implementação.

## DES-01 — Painel executivo comercial

Construa um conjunto de indicadores que permita avaliar o desempenho comercial da TechStore.

Utilize as tabelas `pedidos` e `itens_pedido` separadamente, sem JOINs neste módulo.

O painel deverá contemplar:

- Quantidade de pedidos.
- Quantidade de itens comercializados.
- Quantidade de unidades comercializadas.
- Valor bruto dos itens.
- Valor médio bruto por pedido.
- Distribuição de pedidos por status.

Explique as diferenças entre os indicadores.

Atenção especial à granularidade de cada tabela: uma linha de pedido não representa necessariamente uma linha de item.

## DES-02 — Painel de comportamento dos clientes

Utilize `acessos` para desenvolver uma análise que apresente:

- Volume total de acessos.
- Quantidade de clientes identificados.
- Quantidade de acessos sem cliente identificado.
- Quantidade de páginas distintas.
- Quantidade de dispositivos distintos.
- Quantidade de origens distintas.
- Distribuição de acessos por dispositivo.

Explique as limitações de interpretar acessos como quantidade de clientes.

## DES-03 — Painel de qualidade de produtos

Utilize `avaliacoes` para desenvolver uma análise de qualidade que apresente:

- Quantidade total de avaliações.
- Nota média geral.
- Distribuição de notas.
- Produtos com maior quantidade de avaliações.
- Produtos com nota média superior a um limite definido por você.

Defina um critério mínimo de quantidade de avaliações antes de considerar um produto representativo.

Justifique a escolha.

## DES-04 — Auditoria de movimentações

Utilize `movimentacoes_estoque` para construir uma análise que permita identificar:

- Volume de movimentações.
- Quantidade movimentada por tipo.
- Quantidade média por movimentação.
- Distribuição anual.
- Produtos com maior volume de movimentações.

Apresente os critérios de agrupamento utilizados e explique quais indicadores podem ser úteis para uma auditoria.

## DES-05 — Análise de desempenho de consultas

Escolha três consultas desenvolvidas neste módulo:

1. Uma consulta com agregação simples.
2. Uma consulta com agrupamento.
3. Uma consulta sobre uma tabela com milhões de registros.

Para cada uma:

- Execute a consulta normalmente.
- Execute com `EXPLAIN`.
- Execute com `EXPLAIN (ANALYZE, BUFFERS)`.
- Registre Planning Time.
- Registre Execution Time.
- Identifique os nós de agregação.
- Compare linhas estimadas e reais.
- Analise o uso de memória e disco quando essas informações estiverem disponíveis.

Não altere índices nem configurações do PostgreSQL.

O objetivo é aprender a diagnosticar o plano atual, não modificar o banco.

---

# ETAPA 08 — Validação individual

Responda às perguntas sem consultar a teoria durante a primeira tentativa.

1. Qual é a diferença entre `COUNT(*)` e `COUNT(coluna)`?
2. Por que `SUM` pode retornar `NULL`?
3. Como `AVG` trata valores `NULL`?
4. Qual é a diferença entre média simples e média ponderada?
5. Qual é a finalidade de `MIN` e `MAX`?
6. Como o PostgreSQL trata valores `NULL` no `GROUP BY`?
7. Qual é a diferença entre `WHERE` e `HAVING`?
8. O que acontece quando utilizamos `COUNT(DISTINCT coluna)`?
9. Por que `SUM(DISTINCT coluna)` pode produzir um indicador financeiro incorreto?
10. Qual é a finalidade de `FILTER`?
11. Por que agregações aninhadas diretamente no mesmo nível podem gerar erro?
12. Quais fatores podem influenciar o desempenho de um `GROUP BY`?
13. Qual é a diferença entre `HashAggregate` e `GroupAggregate`?
14. Por que uma consulta que executa corretamente pode produzir um indicador incorreto?
15. Como identificar possíveis problemas de estimativa no plano de execução?

---

# ETAPA 09 — Critérios de conclusão

O módulo será considerado concluído quando o estudante demonstrar domínio dos seguintes conhecimentos:

| Competência | Resultado esperado |
|---|---|
| COUNT | Contar registros e valores corretamente |
| SUM | Somar valores e expressões |
| AVG | Calcular médias simples e ponderadas |
| MIN/MAX | Identificar limites de valores |
| GROUP BY | Agrupar registros corretamente |
| HAVING | Filtrar grupos |
| DISTINCT | Compreender a eliminação de valores repetidos |
| FILTER | Construir agregações condicionais |
| CASE | Construir indicadores segmentados |
| Agregações compostas | Desenvolver relatórios analíticos |
| Validação | Conferir resultados independentemente |
| Desempenho | Interpretar planos de execução |

### Critérios de aprovação

- Nota mínima: 85%.
- Nenhum erro crítico de lógica.
- Resultados validados.
- Desafios profissionais concluídos.
- Capacidade de explicar as consultas desenvolvidas.

---

# 10. Registro de progresso

| Etapa | Atividades | Status |
|---|---|---|
| 01 | AT-01 a AT-05 | Pendente |
| 02 | AT-06 a AT-12 | Pendente |
| 03 | AT-13 a AT-20 | Pendente |
| 04 | AT-21 a AT-26 | Pendente |
| 05 | AT-27 a AT-32 | Pendente |
| 06 | AT-33 a AT-40 | Pendente |
| 07 | DES-01 a DES-05 | Pendente |
| 08 | Validação individual | Pendente |
| 09 | Avaliação final | Pendente |

Estados possíveis:

- Pendente.
- Em andamento.
- Aprovado.
- Revisão necessária.

---

# 11. Regras de segurança e preservação

Durante todas as atividades:

- Trabalhar exclusivamente com consultas de leitura.
- Não modificar dados.
- Não alterar estruturas.
- Não criar índices.
- Não repetir a seed.
- Não executar comandos destrutivos.
- Preservar o banco principal da TechStore.

As consultas de análise de desempenho também deverão respeitar essas restrições.

---

**Status:** Atividades elaboradas. Ainda não iniciadas.

**Próximo documento:** `validacao.md`.