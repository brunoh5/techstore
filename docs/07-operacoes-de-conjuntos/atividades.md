# Atividades — Módulo 07: Operações de Conjuntos

## 1. Orientações gerais

Este documento contém os exercícios práticos do Módulo 07 — Operações de Conjuntos.

O objetivo é desenvolver a capacidade de combinar resultados de consultas utilizando os operadores disponíveis no PostgreSQL.

### Regras de execução

- Utilizar exclusivamente consultas `SELECT`.
- Não modificar os dados da TechStore.
- Não executar novamente os arquivos de seed.
- Não criar, excluir ou alterar estruturas no banco principal.
- Executar consultas individualmente.
- Respeitar a estrutura real das tabelas.
- Validar os resultados antes de considerar uma atividade concluída.

### Como apresentar cada atividade

Para cada exercício, registrar:

1. Identificação da atividade.
2. Consulta SQL desenvolvida.
3. Resultado obtido.
4. Explicação do raciocínio.
5. Operador escolhido.
6. Justificativa da escolha.
7. Observações sobre duplicidades, NULL e granularidade, quando aplicável.

Não basta apresentar uma consulta que execute sem erros. Ela precisa produzir exatamente o resultado solicitado.

---

# NÍVEL 1 — FUNDAMENTOS

Objetivo: compreender a estrutura das operações de conjuntos e dominar UNION e UNION ALL.

## AT-01 — Lista unificada de pessoas

Construa uma consulta que reúna clientes e funcionários em uma única lista.

Colunas esperadas:

- Identificador.
- Nome.
- E-mail.
- Tipo de registro.

Identifique a origem de cada registro utilizando um valor textual para diferenciar clientes de funcionários.

Utilize `UNION ALL`.

**Conceito:** combinação de resultados com identificação de origem.

## AT-02 — Lista unificada com UNION

Repita a atividade anterior utilizando `UNION`.

Compare os resultados com a atividade AT-01.

Explique por que os resultados podem ou não apresentar diferenças.

**Conceito:** eliminação de duplicidades.

## AT-03 — Identificadores de clientes e funcionários

Combine os identificadores de clientes e funcionários em um único resultado.

Utilize `UNION`.

Depois, repita utilizando `UNION ALL`.

Analise se existem identificadores repetidos entre as duas fontes.

**Conceito:** comparação de duplicidades considerando todas as colunas retornadas.

## AT-04 — Produtos ativos e produtos caros

Construa uma consulta que reúna:

- Produtos ativos.
- Produtos com preço superior a R$ 1.000.

Apresente:

- ID.
- Nome.
- Preço.
- Origem da seleção.

Utilize `UNION ALL`.

Um mesmo produto poderá atender às duas condições. Analise o que acontece com essas ocorrências.

## AT-05 — Produtos ativos e produtos caros sem repetição

Repita a atividade anterior utilizando `UNION`.

Compare a quantidade de linhas e explique a diferença entre os dois operadores.

## AT-06 — Relatório de categorias

Construa uma consulta que apresente os identificadores de categorias utilizados pelos produtos.

Combine esse resultado com os identificadores de categorias existentes na tabela `categorias`.

Utilize uma operação de conjuntos adequada para reunir as informações.

**Conceito:** compatibilidade entre colunas e combinação de resultados.

## AT-07 — Relatório de clientes e acessos

Construa um conjunto de identificadores que reúna:

- Clientes cadastrados.
- Clientes associados a registros de acesso.

Considere que `acessos.cliente_id` pode conter `NULL`.

Defina como tratar esses valores antes da operação.

**Conceito:** filtros e NULL em operações de conjuntos.

## AT-08 — Compatibilidade entre consultas

Crie três pequenas consultas de leitura que demonstrem:

1. Combinação de duas consultas com a mesma quantidade de colunas e tipos compatíveis.
2. Tentativa de combinação com quantidade diferente de colunas.
3. Tentativa de combinação com tipos incompatíveis.

Execute somente os exemplos válidos no banco principal. As situações inválidas poderão ser documentadas ou testadas em ambiente isolado.

Explique os erros encontrados.

**Conceito:** regras de compatibilidade.

---

# NÍVEL 2 — INTERSECT E EXCEPT

Objetivo: identificar registros comuns e diferenças entre conjuntos.

## AT-09 — Clientes com pedidos e acessos

Utilize `INTERSECT` para encontrar clientes que:

- Possuem pelo menos um pedido.
- Aparecem em registros de acesso.

Retorne os identificadores dos clientes.

## AT-10 — Produtos vendidos e avaliados

Encontre os produtos que aparecem simultaneamente em:

- `itens_pedido`.
- `avaliacoes`.

Utilize `INTERSECT`.

Apresente o identificador e o nome dos produtos.

## AT-11 — Funcionários com movimentações e logs

Identifique os funcionários que possuem registros nas duas tabelas:

- `movimentacoes_estoque`.
- `logs_sistema`.

Considere que os campos de funcionário podem conter `NULL`.

Utilize uma operação de conjuntos adequada.

## AT-12 — Clientes sem pedidos

Utilize `EXCEPT` para identificar clientes que não possuem pedidos.

Apresente:

- ID.
- Nome.
- E-mail.

Não utilize JOIN ou NOT EXISTS nesta atividade.

## AT-13 — Produtos sem vendas

Identifique os produtos que não aparecem na tabela `itens_pedido`.

Utilize `EXCEPT`.

Apresente os dados de identificação dos produtos.

## AT-14 — Produtos avaliados e não vendidos

Identifique produtos que possuem avaliações, mas não aparecem em itens de pedidos.

Utilize `EXCEPT`.

Explique o significado comercial do resultado.

## AT-15 — Clientes com pedidos, mas sem acessos identificados

Construa uma operação que identifique clientes que aparecem no conjunto de clientes com pedidos, mas não aparecem no conjunto de clientes com acessos.

Trate os valores `NULL` de maneira explícita.

**Conceito:** diferença entre conjuntos e integridade semântica.

## AT-16 — Diferença entre EXCEPT e EXCEPT invertido

Utilize os conjuntos de clientes e funcionários para executar:

- Clientes EXCEPT funcionários.
- Funcionários EXCEPT clientes.

Explique por que os resultados podem ser diferentes.

Considere que identificadores iguais não representam necessariamente a mesma pessoa.

---

# NÍVEL 3 — DUPLICIDADES E MULTIPLICIDADES

Objetivo: compreender as diferenças entre operações tradicionais e variantes ALL.

## AT-17 — Comparação de UNION e UNION ALL

Utilize duas consultas sobre a tabela `produtos`:

- Uma que retorne produtos ativos.
- Outra que retorne produtos com preço superior a um valor definido.

Execute a combinação com UNION e UNION ALL.

Compare:

- Total de linhas.
- Total de linhas distintas.
- Diferença entre os resultados.

## AT-18 — Comparação de INTERSECT e INTERSECT ALL

Utilize duas consultas que produzam identificadores com ocorrências repetidas.

Compare os resultados de:

- INTERSECT.
- INTERSECT ALL.

Para demonstrar o comportamento de multiplicidade, utilize uma pequena relação de valores criada apenas dentro da própria consulta, sem modificar o banco.

## AT-19 — Comparação de EXCEPT e EXCEPT ALL

Crie dois pequenos conjuntos de valores utilizando `VALUES` dentro de uma consulta.

Faça uma comparação entre:

- EXCEPT.
- EXCEPT ALL.

Registre como a quantidade de ocorrências altera o resultado.

## AT-20 — Multiplicidade e interpretação

Monte um exemplo independente que contenha:

- Valores repetidos no primeiro conjunto.
- Valores repetidos no segundo conjunto.
- Valores exclusivos.
- Valores comuns.

Demonstre o comportamento dos seis operadores:

- UNION.
- UNION ALL.
- INTERSECT.
- INTERSECT ALL.
- EXCEPT.
- EXCEPT ALL.

Explique cada resultado.

---

# NÍVEL 4 — OPERAÇÕES AVANÇADAS

Objetivo: combinar operações de conjuntos, filtros, agregações e subconsultas.

## AT-21 — Operações encadeadas

Construa uma consulta que reúna identificadores de:

- Clientes.
- Funcionários.
- Clientes presentes em pedidos.

Utilize mais de uma operação de conjuntos.

Depois, explique a ordem de avaliação utilizada.

## AT-22 — Precedência dos operadores

Crie uma consulta que combine `UNION`, `INTERSECT` e `EXCEPT`.

Construa duas versões:

1. Sem parênteses.
2. Com parênteses.

Analise as diferenças de interpretação e resultado.

Utilize pequenos conjuntos de valores para tornar o comportamento previsível.

## AT-23 — Relatório de produtos por origem

