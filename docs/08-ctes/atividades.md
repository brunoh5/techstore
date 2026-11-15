# Atividades — Módulo 08: CTEs (Common Table Expressions)

## 1. Orientações gerais

Este documento contém as atividades práticas do Módulo 08.

O objetivo é desenvolver domínio na construção, organização, composição e otimização de consultas utilizando CTEs no PostgreSQL 16.

As atividades utilizam o banco TechStore e conjuntos de demonstração quando necessário.

### Regras

- Resolver as atividades individualmente.
- Priorizar consultas de leitura.
- Não modificar registros da TechStore.
- Não executar novamente os arquivos de seed.
- Não criar objetos permanentes.
- Utilizar CTEs quando forem solicitadas.
- Não substituir todas as atividades por subconsultas.
- Utilizar `EXPLAIN` e `EXPLAIN ANALYZE` quando solicitado.
- Validar a correção dos resultados.
- Explicar as decisões técnicas nos desafios.

### Organização

| Nível | Atividades | Tema |
|---|---|---|
| 1 | AT-01 a AT-08 | Fundamentos |
| 2 | AT-09 a AT-16 | Agregações e JOINs |
| 3 | AT-17 a AT-24 | Múltiplas CTEs |
| 4 | AT-25 a AT-32 | Integração com outros recursos |
| 5 | AT-33 a AT-40 | Recursividade |
| 6 | AT-41 a AT-48 | Materialização e desempenho |
| 7 | AT-49 a AT-55 | Aplicações avançadas |

---

# Nível 1 — Fundamentos das CTEs

## AT-01 — Primeira CTE

Crie uma CTE chamada `produtos_ativos`.

Requisitos:

- Consultar a tabela `produtos`.
- Retornar ID, nome e preço.
- Considerar somente produtos ativos.
- Utilizar a CTE na consulta principal.

Objetivo: compreender a estrutura básica de `WITH`.

## AT-02 — CTE com filtros

Crie uma CTE chamada `produtos_caros`.

Requisitos:

- Considerar produtos com preço superior a R$ 500.
- Retornar nome e preço.
- Ordenar pelo preço em ordem decrescente.

Objetivo: utilizar filtros dentro da CTE.

## AT-03 — Definição de colunas

Crie uma CTE chamada `catalogo`.

Defina explicitamente os nomes das colunas da CTE.

Requisitos:

- ID do produto.
- Nome do produto.
- Preço de venda.
- Custo.

Objetivo: compreender a definição de aliases na declaração da CTE.

## AT-04 — CTE com DISTINCT

Crie uma CTE que retorne os clientes que possuem pedidos.

Requisitos:

- Consultar `pedidos`.
- Retornar os identificadores dos clientes.
- Evitar identificadores repetidos.
- Ignorar referências `NULL`.

Objetivo: trabalhar com deduplicação dentro de uma CTE.

## AT-05 — CTE com ORDER BY e LIMIT

Crie uma CTE que identifique os 20 produtos de maior preço.

Requisitos:

- Retornar ID, nome e preço.
- Ordenar pelo preço decrescente.
- Limitar a quantidade de registros a 20.

Objetivo: compreender o uso de ordenação e limitação em uma etapa intermediária.

## AT-06 — CTE com expressão

Crie uma CTE que calcule a diferença entre o preço de venda e o custo dos produtos.

Requisitos:

- Retornar ID e nome.
- Calcular a diferença entre preço e custo.
- Criar um alias para o resultado.
- Ordenar pela maior diferença.

Objetivo: combinar expressões com CTEs.

## AT-07 — CTE com CASE

Crie uma CTE que classifique os produtos conforme seu preço.

Defina três categorias de preço:

- Econômico.
- Intermediário.
- Premium.

Os limites devem ser definidos e documentados por você.

Objetivo: integrar `CASE` com CTE.

## AT-08 — CTE com NULL

Crie uma CTE que analise os acessos registrados na TechStore.

Requisitos:

- Identificar acessos associados a clientes.
- Identificar acessos sem cliente associado.
- Criar uma classificação para cada ocorrência.

