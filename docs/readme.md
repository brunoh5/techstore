# Formação Profissional em SQL e PostgreSQL

## Documentação geral do curso

**Projeto:** TechStore  
**Banco de dados:** PostgreSQL 16  
**Nível:** Profissional  
**Metodologia:** Mastery Learning  
**Formato:** Teoria, demonstrações, atividades práticas, validação independente e desafios profissionais.

---

## 1. Apresentação

Esta documentação organiza uma formação completa em SQL e PostgreSQL, utilizando o banco de dados da TechStore como laboratório prático.

O objetivo é desenvolver conhecimentos que permitam trabalhar com bancos de dados relacionais em situações reais, desde consultas básicas até análise de desempenho, administração, segurança e recursos avançados do PostgreSQL.

O curso não será limitado à memorização de comandos. O foco será compreender o funcionamento das consultas, desenvolver raciocínio lógico, identificar problemas, validar resultados e justificar decisões técnicas.

A TechStore será utilizada como ambiente de aprendizagem durante toda a formação.

## 2. Objetivos gerais

Ao concluir a formação, o estudante deverá ser capaz de:

- Construir consultas SQL simples e complexas.
- Consultar e relacionar múltiplas tabelas.
- Trabalhar com agregações, subconsultas, CTEs e Window Functions.
- Inserir, atualizar e excluir dados com segurança.
- Compreender modelagem e estrutura de bancos relacionais.
- Criar e avaliar índices.
- Interpretar planos de execução.
- Identificar gargalos e otimizar consultas.
- Trabalhar com recursos avançados do PostgreSQL.
- Compreender transações, concorrência e MVCC.
- Administrar permissões e proteger dados.
- Validar resultados por meio de testes independentes.
- Resolver problemas de negócio utilizando SQL.

## 3. Ambiente de aprendizagem

### 3.1. Tecnologias

| Tecnologia | Utilização |
|---|---|
| PostgreSQL 16 | Banco de dados principal |
| Docker | Execução do banco |
| Docker Compose | Gerenciamento do ambiente |
| pgAdmin | Interface de administração e execução SQL |
| SQL | Linguagem principal do curso |

### 3.2. Banco de dados TechStore

A TechStore representa um ambiente de e-commerce com tabelas relacionadas a:

- Clientes e endereços.
- Produtos, categorias e marcas.
- Fornecedores e estoque.
- Pedidos e itens de pedidos.
- Pagamentos e formas de pagamento.
- Entregas e transportadoras.
- Cupons e campanhas.
- Avaliações e devoluções.
- Funcionários e departamentos.
- Movimentações de estoque.
- Histórico de preços.
- Acessos e logs do sistema.

A base contém milhões de registros e será utilizada para exercícios de consulta, análise e desempenho.

### 3.3. Preservação do ambiente

O banco principal da TechStore é um laboratório que deverá ser preservado.

Regras:

1. Não executar novamente a seed durante o curso.
2. Não apagar ou recriar o volume principal sem autorização.
3. Priorizar consultas de leitura durante a exploração.
4. Executar atividades de alteração de dados com transações e estratégia de reversão quando apropriado.
5. Não executar comandos destrutivos sem autorização explícita.
6. Utilizar ambientes separados quando uma atividade exigir alterações arriscadas.
7. Preservar a integridade referencial e os dados existentes.

## 4. Grade curricular

A formação está dividida em quatro fases e possui 18 módulos.

### Fase 1 — Fundamentos e consultas SQL

| Módulo | Conteúdo |
|---|---|
| 01 | Fundamentos e domínio do ambiente PostgreSQL |
| 02 | SELECT e filtros |
| 03 | Expressões e funções SQL |
| 04 | Agregações |
| 05 | JOINs |
| 06 | Subconsultas |
| 07 | Operações de conjuntos |
| 08 | CTEs |
| 09 | Window Functions |

### Fase 2 — Manipulação, modelagem e desempenho

| Módulo | Conteúdo |
|---|---|
| 10 | DML e transações |
| 11 | Modelagem e objetos do banco |
| 12 | Índices |
| 13 | EXPLAIN e execução de consultas |
| 14 | Otimização e desempenho |

