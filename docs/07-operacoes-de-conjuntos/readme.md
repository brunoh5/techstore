# Módulo 07 — Operações de Conjuntos

## 1. Apresentação

Neste módulo, estudaremos as operações de conjuntos disponíveis no SQL e sua aplicação no PostgreSQL.

Até aqui, aprendemos a recuperar dados de uma ou mais tabelas, relacionar registros, utilizar subconsultas e construir consultas mais complexas.

Agora, avançaremos para uma abordagem diferente: combinar os resultados de consultas independentes por meio de operações de conjuntos.

As operações permitem reunir resultados, encontrar elementos presentes em diferentes consultas ou identificar registros que aparecem em apenas um dos resultados.

O objetivo é compreender não apenas a sintaxe, mas também as regras de compatibilidade, o comportamento das duplicidades, a semântica de cada operação e seus impactos no desempenho.

---

## 2. Objetivos do módulo

Ao concluir este módulo, o aluno deverá ser capaz de:

- Compreender o conceito de operações de conjuntos no SQL.
- Utilizar `UNION` para combinar resultados.
- Diferenciar `UNION` de `UNION ALL`.
- Utilizar `INTERSECT` para identificar registros comuns.
- Utilizar `EXCEPT` para identificar diferenças entre resultados.
- Compreender a compatibilidade entre colunas.
- Controlar e identificar duplicidades.
- Trabalhar com operações de conjuntos encadeadas.
- Utilizar operações de conjuntos com filtros e agregações.
- Compreender o comportamento de `NULL` nas operações.
- Combinar operações de conjuntos com subconsultas e CTEs.
- Analisar planos de execução.
- Comparar abordagens alternativas para resolver o mesmo problema.
- Identificar situações em que uma operação de conjuntos é mais adequada que um JOIN ou uma subconsulta.

---

## 3. Conteúdo programático

### 3.1. Fundamentos das operações de conjuntos

- Conceito de conjuntos no contexto relacional.
- Diferenças entre relacionamentos e operações de conjuntos.
- Compatibilidade entre resultados.
- Correspondência por posição das colunas.
- Tipos de dados compatíveis.
- Quantidade de colunas.
- Nomes e aliases das colunas resultantes.

### 3.2. UNION

- Sintaxe.
- Combinação de resultados.
- Eliminação de duplicidades.
- Ordenação do resultado.
- Aplicações práticas na TechStore.

### 3.3. UNION ALL

- Sintaxe.
- Combinação sem eliminação de duplicidades.
- Diferenças de comportamento em relação ao UNION.
- Impacto no volume de resultados.
- Desempenho e utilização adequada.

### 3.4. INTERSECT

- Conceito de interseção.
- Sintaxe.
- Identificação de registros comuns.
- Diferenças em relação ao INNER JOIN.
- Aplicações práticas.

### 3.5. INTERSECT ALL

- Interseção preservando multiplicidades.
- Comportamento diante de duplicidades.
- Diferenças em relação ao INTERSECT.
- Aplicações específicas.

### 3.6. EXCEPT

- Conceito de diferença entre conjuntos.
- Sintaxe.
- Identificação de registros presentes em uma consulta e ausentes em outra.
- Diferenças em relação ao NOT IN e NOT EXISTS.
- Aplicações práticas.

### 3.7. EXCEPT ALL

- Diferença entre conjuntos com multiplicidades.
- Remoção de ocorrências correspondentes.
- Comparação com EXCEPT.
- Interpretação de resultados duplicados.

### 3.8. Operações encadeadas

- Combinação de múltiplas operações.
- Ordem de avaliação.
- Precedência entre operadores.
- Utilização de parênteses.
- Controle de resultados intermediários.

### 3.9. Ordenação e limitação

- ORDER BY em operações de conjuntos.
- Ordenação do resultado final.
- LIMIT e OFFSET.
- Regras para utilização de aliases.
- Limitações e particularidades sintáticas.

### 3.10. Operações de conjuntos e NULL

- Comparação de valores NULL.
- Tratamento de NULL nas operações.
- Diferenças em relação às comparações tradicionais.
- Resultados inesperados.
- Validação de casos extremos.

### 3.11. Operações de conjuntos com filtros e agregações

- WHERE nas consultas individuais.
- GROUP BY.
- HAVING.
- Combinação de resultados agregados.
- Compatibilidade de granularidade.

### 3.12. Operações de conjuntos com subconsultas e CTEs

- UNION dentro de subconsultas.
- Operações de conjuntos dentro de CTEs.
- CTEs que recebem resultados combinados.
- Encadeamento de consultas.
- Organização de consultas complexas.

### 3.13. Comparação com JOINs

- UNION versus JOIN.
- INTERSECT versus INNER JOIN.
- EXCEPT versus LEFT JOIN.
- EXCEPT versus NOT EXISTS.
- Diferenças semânticas.
- Critérios de escolha.

### 3.14. Desempenho e planos de execução

- EXPLAIN.
- EXPLAIN ANALYZE.
- Append.
- HashSetOp.
- SetOp.
- Sort.
- Unique.
- Eliminação de duplicidades.
- Custos de ordenação e comparação.
- Impacto dos índices.
- Análise de volume e cardinalidade.

### 3.15. Boas práticas e erros frequentes

