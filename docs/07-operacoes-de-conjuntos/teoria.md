# Teoria — Módulo 07: Operações de Conjuntos

## 1. Introdução às operações de conjuntos

Até agora, utilizamos principalmente duas estratégias para combinar informações:

- JOINs: relacionam registros de tabelas diferentes por meio de condições.
- Subconsultas: utilizam resultados de outras consultas como parte de uma consulta principal.

As operações de conjuntos oferecem outra maneira de trabalhar com resultados.

Em vez de relacionar colunas de tabelas diferentes, podemos combinar os resultados completos de duas ou mais consultas.

No PostgreSQL, os principais operadores são:

| Operador | Finalidade |
|---|---|
| UNION | Combina resultados e elimina duplicidades |
| UNION ALL | Combina resultados preservando duplicidades |
| INTERSECT | Retorna registros comuns aos dois resultados |
| INTERSECT ALL | Retorna registros comuns considerando multiplicidades |
| EXCEPT | Retorna registros do primeiro resultado que não aparecem no segundo |
| EXCEPT ALL | Calcula a diferença considerando multiplicidades |

Esses operadores são chamados de operações de conjuntos, embora algumas variantes com `ALL` preservem multiplicidades e, portanto, tenham comportamento de operações sobre multiconjuntos (*bags*).

### 1.1. Exemplo conceitual

Imagine dois resultados:

**Consulta A**

| Cliente |
|---|
| Ana |
| Bruno |
| Carlos |

**Consulta B**

| Cliente |
|---|
| Bruno |
| Carlos |
| Daniela |

Podemos combinar esses resultados de diferentes maneiras.

- UNION: Ana, Bruno, Carlos e Daniela.
- INTERSECT: Bruno e Carlos.
- EXCEPT: Ana.

A operação escolhida determina como os resultados serão tratados.

---

## 2. Regras de compatibilidade

Antes de utilizar uma operação de conjuntos, é necessário garantir que as consultas sejam compatíveis.

O PostgreSQL exige que os resultados tenham:

1. A mesma quantidade de colunas.
2. Tipos de dados compatíveis nas posições correspondentes.

### 2.1. Quantidade de colunas

Considere:

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION

SELECT
    id,
    nome
FROM techstore.funcionarios;
```

As duas consultas retornam duas colunas.

Agora considere:

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION

SELECT
    id
FROM techstore.funcionarios;
```

Essa construção é inválida porque as consultas possuem quantidades diferentes de colunas.

### 2.2. Compatibilidade dos tipos

As colunas correspondentes precisam possuir tipos que possam ser reconciliados pelo PostgreSQL.

Exemplo conceitual:

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome
FROM techstore.funcionarios;
```

As duas consultas apresentam identificadores e nomes em posições correspondentes.

O PostgreSQL precisa determinar um tipo de saída compatível para cada posição.

### 2.3. A correspondência é por posição

Um erro comum é acreditar que o PostgreSQL relaciona colunas pelos nomes.

Isso não acontece.

Considere:

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION ALL

SELECT
    nome,
    id
FROM techstore.funcionarios;
```

As posições foram invertidas.

O PostgreSQL tentará compatibilizar:

- Primeira coluna com primeira coluna.
- Segunda coluna com segunda coluna.

Os nomes não corrigem essa incompatibilidade semântica.

**Boa prática:** mantenha a mesma ordem e o mesmo significado das colunas em todas as consultas.

### 2.4. Aliases e nomes finais

Os nomes das colunas do resultado combinado normalmente são determinados pela primeira consulta.

Exemplo:

```sql
SELECT
    id AS identificador,
    nome AS pessoa
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome
FROM techstore.funcionarios;
```

O resultado terá os nomes:

- identificador
- pessoa

Os aliases da segunda consulta não substituem os nomes definidos pela primeira.

---

## 3. UNION

O operador `UNION` combina os resultados de duas ou mais consultas e elimina linhas duplicadas.

### 3.1. Sintaxe

```sql
SELECT coluna_a, coluna_b
FROM tabela_a

UNION

SELECT coluna_a, coluna_b
FROM tabela_b;
```

