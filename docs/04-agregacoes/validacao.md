# Validação — Módulo 04: Agregações SQL

## 1. Objetivo da validação

Este documento define como será verificado o domínio dos conteúdos do Módulo 04.

A validação não consiste apenas em verificar se uma consulta executa sem erros. É necessário demonstrar que os resultados estão corretos, que os agrupamentos representam o problema proposto e que as consultas tratam adequadamente situações especiais.

A validação será realizada no PostgreSQL da TechStore, utilizando consultas somente de leitura.

**Nenhuma tabela, registro, índice ou configuração do banco principal deverá ser alterada.**

---

## 2. Conteúdos avaliados

| Código | Competência | Conteúdos |
|---|---|---|
| VAL-01 | Contagem | COUNT(*), COUNT(coluna), COUNT(DISTINCT) |
| VAL-02 | Soma | SUM e tratamento de NULL |
| VAL-03 | Média | AVG e média ponderada |
| VAL-04 | Extremos | MIN e MAX |
| VAL-05 | Agrupamento | GROUP BY |
| VAL-06 | Agrupamento composto | GROUP BY com múltiplas colunas |
| VAL-07 | Filtragem de grupos | HAVING |
| VAL-08 | Filtragem combinada | WHERE e HAVING |
| VAL-09 | Distinção | DISTINCT em agregações |
| VAL-10 | Condicionais | CASE e FILTER |
| VAL-11 | Consultas compostas | Agregações em diferentes etapas |
| VAL-12 | Análise de dados | Indicadores e interpretação |
| VAL-13 | Desempenho | EXPLAIN e EXPLAIN ANALYZE |

---

## 3. Testes de conhecimento e domínio

### VAL-01 — Contagem de registros

Verificar se o estudante consegue:

- Diferenciar COUNT(*) de COUNT(coluna).
- Identificar como valores NULL afetam a contagem.
- Contar valores distintos.
- Explicar a diferença entre quantidade de registros e quantidade de valores únicos.

**Critério de aprovação:** demonstrar domínio das três formas de contagem e interpretar corretamente seus resultados.

### VAL-02 — Soma e valores NULL

Verificar se o estudante consegue:

- Calcular somas de valores numéricos.
- Entender o comportamento de SUM diante de NULL.
- Diferenciar uma soma sem registros de uma soma com valores.
- Interpretar corretamente resultados agregados.

**Critério de aprovação:** não confundir ausência de registros, valores NULL e resultado numérico zero.

### VAL-03 — Média e média ponderada

Verificar se o estudante consegue:

- Calcular médias aritméticas.
- Identificar quando uma média simples não representa adequadamente o conjunto.
- Construir uma média ponderada.
- Explicar a diferença entre média de preços e preço médio ponderado por quantidade.

**Critério de aprovação:** selecionar o método adequado para cada situação e justificar a escolha.

### VAL-04 — Valores mínimos e máximos

Verificar se o estudante consegue:

- Utilizar MIN e MAX.
- Trabalhar com valores numéricos e datas.
- Interpretar extremos dentro de um conjunto.
- Identificar o comportamento dessas funções diante de NULL.

**Critério de aprovação:** produzir resultados corretos e explicar o significado dos valores encontrados.

### VAL-05 — GROUP BY

Verificar se o estudante consegue:

- Agrupar registros por uma coluna.
- Agrupar por múltiplas colunas.
- Combinar agrupamentos com funções agregadas.
- Entender a diferença entre resultado individual e resultado agrupado.

**Critério de aprovação:** construir agrupamentos corretos, sem misturar informações incompatíveis com o nível de agrupamento.

### VAL-06 — Agrupamentos compostos

Verificar se o estudante consegue:

- Agrupar por duas ou mais dimensões.
- Identificar quando a granularidade do resultado muda.
- Evitar agrupamentos desnecessários.
- Explicar quantas dimensões estão representadas no resultado.

**Critério de aprovação:** demonstrar compreensão da granularidade e da estrutura dos resultados.

### VAL-07 — HAVING

Verificar se o estudante consegue:

- Filtrar grupos após a agregação.
- Utilizar condições com funções agregadas.
- Diferenciar filtros de registros e filtros de grupos.
- Interpretar corretamente grupos que não atendem à condição.

**Critério de aprovação:** aplicar HAVING sem utilizar incorretamente WHERE para filtrar resultados agregados.

### VAL-08 — WHERE e HAVING

Verificar se o estudante consegue:

- Aplicar WHERE antes do agrupamento.
- Aplicar HAVING depois do agrupamento.
- Combinar os dois filtros.
- Explicar como a ordem lógica de processamento afeta o resultado.

**Critério de aprovação:** selecionar corretamente o local de cada condição e preservar a lógica da consulta.

### VAL-09 — DISTINCT em agregações

Verificar se o estudante consegue:

- Contar valores distintos.
- Diferenciar COUNT(*) de COUNT(DISTINCT coluna).
- Entender o efeito de DISTINCT em SUM.
- Reconhecer quando eliminar valores repetidos altera o significado do indicador.

**Critério de aprovação:** utilizar DISTINCT somente quando a regra de negócio exigir valores únicos.

### VAL-10 — Agregações condicionais

Verificar se o estudante consegue:

- Construir indicadores condicionais com CASE.
- Utilizar FILTER em funções agregadas.
- Produzir múltiplos indicadores em uma consulta.
- Comparar abordagens e identificar quando cada uma é adequada.

**Critério de aprovação:** gerar indicadores independentes e interpretar corretamente cada condição.

### VAL-11 — Agregações compostas

Verificar se o estudante consegue:

- Construir consultas com múltiplas métricas.
- Realizar agregações em etapas.
- Reconhecer quando uma subconsulta ou CTE será necessária.
- Evitar agregações aninhadas inválidas no mesmo nível de consulta.

**Critério de aprovação:** produzir consultas logicamente corretas e com granularidade bem definida.

### VAL-12 — Análise de dados

Verificar se o estudante consegue:

- Transformar resultados agregados em indicadores.
- Comparar grupos.
- Identificar padrões e diferenças.
- Explicar limitações de uma métrica.
- Evitar conclusões que não são sustentadas pelos dados.

**Critério de aprovação:** interpretar os resultados com precisão, sem confundir correlação, quantidade, média ou total.

### VAL-13 — Desempenho

Verificar se o estudante consegue:

- Executar EXPLAIN.
- Executar EXPLAIN ANALYZE.
- Interpretar os nós HashAggregate e GroupAggregate quando presentes.
- Identificar diferenças entre estimativas e linhas reais.
- Observar tempo de planejamento e execução.
- Analisar buffers compartilhados.

**Critério de aprovação:** explicar o plano de execução e identificar possíveis gargalos sem propor alterações injustificadas.

---

## 4. Validação independente dos resultados

Além de executar as consultas, o estudante deverá verificar se os resultados são confiáveis.

Os seguintes controles serão utilizados durante a avaliação:

### 4.1 Contagem

- Conferir a quantidade total de registros.
- Comparar contagens totais e contagens de valores não nulos.
- Verificar contagens distintas.
- Identificar possíveis duplicidades.

### 4.2 Soma

- Conferir se a soma corresponde ao conjunto esperado.
- Verificar se valores NULL foram tratados corretamente.
- Comparar somas de grupos com o total geral, quando a partição permitir essa reconciliação.

### 4.3 Média

- Conferir se o denominador utilizado representa a população correta.
- Comparar média simples e ponderada.
- Verificar possíveis divisões por zero.

### 4.4 Agrupamentos

- Verificar se os grupos representam corretamente os registros.
- Conferir se não existem grupos inesperados.
- Comparar a soma das quantidades agrupadas com a quantidade total, quando os grupos forem mutuamente exclusivos e cobrirem todo o conjunto.

### 4.5 HAVING

- Verificar se os grupos eliminados realmente não atendem à condição.
- Conferir limites e condições de igualdade.
- Testar resultados vazios.

### 4.6 Agregações condicionais

- Verificar se as condições são mutuamente exclusivas quando deveriam ser.
- Conferir se todos os registros foram classificados.
- Identificar registros que não se enquadram em nenhuma condição.

### 4.7 Consultas compostas

- Conferir se cada etapa preserva a granularidade correta.
- Comparar resultados intermediários com o resultado final.
- Verificar se não há dupla contagem.

**Importante:** uma consulta pode retornar resultados aparentemente plausíveis e ainda estar incorreta. A validação independente é obrigatória.

---

## 5. Avaliação prática

A avaliação prática será baseada em tarefas semelhantes às atividades do arquivo `atividades.md`, mas não necessariamente idênticas.

O estudante deverá demonstrar que consegue resolver problemas novos utilizando os conceitos aprendidos.

### Etapa A — Fundamentos

- Criar indicadores com COUNT, SUM, AVG, MIN e MAX.
- Diferenciar contagens totais, não nulas e distintas.
- Interpretar resultados agregados.

### Etapa B — Agrupamentos

- Agrupar dados por uma dimensão.
- Agrupar dados por múltiplas dimensões.
- Combinar agrupamentos com diferentes funções agregadas.

### Etapa C — Filtragem

- Filtrar registros antes da agregação.
- Filtrar grupos após a agregação.
- Combinar WHERE e HAVING corretamente.

### Etapa D — Indicadores condicionais

- Criar indicadores com CASE.
- Criar indicadores com FILTER.
- Comparar os resultados das duas abordagens.

### Etapa E — Consultas compostas

- Construir consultas com múltiplas métricas.
- Realizar agregações em etapas.
- Evitar dupla contagem e erros de granularidade.