- Incompatibilidade de colunas.
- Conversões de tipos.
- Colunas em posições incorretas.
- Duplicidades inesperadas.
- Uso desnecessário de UNION.
- Ordenação incorreta.
- Operações encadeadas sem parênteses.
- Consultas difíceis de interpretar.
- Escolha inadequada entre operações.

---

## 4. Aplicação prática na TechStore

Durante o módulo, utilizaremos as tabelas reais da TechStore para construir consultas que combinem conjuntos de resultados.

Algumas situações que serão exploradas:

- Identificar clientes que aparecem em diferentes conjuntos de pedidos.
- Comparar clientes com pedidos e clientes com acessos registrados.
- Encontrar produtos presentes em diferentes conjuntos de movimentações.
- Identificar produtos avaliados e produtos vendidos.
- Comparar funcionários que possuem movimentações com funcionários que possuem registros de outras atividades.
- Combinar relatórios de diferentes períodos.
- Identificar diferenças entre conjuntos de registros.
- Construir relatórios unificados com origens diferentes.

As consultas deverão respeitar a estrutura real do banco, a compatibilidade das colunas e a granularidade dos resultados.

Não serão criadas colunas fictícias para justificar exemplos.

---

## 5. Estrutura do módulo

O módulo seguirá a metodologia oficial do curso.

| Arquivo | Finalidade |
|---|---|
| `README.md` | Apresentação, objetivos e organização do módulo |
| `teoria.md` | Explicações técnicas e conceitos |
| `atividades.md` | Exercícios progressivos e desafios |
| `validacao.md` | Testes independentes e critérios de aprovação |
| `consultas.sql` | Exemplos comentados para experimentação |

Cada arquivo terá uma finalidade específica e deverá ser utilizado na ordem adequada.

---

## 6. Metodologia de aprendizagem

O aprendizado será conduzido pelo método Mastery Learning.

A sequência será:

1. Leitura da teoria.
2. Estudo dos exemplos.
3. Execução e interpretação das consultas.
4. Resolução individual das atividades.
5. Análise dos resultados.
6. Validação independente.
7. Correção de dificuldades.
8. Avaliação de domínio.
9. Liberação do próximo módulo.

O objetivo não é apenas memorizar os operadores, mas compreender como cada operação transforma os resultados.

---

## 7. Avaliação

A avaliação seguirá os pesos oficiais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio de SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de aprovação: **85 pontos**.

Erros críticos de lógica, compatibilidade, duplicidade ou interpretação de resultados deverão ser corrigidos antes da liberação do próximo módulo.

---

## 8. Desempenho e otimização

Este módulo também dará continuidade ao desenvolvimento da capacidade de analisar o desempenho das consultas.

Serão observados:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Tipos de nós de execução.
- Operações de ordenação.
- Eliminação de duplicidades.
- Volume de dados processados.

Não será adotado um limite universal de tempo para aprovação.

O desempenho será avaliado considerando a complexidade da consulta, o volume de registros e a correção do resultado.

---

## 9. Regras de segurança e preservação

Durante este módulo:

- Utilizar somente consultas de leitura.
- Não modificar os registros da TechStore.
- Não executar novamente o seed.
- Não excluir tabelas, índices ou estruturas.
- Não alterar configurações do PostgreSQL.
- Executar consultas potencialmente pesadas individualmente.
- Preservar o banco principal.

O objetivo é desenvolver conhecimento em SQL sem comprometer o ambiente de estudo.

---

## 10. Pré-requisitos

Antes de iniciar, o aluno deverá ter concluído:

- Módulo 01 — Fundamentos e domínio do ambiente PostgreSQL.
- Módulo 02 — SELECT e filtros.
- Módulo 03 — Expressões e funções SQL.
- Módulo 04 — Agregações.
- Módulo 05 — JOINs.
- Módulo 06 — Subconsultas.

É especialmente importante dominar JOINs, subconsultas, filtros, agregações e cardinalidade.

---

## 11. Resultado esperado

Ao concluir o módulo, o aluno deverá conseguir:

- Combinar conjuntos de resultados corretamente.
- Escolher entre UNION e UNION ALL.
- Identificar interseções e diferenças.
- Compreender operações com duplicidades.
- Resolver problemas utilizando INTERSECT e EXCEPT.
- Controlar a compatibilidade das colunas.
- Interpretar operações encadeadas.
- Comparar operações de conjuntos com JOINs e subconsultas.
- Identificar impactos de desempenho.
- Construir consultas confiáveis e legíveis.

---

## 12. Próximo módulo

Após a aprovação, o curso avançará para:

**Módulo 08 — CTEs (Common Table Expressions).**

O próximo módulo aprofundará a organização de consultas complexas utilizando `WITH`, CTEs encadeadas, CTEs recursivas e estratégias de execução no PostgreSQL.

---

## 13. Status do módulo

- Módulo: 07 — Operações de Conjuntos.
- Documentação: em preparação.
- Teoria: pendente.
- Atividades: pendente.
- Validação: pendente.
- Consultas SQL: pendente.
- Aulas: não iniciadas.
- Banco principal: preservado.

**Regra de progressão:** o Módulo 08 somente será liberado após a demonstração de domínio dos conceitos e a aprovação da validação do Módulo 07.