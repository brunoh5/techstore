# Formação Profissional em SQL e PostgreSQL — TechStore Lab

> **Documento oficial da grade curricular e metodologia de ensino.**

## 1. Identificação do curso

| Característica | Definição |
|---|---|
| Curso | Formação Profissional em SQL e PostgreSQL |
| Profundidade | Profissional |
| Progressão | Mastery Learning — avanço por domínio |
| SGBD | PostgreSQL 16 |
| Ambiente | Docker + pgAdmin |
| Laboratório | TechStore |
| Estrutura | 25 tabelas e milhões de registros |
| Projeto final | Análise completa da TechStore |

### Objetivo geral

Desenvolver autonomia profissional para construir consultas SQL, analisar dados, validar resultados, investigar problemas, compreender o funcionamento do PostgreSQL e otimizar consultas em bases com grandes volumes de registros.

O estudante deverá ser capaz de receber uma demanda, compreender o problema, desenvolver a solução, comprovar sua correção e justificar tecnicamente seu desempenho.

---

# 2. Grade curricular oficial

O curso possui 18 módulos, organizados em quatro fases.

## Fase I — Fundamentos e consultas

### Módulo 1 — Fundamentos e domínio do ambiente PostgreSQL

- Arquitetura básica do PostgreSQL.
- Bancos de dados, schemas, tabelas e colunas.
- Tipos de dados e conversões.
- Chaves primárias e estrangeiras.
- Constraints: NOT NULL, UNIQUE, CHECK e DEFAULT.
- Exploração da estrutura da TechStore pelo pgAdmin.
- Catálogo do sistema: information_schema e pg_catalog.

**Objetivo:** compreender a estrutura do banco e saber investigar seus objetos.

### Módulo 2 — SELECT e filtros

- SELECT e seleção de colunas.
- WHERE e condições compostas.
- Operadores de comparação.
- AND, OR e NOT.
- IN, BETWEEN e LIKE.
- ILIKE e expressões regulares.
- IS NULL e IS NOT NULL.
- DISTINCT.
- ORDER BY.
- LIMIT e OFFSET.
- Paginação e seus impactos no desempenho.

**Objetivo:** consultar e filtrar grandes volumes de dados corretamente.

### Módulo 3 — Expressões e funções SQL

- Operações matemáticas.
- Operações com texto.
- Funções numéricas.
- Funções de datas e horários.
- Manipulação de intervalos.
- CASE WHEN.
- COALESCE.
- NULLIF.
- CAST e operador ::.
- Tratamento de valores nulos.
- Conversões e expressões condicionais.

**Objetivo:** transformar, calcular e apresentar dados utilizando SQL.

### Módulo 4 — Agregações e agrupamentos

- COUNT, SUM, AVG, MIN e MAX.
- GROUP BY.
- HAVING.
- Agrupamento por múltiplas colunas.
- Agrupamento com expressões.
- Diferença entre WHERE e HAVING.
- FILTER.
- GROUPING SETS.
- ROLLUP.
- CUBE.

**Objetivo:** construir relatórios e análises comerciais.

### Módulo 5 — JOINs e relacionamentos

- INNER JOIN.
- LEFT JOIN.
- RIGHT JOIN.
- FULL OUTER JOIN.
- CROSS JOIN.
- SELF JOIN.
- JOIN com três ou mais tabelas.
- JOIN com condições compostas.
- JOIN com agregações.
- Relacionamentos 1:1, 1:N e N:N.
- Multiplicação indevida de registros.
- Duplicidades e integridade dos relacionamentos.

**Objetivo:** combinar corretamente os dados das 25 tabelas.

### Módulo 6 — Subconsultas

- Subconsultas escalares.
- Subconsultas de múltiplas linhas.
- Subconsultas correlacionadas.
- EXISTS e NOT EXISTS.
- IN e NOT IN.
- Subconsultas no SELECT.
- Subconsultas no FROM.
- ANY e ALL.
- Comparação entre JOIN e subconsulta.
- Identificação de subconsultas custosas.

**Objetivo:** resolver problemas que exigem consultas dentro de consultas.

### Módulo 7 — Operações entre conjuntos

- UNION.
- UNION ALL.
- INTERSECT.
- EXCEPT.
- Compatibilidade entre colunas.
- Eliminação de duplicidades.
- Diferenças de desempenho.
- Aplicações em relatórios.

**Objetivo:** combinar resultados de diferentes consultas.

---

## Fase II — Consultas avançadas

### Módulo 8 — CTEs e consultas estruturadas

