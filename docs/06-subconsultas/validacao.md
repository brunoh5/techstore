# Validação — Módulo 06: Subconsultas

## 1. Objetivo da validação

Esta etapa verifica se o aluno consegue construir, interpretar, comparar e otimizar consultas SQL que utilizam subconsultas no PostgreSQL.

Não basta produzir uma consulta que aparentemente funciona. É necessário demonstrar que ela:

- Retorna os registros corretos.
- Respeita a granularidade solicitada.
- Trata corretamente valores `NULL`.
- Funciona com resultados vazios, únicos ou com múltiplas linhas.
- Não produz duplicações indevidas.
- Apresenta comportamento consistente em diferentes cenários.
- Possui desempenho adequado para o volume de dados da TechStore.

A validação deve ser realizada depois do estudo da teoria e da conclusão das atividades.

---

## 2. Regras gerais

Durante a validação:

1. Utilizar exclusivamente consultas de leitura (`SELECT`).
2. Não executar `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `DROP` ou `ALTER`.
3. Não executar novamente os arquivos de seed.
4. Não modificar tabelas, índices, constraints ou configurações do banco.
5. Preservar integralmente os dados da TechStore.
6. Executar as consultas individualmente quando houver risco de consumo elevado de recursos.
7. Registrar os resultados e explicar o raciocínio utilizado.

O aluno poderá consultar a documentação oficial do PostgreSQL, mas deverá ser capaz de explicar suas próprias consultas.

---

## 3. Validações técnicas

### VAL-01 — Identificação de subconsultas

Verificar se o aluno consegue:

- Identificar uma subconsulta dentro de uma consulta principal.
- Diferenciar consulta principal e subconsulta.
- Explicar a relação entre as duas.
- Identificar quando uma subconsulta é correlacionada.
- Identificar quando uma subconsulta é independente da consulta externa.

**Critério de aprovação:** explicar corretamente a estrutura e o papel de cada nível da consulta.

### VAL-02 — Subconsultas escalares

Verificar se o aluno compreende que uma subconsulta escalar deve produzir um único valor.

Testar conceitualmente os seguintes cenários:

- Subconsulta retornando exatamente uma linha e uma coluna.
- Subconsulta retornando zero linhas.
- Subconsulta retornando mais de uma linha.
- Subconsulta retornando um valor `NULL`.

**Critério de aprovação:** reconhecer os resultados possíveis e explicar o comportamento do PostgreSQL em cada situação.

### VAL-03 — Subconsultas com múltiplas linhas

Verificar se o aluno consegue utilizar subconsultas que retornam conjuntos de valores.

Avaliar:

- Compatibilidade entre o operador utilizado e o resultado da subconsulta.
- Diferença entre uma subconsulta escalar e uma subconsulta de múltiplas linhas.
- Utilização de `IN`.
- Utilização de `ANY` e `ALL`.

**Critério de aprovação:** selecionar corretamente o operador de acordo com o resultado esperado.

### VAL-04 — Operador IN

Verificar se o aluno consegue:

- Utilizar `IN` com uma lista de valores.
- Utilizar `IN` com uma subconsulta.
- Interpretar o resultado quando existe correspondência.
- Interpretar o resultado quando não existe correspondência.
- Diferenciar `IN` de uma comparação escalar.

**Critério de aprovação:** produzir resultados corretos e explicar como o conjunto retornado pela subconsulta influencia a consulta principal.

### VAL-05 — NOT IN e valores NULL

Esta é uma validação obrigatória.

Verificar se o aluno compreende o comportamento da lógica de três valores do SQL.

Avaliar:

- `NOT IN` quando a subconsulta não contém `NULL`.
- `NOT IN` quando a subconsulta contém `NULL`.
- Comparações envolvendo valores `NULL`.
- Diferença entre ausência de correspondência e resultado desconhecido.
- Alternativas com `NOT EXISTS`.

**Critério de aprovação:** explicar por que `NOT IN` pode produzir resultados inesperados quando o conjunto comparado contém `NULL`.

**Erro crítico:** utilizar `NOT IN` sem considerar a possibilidade de `NULL` em uma situação na qual isso altera o resultado esperado.

### VAL-06 — EXISTS e NOT EXISTS

Verificar se o aluno consegue:

- Utilizar `EXISTS` para verificar a existência de registros.
- Utilizar `NOT EXISTS` para identificar ausência de correspondência.
- Construir subconsultas correlacionadas.
- Diferenciar a verificação de existência da recuperação de valores.
- Identificar situações em que `EXISTS` é mais apropriado que `IN`.

**Critério de aprovação:** construir consultas com semântica correta e explicar a condição de existência utilizada.

### VAL-07 — ANY e ALL

Verificar se o aluno compreende a comparação de um valor com os resultados de uma subconsulta.

Avaliar:

- `= ANY`.
- `> ANY`.
- `< ANY`.
- `> ALL`.
- `< ALL`.
- Conjuntos vazios.
- Conjuntos com valores `NULL`.
- Diferença entre `ANY` e `ALL`.

**Critério de aprovação:** explicar corretamente a lógica de comparação e os resultados possíveis.

### VAL-08 — Subconsultas correlacionadas

Verificar se o aluno consegue construir subconsultas que dependem de valores da consulta externa.

Avaliar:

- Referência a colunas da consulta principal.
- Comparações por grupo ou entidade.
- Uso de agregações dentro da subconsulta.
- Comparação individual com uma média, máximo ou mínimo relacionado.
- Diferença entre uma subconsulta correlacionada e uma independente.

**Critério de aprovação:** construir uma consulta cuja subconsulta utilize corretamente os valores da linha externa.

### VAL-09 — Subconsultas no SELECT e no FROM

Verificar se o aluno compreende os diferentes locais em que uma subconsulta pode ser utilizada.

Avaliar:

- Subconsulta escalar no `SELECT`.
- Subconsulta derivada no `FROM`.
- Alias obrigatório para a tabela derivada.
- Compatibilidade entre as colunas retornadas e a consulta principal.
- Diferença entre retornar um valor e retornar um conjunto de registros.

**Critério de aprovação:** utilizar corretamente os dois formatos e explicar suas diferenças.

### VAL-10 — Subconsultas aninhadas

Verificar se o aluno consegue interpretar consultas com mais de um nível de subconsulta.

Avaliar:

- Dependência entre níveis.
- Escopo dos aliases.
- Referências às consultas externas.
- Legibilidade.
- Possibilidade de simplificação.

**Critério de aprovação:** explicar a ordem lógica e a finalidade dos níveis da consulta, sem confundir suas responsabilidades.

### VAL-11 — Subconsultas com agregações

Verificar se o aluno consegue combinar subconsultas com:

- `COUNT`.
- `SUM`.
- `AVG`.
- `MIN`.
- `MAX`.
- `GROUP BY`.
- `HAVING`.

Avaliar também se compreende a diferença entre uma agregação global e uma agregação por grupo.

**Critério de aprovação:** produzir resultados corretos, respeitando a população considerada no cálculo.

**Atenção:** médias e indicadores devem ter seu universo estatístico definido. Por exemplo, uma média por cliente pode ou não considerar clientes sem pedidos, dependendo da definição do problema.

### VAL-12 — Comparação entre JOIN, CTE e subconsulta

Verificar se o aluno consegue resolver um mesmo problema utilizando abordagens diferentes quando elas forem semanticamente equivalentes.

Avaliar:

- JOIN versus IN.
- JOIN versus EXISTS.
- LEFT JOIN versus NOT EXISTS.
- CTE versus subconsulta.
- Subconsulta no FROM versus tabela derivada.
- Diferenças de cardinalidade.
- Possibilidade de duplicação de registros.

**Critério de aprovação:** escolher uma abordagem adequada e justificar a escolha sem assumir que uma construção é sempre mais rápida que outra.

### VAL-13 — Desempenho e planos de execução

Verificar se o aluno consegue analisar consultas que utilizam subconsultas.

Avaliar:

- `EXPLAIN`.
- `EXPLAIN ANALYZE`.
- `EXPLAIN (ANALYZE, BUFFERS)`.
- `InitPlan`.
- `SubPlan`.
- Nested Loop.
- Hash Join.
- Quantidade estimada e real de linhas.
- Leituras e acessos ao cache.
- Diferenças entre planejamento e execução.

**Critério de aprovação:** interpretar o plano, identificar possíveis gargalos e justificar uma hipótese de melhoria.

Não será considerada correta uma otimização que altere o resultado esperado.

---

## 4. Testes independentes de comportamento

Além dos exercícios, o aluno deverá demonstrar que suas consultas funcionam em cenários que não dependem apenas dos dados atualmente existentes na TechStore.

Os testes poderão ser realizados por meio de raciocínio, consultas auxiliares de leitura ou pequenos conjuntos de dados temporários em um ambiente isolado.

Não criar ou alterar objetos no banco principal para realizar estes testes.

| ID | Cenário | Comportamento esperado |
|---|---|---|
| T-01 | Subconsulta escalar retorna um valor | A consulta principal utiliza o valor normalmente. |
| T-02 | Subconsulta escalar retorna zero linhas | O resultado escalar é tratado como `NULL`. |
| T-03 | Subconsulta escalar retorna múltiplas linhas | O PostgreSQL sinaliza erro de cardinalidade. |
| T-04 | Subconsulta de múltiplas linhas retorna valores | O operador compatível avalia o conjunto corretamente. |
| T-05 | Subconsulta utilizada com `IN` retorna conjunto vazio | Nenhum valor encontra correspondência. |
| T-06 | Subconsulta utilizada com `NOT IN` contém `NULL` | O aluno identifica o efeito da lógica de três valores. |
| T-07 | Subconsulta utilizada com `EXISTS` retorna linhas | A condição de existência é verdadeira. |
| T-08 | Subconsulta utilizada com `EXISTS` não retorna linhas | A condição de existência é falsa. |
| T-09 | Subconsulta utilizada com `ANY` recebe conjunto vazio | A comparação resulta em falso. |
| T-10 | Subconsulta utilizada com `ALL` recebe conjunto vazio | A comparação resulta em verdadeiro. |
| T-11 | Subconsulta correlacionada utiliza uma linha externa | O resultado considera os valores daquela linha. |
| T-12 | Subconsulta correlacionada utiliza várias linhas externas | Cada linha é avaliada de acordo com sua correlação. |
| T-13 | Subconsulta derivada retorna várias linhas | A consulta principal consegue utilizar o conjunto retornado. |
| T-14 | Subconsulta utiliza agregação sem registros correspondentes | O aluno identifica o resultado da agregação e seu tratamento. |
| T-15 | Consulta produz duplicações por cardinalidade | O aluno identifica a origem e corrige a granularidade. |

**Importante:** nos testes T-09 e T-10, os resultados descritos consideram um conjunto realmente vazio. Um conjunto que contém `NULL` possui comportamento diferente e também deve ser compreendido.

---

## 5. Validação dos exercícios

Os exercícios do arquivo `atividades.md` serão avaliados considerando:

- Correção da consulta.
- Correspondência com o enunciado.
- Uso adequado da subconsulta.
- Tratamento de valores `NULL`.
- Granularidade.
- Ausência de duplicações indevidas.
- Legibilidade.
- Justificativa técnica.

O aluno deverá conseguir explicar:

1. Qual é a consulta principal?
2. Qual é a subconsulta?
3. O que a subconsulta retorna?
4. Qual é o operador que relaciona as duas?
5. Existe dependência da consulta externa?
6. O que acontece se a subconsulta retornar zero linhas?
7. O que acontece se retornar várias linhas?
8. Existe possibilidade de `NULL`?
9. O resultado respeita a granularidade solicitada?
10. Existe uma abordagem alternativa?

Não será suficiente apresentar apenas o resultado final.

---

## 6. Validação dos desafios

Os desafios DES-01 a DES-06 do arquivo `atividades.md` deverão demonstrar capacidade de resolver problemas mais completos.

A avaliação deverá considerar:

- Construção de consultas com múltiplas subconsultas.
- Uso adequado de correlações.
- Combinação com agregações.
- Comparação com JOINs e CTEs.
- Tratamento de situações excepcionais.
- Justificativa das decisões.
- Análise de desempenho.

Os desafios devem ser resolvidos individualmente, sem copiar consultas prontas.

O aluno deverá explicar o raciocínio e defender a escolha da abordagem.

---

## 7. Critérios de avaliação

A pontuação seguirá o padrão oficial do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio de SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### Nota mínima

**85 pontos de 100.**

A nota mínima não elimina a necessidade de demonstrar domínio dos fundamentos.

### Erros críticos

Os seguintes erros exigem correção antes da aprovação:

- Subconsulta escalar que pode retornar múltiplas linhas sem tratamento.
- Uso incorreto de `NOT IN` diante de valores `NULL`.
- Resultado logicamente diferente do solicitado.
- Comparação incorreta entre conjuntos.
- Duplicações causadas por cardinalidade não controlada.
- Erros de correlação ou escopo de aliases.
- Alteração indevida dos dados do banco principal.

Um erro crítico impede a liberação do módulo, mesmo que a pontuação numérica seja suficiente.

---

## 8. Processo de correção e recuperação

Quando uma validação não for aprovada, o processo será:

1. Identificar o conceito que apresentou dificuldade.
2. Explicar o motivo técnico do erro.
3. Revisar o trecho específico da teoria.
4. Propor um exercício direcionado.
5. Executar uma nova validação daquele conceito.
6. Reavaliar a consulta original.
7. Registrar o resultado.

Não será necessário repetir todo o módulo quando a dificuldade estiver concentrada em um assunto específico.

Se o problema demonstrar uma lacuna mais ampla, poderá ser solicitado um novo conjunto de exercícios.

---

## 9. Registro de progresso

Preencher após a conclusão da validação.

| Item | Resultado |
|---|---|
| Teoria concluída | Pendente |
| Atividades concluídas | Pendente |
| VAL-01 a VAL-13 | Pendente |
| Testes independentes T-01 a T-15 | Pendente |
| Desafios DES-01 a DES-06 | Pendente |
| Análise de desempenho | Pendente |
| Nota final | Não avaliado |
| Erros críticos | Não avaliado |
| Situação | Não iniciado |

### Situações possíveis

- **Não iniciado:** validação ainda não realizada.
- **Em andamento:** validações em execução.
- **Revisão necessária:** existem lacunas que precisam ser corrigidas.
- **Aprovado:** nota mínima atingida e nenhum erro crítico pendente.
- **Concluído:** aprovação registrada e módulo liberado.

---

## 10. Condições para liberação do Módulo 07

O Módulo 07 — Operações de Conjuntos somente será liberado quando:

- As atividades obrigatórias estiverem concluídas.
- As validações técnicas estiverem aprovadas.
- Os testes independentes estiverem compreendidos.
- Os desafios demonstrarem domínio prático.
- A nota final for igual ou superior a 85%.
- Não existirem erros críticos pendentes.

O próximo módulo abordará:

- `UNION`.
- `UNION ALL`.
- `INTERSECT`.
- `EXCEPT`.
- Compatibilidade entre conjuntos.
- Remoção de duplicidades.
- Operações de conjuntos combinadas.
- Desempenho e planos de execução.

---

## 11. Referências oficiais

- PostgreSQL — Subqueries: https://www.postgresql.org/docs/16/functions-subquery.html
- PostgreSQL — Expressions: https://www.postgresql.org/docs/16/sql-expressions.html
- PostgreSQL — Aggregate Functions: https://www.postgresql.org/docs/16/functions-aggregate.html
- PostgreSQL — EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html

---

## 12. Status do documento

- Módulo: 06 — Subconsultas.
- Arquivo: `validacao.md`.
- Etapa: critérios de validação definidos.
- Execução: pendente.
- Banco principal: preservado.
- Próxima etapa documental: `consultas.sql`.

**Regra final:** avançar para o próximo módulo significa demonstrar domínio sobre subconsultas, e não apenas ter concluído a leitura da documentação.