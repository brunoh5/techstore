# Módulo 04 — Agregações SQL

## 1. Apresentação

O Módulo 04 apresenta as operações de agregação do SQL, fundamentais para transformar grandes volumes de registros em informações resumidas e indicadores analíticos.

Até este momento, o estudante aprendeu a consultar registros, filtrar informações, manipular valores e construir expressões utilizando funções SQL.

Agora, o foco será analisar conjuntos de registros e produzir resultados consolidados.

Na TechStore, essas operações permitirão responder perguntas como:

- Qual é o faturamento total dos pedidos?
- Quantos pedidos foram realizados?
- Qual é o valor médio dos pedidos?
- Quais produtos possuem maior volume de vendas?
- Qual é o faturamento de cada mês?
- Quantos clientes realizaram pedidos?
- Qual é o valor médio das vendas por categoria?
- Quais departamentos possuem mais funcionários?

O objetivo é desenvolver a capacidade de construir consultas analíticas corretas, eficientes e confiáveis.

---

## 2. Objetivos do módulo

Ao concluir este módulo, o estudante deverá ser capaz de:

1. Compreender o funcionamento das funções de agregação.
2. Calcular totais, médias, quantidades, mínimos e máximos.
3. Agrupar registros utilizando `GROUP BY`.
4. Filtrar grupos utilizando `HAVING`.
5. Diferenciar filtros de registros e filtros de grupos.
6. Combinar agregações com expressões e funções SQL.
7. Compreender o comportamento de `NULL` nas agregações.
8. Utilizar agregações distintas.
9. Construir indicadores e relatórios analíticos.
10. Validar os resultados das consultas.
11. Identificar problemas de desempenho em consultas agregadas.
12. Interpretar planos de execução relacionados a agregações.

---

## 3. Conteúdo programático

O módulo será dividido em 12 temas principais.

### Tema 01 — Fundamentos de agregação

- Conceito de agregação.
- Diferença entre registros individuais e resultados consolidados.
- Funcionamento das funções agregadoras.
- Aplicações em análises de dados.
- Relação entre agregações e indicadores.

### Tema 02 — COUNT

- Funcionamento de `COUNT(*)`.
- Funcionamento de `COUNT(coluna)`.
- Contagem de valores não nulos.
- Contagem de valores distintos.
- Diferenças entre as formas de contagem.

### Tema 03 — SUM

- Soma de valores numéricos.
- Aplicação em valores financeiros.
- Soma de quantidades.
- Comportamento diante de valores `NULL`.
- Cuidados com duplicidades e resultados incorretos.

### Tema 04 — AVG

- Cálculo de médias.
- Média aritmética.
- Comportamento diante de valores `NULL`.
- Diferença entre média simples e média ponderada.
- Interpretação de médias em análises comerciais.

### Tema 05 — MIN e MAX

- Identificação do menor valor.
- Identificação do maior valor.
- Aplicação em valores numéricos.
- Aplicação em datas.
- Aplicação em textos.
- Comportamento diante de valores `NULL`.

### Tema 06 — GROUP BY

- Conceito de agrupamento.
- Agrupamento por uma coluna.
- Agrupamento por múltiplas colunas.
- Agrupamento utilizando expressões.
- Relação entre colunas selecionadas e agrupadas.
- Regras do PostgreSQL para agrupamentos.

### Tema 07 — HAVING

- Conceito de filtragem de grupos.
- Diferenças entre `WHERE` e `HAVING`.
- Condições sobre resultados agregados.
- Combinação de `WHERE`, `GROUP BY` e `HAVING`.
- Aplicações em relatórios analíticos.

### Tema 08 — Agregações com DISTINCT

- `COUNT(DISTINCT coluna)`.
- `SUM(DISTINCT coluna)`.
- Diferença entre agregação comum e distinta.
- Impactos de valores repetidos.
- Cuidados para não distorcer indicadores.

### Tema 09 — Agregações condicionais

- Utilização de `CASE` dentro de agregações.
- Contagens condicionais.
- Somas condicionais.
- Indicadores segmentados.
- Utilização da cláusula `FILTER`.
- Comparação entre estratégias de agregação condicional.

### Tema 10 — Agregações compostas

- Combinação de diferentes funções agregadoras.
- Agregações com expressões matemáticas.
- Agregações com funções SQL.
- Indicadores derivados.
- Médias ponderadas.
- Construção de relatórios com múltiplas métricas.

### Tema 11 — Agregações e análise de dados

- Indicadores comerciais.
- Análise de vendas.
- Análise de clientes.
- Análise de produtos.
- Análise de estoque.
- Análise temporal.
- Interpretação de resultados consolidados.
- Identificação de erros de interpretação estatística.

### Tema 12 — Desempenho e otimização

- Funcionamento básico de operações agregadoras.
- Introdução aos nós de agregação nos planos de execução.
- `HashAggregate`.
- `GroupAggregate`.
- `EXPLAIN`.
- `EXPLAIN ANALYZE`.
- `BUFFERS`.
- Impacto de filtros e agrupamentos.
- Custos de agregações sobre grandes volumes de dados.

