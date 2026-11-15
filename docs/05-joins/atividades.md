# Atividades — Módulo 05: JOINs SQL

## 1. Orientações gerais

Este documento contém os exercícios práticos do Módulo 05.

O objetivo é desenvolver domínio sobre junções entre tabelas, relacionamentos, cardinalidade, granularidade e desempenho.

As atividades utilizam o banco TechStore e deverão ser realizadas no PostgreSQL 16.

### Regras obrigatórias

- Utilizar exclusivamente consultas SELECT.
- Não modificar tabelas ou registros.
- Não executar INSERT, UPDATE ou DELETE.
- Não criar, remover ou modificar índices.
- Não executar novamente a seed.
- Não apagar ou recriar o banco.
- Validar os resultados das consultas.
- Registrar dúvidas e dificuldades encontradas.

### Como realizar cada atividade

Para cada exercício:

1. Leia o problema.
2. Identifique as tabelas necessárias.
3. Identifique as colunas de relacionamento.
4. Determine o tipo de JOIN adequado.
5. Escreva a consulta.
6. Execute e analise o resultado.
7. Verifique a quantidade de registros.
8. Confirme a granularidade.
9. Explique por que escolheu aquela abordagem.

Não procure apenas produzir uma consulta que execute. O objetivo é compreender o resultado.

---

# ETAPA 01 — Fundamentos de JOIN

**Objetivo:** compreender como combinar duas tabelas.

### AT-01 — Clientes e pedidos

Construa uma consulta que apresente:

- Nome do cliente.
- Identificador do pedido.
- Data do pedido.
- Status do pedido.

Utilize INNER JOIN.

### AT-02 — Produtos e itens de pedido

Apresente:

- Nome do produto.
- Identificador do item.
- Quantidade.
- Preço unitário.

Identifique quais produtos aparecem nos itens de pedidos.

### AT-03 — Pedidos e pagamentos

Combine pedidos e pagamentos.

Apresente:

- Identificador do pedido.
- Data do pedido.
- Identificador do pagamento.
- Valor pago.
- Forma de pagamento.

### AT-04 — Funcionários e departamentos

Apresente:

- Nome do funcionário.
- E-mail.
- Salário.
- Identificador do departamento.

Utilize o relacionamento entre funcionários e departamentos.

### AT-05 — Produtos e categorias

Apresente:

- Nome do produto.
- Preço.
- Identificador da categoria.

Identifique a categoria associada a cada produto.

### AT-06 — Produtos e marcas

Apresente:

- Nome do produto.
- SKU.
- Nome ou identificador da marca.

Utilize o relacionamento existente entre produtos e marcas.

---

# ETAPA 02 — LEFT JOIN e registros sem correspondência

**Objetivo:** compreender a preservação de registros e a identificação de ausências.

### AT-07 — Todos os clientes e seus pedidos

Apresente todos os clientes, incluindo aqueles que não possuem pedidos.

Colunas:

- Cliente.
- Identificador do pedido.
- Data do pedido.

Utilize LEFT JOIN.

### AT-08 — Clientes sem pedidos

Identifique clientes que nunca realizaram pedidos.

Apresente:

- Identificador.
- Nome.
- E-mail.

### AT-09 — Produtos sem vendas

Identifique produtos que não aparecem em nenhum registro de `itens_pedido`.

Apresente:

- Identificador do produto.
- Nome.
- SKU.
- Preço.

### AT-10 — Todos os produtos e seus registros de estoque

Apresente todos os produtos, mesmo quando não existir correspondência na tabela de estoque.

Identifique como o resultado representa produtos sem registro correspondente.

### AT-11 — Produtos sem avaliações

Identifique produtos que não possuem avaliações.

Apresente:

- Produto.
- SKU.
- Preço.

### AT-12 — Funcionários e registros de movimentação

Apresente todos os funcionários e as movimentações de estoque associadas.

Funcionários sem movimentações também deverão aparecer.

---

# ETAPA 03 — RIGHT JOIN e FULL OUTER JOIN

