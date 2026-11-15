# Validação — Módulo 09: Window Functions

## 1. Objetivo da validação

Este documento estabelece os critérios para verificar se o aluno realmente domina Window Functions no PostgreSQL 16.

A validação não consiste apenas em verificar se uma consulta executa sem erros.

Será necessário demonstrar que os resultados estão corretos, que as funções foram utilizadas adequadamente e que o comportamento das janelas foi compreendido.

Serão avaliados:

- Estrutura `OVER`.
- `PARTITION BY`.
- `ORDER BY`.
- `ROW_NUMBER`, `RANK`, `DENSE_RANK` e `NTILE`.
- Window Frames.
- `ROWS`, `RANGE` e `GROUPS`.
- `LAG` e `LEAD`.
- `FIRST_VALUE`, `LAST_VALUE` e `NTH_VALUE`.
- Agregações analíticas.
- CTEs e subconsultas.
- Análises temporais.
- Granularidade.
- Desempenho e planos de execução.

## 2. Regras de validação

Durante toda a validação:

1. Utilizar somente consultas de leitura.
2. Não modificar a TechStore.
3. Não executar novamente a seed.
4. Não criar objetos permanentes.
5. Não criar índices.
6. Não alterar configurações do PostgreSQL.
7. Validar resultados com dados controlados quando necessário.
8. Não considerar uma consulta correta apenas porque executou sem erros.

### 2.1 Ambiente

- PostgreSQL 16.
- Banco TechStore.
- Schema `techstore`.
- Consultas executadas pelo pgAdmin ou cliente PostgreSQL equivalente.

### 2.2 Testes independentes

Os testes controlados deverão utilizar `VALUES` ou CTEs para produzir conjuntos conhecidos.

Assim, a validação não dependerá dos valores específicos encontrados na seed.

---

# 3. Validação estrutural

## VAL-01 — Estrutura OVER

**Objetivo:** verificar o domínio da cláusula `OVER`.

Critérios:

- Utilizar uma função de janela.
- Preservar as linhas individuais.
- Demonstrar a diferença entre agregação tradicional e agregação analítica.
- Explicar a função de `OVER()`.

**Aprovação:** resultado correto e explicação coerente sobre granularidade.

## VAL-02 — Particionamento

**Objetivo:** verificar `PARTITION BY`.

Critérios:

- Criar partições independentes.
- Demonstrar que o cálculo reinicia em cada partição.
- Comparar o resultado com uma janela global.
- Explicar o efeito de utilizar mais de uma coluna no particionamento.

**Aprovação:** nenhuma mistura indevida entre partições.

## VAL-03 — Ordenação

**Objetivo:** verificar `ORDER BY` dentro de `OVER`.

Critérios:

- Criar uma ordenação crescente.
- Criar uma ordenação decrescente.
- Trabalhar com valores empatados.
- Estabelecer critérios de desempate quando necessário.
- Diferenciar ordenação da janela e ordenação final.

**Aprovação:** resultados coerentes e determinísticos quando a consulta exigir ordem única.

---

# 4. Validação de rankings

## VAL-04 — ROW_NUMBER

Conjunto de teste:

| ID | Valor |
|---:|---:|
| 1 | 100 |
| 2 | 90 |
| 3 | 90 |
| 4 | 80 |
| 5 | 70 |

Ordenação decrescente por valor, com ID crescente como desempate.

Resultado esperado:

| ID | Valor | ROW_NUMBER |
|---:|---:|---:|
| 1 | 100 | 1 |
| 2 | 90 | 2 |
| 3 | 90 | 3 |
| 4 | 80 | 4 |
| 5 | 70 | 5 |

Critérios:

- Cada linha recebe uma posição única.
- A sequência começa em 1.
- A ordenação respeita os critérios definidos.

## VAL-05 — RANK

Utilize o mesmo conjunto do teste anterior.

Resultado esperado:

| ID | Valor | RANK |
|---:|---:|---:|
| 1 | 100 | 1 |
| 2 | 90 | 2 |
| 3 | 90 | 2 |
| 4 | 80 | 4 |
| 5 | 70 | 5 |

Critérios:

- Valores empatados recebem a mesma posição.
- A posição seguinte considera a quantidade de linhas empatadas.

## VAL-06 — DENSE_RANK

Resultado esperado:

| ID | Valor | DENSE_RANK |
|---:|---:|---:|
| 1 | 100 | 1 |
| 2 | 90 | 2 |
| 3 | 90 | 2 |
| 4 | 80 | 3 |
| 5 | 70 | 4 |

