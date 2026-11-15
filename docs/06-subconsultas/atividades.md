# Atividades — Módulo 06: Subconsultas SQL

## 1. Objetivo

Este documento contém os exercícios práticos do Módulo 06 — Subconsultas.

O objetivo é desenvolver a capacidade de resolver problemas utilizando consultas dentro de outras consultas, compreendendo os diferentes tipos de subconsultas e suas aplicações no PostgreSQL.

As atividades utilizam o banco TechStore e deverão ser realizadas de maneira independente.

**Importante:** este documento apresenta os problemas e os critérios esperados, mas não fornece as consultas prontas.

---

# 2. Orientações gerais

Durante a realização das atividades:

- Utilize somente `SELECT`.
- Não altere os dados do banco.
- Não execute novamente o seed.
- Utilize o schema real da TechStore.
- Utilize aliases claros.
- Identifique se a subconsulta é correlacionada ou não correlacionada.
- Observe a quantidade de linhas retornadas.
- Considere o comportamento de `NULL`.
- Não utilize `DISTINCT` para esconder duplicações.
- Valide os resultados com consultas independentes.
- Analise o desempenho quando solicitado.

### Organização das respostas

Para cada atividade, registre:

1. Número da atividade.
2. Consulta SQL desenvolvida.
3. Explicação da lógica utilizada.
4. Tipo de subconsulta.
5. Resultado obtido.
6. Método utilizado para validar o resultado.
7. Observações sobre desempenho, quando aplicável.

---

# 3. Nível 1 — Fundamentos

Objetivo: compreender a estrutura de subconsultas e trabalhar com resultados escalares e conjuntos de valores.

### AT-01 — Produtos acima da média

Identifique todos os produtos cujo preço seja superior à média geral de preços dos produtos.

Requisitos:
- Utilizar uma subconsulta escalar.
- Calcular a média dentro da consulta interna.
- Apresentar identificador, nome e preço.
- Ordenar do maior para o menor preço.

### AT-02 — Produtos abaixo da média

Identifique produtos cujo preço seja inferior à média geral.

Requisitos:
- Utilizar subconsulta escalar.
- Apresentar nome, preço e diferença em relação à média.
- Ordenar pela diferença de preço.

### AT-03 — Clientes com pedidos

Retorne os clientes que possuem pelo menos um pedido.

Requisitos:
- Utilizar `IN`.
- A consulta interna deverá obter os identificadores dos clientes presentes em pedidos.
- Apresentar identificador, nome e e-mail.

### AT-04 — Produtos sem vendas

Identifique produtos que nunca aparecem em `itens_pedido`.

Requisitos:
- Utilizar `NOT IN`.
- Investigar se a coluna utilizada na subconsulta permite valores `NULL`.
- Comparar o comportamento com outra estratégia posteriormente.

### AT-05 — Produtos com preço máximo

Identifique todos os produtos que possuem o maior preço cadastrado.

Requisitos:
- Utilizar `MAX`.
- Utilizar subconsulta escalar.
- Considerar a possibilidade de empate.
- Não limitar o resultado a apenas um produto.

### AT-06 — Produtos com preço mínimo

Identifique todos os produtos que possuem o menor preço cadastrado.

Requisitos:
- Utilizar `MIN`.
- Apresentar identificador, nome e preço.
- Considerar a possibilidade de empate.

### AT-07 — Clientes com muitos pedidos

Identifique clientes que possuem mais de cinco pedidos.

Requisitos:
- Utilizar uma subconsulta com `GROUP BY` e `HAVING`.
- Utilizar o resultado para filtrar os clientes.
- Apresentar a quantidade de pedidos de cada cliente.

### AT-08 — Categorias utilizadas

Identifique categorias que possuem pelo menos um produto cadastrado.

Requisitos:
- Utilizar `IN`.
- Relacionar os identificadores de categorias com os produtos.
- Apresentar identificador e nome da categoria.

### AT-09 — Produtos de categorias específicas

