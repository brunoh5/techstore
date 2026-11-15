# Atividades — Módulo 09: Window Functions

## 1. Orientações gerais

Neste módulo, você deverá desenvolver consultas SQL utilizando Window Functions no PostgreSQL 16.

O objetivo não é apenas obter resultados corretos, mas compreender como as funções de janela processam os registros e como suas configurações influenciam os resultados.

### Regras

- Utilize exclusivamente consultas `SELECT`.
- Não altere os dados da TechStore.
- Não crie tabelas, índices ou objetos permanentes.
- Não execute novamente a seed.
- Utilize CTEs e subconsultas quando necessário.
- Valide os resultados com consultas independentes.
- Observe a granularidade de cada resultado.
- Não utilize `QUALIFY`, pois o PostgreSQL 16 não oferece essa cláusula.
- Utilize `EXPLAIN ANALYZE` somente quando solicitado e individualmente.

### Organização

| Nível | Conteúdo | Atividades |
|---|---|---:|
| 1 | Fundamentos e OVER | AT-01 a AT-07 |
| 2 | PARTITION BY e ORDER BY | AT-08 a AT-14 |
| 3 | Ranking | AT-15 a AT-21 |
| 4 | Window Frames | AT-22 a AT-29 |
| 5 | LAG, LEAD e funções de valor | AT-30 a AT-36 |
| 6 | Agregações analíticas | AT-37 a AT-43 |
| 7 | Análises temporais e integração | AT-44 a AT-50 |
| 8 | Desempenho e otimização | AT-51 a AT-55 |

---

# 2. Nível 1 — Fundamentos e OVER

## AT-01 — Contagem global

Utilize `COUNT(*) OVER()` para apresentar todos os produtos com a quantidade total de produtos retornados pela consulta.

Objetivos:
- Compreender `OVER()`.
- Preservar as linhas individuais.
- Comparar o resultado com `COUNT(*)` tradicional.

## AT-02 — Média geral

Apresente todos os produtos com seus respectivos preços e a média geral de preços.

Utilize `AVG() OVER()`.

## AT-03 — Maior e menor preço

Apresente todos os produtos com:
- Preço individual.
- Maior preço geral.
- Menor preço geral.

Utilize `MAX()` e `MIN()` como funções de janela.

## AT-04 — Contagem de pedidos

Apresente todos os pedidos com a quantidade total de pedidos existentes no resultado.

Compare a quantidade retornada pela Window Function com uma consulta de agregação tradicional.

## AT-05 — Soma global

Apresente os pedidos com seus valores de frete e a soma total dos fretes.

Não agrupe os registros.

## AT-06 — Comparação de granularidade

Produza duas consultas:

1. Uma consulta com `GROUP BY` para calcular a quantidade de pedidos por cliente.
2. Uma consulta com `COUNT() OVER(PARTITION BY ...)` preservando cada pedido.

Explique as diferenças de granularidade.

## AT-07 — Validação de resultados

Escolha uma tabela da TechStore que possua pelo menos algumas centenas de registros.

Produza:
- Uma contagem tradicional.
- Uma contagem utilizando Window Function.
- Uma consulta que permita comparar os resultados.

Explique por que as quantidades devem ser compatíveis quando a população considerada é a mesma.

---

# 3. Nível 2 — PARTITION BY e ORDER BY

## AT-08 — Média por categoria

Apresente todos os produtos com:
- Nome.
- Categoria.
- Preço.
- Média de preço da categoria.

Utilize `AVG() OVER(PARTITION BY ...)`.

## AT-09 — Maior preço por categoria

Apresente todos os produtos e o maior preço encontrado dentro de cada categoria.

## AT-10 — Quantidade de pedidos por cliente

Apresente cada pedido com a quantidade total de pedidos do respectivo cliente.

Não agrupe os pedidos.

Considere somente pedidos que possuem `cliente_id` preenchido.

## AT-11 — Quantidade de avaliações por produto

