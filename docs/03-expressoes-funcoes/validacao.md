# Validação — Módulo 03: Expressões e Funções SQL

## 1. Objetivo

Este documento estabelece os critérios para verificar se os conhecimentos do Módulo 03 foram realmente assimilados.

A validação não consiste apenas em verificar se uma consulta executa. Também será necessário avaliar:

- Correção dos resultados.
- Domínio das expressões e funções SQL.
- Tratamento de valores `NULL`.
- Comportamento com valores inesperados e casos extremos.
- Legibilidade e organização das consultas.
- Desempenho e boas práticas.

**Ambiente:** PostgreSQL 16 — TechStore.

**Restrição:** as validações devem utilizar consultas de leitura (`SELECT`). Não modificar tabelas, registros, índices ou estruturas do banco principal.

---

## 2. Competências que serão avaliadas

Ao concluir o módulo, o estudante deverá demonstrar domínio dos seguintes assuntos:

| Código | Competência |
|---|---|
| VAL-01 | Construir expressões aritméticas e lógicas |
| VAL-02 | Aplicar corretamente operadores e precedência |
| VAL-03 | Manipular textos com funções SQL |
| VAL-04 | Realizar cálculos com funções numéricas |
| VAL-05 | Manipular datas, horários e intervalos |
| VAL-06 | Converter valores entre tipos de dados |
| VAL-07 | Tratar valores `NULL` corretamente |
| VAL-08 | Construir expressões condicionais com `CASE` |
| VAL-09 | Combinar funções em expressões compostas |
| VAL-10 | Utilizar recursos específicos do PostgreSQL |
| VAL-11 | Identificar problemas de desempenho relacionados às expressões |

---

## 3. Testes de validação

### VAL-01 — Expressões aritméticas

Verificar se o estudante consegue:

- Construir operações matemáticas em consultas.
- Utilizar aliases para identificar resultados.
- Aplicar corretamente a precedência dos operadores.
- Evitar divisões por zero.
- Interpretar resultados numéricos.

**Critérios de aprovação:**
- Resultados matematicamente corretos.
- Expressões legíveis.
- Tratamento adequado de denominadores inválidos ou iguais a zero.

### VAL-02 — Operadores e expressões lógicas

Verificar:

- Comparações entre valores.
- Combinação de condições.
- Precedência entre operadores.
- Uso de parênteses para controlar expressões.

**Critérios de aprovação:**
- Condições retornam os registros esperados.
- Não existem erros de interpretação entre `AND`, `OR` e `NOT`.
- O estudante consegue explicar por que cada condição foi utilizada.

### VAL-03 — Funções de texto

Verificar o domínio de:

- `UPPER`
- `LOWER`
- `INITCAP`
- `LENGTH`
- `TRIM`
- `LTRIM`
- `RTRIM`
- `REPLACE`
- `SUBSTRING`
- `CONCAT`
- `CONCAT_WS`
- `POSITION`
- `SPLIT_PART`

**Critérios de aprovação:**
- Aplicação correta das funções.
- Manipulação adequada dos valores retornados.
- Compreensão das diferenças entre funções semelhantes.
- Tratamento de textos vazios e valores `NULL`.

### VAL-04 — Funções numéricas

Verificar:

- `ABS`
- `ROUND`
- `CEIL`
- `CEILING`
- `FLOOR`
- `MOD`
- `POWER`
- `SQRT`

**Critérios de aprovação:**
- Resultados matematicamente corretos.
- Compreensão dos arredondamentos.
- Interpretação correta de valores negativos e positivos.
- Tratamento de entradas que possam produzir resultados inválidos.

### VAL-05 — Datas e horários

Verificar:

- `CURRENT_DATE`
- `CURRENT_TIME`
- `CURRENT_TIMESTAMP`
- `EXTRACT`
- `DATE_PART`
- `DATE_TRUNC`
- `AGE`
- `INTERVAL`
- Operações aritméticas com datas.

**Critérios de aprovação:**
- Manipulação correta de datas e horários.
- Extração adequada de componentes temporais.
- Compreensão da diferença entre truncar uma data e extrair um componente.
- Interpretação correta de intervalos.
- Tratamento de datas ausentes.

### VAL-06 — Conversão de tipos

Verificar:

- `CAST`
- Operador `::`
- Conversões entre tipos compatíveis.
- Conversões que podem falhar.

**Critérios de aprovação:**
- Conversões produzem o tipo esperado.
- O estudante identifica situações em que uma conversão pode gerar erro.
- Compreensão de que conversão de tipo não significa necessariamente validação do conteúdo.

### VAL-07 — Tratamento de NULL

Verificar:

- Diferença entre `NULL` e valores comuns.
- Uso de `COALESCE`.
- Uso de `NULLIF`.
- Comportamento de expressões com valores ausentes.
- Propagação de `NULL` em operações.

**Critérios de aprovação:**
- O estudante não confunde `NULL` com zero ou texto vazio.
- Consegue explicar o resultado de expressões envolvendo `NULL`.
- Aplica corretamente funções de tratamento.
- Identifica quando uma substituição de `NULL` pode alterar o significado dos dados.

