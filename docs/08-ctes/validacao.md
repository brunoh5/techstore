# Validação — Módulo 08: CTEs (Common Table Expressions)

## 1. Objetivo da validação

Este documento estabelece os critérios técnicos para verificar se o aluno domina CTEs no PostgreSQL 16.

A validação deverá comprovar que o aluno consegue:

- Declarar CTEs corretamente.
- Organizar consultas em etapas.
- Encadear múltiplas CTEs.
- Integrar CTEs com JOINs e agregações.
- Trabalhar com operações de conjuntos.
- Utilizar CTEs recursivas.
- Controlar condições de parada.
- Identificar e prevenir ciclos.
- Compreender `SEARCH` e `CYCLE`.
- Diferenciar materialização e incorporação.
- Interpretar planos de execução.
- Comparar alternativas de implementação.

A validação será independente dos exercícios realizados durante o estudo.

Não será suficiente apresentar uma consulta que apenas execute sem erros.

---

## 2. Regras de segurança

A TechStore principal deverá ser preservada.

Regras obrigatórias:

- Não executar novamente o seed.
- Não modificar registros.
- Não excluir dados.
- Não alterar tabelas.
- Não criar índices.
- Não criar objetos permanentes.
- Não executar DML.
- Priorizar consultas `SELECT`.
- Utilizar `VALUES` para estruturas de demonstração.
- Executar `EXPLAIN ANALYZE` individualmente.

As atividades de recursividade deverão utilizar conjuntos de demonstração, sem necessidade de modificar o schema.

---

## 3. Critérios de avaliação

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

Nota mínima de referência: **85%**.

Erros críticos de lógica, segurança ou controle de recursividade impedem a aprovação.

---

# 4. Validação de fundamentos

## VAL-01 — Declaração de CTE

Verificar se o aluno consegue:

- Utilizar `WITH`.
- Declarar uma CTE.
- Definir corretamente o nome.
- Escrever a consulta interna.
- Consumir o resultado na consulta principal.

**Critérios de aprovação:**

- Sintaxe válida.
- Resultado correto.
- Referência correta à CTE.
- Ausência de dependências inexistentes.

## VAL-02 — Definição de colunas

Verificar se o aluno consegue declarar aliases de colunas diretamente na CTE.

Testar:

- Correspondência entre nomes e colunas.
- Quantidade de colunas.
- Ordem dos campos.
- Tipos compatíveis.

**Critério crítico:** não aceitar consultas cuja estrutura de colunas esteja incompatível com os dados retornados.

## VAL-03 — CTE com filtros e expressões

Verificar utilização de:

- `WHERE`.
- `AND` e `OR`.
- `CASE`.
- Expressões aritméticas.
- Funções SQL.
- Tratamento de `NULL`.

O aluno deverá explicar em qual etapa cada expressão é aplicada.

## VAL-04 — Escopo da CTE

Verificar se o aluno compreende que uma CTE comum existe somente durante a instrução em que foi declarada.

Testar:

- Uso na consulta principal.
- Referência em outras CTEs.
- Reutilização na mesma instrução.
- Tentativa de utilização em instrução posterior sem nova declaração.

**Critério de aprovação:** compreensão correta do escopo.

---

# 5. Validação de múltiplas CTEs

## VAL-05 — Encadeamento

Verificar se o aluno consegue declarar pelo menos três CTEs dependentes.

Critérios:

- Ordem de declaração válida.
- Dependências corretas.
- Resultados intermediários coerentes.
- Consulta final correta.

## VAL-06 — Independência entre CTEs

Apresentar uma consulta com indicadores provenientes de tabelas diferentes.

Verificar se o aluno consegue calcular os indicadores separadamente e consolidá-los.

Critérios:

- Ausência de multiplicação indevida.
- Granularidade preservada.
- Agregações corretas.
- Tratamento adequado de registros ausentes.

## VAL-07 — CTE com JOIN

Verificar integração com:

- `INNER JOIN`.
- `LEFT JOIN`.
- Múltiplas tabelas.
- Resultados agregados.
- Identificação de registros sem correspondência.

