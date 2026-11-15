# Validação — Módulo 05: JOINs

## 1. Objetivo

Este documento estabelece os critérios para verificar se o aluno domina operações de junção (`JOIN`) no PostgreSQL.

A validação não considera apenas se a consulta executa sem erros. É necessário demonstrar que os relacionamentos foram construídos corretamente, que os resultados possuem a granularidade esperada e que não existem duplicações ou perdas indevidas de registros.

A aprovação neste módulo é necessária para avançar ao Módulo 06 — Subconsultas.

---

## 2. Regras da validação

Durante todas as atividades:

- Utilize exclusivamente comandos de leitura (`SELECT`).
- Não altere tabelas, registros, índices ou estruturas do banco.
- Não execute novamente o seed.
- Utilize o schema real da TechStore.
- Não presuma que relacionamentos possuem cardinalidade 1:1 sem verificar.
- Não utilize `DISTINCT` automaticamente para esconder duplicações.
- Analise a granularidade antes de realizar agregações.
- Compare os resultados com verificações independentes.
- Execute consultas de desempenho individualmente.

**Importante:** `EXPLAIN ANALYZE` executa efetivamente a consulta. Embora os exercícios sejam de leitura, consultas sobre tabelas grandes podem consumir recursos.

---

## 3. Checklist de domínio

Marque cada competência somente depois de conseguir demonstrá-la sem consultar uma solução pronta.

### 3.1 Fundamentos de JOIN

- [ ] Compreendo o propósito de uma operação JOIN.
- [ ] Identifico as chaves primárias e estrangeiras envolvidas.
- [ ] Consigo identificar a cardinalidade dos relacionamentos.
- [ ] Utilizo aliases de tabelas corretamente.
- [ ] Consigo interpretar uma condição `ON`.
- [ ] Diferencio relacionamentos 1:1, 1:N e N:N.

### 3.2 Tipos de JOIN

- [ ] Domino `INNER JOIN`.
- [ ] Domino `LEFT JOIN`.
- [ ] Domino `RIGHT JOIN`.
- [ ] Domino `FULL OUTER JOIN`.
- [ ] Domino `CROSS JOIN`.
- [ ] Compreendo o funcionamento de `SELF JOIN`.
- [ ] Sei escolher o tipo de JOIN adequado para cada problema.

### 3.3 Relacionamentos múltiplos

- [ ] Consigo combinar três ou mais tabelas.
- [ ] Consigo percorrer relacionamentos com tabelas intermediárias.
- [ ] Compreendo o papel de tabelas associativas.
- [ ] Identifico quando um JOIN multiplica registros.
- [ ] Consigo preservar a granularidade esperada do resultado.

### 3.4 Análise e agregações

- [ ] Sei diferenciar `COUNT(*)` de `COUNT(coluna)`.
- [ ] Sei identificar registros sem correspondência.
- [ ] Compreendo a diferença entre condições em `ON` e `WHERE`.
- [ ] Consigo utilizar JOIN com `GROUP BY`.
- [ ] Consigo utilizar JOIN com `HAVING`.
- [ ] Identifico problemas de dupla contagem.
- [ ] Consigo justificar quando uma agregação deve acontecer antes de um JOIN.

### 3.5 Desempenho

- [ ] Consigo interpretar um plano de execução com JOIN.
- [ ] Reconheço `Nested Loop`, `Hash Join` e `Merge Join`.
- [ ] Consigo observar estimativas e linhas reais.
- [ ] Consigo identificar operações potencialmente custosas.
- [ ] Consigo comparar duas estratégias de consulta.

---

## 4. Validações técnicas

As validações abaixo verificam competências específicas. Elas não fornecem as respostas das atividades.

### VAL-01 — INNER JOIN

**Objetivo:** verificar o domínio da junção interna.

Critérios:

- A consulta utiliza corretamente a condição de relacionamento.
- Somente registros correspondentes são retornados.
- Não existem associações indevidas.
- O resultado possui a granularidade esperada.

### VAL-02 — LEFT JOIN

**Objetivo:** verificar a preservação dos registros da tabela à esquerda.

Critérios:

- Todos os registros da tabela principal são preservados.
- Registros sem correspondência apresentam `NULL` nas colunas da tabela relacionada.
- A consulta não elimina acidentalmente registros preservados.
- O aluno consegue explicar a diferença entre `ON` e `WHERE` nesse contexto.