Identifique produtos pertencentes às categorias que possuem mais de determinado número de produtos.

Requisitos:
- Utilizar uma subconsulta com agregação.
- Utilizar `GROUP BY`.
- Utilizar `HAVING`.
- Utilizar o resultado para filtrar os produtos.

### AT-10 — Funcionários com movimentações

Identifique funcionários que aparecem em `movimentacoes_estoque`.

Requisitos:
- Utilizar uma subconsulta.
- Apresentar identificador, nome e departamento.
- Não retornar funcionários sem correspondência na tabela de movimentações.

---

# 4. Nível 2 — Operadores e existência

Objetivo: dominar `EXISTS`, `NOT EXISTS`, `IN`, `NOT IN`, `ANY` e `ALL`.

### AT-11 — Clientes com pedidos usando EXISTS

Reproduza o objetivo da AT-03 utilizando `EXISTS`.

Requisitos:
- Criar uma subconsulta correlacionada.
- Utilizar o identificador do cliente na condição de relacionamento.
- Retornar uma linha por cliente.

### AT-12 — Clientes sem pedidos

Identifique clientes que nunca realizaram pedidos.

Requisitos:
- Utilizar `NOT EXISTS`.
- Apresentar identificador, nome e e-mail.
- Não utilizar JOIN na consulta principal.

### AT-13 — Produtos sem avaliações

Identifique produtos que não possuem avaliações cadastradas.

Requisitos:
- Utilizar `NOT EXISTS`.
- Relacionar produtos com avaliações.
- Apresentar identificador, nome e preço.

### AT-14 — Produtos avaliados

Identifique produtos que possuem pelo menos uma avaliação.

Requisitos:
- Utilizar `EXISTS`.
- Não multiplicar os produtos quando houver várias avaliações.
- Apresentar identificador e nome.

### AT-15 — Comparação entre IN e EXISTS

Resolva o mesmo problema utilizando:

1. `IN`.
2. `EXISTS`.

Problema: identificar clientes que possuem pedidos.

Requisitos:
- Comparar a estrutura das consultas.
- Verificar se os resultados são equivalentes.
- Explicar as diferenças semânticas.
- Comparar os planos de execução.

### AT-16 — Comparação entre NOT IN e NOT EXISTS

Resolva o problema de identificar produtos sem vendas utilizando as duas estratégias.

Requisitos:
- Utilizar `NOT IN`.
- Utilizar `NOT EXISTS`.
- Verificar a possibilidade de `NULL` na coluna utilizada.
- Explicar se existe diferença nos resultados.
- Justificar qual abordagem considera mais segura.

### AT-17 — Produtos mais caros que algum produto de uma categoria

Identifique produtos cujo preço seja superior ao preço de pelo menos um produto de uma categoria selecionada.

Requisitos:
- Utilizar `ANY`.
- Utilizar uma subconsulta que retorne múltiplos preços.
- Explicar o significado da comparação.

### AT-18 — Produtos mais caros que todos os produtos de uma categoria

Identifique produtos cujo preço seja superior ao preço de todos os produtos de uma categoria selecionada.

Requisitos:
- Utilizar `ALL`.
- Explicar a diferença em relação à AT-17.
- Considerar o comportamento de conjuntos vazios e `NULL`.

### AT-19 — Pedidos de clientes com histórico de compras

Identifique pedidos pertencentes a clientes que possuem mais de um pedido registrado.

Requisitos:
- Utilizar uma subconsulta.
- Trabalhar com a tabela `pedidos`.
- Identificar corretamente a relação entre cliente e pedido.

### AT-20 — Funcionários sem movimentações

Identifique funcionários que não aparecem na tabela `movimentacoes_estoque`.

Requisitos:
- Utilizar `NOT EXISTS`.
- Considerar que `funcionario_id` pode ser NULL em movimentações.
- Não confundir uma movimentação sem funcionário associado com uma movimentação de um funcionário específico.

---

