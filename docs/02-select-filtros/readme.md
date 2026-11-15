# Módulo 02 — SELECT e filtros

## 1. Apresentação

O Módulo 02 inicia o desenvolvimento prático da linguagem SQL por meio da recuperação e consulta de informações armazenadas no banco de dados.

O estudante aprenderá a construir consultas utilizando `SELECT`, selecionar colunas específicas, filtrar registros, combinar condições e controlar a ordenação e a quantidade de resultados retornados.

A TechStore será utilizada como ambiente principal de aprendizagem, permitindo trabalhar com dados reais de um banco de dados relacional de grande volume.

Este módulo estabelece a base necessária para os próximos conteúdos, especialmente funções SQL, agregações, JOINs, subconsultas e otimização de consultas.

**Nível:** Professional  
**Progressão:** Mastery Learning  
**SGBD:** PostgreSQL 16  
**Banco:** TechStore

---

## 2. Objetivos de aprendizagem

Ao concluir o módulo, o estudante deverá ser capaz de:

1. Construir consultas SQL utilizando `SELECT`.
2. Selecionar colunas específicas de uma tabela.
3. Compreender a diferença entre selecionar todas as colunas e selecionar apenas as necessárias.
4. Eliminar resultados duplicados utilizando `DISTINCT`.
5. Filtrar registros com `WHERE`.
6. Utilizar operadores de comparação.
7. Combinar condições com `AND`, `OR` e `NOT`.
8. Trabalhar com intervalos e conjuntos utilizando `BETWEEN` e `IN`.
9. Realizar pesquisas textuais utilizando `LIKE` e `ILIKE`.
10. Identificar e filtrar valores nulos.
11. Ordenar resultados com `ORDER BY`.
12. Controlar a quantidade de registros com `LIMIT` e `OFFSET`.
13. Construir consultas com múltiplas condições.
14. Interpretar corretamente os resultados retornados.
15. Identificar erros lógicos em filtros.
16. Avaliar o comportamento e o desempenho básico de consultas.

---

## 3. Pré-requisitos

Antes de iniciar, o estudante deverá compreender:

- O funcionamento básico do PostgreSQL.
- A organização de bancos, schemas e tabelas.
- Colunas e tipos de dados.
- Chaves primárias e estrangeiras.
- Constraints.
- A utilização do pgAdmin.
- A estrutura geral do banco TechStore.

Os conhecimentos foram introduzidos no Módulo 01.

---

## 4. Conteúdo programático

O módulo será dividido em 12 temas.

### Tema 01 — Introdução ao SELECT

- Finalidade do SELECT.
- Estrutura básica de uma consulta.
- Cláusula SELECT.
- Cláusula FROM.
- Seleção de todas as colunas.
- Seleção de colunas específicas.
- Identificação de resultados.

### Tema 02 — DISTINCT

- Eliminação de duplicidades.
- DISTINCT em uma coluna.
- DISTINCT em múltiplas colunas.
- Diferença entre registros únicos e combinações únicas.
- Comportamento de NULL.

### Tema 03 — WHERE

- Finalidade da filtragem.
- Estrutura da cláusula WHERE.
- Filtragem de registros.
- Condições simples.
- Condições compostas.

### Tema 04 — Operadores de comparação

- Igualdade.
- Diferença.
- Maior que.
- Menor que.
- Maior ou igual.
- Menor ou igual.
- Comparações entre diferentes tipos de dados.
- Cuidados com datas e valores numéricos.

### Tema 05 — Operadores lógicos

- AND.
- OR.
- NOT.
- Combinação de condições.
- Precedência dos operadores.
- Utilização de parênteses.
- Identificação de erros lógicos.

### Tema 06 — IN e BETWEEN

- Operador IN.
- Operador NOT IN.
- Operador BETWEEN.
- Operador NOT BETWEEN.
- Intervalos numéricos.
- Intervalos de datas.
- Inclusividade dos limites.
- Cuidados com valores NULL.

### Tema 07 — LIKE e ILIKE

- Pesquisa textual.
- Utilização de `%`.
- Utilização de `_`.
- Diferença entre LIKE e ILIKE.
- Pesquisa por prefixos.
- Pesquisa por sufixos.
- Pesquisa por trechos de texto.
- Considerações sobre desempenho.