Crie um relatório unificado com produtos classificados em três grupos:

- Produtos ativos.
- Produtos com estoque abaixo do mínimo.
- Produtos que possuem avaliações.

Cada grupo deverá apresentar:

- ID do produto.
- Nome.
- Categoria.
- Origem da classificação.

Utilize `UNION ALL`.

Observe que um produto poderá aparecer em mais de um grupo.

## AT-24 — Relatório sem duplicidades por produto

Repita a atividade AT-23, mas agora apresente cada produto apenas uma vez.

Defina uma estratégia para preservar as informações sobre as origens sem produzir múltiplas linhas para o mesmo produto.

Explique as decisões tomadas.

## AT-25 — Operações com agregações

Construa uma consulta que combine dois relatórios:

- Quantidade de produtos por categoria.
- Quantidade de produtos ativos por categoria.

Inclua uma coluna que identifique a origem de cada métrica.

Utilize `UNION ALL`.

## AT-26 — Comparação de períodos

Construa dois conjuntos de pedidos:

- Pedidos realizados em um período anterior.
- Pedidos realizados em um período posterior.

Utilize `INTERSECT` para identificar os identificadores que aparecem nos dois conjuntos.

Explique por que o resultado pode ser vazio quando os conjuntos representam períodos mutuamente exclusivos e a chave é o identificador do pedido.

Depois, adapte o problema para comparar clientes que compraram nos dois períodos.

## AT-27 — Operações com NULL

Utilize pequenos conjuntos construídos com `VALUES` para testar o comportamento de NULL em:

- UNION.
- INTERSECT.
- EXCEPT.
- UNION ALL.
- INTERSECT ALL.
- EXCEPT ALL.

Explique a diferença entre a comparação tradicional com `=` e a comparação utilizada pelas operações de conjuntos.

## AT-28 — Operações com subconsultas

Construa uma consulta que utilize uma operação de conjuntos dentro de uma subconsulta.

A consulta principal deverá utilizar o resultado combinado para filtrar registros da TechStore.

Explique o papel de cada nível.

## AT-29 — Operações com CTE

Construa uma CTE que reúna informações de clientes e funcionários.

Utilize a CTE na consulta principal para:

- Filtrar registros.
- Ordenar resultados.
- Apresentar uma quantidade limitada de linhas.

Explique por que a CTE pode facilitar a leitura.

## AT-30 — Ordenação e LIMIT

Construa uma consulta com `UNION ALL` entre clientes e funcionários.

Ordene o resultado final por nome e limite a quantidade de registros.

Depois, construa uma versão em que cada consulta individual possua seu próprio limite.

Compare os resultados e explique a diferença.

---

# NÍVEL 5 — COMPARAÇÃO E ANÁLISE

Objetivo: escolher corretamente entre operações de conjuntos, JOINs e subconsultas.

## AT-31 — INTERSECT versus INNER JOIN

Encontre clientes que possuem pedidos e registros de acesso.

Resolva utilizando:

1. INTERSECT.
2. INNER JOIN.

Compare:

- Quantidade de registros.
- Duplicidades.
- Granularidade.
- Legibilidade.

Explique por que os resultados podem apresentar quantidades diferentes.

## AT-32 — EXCEPT versus NOT EXISTS

Identifique clientes sem pedidos utilizando:

1. EXCEPT.
2. NOT EXISTS.

Compare as consultas e explique em quais situações cada abordagem é mais adequada.

## AT-33 — UNION versus JOIN

Construa dois relatórios:

- Um que reúna clientes e funcionários.
- Outro que relacione pedidos com clientes.

Explique por que UNION é adequado para o primeiro e JOIN para o segundo.

## AT-34 — INTERSECT versus EXISTS

Identifique produtos que possuem avaliações.

Resolva utilizando:

1. INTERSECT.
2. EXISTS.

Compare os resultados e a semântica de cada abordagem.

## AT-35 — Diferenças de granularidade

Construa uma consulta que combine identificadores de produtos com informações agregadas de vendas.

Explique por que a quantidade de linhas pode mudar quando o resultado é agrupado por produto, categoria ou pedido.

Identifique qual granularidade é adequada para cada relatório.

---

# NÍVEL 6 — DESEMPENHO E EXECUÇÃO

Objetivo: compreender os planos de execução e os custos das operações de conjuntos.

**Atenção:** execute as consultas deste nível individualmente. `EXPLAIN ANALYZE` executa efetivamente a consulta.