O aluno deverá explicar por que escolheu determinado tipo de JOIN.

## VAL-08 — CTE com operações de conjuntos

Verificar integração com:

- `UNION`.
- `UNION ALL`.
- `INTERSECT`.
- `EXCEPT`.

Critérios:

- Compatibilidade entre consultas.
- Ordem correta das colunas.
- Tratamento de duplicidades.
- Tratamento de `NULL`.
- Preservação da origem quando necessário.

## VAL-09 — Granularidade e duplicidade

Apresentar uma situação em que um produto possua múltiplos itens de pedido e avaliações.

Verificar se o aluno consegue produzir um relatório com uma linha por produto sem multiplicar indevidamente os valores agregados.

**Critério crítico:** não aceitar uma solução que apresente totais inflados devido a JOINs entre relações de cardinalidades diferentes.

---

# 6. Validação de integração SQL

## VAL-10 — CTE com subconsulta

Verificar se o aluno consegue integrar subconsultas em CTEs.

Avaliar:

- Subconsulta escalar.
- Subconsulta correlacionada.
- Subconsulta no `FROM`.
- Comparações com agregações.

O resultado deverá ser logicamente correto.

## VAL-11 — CTE com agregação

Verificar domínio de:

- `COUNT`.
- `SUM`.
- `AVG`.
- `MIN`.
- `MAX`.
- `GROUP BY`.
- `HAVING`.
- `FILTER`.

O aluno deverá compreender a granularidade do resultado produzido.

## VAL-12 — CTE com Window Functions

Verificar a capacidade de preparar resultados em uma CTE e utilizar funções de janela em outra etapa.

Avaliar:

- `ROW_NUMBER`.
- `RANK`.
- `DENSE_RANK`.
- `PARTITION BY`.
- `ORDER BY`.

Não será exigido domínio completo de Window Functions neste módulo, pois esse conteúdo será aprofundado no Módulo 09.

---

# 7. Validação de recursividade

## VAL-13 — Estrutura recursiva

Verificar se o aluno compreende a estrutura:

- `WITH RECURSIVE`.
- Consulta âncora.
- Parte recursiva.
- Referência à própria CTE.
- Condição de parada.

O aluno deverá explicar a função de cada parte.

## VAL-14 — Sequência numérica

Solicitar a geração de uma sequência numérica limitada.

Testar:

- Valor inicial.
- Incremento.
- Limite.
- Quantidade de resultados.
- Encerramento.

A validação deverá detectar valores faltantes, excedentes e duplicados.

## VAL-15 — Hierarquia

Apresentar uma estrutura hierárquica com pelo menos quatro níveis.

Verificar se o aluno consegue:

- Identificar a raiz.
- Percorrer os níveis.
- Retornar os descendentes.
- Calcular profundidade.
- Construir caminhos.

**Critério de aprovação:** todos os elementos esperados deverão aparecer corretamente.

## VAL-16 — Condição de parada

Apresentar uma consulta recursiva com condição inadequada.

Solicitar que o aluno identifique o problema e proponha uma correção.

Avaliar:

- Identificação da condição incorreta.
- Compreensão do encerramento.
- Correção da consulta.
- Prevenção de expansão descontrolada.

## VAL-17 — Prevenção de ciclos

Apresentar uma estrutura com referências circulares.

Exemplo:

```text
A → B
B → C
C → A
```

Verificar se o aluno consegue:

- Identificar o ciclo.
- Explicar o risco.
- Controlar os elementos visitados.
- Impedir expansão indefinida.
- Apresentar um resultado controlado.

**Critério crítico:** uma solução que possa entrar em recursão infinita sem controle não será aprovada.

## VAL-18 — Cláusula CYCLE

Verificar se o aluno consegue utilizar `CYCLE`.

Critérios:

- Identificação correta das colunas de controle.
- Declaração da coluna de marcação.
- Declaração do caminho.
- Interpretação dos registros sinalizados.
- Compreensão da interrupção da expansão de caminhos cíclicos.

