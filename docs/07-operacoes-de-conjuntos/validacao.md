# Validação — Módulo 07: Operações de Conjuntos

## 1. Objetivo

Este documento estabelece os critérios para verificar se o aluno compreendeu e consegue aplicar operações de conjuntos no PostgreSQL.

A validação verifica não apenas se a consulta executa, mas também se o resultado representa corretamente o conjunto solicitado, respeitando duplicidades, multiplicidades, valores `NULL`, compatibilidade de tipos e ordem das operações.

**A validação deve ser realizada após o estudo da teoria e a conclusão das atividades.**

---

## 2. Conteúdos avaliados

Ao final da validação, o aluno deverá demonstrar domínio dos seguintes tópicos:

1. Fundamentos das operações de conjuntos.
2. Compatibilidade entre as consultas participantes.
3. Correspondência posicional das colunas.
4. `UNION`.
5. `UNION ALL`.
6. `INTERSECT`.
7. `INTERSECT ALL`.
8. `EXCEPT`.
9. `EXCEPT ALL`.
10. Diferenças entre conjunto e multiconjunto.
11. Tratamento de valores `NULL`.
12. Encadeamento de operações.
13. Precedência e utilização de parênteses.
14. `ORDER BY` e `LIMIT` em operações de conjuntos.
15. Operações de conjuntos com filtros e agregações.
16. Utilização de operações de conjuntos em CTEs e subconsultas.
17. Comparação com `JOIN`, `EXISTS` e `NOT EXISTS`.
18. Análise de desempenho com `EXPLAIN`.

---

## 3. Regras para execução

- Utilizar PostgreSQL 16.
- Utilizar o banco TechStore existente.
- Executar as consultas preferencialmente em modo somente leitura.
- Não modificar tabelas, registros, índices ou estruturas do banco.
- Não executar novamente os arquivos de seed.
- Não utilizar comandos destrutivos.
- Os testes independentes devem utilizar conjuntos temporários definidos por `VALUES` ou subconsultas, sem necessidade de alterar o banco.

A validação deve ser feita com atenção à semântica dos resultados. Uma consulta que executa sem erro não está necessariamente correta.

---

## 4. Testes de validação

### VAL-01 — Compatibilidade estrutural

Demonstrar que consegue identificar se duas ou mais consultas são compatíveis para uma operação de conjuntos.

Verificar:

- Quantidade de colunas.
- Tipos de dados compatíveis.
- Correspondência posicional.
- Diferenças entre nomes e posições das colunas.
- Comportamento dos aliases no resultado final.

**Critério de aprovação:** identificar corretamente consultas compatíveis e incompatíveis, explicando o motivo.

### VAL-02 — UNION

Demonstrar domínio do `UNION`.

Verificar:

- Combinação de resultados.
- Remoção de duplicidades.
- Diferença entre duplicidade de uma linha completa e repetição de apenas uma coluna.
- Comportamento com múltiplas consultas.

**Critério de aprovação:** produzir resultados sem duplicidades indevidas e explicar quais linhas são consideradas iguais.

### VAL-03 — UNION ALL

Demonstrar domínio do `UNION ALL`.

Verificar:

- Preservação de duplicidades.
- Diferença de comportamento em relação ao `UNION`.
- Impacto da preservação de linhas repetidas.
- Situações em que `UNION ALL` é semanticamente necessário.

**Critério de aprovação:** preservar corretamente todas as ocorrências esperadas.

### VAL-04 — INTERSECT

Demonstrar domínio do `INTERSECT`.

Verificar:

- Identificação de linhas presentes nos dois resultados.
- Remoção de duplicidades.
- Compatibilidade entre consultas.
- Diferença entre interseção e junção.

**Critério de aprovação:** retornar somente as linhas pertencentes aos dois conjuntos.

### VAL-05 — INTERSECT ALL

Demonstrar domínio do `INTERSECT ALL`.

Verificar:

- Preservação das multiplicidades comuns.
- Comportamento quando uma linha aparece quantidades diferentes em cada entrada.
- Diferença em relação ao `INTERSECT`.

**Critério de aprovação:** compreender que a quantidade de ocorrências no resultado corresponde à menor multiplicidade encontrada entre as entradas.