**Objetivo:** compreender outras formas de preservação dos registros.

### AT-13 — RIGHT JOIN entre pedidos e clientes

Utilize RIGHT JOIN para apresentar todos os pedidos e suas informações de cliente.

Compare o resultado com uma consulta equivalente utilizando LEFT JOIN e invertendo a ordem das tabelas.

Explique por que os resultados são equivalentes.

### AT-14 — FULL OUTER JOIN

Construa uma consulta utilizando FULL OUTER JOIN entre duas tabelas relacionadas da TechStore.

Apresente:

- Identificador de cada lado.
- Informações de identificação.
- Indicação de correspondência ou ausência.

Explique quais registros são preservados.

### AT-15 — Comparação entre junções externas

Escolha um relacionamento da TechStore e construa consultas equivalentes utilizando:

- LEFT JOIN.
- RIGHT JOIN.
- FULL OUTER JOIN.

Compare:

- Quantidade de linhas.
- Registros preservados.
- Valores NULL.
- Diferenças entre os resultados.

---

# ETAPA 04 — CROSS JOIN e SELF JOIN

**Objetivo:** compreender junções especiais.

### AT-16 — Produto cartesiano

Combine `categorias` e `marcas` utilizando CROSS JOIN.

Apresente:

- Identificador da categoria.
- Identificador da marca.

Antes da execução, estime a quantidade de linhas esperadas.

Depois, compare sua estimativa com o resultado.

### AT-17 — Análise de produto cartesiano

Repita o raciocínio anterior utilizando outras duas tabelas pequenas da TechStore.

Explique:

- Quantidade de registros em cada tabela.
- Quantidade esperada de combinações.
- Quantidade real de linhas.
- Possíveis aplicações desse tipo de operação.

### AT-18 — SELF JOIN conceitual

A tabela `funcionarios` da TechStore não deve ser tratada como uma estrutura hierárquica sem que exista uma coluna de relacionamento entre funcionários.

Portanto, utilize uma tabela com relacionamento real consigo mesma, caso exista no schema, ou construa um exemplo conceitual separado, sem modificar o banco.

Explique como aliases diferentes permitem representar duas funções distintas da mesma tabela.

---

# ETAPA 05 — JOIN com múltiplas tabelas

**Objetivo:** combinar três ou mais tabelas e compreender os relacionamentos intermediários.

### AT-19 — Clientes, pedidos e itens

Construa uma consulta envolvendo:

- Clientes.
- Pedidos.
- Itens de pedido.

Apresente:

- Nome do cliente.
- Identificador do pedido.
- Identificador do item.
- Quantidade.
- Preço unitário.

Explique o que representa cada linha do resultado.

### AT-20 — Pedidos, itens e produtos

Combine:

- `pedidos`
- `itens_pedido`
- `produtos`

Apresente:

- Pedido.
- Data.
- Produto.
- Quantidade.
- Preço unitário.
- Desconto do item.

### AT-21 — Produtos, categorias e marcas

Construa uma consulta envolvendo as três tabelas.

Apresente:

- Nome do produto.
- Categoria.
- Marca.
- Preço.

### AT-22 — Pedidos, pagamentos e formas de pagamento

Combine as tabelas necessárias para apresentar:

- Pedido.
- Data do pedido.
- Valor pago.
- Forma de pagamento.

Verifique se a relação entre pedidos e pagamentos permite mais de um registro de pagamento por pedido.

Não presuma uma cardinalidade sem verificar o schema.

### AT-23 — Entregas e transportadoras

Apresente:

- Identificador do pedido.
- Identificador da entrega.
- Status da entrega.
- Data de envio.
- Data de entrega.
- Nome ou identificador da transportadora.

### AT-24 — Funcionários, departamentos e movimentações

Combine as três tabelas.

Apresente:

- Funcionário.
- Departamento.
- Tipo de movimentação.
- Quantidade movimentada.
- Data da movimentação.

Explique como a quantidade de linhas é afetada pelas movimentações associadas a cada funcionário.

---

# ETAPA 06 — ON, WHERE e filtros