- WITH.
- CTEs simples.
- CTEs múltiplas.
- CTEs encadeadas.
- WITH RECURSIVE.
- Hierarquias e estruturas em árvore.
- CTEs com agregações e JOINs.
- Materialização.
- NOT MATERIALIZED.
- Comparação entre CTE, subconsulta e tabela temporária.

**Objetivo:** organizar consultas grandes e resolver problemas complexos.

### Módulo 9 — Window Functions

- Conceito de funções de janela.
- OVER.
- PARTITION BY.
- ORDER BY em janelas.
- ROWS e RANGE.
- ROW_NUMBER.
- RANK.
- DENSE_RANK.
- LAG e LEAD.
- FIRST_VALUE e LAST_VALUE.
- NTILE.
- Agregações com OVER.
- Médias móveis.
- Acumulados.
- Rankings de produtos, clientes e vendedores.

**Objetivo:** realizar análises avançadas preservando as linhas individuais.

### Módulo 10 — Manipulação de dados e transações

- INSERT.
- INSERT INTO ... SELECT.
- Inserção de múltiplos registros.
- UPDATE.
- DELETE.
- RETURNING.
- ON CONFLICT.
- UPSERT.
- BEGIN.
- COMMIT.
- ROLLBACK.
- Savepoints.
- Atomicidade.
- Integridade durante alterações.
- Tratamento de falhas.

**Objetivo:** dominar a manipulação segura dos dados.

### Módulo 11 — Modelagem e objetos do banco

- Normalização.
- Primeira, segunda e terceira formas normais.
- Desnormalização.
- Modelagem relacional.
- Chaves naturais e substitutas.
- Relacionamentos.
- CREATE, ALTER e DROP.
- Tabelas temporárias.
- Views.
- Materialized Views.
- Sequências e colunas IDENTITY.
- Constraints.
- Dependências entre objetos.

**Objetivo:** entender como bancos relacionais são projetados e mantidos.

---

## Fase III — PostgreSQL profissional

### Módulo 12 — Índices e estruturas de acesso

- Funcionamento dos índices.
- B-tree.
- Índices compostos.
- Ordem das colunas nos índices.
- Índices únicos.
- Índices parciais.
- Índices de expressão.
- Índices de cobertura com INCLUDE.
- GIN.
- GiST.
- BRIN.
- Quando um índice ajuda.
- Quando um índice prejudica.
- Índices duplicados ou desnecessários.
- Custo de manutenção dos índices.

**Objetivo:** escolher índices adequados às consultas executadas.

### Módulo 13 — EXPLAIN e execução de consultas

- Funcionamento do PostgreSQL ao executar consultas.
- Query Planner.
- Query Optimizer.
- EXPLAIN.
- EXPLAIN ANALYZE.
- BUFFERS.
- Sequential Scan.
- Index Scan.
- Index Only Scan.
- Bitmap Index Scan.
- Nested Loop.
- Hash Join.
- Merge Join.
- Sort e Aggregate.
- Estimativas versus valores reais.
- Custo e tempo de execução.

**Objetivo:** interpretar planos de execução e investigar consultas lentas.

### Módulo 14 — Otimização e desempenho

- Identificação de gargalos.
- Consultas com muitos JOINs.
- Subconsultas correlacionadas.
- Problemas de cardinalidade.
- Filtros pouco seletivos.
- Uso inadequado de funções em filtros.
- Paginação eficiente.
- Otimização de agregações.
- Otimização de CTEs.
- Estratégias de índices.
- VACUUM.
- ANALYZE.
- Estatísticas do PostgreSQL.
- Cache e memória.
- Leitura de métricas.
- Comparação antes e depois das otimizações.

**Objetivo:** transformar consultas lentas em consultas eficientes, justificando tecnicamente as melhorias.

### Módulo 15 — Recursos avançados do PostgreSQL

- Arrays.
- JSON e JSONB.
- Operadores JSONB.
- Pesquisa textual.
- Full-text search.
- Funções e procedimentos.
- PL/pgSQL.
- Triggers.
- Cursores.
- Particionamento de tabelas.
- Tabelas particionadas.
- Herança.
- Tipos personalizados.
- Extensões do PostgreSQL.

**Objetivo:** dominar recursos que vão além do SQL padrão.

### Módulo 16 — Transações, concorrência e administração

- MVCC.
- Níveis de isolamento.
- Read Committed.
- Repeatable Read.
- Serializable.
- Locks.
- Deadlocks.
- Concorrência de consultas.
- Bloqueios entre transações.
- pg_stat_activity.
- pg_locks.
- Monitoramento.
- pg_stat_user_tables.
- pg_stat_user_indexes.
- Backup e restauração.
- Manutenção básica do banco.

**Objetivo:** compreender o comportamento do PostgreSQL em ambientes com múltiplos usuários.