Critérios:

- Valores empatados recebem a mesma classificação.
- Não existem lacunas nas posições seguintes.

## VAL-07 — Comparação dos rankings

O aluno deverá apresentar as três funções na mesma consulta.

Critérios:

- Resultados equivalentes aos testes individuais.
- Diferenças explicadas corretamente.
- Desempate definido para `ROW_NUMBER`.
- Empates preservados em `RANK` e `DENSE_RANK`.

## VAL-08 — NTILE

Conjunto de teste:

```sql
WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1, 10),
            (2, 20),
            (3, 30),
            (4, 40),
            (5, 50),
            (6, 60),
            (7, 70),
            (8, 80),
            (9, 90),
            (10, 100)
    ) AS v(id, valor)
)
SELECT
    id,
    valor,
    NTILE(4) OVER (
        ORDER BY valor, id
    ) AS grupo
FROM dados
ORDER BY valor, id;
```

Distribuição esperada:

| Grupo | Quantidade |
|---:|---:|
| 1 | 3 |
| 2 | 3 |
| 3 | 2 |
| 4 | 2 |

Critérios:

- Todas as linhas devem pertencer a um grupo.
- A distribuição deve seguir as regras de `NTILE`.
- O aluno deverá explicar a distribuição quando a divisão não for exata.

---

# 5. Validação de Window Frames

## VAL-09 — Acumulado com ROWS

Conjunto de teste:

```sql
WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1, 10),
            (2, 20),
            (3, 30),
            (4, 40),
            (5, 50)
    ) AS v(id, valor)
)
SELECT
    id,
    valor,
    SUM(valor) OVER (
        ORDER BY id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS acumulado
FROM dados
ORDER BY id;
```

Resultado esperado:

| ID | Valor | Acumulado |
|---:|---:|---:|
| 1 | 10 | 10 |
| 2 | 20 | 30 |
| 3 | 30 | 60 |
| 4 | 40 | 100 |
| 5 | 50 | 150 |

Critérios:

- Acumulado progressivo.
- Frame corretamente definido.
- Nenhuma linha anterior omitida.

## VAL-10 — Frame móvel

Conjunto de teste:

```sql
WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1, 10),
            (2, 20),
            (3, 30),
            (4, 40),
            (5, 50)
    ) AS v(id, valor)
)
SELECT
    id,
    valor,
    SUM(valor) OVER (
        ORDER BY id
        ROWS BETWEEN 2 PRECEDING
                 AND CURRENT ROW
    ) AS soma_movel
FROM dados
ORDER BY id;
```

Resultado esperado:

| ID | Valor | Soma móvel |
|---:|---:|---:|
| 1 | 10 | 10 |
| 2 | 20 | 30 |
| 3 | 30 | 60 |
| 4 | 40 | 90 |
| 5 | 50 | 120 |

Critérios:

- Considerar no máximo três linhas.
- Respeitar os limites disponíveis nas primeiras linhas.
- Não incluir registros posteriores.

## VAL-11 — Diferença entre ROWS e RANGE

Conjunto de teste:

```sql
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
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS acumulado_rows,

    SUM(valor) OVER (
        ORDER BY valor
        RANGE BETWEEN UNBOUNDED PRECEDING
                  AND CURRENT ROW
    ) AS acumulado_range

FROM dados
ORDER BY valor, id;
```

Resultado esperado:

| ID | Valor | Acumulado ROWS | Acumulado RANGE |
|---:|---:|---:|---:|
| 1 | 10 | 10 | 10 |
| 2 | 20 | 30 | 50 |
| 3 | 20 | 50 | 50 |
| 4 | 30 | 80 | 80 |

Critérios:

- Entender a diferença entre linhas físicas e grupos de pares.
- Explicar por que as linhas empatadas recebem o mesmo resultado com `RANGE`.
- Não presumir que `ROWS` e `RANGE` são intercambiáveis.

## VAL-12 — Diferença entre ROWS e GROUPS

Conjunto de teste:

```sql
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
        ROWS BETWEEN 1 PRECEDING
                 AND CURRENT ROW
    ) AS soma_rows,

    SUM(valor) OVER (
        ORDER BY valor
        GROUPS BETWEEN 1 PRECEDING
                   AND CURRENT ROW
    ) AS soma_groups

FROM dados
ORDER BY valor, id;
```