### Fase 3 — PostgreSQL avançado e administração

| Módulo | Conteúdo |
|---|---|
| 15 | Recursos avançados do PostgreSQL |
| 16 | Transações, concorrência e administração |
| 17 | Segurança e permissões |

### Fase 4 — Aplicação profissional

| Módulo | Conteúdo |
|---|---|
| 18 | Projeto final — análise completa da TechStore |

### 4.1. Conteúdo previsto por módulo

**Módulo 01 — Fundamentos e domínio do ambiente PostgreSQL**

Arquitetura do PostgreSQL, schemas, tabelas, tipos de dados, chaves primárias e estrangeiras, constraints, pgAdmin, information_schema e pg_catalog.

**Módulo 02 — SELECT e filtros**

SELECT, FROM, WHERE, AND, OR, NOT, IN, BETWEEN, LIKE, ILIKE, expressões regulares, NULL, DISTINCT, ORDER BY, LIMIT, OFFSET e paginação.

**Módulo 03 — Expressões e funções SQL**

Operações matemáticas, funções de texto, funções numéricas, datas, CASE, COALESCE, NULLIF, CAST, conversões e tratamento de valores NULL.

**Módulo 04 — Agregações**

COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING, FILTER, GROUPING SETS, ROLLUP e CUBE.

**Módulo 05 — JOINs**

INNER, LEFT, RIGHT, FULL, CROSS e SELF JOIN, relacionamentos entre múltiplas tabelas, relações 1:1, 1:N e N:N, multiplicação de linhas e agregações com JOIN.

**Módulo 06 — Subconsultas**

Subconsultas escalares, múltiplas linhas, correlacionadas, EXISTS, NOT EXISTS, IN, NOT IN, ANY, ALL, subconsultas em SELECT e FROM e comparação com JOINs.

**Módulo 07 — Operações de conjuntos**

UNION, UNION ALL, INTERSECT e EXCEPT, compatibilidade entre consultas, deduplicação e desempenho.

**Módulo 08 — CTEs**

WITH, múltiplas CTEs, encadeamento, WITH RECURSIVE, hierarquias, materialização, NOT MATERIALIZED e comparação com subconsultas e tabelas temporárias.

**Módulo 09 — Window Functions**

OVER, PARTITION BY, ORDER BY, ROWS, RANGE, ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, FIRST_VALUE, LAST_VALUE, NTILE, agregações em janelas, rankings, acumulados e médias móveis.

**Módulo 10 — DML e transações**

INSERT, INSERT SELECT, UPDATE, DELETE, RETURNING, ON CONFLICT, UPSERT, BEGIN, COMMIT, ROLLBACK, SAVEPOINT, atomicidade e integridade.

**Módulo 11 — Modelagem e objetos do banco**

Normalização, 1FN, 2FN, 3FN, desnormalização, modelagem relacional, CREATE, ALTER, DROP, tabelas temporárias, views, materialized views, sequences, IDENTITY, constraints e dependências.

**Módulo 12 — Índices**

B-tree, índices compostos, únicos, parciais, de expressão, INCLUDE, GIN, GiST, BRIN, seleção de índices, manutenção e custos de utilização.

**Módulo 13 — EXPLAIN e execução**

Query Planner, EXPLAIN, EXPLAIN ANALYZE, BUFFERS, Sequential Scan, Index Scan, Index Only Scan, Bitmap Scan, Nested Loop, Hash Join, Merge Join, Sort, Aggregate e estimativas versus valores reais.

**Módulo 14 — Otimização e desempenho**

Identificação de gargalos, cardinalidade, filtros, JOINs, subconsultas, CTEs, paginação, agregações, índices, VACUUM, ANALYZE, estatísticas, memória e comparação de desempenho antes e depois.

**Módulo 15 — Recursos avançados do PostgreSQL**

Arrays, JSON, JSONB, operadores e índices, full-text search, funções, procedures, PL/pgSQL, triggers, cursores, particionamento, herança, tipos customizados e extensões.

