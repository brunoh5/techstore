# Módulo 01 — Fundamentos e domínio do ambiente PostgreSQL

**Formação:** SQL e PostgreSQL — TechStore  
**Nível:** Profissional  
**Fase:** 1 — Fundamentos e consultas SQL  
**Metodologia:** Mastery Learning  
**Banco de dados:** PostgreSQL 16  
**Status:** Aguardando início das aulas

---

## 1. Apresentação

Este módulo apresenta os fundamentos do PostgreSQL e o funcionamento de um banco de dados relacional.

O objetivo é desenvolver uma compreensão sólida da estrutura do banco, seus principais componentes, organização dos dados e ferramentas de administração.

Antes de desenvolver consultas complexas, é importante compreender onde os dados estão armazenados, como são organizados, como as tabelas se relacionam e como investigar a estrutura existente.

A TechStore será utilizada como laboratório para explorar uma base de dados realista, com diversas tabelas e milhões de registros.

## 2. Objetivos de aprendizagem

Ao concluir este módulo, o estudante deverá ser capaz de:

- Compreender o funcionamento geral de um banco relacional.
- Conhecer a arquitetura básica do PostgreSQL.
- Diferenciar servidor, banco de dados, schema e tabela.
- Compreender a estrutura de uma tabela.
- Identificar e interpretar tipos de dados.
- Compreender chaves primárias e estrangeiras.
- Interpretar constraints.
- Identificar relacionamentos entre tabelas.
- Navegar pelo pgAdmin com autonomia.
- Consultar metadados utilizando information_schema.
- Investigar estruturas utilizando pg_catalog.
- Compreender a organização do banco TechStore.

## 3. Pré-requisitos

- Conhecimentos básicos de informática.
- PostgreSQL 16 instalado e em execução pelo Docker.
- pgAdmin instalado e conectado ao banco TechStore.
- Acesso ao banco de dados da TechStore.

Não é necessário conhecimento prévio avançado de SQL.

## 4. Conteúdo programático

### Tema 01 — Fundamentos de bancos de dados relacionais

**Assuntos:**

1. O que é um banco de dados.
2. O que é um SGBD.
3. Diferença entre banco relacional e não relacional.
4. Conceito de tabelas, linhas e colunas.
5. Organização e armazenamento lógico dos dados.
6. Relacionamentos entre entidades.
7. Integridade dos dados.
8. Introdução ao modelo relacional.

**Resultado esperado:**

Compreender como os dados são organizados em um banco relacional e por que essa estrutura é utilizada em aplicações profissionais.

### Tema 02 — Arquitetura e funcionamento do PostgreSQL

**Assuntos:**

1. O que é PostgreSQL.
2. Arquitetura cliente-servidor.
3. Servidor e processos do PostgreSQL.
4. Conexões com o banco.
5. Database cluster.
6. Databases.
7. Schemas.
8. Relação entre schemas, tabelas e objetos.
9. Visão geral do armazenamento físico e lógico.
10. Introdução ao funcionamento de uma consulta.

**Resultado esperado:**

Compreender a organização do PostgreSQL e identificar os principais componentes de uma instalação.

### Tema 03 — Estrutura de tabelas

**Assuntos:**

1. Conceito de tabela.
2. Registros e colunas.
3. Identificação de colunas.
4. Tipos de dados.
5. Restrições de valores.
6. Estrutura de uma tabela existente.
7. Relação entre estrutura e conteúdo.
8. Diferença entre definição da tabela e seus registros.

**Resultado esperado:**

Conseguir investigar a estrutura de uma tabela e interpretar suas colunas e propriedades.

### Tema 04 — Tipos de dados

**Assuntos:**

1. INTEGER e BIGINT.
2. SMALLINT.
3. NUMERIC e DECIMAL.
4. REAL e DOUBLE PRECISION.
5. VARCHAR e CHAR.
6. TEXT.
7. BOOLEAN.
8. DATE.
9. TIME.
10. TIMESTAMP e TIMESTAMPTZ.
11. UUID.
12. JSON e JSONB — introdução.
13. Diferenças entre tipos semelhantes.
14. Escolha adequada de tipos de dados.

**Resultado esperado:**

Identificar os tipos utilizados na TechStore e justificar a escolha de um tipo apropriado conforme a natureza da informação.

### Tema 05 — Chaves e relacionamentos

**Assuntos:**

1. Chaves primárias — PRIMARY KEY.
2. Chaves estrangeiras — FOREIGN KEY.
3. Chaves compostas.
4. Chaves naturais e substitutas.
5. Relacionamento 1:1.
6. Relacionamento 1:N.
7. Relacionamento N:N.
8. Integridade referencial.
9. Dependências entre tabelas.
10. Comportamento básico das referências.

**Resultado esperado:**

Identificar as chaves e compreender como as tabelas da TechStore se relacionam.

### Tema 06 — Constraints

**Assuntos:**

1. NOT NULL.
2. UNIQUE.
3. PRIMARY KEY.
4. FOREIGN KEY.
5. CHECK.
6. DEFAULT.
7. Diferenças entre constraints.
8. Integridade e consistência dos dados.
9. Identificação de constraints existentes.
10. Consequências de violações de restrições.

**Resultado esperado:**

Reconhecer as regras de integridade implementadas no banco e compreender como elas protegem os dados.

### Tema 07 — pgAdmin e exploração do banco

**Assuntos:**

1. Interface do pgAdmin.
2. Navegação pelo servidor.
3. Exploração de databases.
4. Exploração de schemas.
5. Visualização de tabelas.
6. Visualização de colunas.
7. Identificação de constraints.
8. Visualização de índices.
9. Query Tool.
10. Histórico de consultas.
11. Execução e interpretação de resultados.
12. Boas práticas de exploração.