### VAL-06 — EXCEPT

Demonstrar domínio do `EXCEPT`.

Verificar:

- Identificação de linhas presentes na primeira consulta e ausentes na segunda.
- Direcionalidade da operação.
- Remoção de duplicidades.
- Diferença entre `EXCEPT` e `NOT EXISTS`.

**Critério de aprovação:** retornar corretamente as linhas exclusivas do primeiro resultado.

### VAL-07 — EXCEPT ALL

Demonstrar domínio do `EXCEPT ALL`.

Verificar:

- Subtração de multiplicidades.
- Diferença entre `EXCEPT` e `EXCEPT ALL`.
- Comportamento quando a segunda entrada contém mais ocorrências que a primeira.

**Critério de aprovação:** compreender que as ocorrências restantes correspondem à diferença positiva entre as multiplicidades das duas entradas.

### VAL-08 — Valores NULL

Demonstrar compreensão do comportamento de `NULL` nas operações de conjuntos.

Verificar:

- Comparação de linhas com valores `NULL`.
- Deduplicação de linhas com `NULL`.
- Correspondência de linhas contendo `NULL` em operações de interseção.
- Diferenças entre operações de conjuntos e comparações convencionais com `=`.

**Critério de aprovação:** explicar corretamente o tratamento de `NULL` nas operações e não aplicar incorretamente a lógica de igualdade convencional do SQL.

### VAL-09 — Encadeamento e precedência

Demonstrar domínio de operações encadeadas.

Verificar:

- Encadeamento de três ou mais consultas.
- Precedência de `INTERSECT`.
- Avaliação da sequência de `UNION` e `EXCEPT`.
- Uso de parênteses para alterar ou tornar explícita a ordem de avaliação.

**Critério de aprovação:** prever e produzir o resultado correto de expressões com múltiplas operações.

### VAL-10 — Ordenação e limitação

Demonstrar domínio de `ORDER BY` e `LIMIT` em operações de conjuntos.

Verificar:

- Ordenação do resultado final.
- Aplicação de limites ao resultado combinado.
- Diferença entre limitar uma consulta individual e limitar o resultado da operação.
- Uso de subconsultas ou parênteses quando necessário.

**Critério de aprovação:** aplicar ordenação e limitação no nível correto, sem alterar involuntariamente a semântica da consulta.

### VAL-11 — Operações com filtros e agregações

Demonstrar domínio da combinação de operações de conjuntos com outras construções SQL.

Verificar:

- Utilização de `WHERE` nas consultas participantes.
- Operações com resultados agregados.
- Compatibilidade entre colunas agregadas.
- Identificação de resultados com granularidades diferentes.
- Utilização de rótulos para identificar a origem dos resultados.

**Critério de aprovação:** construir operações coerentes, respeitando a estrutura e o significado dos dados.

### VAL-12 — Operações com CTEs e subconsultas

Demonstrar capacidade de incorporar operações de conjuntos em consultas maiores.

Verificar:

- Uso de `UNION` dentro de uma CTE.
- Uso de operações de conjuntos em subconsultas.
- Encadeamento com outras CTEs.
- Organização e legibilidade da consulta.
- Correção da estrutura final.

**Critério de aprovação:** construir consultas compostas sem perder a semântica das operações.

### VAL-13 — Comparação com JOIN e EXISTS

Demonstrar que compreende quando operações de conjuntos são adequadas em comparação com outras construções SQL.

Verificar:

- `INTERSECT` versus `INNER JOIN`.
- `EXCEPT` versus `NOT EXISTS`.
- `UNION` versus `JOIN`.
- `INTERSECT` versus `EXISTS`.
- Diferenças de multiplicidade e cardinalidade.
- Necessidade de `DISTINCT` em determinadas comparações.

**Critério de aprovação:** explicar quando os resultados são equivalentes e quando podem divergir.

A comparação deve considerar a granularidade dos resultados. Um `JOIN` pode multiplicar linhas, enquanto uma operação de conjuntos pode eliminar duplicidades.