### Tema 08 — Tratamento de NULL

- Significado de NULL.
- Diferença entre NULL e valores vazios.
- IS NULL.
- IS NOT NULL.
- Comportamento de NULL em comparações.
- Lógica de três valores do SQL.
- Erros frequentes em filtros com NULL.

### Tema 09 — ORDER BY

- Ordenação crescente.
- Ordenação decrescente.
- Ordenação por múltiplas colunas.
- Ordenação por expressões.
- ASC e DESC.
- NULLS FIRST e NULLS LAST.
- Importância da ordenação determinística.

### Tema 10 — LIMIT e OFFSET

- Limitação de resultados.
- Paginação básica.
- Combinação com ORDER BY.
- Diferença entre LIMIT e OFFSET.
- Cuidados com paginação em grandes tabelas.
- Estabilidade dos resultados.

### Tema 11 — Construção de consultas compostas

- Combinação de SELECT, WHERE e ORDER BY.
- Múltiplas condições.
- Filtros numéricos e textuais.
- Filtros temporais.
- Consultas com diferentes critérios.
- Leitura e interpretação de consultas maiores.

### Tema 12 — Diagnóstico e desempenho básico

- Identificação de filtros incorretos.
- Diferença entre resultado vazio e consulta incorreta.
- Análise da quantidade de registros retornados.
- Primeira utilização do EXPLAIN.
- Introdução ao EXPLAIN ANALYZE.
- Noções iniciais de leitura de planos.
- Impacto de filtros e ordenações.
- Diferença entre correção lógica e eficiência.

---

## 5. Aplicação prática na TechStore

Todas as atividades utilizarão as tabelas existentes no banco TechStore.

As principais tabelas utilizadas serão:

| Tabela | Contexto de utilização |
|---|---|
| produtos | Consultas de produtos e características |
| categorias | Consultas por categoria |
| marcas | Consultas por fabricante |
| clientes | Pesquisa de clientes |
| pedidos | Filtragem por datas e informações de pedidos |
| itens_pedido | Consulta de itens comercializados |
| pagamentos | Pesquisa de pagamentos |
| entregas | Consulta de informações logísticas |
| acessos | Consultas em uma tabela de grande volume |
| logs_sistema | Exploração de registros operacionais |

Outras tabelas poderão ser utilizadas conforme a necessidade dos exercícios.

### Cuidados com o ambiente

O banco TechStore já possui milhões de registros e deverá ser preservado.

Durante este módulo:

- Priorizar consultas SELECT.
- Não executar novamente o seed.
- Não modificar registros.
- Não modificar a estrutura das tabelas.
- Utilizar LIMIT durante explorações iniciais.
- Evitar consultas desnecessariamente repetitivas em tabelas grandes.

---

## 6. Metodologia de aprendizagem

O módulo utilizará a metodologia Mastery Learning.

Cada tema seguirá o seguinte processo:

1. Leitura da teoria.
2. Compreensão dos conceitos e operadores.
3. Consulta aos exemplos disponíveis.
4. Resolução individual das atividades.
5. Correção e análise das consultas.
6. Validação dos resultados.
7. Revisão direcionada quando necessário.
8. Avaliação de domínio.

O estudante terá liberdade para estudar a documentação no próprio ritmo.

O acompanhamento será realizado durante a resolução das atividades, com explicações, diagnóstico de erros e orientação sobre boas práticas.

### Política de entrega de código

As soluções não serão entregues antecipadamente.

O estudante deverá desenvolver suas próprias consultas. Quando houver erros, receberá orientações progressivas para identificar e corrigir os problemas.

Códigos completos poderão ser apresentados quando solicitados explicitamente ou quando forem necessários para uma demonstração didática.

---

## 7. Estrutura dos materiais

O diretório do módulo conterá:

| Arquivo | Finalidade |
|---|---|
| README.md | Apresentação e organização do módulo |
| teoria.md | Explicações detalhadas dos conteúdos |
| atividades.md | Exercícios progressivos |
| validacao.md | Testes e critérios objetivos de aprovação |
| consultas.sql | Exemplos demonstrativos e laboratório de consultas |

Cada arquivo terá uma finalidade específica, evitando repetição desnecessária de conteúdo.