# 5. Nível 3 — Subconsultas correlacionadas

Objetivo: compreender como uma consulta interna pode depender de cada registro da consulta externa.

### AT-21 — Produtos acima da média da categoria

Identifique produtos cujo preço seja superior à média de preços de sua própria categoria.

Requisitos:
- Utilizar subconsulta correlacionada.
- Comparar produtos com outros produtos da mesma categoria.
- Apresentar categoria, produto e preço.

### AT-22 — Clientes acima da média de pedidos

Identifique clientes cuja quantidade de pedidos seja superior à média de pedidos por cliente.

Requisitos:
- Utilizar subconsulta correlacionada.
- Calcular a quantidade de pedidos por cliente.
- Comparar com uma média calculada independentemente.
- Definir claramente como clientes sem pedidos entram no cálculo da média.

### AT-23 — Produtos com mais vendas que a média

Identifique produtos cuja quantidade total de unidades vendidas seja superior à média de unidades vendidas por produto.

Requisitos:
- Trabalhar com `produtos` e `itens_pedido`.
- Utilizar subconsulta com agregação.
- Definir se produtos sem vendas participam da média.
- Explicar a escolha.

### AT-24 — Funcionários acima da média salarial

Identifique funcionários cujo salário seja superior à média salarial de seu departamento.

Requisitos:
- Utilizar subconsulta correlacionada.
- Relacionar funcionários com departamentos.
- Comparar salários dentro do mesmo departamento.

### AT-25 — Pedidos acima da média do cliente

Identifique pedidos cujo valor calculado dos itens seja superior à média dos valores dos pedidos do mesmo cliente.

Requisitos:
- Utilizar subconsultas correlacionadas.
- Calcular os valores a partir de `itens_pedido`.
- Agrupar os itens por pedido antes da comparação.
- Considerar que pedidos podem possuir vários itens.
- Não confundir valor dos itens com valor final do pedido.

Observação: neste exercício, o valor calculado considera quantidade multiplicada pelo preço unitário, sem incluir frete ou aplicar descontos adicionais.

### AT-26 — Clientes com compras superiores à média de sua região

Construa uma consulta que compare o total calculado dos itens comprados por cada cliente com a média de compras dos clientes de sua cidade.

Requisitos:
- Utilizar relacionamentos entre clientes, endereços, cidades e pedidos.
- Utilizar subconsulta correlacionada.
- Definir como clientes com múltiplos endereços serão tratados.
- Definir se clientes sem compras participam da média.
- Evitar multiplicação de valores causada por junções.

### AT-27 — Produtos com avaliações acima da média

Identifique produtos cuja nota média seja superior à média geral das avaliações.

Requisitos:
- Utilizar subconsulta correlacionada.
- Utilizar `AVG`.
- Considerar produtos sem avaliações.
- Diferenciar média geral de média por produto.

### AT-28 — Clientes com pedidos em diferentes períodos

Identifique clientes que possuem pedidos em mais de um mês distinto.

Requisitos:
- Utilizar subconsulta.
- Trabalhar com datas.
- Utilizar agrupamento.
- Comparar a quantidade de períodos distintos por cliente.

---

# 6. Nível 4 — Subconsultas avançadas

Objetivo: utilizar subconsultas em diferentes posições e combinar múltiplas etapas de processamento.

### AT-29 — Subconsulta no SELECT

Retorne os produtos com uma coluna adicional contendo a média geral dos preços.

Requisitos:
- Utilizar subconsulta no `SELECT`.
- Apresentar produto, preço e média geral.
- Não utilizar JOIN para calcular a média.

### AT-30 — Subconsulta correlacionada no SELECT

Retorne cada cliente acompanhado da quantidade de pedidos realizados.

Requisitos:
- Utilizar subconsulta no `SELECT`.
- Utilizar correlação.
- Preservar clientes sem pedidos.
- Retornar uma linha por cliente.

### AT-31 — Subconsulta no FROM