**Objetivo:** compreender como a posição das condições altera o resultado.

### AT-25 — Filtro no WHERE

Combine clientes e pedidos.

Retorne somente pedidos com status `entregue`.

Apresente:

- Cliente.
- Pedido.
- Data.
- Status.

### AT-26 — Condição no ON

Utilize LEFT JOIN entre clientes e pedidos.

Coloque a condição de status dos pedidos na cláusula ON.

Apresente todos os clientes e somente os pedidos que atendem à condição.

### AT-27 — Comparação entre ON e WHERE

Construa duas consultas equivalentes em estrutura, mas com a condição de status posicionada:

- Na cláusula ON.
- Na cláusula WHERE.

Compare os resultados.

Explique por que a quantidade de clientes retornados pode mudar.

### AT-28 — Filtros combinados

Combine produtos e categorias.

Utilize condições para filtrar produtos por preço e categoria.

Explique quais condições pertencem à junção e quais pertencem à filtragem.

---

# ETAPA 07 — JOIN com agregações

**Objetivo:** construir indicadores com múltiplas tabelas.

### AT-29 — Pedidos por cliente

Apresente:

- Identificador do cliente.
- Nome.
- Quantidade de pedidos.

Inclua clientes sem pedidos.

### AT-30 — Produtos vendidos por categoria

Combine produtos, categorias e itens de pedido.

Apresente indicadores por categoria:

- Quantidade de produtos cadastrados.
- Quantidade de unidades vendidas.
- Quantidade de itens associados.

Explique a diferença entre contar produtos, itens e unidades.

### AT-31 — Valor comercializado por produto

Combine produtos e itens de pedido.

Calcule o valor bruto associado a cada produto, considerando quantidade e preço unitário.

Não confunda quantidade de itens com quantidade de unidades.

### AT-32 — Avaliações por produto

Combine produtos e avaliações.

Apresente:

- Produto.
- Quantidade de avaliações.
- Nota média.
- Menor nota.
- Maior nota.

Inclua produtos sem avaliações.

### AT-33 — Funcionários e movimentações

Apresente por funcionário:

- Nome.
- Departamento.
- Quantidade de movimentações.
- Quantidade total movimentada.

Inclua funcionários sem movimentações.

### AT-34 — Transportadoras e entregas

Apresente por transportadora:

- Quantidade de entregas.
- Quantidade de entregas com data preenchida.
- Quantidade de entregas sem data preenchida.

Explique o significado dos valores NULL encontrados.

---

# ETAPA 08 — Cardinalidade e duplicações

**Objetivo:** desenvolver domínio sobre multiplicação de registros e granularidade.

### AT-35 — Granularidade de pedidos e itens

Combine pedidos e itens de pedido.

Determine:

- Quantidade de pedidos distintos.
- Quantidade de linhas retornadas.
- Quantidade total de itens.
- Quantidade de pedidos com mais de um item.

Explique por que as quantidades podem ser diferentes.

### AT-36 — COUNT(*) versus COUNT(DISTINCT)

Utilize uma consulta com JOIN entre clientes e pedidos.

Compare:

- COUNT(*).
- COUNT(p.id).
- COUNT(DISTINCT c.id).

Explique o que cada resultado representa.

### AT-37 — Risco de dupla contagem

Combine pedidos, itens de pedido e pagamentos.

Analise como os relacionamentos podem multiplicar os registros.

Não é necessário assumir que todo pedido tenha vários pagamentos: primeiro verifique a cardinalidade real.

Identifique quais indicadores poderiam ser calculados incorretamente se a granularidade não for controlada.

### AT-38 — Agregação antes do JOIN

Utilize uma subconsulta ou CTE para calcular previamente uma métrica por pedido.

Depois, combine esse resultado com outra tabela relacionada.

Explique como a agregação prévia pode ajudar a evitar dupla contagem.

### AT-39 — DISTINCT e métricas

Construa uma consulta que apresente uma contagem de entidades únicas após um JOIN.

Compare o resultado com a contagem simples de linhas.

