# Validação — Módulo 02: SELECT e filtros

## 1. Objetivo

Este documento estabelece os procedimentos de validação técnica e os critérios de aprovação do Módulo 02.

O objetivo é verificar se o estudante domina a construção de consultas SQL utilizando SELECT, filtros, operadores lógicos, pesquisas textuais, tratamento de NULL, ordenação e limitação de resultados.

A avaliação deverá considerar três aspectos fundamentais:

1. Correção sintática: a consulta é válida no PostgreSQL?
2. Correção lógica: a consulta retorna exatamente os registros solicitados?
3. Qualidade técnica: a consulta é legível, adequada e eficiente para o contexto?

Uma consulta que executa sem apresentar erros não será considerada automaticamente correta.

**SGBD:** PostgreSQL 16  
**Banco:** TechStore  
**Schema:** techstore  
**Ambiente:** pgAdmin e Docker

---

## 2. Regras de validação

Durante este módulo:

- Utilizar exclusivamente consultas de leitura.
- Não executar novamente o seed.
- Não inserir, atualizar ou excluir registros.
- Não modificar tabelas, índices ou constraints.
- Não alterar configurações do PostgreSQL.
- Utilizar LIMIT durante explorações iniciais.
- Executar consultas pesadas somente quando necessário.
- Validar os resultados antes de considerar uma atividade concluída.

Não utilizar comandos de alteração de dados como parte dos testes deste módulo.

---

## 3. Categorias de validação

| Código | Categoria | Competência |
|---|---|---|
| VAL-01 | SELECT e FROM | Recuperação de dados |
| VAL-02 | Seleção de colunas | Controle das informações retornadas |
| VAL-03 | DISTINCT | Eliminação de duplicidades |
| VAL-04 | WHERE | Filtragem de registros |
| VAL-05 | Comparações | Comparação de valores |
| VAL-06 | Operadores lógicos | Combinação de condições |
| VAL-07 | IN e BETWEEN | Conjuntos e intervalos |
| VAL-08 | LIKE e ILIKE | Pesquisa textual |
| VAL-09 | NULL | Tratamento de valores ausentes |
| VAL-10 | ORDER BY | Ordenação |
| VAL-11 | LIMIT e OFFSET | Controle e paginação |
| VAL-12 | Consultas compostas | Integração dos conhecimentos |
| VAL-13 | Diagnóstico e desempenho | Análise técnica |

---

## 4. VAL-01 — SELECT e FROM

### Objetivo

Verificar se o estudante consegue construir consultas básicas e identificar corretamente a origem dos dados.

### Testes

- [ ] Consultar uma tabela existente.
- [ ] Recuperar todos os registros de uma tabela pequena.
- [ ] Selecionar colunas específicas.
- [ ] Consultar tabelas utilizando o schema explícito.
- [ ] Utilizar aliases para melhorar a apresentação.
- [ ] Identificar erros de sintaxe.
- [ ] Diferenciar uma consulta válida de uma consulta semanticamente incorreta.

### Critérios de aprovação

O estudante deverá demonstrar domínio da estrutura básica do SELECT e compreender a finalidade das cláusulas SELECT e FROM.

Também deverá saber explicar por que a seleção explícita de colunas é preferível em consultas profissionais.

---

## 5. VAL-02 — Seleção de colunas

### Objetivo

Verificar se o estudante consegue controlar as informações retornadas.

### Testes

- [ ] Selecionar uma única coluna.
- [ ] Selecionar várias colunas.
- [ ] Alterar a ordem das colunas no resultado.
- [ ] Utilizar aliases.
- [ ] Diferenciar alias de nome real da coluna.
- [ ] Evitar retornar informações desnecessárias.

### Critérios de aprovação

O resultado deverá conter somente as colunas solicitadas, na ordem esperada e com os nomes de apresentação adequados.

---

## 6. VAL-03 — DISTINCT