### VAL-03 — RIGHT JOIN

**Objetivo:** verificar a compreensão da preservação dos registros da tabela à direita.

Critérios:

- A tabela preservada foi identificada corretamente.
- Os registros sem correspondência continuam presentes.
- O aluno consegue explicar como a consulta poderia ser reescrita utilizando `LEFT JOIN`.

### VAL-04 — FULL OUTER JOIN

**Objetivo:** verificar a compreensão da preservação dos dois lados da junção.

Critérios:

- Registros correspondentes são relacionados.
- Registros exclusivos de cada lado são preservados.
- O aluno identifica corretamente os valores `NULL` produzidos pela operação.

### VAL-05 — CROSS JOIN

**Objetivo:** verificar a compreensão do produto cartesiano.

Critérios:

- O aluno identifica que cada registro de uma tabela é combinado com cada registro da outra.
- Consegue explicar a relação entre as quantidades de registros de entrada e saída.
- Reconhece o risco de crescimento excessivo do resultado.

### VAL-06 — SELF JOIN

**Objetivo:** verificar a compreensão de uma tabela relacionada a ela mesma.

Critérios:

- Utiliza aliases distintos para representar cada instância da tabela.
- Compreende a necessidade de uma condição de autorrelacionamento.
- Consegue explicar situações em que essa técnica é útil.

**Observação sobre a TechStore:** não presuma a existência de uma coluna `gestor_id` em `funcionarios`. Caso seja necessário demonstrar uma hierarquia de funcionários, utilize um exemplo conceitual separado do schema real.

### VAL-07 — JOIN com múltiplas tabelas

**Objetivo:** verificar a capacidade de construir consultas com vários relacionamentos.

Critérios:

- Todas as condições de relacionamento estão corretas.
- Não existem junções desconectadas ou acidentais.
- As tabelas foram relacionadas respeitando suas chaves.
- O resultado representa corretamente o problema solicitado.

### VAL-08 — ON versus WHERE

**Objetivo:** verificar o entendimento da ordem lógica e do comportamento das condições em junções externas.

Critérios:

- O aluno consegue explicar o efeito de uma condição colocada em `ON`.
- O aluno consegue explicar o efeito de uma condição colocada em `WHERE`.
- Consegue identificar quando uma condição no `WHERE` elimina registros preservados por um `LEFT JOIN`.
- Consegue escolher a posição adequada para cada condição.

### VAL-09 — COUNT e valores NULL

**Objetivo:** verificar a contagem correta em resultados de junções externas.

Critérios:

- Diferencia `COUNT(*)` de `COUNT(coluna)`.
- Compreende como os valores `NULL` afetam a contagem.
- Consegue contar registros relacionados sem incluir indevidamente as linhas sem correspondência.
- Não confunde quantidade de linhas retornadas com quantidade de entidades relacionadas.

### VAL-10 — Cardinalidade e duplicações

**Objetivo:** verificar a capacidade de identificar multiplicação de registros.

Critérios:

- Identifica relacionamentos 1:N e N:N.
- Consegue explicar por que uma junção pode retornar mais linhas do que a tabela principal.
- Identifica a granularidade do resultado.
- Reconhece quando duas relações 1:N combinadas podem multiplicar linhas.
- Não utiliza `DISTINCT` como correção automática para problemas de cardinalidade.

### VAL-11 — Agregações e dupla contagem

**Objetivo:** verificar a segurança ao agregar dados provenientes de múltiplas tabelas.

Critérios:

- Identifica o nível de detalhe de cada tabela.
- Reconhece quando uma métrica pode ser repetida após uma junção.
- Evita somar valores que foram multiplicados pela cardinalidade.
- Sabe quando utilizar agregações prévias, subconsultas ou CTEs para preservar os resultados.

### VAL-12 — Registros sem correspondência

**Objetivo:** verificar a capacidade de encontrar registros sem relacionamento correspondente.

Critérios:

- Utiliza corretamente uma junção externa ou outra estratégia apropriada.
- Identifica a ausência de correspondência sem confundir com outros valores `NULL`.
- Consegue explicar por que a condição de identificação foi escolhida.
- Verifica se os registros esperados foram preservados.