## AT-36 — Plano de execução do UNION

Utilize `EXPLAIN` para analisar uma consulta que combine identificadores de clientes e funcionários utilizando UNION.

Identifique os nós do plano.

Observe se há operações relacionadas à ordenação ou eliminação de duplicidades.

## AT-37 — Plano de execução do UNION ALL

Repita a análise da atividade anterior utilizando UNION ALL.

Compare os planos.

Explique quais operações deixaram de ser necessárias.

## AT-38 — INTERSECT e EXCEPT

Analise os planos de execução de consultas com INTERSECT e EXCEPT.

Observe:

- Tipo de nó.
- Linhas estimadas.
- Custo estimado.
- Operações de comparação.
- Possíveis estruturas de hashing.

## AT-39 — EXPLAIN ANALYZE e BUFFERS

Escolha uma consulta de operação de conjuntos que utilize tabelas com grande volume de dados.

Execute:

`EXPLAIN (ANALYZE, BUFFERS)`

Registre:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Nós de execução.

Explique o que os resultados indicam.

## AT-40 — Comparação de desempenho

Escolha um problema que possa ser resolvido com duas abordagens semanticamente equivalentes.

Compare:

- UNION versus UNION ALL, quando a eliminação de duplicidades não for necessária.
- INTERSECT versus JOIN, quando os resultados e a granularidade forem equivalentes.
- EXCEPT versus NOT EXISTS, quando os resultados forem equivalentes.

Não compare apenas o tempo.

Valide primeiro a igualdade dos resultados.

Apresente uma justificativa técnica para a abordagem escolhida.

---

# DESAFIOS FINAIS

Os desafios devem ser resolvidos individualmente.

O objetivo é combinar os conhecimentos adquiridos ao longo dos módulos anteriores.

## DES-01 — Relatório consolidado de pessoas

A TechStore precisa de um relatório que reúna clientes e funcionários.

O resultado deverá apresentar:

- Identificador.
- Nome.
- E-mail.
- Tipo de pessoa.

Requisitos:

- Não confundir identificadores iguais de tabelas diferentes.
- Identificar a origem de cada registro.
- Ordenar o resultado.
- Evitar eliminação indevida de ocorrências.
- Explicar a escolha do operador.

## DES-02 — Análise de relacionamento comercial

Construa um relatório que identifique:

- Clientes com pedidos.
- Clientes com acessos.
- Clientes presentes nos dois conjuntos.
- Clientes exclusivos de cada conjunto.

Apresente os resultados de forma organizada.

Requisitos:

- Utilizar operações de conjuntos.
- Tratar NULL.
- Evitar duplicidades indevidas.
- Explicar a diferença entre interseção e diferença.

## DES-03 — Auditoria de produtos

Construa um relatório que identifique:

- Produtos vendidos.
- Produtos avaliados.
- Produtos vendidos e avaliados.
- Produtos vendidos, mas não avaliados.
- Produtos avaliados, mas não vendidos.
- Produtos sem vendas e sem avaliações.

Requisitos:

- Utilizar operações de conjuntos.
- Recuperar informações descritivas dos produtos.
- Preservar a granularidade por produto.
- Validar se os grupos são consistentes.
- Identificar eventuais sobreposições.

## DES-04 — Relatório de atividade dos funcionários

Construa um relatório que compare funcionários que aparecem em:

- Movimentações de estoque.
- Logs do sistema.

Identifique:

- Funcionários presentes nos dois conjuntos.
- Funcionários exclusivos de movimentações.
- Funcionários exclusivos de logs.
- Funcionários que não aparecem em nenhum dos dois conjuntos.

Requisitos:

- Tratar corretamente os valores NULL.
- Evitar contar registros como se fossem funcionários.
- Manter a granularidade por funcionário.
- Justificar as operações escolhidas.

## DES-05 — Consolidação de indicadores

Construa um relatório que reúna indicadores de produtos por categoria.

O relatório deverá combinar:

- Quantidade total de produtos.
- Quantidade de produtos ativos.
- Quantidade de produtos com estoque.
- Quantidade de produtos avaliados.

Requisitos:

- Cada linha deve identificar a categoria e o indicador.
- As métricas devem possuir granularidade consistente.
- Não realizar somas indevidas entre métricas diferentes.
- Utilizar uma operação de conjuntos adequada.
- Explicar a origem de cada indicador.