### Objetivo

Verificar se o estudante compreende a eliminação de duplicidades no resultado.

### Testes

- [ ] Aplicar DISTINCT em uma coluna.
- [ ] Aplicar DISTINCT em múltiplas colunas.
- [ ] Interpretar combinações distintas.
- [ ] Reconhecer o comportamento de NULL.
- [ ] Diferenciar duplicidade no resultado de duplicidade na tabela.
- [ ] Identificar situações em que DISTINCT não é necessário.

### Critérios de aprovação

O estudante deverá conseguir explicar quais colunas participam da comparação de duplicidade.

Também deverá justificar quando o uso de DISTINCT é adequado e quando pode esconder um problema na consulta.

---

## 7. VAL-04 — WHERE

### Objetivo

Verificar a capacidade de filtrar registros conforme requisitos específicos.

### Testes

- [ ] Construir um filtro simples.
- [ ] Filtrar informações textuais.
- [ ] Filtrar valores numéricos.
- [ ] Filtrar datas.
- [ ] Combinar filtros de diferentes tipos.
- [ ] Identificar condições excessivamente restritivas.
- [ ] Explicar resultados vazios.

### Critérios de aprovação

O estudante deverá produzir consultas que retornem somente os registros que atendam aos critérios estabelecidos.

Não serão aceitas consultas que retornem resultados aparentemente corretos por coincidência, mas que não representem a regra solicitada.

---

## 8. VAL-05 — Operadores de comparação

### Objetivo

Validar a utilização correta dos operadores de comparação.

### Operadores avaliados

- Igualdade.
- Diferença.
- Maior que.
- Menor que.
- Maior ou igual.
- Menor ou igual.

### Testes

- [ ] Comparar valores numéricos.
- [ ] Comparar textos.
- [ ] Comparar datas.
- [ ] Trabalhar com limites inclusivos.
- [ ] Trabalhar com limites exclusivos.
- [ ] Identificar incompatibilidades entre tipos.
- [ ] Interpretar o resultado de comparações envolvendo NULL.

### Critérios de aprovação

O estudante deverá selecionar corretamente os operadores conforme a necessidade.

Também deverá demonstrar que compreende a diferença entre igualdade, desigualdade e limites de intervalos.

---

## 9. VAL-06 — Operadores lógicos

### Objetivo

Verificar a capacidade de construir condições compostas.

### Operadores avaliados

- AND.
- OR.
- NOT.

### Testes

- [ ] Construir condições com AND.
- [ ] Construir condições com OR.
- [ ] Aplicar NOT.
- [ ] Combinar AND e OR.
- [ ] Utilizar parênteses.
- [ ] Interpretar precedência lógica.
- [ ] Reconhecer resultados UNKNOWN.
- [ ] Identificar erros de agrupamento.

### Casos especiais

A validação deverá incluir situações nas quais:

- Todas as condições são verdadeiras.
- Apenas uma condição é verdadeira.
- Todas as condições são falsas.
- Uma das condições envolve NULL.
- Uma expressão combina AND e OR.

### Critérios de aprovação

O estudante deverá demonstrar que consegue traduzir regras de negócio em expressões lógicas.

A consulta deverá preservar exatamente a intenção do requisito, independentemente da complexidade dos filtros.

---

## 10. VAL-07 — IN e BETWEEN

### Objetivo

Validar consultas que utilizam conjuntos e intervalos.

### Testes com IN

- [ ] Pesquisar um único valor.
- [ ] Pesquisar múltiplos valores.
- [ ] Aplicar NOT IN.
- [ ] Interpretar resultados com valores NULL.
- [ ] Comparar IN com condições equivalentes utilizando OR.

### Testes com BETWEEN

- [ ] Consultar intervalos numéricos.
- [ ] Consultar intervalos de datas.
- [ ] Confirmar que os limites são inclusivos.
- [ ] Aplicar NOT BETWEEN.
- [ ] Identificar problemas com colunas temporais.
- [ ] Utilizar corretamente intervalos semiabertos quando necessário.