### 3.2. Exemplo

Imagine que queremos reunir clientes e funcionários em uma única lista.

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION

SELECT
    id,
    nome
FROM techstore.funcionarios;
```

O resultado reúne as linhas das duas consultas.

Se duas linhas forem consideradas duplicadas, apenas uma será mantida.

### 3.3. Como o UNION identifica duplicidades?

A comparação considera todas as colunas retornadas.

Considere:

| ID | Nome |
|---:|---|
| 1 | Ana |
| 2 | Bruno |
| 1 | Ana |

As duas ocorrências de `(1, Ana)` são duplicadas.

Entretanto:

| ID | Nome |
|---:|---|
| 1 | Ana |
| 1 | Carlos |

Essas linhas são diferentes porque o conteúdo completo não é igual.

### 3.4. UNION e NULL

Nas operações de conjuntos, valores `NULL` em posições correspondentes são tratados como iguais para a finalidade de identificar linhas duplicadas.

Isso é diferente da comparação tradicional:

```sql
NULL = NULL
```

Que não resulta em verdadeiro, mas em desconhecido (`UNKNOWN`).

Essa diferença é importante para compreender a eliminação de duplicidades.

### 3.5. Custo do UNION

Para eliminar duplicidades, o PostgreSQL pode utilizar estratégias como:

- Ordenação seguida de eliminação de duplicidades.
- Hashing para identificar linhas repetidas.

Essas operações podem consumir CPU e memória.

O custo depende do volume, dos tipos de dados e do plano escolhido pelo PostgreSQL.

**Regra prática:** utilize UNION quando a eliminação de duplicidades fizer parte do resultado desejado.

---

## 4. UNION ALL

O operador `UNION ALL` combina os resultados sem eliminar duplicidades.

### 4.1. Sintaxe

```sql
SELECT coluna_a, coluna_b
FROM tabela_a

UNION ALL

SELECT coluna_a, coluna_b
FROM tabela_b;
```

### 4.2. Exemplo

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome
FROM techstore.funcionarios;
```

Todas as linhas retornadas pelas duas consultas serão preservadas.

### 4.3. Diferença entre UNION e UNION ALL

| Característica | UNION | UNION ALL |
|---|---|---|
| Combina resultados | Sim | Sim |
| Elimina duplicidades | Sim | Não |
| Preserva repetições | Não | Sim |
| Pode exigir comparação de linhas | Sim | Não para deduplicação |
| Custo de execução | Pode ser maior | Geralmente menor |

### 4.4. Quando utilizar UNION ALL?

Imagine um relatório que reúne registros de duas fontes independentes.

Se cada ocorrência representa um evento real, eliminar duplicidades pode destruir informação.

Nesse cenário, `UNION ALL` é mais adequado.

Outro caso comum é a consolidação de resultados de diferentes períodos.

Se cada registro representa uma ocorrência distinta, não devemos remover repetições automaticamente.

**Importante:** UNION ALL não é sempre melhor. Ele é correto quando preservar todas as ocorrências corresponde à regra de negócio.

---

## 5. INTERSECT

O operador `INTERSECT` retorna somente as linhas que aparecem nos dois resultados.

### 5.1. Sintaxe

```sql
SELECT coluna_a, coluna_b
FROM tabela_a

INTERSECT

SELECT coluna_a, coluna_b
FROM tabela_b;
```

### 5.2. Exemplo conceitual

Considere:

**Conjunto A**

| Cliente |
|---|
| Ana |
| Bruno |
| Carlos |

**Conjunto B**

| Cliente |
|---|
| Bruno |
| Carlos |
| Daniela |

Resultado:

| Cliente |
|---|
| Bruno |
| Carlos |

Somente as linhas presentes nos dois conjuntos são retornadas.

### 5.3. Exemplo na TechStore

Podemos identificar clientes que possuem pedidos e também aparecem nos registros de acessos.

```sql
SELECT
    cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

INTERSECT

SELECT
    cliente_id
FROM techstore.acessos
WHERE cliente_id IS NOT NULL;
```