## DES-06 — Investigação e otimização

Escolha uma consulta desenvolvida durante o módulo que utilize uma operação de conjuntos.

Produza duas versões semanticamente equivalentes, quando possível.

Investigue:

- Diferenças de execução.
- Eliminação de duplicidades.
- Operações de ordenação.
- Hashing.
- Quantidade de linhas.
- Uso de memória.
- Planejamento.
- Tempo de execução.

Entregue uma análise explicando:

1. Qual era o problema original?
2. Quais abordagens foram comparadas?
3. Os resultados são equivalentes?
4. Qual plano foi escolhido pelo PostgreSQL?
5. Qual abordagem apresentou melhor comportamento?
6. Quais são as limitações da comparação?
7. Qual versão você recomendaria e por quê?

---

# PERGUNTAS DE COMPREENSÃO

Responder sem executar consultas, sempre que possível.

1. Qual é a finalidade de UNION?
2. Qual é a diferença entre UNION e UNION ALL?
3. Como o PostgreSQL identifica duplicidades?
4. Por que a quantidade de colunas precisa ser igual?
5. A correspondência entre colunas ocorre pelo nome ou pela posição?
6. Qual é a finalidade de INTERSECT?
7. Qual é a diferença entre INTERSECT e INTERSECT ALL?
8. Qual é a finalidade de EXCEPT?
9. Por que a ordem dos conjuntos importa no EXCEPT?
10. Qual é a diferença entre EXCEPT e EXCEPT ALL?
11. Como NULL é tratado nas operações de conjuntos?
12. Por que UNION pode exigir mais processamento que UNION ALL?
13. Qual é a diferença entre JOIN e UNION?
14. Em quais situações INTERSECT pode substituir um JOIN?
15. Por que NOT EXISTS pode ser uma alternativa ao EXCEPT?
16. Qual é a importância dos parênteses em operações encadeadas?
17. Como ORDER BY funciona em uma operação de conjuntos?
18. O que acontece quando cada consulta possui um LIMIT próprio?
19. Quais nós de execução podem aparecer em operações de conjuntos?
20. Por que uma consulta mais rápida não é necessariamente uma consulta melhor?

---

# CRITÉRIOS DE CONCLUSÃO

Para considerar as atividades concluídas, o aluno deverá:

- Resolver os exercícios progressivos.
- Demonstrar domínio dos seis operadores.
- Explicar a diferença entre conjuntos distintos e multiplicidades.
- Tratar corretamente NULL.
- Compreender a compatibilidade entre consultas.
- Resolver operações encadeadas.
- Comparar operações de conjuntos com JOINs e subconsultas.
- Analisar planos de execução.
- Concluir os seis desafios.
- Responder às perguntas de compreensão.

## Critérios de avaliação

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio de SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: **85 pontos**.

Erros críticos de lógica, compatibilidade, duplicidade ou interpretação de resultados deverão ser corrigidos antes da aprovação.

---

# REGISTRO DE PROGRESSO

| Etapa | Situação |
|---|---|
| Nível 1 — Fundamentos | Pendente |
| Nível 2 — INTERSECT e EXCEPT | Pendente |
| Nível 3 — Multiplicidades | Pendente |
| Nível 4 — Operações avançadas | Pendente |
| Nível 5 — Comparações | Pendente |
| Nível 6 — Desempenho | Pendente |
| DES-01 | Pendente |
| DES-02 | Pendente |
| DES-03 | Pendente |
| DES-04 | Pendente |
| DES-05 | Pendente |
| DES-06 | Pendente |
| Perguntas de compreensão | Pendente |
| Validação independente | Pendente |
| Nota final | Não avaliado |
| Situação geral | Não iniciado |

### Situações possíveis

- Não iniciado.
- Em andamento.
- Revisão necessária.
- Aprovado.
- Concluído.

---

## REGRAS FINAIS

1. Não consultar gabaritos antes de tentar resolver as atividades.
2. Não copiar consultas sem compreender sua finalidade.
3. Não considerar uma consulta correta apenas porque executou sem erros.
4. Conferir a quantidade de linhas e a granularidade.
5. Comparar resultados quando existirem abordagens alternativas.
6. Preservar o banco principal da TechStore.
7. Registrar dúvidas e dificuldades para revisão direcionada.

**Próxima etapa:** `validacao.md` — testes independentes para verificar o domínio de operações de conjuntos antes da liberação do Módulo 08.