Resultado esperado:

| ID | Valor | Soma ROWS | Soma GROUPS |
|---:|---:|---:|---:|
| 1 | 10 | 10 | 10 |
| 2 | 20 | 30 | 50 |
| 3 | 20 | 40 | 50 |
| 4 | 30 | 50 | 100 |
| 5 | 30 | 60 | 100 |
| 6 | 30 | 60 | 100 |

Critérios:

- `ROWS` considera posições individuais.
- `GROUPS` considera grupos de pares.
- O aluno deverá justificar as diferenças.

## VAL-13 — Frame padrão

Utilize o conjunto:

```sql
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
    ) AS acumulado_padrao
FROM dados
ORDER BY valor, id;
```

Resultado esperado:

| ID | Valor | Acumulado padrão |
|---:|---:|---:|
| 1 | 10 | 10 |
| 2 | 20 | 50 |
| 3 | 20 | 50 |
| 4 | 30 | 80 |

Critérios:

- Identificar o frame padrão.
- Compreender a inclusão de pares.
- Explicar por que as duas linhas com valor 20 possuem o mesmo acumulado.

## VAL-14 — LAST_VALUE

Utilize um conjunto controlado com pelo menos quatro registros ordenados.

Compare:

1. `LAST_VALUE()` com o frame padrão.
2. `LAST_VALUE()` com `UNBOUNDED FOLLOWING`.

Critérios:

- Identificar o comportamento do frame padrão.
- Obter o último valor da partição na segunda consulta.
- Explicar a diferença entre último valor do frame e último valor da partição.

## VAL-15 — NTH_VALUE

Utilize um conjunto com pelo menos cinco registros.

Verifique:

- Primeiro valor.
- Segundo valor.
- Terceiro valor.
- Uma posição superior à quantidade de linhas disponíveis.

Critérios:

- Resultado correto para cada posição.
- Retorno NULL quando a posição não existe no frame.
- Frame definido corretamente.

---

# 6. Validação de funções de navegação

## VAL-16 — LAG

Conjunto de teste:

```sql
WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1, 10),
            (2, 20),
            (3, 30),
            (4, 40)
    ) AS v(id, valor)
)
SELECT
    id,
    valor,
    LAG(valor) OVER (
        ORDER BY id
    ) AS anterior
FROM dados
ORDER BY id;
```

Resultado esperado:

| ID | Valor | Anterior |
|---:|---:|---:|
| 1 | 10 | NULL |
| 2 | 20 | 10 |
| 3 | 30 | 20 |
| 4 | 40 | 30 |

Critérios:

- A primeira linha não possui anterior.
- As demais linhas recuperam o valor correto.

## VAL-17 — LEAD

Utilize o mesmo conjunto anterior.

Resultado esperado:

| ID | Valor | Próximo |
|---:|---:|---:|
| 1 | 10 | 20 |
| 2 | 20 | 30 |
| 3 | 30 | 40 |
| 4 | 40 | NULL |

Critérios:

- A última linha não possui próximo registro.
- Os demais valores devem corresponder à ordenação.

## VAL-18 — Deslocamento e valor padrão

Crie um conjunto com pelo menos cinco registros.

Utilize:
- `LAG` com deslocamento 2.
- `LEAD` com deslocamento 2.
- Valor padrão personalizado.

Critérios:

- Deslocamento respeitado.
- Valor padrão aplicado somente quando a linha solicitada não existe.
- NULL existente na coluna de origem não deve ser confundido com ausência de linha.

## VAL-19 — Partições independentes com LAG

Crie um conjunto com pelo menos duas partições.

Utilize `LAG()` com `PARTITION BY`.

Critérios:

- A primeira linha de cada partição deve respeitar a ausência de registro anterior dentro daquela partição.
- Nenhum valor deve atravessar os limites das partições.

---

# 7. Validação de funções de valor

## VAL-20 — FIRST_VALUE

Crie um conjunto com pelo menos quatro registros.

Utilize `FIRST_VALUE()` com ordenação definida.

Critérios:

- Retorno do primeiro valor do frame.
- Frame compatível com a finalidade.
- Ordenação consistente.

## VAL-21 — LAST_VALUE

Crie duas consultas com o mesmo conjunto.

Uma utilizará o frame padrão e outra utilizará:

`ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.

Critérios:

- Diferença explicada corretamente.
- Último valor da partição obtido na consulta com frame completo.

## VAL-22 — NTH_VALUE e NULL

Crie um conjunto que contenha:
- Valores numéricos.
- Um valor NULL.
- Uma quantidade limitada de registros.

Utilize `NTH_VALUE()`.

Critérios:

- Distinguir posição inexistente de valor NULL existente.
- Compreender que a função retorna o valor da posição solicitada dentro do frame.
- Tratar corretamente os limites da janela.

---

# 8. Validação de agregações analíticas

## VAL-23 — COUNT OVER

Crie um conjunto controlado e calcule a quantidade de registros por partição.

Critérios:

- Contagem correta.
- Preservação de todas as linhas.
- Comparação com uma agregação tradicional.

## VAL-24 — SUM OVER

Crie um conjunto com valores conhecidos.

Calcule:
- Soma global.
- Soma por partição.
- Soma acumulada.

Critérios:

- Resultados corretos.
- Diferenças explicadas.
- Frame definido conforme a necessidade.

## VAL-25 — AVG OVER

Crie um conjunto com valores numéricos e pelo menos um NULL.

Calcule a média por partição.

Critérios:

- Compreender o tratamento de NULL em `AVG`.
- Identificar o denominador efetivo.
- Validar o resultado manualmente.

## VAL-26 — MIN e MAX OVER

Crie um conjunto com pelo menos duas partições.

Calcule o menor e o maior valor de cada partição.

Critérios:

- Partições independentes.
- Resultados corretos.
- Nenhuma redução indevida de linhas.

## VAL-27 — FILTER em agregações de janela

Crie um conjunto com diferentes categorias ou status.

Utilize `FILTER (WHERE ...)` em uma função agregada de janela.

Critérios:

- Filtragem aplicada somente à agregação correspondente.
- Linhas externas preservadas.
- Resultado comparado com uma consulta independente.

## VAL-28 — Divisão por zero

Construa um cálculo percentual com denominador que possa ser zero.

Utilize `NULLIF` para evitar erro de divisão.

Critérios:

- Consulta executa sem erro.
- Resultado NULL quando o denominador é zero.
- Interpretação correta do resultado.

---

# 9. Validação de integração

## VAL-29 — Window Function com CTE

Construa uma CTE que calcule um ranking e uma consulta externa que filtre as posições.

Critérios:

- Ranking calculado antes da filtragem externa.
- Resultado equivalente ao critério solicitado.
- Ausência de uso de QUALIFY.

## VAL-30 — Agregação seguida de Window Function

Construa uma consulta que primeiro agregue dados e depois utilize uma função de janela.

Critérios:

- Granularidade da agregação identificada.
- Janela aplicada sobre o resultado agregado.
- Valores finais corretos.

## VAL-31 — JOIN e preservação da granularidade

Escolha duas ou mais tabelas relacionadas da TechStore.

Construa uma consulta analítica que utilize JOIN e Window Functions.

Critérios:

- Identificar cardinalidade dos relacionamentos.
- Evitar multiplicação de valores.
- Justificar a granularidade final.
- Validar a quantidade de linhas.

## VAL-32 — Produtos sem avaliações

Construa um relatório de produtos com indicadores de avaliação.

Critérios:

- Produtos sem avaliações devem permanecer no resultado.
- A quantidade de avaliações deve ser zero quando não houver registros.
- A média não deve ser inventada como se existissem avaliações.
- A estratégia de junção deve preservar todos os produtos.

## VAL-33 — Histórico de preços

Utilize `historico_precos`.

Critérios:

- Ordenação cronológica.
- Particionamento por produto.
- Uso correto de LAG ou LEAD.
- Tratamento do primeiro e último registro.
- Cálculo de variação correto.

## VAL-34 — Relatório analítico integrado

Construa uma consulta que combine:
- Agregação.
- Window Function.
- CTE.
- JOIN.
- Filtro externo.

Critérios:

- Consulta legível.
- Resultado correto.
- Granularidade preservada.
- Ausência de duplicações.
- Explicação da estratégia.

---

# 10. Validação na TechStore

Os testes anteriores verificam o comportamento das funções com dados controlados.

Agora será necessário demonstrar domínio com os dados reais.

## VAL-35 — Ranking por categoria

Utilize `produtos`.

Verifique:

- Quantidade de categorias representadas.
- Quantidade de produtos.
- Ranking por categoria.
- Empates.
- Consistência das posições.

## VAL-36 — Pedidos por cliente

Utilize `pedidos`.

Verifique:

- Quantidade de clientes com pedidos.
- Quantidade total de pedidos considerados.
- Posição cronológica por cliente.
- Reinício da sequência por partição.

## VAL-37 — Avaliações

Utilize `avaliacoes`.

Verifique:

- Quantidade de avaliações.
- Média por produto.
- Ranking de notas.
- Produtos com múltiplas avaliações.
- Tratamento de empates.

## VAL-38 — Estoque

Utilize `produtos` e `estoque`.

Verifique:

- Produtos com registro de estoque.
- Quantidade atual.
- Estoque mínimo.
- Média por categoria.
- Ranking de disponibilidade.

## VAL-39 — Histórico de preços

Utilize `historico_precos`.

Verifique:

- Quantidade de registros.
- Quantidade de produtos com histórico.
- Ordenação cronológica.
- Comparações entre preços consecutivos.
- Primeiro e último registro por produto.

## VAL-40 — Acessos

Utilize `acessos`.

Verifique:

- Quantidade de acessos.
- Particionamento por cliente.
- Registros com `cliente_id` NULL.
- Tratamento dos registros sem cliente identificado.

Não atribua esses acessos a um cliente específico.

---

# 11. Validação de desempenho

## VAL-41 — EXPLAIN

Escolha uma consulta com Window Function e execute `EXPLAIN`.

Critérios:

- Identificar `WindowAgg`.
- Identificar operações de ordenação.
- Interpretar estimativas de linhas.
- Explicar a estrutura do plano.

## VAL-42 — EXPLAIN ANALYZE

Execute `EXPLAIN (ANALYZE, BUFFERS)` sobre a mesma consulta.

Critérios:

- Registrar Planning Time.
- Registrar Execution Time.
- Observar Actual Rows.
- Observar Shared Hit Blocks.
- Observar Shared Read Blocks.
- Identificar operações relevantes.

## VAL-43 — Comparação de ordenações

Compare consultas que utilizem diferentes estratégias de ordenação.

Critérios:

- Identificar ordenações necessárias.
- Observar se existe Sort.
- Identificar possível aproveitamento de ordenação existente.
- Não assumir que a presença de um índice garante sua utilização.

## VAL-44 — Comparação de estratégias

Compare uma consulta baseada em Window Function com outra estratégia que produza o mesmo resultado.

Critérios:

- Equivalência dos resultados.
- Mesma população considerada.
- Mesma granularidade.
- Comparação de planos.
- Comparação de tempos.

## VAL-45 — Validação de otimização

Escolha uma consulta e apresente:

- Resultado original.
- Plano original.
- Hipótese de melhoria.
- Alteração realizada.
- Resultado após a alteração.
- Plano após a alteração.
- Conclusão.

A alteração não poderá modificar os resultados esperados.

---

# 12. Desafios de avaliação independente

Os desafios serão utilizados para verificar se o aluno consegue resolver problemas sem depender da estrutura exata dos exemplos estudados.

## DES-A — Ranking comercial

Desenvolva uma análise de faturamento bruto por produto.

Requisitos:

- Agregação dos itens.
- Ranking global.
- Ranking por categoria.
- Participação percentual.
- Tratamento de empates.
- Validação da granularidade.

## DES-B — Comportamento dos clientes

Desenvolva uma análise de pedidos por cliente.

Requisitos:

- Quantidade de pedidos.
- Primeiro pedido.
- Último pedido.
- Pedido anterior.
- Intervalo entre pedidos.
- Ranking de clientes.

Explique como clientes sem pedidos participariam do relatório, caso sejam incluídos.

## DES-C — Evolução de preços

Desenvolva uma análise completa do histórico de preços.

Requisitos:

- LAG.
- LEAD.
- ROW_NUMBER.
- Variação absoluta.
- Variação percentual.
- Tratamento de NULL.
- Ordenação cronológica.

## DES-D — Estoque e categoria

Desenvolva uma análise de estoque por categoria.

Requisitos:

- Quantidade atual.
- Estoque mínimo.
- Média da categoria.
- Ranking.
- Diferença em relação à média.
- Produtos sem registro de estoque.

## DES-E — Relatório executivo

Desenvolva um relatório analítico que combine produtos, vendas e avaliações.

Requisitos:

- CTEs.
- Agregações.
- Window Functions.
- Rankings.
- Indicadores percentuais.
- Preservação da granularidade.
- Validação independente.

## DES-F — Investigação de desempenho

Selecione uma consulta analítica complexa.

Apresente uma investigação técnica completa, incluindo:

- Baseline.
- Plano de execução.
- Gargalo identificado.
- Hipótese.
- Alteração.
- Validação dos resultados.
- Comparação de desempenho.
- Conclusão.

---

# 13. Erros críticos

Os seguintes erros impedem a aprovação até que sejam corrigidos:

| Erro | Consequência |
|---|---|
| PARTITION BY incorreto | Mistura de grupos |
| ORDER BY inadequado | Sequência incorreta |
| Frame incorreto | Resultado matemático errado |
| Confusão entre ROWS e RANGE | Acumulados incorretos |
| LAST_VALUE mal configurado | Último valor incorreto |
| LAG/LEAD com ordenação errada | Comparação incorreta |
| Multiplicação de registros | Indicadores inflados |
| Tratamento incorreto de NULL | Resultados inválidos |
| Ranking sem regra de desempate quando necessário | Resultado não determinístico |
| Filtragem antes do cálculo sem justificativa | Perda de registros necessários |
| Otimização que altera os resultados | Consulta incorreta |

---

# 14. Critérios de avaliação

A avaliação segue o padrão geral do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: **85%**.

### 14.1 Correção lógica — 35%

Avalia:
- Resultado correto.
- Particionamento.
- Ordenação.
- Frames.
- Rankings.
- Funções de navegação.
- Granularidade.

### 14.2 Sintaxe e domínio — 20%

Avalia:
- Uso de OVER.
- PARTITION BY.
- ORDER BY.
- ROWS, RANGE e GROUPS.
- Funções analíticas.
- Integração com CTEs.

### 14.3 Casos extremos — 15%

Avalia:
- Empates.
- NULL.
- Partições pequenas.
- Partições vazias.
- Uma linha por partição.
- Divisão por zero.
- Frames incompletos.

### 14.4 Desempenho — 20%

Avalia:
- EXPLAIN.
- EXPLAIN ANALYZE.
- WindowAgg.
- Sort.
- Buffers.
- Comparação de estratégias.
- Otimização com preservação dos resultados.

### 14.5 Legibilidade — 10%

Avalia:
- Aliases.
- CTEs.
- Organização.
- Clareza.
- Boas práticas.

---

# 15. Critérios para liberação do Módulo 10

O aluno deverá demonstrar domínio dos seguintes assuntos:

- Diferença entre agregação e função de janela.
- Particionamento.
- Ordenação.
- Rankings.
- Frames.
- LAG e LEAD.
- FIRST_VALUE, LAST_VALUE e NTH_VALUE.
- Agregações analíticas.
- Análises temporais.
- Integração com CTEs.
- Preservação da granularidade.
- Interpretação de planos.

A nota mínima de referência será 85%, sem erros críticos pendentes.

Caso o desempenho seja insuficiente, o reforço será direcionado aos assuntos que apresentarem falhas.

Não será necessário repetir automaticamente todas as atividades.

Após a aprovação, será liberado:

**Módulo 10 — DML e Transações.**

---

# 16. Registro de validação

| Etapa | Status | Nota/Observações |
|---|---|---|
| VAL-01 a VAL-03 | Pendente | Estrutura |
| VAL-04 a VAL-08 | Pendente | Rankings |
| VAL-09 a VAL-15 | Pendente | Frames |
| VAL-16 a VAL-19 | Pendente | Navegação |
| VAL-20 a VAL-22 | Pendente | Funções de valor |
| VAL-23 a VAL-28 | Pendente | Agregações |
| VAL-29 a VAL-34 | Pendente | Integração |
| VAL-35 a VAL-40 | Pendente | TechStore |
| VAL-41 a VAL-45 | Pendente | Desempenho |
| DES-A a DES-F | Pendente | Desafios |
| Avaliação final | Pendente | Nota |
| Liberação do Módulo 10 | Pendente | Aprovação |

---

# 17. Segurança e preservação

A validação deverá ser realizada exclusivamente com consultas de leitura.

Não executar:

- INSERT.
- UPDATE.
- DELETE.
- TRUNCATE.
- DROP.
- ALTER.
- CREATE INDEX.
- CREATE TABLE.

Não executar novamente a seed.

O ambiente TechStore deverá permanecer preservado durante todo o processo.

**Objetivo final:** demonstrar que o aluno consegue construir, validar, explicar e analisar consultas com Window Functions em situações reais, sem depender de exemplos prontos.