Construa uma tabela derivada que apresente a quantidade de unidades vendidas por produto.

Requisitos:
- Utilizar subconsulta no `FROM`.
- Agrupar os itens por produto.
- Apresentar o resultado ordenado por unidades vendidas.

### AT-32 — Agregação prévia

Construa uma consulta que calcule o total de itens por pedido antes de relacionar o resultado com a tabela `pedidos`.

Requisitos:
- Utilizar uma tabela derivada ou CTE.
- Preservar pedidos sem itens, caso existam.
- Evitar multiplicação de linhas.
- Identificar a granularidade do resultado.

### AT-33 — Subconsulta aninhada

Identifique produtos pertencentes a categorias cuja média de preços seja superior à média geral de preços dos produtos.

Requisitos:
- Utilizar pelo menos dois níveis de subconsulta.
- Utilizar agregações.
- Explicar a função de cada nível.
- Evitar cálculos redundantes.

### AT-34 — Subconsulta com HAVING

Identifique departamentos cuja média salarial seja superior à média salarial geral da empresa.

Requisitos:
- Utilizar `GROUP BY`.
- Utilizar `HAVING`.
- Utilizar uma subconsulta para calcular a média geral.
- Apresentar o nome do departamento e a média salarial.

### AT-35 — Subconsulta com múltiplas agregações

Construa uma consulta que apresente produtos acompanhados de:

- Quantidade de itens vendidos.
- Total de unidades vendidas.
- Preço médio praticado.
- Maior preço unitário registrado.

Requisitos:
- Utilizar uma subconsulta no `FROM` ou uma CTE.
- Agrupar por produto.
- Preservar a granularidade de uma linha por produto.
- Tratar produtos sem vendas.

---

# 7. Nível 5 — Comparação e desempenho

Objetivo: compreender que diferentes estruturas SQL podem representar a mesma regra de negócio, mas produzir planos de execução distintos.

### AT-36 — JOIN versus IN

Resolva o problema de identificar clientes que possuem pedidos utilizando:

1. INNER JOIN.
2. IN com subconsulta.

Requisitos:
- Comparar os resultados.
- Identificar a necessidade ou não de `DISTINCT`.
- Explicar a cardinalidade de cada estratégia.

### AT-37 — JOIN versus EXISTS

Resolva o problema de identificar clientes que possuem pedidos utilizando:

1. JOIN.
2. EXISTS.

Requisitos:
- Comparar as consultas.
- Explicar a diferença de granularidade.
- Verificar se ambas retornam o mesmo conjunto de clientes.
- Comparar os planos.

### AT-38 — LEFT JOIN versus NOT EXISTS

Identifique clientes sem pedidos utilizando as duas estratégias.

Requisitos:
- Verificar equivalência dos resultados.
- Explicar o papel de `IS NULL`.
- Utilizar uma chave não nula da tabela relacionada na verificação.
- Comparar os planos de execução.

### AT-39 — Subconsulta versus CTE

Resolva o cálculo de unidades vendidas por produto utilizando:

1. Subconsulta no `FROM`.
2. CTE com `WITH`.

Requisitos:
- Comparar legibilidade.
- Comparar resultados.
- Analisar os planos de execução.
- Explicar se existe diferença relevante.

### AT-40 — Análise de subconsulta correlacionada

Selecione uma consulta correlacionada desenvolvida anteriormente.

Requisitos:
- Executar `EXPLAIN`.
- Executar `EXPLAIN ANALYZE`.
- Identificar `SubPlan`, `InitPlan` ou outras operações relevantes, quando presentes.
- Observar `Actual Rows`, `Loops` e tempo.
- Explicar o plano.

### AT-41 — Otimização de consulta

Selecione um problema resolvido com subconsulta e desenvolva uma segunda versão utilizando outra estratégia.

Requisitos:
- Manter a mesma regra de negócio.
- Validar equivalência dos resultados.
- Medir as duas consultas.
- Comparar os planos.
- Justificar a estratégia escolhida.