Objetivo: trabalhar com valores `NULL` e expressões condicionais.

---

# Nível 2 — CTEs com agregações e JOINs

## AT-09 — Pedidos por cliente

Crie uma CTE que calcule a quantidade de pedidos por cliente.

Requisitos:

- Utilizar `pedidos`.
- Agrupar por cliente.
- Retornar quantidade de pedidos.
- Ordenar pelos clientes com maior quantidade.

Objetivo: utilizar `GROUP BY` dentro de uma CTE.

## AT-10 — Clientes sem pedidos

Crie uma CTE com os clientes que possuem pedidos.

Na consulta principal, identifique os clientes que não aparecem nesse resultado.

Requisitos:

- Utilizar `clientes`.
- Utilizar a CTE como fonte de comparação.
- Retornar clientes sem pedidos.

Objetivo: combinar CTE com `LEFT JOIN` ou `NOT EXISTS`.

## AT-11 — Unidades vendidas por produto

Crie uma CTE que calcule a quantidade total de unidades vendidas por produto.

Requisitos:

- Utilizar `itens_pedido`.
- Agrupar por produto.
- Calcular a soma das quantidades.
- Relacionar com `produtos`.
- Retornar o nome e a quantidade vendida.

Objetivo: combinar agregações e JOIN.

## AT-12 — Faturamento por produto

Crie uma CTE que calcule o valor bruto dos itens vendidos por produto.

Considere:

- Quantidade.
- Preço unitário.

Não desconte `desconto_item` neste exercício.

Relacione o resultado com o catálogo de produtos.

Objetivo: construir indicadores comerciais utilizando CTE.

## AT-13 — Faturamento por categoria

Crie uma CTE que calcule o valor bruto vendido por categoria.

Requisitos:

- Relacionar produtos e itens de pedidos.
- Agrupar por categoria.
- Calcular o valor bruto.
- Retornar o nome da categoria e o valor calculado.

Objetivo: utilizar CTE com múltiplas tabelas e agregações.

## AT-14 — Produtos sem vendas

Crie uma CTE com os produtos que aparecem em `itens_pedido`.

Na consulta principal, identifique os produtos que não aparecem nessa CTE.

Objetivo: trabalhar com conjuntos e CTEs.

## AT-15 — Avaliações por produto

Crie uma CTE que calcule:

- Quantidade de avaliações.
- Média das notas.
- Maior nota.
- Menor nota.

Relacione o resultado com `produtos`.

Considere somente produtos que possuem avaliações.

Objetivo: combinar funções agregadas com CTE.

## AT-16 — Funcionários e movimentações

Crie uma CTE que calcule a quantidade de movimentações de estoque por funcionário.

Requisitos:

- Utilizar `movimentacoes_estoque`.
- Agrupar por funcionário.
- Relacionar com `funcionarios`.
- Preservar funcionários sem movimentações na consulta final.

Atenção: `movimentacoes_estoque.funcionario_id` permite `NULL`.

Objetivo: compreender a diferença entre ausência de movimentação e movimentação sem funcionário identificado.

---

# Nível 3 — Múltiplas CTEs e encadeamento

## AT-17 — Relatório de clientes

Crie pelo menos duas CTEs para construir um relatório de clientes.

O resultado deverá apresentar:

- ID.
- Nome.
- Quantidade de pedidos.
- Valor bruto total dos itens comprados.

Requisitos:

- Uma etapa deve calcular os pedidos.
- Outra deve calcular os valores dos itens.
- A consulta final deve relacionar os resultados.

Objetivo: separar responsabilidades entre CTEs.

## AT-18 — Análise de produtos

Construa um relatório utilizando pelo menos três CTEs.

O resultado deverá apresentar:

- Nome do produto.
- Categoria.
- Quantidade vendida.
- Quantidade de avaliações.
- Média das avaliações.

Cada CTE deverá representar uma etapa lógica da consulta.

Objetivo: encadear resultados intermediários.

## AT-19 — Análise de entregas

