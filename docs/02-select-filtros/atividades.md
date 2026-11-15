# Atividades — Módulo 02: SELECT e filtros

## 1. Orientações gerais

Este documento contém as atividades práticas do Módulo 02 do curso de SQL com PostgreSQL.

O objetivo é transformar os conceitos estudados em consultas reais, desenvolvendo raciocínio lógico, autonomia e capacidade de investigação.

Todas as atividades deverão ser realizadas no banco TechStore.

### Regras de execução

1. Leia o enunciado antes de escrever a consulta.
2. Identifique a tabela e as colunas necessárias.
3. Consulte a estrutura da tabela quando tiver dúvidas sobre os nomes ou tipos das colunas.
4. Escreva sua própria consulta.
5. Execute no pgAdmin.
6. Analise o resultado.
7. Verifique se a consulta atende a todos os requisitos.
8. Guarde a consulta e o resultado para apresentar na correção.

### Restrições do ambiente

- Utilizar exclusivamente consultas de leitura.
- Não executar INSERT, UPDATE ou DELETE.
- Não modificar tabelas.
- Não criar ou remover índices.
- Não executar novamente o seed.
- Não alterar configurações do PostgreSQL.
- Preservar o banco TechStore.

### Entrega das atividades

Para cada exercício, apresentar:

- Identificação da atividade.
- Consulta SQL desenvolvida.
- Resultado obtido.
- Explicação breve do raciocínio utilizado.
- Dificuldades encontradas, quando houver.

Não é necessário apresentar capturas de tela de todas as consultas. O SQL e os resultados podem ser enviados diretamente na conversa.

---

# Nível 1 — Fundamentos

**Objetivo:** dominar a estrutura básica do SELECT, seleção de colunas, DISTINCT e filtros simples.

## Atividade 01 — Primeira consulta

Tabela: `produtos`

Desenvolva uma consulta que apresente todos os registros da tabela de produtos.

Requisitos:

- Utilizar SELECT.
- Identificar corretamente a origem.
- Observar a quantidade de colunas retornadas.
- Analisar a quantidade de registros apresentada.

**Entrega:** consulta e explicação do resultado.

## Atividade 02 — Seleção específica de colunas

Tabela: `produtos`

Desenvolva uma consulta que apresente somente:

- Identificador do produto.
- Nome.
- Preço.

Requisitos:

- Não utilizar SELECT *.
- Manter a ordem das colunas solicitadas.
- Utilizar o schema explicitamente.

**Entrega:** consulta e explicação da diferença em relação à atividade anterior.

## Atividade 03 — Alias de colunas

Tabela: `produtos`

Apresente as informações de identificação, nome e preço utilizando nomes alternativos mais descritivos no resultado.

Requisitos:

- Utilizar alias.
- Não alterar a estrutura da tabela.
- Utilizar nomes compreensíveis.

**Entrega:** consulta e explicação sobre a finalidade dos aliases.

## Atividade 04 — DISTINCT simples

Tabela: `produtos`

Identifique os diferentes valores existentes na coluna que representa a categoria dos produtos.

Requisitos:

- Utilizar DISTINCT.
- Não apresentar combinações desnecessárias de colunas.
- Explicar por que o resultado pode possuir menos linhas que a tabela original.

**Entrega:** consulta e quantidade de valores distintos encontrados.

## Atividade 05 — DISTINCT composto

Tabela: `produtos`

Identifique as combinações distintas entre categoria e marca dos produtos.

Requisitos:

- Utilizar duas colunas no DISTINCT.
- Interpretar o resultado como combinações.
- Explicar por que o resultado pode conter várias linhas para uma mesma categoria.

**Entrega:** consulta e explicação do comportamento.

## Atividade 06 — Filtro de igualdade

Tabela: `categorias`

Identifique os registros de uma categoria específica, escolhida pelo estudante a partir dos valores existentes no banco.

Requisitos:

- Utilizar WHERE.
- Utilizar operador de igualdade.
- Apresentar somente as colunas necessárias.

**Entrega:** consulta e identificação do critério utilizado.

## Atividade 07 — Filtro numérico

Tabela: `produtos`

Encontre os produtos cujo preço seja superior a um valor escolhido pelo estudante.

Requisitos:

- Utilizar WHERE.
- Utilizar operador de comparação.
- Apresentar identificador, nome e preço.
- Explicar o comportamento do limite escolhido.

**Entrega:** consulta e quantidade de registros retornados.

## Atividade 08 — Filtro de diferença

Tabela: `produtos`

Encontre os produtos cujo preço seja diferente de um valor escolhido pelo estudante.

Requisitos:

- Utilizar operador de diferença.
- Interpretar corretamente o resultado.
- Explicar a diferença entre igualdade e desigualdade.