### VAL-13 — Plano de execução e desempenho

**Objetivo:** verificar a capacidade de analisar consultas que utilizam JOIN.

Critérios:

- Consegue executar `EXPLAIN`.
- Consegue interpretar os principais elementos de `EXPLAIN ANALYZE`.
- Identifica o método de junção escolhido pelo PostgreSQL.
- Compara linhas estimadas e linhas reais.
- Reconhece operações que podem representar gargalos.
- Não conclui que um índice é necessário apenas porque uma consulta contém JOIN.

---

## 5. Validação independente

A validação independente serve para verificar se os resultados estão corretos sem depender exclusivamente da aparência da consulta.

Para cada exercício selecionado, o aluno deverá utilizar pelo menos uma estratégia de conferência apropriada.

### 5.1 Conferência de quantidade

Verifique:

- Quantidade total de linhas retornadas.
- Quantidade de entidades distintas, quando pertinente.
- Quantidade de registros sem correspondência.
- Quantidade de valores `NULL` relevantes.

Não presuma que a quantidade de linhas de uma junção deve ser igual à quantidade de registros da tabela principal.

### 5.2 Conferência de relacionamentos

Verifique:

- Se as chaves relacionadas realmente correspondem.
- Se existem registros sem correspondência.
- Se a junção preservou os registros exigidos pelo problema.
- Se as condições de relacionamento são suficientes para evitar associações indevidas.

### 5.3 Conferência de agregações

Quando houver `SUM`, `AVG` ou outras agregações:

- Compare os resultados com consultas independentes.
- Verifique se os valores foram multiplicados por junções posteriores.
- Analise a granularidade antes e depois da junção.
- Confirme que a agregação representa a entidade ou o evento esperado.

### 5.4 Casos extremos

A validação deverá considerar, quando aplicável:

- Tabelas ou subconjuntos sem correspondência.
- Valores `NULL`.
- Relacionamentos com múltiplos registros.
- Resultados vazios.
- Registros com valores repetidos.
- Registros que aparecem em apenas um dos lados da junção.

---

## 6. Desafio de domínio

O desafio deverá ser realizado sem copiar consultas de demonstração ou soluções prontas.

### DES-01 — Relatório comercial

Construir um relatório que relacione clientes, pedidos e itens dos pedidos.

O relatório deverá permitir analisar o comportamento de compra dos clientes.

Critérios:

- Relacionamentos corretos.
- Granularidade explicitamente identificada.
- Ausência de associações indevidas.
- Resultados conferidos independentemente.

### DES-02 — Catálogo e vendas

Construir uma consulta que relacione produtos, categorias, marcas, itens de pedidos e informações de estoque.

Critérios:

- Junções corretas.
- Produtos sem movimentação comercial tratados adequadamente.
- Quantidades e valores interpretados corretamente.
- Ausência de duplicações não justificadas.

### DES-03 — Entregas

Construir uma consulta que relacione pedidos, entregas e transportadoras.

Critérios:

- Relacionamentos corretos.
- Situações sem data de entrega tratadas adequadamente.
- Status interpretados corretamente.
- Registros sem correspondência considerados quando necessário.

### DES-04 — Estrutura organizacional

Construir uma consulta que relacione funcionários, departamentos e movimentações de estoque.

Critérios:

- Relacionamentos corretos.
- Funcionários sem movimentações tratados adequadamente.
- Agregações consistentes.
- Ausência de contagens incorretas.

### DES-05 — Auditoria de dados

Construir consultas que identifiquem possíveis inconsistências nos relacionamentos entre tabelas.

Critérios:

- Identificação de registros sem correspondência.
- Interpretação correta de valores `NULL`.
- Verificação independente dos resultados.
- Explicação das limitações de cada consulta.

### DES-06 — Análise de desempenho

Selecionar uma consulta com múltiplos JOINs e realizar uma análise de execução.

Critérios:

- Medição inicial.
- Identificação dos métodos de junção.
- Análise de linhas estimadas e reais.
- Identificação de possíveis gargalos.
- Proposta de melhoria fundamentada.
- Comparação antes e depois, quando houver uma alteração justificável.

---

## 7. Avaliação de domínio

A avaliação considera cinco dimensões.

