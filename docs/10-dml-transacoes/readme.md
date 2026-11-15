# Módulo 10 — DML e Transações

## 1. Apresentação

Neste módulo, estudaremos como manipular dados em bancos relacionais utilizando SQL e PostgreSQL.

Até o módulo anterior, o foco esteve principalmente em consultas e análises de dados. Agora, avançaremos para operações que permitem inserir, atualizar e remover registros.

Também estudaremos transações, controle de alterações, consistência dos dados e mecanismos de recuperação.

Este é um módulo especialmente importante porque erros em operações de escrita podem comprometer informações, relacionamentos e a integridade do banco de dados.

O objetivo não é apenas aprender a executar comandos, mas compreender seus efeitos, validar resultados e controlar alterações com segurança.

## 2. Objetivos

Ao concluir este módulo, você deverá ser capaz de:

- Compreender a diferença entre DQL e DML.
- Inserir registros utilizando INSERT.
- Inserir múltiplos registros em uma operação.
- Recuperar registros inseridos utilizando RETURNING.
- Atualizar dados utilizando UPDATE.
- Remover registros utilizando DELETE.
- Compreender os efeitos de operações de escrita sobre constraints.
- Utilizar transações para agrupar operações.
- Compreender COMMIT e ROLLBACK.
- Trabalhar com SAVEPOINT e ROLLBACK TO SAVEPOINT.
- Compreender as propriedades ACID.
- Identificar problemas de integridade e consistência.
- Utilizar bloqueios em operações concorrentes.
- Diagnosticar falhas em transações.
- Validar alterações antes de confirmá-las.
- Aplicar práticas seguras de manipulação de dados.

## 3. Conteúdo programático

### 3.1. Fundamentos de DML

- Diferença entre DQL, DML e DDL.
- Operações de leitura e escrita.
- Impacto das alterações no banco.
- Integridade dos dados.
- Restrições e relacionamentos.

### 3.2. INSERT

- Estrutura do comando INSERT.
- Inserção de uma linha.
- Inserção de múltiplas linhas.
- Inserção com colunas explícitas.
- Inserção utilizando DEFAULT.
- Inserção com valores NULL.
- INSERT INTO ... SELECT.
- RETURNING.
- Tratamento de erros e constraints.

### 3.3. UPDATE

- Estrutura do comando UPDATE.
- Atualização de uma coluna.
- Atualização de múltiplas colunas.
- Atualização condicional com WHERE.
- Atualização baseada em expressões.
- Atualização utilizando subconsultas.
- UPDATE ... FROM.
- RETURNING.
- Riscos de atualizações sem filtros adequados.

### 3.4. DELETE

- Estrutura do comando DELETE.
- Exclusão de registros específicos.
- DELETE com WHERE.
- DELETE utilizando subconsultas.
- DELETE ... USING.
- RETURNING.
- Relacionamentos e chaves estrangeiras.
- Comportamento de ON DELETE.
- Diferenças entre DELETE, TRUNCATE e DROP.

### 3.5. UPSERT

- Conceito de UPSERT.
- INSERT ... ON CONFLICT.
- ON CONFLICT DO NOTHING.
- ON CONFLICT DO UPDATE.
- Chaves únicas e constraints.
- Atualizações condicionais.
- RETURNING em operações UPSERT.

### 3.6. Transações

- Conceito de transação.
- BEGIN.
- COMMIT.
- ROLLBACK.
- SAVEPOINT.
- ROLLBACK TO SAVEPOINT.
- RELEASE SAVEPOINT.
- Agrupamento de operações.
- Atomicidade.
- Estados de uma transação.
- Transações com múltiplas instruções.
- Tratamento de erros.

### 3.7. Propriedades ACID

- Atomicidade.
- Consistência.
- Isolamento.
- Durabilidade.
- Aplicação das propriedades em operações reais.
- Relação entre ACID e integridade dos dados.

### 3.8. Integridade e validação

- PRIMARY KEY.
- FOREIGN KEY.
- UNIQUE.
- NOT NULL.
- CHECK.
- DEFAULT.
- Restrições durante INSERT.
- Restrições durante UPDATE.
- Restrições durante DELETE.
- Validação antes e depois de alterações.

### 3.9. Concorrência e bloqueios

- Concorrência entre transações.
- Locks.
- Bloqueios de linha.
- SELECT FOR UPDATE.
- SELECT FOR SHARE.
- Deadlocks.
- Espera por bloqueios.
- Introdução aos níveis de isolamento.
- MVCC no PostgreSQL.

### 3.10. Segurança e boas práticas

- Operações dentro de transações.
- Validação antes do COMMIT.
- Uso criterioso de WHERE.
- Identificação de registros afetados.
- Prevenção de alterações em massa.
- Menor privilégio.
- Auditoria de operações.
- Recuperação após falhas.
- Cuidados com dados de produção.