**Entrega:** consulta e explicação.

---

# Nível 2 — Intermediário

**Objetivo:** combinar condições, trabalhar com intervalos, conjuntos, pesquisas textuais e valores nulos.

## Atividade 09 — AND

Tabela: `produtos`

Encontre produtos que atendam simultaneamente a duas condições:

- Pertencer a uma categoria escolhida.
- Possuir preço acima de um limite escolhido.

Requisitos:

- Utilizar AND.
- Utilizar pelo menos dois critérios.
- Explicar por que ambas as condições precisam ser verdadeiras.

**Entrega:** consulta e interpretação dos resultados.

## Atividade 10 — OR

Tabela: `produtos`

Encontre produtos pertencentes a uma de duas categorias escolhidas.

Requisitos:

- Utilizar OR.
- Garantir que as condições representem a intenção do enunciado.
- Comparar conceitualmente com o exercício anterior.

**Entrega:** consulta e explicação.

## Atividade 11 — Combinação de AND e OR

Tabela: `produtos`

Encontre produtos que atendam à seguinte regra:

- Pertencer a uma das duas categorias escolhidas.
- Possuir preço acima de um valor mínimo.

Requisitos:

- Utilizar AND e OR.
- Utilizar parênteses para deixar explícita a lógica.
- Explicar a precedência dos operadores.

**Entrega:** consulta e explicação da lógica utilizada.

## Atividade 12 — NOT

Tabela: `produtos`

Encontre produtos que não atendam a uma condição escolhida pelo estudante.

Requisitos:

- Utilizar NOT.
- Explicar o efeito da negação.
- Considerar o comportamento de valores NULL, caso a condição envolva uma coluna que os permita.

**Entrega:** consulta e explicação.

## Atividade 13 — IN

Tabela: `produtos`

Encontre produtos pertencentes a um conjunto de pelo menos três categorias escolhidas.

Requisitos:

- Utilizar IN.
- Apresentar as categorias consideradas.
- Comparar a legibilidade com uma solução construída por múltiplas condições OR.

**Entrega:** consulta e comparação conceitual.

## Atividade 14 — NOT IN

Tabela: `produtos`

Encontre produtos que não pertençam a um conjunto de categorias escolhido.

Requisitos:

- Utilizar NOT IN.
- Investigar se a coluna utilizada permite NULL.
- Explicar o impacto que NULL poderia causar na condição.

**Entrega:** consulta e análise do comportamento.

## Atividade 15 — BETWEEN

Tabela: `produtos`

Encontre produtos cujo preço esteja dentro de um intervalo escolhido.

Requisitos:

- Utilizar BETWEEN.
- Apresentar os limites utilizados.
- Verificar se os valores dos limites também são considerados.
- Comparar conceitualmente com o uso de dois operadores de comparação.

**Entrega:** consulta e explicação da inclusividade.

## Atividade 16 — Pesquisa com LIKE

Tabela: `produtos`

Localize produtos cujo nome corresponda a um padrão textual escolhido.

Requisitos:

- Utilizar LIKE.
- Utilizar pelo menos um dos caracteres `%` ou `_`.
- Explicar o padrão utilizado.
- Identificar a diferença entre pesquisar prefixos e trechos de texto.

**Entrega:** consulta e explicação.

## Atividade 17 — Pesquisa com ILIKE

Tabela: `produtos`

Realize uma pesquisa textual sem diferenciar letras maiúsculas e minúsculas.

Requisitos:

- Utilizar ILIKE.
- Escolher um termo presente nos dados.
- Comparar o comportamento com LIKE.
- Explicar que ILIKE é uma extensão específica do PostgreSQL.

**Entrega:** duas consultas comparativas e interpretação.

## Atividade 18 — Tratamento de NULL

Tabela: `clientes`

Investigue uma coluna opcional que permita valores NULL.

Desenvolva consultas que identifiquem:

- Registros em que a coluna esteja NULL.
- Registros em que a coluna não esteja NULL.

Requisitos:

- Utilizar IS NULL.
- Utilizar IS NOT NULL.
- Não confundir NULL com texto vazio.
- Explicar a diferença entre os conjuntos encontrados.

**Entrega:** consultas e comparação das quantidades.

---

# Nível 3 — Avançado

**Objetivo:** construir consultas compostas, ordenar resultados, implementar paginação e interpretar situações mais complexas.

## Atividade 19 — Ordenação crescente

Tabela: `produtos`

Apresente os produtos ordenados pelo preço, do menor para o maior.

Requisitos:

- Utilizar ORDER BY.
- Utilizar ASC.
- Apresentar identificador, nome e preço.
- Verificar se existem valores repetidos.

**Entrega:** consulta e explicação da ordenação.