| Critério | Peso |
|---|---:|
| Correção lógica e dos resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### 7.1 Escala de desempenho

| Nota | Classificação |
|---|---|
| 0–59 | Insuficiente |
| 60–74 | Em desenvolvimento |
| 75–84 | Próximo do domínio |
| 85–94 | Domínio demonstrado |
| 95–100 | Domínio avançado |

A nota mínima de referência para aprovação é **85%**.

### 7.2 Erros críticos

Independentemente da nota numérica, exigem correção antes da aprovação:

- Junção baseada em relacionamento incorreto.
- Perda indevida de registros que deveriam ser preservados.
- Duplicação de valores que altera o resultado de uma agregação.
- Interpretação incorreta da granularidade.
- Resultado apresentado como correto sem validação quando existem dúvidas relevantes.
- Alteração não autorizada no banco de dados.

---

## 8. Critérios de aprovação

Para concluir o módulo, o aluno deverá:

- [ ] Concluir as atividades obrigatórias.
- [ ] Demonstrar domínio dos tipos de JOIN.
- [ ] Resolver consultas com múltiplas tabelas.
- [ ] Explicar cardinalidade e granularidade.
- [ ] Identificar e corrigir duplicações indevidas.
- [ ] Demonstrar domínio de `ON` e `WHERE`.
- [ ] Realizar agregações sem dupla contagem.
- [ ] Concluir os desafios definidos para avaliação.
- [ ] Demonstrar capacidade de validar resultados independentemente.
- [ ] Obter nota igual ou superior a 85%.
- [ ] Não apresentar erros críticos pendentes.

---

## 9. Reforço direcionado

Caso o aluno não alcance os critérios de aprovação, a revisão será direcionada às competências que apresentaram dificuldade.

| Dificuldade identificada | Reforço |
|---|---|
| Confusão entre INNER e LEFT JOIN | Revisar preservação de registros |
| Dificuldade com RIGHT e FULL JOIN | Revisar comportamento de junções externas |
| Erros em múltiplas tabelas | Revisar chaves e caminhos de relacionamento |
| Dificuldade com ON e WHERE | Comparar resultados de junções externas |
| Contagens incorretas | Revisar COUNT, NULL e cardinalidade |
| Valores duplicados | Revisar granularidade e relacionamentos 1:N e N:N |
| Dupla contagem | Revisar agregações prévias e granularidade |
| Dificuldade com desempenho | Revisar EXPLAIN e métodos de junção |

O aluno não precisará repetir atividades já dominadas sem necessidade.

---

## 10. Registro de progresso

Preencher ao concluir a avaliação.

| Informação | Resultado |
|---|---|
| Data da avaliação | |
| Atividades concluídas | |
| Desafios concluídos | |
| Nota final | |
| Erros críticos | |
| Competências dominadas | |
| Competências que precisam de reforço | |
| Resultado | Pendente / Aprovado / Reforço |

### Observações do avaliador

Registrar aqui:

- Erros recorrentes.
- Decisões técnicas bem justificadas.
- Dificuldades de interpretação.
- Problemas de cardinalidade.
- Qualidade da validação independente.
- Evolução em relação às atividades anteriores.

---

## 11. Liberação do próximo módulo

<PRIVATE_PERSON> O Módulo 06 — Subconsultas — somente será iniciado depois que os critérios de aprovação forem atendidos.

O próximo módulo utilizará os conhecimentos de JOINs para aprofundar:

- Subconsultas escalares.
- Subconsultas de múltiplas linhas.
- `IN` e `NOT IN`.
- `EXISTS` e `NOT EXISTS`.
- Subconsultas correlacionadas.
- Subconsultas no `FROM`.
- Subconsultas no `SELECT`.
- Comparação entre JOINs e subconsultas.
- Análise de desempenho.

**Status inicial:** aguardando início das aulas e realização das atividades.

---

## 12. Referências

Documentação oficial do PostgreSQL:

- JOIN: https://www.postgresql.org/docs/current/queries-table-expressions.html
- Funções de agregação: https://www.postgresql.org/docs/current/functions-aggregate.html
- EXPLAIN: https://www.postgresql.org/docs/current/using-explain.html
- Sintaxe SELECT: https://www.postgresql.org/docs/current/sql-select.html