### VAL-08 — Expressões condicionais CASE

Verificar:

- `CASE` simples.
- `CASE` pesquisado.
- Múltiplas condições.
- Ordem das condições.
- Cláusula `ELSE`.
- Combinação com funções e expressões.

**Critérios de aprovação:**
- Classificações corretas.
- Condições organizadas adequadamente.
- Tratamento de situações não contempladas.
- Ausência de classificações contraditórias.

### VAL-09 — Funções compostas

Verificar se o estudante consegue combinar diferentes funções em uma única expressão.

Exemplos de competências:

- Normalização e transformação de textos.
- Cálculos com funções numéricas.
- Manipulação de datas combinada com condições.
- Tratamento de `NULL` dentro de expressões.
- Classificações que combinam `CASE` e funções.

**Critérios de aprovação:**
- Expressões corretas.
- Resultado final coerente.
- Organização que permita compreender cada etapa.
- Ausência de conversões ou cálculos desnecessários.

### VAL-10 — Recursos específicos do PostgreSQL

Verificar:

- `GREATEST`
- `LEAST`
- `TO_CHAR`
- `TO_DATE`
- `TO_TIMESTAMP`
- `FORMAT`

**Critérios de aprovação:**
- Aplicação correta das funções.
- Compreensão do formato de entrada e saída.
- Distinção entre representação textual e valor original.
- Interpretação adequada de datas formatadas.

### VAL-11 — Desempenho e boas práticas

Verificar se o estudante compreende:

- O impacto de funções aplicadas sobre colunas.
- A diferença entre uma expressão simples e uma expressão desnecessariamente complexa.
- O uso de `EXPLAIN`.
- A interpretação inicial de `EXPLAIN ANALYZE`.
- O conceito de funções `IMMUTABLE`, `STABLE` e `VOLATILE`.
- A relação entre expressões, índices e estratégias de acesso.

**Critérios de aprovação:**
- Consegue identificar possíveis problemas de desempenho.
- Não presume que uma consulta é rápida apenas por ser curta.
- Consegue interpretar informações básicas do plano de execução.
- Apresenta justificativas técnicas para possíveis melhorias.

---

## 4. Validação independente dos resultados

A avaliação não deve depender exclusivamente da aparência da consulta ou de sua execução sem erros.

Sempre que possível, os resultados serão confrontados com verificações independentes.

### 4.1 Conferência matemática

Verificar:
- Valores calculados.
- Precisão decimal.
- Arredondamentos.
- Limites e valores extremos.
- Divisões por zero.

### 4.2 Conferência textual

Verificar:
- Comprimento dos textos.
- Espaços desnecessários.
- Caracteres e substituições.
- Diferenças entre maiúsculas e minúsculas.
- Resultado de concatenações.

### 4.3 Conferência temporal

Verificar:
- Datas retornadas.
- Componentes extraídos.
- Diferenças entre datas.
- Intervalos.
- Valores ausentes.
- Limites de períodos.

### 4.4 Conferência de NULL

Verificar:
- Quantidade de registros com valores ausentes.
- Comportamento das expressões diante de `NULL`.
- Diferenças entre substituição e preservação de valores ausentes.
- Resultados de funções condicionais.

### 4.5 Conferência de classificações

Verificar:
- Se todos os registros recebem uma classificação esperada.
- Se existem classificações incorretas.
- Se os limites entre categorias foram respeitados.
- Se existe tratamento para situações não previstas.

### 4.6 Conferência de desempenho

Verificar:
- Planning Time.
- Execution Time.
- Tipo de operação.
- Quantidade de registros estimados e efetivos.
- Blocos encontrados em memória e lidos em disco.

Os resultados devem ser interpretados considerando o volume de dados, o estado do cache e o objetivo da consulta.

---

## 5. Desafio de validação profissional

O estudante deverá demonstrar que consegue construir consultas que combinem diferentes conhecimentos do módulo.

O desafio será dividido em quatro partes.

### DES-VAL-01 — Análise de produtos

Construir uma consulta analítica utilizando:

- Expressões aritméticas.
- Funções numéricas.
- Conversões quando necessárias.
- Aliases claros.

A consulta deverá produzir informações derivadas dos dados dos produtos.

### DES-VAL-02 — Análise de clientes

Construir uma consulta utilizando:

- Funções de texto.
- Tratamento de valores ausentes.
- Expressões condicionais.
- Resultados organizados e legíveis.

### DES-VAL-03 — Análise temporal

Construir uma consulta utilizando:

- Funções de data e hora.
- Extração de componentes temporais.
- Intervalos.
- Classificações condicionais.

### DES-VAL-04 — Consulta composta

Construir uma consulta que combine pelo menos quatro grupos de conhecimentos do módulo.

A solução deverá demonstrar:
- Correção lógica.
- Uso adequado das funções.
- Tratamento de casos extremos.
- Legibilidade.
- Justificativa das escolhas realizadas.