Apresente cada avaliação com:
- Identificador do produto.
- Nota.
- Quantidade total de avaliações daquele produto.

## AT-12 — Quantidade de movimentações por funcionário

Apresente cada movimentação com a quantidade total de movimentações do funcionário correspondente.

Considere que `funcionario_id` pode ser NULL.

Defina como esses registros devem ser tratados na análise.

## AT-13 — Pedidos ordenados por cliente

Apresente os pedidos com uma numeração sequencial dentro de cada cliente.

Utilize `ROW_NUMBER()`.

Ordene cronologicamente e estabeleça um critério de desempate.

## AT-14 — Ordenação independente da apresentação

Crie uma consulta que:

1. Calcule uma posição dos produtos pelo preço.
2. Apresente o resultado final ordenado pelo identificador do produto.

Explique por que a posição calculada pode não acompanhar a ordem visual dos registros.

---

# 4. Nível 3 — Ranking

## AT-15 — Ranking global de produtos

Crie um ranking dos produtos considerando o preço em ordem decrescente.

Utilize `ROW_NUMBER()`.

## AT-16 — Ranking de produtos por categoria

Crie um ranking independente para cada categoria.

Apresente:
- Produto.
- Categoria.
- Preço.
- Posição.

## AT-17 — Ranking com empates

Utilize `RANK()` para classificar os produtos pelo preço.

Identifique se existem empates.

Explique como o PostgreSQL trata as posições seguintes.

## AT-18 — Ranking sem lacunas

Repita a classificação anterior utilizando `DENSE_RANK()`.

Compare os resultados com `RANK()`.

## AT-19 — Comparação dos três rankings

Produza uma consulta contendo simultaneamente:

- `ROW_NUMBER()`.
- `RANK()`.
- `DENSE_RANK()`.

Utilize a mesma ordenação nas três funções.

Explique as diferenças encontradas.

## AT-20 — Segmentação por quartis

Utilize `NTILE(4)` para dividir os produtos em quatro grupos conforme seus preços.

Apresente a quantidade de produtos em cada grupo.

Explique como o PostgreSQL distribui as linhas quando a divisão não é exata.

## AT-21 — Três produtos por categoria

Apresente até três produtos de cada categoria, considerando o maior preço.

Utilize `ROW_NUMBER()` e uma CTE ou subconsulta para filtrar o resultado.

Depois, repita a análise utilizando `RANK()`.

Explique por que os dois resultados podem apresentar quantidades diferentes de produtos.

---

# 5. Nível 4 — Window Frames

## AT-22 — Soma acumulada global

Utilize `SUM() OVER()` para construir uma soma acumulada dos valores de frete dos pedidos.

Ordene por data e utilize um critério de desempate.

Defina explicitamente o frame.

## AT-23 — Soma acumulada por cliente

Repita a atividade anterior, mas reinicie o acumulado para cada cliente.

Compare os resultados com o acumulado global.

## AT-24 — Acumulado com ROWS

Utilize uma sequência controlada com `VALUES` para construir um acumulado utilizando:

`ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`.

Apresente pelo menos cinco registros.

Valide manualmente os resultados.

## AT-25 — Janela móvel de três registros

Utilize uma sequência controlada para calcular uma soma móvel considerando:

- Duas linhas anteriores.
- Linha atual.

Explique como o frame se comporta nas primeiras linhas.

## AT-26 — Comparação entre ROWS e RANGE

Crie um conjunto de dados utilizando `VALUES` que contenha valores repetidos.

Calcule uma soma acumulada utilizando:
- `ROWS`.
- `RANGE`.

Compare os resultados.

Explique o efeito dos pares de ordenação.

## AT-27 — Comparação entre ROWS e GROUPS

Utilize uma sequência controlada com valores repetidos.

Calcule uma soma utilizando:

- `ROWS BETWEEN 1 PRECEDING AND CURRENT ROW`.
- `GROUPS BETWEEN 1 PRECEDING AND CURRENT ROW`.

Explique por que os frames podem considerar quantidades diferentes de registros.