## Atividade 20 — Ordenação decrescente

Tabela: `produtos`

Apresente os produtos do maior preço para o menor.

Requisitos:

- Utilizar DESC.
- Apresentar os primeiros resultados.
- Explicar a diferença entre ASC e DESC.

**Entrega:** consulta e interpretação.

## Atividade 21 — Ordenação múltipla

Tabela: `produtos`

Organize os produtos considerando:

1. Categoria em ordem crescente.
2. Preço em ordem decrescente.
3. Identificador como critério adicional para desempate.

Requisitos:

- Utilizar múltiplas colunas no ORDER BY.
- Definir a direção de cada ordenação.
- Explicar a importância do critério adicional.

**Entrega:** consulta e explicação da prioridade de ordenação.

## Atividade 22 — Controle de resultados

Tabela: `produtos`

Apresente somente uma quantidade limitada de produtos.

Requisitos:

- Utilizar LIMIT.
- Selecionar uma quantidade definida pelo estudante.
- Apresentar uma ordenação determinística.
- Explicar por que LIMIT não garante que somente essa quantidade de registros será examinada pelo banco.

**Entrega:** consulta e explicação.

## Atividade 23 — Paginação

Tabela: `produtos`

Implemente uma paginação simples utilizando LIMIT e OFFSET.

Requisitos:

- Definir um tamanho de página.
- Consultar pelo menos três páginas.
- Manter uma ordenação determinística.
- Explicar como o OFFSET de cada página foi calculado.
- Investigar por que a paginação pode ser inconsistente sem ordenação adequada.

**Entrega:** consultas das páginas e explicação da estratégia.

## Atividade 24 — Consulta composta de produtos

Tabela: `produtos`

Construa uma consulta que encontre produtos:

- De duas categorias escolhidas.
- Com preço dentro de um intervalo.
- Com nome correspondente a um padrão textual.
- Ordenados pelo preço do maior para o menor.
- Limitados a uma quantidade definida.

Requisitos:

- Combinar SELECT, WHERE, AND, OR, IN ou BETWEEN, LIKE ou ILIKE, ORDER BY e LIMIT, conforme a solução escolhida.
- Utilizar parênteses quando necessários.
- Apresentar somente as colunas relevantes.
- Explicar cada parte da consulta.

**Entrega:** consulta completa e interpretação dos resultados.

## Atividade 25 — Consulta temporal

Tabela: `pedidos`

Investigue a coluna que representa a data ou o horário do pedido.

Construa uma consulta que encontre os pedidos realizados dentro de um período escolhido.

Requisitos:

- Verificar primeiro o tipo da coluna.
- Utilizar limites temporais adequados.
- Considerar corretamente a inclusão ou exclusão dos limites.
- Caso a coluna seja TIMESTAMP, demonstrar o cuidado com o horário final do período.
- Ordenar os resultados cronologicamente.

**Entrega:** consulta, tipo da coluna e justificativa do intervalo escolhido.

---

# Nível 4 — Desafios profissionais

**Objetivo:** desenvolver autonomia, raciocínio analítico, validação de resultados e percepção de desempenho.

## Atividade 26 — Investigação de acessos

Tabela: `acessos`

A tabela possui grande volume de registros.

Construa uma consulta para investigar os acessos mais recentes.

Requisitos:

- Identificar as colunas temporais disponíveis.
- Apresentar somente as colunas relevantes.
- Ordenar do mais recente para o mais antigo.
- Utilizar LIMIT.
- Definir um critério adicional de desempate quando possível.
- Explicar por que uma ordenação determinística é importante.

**Entrega:** consulta, resultado e justificativa técnica.

## Atividade 27 — Diagnóstico de uma consulta incorreta

Considere o seguinte requisito:

"Encontrar produtos que pertençam à categoria A ou à categoria B e que possuam preço superior a um limite definido."

Analise duas possibilidades de construção da condição:

- Uma expressão que não utiliza parênteses.
- Uma expressão que utiliza parênteses para agrupar as categorias.

Requisitos:

- Demonstrar o comportamento da precedência entre AND e OR.
- Identificar se as duas expressões são equivalentes.
- Construir um exemplo em que os resultados sejam diferentes.
- Explicar qual expressão representa corretamente o requisito.

**Entrega:** consultas comparativas e diagnóstico.

## Atividade 28 — Validação de resultados

Tabela: `produtos`

Construa uma consulta com pelo menos três condições diferentes.

Depois, valide seu resultado por meio de consultas independentes.

Requisitos:

- Escolher condições que possam ser verificadas separadamente.
- Conferir se os registros retornados atendem a todas as condições.
- Investigar possíveis registros ausentes.
- Conferir se existem duplicidades inesperadas.
- Explicar como a validação foi realizada.