**Módulo 16 — Transações, concorrência e administração**

MVCC, níveis de isolamento, Read Committed, Repeatable Read, Serializable, locks, deadlocks, pg_stat_activity, pg_locks, monitoramento, backup, restore e manutenção.

**Módulo 17 — Segurança e permissões**

Usuários, roles, CREATE USER, CREATE ROLE, GRANT, REVOKE, privilégios de schemas, tabelas e sequences, ALTER DEFAULT PRIVILEGES, OWNER, menor privilégio, perfis de acesso, pg_hba.conf, autenticação, SQL Injection, consultas parametrizadas, proteção de dados e auditoria.

**Módulo 18 — Projeto final**

Análise completa da TechStore, construção de relatórios, investigação de inconsistências, validação de resultados, avaliação de desempenho, otimização e justificativas técnicas.

## 5. Organização da documentação dos módulos

Cada módulo terá uma pasta própria dentro de `docs/`.

Estrutura padrão:

```text
docs/
├── README.md
│
├── modulo-01-fundamentos-postgresql/
│   ├── README.md
│   ├── teoria.md
│   ├── atividades.md
│   ├── validacao.md
│   └── consultas.sql
│
├── modulo-02-select-filtros/
│   ├── README.md
│   ├── teoria.md
│   ├── atividades.md
│   ├── validacao.md
│   └── consultas.sql
│
└── ...
```

A estrutura poderá ser ampliada quando a complexidade de um módulo justificar documentos adicionais.

### 5.1. Responsabilidade dos arquivos

| Arquivo | Responsabilidade |
|---|---|
| README.md | Apresentação, objetivos, índice e organização do módulo |
| teoria.md | Explicações completas dos temas e subtópicos |
| atividades.md | Exercícios, requisitos, desafios e critérios de aceitação |
| validacao.md | Testes, verificações e resultados esperados |
| consultas.sql | Consultas demonstrativas e materiais SQL de apoio |

O README de cada módulo será o ponto de entrada para seu conteúdo.

### 5.2. Padrão de explicação dos assuntos

Cada tema será explicado de acordo com sua natureza, contemplando quando aplicável:

1. Conceito e definição.
2. Importância e aplicações.
3. Funcionamento no PostgreSQL.
4. Sintaxe e componentes.
5. Demonstração prática.
6. Interpretação dos resultados.
7. Comparações e alternativas.
8. Erros frequentes.
9. Diagnóstico e correção.
10. Atividade prática.
11. Critérios de validação.
12. Aplicação profissional.

Não será suficiente apresentar uma lista de comandos. O objetivo é compreender o funcionamento e saber quando utilizar cada recurso.

## 6. Metodologia de aprendizagem

O curso utilizará o modelo Mastery Learning, no qual o avanço depende da comprovação de domínio do conteúdo.

### 6.1. Ciclo de aprendizagem

1. Apresentação do conteúdo.
2. Explicação teórica.
3. Demonstração prática.
4. Exercícios individuais.
5. Validação independente.
6. Correção e revisão.
7. Avaliação de domínio.
8. Liberação do próximo módulo.

Caso sejam identificadas lacunas, serão realizados reforços direcionados antes do avanço.

Não será necessário repetir conteúdos já dominados sem motivo.

### 6.2. Formato das aulas

As aulas deverão ser divididas em assuntos menores e progressivos.

Cada assunto deverá possuir explicação, demonstração e oportunidade de aplicação.

Conteúdos complexos poderão ser divididos em várias aulas para evitar excesso de informações em uma única sessão.

A sequência de assuntos deverá respeitar os pré-requisitos e a progressão de dificuldade.

## 7. Atividades e exercícios

As atividades serão progressivas e terão diferentes objetivos.

| Nível | Objetivo |
|---|---|
| Básico | Compreender e aplicar os conceitos |
| Intermediário | Combinar diferentes recursos SQL |
| Avançado | Resolver problemas com maior complexidade |
| Profissional | Resolver cenários próximos aos encontrados no mercado |
| Desafio de domínio | Integrar os conhecimentos do módulo |

### 7.1. Estrutura de uma atividade