### Critérios de aprovação

O estudante deverá demonstrar que compreende os limites dos intervalos e as diferenças entre IN e BETWEEN.

Erros envolvendo NULL ou limites temporais serão considerados erros de lógica.

---

## 11. VAL-08 — LIKE e ILIKE

### Objetivo

Validar a utilização de padrões textuais.

### Testes

- [ ] Pesquisar textos com prefixo.
- [ ] Pesquisar textos com sufixo.
- [ ] Pesquisar trechos de texto.
- [ ] Utilizar o caractere `%`.
- [ ] Utilizar o caractere `_`.
- [ ] Comparar LIKE e ILIKE.
- [ ] Reconhecer a diferença entre pesquisa sensível e insensível a maiúsculas e minúsculas.
- [ ] Interpretar resultados vazios.
- [ ] Reconhecer a necessidade de escape para caracteres especiais.

### Critérios de aprovação

O estudante deverá construir pesquisas textuais que respeitem exatamente os padrões solicitados.

Também deverá compreender que pesquisas textuais podem ter impactos diferentes sobre o desempenho, dependendo do padrão e dos índices disponíveis.

---

## 12. VAL-09 — Tratamento de NULL

### Objetivo

Verificar se o estudante compreende a ausência de valores e a lógica de três estados do SQL.

### Testes

- [ ] Identificar registros com NULL.
- [ ] Identificar registros sem NULL.
- [ ] Utilizar IS NULL.
- [ ] Utilizar IS NOT NULL.
- [ ] Diferenciar NULL de string vazia.
- [ ] Diferenciar NULL de zero.
- [ ] Interpretar comparações envolvendo NULL.
- [ ] Reconhecer o resultado UNKNOWN.
- [ ] Identificar problemas com NOT IN e NULL.

### Casos extremos

A validação deverá incluir situações com:

- Valor conhecido.
- Valor NULL.
- String vazia.
- Número zero.
- Expressões lógicas com UNKNOWN.

### Critérios de aprovação

O estudante deverá demonstrar domínio do tratamento de valores nulos.

Este é um dos requisitos críticos do módulo: não serão aceitas soluções que utilizem comparações inadequadas para identificar NULL.

---

## 13. VAL-10 — ORDER BY

### Objetivo

Verificar a capacidade de ordenar resultados de forma correta e previsível.

### Testes

- [ ] Ordenar números em ordem crescente.
- [ ] Ordenar números em ordem decrescente.
- [ ] Ordenar textos.
- [ ] Ordenar datas.
- [ ] Ordenar por múltiplas colunas.
- [ ] Utilizar ASC e DESC.
- [ ] Utilizar NULLS FIRST.
- [ ] Utilizar NULLS LAST.
- [ ] Construir ordenação determinística.

### Critérios de aprovação

A ordenação deverá corresponder aos critérios solicitados.

Quando houver empates, o estudante deverá compreender quando é necessário acrescentar um critério adicional, como uma chave primária, para garantir uma sequência estável.

---

## 14. VAL-11 — LIMIT e OFFSET

### Objetivo

Validar o controle da quantidade de registros retornados e a paginação.

### Testes

- [ ] Aplicar LIMIT.
- [ ] Aplicar OFFSET.
- [ ] Combinar LIMIT e OFFSET.
- [ ] Construir páginas sequenciais.
- [ ] Utilizar ORDER BY com paginação.
- [ ] Identificar resultados instáveis sem ordenação.
- [ ] Compreender o custo potencial de OFFSET elevado.

### Critérios de aprovação

O estudante deverá conseguir construir paginações coerentes.

Também deverá explicar por que LIMIT não garante que o banco examinará somente a quantidade de linhas retornadas.

---

## 15. VAL-12 — Consultas compostas