## AT-28 — Frame completo da partição

Utilize `LAST_VALUE()` para apresentar o último valor de cada partição.

Faça uma primeira consulta com o frame padrão e outra com:

`ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.

Explique a diferença.

## AT-29 — Primeiro, segundo e último registro

Utilize `FIRST_VALUE()`, `NTH_VALUE()` e `LAST_VALUE()` para identificar:

- Primeiro produto de cada categoria.
- Segundo produto de cada categoria.
- Último produto de cada categoria.

Defina uma ordenação consistente e frames apropriados.

---

# 6. Nível 5 — LAG, LEAD e funções de valor

## AT-30 — Preço anterior

Utilize `LAG()` na tabela `historico_precos`.

Apresente o preço atual e o preço registrado anteriormente para cada produto.

Ordene o histórico cronologicamente.

## AT-31 — Variação de preço

Utilize `LAG()` para calcular:

- Preço anterior.
- Preço atual.
- Diferença absoluta.
- Variação percentual.

Trate corretamente os casos sem preço anterior e possíveis divisões por zero.

## AT-32 — Próxima alteração

Utilize `LEAD()` para apresentar o próximo preço registrado para cada produto.

Explique o comportamento do último registro de cada partição.

## AT-33 — Intervalo entre pedidos

Utilize `LAG()` para comparar a data de cada pedido com a data do pedido anterior do mesmo cliente.

Apresente o intervalo entre os pedidos.

Defina como tratar clientes com apenas um pedido.

## AT-34 — Primeiro e último pedido

Utilize funções de janela para apresentar, em cada pedido:

- Data do primeiro pedido do cliente.
- Data do último pedido do cliente.

Não reduza o resultado para uma linha por cliente.

## AT-35 — Comparação com o registro seguinte

Utilize `LEAD()` para comparar as datas dos pedidos consecutivos de cada cliente.

Identifique o intervalo até o próximo pedido.

## AT-36 — Análise de avaliações

Utilize funções de janela para apresentar:

- Nota individual.
- Média de avaliações do produto.
- Maior nota do produto.
- Menor nota do produto.

Preserve cada avaliação individual.

---

# 7. Nível 6 — Agregações analíticas

## AT-37 — Total de vendas por produto

Utilize `itens_pedido` para calcular o valor bruto vendido por produto.

Apresente cada item com o total bruto do respectivo produto.

Utilize:

`quantidade * preco_unitario`.

Não aplique descontos nesta atividade.

## AT-38 — Participação percentual

Calcule a participação percentual de cada produto na soma dos preços dos produtos de sua categoria.

Apresente:
- Preço individual.
- Soma dos preços da categoria.
- Participação percentual.

Não confunda essa métrica com participação no faturamento.

## AT-39 — Quantidade de pedidos e média por cliente

Apresente cada pedido com:
- Quantidade total de pedidos do cliente.
- Média de pedidos por cliente considerando a população definida.

Explique qual população foi utilizada no denominador.

## AT-40 — Média de preço por categoria

Apresente todos os produtos com:
- Preço individual.
- Média da categoria.
- Diferença entre preço individual e média.

Identifique produtos acima e abaixo da média.

## AT-41 — Contagem condicional

Utilize `COUNT() FILTER (WHERE ...) OVER()` para contar os pedidos com status `entregue`.

Preserve cada pedido.

Compare com uma consulta que utilize `COUNT` e `GROUP BY`.

## AT-42 — Soma condicional

Utilize `SUM() FILTER (WHERE ...) OVER()` para calcular o total de frete somente dos pedidos com status `entregue`.

Apresente todos os pedidos.

## AT-43 — Indicadores simultâneos

Construa uma consulta que apresente cada produto com:

- Quantidade de avaliações.
- Média das notas.
- Maior nota.
- Menor nota.

Produtos sem avaliações também deverão ser considerados.

Para isso, escolha uma estratégia que preserve a população completa de produtos.

---

# 8. Nível 7 — Análises temporais e integração

## AT-44 — Pedidos por dia e comparação

Primeiro, calcule a quantidade de pedidos por dia.

Depois, utilize `LAG()` para comparar a quantidade de pedidos com o dia anterior existente no resultado.

Apresente:
- Dia.
- Quantidade atual.
- Quantidade anterior.
- Diferença.

Explique uma limitação de comparar apenas os dias existentes na tabela.

## AT-45 — Variação percentual diária

Evolua a atividade anterior e calcule a variação percentual entre os dias.

Trate:
- Primeiro dia.
- Dia anterior com quantidade zero.
- Valores NULL.

## AT-46 — Ranking de clientes

Calcule a quantidade de pedidos por cliente e crie um ranking dos clientes com maior quantidade de pedidos.

Apresente os dez primeiros colocados.

Considere como os empates devem ser tratados.

## AT-47 — Ranking de faturamento por produto

Calcule o faturamento bruto por produto utilizando `itens_pedido`.

Depois, classifique os produtos pelo faturamento.

Apresente:
- Identificador.
- Nome.
- Faturamento.
- Ranking.
- Participação percentual no faturamento total.

Não permita que a junção com outras tabelas multiplique os valores.

## AT-48 — Análise de estoque

Apresente os produtos com:
- Quantidade atual em estoque.
- Estoque mínimo.
- Posição do produto em relação à quantidade disponível dentro da categoria.
- Média de estoque da categoria.

Considere que a tabela `estoque` possui um registro por produto conforme o modelo da TechStore.

## AT-49 — Relatório de avaliações

Construa um relatório com:
- Produto.
- Quantidade de avaliações.
- Média de notas.
- Ranking por média de avaliações dentro da categoria.

Defina como tratar produtos sem avaliações.

Evite que produtos sem avaliações recebam uma classificação indevida.

## AT-50 — Histórico de preços analítico

Construa um relatório utilizando `historico_precos` com:

- Produto.
- Data da alteração.
- Preço anterior.
- Preço novo.
- Variação absoluta.
- Variação percentual.
- Posição cronológica da alteração.
- Próximo preço registrado.

Utilize pelo menos três funções de janela.

---

# 9. Nível 8 — Desempenho e otimização

## AT-51 — Plano de execução de ranking

Escolha uma consulta de ranking desenvolvida anteriormente.

Execute:

`EXPLAIN`

Identifique:
- Ordenações.
- WindowAgg.
- Estratégia de leitura.
- Estimativas de linhas.

Explique a estrutura do plano.

## AT-52 — Análise com EXPLAIN ANALYZE

Execute `EXPLAIN (ANALYZE, BUFFERS)` sobre a consulta escolhida.

Registre:
- Planning Time.
- Execution Time.
- Actual Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Sort Method, quando presente.

Não faça alterações no banco.

## AT-53 — Comparação de estratégias

Escolha uma análise que utilize Window Function e compare com uma estratégia baseada em agregação e JOIN, quando ambas puderem produzir o mesmo resultado.

Valide a equivalência antes de comparar desempenho.

Explique as diferenças de granularidade e complexidade.

## AT-54 — Ordenação e particionamento

Escolha uma consulta que utilize simultaneamente `PARTITION BY` e `ORDER BY`.

Analise o custo de ordenação.

Explique se a ordenação é necessária e como o PostgreSQL a executa.

Não crie índices nesta atividade.

## AT-55 — Otimização de consulta analítica

Escolha uma consulta analítica desenvolvida neste módulo.

Siga o processo:

1. Registre o resultado original.
2. Execute `EXPLAIN (ANALYZE, BUFFERS)`.
3. Identifique o principal custo.
4. Formule uma hipótese de otimização.
5. Faça uma única alteração lógica por vez.
6. Valide novamente os resultados.
7. Compare as métricas.
8. Registre a conclusão.

Não considere uma consulta otimizada apenas porque apresentou menor tempo em uma única execução.

---

# 10. Desafios complexos

Os desafios exigem combinar diferentes recursos SQL.

Não existe uma única implementação obrigatória. A avaliação considerará correção, clareza, granularidade, validação e desempenho.

## DES-01 — Ranking comercial

Desenvolva um relatório dos produtos com maior faturamento bruto.

O relatório deverá conter:

- Produto.
- Categoria.
- Quantidade vendida.
- Faturamento bruto.
- Participação percentual no faturamento total.
- Ranking global.
- Ranking dentro da categoria.

Requisitos:

- Utilizar agregação.
- Utilizar pelo menos duas Window Functions.
- Tratar empates.
- Preservar a granularidade do relatório.
- Evitar duplicações.

## DES-02 — Comportamento dos clientes

Desenvolva uma análise de comportamento dos clientes.

O relatório deverá apresentar:

- Quantidade de pedidos.
- Data do primeiro pedido.
- Data do último pedido.
- Data do pedido anterior.
- Intervalo entre pedidos.
- Ranking de clientes por quantidade de pedidos.

Defina como clientes sem pedidos serão tratados.

## DES-03 — Evolução de preços

Desenvolva um relatório de evolução dos preços.

O resultado deverá apresentar:

- Produto.
- Histórico cronológico.
- Preço anterior.
- Preço atual.
- Próximo preço.
- Variação absoluta.
- Variação percentual.
- Ranking cronológico por produto.

Trate corretamente os primeiros e últimos registros.

## DES-04 — Análise de estoque

Desenvolva uma análise comparativa do estoque.

O relatório deverá apresentar:

- Produto.
- Categoria.
- Quantidade atual.
- Estoque mínimo.
- Média de estoque da categoria.
- Diferença em relação à média.
- Ranking por quantidade disponível.

Considere produtos que eventualmente não possuam registro de estoque.

## DES-05 — Relatório executivo TechStore

Construa um relatório analítico que combine:

- Produtos.
- Categorias.
- Vendas.
- Avaliações.
- Rankings.
- Indicadores percentuais.

O resultado deverá permitir identificar produtos com bom desempenho comercial e boa avaliação.

Requisitos:

- Utilizar CTEs.
- Utilizar agregações.
- Utilizar pelo menos três Window Functions.
- Evitar multiplicação de registros.
- Tratar produtos sem vendas ou avaliações.
- Justificar a granularidade final.

## DES-06 — Investigação de desempenho

Escolha uma consulta complexa desenvolvida durante o módulo.

Produza uma análise técnica contendo:

1. Objetivo da consulta.
2. Granularidade esperada.
3. Resultado original.
4. Plano de execução.
5. Identificação de gargalos.
6. Hipótese de otimização.
7. Alteração realizada.
8. Resultado após a alteração.
9. Comparação de métricas.
10. Conclusão técnica.

A consulta deverá manter os mesmos resultados após a otimização.

---

# 11. Perguntas de compreensão

Responda com suas próprias palavras.

1. Qual é a principal diferença entre GROUP BY e Window Functions?
2. Para que serve a cláusula OVER?
3. Qual é a função do PARTITION BY?
4. O ORDER BY dentro de OVER altera necessariamente a ordenação final?
5. Qual é a diferença entre ROW_NUMBER e RANK?
6. Qual é a diferença entre RANK e DENSE_RANK?
7. Como funciona NTILE?
8. O que é um Window Frame?
9. Qual é a diferença entre ROWS e RANGE?
10. O que significa GROUPS?
11. Qual é o frame padrão quando existe ORDER BY em uma janela?
12. Por que LAST_VALUE pode retornar um resultado inesperado?
13. Qual é a diferença entre LAG e LEAD?
14. Para que serve NTH_VALUE?
15. Como calcular um total acumulado?
16. Como calcular uma média móvel?
17. É possível utilizar FILTER em uma agregação de janela no PostgreSQL?
18. Por que uma Window Function não pode ser filtrada diretamente no WHERE da mesma etapa?
19. O PostgreSQL 16 possui QUALIFY?
20. Quais elementos do plano de execução são importantes para analisar Window Functions?
21. Por que uma ordenação com empates pode não ser determinística?
22. Como preservar a granularidade ao combinar agregações e Window Functions?
23. Qual é o risco de combinar várias tabelas com relacionamentos um-para-muitos antes de calcular indicadores?
24. Por que uma consulta com Window Function pode exigir uma operação Sort?
25. Como validar que uma otimização preservou os resultados originais?

---

# 12. Critérios de avaliação

A avaliação seguirá os critérios gerais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: **85%**.

Erros críticos de lógica, granularidade ou interpretação dos frames deverão ser corrigidos mesmo quando a nota geral atingir o mínimo.

## 12.1 O que será observado

### Correção lógica

- Resultados corretos.
- Particionamento correto.
- Ordenação adequada.
- Frames compatíveis com a regra de negócio.
- Tratamento de empates e NULL.

### Domínio SQL

- Uso correto de `OVER`.
- Domínio de `PARTITION BY`.
- Domínio de rankings.
- Uso adequado de LAG e LEAD.
- Integração com CTEs e agregações.

### Validação

- Comparação com resultados independentes.
- Casos com empates.
- Partições com poucas linhas.
- Partições com uma única linha.
- Valores NULL.
- Divisão por zero.
- Frames com limites diferentes.

### Desempenho

- Interpretação de WindowAgg.
- Análise de Sort.
- Comparação de planos.
- Identificação de gargalos.
- Validação após otimização.

### Legibilidade

- Aliases claros.
- CTEs organizadas.
- Consultas compreensíveis.
- Granularidade documentada.
- Ausência de operações desnecessárias.

---

# 13. Registro de progresso

Utilize esta seção para acompanhar a execução.

| Etapa | Status | Observações |
|---|---|---|
| AT-01 a AT-07 | Pendente | Fundamentos |
| AT-08 a AT-14 | Pendente | Particionamento |
| AT-15 a AT-21 | Pendente | Rankings |
| AT-22 a AT-29 | Pendente | Window Frames |
| AT-30 a AT-36 | Pendente | Navegação e valores |
| AT-37 a AT-43 | Pendente | Agregações analíticas |
| AT-44 a AT-50 | Pendente | Análises temporais |
| AT-51 a AT-55 | Pendente | Desempenho |
| DES-01 a DES-06 | Pendente | Desafios |
| Perguntas de compreensão | Pendente | Revisão teórica |
| Avaliação de domínio | Pendente | Validação independente |

---

# 14. Condições para aprovação

Para concluir o módulo, será necessário:

- Demonstrar domínio de `OVER` e `PARTITION BY`.
- Diferenciar corretamente os rankings.
- Compreender os três tipos de Window Frame.
- Utilizar LAG e LEAD corretamente.
- Construir acumulados e médias móveis.
- Integrar Window Functions com CTEs e agregações.
- Preservar a granularidade.
- Validar os resultados.
- Interpretar planos de execução.
- Concluir os desafios definidos na avaliação.

A aprovação de referência exige nota mínima de 85%, sem erros críticos.

Caso existam lacunas, será realizado reforço direcionado aos assuntos que ainda não foram dominados.

Após a aprovação, o aluno estará apto a avançar para o:

**Módulo 10 — DML e Transações.**

---

# 15. Segurança e preservação do ambiente

A TechStore é o ambiente principal de estudo e deve ser preservada.

Durante este módulo:

- Não utilizar INSERT.
- Não utilizar UPDATE.
- Não utilizar DELETE.
- Não utilizar TRUNCATE.
- Não utilizar DROP.
- Não executar novamente a seed.
- Não criar índices ou tabelas permanentes.
- Não alterar configurações do PostgreSQL.

Todas as atividades devem ser executadas com consultas de leitura.

**Regra principal:** o objetivo é desenvolver domínio analítico sobre o banco existente, não modificar sua estrutura ou seus dados.