### Módulo 17 — Segurança, usuários e permissões

- Usuários e roles.
- CREATE USER e CREATE ROLE.
- GRANT e REVOKE.
- Permissões de SELECT, INSERT, UPDATE e DELETE.
- Permissões em schemas e tabelas.
- ALTER DEFAULT PRIVILEGES.
- Privilégios de sequência.
- OWNER.
- Princípio do menor privilégio.
- Separação entre administrador, aplicação e usuário de leitura.
- Segurança de conexões.
- pg_hba.conf.
- Autenticação.
- SQL Injection.
- Consultas parametrizadas.
- Proteção de dados e auditoria de acessos.

**Projeto prático:** configurar perfis administrativos, de aplicação e de leitura, validando suas permissões diretamente no PostgreSQL.

---

## Fase IV — Aplicação profissional

### Módulo 18 — Projeto final: análise completa da TechStore

O projeto final integrará os conhecimentos adquiridos ao longo de todo o curso.

Demandas previstas:

- Identificar clientes mais valiosos.
- Descobrir produtos com queda de vendas.
- Analisar faturamento mensal.
- Encontrar clientes inativos.
- Calcular taxas de devolução.
- Identificar produtos com estoque crítico.
- Analisar desempenho dos vendedores.
- Investigar inconsistências.
- Construir relatórios complexos.
- Otimizar consultas com milhões de registros.
- Validar resultados.
- Justificar tecnicamente as soluções.

---

# 3. Metodologia de ensino

Todos os módulos deverão seguir uma estrutura didática consistente.

1. Objetivos de aprendizagem.
2. Explicação teórica detalhada.
3. Sintaxe e comportamento dos comandos.
4. Exemplos práticos na TechStore.
5. Comparação de abordagens alternativas.
6. Erros frequentes e suas causas.
7. Testes de validação independentes.
8. Exercícios progressivos.
9. Desafio prático.
10. Avaliação de domínio.

## Progressão por domínio — Mastery Learning

O estudante somente avançará quando demonstrar domínio do conteúdo.

Etapas:

1. Apresentação da aula.
2. Demonstração técnica.
3. Exercícios individuais.
4. Validação independente.
5. Correção e revisão.
6. Avaliação de domínio.
7. Liberação do próximo conteúdo.

Se houver dificuldades, serão propostas atividades de reforço e novas avaliações direcionadas.

Não será necessário refazer conteúdos já dominados.

---

# 4. Exercícios e categorias de testes

O curso terá cinco categorias principais de atividades:

1. **Desenvolvimento correto:** construir consultas que atendam a demandas específicas.
2. **Identificação de erros:** investigar consultas com problemas de sintaxe, lógica ou relacionamento.
3. **Casos extremos:** tratar NULL, ausência de registros, duplicidades, limites e valores inesperados.
4. **Desempenho:** investigar consultas corretas, mas lentas.
5. **Análise e interpretação:** interpretar resultados, métricas e planos de execução.

## Validação independente do GPT

O GPT será professor e revisor, mas não será a única fonte de validação.

Sempre que possível, as atividades terão:

- Quantidade esperada de registros.
- Valores esperados ou critérios objetivos.
- Comparação de conjuntos de resultados.
- Testes de duplicidade.
- Testes de registros ausentes.
- Testes com NULL.
- Testes de limites e empates.
- Verificação de integridade.
- Testes executáveis diretamente no pgAdmin.

Algumas atividades terão resultados ocultos para estimular investigação independente.

Uma consulta não será considerada correta apenas por executar sem erro.

---

# 5. Sistema oficial de avaliação

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: **85%**.

Também será obrigatório não apresentar erros críticos de lógica, integridade ou segurança.

Uma consulta mais rápida que retorna resultados incorretos nunca será considerada uma otimização válida.

---

# 6. Laboratório de desempenho

O desempenho será medido diretamente no PostgreSQL.

## Métricas obrigatórias de estudo

| Métrica | Finalidade |
|---|---|
| Execution Time | Tempo de execução |
| Planning Time | Tempo de planejamento |
| Actual Rows | Linhas realmente processadas |
| Estimated Rows | Linhas estimadas pelo planejador |
| Shared Hit Blocks | Blocos encontrados no cache |
| Shared Read Blocks | Blocos lidos do armazenamento |
| Node Type | Estratégia de execução |
| Index Usage | Utilização de índices |

## Protocolo de benchmark

1. Executar a consulta original.
2. Registrar o tempo inicial.
3. Medir com EXPLAIN ANALYZE.
4. Analisar o plano de execução.
5. Observar leituras com BUFFERS.
6. Identificar o gargalo.
7. Aplicar uma otimização.
8. Executar novamente.
9. Comparar os resultados.
10. Repetir as medições e avaliar a mediana.