**Atenção:** IDs de tabelas diferentes não representam necessariamente a mesma entidade. Por exemplo, um ID de cliente igual a um ID de funcionário não significa que sejam a mesma pessoa. Quando combinar entidades diferentes, identifique a origem da linha por meio de uma coluna adicional.

---

## 5. Testes independentes

Os testes abaixo devem ser realizados independentemente das atividades. Eles verificam se o aluno compreendeu o comportamento dos operadores e não apenas memorizou consultas.

Utilize conjuntos pequenos definidos com `VALUES`, CTEs ou subconsultas.

### T-01 — Duplicidades

Criar dois resultados pequenos com linhas repetidas.

Verificar a diferença entre:

- `UNION`
- `UNION ALL`

**Resultado esperado:** explicar a quantidade de linhas produzida por cada operador.

### T-02 — Interseção

Criar dois conjuntos com:

- Valores exclusivos do primeiro.
- Valores exclusivos do segundo.
- Valores compartilhados.
- Valores repetidos.

Verificar `INTERSECT` e `INTERSECT ALL`.

**Resultado esperado:** identificar corretamente as linhas comuns e suas multiplicidades.

### T-03 — Diferença

Criar dois conjuntos com valores em comum e valores exclusivos.

Verificar `EXCEPT` e `EXCEPT ALL`.

**Resultado esperado:** identificar as linhas removidas e as ocorrências restantes.

### T-04 — Multiplicidades diferentes

Criar duas entradas nas quais determinado valor aparece quantidades diferentes.

Exemplo conceitual:

- Primeiro conjunto: três ocorrências do mesmo valor.
- Segundo conjunto: uma ocorrência desse valor.

Verificar o comportamento de `INTERSECT ALL` e `EXCEPT ALL`.

**Resultado esperado:** demonstrar domínio da lógica de multiplicidades.

### T-05 — Valores NULL

Criar entradas contendo valores `NULL`, incluindo linhas que diferem apenas pela presença ou ausência de `NULL`.

Verificar todos os operadores aplicáveis.

**Resultado esperado:** explicar como o PostgreSQL trata essas linhas nas operações de conjuntos.

### T-06 — Conjuntos vazios

Criar uma ou mais entradas sem registros.

Verificar:

- `UNION`.
- `INTERSECT`.
- `EXCEPT`.
- Operações encadeadas.

**Resultado esperado:** prever corretamente os resultados sem depender de registros existentes na TechStore.

### T-07 — Compatibilidade de tipos

Criar consultas com tipos iguais e tipos diferentes, incluindo casos em que o PostgreSQL consegue encontrar um tipo comum e casos incompatíveis.

**Resultado esperado:** identificar quando a operação é válida e compreender a necessidade de conversão explícita quando aplicável.

### T-08 — Correspondência posicional

Criar duas consultas com colunas de nomes diferentes, mas posições compatíveis.

Depois, inverter a ordem das colunas.

**Resultado esperado:** explicar por que a correspondência é posicional e como a inversão pode alterar o significado do resultado.

### T-09 — Precedência

Criar uma expressão com `UNION`, `INTERSECT` e `EXCEPT`.

Comparar o resultado padrão com uma versão que utiliza parênteses.

**Resultado esperado:** explicar a ordem de avaliação e a influência dos parênteses.

### T-10 — Ordenação e LIMIT

Criar uma operação de conjuntos e aplicar ordenação e limitação.

Comparar com uma versão em que uma das consultas internas possui limite próprio.

**Resultado esperado:** identificar a diferença entre limitar uma entrada e limitar o resultado final.

### T-11 — Granularidade

Utilizar dados da TechStore para combinar resultados de clientes, pedidos ou produtos.

Verificar se a granularidade é compatível e se a operação preserva o significado esperado.

**Resultado esperado:** não confundir uma linha por entidade com uma linha por ocorrência ou evento.

### T-12 — Comparação com JOIN

Criar uma consulta equivalente, quando possível, utilizando `INTERSECT` e `INNER JOIN`.

Verificar o comportamento com dados repetidos.

**Resultado esperado:** explicar quando é necessário utilizar `DISTINCT` para obter resultados equivalentes.

### T-13 — Comparação com EXISTS

Comparar uma operação `INTERSECT` com uma consulta baseada em `EXISTS`.