---

## 8. Atividades práticas

As atividades serão organizadas progressivamente.

### Nível 1 — Fundamentos

- Consultas simples.
- Seleção de colunas.
- DISTINCT.
- Filtros básicos.
- Operadores de comparação.

### Nível 2 — Intermediário

- Combinação de condições.
- Operadores lógicos.
- IN e BETWEEN.
- LIKE e ILIKE.
- Tratamento de NULL.

### Nível 3 — Avançado

- Ordenação múltipla.
- Paginação.
- Consultas compostas.
- Combinação de diferentes critérios.
- Diagnóstico de resultados.

### Nível 4 — Desafios profissionais

- Consultas com requisitos detalhados.
- Filtros com múltiplas regras de negócio.
- Identificação de erros lógicos.
- Análise de consultas alternativas.
- Consultas em tabelas com grande volume de registros.
- Avaliação de desempenho.

A dificuldade será aumentada conforme o domínio demonstrado.

---

## 9. Validação independente

A validação não dependerá exclusivamente da avaliação do professor.

Sempre que possível, os exercícios terão resultados esperados verificáveis diretamente no PostgreSQL.

Serão utilizados:

- Quantidade de registros retornados.
- Valores esperados.
- Comparação entre conjuntos de resultados.
- Verificação de duplicidades.
- Identificação de registros ausentes.
- Casos com NULL.
- Resultados vazios.
- Limites de intervalos.
- Empates na ordenação.
- Casos extremos.

O estudante também deverá explicar por que sua consulta retorna o resultado esperado.

---

## 10. Desempenho e análise de consultas

O módulo introduzirá os primeiros conceitos de desempenho.

Serão observados:

| Métrica | Finalidade |
|---|---|
| Execution Time | Tempo de execução |
| Planning Time | Tempo de planejamento |
| Actual Rows | Registros efetivamente processados ou retornados pelo nó |
| Estimated Rows | Estimativa de registros do planejador |
| Node Type | Operação utilizada no plano |
| Shared Hit Blocks | Blocos encontrados no cache compartilhado |
| Shared Read Blocks | Blocos lidos do armazenamento |

O objetivo não será realizar otimizações avançadas neste módulo, mas começar a compreender como o PostgreSQL executa consultas.

Não haverá um limite universal de tempo para aprovação. O desempenho será analisado considerando a tabela, a consulta, o volume de dados e as condições de execução.

---

## 11. Critérios de avaliação

A avaliação seguirá o padrão definido no curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### Aprovação

- Nota mínima de referência: 85%.
- Ausência de erros críticos de lógica.
- Capacidade de explicar as consultas.
- Validação dos resultados.
- Demonstração de autonomia.

A avaliação poderá exigir revisão direcionada antes da liberação do próximo módulo.

---

## 12. Competências esperadas ao concluir o módulo

Ao final, o estudante deverá conseguir:

- Consultar qualquer tabela da TechStore.
- Selecionar somente as informações necessárias.
- Construir filtros simples e complexos.
- Combinar operadores corretamente.
- Pesquisar textos e intervalos.
- Tratar valores NULL.
- Ordenar resultados corretamente.
- Controlar a quantidade de registros retornados.
- Identificar erros em consultas.
- Interpretar resultados vazios e inesperados.
- Realizar uma análise básica de desempenho.
- Construir consultas SQL legíveis e confiáveis.

---

## 13. Preparação para o Módulo 03

O próximo módulo será:

**Módulo 03 — Expressões e funções SQL**

Os conhecimentos adquiridos aqui serão utilizados para trabalhar com:

- Funções de texto.
- Funções numéricas.
- Funções de data e hora.
- Conversões de tipos.
- CASE.
- COALESCE.
- NULLIF.
- Expressões condicionais.
- Manipulação e transformação de dados.

---

## 14. Estado do módulo

| Informação | Estado |
|---|---|
| Documentação | Em preparação |
| Teoria | Pendente |
| Atividades | Pendente |
| Validação | Pendente |
| Consultas demonstrativas | Pendente |
| Aulas | Não iniciadas |
| Avaliação | Não realizada |

**O módulo será considerado concluído somente após a demonstração prática das competências estabelecidas.**