O resultado apresenta os identificadores presentes nos dois resultados.

### 5.4. INTERSECT elimina duplicidades

O operador `INTERSECT` elimina duplicidades no resultado final.

Mesmo que um cliente tenha muitos pedidos e muitos acessos, seu identificador aparece uma única vez.

### 5.5. INTERSECT e JOIN

Essas construções podem resolver problemas semelhantes, mas não são equivalentes em todos os cenários.

Um JOIN relaciona registros e pode produzir várias linhas para uma mesma entidade.

INTERSECT trabalha com linhas completas e retorna valores comuns aos resultados.

A escolha depende da granularidade e do resultado desejado.

---

## 6. INTERSECT ALL

O PostgreSQL também permite utilizar:

```sql
INTERSECT ALL
```

Diferentemente do INTERSECT tradicional, essa variante considera a quantidade de ocorrências de cada linha.

### 6.1. Exemplo conceitual

**Conjunto A**

| Valor |
|---|
| A |
| A |
| A |
| B |

**Conjunto B**

| Valor |
|---|
| A |
| A |
| C |

Resultado de `INTERSECT`:

| Valor |
|---|
| A |

Resultado de `INTERSECT ALL`:

| Valor |
|---|
| A |
| A |

A quantidade de ocorrências no resultado corresponde à menor quantidade encontrada nos dois conjuntos.

### 6.2. Regra de multiplicidade

Se uma linha aparece:

- 3 vezes no primeiro conjunto.
- 2 vezes no segundo conjunto.

O `INTERSECT ALL` retorna 2 ocorrências.

Essa diferença é relevante em relatórios que precisam preservar frequências.

---

## 7. EXCEPT

O operador `EXCEPT` retorna as linhas presentes no primeiro resultado que não aparecem no segundo.

### 7.1. Sintaxe

```sql
SELECT coluna_a, coluna_b
FROM tabela_a

EXCEPT

SELECT coluna_a, coluna_b
FROM tabela_b;
```

### 7.2. Exemplo conceitual

**Conjunto A**

| Cliente |
|---|
| Ana |
| Bruno |
| Carlos |

**Conjunto B**

| Cliente |
|---|
| Bruno |
| Daniela |

Resultado:

| Cliente |
|---|
| Ana |
| Carlos |

O EXCEPT mantém apenas as linhas exclusivas do primeiro resultado.

### 7.3. Exemplo na TechStore

Podemos identificar clientes cadastrados que não possuem pedidos.

```sql
SELECT
    id
FROM techstore.clientes

EXCEPT

SELECT
    cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

A consulta apresenta os identificadores de clientes que aparecem no primeiro conjunto, mas não no segundo.

### 7.4. A ordem importa

EXCEPT não é comutativo.

Considere:

```sql
SELECT id
FROM techstore.clientes

EXCEPT

SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

O resultado representa clientes sem pedidos.

Invertendo a ordem, a interpretação muda:

```sql
SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL

EXCEPT

SELECT id
FROM techstore.clientes;
```

Agora estamos procurando identificadores presentes nos pedidos e ausentes no conjunto de clientes.

A ordem dos resultados é fundamental.

### 7.5. EXCEPT elimina duplicidades

Assim como UNION e INTERSECT, EXCEPT tradicional elimina duplicidades.

O resultado contém linhas distintas.

---

## 8. EXCEPT ALL

`EXCEPT ALL` realiza uma diferença considerando multiplicidades.

### 8.1. Exemplo conceitual

**Conjunto A**

| Valor |
|---|
| A |
| A |
| A |
| B |
| B |

**Conjunto B**

| Valor |
|---|
| A |
| B |

Resultado:

| Valor |
|---|
| A |
| A |
| B |

A quantidade de ocorrências é calculada subtraindo as ocorrências do segundo conjunto das ocorrências do primeiro, sem permitir resultado negativo.

### 8.2. Regra de multiplicidade

Se uma linha aparece:

- 4 vezes no primeiro conjunto.
- 2 vezes no segundo conjunto.

O `EXCEPT ALL` retorna 2 ocorrências.