Cada atividade deverá apresentar:

- Identificação.
- Nível de dificuldade.
- Conhecimentos envolvidos.
- Contexto do problema.
- Requisitos funcionais.
- Restrições.
- Critérios de aceitação.
- Resultados esperados ou critérios objetivos de validação.
- Métricas de desempenho quando aplicáveis.

### 7.2. Entrega das soluções

O estudante deverá desenvolver as próprias consultas.

As demonstrações poderão apresentar soluções completas e explicadas.

Os exercícios individuais não deverão apresentar a solução pronta antes da tentativa do estudante.

A correção deverá considerar a consulta, os resultados obtidos, os testes e a justificativa técnica.

## 8. Validação independente

A validação não dependerá exclusivamente da avaliação do professor.

Sempre que possível, os exercícios terão testes executáveis no PostgreSQL.

### 8.1. Tipos de validação

- Comparação de valores esperados.
- Comparação de conjuntos de registros.
- Contagem de linhas.
- Identificação de duplicidades.
- Identificação de registros ausentes.
- Verificação de integridade referencial.
- Tratamento de NULL.
- Resultados vazios.
- Limites e empates.
- Casos extremos.
- Consistência entre diferentes abordagens.

### 8.2. Testes ocultos

Quando apropriado, algumas atividades terão casos de teste não apresentados inicialmente.

O objetivo será verificar se a solução funciona além do exemplo mais simples.

Uma consulta que executa sem erro, mas retorna dados incorretos, será considerada incorreta.

## 9. Avaliação de desempenho

O desempenho será desenvolvido progressivamente, com maior profundidade nos módulos de índices, execução e otimização.

### 9.1. Métricas

Serão utilizadas, quando relevantes:

- Execution Time.
- Planning Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Tipos de nós do plano.
- Utilização de índices.
- Quantidade de registros processados.

### 9.2. Protocolo de benchmark

1. Executar a consulta original.
2. Registrar o resultado e as métricas.
3. Identificar o possível gargalo.
4. Formular uma hipótese de melhoria.
5. Alterar uma variável por vez.
6. Executar novamente.
7. Comparar correção e desempenho.
8. Repetir as medições quando necessário.
9. Avaliar a mediana e considerar cache quente ou frio.
10. Documentar a conclusão.

Não será adotado um limite universal de tempo para todas as consultas.

As metas serão definidas conforme volume de dados, complexidade, hardware, cache, armazenamento e tipo de operação.

A correção dos resultados sempre terá prioridade sobre a velocidade.

## 10. Critérios de avaliação

A avaliação de domínio utilizará os seguintes pesos:

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### 10.1. Aprovação

A nota mínima de referência será de 85%.

Além da pontuação, não poderão existir erros críticos de:

- Lógica e correção dos resultados.
- Integridade dos dados.
- Segurança.
- Comportamento transacional.

O desempenho será avaliado conforme os objetivos do exercício, não por um limite arbitrário.

### 10.2. Reforço

Quando um critério não for atingido:

1. A lacuna será identificada.
2. O conteúdo relacionado será revisado.
3. Serão propostos exercícios direcionados.
4. A competência será novamente avaliada.

O avanço ocorrerá após a comprovação do domínio.

## 11. Acompanhamento do progresso

Cada módulo deverá possuir um estado de acompanhamento.

Estados possíveis:

| Estado | Significado |
|---|---|
| Aguardando | Ainda não iniciado |
| Em andamento | Conteúdo em estudo |
| Em exercícios | Atividades em execução |
| Em validação | Testes e avaliação |
| Em reforço | Existem lacunas a corrigir |
| Concluído | Domínio comprovado |

### 11.1. Controle curricular