Explique por que DISTINCT pode ser adequado para uma métrica e inadequado para outra.

### AT-40 — Auditoria de cardinalidade

Escolha três relacionamentos da TechStore.

Para cada um, registre:

- Tabela de origem.
- Tabela relacionada.
- Coluna de relacionamento.
- Cardinalidade esperada.
- Quantidade de linhas antes da junção.
- Quantidade de linhas depois da junção.
- Explicação da diferença.

---

# ETAPA 09 — Análise de desempenho

**Objetivo:** compreender o custo das junções no PostgreSQL.

### AT-41 — Plano de execução de INNER JOIN

Utilize EXPLAIN ANALYZE e BUFFERS em uma consulta entre clientes e pedidos.

Registre:

- Planning Time.
- Execution Time.
- Node Type.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.

### AT-42 — Plano de execução de LEFT JOIN

Repita a análise utilizando LEFT JOIN.

Compare os resultados e explique as diferenças observadas.

### AT-43 — JOIN com três tabelas

Analise uma consulta envolvendo pedidos, itens de pedido e produtos.

Identifique:

- Estratégias de JOIN.
- Quantidade de linhas em cada etapa.
- Nós de agregação, caso existam.
- Operações que merecem investigação.

### AT-44 — Comparação de consultas

Escolha duas consultas que produzam resultados equivalentes.

Compare seus planos de execução e tempos.

Explique se existe diferença relevante e se a consulta mais rápida preserva a mesma lógica.

### AT-45 — Diagnóstico profissional

Escolha uma consulta envolvendo tabelas de maior volume.

Analise:

- Cardinalidade.
- Estimativas do planejador.
- Quantidade de linhas reais.
- Estratégia de JOIN.
- Acessos a blocos.
- Tempo de execução.

Apresente uma hipótese de melhoria sem modificar o banco principal.

---

# ETAPA 10 — Desafios profissionais

Os desafios exigem interpretação, planejamento e validação independente.

Não existe uma única forma obrigatória de resolver cada problema.

## DES-01 — Relatório comercial

Construa um relatório que apresente informações de clientes, pedidos e itens de pedido.

O relatório deverá permitir analisar:

- Cliente.
- Quantidade de pedidos.
- Quantidade de unidades adquiridas.
- Valor bruto associado aos itens.

Valide cada indicador separadamente.

Atenção à granularidade e à possibilidade de dupla contagem.

## DES-02 — Catálogo e desempenho de vendas

Construa um relatório de produtos que permita identificar:

- Produto.
- Categoria.
- Marca.
- Preço.
- Quantidade de unidades vendidas.
- Valor bruto comercializado.

Produtos sem vendas também deverão ser considerados.

## DES-03 — Análise de entregas

Construa uma consulta que relacione pedidos, entregas e transportadoras.

O objetivo é analisar:

- Quantidade de entregas.
- Status.
- Datas de envio e entrega.
- Entregas sem data preenchida.

Não confunda pedidos com entregas.

## DES-04 — Desempenho de funcionários

Construa um relatório envolvendo funcionários, departamentos e movimentações de estoque.

Apresente indicadores por funcionário e departamento.

Funcionários sem movimentações deverão ser tratados corretamente.

## DES-05 — Auditoria de relacionamentos

Escolha relacionamentos da TechStore e construa consultas para identificar:

- Registros sem correspondência.
- Registros opcionais.
- Possíveis inconsistências.
- Duplicações inesperadas.
- Diferenças entre cardinalidade esperada e observada.

Explique quais situações representam problemas e quais são permitidas pelo modelo.

## DES-06 — Diagnóstico de desempenho

Selecione três consultas desenvolvidas durante o módulo.

Para cada uma:

1. Execute uma versão de referência.
2. Analise o plano de execução.
3. Identifique o principal custo.
4. Formule uma hipótese.
5. Teste uma alteração de consulta por vez.
6. Compare os planos.
7. Verifique a equivalência lógica.
8. Registre as conclusões.

Não altere índices ou configurações do banco principal.