### AT-42 — Diagnóstico de NULL

Construa uma demonstração controlada para mostrar como `NULL` interfere em `NOT IN`.

Requisitos:
- Utilizar expressões SQL ou conjuntos controlados, sem modificar tabelas.
- Comparar `NOT IN` com `NOT EXISTS`.
- Explicar o resultado `UNKNOWN`.
- Demonstrar como a filtragem do conjunto altera o resultado.

---

# 8. Desafios complexos

Os desafios devem ser resolvidos sem copiar consultas prontas.

## DES-01 — Inteligência comercial por cliente

Construir um relatório que identifique clientes com desempenho de compra acima de uma referência calculada.

O relatório deverá apresentar:

- Identificador do cliente.
- Nome.
- Quantidade de pedidos.
- Total calculado dos itens comprados.
- Média de compras dos clientes considerados.
- Diferença em relação à média.
- Classificação acima ou abaixo da média.

Requisitos técnicos:

- Utilizar subconsultas.
- Utilizar agregações.
- Definir claramente a população utilizada no cálculo da média.
- Evitar dupla contagem.
- Preservar a granularidade de uma linha por cliente.

## DES-02 — Inteligência comercial por produto

Construir um relatório que identifique produtos com desempenho acima da média de sua categoria.

Apresentar:

- Produto.
- Categoria.
- Preço.
- Média de preço da categoria.
- Unidades vendidas.
- Média de unidades vendidas da categoria.
- Classificação do produto.

Requisitos técnicos:

- Utilizar subconsultas correlacionadas.
- Utilizar agregações.
- Definir o tratamento dos produtos sem vendas.
- Evitar multiplicação de valores.
- Validar os resultados.

## DES-03 — Auditoria de relacionamentos

Desenvolver consultas para identificar:

- Clientes sem pedidos.
- Produtos sem vendas.
- Produtos sem avaliações.
- Funcionários sem movimentações.
- Pedidos sem registros relacionados nas tabelas escolhidas.

Requisitos técnicos:

- Utilizar `NOT EXISTS`.
- Utilizar pelo menos uma comparação com `LEFT JOIN`.
- Verificar os relacionamentos reais.
- Não confundir ausência de correspondência com colunas naturalmente nulas.

## DES-04 — Análise salarial

Construir uma análise dos salários dos funcionários em relação ao departamento.

O relatório deverá apresentar:

- Funcionário.
- Departamento.
- Salário.
- Média salarial do departamento.
- Diferença entre salário e média.
- Classificação acima, abaixo ou igual à média.

Requisitos técnicos:

- Utilizar subconsulta correlacionada.
- Utilizar agregação.
- Preservar uma linha por funcionário.
- Considerar departamentos com poucos funcionários.

## DES-05 — Comparação de estratégias

Escolher um problema de negócio e resolvê-lo de três formas:

1. JOIN.
2. Subconsulta.
3. CTE.

Requisitos técnicos:

- Resultados equivalentes.
- Explicação da lógica.
- Comparação de legibilidade.
- Comparação dos planos de execução.
- Justificativa da solução escolhida.

## DES-06 — Otimização avançada

Selecionar uma consulta com subconsulta correlacionada que envolva tabelas de grande volume.

Requisitos técnicos:

- Estabelecer uma versão inicial.
- Medir com `EXPLAIN ANALYZE`.
- Identificar o gargalo.
- Criar uma estratégia alternativa.
- Comparar resultados.
- Comparar desempenho.
- Explicar a decisão final.

Não é necessário modificar índices ou configurações do banco.

---

# 9. Perguntas de compreensão

Responder com suas próprias palavras.