**Resultado esperado:** identificar diferenças de duplicidade, cardinalidade e semântica.

### T-14 — Operações com CTE

Criar uma CTE que contenha uma operação de conjuntos e utilizá-la em uma consulta externa.

**Resultado esperado:** preservar a semântica do conjunto e organizar corretamente a consulta.

### T-15 — Plano de execução

Selecionar uma consulta com operação de conjuntos sobre dados da TechStore.

Analisar seu plano utilizando `EXPLAIN`.

Verificar:

- Nós de execução.
- Estimativa de linhas.
- Operações de ordenação.
- Operações de deduplicação.
- Uso de estruturas de hash.
- Custo estimado.

Quando apropriado, comparar com uma consulta equivalente usando `EXPLAIN (ANALYZE, BUFFERS)`.

**Resultado esperado:** identificar os principais componentes do plano e explicar o custo da operação.

`EXPLAIN ANALYZE` executa a consulta. Utilize apenas consultas de leitura, individualmente, e evite executar várias análises pesadas simultaneamente.

---

## 6. Desafios de validação

Os desafios devem ser realizados sem copiar soluções prontas.

### DES-01 — Consolidação de pessoas

Construir um relatório unificado de clientes e funcionários.

Requisitos:

- Identificar o tipo de entidade.
- Apresentar campos compatíveis.
- Preservar a origem de cada registro.
- Ordenar o resultado.
- Evitar confusão entre IDs de tabelas diferentes.

**Avaliação:** compatibilidade, semântica, organização e correção.

### DES-02 — Relacionamento comercial

Construir uma análise de clientes que aparecem em diferentes conjuntos de atividade comercial.

Considerar pedidos e acessos.

Requisitos:

- Identificar clientes presentes nos dois conjuntos.
- Identificar clientes exclusivos de cada conjunto.
- Tratar valores `NULL` adequadamente.
- Evitar duplicidades indevidas.

**Avaliação:** domínio de `INTERSECT`, `EXCEPT` e granularidade.

### DES-03 — Auditoria de produtos

Construir uma análise que classifique produtos conforme sua presença nos conjuntos de produtos vendidos e avaliados.

Requisitos:

- Produtos vendidos.
- Produtos avaliados.
- Produtos presentes nos dois conjuntos.
- Produtos vendidos sem avaliações.
- Produtos avaliados sem vendas.
- Produtos sem vendas e sem avaliações.

**Avaliação:** operações corretas, interpretação dos resultados e consistência lógica.

### DES-04 — Atividade de funcionários

Construir uma análise da presença de funcionários em movimentações de estoque e logs do sistema.

Requisitos:

- Funcionários presentes nos dois conjuntos.
- Funcionários presentes somente em movimentações.
- Funcionários presentes somente em logs.
- Funcionários ausentes dos dois conjuntos.
- Tratamento correto de referências `NULL`.

**Avaliação:** domínio das diferenças e interseções entre conjuntos.

### DES-05 — Consolidação de indicadores

Construir um relatório unificado com indicadores de diferentes áreas da TechStore.

Requisitos:

- Combinar resultados de origens distintas.
- Identificar a origem de cada indicador.
- Padronizar as colunas.
- Preservar métricas e granularidades.
- Ordenar o resultado final.

**Avaliação:** compatibilidade, organização e interpretação correta dos dados.

### DES-06 — Investigação e otimização

Selecionar uma consulta que utilize operações de conjuntos e investigar seu desempenho.

Requisitos:

1. Apresentar a consulta original.
2. Registrar o plano de execução.
3. Identificar o principal custo.
4. Formular uma hipótese de melhoria.
5. Aplicar uma alteração por vez.
6. Comparar os resultados.
7. Confirmar que a alteração não modificou a semântica.

**Avaliação:** capacidade de análise, justificativa técnica e preservação da correção.

---

## 7. Critérios de avaliação

A nota será calculada considerando cinco dimensões.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### Interpretação dos critérios

**Correção lógica e resultados — 35%**

- Operadores adequados.
- Resultados corretos.
- Semântica preservada.
- Multiplicidades compreendidas.

**Sintaxe e domínio SQL — 20%**