---

# ETAPA 11 — Perguntas de validação individual

Responda sem consultar a teoria.

1. Qual é a diferença entre INNER JOIN e LEFT JOIN?
2. O que acontece com registros sem correspondência em um LEFT JOIN?
3. Qual é a diferença entre LEFT JOIN e RIGHT JOIN?
4. Em quais situações FULL OUTER JOIN é útil?
5. O que acontece em um CROSS JOIN?
6. Como funciona um SELF JOIN?
7. Qual é a função da cláusula ON?
8. Como WHERE pode alterar o resultado de um LEFT JOIN?
9. Por que COUNT(*) pode apresentar um resultado diferente de COUNT(coluna)?
10. O que é cardinalidade?
11. O que significa granularidade?
12. Por que um JOIN pode multiplicar registros?
13. Como uma agregação pode sofrer dupla contagem?
14. Quando utilizar uma subconsulta antes de realizar um JOIN?
15. Quais são as diferenças entre Nested Loop, Hash Join e Merge Join?
16. Uma chave estrangeira garante que existe um índice na coluna relacionada?
17. Como identificar registros sem correspondência?
18. Por que DISTINCT não deve ser utilizado para esconder problemas de cardinalidade?
19. Quais informações do EXPLAIN ANALYZE ajudam a investigar uma junção?
20. Como validar se uma consulta com várias tabelas está correta?

---

# ETAPA 12 — Critérios de conclusão

O estudante deverá demonstrar domínio das seguintes competências:

| Competência | Status |
|---|---|
| INNER JOIN | Pendente |
| LEFT JOIN | Pendente |
| RIGHT JOIN | Pendente |
| FULL OUTER JOIN | Pendente |
| CROSS JOIN | Pendente |
| SELF JOIN | Pendente |
| JOIN com múltiplas tabelas | Pendente |
| Relacionamentos 1:1, 1:N e N:N | Pendente |
| ON e WHERE | Pendente |
| JOIN com agregações | Pendente |
| Registros sem correspondência | Pendente |
| Cardinalidade | Pendente |
| Granularidade | Pendente |
| Prevenção de dupla contagem | Pendente |
| Estratégias de JOIN | Pendente |
| EXPLAIN ANALYZE | Pendente |

Estados possíveis:

- Pendente.
- Em desenvolvimento.
- Dominado.
- Necessita reforço.

---

# ETAPA 13 — Critérios de avaliação

A avaliação seguirá os pesos oficiais do curso:

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: **85%**.

Não será permitida a aprovação com erros críticos pendentes, principalmente:

- Condições de junção incorretas.
- Perda indevida de registros.
- Duplicação não identificada.
- Dupla contagem em agregações.
- Granularidade incorreta.
- Interpretação inadequada de NULL.

---

# ETAPA 14 — Registro de progresso

| Informação | Registro |
|---|---|
| Data de início | |
| Data de conclusão | |
| Atividades concluídas | |
| Desafios concluídos | |
| Nota final | |
| Competências dominadas | |
| Competências que precisam de reforço | |
| Erros críticos | |
| Status do módulo | |

---

# ETAPA 15 — Regras de preservação

Durante todas as atividades:

- Não modificar o schema.
- Não alterar registros.
- Não criar ou remover índices.
- Não executar novamente a seed.
- Não apagar ou recriar o banco.
- Utilizar consultas de leitura.
- Executar consultas pesadas individualmente.
- Avaliar o volume esperado antes de utilizar CROSS JOIN.

O banco TechStore deverá permanecer preservado para os módulos seguintes.

---

# STATUS

| Item | Status |
|---|---|
| Atividades elaboradas | Concluído |
| Execução pelo estudante | Não iniciada |
| Validação independente | Pendente |
| Avaliação final | Não iniciada |
| Liberação do Módulo 06 | Bloqueada até aprovação |

**Objetivo final:** desenvolver a capacidade de combinar informações de diferentes tabelas, preservar a lógica dos relacionamentos e produzir resultados confiáveis, mesmo em consultas complexas.