1. O que é uma subconsulta?
2. Qual a diferença entre consulta interna e externa?
3. O que caracteriza uma subconsulta escalar?
4. O que acontece quando uma subconsulta escalar retorna várias linhas?
5. Qual a diferença entre subconsulta correlacionada e não correlacionada?
6. Em quais partes de uma consulta podemos utilizar subconsultas?
7. Qual a diferença entre IN e EXISTS?
8. Qual o risco de utilizar NOT IN quando existem valores NULL?
9. Por que NOT EXISTS pode ser mais seguro para verificar ausência de correspondência?
10. Qual a diferença entre ANY e ALL?
11. O que acontece quando ANY recebe um conjunto vazio?
12. O que acontece quando ALL recebe um conjunto vazio?
13. Qual a função de uma subconsulta no FROM?
14. Qual a diferença entre uma tabela derivada e uma CTE?
15. Uma subconsulta correlacionada sempre executa fisicamente uma vez por linha externa?
16. O que são InitPlan e SubPlan?
17. Por que um JOIN pode multiplicar registros?
18. Por que DISTINCT não deve ser utilizado automaticamente para corrigir duplicações?
19. Quando uma subconsulta pode ser mais clara que um JOIN?
20. Por que precisamos analisar o plano de execução antes de concluir que uma estratégia é mais rápida?

---

# 10. Critérios de qualidade

As consultas serão avaliadas considerando:

### Correção

- Resultado correto.
- Relacionamentos adequados.
- Comparações coerentes.
- Tratamento de NULL.
- Ausência de registros indevidamente eliminados.

### Domínio SQL

- Uso correto dos operadores.
- Estrutura das subconsultas.
- Aliases claros.
- Agregações corretas.
- Boa organização.

### Validação

- Conferência independente.
- Comparação de resultados.
- Verificação de casos extremos.
- Análise de conjuntos vazios.
- Tratamento de empates.

### Desempenho

- Interpretação do plano.
- Identificação de operações repetidas.
- Análise de loops.
- Comparação entre estratégias.
- Justificativa técnica.

### Boas práticas

- Legibilidade.
- Ausência de complexidade desnecessária.
- Escolha adequada da estratégia.
- Preservação da integridade do banco.

---

# 11. Organização da execução

| Etapa | Atividades |
|---|---|
| Fundamentos | AT-01 a AT-10 |
| Operadores | AT-11 a AT-20 |
| Correlação | AT-21 a AT-28 |
| Avançado | AT-29 a AT-35 |
| Desempenho | AT-36 a AT-42 |
| Desafios | DES-01 a DES-06 |
| Compreensão | 20 perguntas |

A progressão deverá acontecer de maneira gradual.

Não é necessário realizar todas as atividades em uma única sessão.

---

# 12. Registro de progresso

| Etapa | Status |
|---|---|
| Nível 1 — Fundamentos | Pendente |
| Nível 2 — Operadores e existência | Pendente |
| Nível 3 — Correlacionadas | Pendente |
| Nível 4 — Avançadas | Pendente |
| Nível 5 — Desempenho | Pendente |
| Desafios complexos | Pendente |
| Perguntas de compreensão | Pendente |
| Validação independente | Pendente |
| Avaliação final | Pendente |

## Observações

Registrar:

- Atividades que apresentaram dificuldade.
- Erros de lógica.
- Problemas com NULL.
- Dificuldades com correlação.
- Problemas de desempenho.
- Conteúdos que precisam de reforço.

---

# 13. Regras de preservação do banco

Durante este módulo, o banco TechStore deverá permanecer preservado.

Não executar:

- INSERT.
- UPDATE.
- DELETE.
- TRUNCATE.
- DROP.
- ALTER.

O objetivo é estudar consultas e análise de execução, sem modificar os dados existentes.

---

# 14. Conclusão

Ao concluir as atividades, o aluno deverá demonstrar que consegue utilizar subconsultas como uma ferramenta de construção de consultas SQL complexas.

O domínio não será medido pela quantidade de subconsultas utilizadas, mas pela capacidade de escolher a estratégia correta, produzir resultados confiáveis, validar sua lógica e compreender seu desempenho.

**Próxima etapa:** validação independente do Módulo 06.