## VAL-19 — Cláusula SEARCH

Verificar utilização de:

- `SEARCH DEPTH FIRST`.
- `SEARCH BREADTH FIRST`.

O aluno deverá compreender a diferença entre os percursos e utilizar a coluna de ordenação gerada para apresentar o resultado.

**Critério de aprovação:** não confundir a coluna de ordenação com uma garantia de ordem física de execução.

---

# 8. Validação de materialização

## VAL-20 — Comportamento padrão

Apresentar uma CTE não recursiva elegível para incorporação.

Verificar se o aluno compreende o comportamento padrão do PostgreSQL 16.

Avaliar:

- Quantidade de referências.
- Possibilidade de incorporação.
- Presença de materialização.
- Diferenças entre CTEs elegíveis e não elegíveis.

## VAL-21 — MATERIALIZED

Verificar se o aluno consegue:

- Aplicar `MATERIALIZED`.
- Interpretar o plano.
- Identificar o comportamento de materialização.
- Explicar vantagens e desvantagens.

## VAL-22 — NOT MATERIALIZED

Verificar se o aluno compreende:

- Incorporação da CTE.
- Possibilidade de empurramento de filtros.
- Repetição de trabalho.
- Limitações de aplicação.
- Diferenças de planejamento.

## VAL-23 — CTE reutilizada

Apresentar uma CTE referenciada múltiplas vezes.

Verificar se o aluno consegue comparar:

- Estratégia padrão.
- Materialização.
- Incorporação, quando permitida.

O aluno deverá explicar quando a reutilização favorece a materialização e quando a incorporação pode ser mais vantajosa.

---

# 9. Validação de desempenho

## VAL-24 — EXPLAIN

Verificar se o aluno consegue utilizar `EXPLAIN` e interpretar:

- Cost.
- Estimated Rows.
- Node Type.
- Estrutura do plano.

## VAL-25 — EXPLAIN ANALYZE

Verificar se o aluno consegue utilizar `EXPLAIN ANALYZE` e interpretar:

- Planning Time.
- Execution Time.
- Actual Rows.
- Loops.
- Diferença entre estimativas e valores reais.

## VAL-26 — Buffers

Verificar compreensão de:

- Shared Hit Blocks.
- Shared Read Blocks.
- Leitura e utilização de blocos.
- Relação entre buffers e desempenho.

## VAL-27 — CTE Scan

Apresentar um plano que contenha `CTE Scan`.

O aluno deverá explicar:

- O significado do nó.
- Sua relação com o resultado da CTE.
- Se sua presença representa necessariamente um problema.

## VAL-28 — Comparação de alternativas

Solicitar a comparação entre:

- CTE.
- Subconsulta.
- JOIN direto.
- CTE materializada.
- CTE não materializada.

Critérios:

- Resultados equivalentes.
- Mesma granularidade.
- Comparação de planos.
- Justificativa técnica.

Não será aceita a afirmação de que uma alternativa é sempre mais rápida sem evidências.

---

# 10. Testes independentes

Os testes abaixo deverão ser utilizados para verificar o comportamento do PostgreSQL sem depender dos dados da TechStore.

## T-01 — CTE básica

```sql
WITH numeros AS (
    SELECT 1 AS numero
)
SELECT *
FROM numeros;
```

Resultado esperado: uma linha com o valor 1.

## T-02 — Múltiplas CTEs

```sql
WITH primeira AS (
    SELECT 10 AS valor
),
segunda AS (
    SELECT valor * 2 AS resultado
    FROM primeira
)
SELECT *
FROM segunda;
```

Resultado esperado: uma linha com o valor 20.

## T-03 — CTE com agregação

```sql
WITH valores AS (
    SELECT *
    FROM (
        VALUES
            (10),
            (20),
            (30),
            (40)
    ) AS dados(valor)
)
SELECT
    COUNT(*) AS quantidade,
    SUM(valor) AS total,
    AVG(valor) AS media,
    MIN(valor) AS minimo,
    MAX(valor) AS maximo
FROM valores;
```