**Entrega:** consulta principal, consultas de conferência e explicação.

## Atividade 29 — Análise inicial de desempenho

Tabela: `acessos` ou `logs_sistema`

Escolha uma consulta de leitura que utilize filtros e ordenação em uma tabela de grande volume.

Realize uma investigação inicial do plano de execução.

Requisitos:

- Confirmar primeiro a correção lógica.
- Registrar a consulta utilizada.
- Executar EXPLAIN.
- Executar EXPLAIN ANALYZE na consulta SELECT controlada.
- Identificar o tipo de operação principal.
- Observar Planning Time e Execution Time.
- Observar Plan Rows e Actual Rows.
- Analisar Shared Hit Blocks e Shared Read Blocks, quando apresentados.
- Explicar o comportamento observado.

Não será exigido modificar índices ou configurações.

**Entrega:** consulta, plano de execução e análise técnica.

## Atividade 30 — Desafio final: exploração comercial da TechStore

### Contexto

A equipe comercial da TechStore precisa investigar o catálogo de produtos para preparar uma análise de oportunidades comerciais.

Você deverá construir consultas que permitam explorar o catálogo utilizando diferentes critérios.

### Parte A — Exploração

Investigue a estrutura da tabela de produtos e identifique as colunas relevantes para a análise.

### Parte B — Filtragem

Construa uma consulta que utilize diferentes critérios de seleção, considerando características como:

- Categoria.
- Marca.
- Preço.
- Nome.
- Disponibilidade de informações opcionais.

Os critérios deverão ser escolhidos com base nos dados existentes.

### Parte C — Organização

Organize os resultados de maneira que sejam úteis para a equipe comercial.

Considere:

- Ordenação.
- Critérios de desempate.
- Quantidade máxima de resultados.
- Clareza das colunas apresentadas.

### Parte D — Validação

Demonstre que os resultados atendem aos requisitos.

A validação deverá considerar:

- Condições individuais.
- Combinação de condições.
- Valores NULL, quando aplicável.
- Limites dos intervalos.
- Resultados vazios.
- Ordenação.

### Parte E — Análise técnica

Explique:

- Por que escolheu os filtros.
- Como organizou a consulta.
- Quais possíveis erros lógicos precisou evitar.
- Como avaliou o resultado.
- Se existe alguma oportunidade de melhorar a consulta.

### Entrega final

Apresente:

1. Consulta principal.
2. Consultas auxiliares de validação.
3. Resultados obtidos.
4. Explicação das decisões.
5. Análise crítica da solução.

Não existe uma única combinação de filtros obrigatória. A qualidade será avaliada pela coerência entre os requisitos definidos, a consulta construída e os resultados apresentados.

---

# 3. Critérios gerais de correção

Todas as atividades serão avaliadas considerando cinco dimensões.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nem todas as dimensões terão a mesma relevância em todos os exercícios.

Por exemplo, atividades introdutórias terão maior foco na sintaxe e na compreensão dos operadores. Nos desafios profissionais, a validação e o desempenho terão maior importância.

---

# 4. Regras para solicitar ajuda

O estudante poderá solicitar ajuda durante qualquer atividade.

A orientação seguirá uma progressão:

**Nível 1 — Direcionamento**

Indicação do conceito ou cláusula que deverá ser investigado.

**Nível 2 — Diagnóstico**

Análise da consulta apresentada e identificação do problema.

**Nível 3 — Orientação técnica**

Explicação mais específica sobre a correção necessária, sem necessariamente entregar a solução completa.

**Nível 4 — Demonstração**

Apresentação de uma solução completa quando solicitada explicitamente ou quando necessária para consolidar o aprendizado.

O objetivo é desenvolver autonomia, não criar dependência de respostas prontas.

---

# 5. Critérios de conclusão

O estudante deverá:

- Demonstrar domínio dos fundamentos do SELECT.
- Construir filtros simples e compostos.
- Compreender AND, OR e NOT.
- Utilizar corretamente IN e BETWEEN.
- Trabalhar com LIKE e ILIKE.
- Tratar NULL corretamente.
- Ordenar e limitar resultados.
- Construir consultas compostas.
- Validar resultados independentemente.
- Interpretar um plano básico de execução.
- Concluir o desafio final.

**Nota mínima de referência:** 85%.

Erros críticos de lógica, interpretação ou preservação do banco poderão exigir revisão e revalidação, independentemente da nota.

---

# 6. Próximo módulo

Após a conclusão e aprovação deste módulo, o estudante estará preparado para:

**Módulo 03 — Expressões e funções SQL**

Nesse módulo serão estudadas técnicas para transformar, manipular e interpretar valores diretamente nas consultas.