Se a linha aparece menos vezes no primeiro conjunto do que no segundo, ela não aparece no resultado.

---

## 9. Comparação dos operadores

| Operador | Resultado | Duplicidades |
|---|---|---|
| UNION | Todas as linhas distintas dos conjuntos | Elimina |
| UNION ALL | Todas as ocorrências dos conjuntos | Preserva |
| INTERSECT | Linhas comuns | Elimina |
| INTERSECT ALL | Linhas comuns considerando multiplicidade | Preserva multiplicidade mínima |
| EXCEPT | Linhas exclusivas do primeiro conjunto | Elimina |
| EXCEPT ALL | Diferença entre ocorrências dos conjuntos | Subtrai multiplicidades |

### 9.1. Regra importante

As operações tradicionais trabalham com linhas distintas.

As variantes `ALL` consideram as ocorrências das linhas.

Não confunda a existência de um registro com a quantidade de vezes que ele aparece.

---

## 10. Operações encadeadas

Podemos combinar mais de duas consultas utilizando operações de conjuntos.

Exemplo:

```sql
SELECT id
FROM techstore.clientes

UNION

SELECT id
FROM techstore.funcionarios

UNION

SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

O resultado reúne os identificadores retornados pelas três consultas.

### 10.1. Ordem de avaliação

No PostgreSQL, `INTERSECT` possui precedência maior que `UNION` e `EXCEPT`.

`UNION` e `EXCEPT` possuem a mesma precedência e são avaliados da esquerda para a direita.

Parênteses permitem deixar a intenção explícita.

Exemplo:

```sql
(
    SELECT id
    FROM techstore.clientes

    UNION

    SELECT id
    FROM techstore.funcionarios
)

EXCEPT

SELECT cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

Nesse exemplo:

1. Os identificadores de clientes e funcionários são reunidos.
2. O resultado combinado é comparado com os identificadores de clientes presentes nos pedidos.
3. Permanecem as linhas que não aparecem no segundo resultado.

### 10.2. Por que utilizar parênteses?

Em consultas complexas, parênteses tornam a intenção explícita e ajudam a evitar interpretações equivocadas.

Não dependa apenas da memória sobre precedência.

---

## 11. ORDER BY e LIMIT

A ordenação de uma operação de conjuntos deve ser aplicada ao resultado combinado.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome
FROM techstore.funcionarios

ORDER BY nome;
```

O ORDER BY final organiza o resultado completo.

### 11.1. Ordenação por posição

Também podemos ordenar pela posição da coluna:

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome
FROM techstore.funcionarios

ORDER BY 2;
```

Nesse caso, a segunda coluna é utilizada para ordenação.

### 11.2. LIMIT

O LIMIT final restringe o resultado combinado.

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome
FROM techstore.funcionarios

ORDER BY nome
LIMIT 20;
```

O limite é aplicado ao conjunto final, e não separadamente a cada consulta.

Quando a intenção for limitar cada parte, será necessário estruturar as consultas adequadamente, normalmente utilizando parênteses ou subconsultas.

---

## 12. NULL nas operações de conjuntos

O tratamento de `NULL` é uma das particularidades mais importantes deste módulo.

Nas comparações tradicionais:

```sql
NULL = NULL
```

O resultado é desconhecido.

Entretanto, nas operações de conjuntos, o PostgreSQL considera dois valores `NULL` correspondentes como iguais para determinar duplicidades e correspondências entre linhas.

### 12.1. UNION

Se duas consultas retornarem uma linha com `NULL` nas mesmas posições, o UNION poderá eliminar uma delas como duplicada.

### 12.2. INTERSECT

Linhas com `NULL` nas mesmas posições podem ser consideradas correspondentes e aparecer no resultado.

### 12.3. EXCEPT

Linhas com `NULL` também participam da comparação de linhas realizada pela operação.

### 12.4. Exemplo conceitual

Considere:

```sql
SELECT NULL::INTEGER AS codigo

UNION

SELECT NULL::INTEGER AS codigo;
```

O resultado terá uma única linha.

Agora:

```sql
SELECT NULL::INTEGER AS codigo

INTERSECT