### Objetivo

Verificar a capacidade de integrar os recursos estudados em consultas completas.

### Testes

- [ ] Combinar SELECT e WHERE.
- [ ] Combinar WHERE e ORDER BY.
- [ ] Combinar múltiplos filtros.
- [ ] Utilizar operadores lógicos.
- [ ] Utilizar IN ou BETWEEN.
- [ ] Combinar filtros textuais e numéricos.
- [ ] Tratar NULL.
- [ ] Aplicar ordenação múltipla.
- [ ] Aplicar LIMIT e OFFSET.
- [ ] Interpretar consultas mais extensas.

### Critérios de aprovação

A consulta deverá atender a todos os requisitos simultaneamente.

O estudante deverá explicar a função de cada cláusula e justificar as condições utilizadas.

---

## 16. VAL-13 — Diagnóstico e desempenho

### Objetivo

Introduzir a capacidade de analisar consultas por meio do plano de execução.

### Testes

- [ ] Executar EXPLAIN em uma consulta SELECT.
- [ ] Identificar o tipo de operação utilizado.
- [ ] Reconhecer Sequential Scan.
- [ ] Reconhecer Index Scan.
- [ ] Reconhecer Sort.
- [ ] Identificar Planning Time.
- [ ] Identificar Execution Time.
- [ ] Diferenciar estimativas de resultados reais.
- [ ] Interpretar Actual Rows.
- [ ] Reconhecer a função de LIMIT no plano.
- [ ] Identificar possíveis gargalos.

### Critérios de aprovação

O estudante deverá conseguir interpretar um plano simples e explicar, em termos gerais, como o PostgreSQL executou a consulta.

Não será exigido domínio de otimização avançada neste módulo.

### Cuidados

EXPLAIN ANALYZE executa a consulta analisada.

Neste módulo, utilizar exclusivamente consultas SELECT controladas e evitar operações que possam consumir recursos excessivos.

---

## 17. Validação independente dos resultados

A validação não deverá depender exclusivamente da aparência do resultado apresentado pelo pgAdmin.

Sempre que possível, serão utilizados testes independentes.

### Técnicas de validação

**1. Quantidade de registros**

Verificar se a quantidade retornada corresponde ao requisito.

**2. Verificação de limites**

Conferir se os valores nos limites inferiores e superiores foram tratados corretamente.

**3. Comparação de conjuntos**

Verificar se os registros retornados correspondem exatamente ao conjunto esperado.

**4. Duplicidades**

Conferir se existem resultados repetidos quando a consulta exige valores distintos.

**5. Valores NULL**

Verificar se registros com ausência de valor foram tratados corretamente.

**6. Resultados vazios**

Confirmar se um resultado vazio é esperado ou indica um erro no filtro.

**7. Ordenação**

Verificar a sequência dos resultados, incluindo empates e valores NULL.

**8. Paginação**

Conferir se páginas consecutivas apresentam a sequência esperada, sem sobreposição ou lacunas em uma mesma execução estável dos dados.

### Princípio fundamental

A validação deverá testar o resultado, não apenas a sintaxe.

---

## 18. Desafio de domínio

O estudante deverá receber requisitos de consulta que combinem os conhecimentos do módulo.

O desafio deverá envolver:

- Seleção de colunas específicas.
- Múltiplos critérios de filtragem.
- Operadores de comparação.
- Combinação de condições lógicas.
- Tratamento de NULL.
- Pesquisa textual.
- Ordenação.
- Limitação de resultados.

### Requisitos de execução

O estudante deverá:

1. Interpretar o requisito.
2. Identificar as tabelas e colunas necessárias.
3. Construir a consulta.
4. Executar no PostgreSQL.
5. Validar os resultados.
6. Explicar a lógica utilizada.
7. Identificar possíveis limitações.
8. Apresentar uma versão legível da consulta.

