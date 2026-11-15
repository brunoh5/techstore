# Módulo 03 — Expressões e Funções SQL

## 1. Apresentação

Neste módulo, vamos aprofundar a capacidade de manipular, transformar e interpretar dados utilizando expressões e funções SQL.

O objetivo é aprender a transformar dados diretamente no PostgreSQL, construir expressões mais elaboradas e compreender como as funções podem ser aplicadas em consultas reais.

## 2. Objetivos

Ao concluir este módulo, o estudante deverá conseguir:

- Construir expressões aritméticas e lógicas.
- Manipular textos utilizando funções SQL.
- Trabalhar com datas e horários.
- Executar cálculos numéricos.
- Converter tipos de dados.
- Tratar valores nulos.
- Utilizar funções condicionais.
- Construir expressões compostas.
- Compreender diferenças entre funções e operadores.
- Identificar impactos de expressões sobre consultas e desempenho.

## 3. Conteúdo programático

### Tema 01 — Expressões SQL
- Conceito de expressão.
- Expressões aritméticas.
- Expressões lógicas.
- Expressões de comparação.
- Precedência de operadores.
- Expressões compostas.

### Tema 02 — Funções de texto
- UPPER e LOWER.
- INITCAP.
- LENGTH.
- TRIM, LTRIM e RTRIM.
- REPLACE.
- SUBSTRING.
- CONCAT e CONCAT_WS.
- POSITION.
- SPLIT_PART.

### Tema 03 — Funções numéricas
- ABS.
- ROUND.
- CEIL e FLOOR.
- MOD.
- POWER.
- SQRT.
- Operações com valores numéricos.

### Tema 04 — Funções de data e hora
- CURRENT_DATE.
- CURRENT_TIME.
- CURRENT_TIMESTAMP.
- EXTRACT.
- DATE_PART.
- DATE_TRUNC.
- AGE.
- Intervalos.
- Aritmética de datas.

### Tema 05 — Conversão de tipos
- CAST.
- Operador de conversão `::`.
- Conversões entre tipos.
- Conversões explícitas e implícitas.
- Problemas de incompatibilidade.

### Tema 06 — Tratamento de NULL
- COALESCE.
- NULLIF.
- Diferenças entre NULL e valores padrão.
- Aplicações em expressões.
- Cuidados com resultados desconhecidos.

### Tema 07 — Expressões condicionais
- CASE.
- WHEN.
- THEN.
- ELSE.
- END.
- CASE simples e pesquisado.
- Condições encadeadas.

### Tema 08 — Funções e expressões compostas
- Combinação de funções.
- Funções aninhadas.
- Expressões em SELECT.
- Expressões em WHERE.
- Expressões em ORDER BY.
- Construção de cálculos derivados.

### Tema 09 — Funções específicas do PostgreSQL
- GREATEST e LEAST.
- TO_CHAR.
- TO_DATE.
- TO_TIMESTAMP.
- FORMAT.
- Funções próprias do PostgreSQL.

### Tema 10 — Desempenho e boas práticas
- Custo de expressões.
- Funções aplicadas sobre colunas.
- Impactos sobre índices.
- Legibilidade.
- Reutilização de expressões.
- Análise com EXPLAIN.

## 4. Aplicação na TechStore

As demonstrações utilizarão situações próximas de um sistema comercial:

- Formatação de nomes de clientes.
- Padronização de textos.
- Cálculo de valores de produtos.
- Aplicação de descontos.
- Cálculo de intervalos entre datas.
- Classificação de pedidos.
- Tratamento de campos nulos.
- Construção de informações derivadas.
- Formatação de valores e datas.

## 5. Estrutura de aprendizagem

O módulo será dividido em explicações teóricas, demonstrações práticas, exercícios progressivos, desafios e validações independentes.

O estudante deverá demonstrar domínio antes de avançar para o módulo seguinte.

## 6. Critérios de domínio

- Correção lógica e resultados: 35%.
- Sintaxe e domínio SQL: 20%.
- Casos extremos e validação: 15%.
- Desempenho e otimização: 20%.
- Legibilidade e boas práticas: 10%.

Nota de referência para aprovação: 85%, sem erros críticos.

## 7. Arquivos do módulo

- README.md
- teoria.md
- atividades.md
- validacao.md
- consultas.sql

## 8. Pré-requisitos

- Módulo 01 — Fundamentos e domínio do ambiente PostgreSQL.
- Módulo 02 — SELECT e filtros.

## 9. Resultado esperado

Ao concluir este módulo, o estudante deverá conseguir construir consultas que não apenas recuperem dados, mas também transformem, calculem, formatem e interpretem informações diretamente no PostgreSQL.

**Status:** Documentação em preparação. Aulas ainda não iniciadas.