Construa um relatório utilizando CTEs para analisar as entregas.

Requisitos:

- Relacionar pedidos e entregas.
- Relacionar transportadoras.
- Apresentar quantidade de entregas por transportadora.
- Identificar entregas sem data de conclusão.
- Apresentar a situação registrada.

Objetivo: trabalhar com múltiplas etapas e dados incompletos.

## AT-20 — Análise de pagamentos

Construa um relatório que apresente informações de pagamentos por pedido.

Requisitos:

- Calcular a quantidade de registros de pagamento por pedido.
- Calcular o valor total pago por pedido.
- Relacionar os resultados com pedidos.
- Preservar pedidos sem registros de pagamento, caso existam.

Objetivo: organizar agregações e relacionamentos em CTEs.

Não presuma que existe necessariamente apenas um registro de pagamento por pedido.

## AT-21 — Análise de estoque

Construa uma consulta com pelo menos duas CTEs.

A consulta deverá identificar:

- Produtos abaixo do estoque mínimo.
- Produtos com estoque suficiente.
- Quantidade disponível.
- Diferença entre quantidade atual e estoque mínimo.

Objetivo: separar classificação e apresentação dos dados.

## AT-22 — Relatório de funcionários

Construa um relatório com:

- Nome do funcionário.
- Departamento.
- Quantidade de movimentações de estoque.
- Quantidade de logs registrados.

Requisitos:

- Utilizar CTEs independentes para os indicadores.
- Consolidar os resultados na consulta principal.
- Preservar funcionários sem registros em alguma das fontes.

Objetivo: integrar resultados agregados de diferentes tabelas.

## AT-23 — CTE dependente de outra CTE

Crie três CTEs encadeadas.

Requisitos:

1. Primeira CTE: calcular unidades vendidas por produto.
2. Segunda CTE: relacionar os resultados com o catálogo.
3. Terceira CTE: classificar os produtos por volume de vendas.

A consulta final deverá apresentar a classificação.

Objetivo: dominar dependências entre CTEs.

## AT-24 — Consulta em etapas

Construa uma consulta que apresente clientes classificados conforme o valor bruto comprado.

Requisitos:

- Calcular o valor por pedido.
- Consolidar o valor por cliente.
- Classificar os clientes em faixas.
- Ordenar pelo valor total.

Utilize pelo menos três CTEs.

Objetivo: desenvolver uma consulta analítica organizada.

---

# Nível 4 — Integração com outros recursos SQL

## AT-25 — CTE com subconsulta

Crie uma CTE que identifique produtos cujo preço seja superior à média de preços da própria categoria.

Requisitos:

- Utilizar uma subconsulta correlacionada ou outra estratégia equivalente.
- Relacionar produtos e categorias quando necessário.
- Retornar nome, categoria e preço.

Objetivo: integrar conhecimentos de subconsultas e CTEs.

## AT-26 — CTE com operações de conjuntos

Crie uma CTE que consolide os clientes encontrados em pedidos e acessos.

Requisitos:

- Utilizar `UNION` ou `UNION ALL`.
- Tratar `NULL` corretamente.
- Identificar a origem dos registros quando preservar ocorrências.
- Retornar os dados dos clientes.

Objetivo: integrar o Módulo 07 com CTEs.

## AT-27 — CTE com HAVING

Crie uma consulta que identifique categorias cujo faturamento bruto esteja acima de um limite definido por você.

Requisitos:

- Calcular o faturamento por categoria.
- Utilizar `HAVING`.
- Organizar o resultado em uma CTE.
- Apresentar o resultado final ordenado.

Objetivo: trabalhar com agregações e filtros de grupos.

## AT-28 — CTE com Window Function

Crie uma CTE que calcule a quantidade vendida por produto.

Em outra CTE, aplique `ROW_NUMBER()` ou `RANK()`.

Requisitos:

- Classificar produtos por quantidade vendida.
- Apresentar a posição.
- Relacionar com o catálogo.

Objetivo: preparar a integração com o Módulo 09.