### 3.11. Desempenho de operações DML

- Custo de INSERT.
- Custo de UPDATE.
- Custo de DELETE.
- Impacto de índices nas operações de escrita.
- WAL.
- Locks e concorrência.
- Operações em lote.
- RETURNING e seu custo.
- EXPLAIN em operações de escrita.
- EXPLAIN ANALYZE e seus riscos.

## 4. Aplicação prática no TechStore

O banco TechStore será utilizado para compreender cenários reais de manipulação de dados.

As atividades poderão envolver:

- Cadastro de produtos.
- Atualização de preços.
- Atualização de estoque.
- Registro de movimentações.
- Inserção de pedidos.
- Atualização de status.
- Cancelamento de operações.
- Exclusão controlada de registros.
- Tratamento de conflitos de unicidade.
- Operações envolvendo múltiplas tabelas.
- Validação de integridade referencial.

**Importante:** o banco principal já possui uma seed extensa e validada. Ele deverá ser preservado.

As atividades que envolvam escrita serão realizadas preferencialmente em transações com ROLLBACK, tabelas auxiliares controladas ou ambiente separado de testes.

Nenhuma atividade deverá exigir a execução novamente da seed ou a destruição do banco existente.

## 5. Estrutura do módulo

Este diretório deverá conter:

| Arquivo | Responsabilidade |
|---|---|
| README.md | Apresentação e organização do módulo |
| teoria.md | Explicações e demonstrações dos conteúdos |
| atividades.md | Exercícios progressivos e desafios |
| validacao.md | Testes independentes e critérios de domínio |
| consultas.sql | Exemplos práticos comentados |

## 6. Metodologia de aprendizagem

O módulo seguirá a metodologia Mastery Learning.

Cada assunto será desenvolvido em etapas:

1. Apresentação do conceito.
2. Explicação da sintaxe.
3. Demonstração prática.
4. Análise dos efeitos da operação.
5. Exercícios individuais.
6. Validação independente.
7. Correção de erros.
8. Avaliação de domínio.

O objetivo é garantir que você compreenda o comportamento das operações antes de avançar para cenários mais complexos.

## 7. Avaliação

A avaliação seguirá os critérios gerais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |

**Nota mínima de referência: 85%.**

Erros críticos envolvendo perda acidental de dados, quebra de integridade ou uso inseguro de transações impedirão a aprovação, independentemente da nota numérica.

## 8. Segurança e preservação do banco

Este módulo introduz operações capazes de modificar permanentemente os dados.

Por isso, algumas regras serão obrigatórias:

- Não executar UPDATE sem compreender o conjunto de registros afetados.
- Não executar DELETE sem validar previamente os registros envolvidos.
- Não executar TRUNCATE ou DROP no banco principal.
- Utilizar transações sempre que apropriado.
- Validar os resultados antes de confirmar alterações.
- Utilizar ROLLBACK durante experimentações.
- Não alterar a estrutura original do TechStore sem autorização.
- Não executar novamente a seed.
- Não realizar testes destrutivos no banco principal.

A segurança será tratada como parte do domínio técnico, não como um conteúdo opcional.

## 9. Pré-requisitos

Para iniciar este módulo, é necessário dominar os conteúdos dos módulos anteriores:

- Módulo 01 — Fundamentos e domínio do ambiente PostgreSQL.
- Módulo 02 — SELECT e filtros.
- Módulo 03 — Expressões e funções SQL.
- Módulo 04 — Agregações.
- Módulo 05 — JOINs.
- Módulo 06 — Subconsultas.
- Módulo 07 — Operações de conjuntos.
- Módulo 08 — CTEs.
- Módulo 09 — Window Functions.

Também é importante compreender chaves primárias, chaves estrangeiras e constraints.

## 10. Resultado esperado

Ao finalizar o módulo, você deverá conseguir manipular dados com segurança e precisão.

Isso significa não apenas saber executar INSERT, UPDATE e DELETE, mas também:

- Antecipar os efeitos das operações.
- Preservar a integridade referencial.
- Controlar alterações por meio de transações.
- Recuperar operações não confirmadas.
- Tratar conflitos.
- Identificar problemas de concorrência.
- Validar alterações antes de confirmá-las.
- Avaliar o impacto das operações no desempenho.

## 11. Próximo módulo

Após a aprovação, avançaremos para:

**Módulo 11 — Modelagem e Objetos do Banco de Dados**

Nesse módulo, aprofundaremos a criação e organização de estruturas, objetos e recursos do PostgreSQL.

## 12. Status

- [x] README.md
- [ ] teoria.md
- [ ] atividades.md
- [ ] validacao.md
- [ ] consultas.sql
- [ ] Aulas concluídas
- [ ] Avaliação aprovada

**Situação atual:** documentação inicial do módulo preparada. Aulas ainda não iniciadas.