---

## 4. Aplicação prática na TechStore

Os conhecimentos serão aplicados diretamente nas tabelas existentes no banco.

| Tabela                | Possibilidades de análise                      |
| --------------------- | ---------------------------------------------- |
| clientes              | Quantidade e distribuição de clientes          |
| produtos              | Preços, custos e quantidade de produtos        |
| estoque               | Quantidades disponíveis e níveis de estoque    |
| pedidos               | Volume e valores de pedidos                    |
| itens_pedido          | Quantidades e valores comercializados          |
| pagamentos            | Valores e distribuição de pagamentos           |
| entregas              | Quantidade e situação das entregas             |
| funcionarios          | Distribuição por departamento e salários       |
| avaliacoes            | Médias e distribuição de notas                 |
| acessos               | Volume de acessos e comportamento de navegação |
| movimentacoes_estoque | Quantidade de movimentações por tipo           |
| logs_sistema          | Volume de ocorrências por nível e módulo       |

Os exercícios utilizarão os dados reais da seed, incluindo tabelas com centenas de milhares e milhões de registros.

Isso permitirá observar não apenas a correção dos resultados, mas também o comportamento das agregações em volumes relevantes.

---

## 5. Organização dos arquivos

A pasta deste módulo deverá conter:

```text
modulo-04-agregacoes/
├── README.md
├── teoria.md
├── atividades.md
├── validacao.md
└── consultas.sql
```

### README.md

Documento atual.

Apresenta o módulo, seus objetivos, conteúdos e critérios gerais.

### teoria.md

Material didático com explicações, sintaxe, exemplos, comparações e referências oficiais.

### atividades.md

Exercícios progressivos para desenvolver domínio das agregações.

### validacao.md

Testes independentes, critérios de aprovação e desafios profissionais.

### consultas.sql

Laboratório de consultas demonstrativas para execução no pgAdmin.

---

## 6. Metodologia de aprendizagem

O módulo seguirá a metodologia Mastery Learning.

Cada tema será desenvolvido por meio de:

1. Explicação conceitual.
2. Apresentação da sintaxe.
3. Demonstração utilizando a TechStore.
4. Análise dos resultados.
5. Exercícios individuais.
6. Correção e discussão das soluções.
7. Validação independente.
8. Avaliação de domínio.

Os assuntos serão apresentados progressivamente, aumentando a complexidade conforme o estudante demonstrar domínio.

Não será necessário repetir assuntos já dominados, mas eventuais lacunas serão revisadas antes de avançar.

---

## 7. Critérios de desempenho

Neste módulo, além da correção lógica, será dada atenção especial ao custo das consultas agregadas.

Serão observados:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Tipo de operação de agregação.
- Uso de índices quando aplicável.
- Volume de registros processados.

Não será estabelecido um limite universal de tempo para todas as consultas.

O desempenho será avaliado considerando o volume de dados, a complexidade da consulta e o objetivo da operação.

---

## 8. Critérios de avaliação

A avaliação seguirá os critérios gerais do curso.

| Critério                     |     Peso |
| ---------------------------- | -------: |
| Correção lógica e resultados |      35% |
| Sintaxe e domínio SQL        |      20% |
| Casos extremos e validação   |      15% |
| Desempenho e otimização      |      20% |
| Legibilidade e boas práticas |      10% |
| **Total**                    | **100%** |

Nota mínima de aprovação: **85%**.

Erros críticos de lógica ou interpretação dos resultados impedem a aprovação, mesmo quando a consulta executa corretamente.

---

## 9. Pré-requisitos

Para iniciar este módulo, é importante dominar:

- SELECT e FROM.
- WHERE.
- DISTINCT.
- ORDER BY.
- Expressões matemáticas.
- Funções SQL.
- CASE.
- Tratamento de NULL.
- EXPLAIN básico.

Esses conhecimentos foram trabalhados nos módulos anteriores.

---

## 10. Resultados esperados

Ao concluir o Módulo 04, o estudante deverá conseguir:

- Construir consultas com funções agregadoras.
- Agrupar registros por diferentes critérios.
- Filtrar grupos corretamente.
- Construir indicadores comerciais.
- Calcular médias e totais com precisão.
- Identificar distorções causadas por duplicidades.
- Interpretar corretamente valores ausentes.
- Validar resultados agregados de forma independente.
- Analisar o desempenho de consultas sobre grandes volumes de dados.

---

## 11. Próximo módulo

Após a aprovação, o estudante estará preparado para o:

**Módulo 05 — JOINs**

Nesse módulo, aprenderá a combinar informações de diferentes tabelas, construindo consultas relacionais mais completas e análises que utilizam dados de múltiplas entidades.

---

## 12. Status do módulo

- [x] README.md
- [ ] teoria.md
- [ ] atividades.md
- [ ] validacao.md
- [ ] consultas.sql
- [ ] Aulas concluídas
- [ ] Avaliação aprovada

**Status atual:** Documentação em preparação. As aulas ainda não foram iniciadas.