**Resultado esperado:**

Navegar pelo banco com autonomia e localizar informações estruturais sem depender exclusivamente da interface gráfica.

### Tema 08 — Catálogos e metadados do PostgreSQL

**Assuntos:**

1. O que são metadados.
2. information_schema.
3. pg_catalog.
4. Diferenças entre as duas estruturas.
5. Identificação de tabelas e schemas.
6. Investigação de colunas.
7. Identificação de tipos de dados.
8. Consulta de constraints.
9. Consulta de índices.
10. Investigação da estrutura do banco por SQL.

**Resultado esperado:**

Conseguir investigar a estrutura do PostgreSQL por meio de consultas, identificando tabelas, colunas, tipos, constraints e índices.

---

## 5. Aplicação prática na TechStore

Durante o módulo, o estudante deverá explorar o banco existente.

As atividades utilizarão tabelas como:

- clientes
- enderecos
- produtos
- categorias
- marcas
- pedidos
- itens_pedido
- pagamentos
- estoque
- entregas
- funcionarios
- logs_sistema

A exploração deverá permitir compreender a estrutura e os relacionamentos do banco antes de iniciar a construção de consultas mais elaboradas.

O banco principal deverá ser preservado.

## 6. Atividades previstas

As atividades serão liberadas progressivamente durante as aulas.

### Atividade 01 — Reconhecimento do ambiente

Identificar os principais componentes do ambiente PostgreSQL e compreender a conexão entre pgAdmin, servidor e banco de dados.

### Atividade 02 — Exploração estrutural

Investigar os schemas e identificar as tabelas existentes na TechStore.

### Atividade 03 — Investigação de colunas

Identificar colunas, tipos de dados e propriedades de tabelas selecionadas.

### Atividade 04 — Identificação de relacionamentos

Investigar chaves primárias e estrangeiras e compreender os relacionamentos entre tabelas.

### Atividade 05 — Investigação de constraints

Identificar as regras de integridade implementadas no banco.

### Atividade 06 — Consulta de metadados

Utilizar information_schema e pg_catalog para investigar a estrutura do banco por meio de SQL.

### Atividade 07 — Desafio integrado

Produzir um levantamento técnico da estrutura de uma parte da TechStore, relacionando tabelas, colunas, tipos, chaves e constraints.

As atividades não apresentarão soluções prontas antes da tentativa do estudante.

## 7. Validação independente

As atividades deverão possuir critérios objetivos de verificação.

Serão utilizados, quando aplicáveis:

- Comparação da quantidade de tabelas encontradas.
- Identificação de schemas existentes.
- Conferência de colunas e tipos.
- Verificação de chaves primárias.
- Verificação de chaves estrangeiras.
- Identificação de constraints.
- Comparação entre informações da interface e dos catálogos.
- Conferência dos relacionamentos identificados.

Os testes deverão permitir verificar se o levantamento estrutural está correto.

## 8. Desafio de domínio

### Levantamento técnico da TechStore

O estudante deverá produzir um levantamento técnico de uma seleção de tabelas da TechStore.

O levantamento deverá identificar:

- Nome das tabelas.
- Schema correspondente.
- Colunas.
- Tipos de dados.
- Chaves primárias.
- Chaves estrangeiras.
- Constraints.
- Relacionamentos.
- Dependências entre tabelas.

Também deverá explicar como essas informações foram obtidas e quais recursos do PostgreSQL foram utilizados.

O desafio deverá ser desenvolvido sem modificar a estrutura ou os dados do banco principal.

## 9. Critérios de avaliação

A avaliação seguirá os pesos gerais da formação:

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: 85%.

Para aprovação, também será necessário demonstrar domínio dos fundamentos e não apresentar erros críticos de interpretação estrutural ou integridade.

O desempenho de consultas não será cobrado como otimização avançada neste módulo, mas serão introduzidas as noções necessárias para as próximas etapas.

## 10. Competências necessárias para avançar

Antes de liberar o Módulo 02, o estudante deverá demonstrar que consegue:

- Explicar a organização básica do PostgreSQL.
- Diferenciar database, schema e tabela.
- Identificar e interpretar tipos de dados.
- Reconhecer chaves primárias e estrangeiras.
- Compreender relacionamentos.
- Identificar constraints.
- Navegar pelo pgAdmin.
- Consultar metadados do banco.
- Investigar a estrutura da TechStore com autonomia.

## 11. Critério de conclusão

O módulo será considerado concluído somente após:

1. Estudo dos temas previstos.
2. Realização das atividades.
3. Aprovação nas validações.
4. Conclusão do desafio de domínio.
5. Avaliação final.
6. Correção de eventuais lacunas identificadas.

Após a aprovação, será liberado o Módulo 02 — SELECT e filtros.

## 12. Materiais complementares

| Arquivo | Conteúdo |
|---|---|
| teoria.md | Explicações detalhadas dos oito temas |
| atividades.md | Enunciados completos das atividades |
| validacao.md | Testes e critérios objetivos |
| consultas.sql | Consultas demonstrativas e exemplos de apoio |

Esses arquivos serão desenvolvidos antes das respectivas aulas e atualizados conforme a necessidade pedagógica.

---

## 13. Situação do módulo

**Documentação principal:** definida.

**Conteúdo programático:** definido.

**Atividades:** planejadas.

**Validação:** planejada.

**Desafio de domínio:** definido.

**Aulas:** aguardando início.

**Aprovação:** pendente.