## AT-29 — CTE com múltiplas fontes

Construa um relatório consolidado de eventos da TechStore.

Utilize registros de:

- Pedidos.
- Acessos.
- Movimentações de estoque.

Requisitos:

- Padronizar as colunas.
- Identificar o tipo de evento.
- Preservar a origem.
- Combinar os resultados.
- Ordenar pela data do evento.

Objetivo: integrar CTEs e operações de conjuntos.

## AT-30 — CTE com filtros externos

Construa duas versões equivalentes de uma consulta:

- Uma com filtros dentro da CTE.
- Outra com filtros na consulta principal.

Requisitos:

- Garantir que os resultados sejam equivalentes.
- Comparar os planos.
- Verificar se o PostgreSQL consegue incorporar a CTE.
- Explicar possíveis diferenças.

Objetivo: compreender a otimização de filtros.

## AT-31 — CTE versus subconsulta

Escolha uma consulta que utilize agregação por produto.

Construa duas versões:

- Uma utilizando CTE.
- Outra utilizando subconsulta no `FROM`.

Requisitos:

- Mesmos campos.
- Mesma granularidade.
- Mesmos resultados.
- Comparação de planos.

Objetivo: compreender diferenças de organização e execução.

## AT-32 — CTE versus JOIN direto

Construa duas versões de um relatório de vendas por produto:

- Uma utilizando CTE.
- Outra utilizando JOIN e agregação diretamente.

Requisitos:

- Garantir equivalência dos resultados.
- Comparar quantidade de linhas.
- Comparar planos.
- Explicar qual estrutura considera mais legível.

Objetivo: desenvolver capacidade de escolha entre alternativas SQL.

---

# Nível 5 — CTEs recursivas

As atividades deste nível utilizarão estruturas de demonstração criadas por `VALUES` ou outras consultas de leitura.

Não é necessário alterar o schema da TechStore.

## AT-33 — Sequência numérica

Utilize `WITH RECURSIVE` para gerar uma sequência de 1 até 20.

Requisitos:

- Definir a consulta âncora.
- Definir a parte recursiva.
- Estabelecer a condição de parada.

Objetivo: compreender o funcionamento básico da recursividade.

## AT-34 — Sequência com incremento

Gere uma sequência de números pares entre 2 e 50.

Requisitos:

- Utilizar CTE recursiva.
- Iniciar no primeiro valor adequado.
- Incrementar corretamente.
- Impedir valores acima do limite.

Objetivo: trabalhar com condições recursivas.

## AT-35 — Contagem regressiva

Gere uma sequência decrescente de 30 até 0.

Requisitos:

- Definir o valor inicial.
- Reduzir o valor a cada iteração.
- Finalizar corretamente.

Objetivo: compreender que a recursividade não está limitada a incrementos.

## AT-36 — Hierarquia simples

Crie uma estrutura hierárquica com pelo menos três níveis utilizando `VALUES`.

Exemplo de estrutura:

```text
Diretoria
├── Gerência A
│   ├── Equipe A1
│   └── Equipe A2
└── Gerência B
    └── Equipe B1
```

Requisitos:

- Criar identificadores.
- Criar relacionamentos entre os elementos.
- Identificar o elemento raiz.
- Percorrer a estrutura com CTE recursiva.
- Apresentar todos os níveis.

Objetivo: compreender a expansão hierárquica.

## AT-37 — Hierarquia com nível

Utilize a estrutura criada na atividade anterior.

Requisitos:

- Criar uma coluna de nível.
- Definir a raiz como nível zero.
- Incrementar o nível a cada etapa.
- Ordenar o resultado de maneira coerente.

Objetivo: controlar a profundidade de uma hierarquia.

## AT-38 — Construção de caminhos

Utilize uma estrutura hierárquica de demonstração.

Requisitos:

- Construir o caminho completo de cada elemento.
- Separar os níveis por um caractere.
- Apresentar o caminho da raiz até o elemento.
- Evitar caminhos inconsistentes.

Objetivo: trabalhar com arrays ou expressões de texto durante a recursão.