### Etapa F — Desempenho

- Analisar consultas com EXPLAIN ANALYZE.
- Interpretar os principais nós do plano.
- Comparar consultas equivalentes quando solicitado.

---

## 6. Desafio de domínio

O desafio final será construir um conjunto de indicadores gerenciais para a TechStore.

O problema será apresentado durante a avaliação, sem fornecer a consulta pronta.

O estudante deverá demonstrar que consegue:

1. Interpretar os requisitos do problema.
2. Identificar as tabelas e colunas necessárias.
3. Determinar a granularidade dos resultados.
4. Selecionar as funções agregadas adequadas.
5. Construir agrupamentos coerentes.
6. Aplicar filtros no momento correto.
7. Criar indicadores condicionais.
8. Validar os resultados independentemente.
9. Analisar o desempenho das consultas.
10. Explicar as decisões tomadas.

**Restrição:** o desafio deverá ser resolvido com os conceitos estudados até o Módulo 04. JOINs ainda não fazem parte do conteúdo exigido.

---

## 7. Critérios de avaliação

A avaliação seguirá os pesos definidos para o curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### Nota mínima

A referência para aprovação é **85%**.

Entretanto, a nota não será suficiente caso existam erros críticos, como:

- Indicadores calculados incorretamente.
- Dupla contagem não identificada.
- Agrupamentos com granularidade inadequada.
- Interpretação incorreta de NULL.
- Uso inadequado de filtros que altera o resultado.
- Conclusões incompatíveis com os dados.

Erros críticos deverão ser corrigidos antes da liberação do próximo módulo.

---

## 8. Diagnóstico de dificuldades

Quando uma competência não for dominada, será realizado um reforço direcionado.

| Dificuldade identificada | Conteúdo para revisar |
|---|---|
| Contagens incorretas | COUNT e NULL |
| Somas inconsistentes | SUM e granularidade |
| Médias incorretas | AVG e média ponderada |
| Grupos incorretos | GROUP BY |
| Filtros inadequados | WHERE e HAVING |
| Valores duplicados | DISTINCT |
| Indicadores condicionais incorretos | CASE e FILTER |
| Dupla contagem | Agregações compostas |
| Dificuldade com desempenho | EXPLAIN e nós de agregação |

O objetivo é corrigir a lacuna específica sem exigir que o estudante repita conteúdos já dominados.

---

## 9. Registro de progresso

Ao concluir a avaliação, o resultado deverá ser registrado.

| Competência | Status | Observações |
|---|---|---|
| COUNT | Pendente | |
| SUM | Pendente | |
| AVG | Pendente | |
| MIN e MAX | Pendente | |
| GROUP BY | Pendente | |
| Agrupamentos compostos | Pendente | |
| HAVING | Pendente | |
| WHERE e HAVING | Pendente | |
| DISTINCT | Pendente | |
| CASE e FILTER | Pendente | |
| Agregações compostas | Pendente | |
| Análise de dados | Pendente | |
| Desempenho | Pendente | |

Estados possíveis:

- Pendente
- Em desenvolvimento
- Dominado
- Necessita reforço

### Resultado final

- Nota:
- Data:
- Competências dominadas:
- Competências que precisam de reforço:
- Erros críticos identificados:
- Desafio final concluído:
- Status do módulo:

---

## 10. Condições para liberação do Módulo 05

O próximo módulo será liberado quando:

- [ ] Todas as competências essenciais estiverem dominadas.
- [ ] A nota mínima de referência de 85% for alcançada.
- [ ] Não existirem erros críticos pendentes.
- [ ] O desafio de domínio estiver concluído.
- [ ] Os resultados tiverem sido validados independentemente.
- [ ] O estudante conseguir explicar suas consultas.

O Módulo 05 abordará **JOINs**, permitindo combinar informações de diferentes tabelas e ampliar as análises realizadas até aqui.

---

## 11. Segurança e preservação do banco

Durante todas as validações:

- Utilizar consultas somente de leitura.
- Não executar INSERT, UPDATE ou DELETE.
- Não criar, alterar ou remover tabelas.
- Não criar ou remover índices.
- Não modificar configurações do PostgreSQL.
- Não executar novamente a seed.
- Não apagar ou recriar o banco.

O banco TechStore deverá permanecer preservado para os módulos seguintes.

---

## 12. Status do documento

| Item | Status |
|---|---|
| Critérios de validação | Definidos |
| Competências avaliadas | Definidas |
| Avaliação prática | Planejada |
| Desafio de domínio | Planejado |
| Critérios de aprovação | Definidos |
| Validação pelo estudante | Pendente |
| Avaliação do módulo | Não iniciada |

**Este documento define como o domínio será avaliado. A avaliação propriamente dita acontecerá durante as aulas, após o estudo da teoria e a realização das atividades.**