- Sintaxe PostgreSQL correta.
- Compatibilidade estrutural.
- Uso adequado dos operadores.
- Encadeamento correto.

**Casos extremos e validação — 15%**

- Tratamento de `NULL`.
- Conjuntos vazios.
- Duplicidades.
- Tipos incompatíveis.
- Limites e precedência.

**Desempenho e otimização — 20%**

- Leitura do plano.
- Identificação dos nós de execução.
- Comparação de alternativas.
- Justificativa de melhorias.

**Legibilidade e boas práticas — 10%**

- Aliases claros.
- Identificação da origem dos dados.
- Organização das consultas.
- Ausência de complexidade desnecessária.

---

## 8. Regras de aprovação

A nota mínima de referência é **85%**.

Além da pontuação, não podem existir erros críticos de:

- Interpretação dos resultados.
- Uso de operadores incompatíveis com o objetivo.
- Tratamento incorreto de multiplicidades.
- Confusão de entidades com IDs de tabelas diferentes.
- Perda de registros por tratamento incorreto de `NULL`.
- Alteração indevida da semântica durante uma otimização.

Uma consulta que executa corretamente, mas retorna um conjunto semanticamente incorreto, não será considerada aprovada.

### Situações de reprovação

- Não compreender a diferença entre `UNION` e `UNION ALL`.
- Não compreender a diferença entre `INTERSECT` e `INTERSECT ALL`.
- Não compreender a diferença entre `EXCEPT` e `EXCEPT ALL`.
- Não conseguir identificar incompatibilidades estruturais.
- Não compreender a precedência das operações.
- Não conseguir explicar resultados com duplicidades ou `NULL`.
- Não validar a correção das consultas.

---

## 9. Reforço direcionado

Caso o resultado fique abaixo de 85%, o aluno não precisará repetir todo o módulo.

O reforço será direcionado aos conteúdos que apresentarem dificuldades.

| Dificuldade identificada | Reforço |
|---|---|
| Compatibilidade estrutural | Regras de composição e tipos |
| UNION e UNION ALL | Deduplicação e multiplicidade |
| INTERSECT | Interseção de conjuntos |
| EXCEPT | Diferença e direcionalidade |
| Operadores ALL | Multiconjuntos e contagem de ocorrências |
| NULL | Semântica de valores desconhecidos |
| Precedência | Encadeamento e parênteses |
| JOIN versus operações de conjuntos | Cardinalidade e granularidade |
| CTE e subconsultas | Composição de consultas |
| Desempenho | Plano de execução e custos |

Após o reforço, serão aplicados novos testes sobre os conteúdos não dominados.

---

## 10. Registro de progresso

Preencher após a conclusão da validação.

| Etapa | Status |
|---|---|
| Teoria estudada | Pendente |
| Atividades concluídas | Pendente |
| VAL-01 a VAL-13 | Pendente |
| T-01 a T-15 | Pendente |
| DES-01 a DES-06 | Pendente |
| Avaliação final | Pendente |
| Nota obtida | — |
| Reforço necessário | — |
| Módulo aprovado | Não |

### Anotações

Registrar:

- Dificuldades encontradas.
- Conceitos que precisaram de reforço.
- Erros identificados.
- Melhorias realizadas.
- Desempenho das consultas relevantes.
- Observações para os próximos módulos.

---

## 11. Liberação do próximo módulo

O Módulo 08 — CTEs será liberado quando:

1. A teoria tiver sido estudada.
2. As atividades tiverem sido concluídas.
3. Os testes de validação demonstrarem domínio.
4. Os desafios tiverem sido realizados.
5. A nota mínima de 85% tiver sido atingida.
6. Não houver erros críticos pendentes.

A aprovação representa domínio prático das operações de conjuntos no PostgreSQL, incluindo sua aplicação em consultas compostas e sua relação com outras construções SQL.

---

## 12. Próximo módulo

**Módulo 08 — CTEs (Common Table Expressions)**

O próximo módulo aprofundará a organização de consultas com `WITH`, CTEs encadeadas, recursividade, materialização e comparação de estratégias de execução.

**Status:** aguardando conclusão do Módulo 07.