## AT-39 — Prevenção de ciclos

Crie uma estrutura de demonstração que contenha um ciclo.

Exemplo:

```text
A → B
B → C
C → A
```

Requisitos:

- Construir uma CTE recursiva.
- Identificar o problema potencial.
- Implementar controle de elementos já visitados.
- Impedir a expansão indefinida.
- Explicar a estratégia utilizada.

Objetivo: compreender e prevenir ciclos.

## AT-40 — Utilização de CYCLE

Utilize uma estrutura com possibilidade de ciclos.

Requisitos:

- Implementar uma CTE recursiva.
- Utilizar a cláusula `CYCLE`.
- Definir as colunas utilizadas para detectar ciclos.
- Identificar os registros sinalizados.
- Explicar o comportamento do caminho gerado.

Objetivo: dominar um recurso específico do PostgreSQL.

---

# Nível 6 — Materialização e desempenho

## AT-41 — CTE padrão

Escolha uma consulta simples com CTE sobre produtos.

Execute:

- `EXPLAIN`.
- `EXPLAIN ANALYZE`.
- `EXPLAIN (ANALYZE, BUFFERS)`.

Registre os resultados.

Objetivo: identificar o comportamento de planejamento de uma CTE simples.

## AT-42 — MATERIALIZED

Construa uma versão de uma consulta utilizando `MATERIALIZED`.

Requisitos:

- Escolher uma consulta com agregação.
- Analisar o plano.
- Identificar a presença de materialização.
- Registrar custos e tempos.

Objetivo: compreender o efeito da materialização.

## AT-43 — NOT MATERIALIZED

Construa uma versão equivalente utilizando `NOT MATERIALIZED`.

Requisitos:

- Utilizar uma CTE elegível.
- Comparar com a versão materializada.
- Observar os nós de execução.
- Identificar diferenças no plano.

Objetivo: compreender a incorporação de CTEs.

## AT-44 — CTE referenciada múltiplas vezes

Crie uma CTE que seja utilizada mais de uma vez na consulta principal.

Requisitos:

- Construir uma consulta válida.
- Analisar o comportamento padrão.
- Comparar com `NOT MATERIALIZED`, quando aplicável.
- Identificar possíveis recomputações.

Objetivo: compreender o impacto da reutilização.

## AT-45 — Empurramento de filtros

Construa duas versões de uma consulta com CTE:

- Uma materializada.
- Outra não materializada.

Aplique um filtro seletivo na consulta externa.

Requisitos:

- Comparar o plano.
- Observar a quantidade de linhas processadas.
- Verificar a posição do filtro.
- Explicar o comportamento observado.

Objetivo: compreender a interação entre filtros e materialização.

## AT-46 — Comparação de desempenho

Escolha uma consulta complexa com pelo menos duas CTEs.

Construa uma alternativa equivalente utilizando subconsultas ou JOINs.

Requisitos:

- Garantir os mesmos resultados.
- Registrar Planning Time.
- Registrar Execution Time.
- Registrar buffers.
- Comparar os planos.
- Explicar a diferença encontrada.

Objetivo: desenvolver análise técnica baseada em evidências.

## AT-47 — Identificação de gargalo

Escolha uma consulta que apresente custo elevado.

Investigue:

- Estimativas de linhas.
- Linhas reais.
- Nós de agregação.
- Nós de junção.
- Materialização.
- Leitura de blocos.

Proponha uma hipótese de melhoria e teste uma alteração por vez.

Objetivo: desenvolver raciocínio de otimização.

## AT-48 — Recursividade e desempenho

Utilize uma estrutura hierárquica de demonstração com vários níveis.

Requisitos:

- Medir o comportamento da recursão.
- Observar o número de linhas produzidas.
- Identificar os nós recursivos.
- Avaliar o impacto do crescimento da estrutura.
- Comparar diferentes profundidades.

Objetivo: compreender o custo de consultas recursivas.

---

# Nível 7 — Aplicações avançadas

## AT-49 — Relatório comercial completo