## Metas de desempenho

Não haverá um único limite universal para todas as consultas.

Metas de referência:

- Buscas seletivas por chave primária: buscar tempos na faixa de milissegundos quando o ambiente permitir.
- Buscas seletivas com índice: referência preferencial abaixo de 100 ms em condições adequadas.
- JOINs grandes: estabelecer metas após a medição inicial.
- Agregações de milhões de linhas: reduzir leituras e tempo progressivamente.
- Relatórios complexos: comparar estratégias e justificar a melhor.
- Window Functions: analisar especialmente os custos de ordenação e processamento.

As metas são referências, não garantias. Hardware, cache, armazenamento, concorrência e volume de dados influenciam os resultados.

---

# 7. Ferramentas do laboratório

| Ferramenta | Utilização |
|---|---|
| pgAdmin | Execução e análise de consultas |
| EXPLAIN ANALYZE | Medição e plano de execução |
| BUFFERS | Investigação de leituras |
| pg_stat_activity | Monitoramento de consultas |
| pg_stat_user_tables | Estatísticas das tabelas |
| pg_stat_user_indexes | Estatísticas dos índices |
| pg_catalog | Metadados internos |
| information_schema | Metadados padronizados |
| pg_stat_statements | Análise de consultas executadas |

A extensão pg_stat_statements será estudada incluindo sua instalação e configuração.

---

# 8. Preservação da TechStore

A TechStore atual será nossa base principal de treinamento.

Regras:

- Não executar novamente a seed.
- Preservar os dados originais.
- Priorizar SELECT nos exercícios de exploração.
- Utilizar transações controladas em exercícios de alteração.
- Usar ROLLBACK quando apropriado.
- Criar tabelas de laboratório ou ambientes auxiliares para testes persistentes.
- Não executar comandos destrutivos sem justificativa e estratégia de segurança.
- Preservar a integridade dos relacionamentos.

---

# 9. Projeto final

O projeto final será uma simulação de demandas de uma equipe profissional de dados.

O estudante deverá:

- Construir consultas complexas.
- Criar relatórios analíticos.
- Investigar inconsistências.
- Validar resultados independentemente.
- Analisar grandes volumes de dados.
- Interpretar planos de execução.
- Otimizar consultas.
- Medir e documentar melhorias.
- Aplicar conceitos de segurança.
- Justificar tecnicamente as decisões.

---

# 10. Competências esperadas ao concluir

Ao final do curso, o estudante deverá conseguir:

1. Construir consultas SQL complexas sem depender de exemplos prontos.
2. Combinar corretamente dezenas de tabelas e relacionamentos.
3. Criar relatórios e análises utilizando SQL.
4. Resolver problemas com CTEs, subconsultas e Window Functions.
5. Identificar e corrigir consultas logicamente incorretas.
6. Entender índices e selecionar estruturas adequadas.
7. Interpretar planos de execução.
8. Investigar e otimizar consultas lentas.
9. Trabalhar com transações e concorrência.
10. Compreender recursos internos do PostgreSQL.
11. Configurar usuários, roles e permissões.
12. Validar resultados e justificar tecnicamente suas soluções.

---

# 11. Regras de entrega e papel do GPT

O GPT atuará como professor, orientador e revisor técnico.

- As aulas poderão conter consultas SQL completas para demonstração.
- Os exercícios não apresentarão soluções antecipadamente.
- O estudante deverá desenvolver e executar suas próprias consultas.
- A validação deverá ocorrer diretamente no PostgreSQL sempre que possível.
- A revisão considerará código, resultados, testes e desempenho.
- As soluções de referência serão discutidas após a tentativa.
- O avanço seguirá os critérios de domínio.

O objetivo é desenvolver autonomia profissional, e não dependência de respostas prontas.

---

# 12. Estado oficial do planejamento

| Item | Estado |
|---|---|
| Grade curricular | Consolidada |
| Quantidade de módulos | 18 |
| Profundidade | Profissional |
| Progressão | Mastery Learning |
| Segurança e permissões | Incluídas |
| Testes independentes | Incluídos |
| Benchmarks | Incluídos |
| Projeto final | Definido |
| Início das aulas | Aguardando autorização |

**Importante:** este documento representa o escopo oficial aprovado. As aulas ainda não começaram.

Qualquer alteração futura deverá ser acordada antes de modificar a grade ou iniciar conteúdos não previstos.

---

**Documento:** Grade Curricular Oficial — SQL e PostgreSQL  
**Projeto:** TechStore Lab  
**Versão:** 1.0  
**Status:** Aprovado — aguardando início das aulas.
