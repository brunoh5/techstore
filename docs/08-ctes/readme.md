# Módulo 08 — CTEs (Common Table Expressions)

## 1. Apresentação

Neste módulo, estudaremos as CTEs (*Common Table Expressions*), um recurso do SQL que permite definir resultados temporários nomeados e utilizá-los dentro de uma consulta.

As CTEs são especialmente úteis para organizar consultas complexas, separar etapas de processamento, melhorar a legibilidade e estruturar operações que envolvem múltiplas tabelas e cálculos.

Também estudaremos as CTEs recursivas, que permitem trabalhar com estruturas hierárquicas e relacionamentos que exigem processamento iterativo.

O foco será compreender não apenas como escrever uma CTE, mas também como o PostgreSQL 16 planeja e executa essas consultas.

Ao longo do módulo, utilizaremos o banco TechStore para desenvolver consultas progressivamente mais complexas.

---

## 2. Objetivos de aprendizagem

Ao concluir este módulo, o aluno deverá ser capaz de:

- Compreender o conceito de CTE.
- Utilizar a cláusula `WITH`.
- Criar uma ou várias CTEs na mesma consulta.
- Encadear CTEs dependentes.
- Definir nomes e colunas para resultados intermediários.
- Utilizar CTEs com `SELECT`.
- Combinar CTEs com `JOIN`.
- Utilizar CTEs com agregações.
- Integrar CTEs com subconsultas e operações de conjuntos.
- Compreender o funcionamento de CTEs recursivas.
- Utilizar `WITH RECURSIVE`.
- Compreender os conceitos de âncora e parte recursiva.
- Trabalhar com condições de parada.
- Evitar recursões infinitas.
- Compreender a materialização de CTEs no PostgreSQL.
- Utilizar `MATERIALIZED` e `NOT MATERIALIZED`.
- Comparar CTEs com subconsultas e tabelas derivadas.
- Analisar planos de execução.
- Identificar oportunidades de melhoria de legibilidade e desempenho.

---

## 3. Conteúdo programático

### 3.1 Fundamentos das CTEs

- O que são Common Table Expressions.
- Por que utilizar CTEs.
- Diferenças entre CTEs e tabelas físicas.
- Diferenças entre CTEs e tabelas temporárias.
- Escopo e duração de uma CTE.
- Sintaxe da cláusula `WITH`.

### 3.2 CTEs básicas

- Criação de uma CTE simples.
- Definição de nomes.
- Definição de colunas.
- Utilização de CTE no SELECT principal.
- Filtragem de resultados intermediários.
- Ordenação e limitação.
- CTEs com agregações.

### 3.3 Múltiplas CTEs

- Definição de várias CTEs.
- Separação de etapas de processamento.
- Dependência entre CTEs.
- Encadeamento.
- Reutilização de resultados intermediários.
- Organização de consultas extensas.

### 3.4 CTEs com outros recursos SQL

- CTE com JOIN.
- CTE com subconsultas.
- CTE com GROUP BY e HAVING.
- CTE com Window Functions.
- CTE com operações de conjuntos.
- CTE com filtros e expressões.
- CTE como fonte de outra CTE.

### 3.5 CTEs recursivas

- Introdução à recursividade.
- Sintaxe de `WITH RECURSIVE`.
- Consulta inicial ou âncora.
- Parte recursiva.
- Operação de união entre as partes.
- Condições de parada.
- Controle de profundidade.
- Prevenção de ciclos.
- Hierarquias e relacionamentos.
- Limitações e riscos.

### 3.6 Materialização no PostgreSQL

- Conceito de materialização.
- Comportamento padrão das CTEs.
- CTEs materializadas.
- `MATERIALIZED`.
- `NOT MATERIALIZED`.
- Possibilidade de otimização conjunta com a consulta externa.
- Impacto de filtros e reutilização.
- Diferenças de comportamento conforme a versão do PostgreSQL.

### 3.7 Desempenho e otimização

- CTE versus subconsulta.
- CTE versus tabela derivada.
- CTE versus JOIN.
- CTE versus tabela temporária.
- Planejamento e execução.
- `EXPLAIN`.
- `EXPLAIN ANALYZE`.
- `BUFFERS`.
- Identificação de materialização.
- Avaliação de custos e estimativas.
- Escolha da estrutura mais adequada.

### 3.8 Boas práticas

- Nomeação de CTEs.
- Separação lógica de responsabilidades.
- Evitar CTEs desnecessárias.
- Controlar a quantidade de etapas.
- Evitar recursões sem condição de parada.
- Validar cardinalidade.
- Preservar a granularidade.
- Priorizar clareza sem ignorar desempenho.

---

## 4. Aplicações práticas na TechStore

Durante o módulo, utilizaremos as tabelas existentes para construir consultas que representem situações reais.

Exemplos de aplicações:

- Consolidar informações de clientes e pedidos.
- Construir relatórios comerciais por etapas.
- Separar agregações de vendas por categoria.
- Identificar produtos com diferentes indicadores.
- Analisar comportamento de clientes.
- Combinar dados de pedidos, pagamentos e entregas.
- Criar relatórios de movimentação de estoque.
- Organizar análises de funcionários.
- Construir consultas com múltiplas etapas de transformação.
- Estudar recursividade com conjuntos de dados apropriados.

As estruturas hierárquicas utilizadas nos exercícios recursivos serão explicitamente identificadas como dados de demonstração quando não existirem relacionamentos hierárquicos equivalentes no schema real da TechStore.