O desafio não deverá ser resolvido com uma consulta fornecida antecipadamente.

---

## 19. Critérios de avaliação

A avaliação seguirá os pesos oficiais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### Requisitos para aprovação

- Nota mínima de referência: 85%.
- Ausência de erros críticos de lógica.
- Domínio dos operadores fundamentais.
- Tratamento correto de NULL.
- Capacidade de validar resultados.
- Capacidade de explicar as próprias consultas.
- Demonstração de autonomia.

### Erros críticos

São considerados erros críticos:

- Consulta que retorna registros fora dos critérios exigidos.
- Utilização incorreta de AND e OR.
- Interpretação incorreta de limites de datas.
- Tratamento incorreto de NULL.
- Paginação sem compreender a ordenação necessária.
- Utilização de DISTINCT para esconder um erro lógico.
- Modificação indevida do banco principal.

Um erro crítico poderá exigir nova avaliação, mesmo que a pontuação numérica seja suficiente.

---

## 20. Diagnóstico de dificuldades

| Dificuldade | Conteúdo para revisar |
|---|---|
| Consulta retorna registros demais | WHERE e operadores lógicos |
| Consulta não retorna registros | Condições e tipos de dados |
| Duplicidades inesperadas | DISTINCT e lógica da consulta |
| Pesquisa textual incorreta | LIKE e ILIKE |
| Problemas com NULL | Lógica de três valores |
| Ordenação inesperada | ORDER BY |
| Paginação inconsistente | ORDER BY, LIMIT e OFFSET |
| Resultado incorreto em datas | Tipos temporais e limites |
| Consulta lenta | EXPLAIN e plano de execução |

As revisões serão direcionadas ao conteúdo que apresentar dificuldade.

Não será necessário repetir todo o módulo quando apenas um conceito específico precisar de reforço.

---

## 21. Registro de progresso

| Categoria | Status | Resultado |
|---|---|---|
| VAL-01 — SELECT e FROM | Pendente | — |
| VAL-02 — Seleção de colunas | Pendente | — |
| VAL-03 — DISTINCT | Pendente | — |
| VAL-04 — WHERE | Pendente | — |
| VAL-05 — Comparações | Pendente | — |
| VAL-06 — Operadores lógicos | Pendente | — |
| VAL-07 — IN e BETWEEN | Pendente | — |
| VAL-08 — LIKE e ILIKE | Pendente | — |
| VAL-09 — NULL | Pendente | — |
| VAL-10 — ORDER BY | Pendente | — |
| VAL-11 — LIMIT e OFFSET | Pendente | — |
| VAL-12 — Consultas compostas | Pendente | — |
| VAL-13 — Desempenho | Pendente | — |
| Desafio de domínio | Pendente | — |
| Avaliação final | Pendente | — |

### Status possíveis

- Pendente.
- Em andamento.
- Aprovado.
- Revisão necessária.
- Revalidado.

---

## 22. Condições para liberar o Módulo 03

O próximo módulo será liberado quando o estudante:

- [ ] Demonstrar domínio das 13 categorias.
- [ ] Concluir as atividades obrigatórias.
- [ ] Resolver o desafio de domínio.
- [ ] Atingir a nota mínima de referência.
- [ ] Demonstrar capacidade de validar consultas.
- [ ] Tratar corretamente casos com NULL.
- [ ] Construir consultas compostas de forma independente.

---

## 23. Estado do documento

| Informação | Estado |
|---|---|
| Documento | Validação do Módulo 02 |
| Módulo | SELECT e filtros |
| Banco | TechStore |
| SGBD | PostgreSQL 16 |
| Metodologia | Mastery Learning |
| Nível | Professional |
| Aulas | Aguardando início |
| Atividades | Aguardando execução |
| Validação | Aguardando execução |
| Avaliação | Não realizada |

**Este documento define os critérios de validação. Os resultados serão registrados conforme o estudante avançar nas atividades.**