Resultados esperados:

| Indicador | Resultado |
|---|---:|
| Quantidade | 4 |
| Total | 100 |
| Média | 25 |
| Mínimo | 10 |
| Máximo | 40 |

## T-04 — CTE vazia

```sql
WITH dados AS (
    SELECT 1 AS valor
    WHERE FALSE
)
SELECT COUNT(*)
FROM dados;
```

Resultado esperado: zero.

## T-05 — CTE com NULL

```sql
WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1),
            (2),
            (NULL::INTEGER),
            (3)
    ) AS origem(valor)
)
SELECT
    COUNT(*) AS total_linhas,
    COUNT(valor) AS valores_nao_nulos
FROM dados;
```

Resultados esperados:

| Indicador | Resultado |
|---|---:|
| Total de linhas | 4 |
| Valores não nulos | 3 |

## T-06 — CTE encadeada com filtros

```sql
WITH valores AS (
    SELECT *
    FROM (
        VALUES
            (5),
            (10),
            (15),
            (20),
            (25)
    ) AS dados(valor)
),
filtrados AS (
    SELECT valor
    FROM valores
    WHERE valor >= 15
),
resultado AS (
    SELECT SUM(valor) AS total
    FROM filtrados
)
SELECT *
FROM resultado;
```

Resultado esperado: total igual a 60.

## T-07 — CTE com duplicidades

```sql
WITH dados AS (
    SELECT *
    FROM (
        VALUES
            (1),
            (1),
            (2),
            (2),
            (2),
            (3)
    ) AS origem(valor)
)
SELECT
    COUNT(*) AS total,
    COUNT(DISTINCT valor) AS distintos
FROM dados;
```

Resultados esperados:

| Indicador | Resultado |
|---|---:|
| Total | 6 |
| Distintos | 3 |

## T-08 — CTE com UNION ALL

```sql
WITH dados AS (
    SELECT 1 AS valor
    UNION ALL
    SELECT 1
    UNION ALL
    SELECT 2
)
SELECT
    valor,
    COUNT(*) AS ocorrencias
FROM dados
GROUP BY valor
ORDER BY valor;
```

Resultados esperados:

| Valor | Ocorrências |
|---|---:|
| 1 | 2 |
| 2 | 1 |

## T-09 — Recursividade básica

```sql
WITH RECURSIVE numeros AS (
    SELECT 1 AS numero

    UNION ALL

    SELECT numero + 1
    FROM numeros
    WHERE numero < 5
)
SELECT *
FROM numeros
ORDER BY numero;
```

Resultado esperado: sequência de 1 até 5, com cinco linhas.

## T-10 — Recursividade decrescente

```sql
WITH RECURSIVE numeros AS (
    SELECT 5 AS numero

    UNION ALL

    SELECT numero - 1
    FROM numeros
    WHERE numero > 1
)
SELECT *
FROM numeros
ORDER BY numero DESC;
```

Resultado esperado: sequência de 5 até 1.

## T-11 — Hierarquia

```sql
WITH RECURSIVE estrutura AS (
    SELECT *
    FROM (
        VALUES
            (1, 'Raiz', NULL::INTEGER),
            (2, 'Filho A', 1),
            (3, 'Filho B', 1),
            (4, 'Neto A1', 2),
            (5, 'Neto B1', 3)
    ) AS dados(id, nome, pai_id)
),
hierarquia AS (
    SELECT
        id,
        nome,
        pai_id,
        0 AS nivel
    FROM estrutura
    WHERE pai_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.nome,
        e.pai_id,
        h.nivel + 1
    FROM estrutura AS e
    INNER JOIN hierarquia AS h
        ON e.pai_id = h.id
)
SELECT *
FROM hierarquia
ORDER BY nivel, id;
```

Resultados esperados:

| ID | Nome | Nível |
|---:|---|---:|
| 1 | Raiz | 0 |
| 2 | Filho A | 1 |
| 3 | Filho B | 1 |
| 4 | Neto A1 | 2 |
| 5 | Neto B1 | 2 |