Construa um relatório de desempenho comercial utilizando pelo menos quatro CTEs.

O relatório deverá apresentar:

- Produto.
- Categoria.
- Unidades vendidas.
- Valor bruto vendido.
- Quantidade de avaliações.
- Média das avaliações.

Requisitos:

- Separar cálculos em etapas.
- Preservar produtos sem vendas ou avaliações.
- Evitar duplicação de valores.
- Apresentar uma linha por produto.

Objetivo: consolidar conhecimentos de agregação, JOIN e CTE.

## AT-50 — Análise de clientes

Construa um relatório de clientes com:

- Quantidade de pedidos.
- Valor bruto dos itens comprados.
- Quantidade de acessos.
- Data do último acesso.

Requisitos:

- Utilizar CTEs independentes para os indicadores.
- Preservar clientes sem registros em algumas fontes.
- Evitar multiplicação de valores devido a JOINs.
- Definir corretamente a granularidade.

Objetivo: desenvolver uma consulta analítica de múltiplas fontes.

## AT-51 — Auditoria operacional

Construa uma consulta que consolide informações de:

- Movimentações de estoque.
- Logs do sistema.
- Pedidos.

Requisitos:

- Identificar a origem de cada evento.
- Padronizar os campos.
- Combinar os resultados.
- Tratar valores `NULL`.
- Ordenar cronologicamente.

Objetivo: utilizar CTEs para estruturar uma auditoria.

## AT-52 — Relatório de entregas

Construa um relatório que analise o desempenho das transportadoras.

Requisitos:

- Quantidade de entregas.
- Quantidade de entregas concluídas.
- Quantidade de entregas sem data de conclusão.
- Tempo médio entre envio e entrega, quando as datas necessárias estiverem disponíveis.
- Identificação da transportadora.

Defina claramente como serão tratados registros incompletos.

Objetivo: desenvolver indicadores operacionais com CTEs.

## AT-53 — Consulta modularizada

Escolha uma consulta complexa da TechStore.

Reescreva-a utilizando CTEs com as seguintes exigências:

- Cada CTE deverá possuir uma responsabilidade clara.
- Não poderá existir CTE sem utilidade.
- A granularidade de cada etapa deverá ser documentada.
- Os resultados deverão ser equivalentes à consulta original.
- A consulta final deverá ser legível.

Objetivo: demonstrar capacidade de estruturar consultas complexas.

## AT-54 — Investigação de materialização

Escolha uma consulta com múltiplas referências a uma mesma CTE.

Construa alternativas utilizando:

- Comportamento padrão.
- `MATERIALIZED`.
- `NOT MATERIALIZED`, quando aplicável.

Requisitos:

- Comparar planos.
- Comparar tempos.
- Observar a quantidade de leituras.
- Verificar possíveis recomputações.
- Explicar os resultados.

Objetivo: tomar decisões fundamentadas sobre materialização.

## AT-55 — Desafio final do módulo

Desenvolva uma consulta analítica completa para a TechStore.

O relatório deverá combinar informações de pelo menos quatro áreas diferentes do banco.

Exemplos de áreas:

- Clientes.
- Produtos.
- Pedidos.
- Pagamentos.
- Estoque.
- Avaliações.
- Entregas.
- Funcionários.

Requisitos obrigatórios:

1. Utilizar pelo menos quatro CTEs.
2. Possuir dependências entre CTEs.
3. Utilizar pelo menos uma agregação.
4. Utilizar pelo menos um JOIN.
5. Utilizar pelo menos uma expressão condicional.
6. Preservar a granularidade.
7. Tratar valores `NULL`.
8. Evitar duplicidades indevidas.
9. Apresentar resultado organizado.
10. Analisar o plano de execução.
11. Justificar as decisões de estruturação.
12. Comprovar a equivalência e a correção do resultado.

A recursividade poderá ser incorporada caso exista uma aplicação adequada, mas não será obrigatória neste desafio.

---

# 8. Perguntas de compreensão

Responda às perguntas sem consultar a teoria.