Não presumiremos a existência de colunas ou relacionamentos que não estejam definidos no banco.

---

## 5. Organização dos materiais

A pasta do módulo será organizada da seguinte maneira:

```text
docs/
└── modulo-08-ctes/
    ├── README.md
    ├── teoria.md
    ├── atividades.md
    ├── validacao.md
    └── consultas.sql
```

### README.md

Apresentação do módulo, objetivos, conteúdo programático, metodologia e critérios gerais.

### teoria.md

Explicações detalhadas dos conceitos, sintaxe, exemplos, comparações, comportamento do PostgreSQL e boas práticas.

### atividades.md

Exercícios progressivos para desenvolver domínio prático das CTEs.

### validacao.md

Testes independentes, critérios de aprovação, desafios e avaliação do domínio.

### consultas.sql

Exemplos comentados para experimentação e consulta durante os estudos.

---

## 6. Metodologia de aprendizagem

O módulo seguirá a metodologia Mastery Learning.

Cada conteúdo será trabalhado em etapas:

1. Apresentação do conceito.
2. Explicação teórica.
3. Demonstração prática.
4. Exercícios individuais.
5. Validação independente.
6. Correção e revisão.
7. Avaliação de domínio.

O objetivo é garantir que o aluno compreenda o funcionamento das CTEs antes de avançar para construções mais complexas.

Não será necessário repetir conteúdos já dominados. Caso uma dificuldade seja identificada, o reforço será direcionado ao assunto correspondente.

---

## 7. Progressão de dificuldade

As atividades serão organizadas em níveis.

| Nível | Conteúdo |
|---|---|
| 1 — Fundamentos | CTE simples e cláusula WITH |
| 2 — Aplicação | Filtros, agregações e JOINs |
| 3 — Composição | Múltiplas CTEs e encadeamento |
| 4 — Integração | Subconsultas, conjuntos e Window Functions |
| 5 — Recursividade | WITH RECURSIVE e controle de ciclos |
| 6 — Desempenho | Materialização e análise de planos |
| 7 — Desafio | Consultas complexas com múltiplas etapas |

A progressão será gradual, com aumento de complexidade conforme o domínio demonstrado.

---

## 8. Avaliação

A avaliação seguirá os critérios gerais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

A nota mínima de referência será de **85%**.

Não serão considerados aprovados resultados que apresentem erros críticos de lógica, recursividade, integridade ou segurança, mesmo que a pontuação numérica seja suficiente.

---

## 9. Desempenho e análise técnica

Neste módulo, começaremos a aprofundar a avaliação de consultas compostas por múltiplas etapas.

Serão considerados:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Nós de execução.
- Materialização.
- Reutilização de resultados intermediários.
- Impacto de filtros e agregações.

A análise será realizada por meio de `EXPLAIN` e `EXPLAIN ANALYZE`.

Não haverá um limite universal de tempo para aprovação. O desempenho será avaliado considerando a complexidade da consulta, o volume de dados e a equivalência dos resultados.

---

## 10. Segurança e preservação do ambiente

O banco TechStore existente deverá ser preservado.

Durante os exercícios:

- Priorizar consultas de leitura.
- Não executar novamente os arquivos de seed.
- Não modificar dados existentes.
- Não criar objetos permanentes sem necessidade e autorização.
- Utilizar conjuntos de demonstração e CTEs quando forem suficientes.
- Evitar consultas recursivas sem condição de parada.
- Executar análises de desempenho individualmente.

As CTEs são uma ferramenta de organização de consultas e não exigem, por si só, a criação de tabelas físicas.

---

## 11. Pré-requisitos

Para iniciar este módulo, o aluno deverá ter domínio dos conteúdos anteriores:

- Módulo 01 — Fundamentos e ambiente PostgreSQL.
- Módulo 02 — SELECT e filtros.
- Módulo 03 — Expressões e funções SQL.
- Módulo 04 — Agregações.
- Módulo 05 — JOINs.
- Módulo 06 — Subconsultas.
- Módulo 07 — Operações de conjuntos.

Especialmente importante:

- Compreender consultas compostas.
- Dominar agregações.
- Compreender cardinalidade e granularidade.
- Conhecer subconsultas.
- Dominar operações de conjuntos.

---

## 12. Resultado esperado

Ao concluir o módulo, o aluno deverá conseguir estruturar consultas complexas utilizando CTEs de maneira organizada, compreendendo suas limitações e seu comportamento no PostgreSQL.

Também deverá ser capaz de desenvolver consultas recursivas simples, identificar riscos de recursão, compreender materialização e avaliar quando uma CTE é uma escolha adequada.

O objetivo não é apenas escrever consultas menores ou visualmente mais organizadas, mas desenvolver capacidade de estruturar, compreender, validar e otimizar consultas SQL complexas.

---

## 13. Próximo módulo

**Módulo 09 — Window Functions**

O próximo módulo aprofundará funções analíticas, particionamento, ordenação, janelas, rankings, cálculos acumulados e análises avançadas sobre conjuntos de registros.

---

## 14. Status do módulo

| Item | Status |
|---|---|
| README.md | Concluído |
| teoria.md | Pendente |
| atividades.md | Pendente |
| validacao.md | Pendente |
| consultas.sql | Pendente |
| Aulas | Não iniciadas |

**Módulo 08 — CTEs: documentação em preparação.**