Os detalhes e critérios específicos de cada desafio serão apresentados durante a avaliação, sem antecipar as soluções.

---

## 6. Casos extremos obrigatórios

O estudante deverá demonstrar que sabe lidar com situações que podem não aparecer nos registros mais comuns.

| Caso | O que será verificado |
|---|---|
| Valor `NULL` | Comportamento das funções |
| Texto vazio | Diferença entre vazio e `NULL` |
| Texto com espaços | Tratamento de espaços |
| Número negativo | Comportamento matemático |
| Número igual a zero | Divisões e operações |
| Número decimal | Precisão e arredondamento |
| Data ausente | Propagação de `NULL` |
| Data futura | Interpretação temporal |
| Intervalo zero | Resultado das operações temporais |
| Condição não atendida | Comportamento do `ELSE` |
| Resultado vazio | Interpretação de ausência de registros |

A avaliação deverá considerar tanto a lógica da consulta quanto a interpretação do resultado.

---

## 7. Critérios de avaliação

A nota será composta por cinco dimensões.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### Nota mínima

**85% para aprovação.**

Além da nota, não poderá existir erro crítico de lógica, interpretação de dados ou segurança.

Uma consulta que executa corretamente, mas retorna informações incorretas, não será considerada aprovada.

---

## 8. Diagnóstico de dificuldades

Caso o estudante não alcance a nota mínima, a revisão será direcionada às competências que apresentarem dificuldades.

| Dificuldade | Conteúdo para revisar |
|---|---|
| Erros matemáticos | Expressões e operadores |
| Resultados textuais incorretos | Funções de texto |
| Arredondamentos incorretos | Funções numéricas |
| Datas inconsistentes | Funções temporais |
| Erros de conversão | CAST e tipos de dados |
| Resultados inesperados com NULL | COALESCE e NULLIF |
| Classificações incorretas | CASE |
| Expressões difíceis de interpretar | Funções compostas |
| Baixo desempenho | EXPLAIN e boas práticas |

A revisão não exigirá repetir todo o módulo quando a dificuldade estiver concentrada em poucos assuntos.

---

## 9. Registro de progresso

O progresso deverá ser registrado conforme a conclusão das competências.

| Código | Competência | Status |
|---|---|---|
| VAL-01 | Expressões aritméticas | Pendente |
| VAL-02 | Operadores e expressões lógicas | Pendente |
| VAL-03 | Funções de texto | Pendente |
| VAL-04 | Funções numéricas | Pendente |
| VAL-05 | Datas e horários | Pendente |
| VAL-06 | Conversão de tipos | Pendente |
| VAL-07 | Tratamento de NULL | Pendente |
| VAL-08 | CASE | Pendente |
| VAL-09 | Funções compostas | Pendente |
| VAL-10 | Recursos PostgreSQL | Pendente |
| VAL-11 | Desempenho e boas práticas | Pendente |
| DES-VAL | Desafio profissional | Pendente |

Estados possíveis:

- **Pendente:** ainda não avaliado.
- **Em andamento:** em processo de aprendizagem.
- **Aprovado:** competência demonstrada.
- **Revisão necessária:** competência ainda não dominada.

---

## 10. Condições para aprovação do módulo

O Módulo 03 será considerado concluído quando o estudante:

1. Demonstrar domínio das competências VAL-01 a VAL-11.
2. Atingir pelo menos 85% na avaliação.
3. Resolver os desafios profissionais.
4. Demonstrar capacidade de validar os próprios resultados.
5. Tratar corretamente os casos extremos.
6. Explicar as decisões tomadas nas consultas.
7. Demonstrar compreensão das implicações de desempenho.

A aprovação libera o início do Módulo 04 — Agregações.

---

## 11. Regras de segurança

Durante as atividades e validações:

- Utilizar o banco TechStore em modo de leitura.
- Não executar alterações nas tabelas.
- Não modificar índices ou estruturas.
- Não executar comandos destrutivos.
- Utilizar `SELECT` e comandos de análise compatíveis com o objetivo da atividade.
- Não repetir a seed.

Qualquer atividade que futuramente exija modificação de dados deverá utilizar um ambiente separado ou uma estratégia de isolamento previamente definida.

---

## 12. Referências

Documentação oficial do PostgreSQL 16:

- Funções e operadores: https://www.postgresql.org/docs/16/functions.html
- Funções de texto: https://www.postgresql.org/docs/16/functions-string.html
- Funções matemáticas: https://www.postgresql.org/docs/16/functions-math.html
- Funções de data e hora: https://www.postgresql.org/docs/16/functions-datetime.html
- Conversão de tipos: https://www.postgresql.org/docs/16/typeconv.html
- Expressões condicionais: https://www.postgresql.org/docs/16/functions-conditional.html
- EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html

---

**Status do documento:** Estrutura de validação definida.

**Status do módulo:** Documentação em preparação. Aulas e avaliações ainda não iniciadas.