SELECT NULL::INTEGER AS codigo;
```

O resultado também terá uma linha.

E:

```sql
SELECT NULL::INTEGER AS codigo

EXCEPT

SELECT NULL::INTEGER AS codigo;
```

O resultado será vazio.

**Atenção:** isso não significa que `NULL` passou a ser igual a qualquer valor nas expressões SQL. Trata-se da regra de comparação utilizada pelas operações de conjuntos.

---

## 13. Operações com filtros

Cada consulta pode possuir seus próprios filtros.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.produtos
WHERE ativo = TRUE

UNION

SELECT
    id,
    nome
FROM techstore.produtos
WHERE preco > 1000;
```

O resultado combina:

- Produtos ativos.
- Produtos com preço superior a 1000.

Como foi utilizado UNION, linhas duplicadas entre os dois resultados serão eliminadas.

### 13.1. Importância da interpretação

Um produto que seja ativo e tenha preço superior a 1000 aparecerá uma única vez.

Se a intenção fosse contar ou preservar as ocorrências provenientes de cada consulta, a escolha do operador precisaria ser diferente.

---

## 14. Operações com agregações

Operações de conjuntos também podem combinar resultados agregados.

Exemplo:

```sql
SELECT
    categoria_id,
    COUNT(*) AS quantidade
FROM techstore.produtos
GROUP BY categoria_id

UNION ALL

SELECT
    categoria_id,
    COUNT(*) AS quantidade
FROM techstore.produtos
WHERE ativo = TRUE
GROUP BY categoria_id;
```

As duas consultas retornam:

- Uma identificação de categoria.
- Uma quantidade de produtos.

As colunas são compatíveis em quantidade e tipos.

Entretanto, a granularidade e o significado das linhas precisam ser interpretados corretamente.

A primeira consulta representa a quantidade total por categoria.

A segunda representa a quantidade de produtos ativos por categoria.

Não são métricas equivalentes, mesmo que possuam a mesma estrutura.

**Boa prática:** quando combinar resultados agregados, deixe explícito o significado de cada linha.

Uma coluna adicional de identificação da origem pode ajudar:

```sql
SELECT
    'total' AS tipo,
    categoria_id,
    COUNT(*) AS quantidade
FROM techstore.produtos
GROUP BY categoria_id

UNION ALL

SELECT
    'ativos' AS tipo,
    categoria_id,
    COUNT(*) AS quantidade
FROM techstore.produtos
WHERE ativo = TRUE
GROUP BY categoria_id;
```

---

## 15. Operações de conjuntos com CTEs

As operações de conjuntos podem ser utilizadas dentro de CTEs.

Exemplo:

```sql
WITH pessoas AS (
    SELECT
        id,
        nome
    FROM techstore.clientes

    UNION ALL

    SELECT
        id,
        nome
    FROM techstore.funcionarios
)
SELECT
    id,
    nome
FROM pessoas
ORDER BY nome;
```

A CTE organiza o resultado combinado e permite utilizá-lo na consulta principal.

### 15.1. Vantagens

- Melhor organização.
- Separação de responsabilidades.
- Reutilização do resultado dentro da instrução.
- Maior legibilidade em consultas complexas.

### 15.2. Desempenho

Uma CTE não é automaticamente mais rápida que uma subconsulta ou operação direta.

No PostgreSQL moderno, CTEs não recursivas podem ser incorporadas à consulta principal (*folding*) em determinadas condições.

Também é possível controlar a materialização com:

- `MATERIALIZED`.
- `NOT MATERIALIZED`.

Esses recursos serão aprofundados no módulo de CTEs.

---

## 16. Operações de conjuntos versus JOINs

É fundamental compreender que JOIN e operações de conjuntos possuem finalidades diferentes.

### 16.1. JOIN

JOIN relaciona colunas de registros.

Exemplo:

```sql
SELECT
    p.id,
    p.cliente_id,
    c.nome
FROM techstore.pedidos AS p
INNER JOIN techstore.clientes AS c
    ON c.id = p.cliente_id;
```

O resultado reúne informações de pedidos e clientes.

### 16.2. UNION