| Módulo | Conteúdo | Estado |
|---|---|---|
| 01 | Fundamentos PostgreSQL | Aguardando |
| 02 | SELECT e filtros | Aguardando |
| 03 | Expressões e funções | Aguardando |
| 04 | Agregações | Aguardando |
| 05 | JOINs | Aguardando |
| 06 | Subconsultas | Aguardando |
| 07 | Operações de conjuntos | Aguardando |
| 08 | CTEs | Aguardando |
| 09 | Window Functions | Aguardando |
| 10 | DML e transações | Aguardando |
| 11 | Modelagem e objetos | Aguardando |
| 12 | Índices | Aguardando |
| 13 | EXPLAIN e execução | Aguardando |
| 14 | Otimização e desempenho | Aguardando |
| 15 | Recursos avançados PostgreSQL | Aguardando |
| 16 | Concorrência e administração | Aguardando |
| 17 | Segurança e permissões | Aguardando |
| 18 | Projeto final | Aguardando |

O estado deverá ser atualizado conforme o progresso real, sem considerar um módulo concluído apenas por ter sido estudado.

## 12. Projeto final

O último módulo reunirá os conhecimentos desenvolvidos ao longo da formação.

O projeto será baseado em demandas profissionais relacionadas à TechStore.

Entre os desafios previstos:

- Análise de faturamento.
- Ranking de produtos e categorias.
- Identificação de produtos em queda.
- Identificação de clientes inativos.
- Análise de estoque crítico.
- Análise de pagamentos e devoluções.
- Investigação de inconsistências.
- Construção de relatórios.
- Otimização de consultas.
- Análise de planos de execução.
- Validação independente.
- Justificativas técnicas.
- Aplicação de segurança e boas práticas.

O objetivo será demonstrar autonomia para resolver problemas utilizando SQL e PostgreSQL.

## 13. Competências esperadas ao final

Ao concluir os 18 módulos, o estudante deverá demonstrar capacidade de:

- Desenvolver consultas SQL com autonomia.
- Trabalhar com estruturas relacionais complexas.
- Resolver problemas analíticos e operacionais.
- Validar resultados de forma independente.
- Interpretar planos de execução.
- Escolher e avaliar índices.
- Otimizar consultas.
- Utilizar transações com segurança.
- Trabalhar com recursos avançados do PostgreSQL.
- Administrar permissões.
- Identificar riscos de segurança.
- Justificar decisões técnicas.

## 14. Papel do professor e do estudante

### Professor

O professor será responsável por:

- Apresentar e explicar os conteúdos.
- Demonstrar aplicações práticas.
- Elaborar atividades progressivas.
- Analisar as soluções apresentadas.
- Identificar lacunas de aprendizagem.
- Propor reforços direcionados.
- Avaliar resultados e desempenho.
- Liberar a progressão após o domínio.

### Estudante

O estudante será responsável por:

- Estudar os conteúdos apresentados.
- Desenvolver as atividades.
- Executar as consultas no PostgreSQL.
- Apresentar resultados e evidências.
- Investigar erros.
- Validar as próprias soluções.
- Justificar decisões técnicas.
- Demonstrar domínio antes de avançar.

## 15. Regras gerais da formação

1. A grade curricular oficial possui 18 módulos.
2. A profundidade da formação é profissional.
3. A progressão seguirá Mastery Learning.
4. Todos os módulos terão objetivos e critérios de conclusão.
5. Os exercícios não apresentarão soluções prontas antes da tentativa.
6. As demonstrações poderão conter código completo.
7. A validação deverá ser independente sempre que possível.
8. A correção dos resultados será prioridade.
9. O desempenho será medido conforme o contexto de cada exercício.
10. O banco principal deverá ser preservado.
11. Conteúdos já dominados não precisarão ser repetidos desnecessariamente.
12. O próximo módulo só será liberado após a avaliação de domínio.

---

## 16. Estado atual do curso

**Planejamento curricular:** consolidado.

**Grade:** 18 módulos.

**Profundidade:** profissional.

**Progressão:** Mastery Learning.

**Ambiente:** TechStore com PostgreSQL 16.

**Validação independente:** prevista.

**Benchmarks e desempenho:** previstos.

**Segurança e permissões:** incluídas.

**Projeto final:** definido.

**Aulas:** ainda não iniciadas.

Este documento representa a referência geral da formação. Os READMEs individuais dos módulos deverão respeitar estas diretrizes e detalhar seus respectivos conteúdos, atividades, validações e critérios de domínio.