## T-12 — Prevenção de ciclos com caminho

```sql
WITH RECURSIVE estrutura AS (
    SELECT *
    FROM (
        VALUES
            (1, 2),
            (2, 3),
            (3, 1)
    ) AS dados(id, proximo_id)
),
caminhos AS (
    SELECT
        id,
        proximo_id,
        ARRAY[id] AS caminho
    FROM estrutura
    WHERE id = 1

    UNION ALL

    SELECT
        e.id,
        e.proximo_id,
        c.caminho || e.id
    FROM estrutura AS e
    INNER JOIN caminhos AS c
        ON e.id = c.proximo_id
    WHERE NOT e.id = ANY(c.caminho)
)
SELECT *
FROM caminhos;
```

Resultado esperado:

- A consulta termina.
- Os identificadores não se repetem no mesmo caminho.
- O ciclo não provoca expansão infinita.

## T-13 — CYCLE

Criar uma consulta recursiva sobre uma estrutura cíclica e utilizar `CYCLE`.

Critérios de aprovação:

- O ciclo é identificado.
- A coluna de marcação indica a ocorrência.
- O caminho é produzido.
- A expansão do caminho cíclico é interrompida.

O resultado deverá ser interpretado conforme a estrutura utilizada.

## T-14 — SEARCH

Criar uma estrutura hierárquica e utilizar:

- `SEARCH DEPTH FIRST`.
- `SEARCH BREADTH FIRST`.

Critérios:

- A consulta executa.
- A coluna de ordenação é gerada.
- Os resultados podem ser apresentados na ordem solicitada.
- A diferença entre os percursos é explicada.

## T-15 — Materialização

Construir versões equivalentes utilizando:

- CTE padrão.
- `MATERIALIZED`.
- `NOT MATERIALIZED`, quando aplicável.

Executar `EXPLAIN` e analisar os planos.

Critério: identificar diferenças reais sem presumir que uma estratégia sempre será melhor.

---

# 11. Validação específica da TechStore

A validação prática deverá utilizar os dados existentes.

Os testes deverão verificar:

1. Quantidade de pedidos por cliente.
2. Unidades vendidas por produto.
3. Faturamento bruto por categoria.
4. Produtos sem vendas.
5. Avaliações por produto.
6. Movimentações por funcionário.
7. Entregas por transportadora.
8. Acessos por cliente.
9. Indicadores comerciais consolidados.
10. Relatórios com múltiplas CTEs.

Para cada resultado, deverá ser possível demonstrar:

- Quantidade de linhas.
- Ausência de duplicidades indevidas.
- Valores agregados coerentes.
- Tratamento de `NULL`.
- Granularidade correta.
- Equivalência com uma estratégia independente quando aplicável.

Os resultados devem ser calculados sobre o estado atual do banco. Não serão utilizados números fixos como gabarito quando dependerem dos registros existentes.

---

# 12. Avaliação prática

A avaliação deverá conter tarefas inéditas, diferentes das atividades já resolvidas.

## Desafio A — Consulta analítica

Construir um relatório utilizando pelo menos três CTEs.

O avaliador deverá verificar:

- Organização.
- Dependências.
- Agregações.
- JOINs.
- Correção do resultado.

## Desafio B — Recursividade

Receber uma estrutura hierárquica desconhecida e percorrê-la.

O avaliador deverá verificar:

- Consulta âncora.
- Parte recursiva.
- Níveis.
- Caminhos.
- Condição de parada.

## Desafio C — Ciclos

Receber uma estrutura com possibilidade de ciclo.

O aluno deverá apresentar uma solução que encerre corretamente a recursão.

## Desafio D — Materialização

Receber uma consulta com CTE referenciada múltiplas vezes.

O aluno deverá comparar estratégias de materialização e justificar a decisão.

## Desafio E — Otimização

Receber uma consulta funcional, mas com plano de execução menos eficiente que uma alternativa equivalente.

O aluno deverá:

1. Identificar o gargalo.
2. Formular uma hipótese.
3. Implementar uma alteração.
4. Verificar a equivalência.
5. Comparar as métricas.
6. Explicar o resultado.

---

# 13. Critérios de erros críticos

Os seguintes problemas impedem aprovação até serem corrigidos:

- Consulta que retorna resultados logicamente incorretos.
- Multiplicação indevida de valores agregados.
- Recursão sem controle adequado de encerramento.
- Ciclos capazes de gerar expansão indefinida.
- Uso incorreto de materialização que altera o resultado esperado.
- Comparação de desempenho entre consultas não equivalentes.
- Alteração indevida da TechStore principal.
- Execução de operações destrutivas sem autorização.

---

# 14. Reforço direcionado

Caso o aluno não alcance os critérios esperados, o reforço será direcionado à dificuldade identificada.

| Dificuldade | Conteúdo de reforço |
|---|---|
| Sintaxe WITH | Teoria 2 |
| Colunas e aliases | Teoria 2 |
| Agregações | Teorias 4 e 5 |
| Encadeamento | Teoria 5 |
| JOINs e granularidade | Teoria 6 |
| Operações de conjuntos | Teoria 7 |
| Subconsultas | Teoria 9 |
| Recursividade | Teorias 11 a 18 |
| Ciclos | Teoria 17 |
| SEARCH e CYCLE | Teorias 17 e 18 |
| Materialização | Teoria 19 |
| CTE versus subconsulta | Teoria 9 |
| Desempenho | Teoria 22 |

O aluno deverá refazer apenas os testes relacionados às lacunas identificadas.

---

# 15. Registro de avaliação

| Validação | Resultado |
|---|---|
| VAL-01 — Declaração | Pendente |
| VAL-02 — Colunas | Pendente |
| VAL-03 — Filtros | Pendente |
| VAL-04 — Escopo | Pendente |
| VAL-05 — Encadeamento | Pendente |
| VAL-06 — Independência | Pendente |
| VAL-07 — JOIN | Pendente |
| VAL-08 — Conjuntos | Pendente |
| VAL-09 — Granularidade | Pendente |
| VAL-10 — Subconsultas | Pendente |
| VAL-11 — Agregações | Pendente |
| VAL-12 — Window Functions | Pendente |
| VAL-13 — Estrutura recursiva | Pendente |
| VAL-14 — Sequência | Pendente |
| VAL-15 — Hierarquia | Pendente |
| VAL-16 — Condição de parada | Pendente |
| VAL-17 — Ciclos | Pendente |
| VAL-18 — CYCLE | Pendente |
| VAL-19 — SEARCH | Pendente |
| VAL-20 — Comportamento padrão | Pendente |
| VAL-21 — MATERIALIZED | Pendente |
| VAL-22 — NOT MATERIALIZED | Pendente |
| VAL-23 — Reutilização | Pendente |
| VAL-24 — EXPLAIN | Pendente |
| VAL-25 — EXPLAIN ANALYZE | Pendente |
| VAL-26 — Buffers | Pendente |
| VAL-27 — CTE Scan | Pendente |
| VAL-28 — Comparação | Pendente |

### Resultado final

- Nota: —
- Erros críticos: —
- Conteúdos dominados: —
- Conteúdos para reforço: —
- Desafios concluídos: —
- Situação: Pendente.

---

# 16. Critérios de liberação do próximo módulo

O Módulo 09 somente será liberado quando o aluno:

1. Demonstrar domínio de CTEs comuns.
2. Construir consultas com múltiplas CTEs.
3. Preservar a granularidade dos resultados.
4. Demonstrar domínio de recursividade.
5. Controlar ciclos e condições de parada.
6. Compreender materialização.
7. Interpretar planos de execução.
8. Concluir os desafios práticos.
9. Atingir pelo menos 85%.
10. Não apresentar erros críticos pendentes.

**Próximo módulo:** Módulo 09 — Window Functions.

**Status:** validação preparada. Aulas ainda não iniciadas.