UNION combina linhas de consultas compatíveis.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.clientes

UNION ALL

SELECT
    id,
    nome
FROM techstore.funcionarios;
```

O resultado reúne linhas das duas fontes.

### 16.3. INTERSECT versus INNER JOIN

Ambos podem ser utilizados para identificar correspondências, mas:

- INTERSECT compara linhas completas dos resultados.
- INNER JOIN relaciona registros por uma condição.
- JOIN pode gerar múltiplas linhas para uma mesma entidade.
- INTERSECT tradicional elimina duplicidades.

### 16.4. EXCEPT versus NOT EXISTS

Ambos podem identificar registros ausentes em outro conjunto.

Entretanto:

- EXCEPT compara linhas completas.
- NOT EXISTS verifica a ausência de correspondência segundo uma condição.
- EXCEPT elimina duplicidades por padrão.
- NOT EXISTS preserva a granularidade da consulta externa.

A escolha deve considerar o resultado desejado.

---

## 17. Como o PostgreSQL executa operações de conjuntos

O PostgreSQL pode utilizar diferentes estratégias internas para executar essas operações.

Os nós encontrados nos planos podem incluir:

### 17.1. Append

Combina resultados provenientes de diferentes fontes.

É comum em planos associados a operações de união, especialmente quando não é necessário eliminar duplicidades.

### 17.2. Sort

Ordena os resultados.

Pode ser utilizado como etapa de preparação para identificar linhas repetidas ou executar operações de conjuntos.

### 17.3. Unique

Remove linhas duplicadas de um resultado ordenado.

Pode aparecer em planos associados a operações que precisam eliminar duplicidades.

### 17.4. HashSetOp

Executa operações de conjuntos utilizando estruturas de hashing.

Pode ser utilizado em operações como INTERSECT e EXCEPT.

### 17.5. SetOp

Representa uma operação de conjunto no plano de execução.

Pode aparecer em diferentes estratégias de execução, dependendo da operação e do plano escolhido.

### 17.6. Memória e desempenho

Operações de conjuntos podem exigir memória para:

- Ordenação.
- Estruturas de hashing.
- Comparação de linhas.
- Eliminação de duplicidades.

Quando a quantidade de dados é grande, algumas operações podem utilizar arquivos temporários em disco.

O desempenho depende de:

- Quantidade de linhas.
- Largura das linhas.
- Tipos de dados.
- Duplicidades.
- Memória disponível.
- Configuração de `work_mem`.
- Estratégia escolhida pelo planner.
- Estado do cache.

Não se deve assumir que uma operação específica utilizará sempre o mesmo nó de execução.

---

## 18. Análise de desempenho com EXPLAIN

O comando EXPLAIN permite observar o plano estimado.

Exemplo:

```sql
EXPLAIN
SELECT
    id
FROM techstore.clientes

UNION

SELECT
    cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

O objetivo é identificar:

- Nós utilizados.
- Estimativa de linhas.
- Custos.
- Operações de ordenação.
- Eliminação de duplicidades.

### 18.1. EXPLAIN ANALYZE

Para observar dados reais de execução:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id
FROM techstore.clientes

UNION ALL

SELECT
    cliente_id
