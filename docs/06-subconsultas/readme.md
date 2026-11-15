# Módulo 06 — Subconsultas SQL

## 1. Apresentação

O Módulo 06 apresenta o uso de subconsultas (*subqueries*) no PostgreSQL.

Uma subconsulta é uma consulta SQL inserida dentro de outra consulta. Ela permite utilizar resultados intermediários para filtrar, comparar, calcular ou construir conjuntos de dados.

Subconsultas são fundamentais para resolver problemas que exigem mais de uma etapa lógica, especialmente quando uma consulta depende do resultado de outra.

Neste módulo, o aluno aprenderá a construir subconsultas simples e avançadas, compreender sua execução e escolher entre subconsultas, JOINs e CTEs.

Os estudos serão realizados utilizando o banco de dados TechStore.

---

## 2. Objetivos

Ao concluir este módulo, o aluno deverá ser capaz de:

- Compreender a estrutura de uma subconsulta.
- Identificar os diferentes contextos em que uma subconsulta pode ser utilizada.
- Construir subconsultas escalares.
- Construir subconsultas que retornam múltiplas linhas.
- Utilizar subconsultas no `WHERE`, `SELECT` e `FROM`.
- Diferenciar subconsultas correlacionadas e não correlacionadas.
- Dominar `IN`, `NOT IN`, `EXISTS` e `NOT EXISTS`.
- Compreender os operadores `ANY` e `ALL`.
- Utilizar subconsultas com agregações.
- Construir subconsultas aninhadas.
- Comparar subconsultas com JOINs e CTEs.
- Analisar o desempenho de diferentes estratégias.
- Validar os resultados independentemente.

---

## 3. Conteúdo programático

### 3.1 Fundamentos de subconsultas

- Introdução às subconsultas.
- Estrutura e sintaxe.
- Ordem lógica de avaliação.
- Consultas internas e externas.
- Resultados retornados por subconsultas.

### 3.2 Tipos de subconsultas

- Subconsultas escalares.
- Subconsultas de uma única linha.
- Subconsultas de múltiplas linhas.
- Subconsultas correlacionadas.
- Subconsultas não correlacionadas.
- Subconsultas aninhadas.

### 3.3 Localização das subconsultas

- Subconsultas no `WHERE`.
- Subconsultas no `SELECT`.
- Subconsultas no `FROM`.
- Subconsultas em expressões condicionais.
- Subconsultas associadas a agregações.

### 3.4 Operadores

- `IN`.
- `NOT IN`.
- `EXISTS`.
- `NOT EXISTS`.
- `ANY`.
- `ALL`.
- Operadores de comparação com resultados escalares.

### 3.5 Subconsultas e agregações

- Subconsultas com `COUNT`.
- Subconsultas com `SUM`.
- Subconsultas com `AVG`.
- Subconsultas com `MIN` e `MAX`.
- Comparações com médias e totais.
- Subconsultas com `GROUP BY`.
- Subconsultas com `HAVING`.

### 3.6 Comparações e desempenho

- JOIN versus subconsulta.
- CTE versus subconsulta.
- Subconsultas correlacionadas e seus custos.
- Transformações realizadas pelo PostgreSQL.
- Planos de execução.
- `EXPLAIN`.
- `EXPLAIN ANALYZE`.
- `EXPLAIN (ANALYZE, BUFFERS)`.

---

## 4. Aplicação na TechStore

O banco TechStore será utilizado para construir consultas que representem situações reais de análise comercial e operacional.

Entre os cenários de estudo:

- Clientes que possuem pedidos.
- Clientes que nunca realizaram pedidos.
- Produtos com vendas acima da média.
- Produtos cujo preço supera determinado valor de referência.
- Pedidos com valores superiores à média.
- Funcionários com movimentações de estoque.
- Produtos com quantidade vendida acima de um limite.
- Clientes com quantidade de pedidos superior à média.
- Categorias com determinados indicadores comerciais.
- Identificação de registros que atendem a múltiplas condições.

Os exercícios deverão respeitar os relacionamentos e as colunas existentes no schema.

---

## 5. Metodologia

O módulo seguirá o método Mastery Learning.

Cada conteúdo será desenvolvido em etapas:

1. Apresentação do conceito.
2. Explicação detalhada da sintaxe.
3. Demonstração com dados da TechStore.
4. Análise dos resultados.
5. Comparação com outras estratégias SQL.
6. Exercícios individuais.
7. Validação independente.
8. Correção das dificuldades.
9. Avaliação de domínio.

O avanço para o próximo módulo dependerá da demonstração de domínio dos conceitos.

---

## 6. Estrutura dos arquivos

Este diretório conterá:

| Arquivo | Finalidade |
|---|---|
| `README.md` | Organização e orientação do módulo |
| `teoria.md` | Conteúdo teórico completo |
| `atividades.md` | Exercícios e desafios |
| `validacao.md` | Critérios de validação e aprovação |
| `consultas.sql` | Exemplos demonstrativos |

Os exemplos de `consultas.sql` não substituirão as atividades individuais.

---

## 7. Avaliação

A avaliação seguirá os critérios gerais do curso:

| Critério | Peso |
|---|---:|
| Correção lógica e dos resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: **85%**.

Erros críticos de lógica, integridade ou interpretação dos resultados deverão ser corrigidos antes da aprovação.

---

## 8. Desempenho

O aluno deverá aprender a avaliar diferentes formas de construir uma consulta.

Serão observados:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Métodos de execução.
- SubPlan e InitPlan, quando presentes.
- Estratégias de acesso aos dados.

Não será estabelecido um tempo universal para todas as consultas. O desempenho será avaliado considerando o volume de dados, o objetivo e a correção dos resultados.

---

## 9. Preservação do ambiente

Durante o módulo:

- Utilizar somente consultas de leitura.
- Não modificar os dados do banco principal.
- Não executar novamente o seed.
- Não criar índices ou alterar estruturas sem autorização.
- Executar consultas de desempenho individualmente.
- Evitar consultas desnecessariamente custosas.

O banco TechStore existente deverá ser preservado.

---

## 10. Pré-requisitos

É necessário dominar os conteúdos dos módulos anteriores:

- Fundamentos do PostgreSQL.
- SELECT e filtros.
- Expressões e funções SQL.
- Agregações.
- JOINs.

Especialmente importante: compreender cardinalidade, granularidade e tratamento de `NULL`.

---

## 11. Resultados esperados

Ao finalizar o módulo, o aluno deverá conseguir:

- Resolver problemas utilizando subconsultas.
- Escolher corretamente entre subconsultas escalares e de múltiplas linhas.
- Utilizar subconsultas correlacionadas.
- Aplicar `EXISTS` e `NOT EXISTS`.
- Trabalhar com `ANY` e `ALL`.
- Combinar subconsultas com agregações.
- Identificar situações em que `NOT IN` pode produzir resultados inesperados devido a `NULL`.
- Comparar diferentes estratégias de consulta.
- Interpretar planos de execução.
- Justificar tecnicamente suas escolhas.

---

## 12. Status do módulo

- [x] README.md
- [ ] teoria.md
- [ ] atividades.md
- [ ] validacao.md
- [ ] consultas.sql
- [ ] Aulas iniciadas
- [ ] Avaliação concluída
- [ ] Módulo aprovado

**Status:** documentação em preparação.