1. O que é uma CTE?
2. Qual é a função da cláusula `WITH`?
3. Qual é a diferença entre uma CTE e uma tabela temporária?
4. Uma CTE permanece disponível após o término da instrução?
5. É possível declarar várias CTEs na mesma consulta?
6. Uma CTE pode utilizar outra CTE?
7. Qual é a importância da ordem de declaração?
8. Uma CTE garante melhor desempenho?
9. Qual é a diferença entre CTE e subconsulta?
10. O que é uma CTE recursiva?
11. Qual é a função da consulta âncora?
12. Qual é a função da parte recursiva?
13. Por que normalmente utilizamos `UNION ALL` em recursões?
14. O que é uma condição de parada?
15. O que pode causar uma recursão infinita?
16. Como podemos prevenir ciclos?
17. Qual é a finalidade da cláusula `CYCLE`?
18. Qual é a finalidade da cláusula `SEARCH`?
19. Qual é a diferença entre `MATERIALIZED` e `NOT MATERIALIZED`?
20. O que é empurramento de filtros?
21. O que significa um nó `CTE Scan`?
22. Uma CTE materializada é uma tabela permanente?
23. Quando uma subconsulta pode ser mais adequada que uma CTE?
24. Como verificar se uma CTE está prejudicando o desempenho?
25. Por que devemos preservar a granularidade entre etapas?

---

# 9. Critérios de avaliação

A avaliação seguirá os critérios oficiais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: **85%**.

Erros críticos de lógica, recursividade, segurança ou integridade impedem a aprovação, independentemente da pontuação numérica.

## 9.1 Critérios específicos

**Correção lógica**

- Resultados corretos.
- CTEs com responsabilidades coerentes.
- Agregações corretas.
- Cardinalidade preservada.

**Domínio SQL**

- Sintaxe correta.
- Encadeamento correto.
- Utilização adequada de CTEs.
- Recursividade funcional.

**Casos extremos**

- Tratamento de `NULL`.
- Conjuntos vazios.
- Ausência de relacionamentos.
- Ciclos.
- Condições de parada.

**Desempenho**

- Capacidade de ler planos.
- Comparação de alternativas.
- Compreensão de materialização.
- Identificação de gargalos.

**Legibilidade**

- Nomes claros.
- Organização lógica.
- Ausência de etapas desnecessárias.
- Código compreensível.

---

# 10. Registro de progresso

| Atividade | Status |
|---|---|
| AT-01 a AT-08 | Pendente |
| AT-09 a AT-16 | Pendente |
| AT-17 a AT-24 | Pendente |
| AT-25 a AT-32 | Pendente |
| AT-33 a AT-40 | Pendente |
| AT-41 a AT-48 | Pendente |
| AT-49 a AT-55 | Pendente |
| Perguntas de compreensão | Pendente |
| Validação independente | Pendente |
| Desafio final | Pendente |
| Avaliação | Pendente |
| Nota final | — |

### Anotações

Registrar:

- Atividades com dificuldades.
- Conceitos que precisaram de reforço.
- Problemas encontrados nas consultas.
- Decisões de modelagem.
- Resultados de desempenho.
- Melhorias aplicadas.

---

# 11. Regras de aprovação

Para concluir o módulo:

1. Estudar toda a teoria.
2. Realizar as atividades progressivamente.
3. Demonstrar domínio de CTEs simples e encadeadas.
4. Demonstrar domínio de CTEs recursivas.
5. Compreender materialização.
6. Concluir os testes independentes.
7. Realizar o desafio final.
8. Atingir pelo menos 85%.
9. Não apresentar erros críticos pendentes.

Caso existam dificuldades, será realizado reforço direcionado aos conteúdos não dominados.

---

# 12. Próximo módulo

Após a aprovação, o aluno estará apto a avançar para:

**Módulo 09 — Window Functions**

O próximo módulo aprofundará funções analíticas, particionamento, ordenação, rankings, cálculos acumulados e análises avançadas sobre conjuntos de registros.

**Status:** atividades preparadas. Aulas ainda não iniciadas.