FROM techstore.pedidos
WHERE cliente_id IS NOT NULL;
```

Esse comando executa a consulta.

Analise:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Nós de execução.
- Uso de memória e arquivos temporários, quando apresentados.

### 18.2. Comparação adequada

Para comparar UNION e UNION ALL:

1. Utilize consultas semanticamente equivalentes.
2. Confirme se a eliminação de duplicidades é necessária.
3. Execute as consultas em condições semelhantes.
4. Observe os planos.
5. Compare os resultados.
6. Compare os tempos e os recursos utilizados.

Uma consulta mais rápida não é melhor se produzir um resultado incorreto.

**Importante:** não compare resultados de operações com semânticas diferentes como se fossem equivalentes.

---

## 19. Erros frequentes

### Erro 1 — Quantidade diferente de colunas

O PostgreSQL não permite combinar resultados com quantidades diferentes de colunas.

### Erro 2 — Tipos incompatíveis

Colunas correspondentes precisam ter tipos compatíveis.

### Erro 3 — Ordem incorreta das colunas

As operações utilizam a posição das colunas, não o nome.

### Erro 4 — Utilizar UNION quando deveria preservar duplicidades

A eliminação de duplicidades pode remover ocorrências importantes.

### Erro 5 — Utilizar UNION ALL quando deveria eliminar duplicidades

O resultado pode conter registros repetidos indevidamente.

### Erro 6 — Confundir UNION com JOIN

UNION combina linhas. JOIN relaciona colunas de registros.

### Erro 7 — Inverter a ordem do EXCEPT

A ordem altera o significado da operação.

### Erro 8 — Não considerar a multiplicidade

INTERSECT ALL e EXCEPT ALL possuem comportamento diferente das versões tradicionais.

### Erro 9 — Ordenar cada parte sem necessidade

O ORDER BY final normalmente é suficiente para ordenar o resultado combinado.

### Erro 10 — Combinar métricas de granularidades diferentes

Duas consultas podem retornar colunas compatíveis, mas representar informações com significados diferentes.

Compatibilidade técnica não garante compatibilidade semântica.

---

## 20. Boas práticas

1. Defina a finalidade da operação antes de escolher o operador.
2. Confirme a quantidade de colunas.
3. Confirme os tipos de dados.
4. Mantenha as colunas na mesma ordem.
5. Utilize aliases claros.
6. Prefira UNION ALL quando a preservação de ocorrências for necessária.
7. Utilize UNION somente quando eliminar duplicidades fizer sentido.
8. Considere a multiplicidade ao utilizar as variantes ALL.
9. Utilize parênteses em operações encadeadas complexas.
10. Deixe explícita a origem dos dados quando combinar relatórios diferentes.
11. Verifique a granularidade das consultas.
12. Compare resultados antes de comparar desempenho.
13. Utilize EXPLAIN para entender o plano.
14. Evite otimizações que alterem a semântica.

---

## 21. Referência rápida

| Necessidade | Operador |
|---|---|
| Reunir resultados eliminando duplicidades | UNION |
| Reunir resultados preservando duplicidades | UNION ALL |
| Encontrar linhas comuns | INTERSECT |
| Encontrar linhas comuns preservando multiplicidade | INTERSECT ALL |
| Encontrar linhas exclusivas do primeiro resultado | EXCEPT |
| Calcular diferenças preservando multiplicidade | EXCEPT ALL |

### Regras essenciais

- As consultas precisam retornar a mesma quantidade de colunas.
- Os tipos correspondentes precisam ser compatíveis.
- A correspondência das colunas é posicional.
- O ORDER BY final ordena o resultado combinado.
- UNION, INTERSECT e EXCEPT eliminam duplicidades.
- As variantes ALL preservam ou calculam multiplicidades.
- EXCEPT depende da ordem dos conjuntos.
- NULL possui regras próprias nas operações de conjuntos.

---

## 22. Documentação oficial

Referências do PostgreSQL 16:

- UNION, INTERSECT e EXCEPT: https://www.postgresql.org/docs/16/queries-union.html
- SELECT: https://www.postgresql.org/docs/16/sql-select.html
- EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html
- Tipos de dados: https://www.postgresql.org/docs/16/datatype.html
- Expressões: https://www.postgresql.org/docs/16/sql-expressions.html

---

## 23. Resultados esperados

Ao concluir a teoria, o aluno deverá compreender:

- O funcionamento das operações de conjuntos.
- As diferenças entre os operadores.
- O tratamento de duplicidades.
- A compatibilidade entre consultas.
- O comportamento de NULL.
- A ordem de avaliação das operações.
- A utilização de operações encadeadas.
- A combinação com filtros, agregações e CTEs.
- As diferenças entre operações de conjuntos, JOINs e subconsultas.
- A interpretação dos planos de execução.

A compreensão desses conceitos será necessária para resolver as atividades e os desafios do módulo.

**Próxima etapa:** `atividades.md` — exercícios progressivos para aplicar os operadores de conjuntos na TechStore.