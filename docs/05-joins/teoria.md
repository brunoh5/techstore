# Teoria — Módulo 05: JOINs (Junções entre Tabelas)

# 1. Introdução aos JOINs

Até agora, trabalhamos principalmente com consultas sobre uma tabela por vez.

Entretanto, bancos de dados relacionais são construídos justamente para armazenar informações relacionadas em diferentes tabelas.

Em um sistema comercial, por exemplo:

- Os clientes possuem pedidos.
- Os pedidos possuem itens.
- Os itens fazem referência aos produtos.
- Os produtos pertencem a categorias.
- Os pedidos podem possuir pagamentos.
- As entregas estão associadas aos pedidos.

Essas informações ficam separadas para evitar redundância e facilitar a organização dos dados.

O problema é que, para responder a perguntas de negócio, frequentemente precisamos combinar essas informações.

É nesse contexto que utilizamos JOIN.

## 1.1 O que é JOIN?

JOIN é uma operação SQL utilizada para combinar registros de duas ou mais tabelas a partir de uma condição de relacionamento.

Exemplo conceitual:

```sql
SELECT
    clientes.nome,
    pedidos.id,
    pedidos.data_pedido
FROM techstore.clientes
INNER JOIN techstore.pedidos
    ON pedidos.cliente_id = clientes.id;
```

A consulta combina informações dos clientes com seus respectivos pedidos.

O resultado apresenta informações que estavam originalmente distribuídas em duas tabelas.

## 1.2 Por que utilizar JOIN?

Imagine que temos duas tabelas:

**clientes**

| id | nome |
|---:|---|
| 1 | Ana |
| 2 | Carlos |
| 3 | Maria |

**pedidos**

| id | cliente_id | valor |
|---:|---:|---:|
| 101 | 1 | 250 |
| 102 | 1 | 150 |
| 103 | 2 | 300 |

Se quisermos descobrir o nome do cliente responsável por cada pedido, precisamos relacionar as tabelas.

Resultado esperado:

| cliente | pedido | valor |
|---|---:|---:|
| Ana | 101 | 250 |
| Ana | 102 | 150 |
| Carlos | 103 | 300 |

Observe que Ana aparece duas vezes porque possui dois pedidos.

Isso não representa necessariamente uma duplicação incorreta. É uma consequência natural do relacionamento.

---

# 2. Fundamentos dos relacionamentos

Antes de estudar os tipos de JOIN, precisamos compreender como as tabelas se relacionam.

## 2.1 Chave primária (PRIMARY KEY)

Uma chave primária identifica exclusivamente cada registro de uma tabela.

Exemplo:

```sql
id BIGINT PRIMARY KEY
```

Características:

- Não pode possuir valores duplicados.
- Não aceita NULL.
- Identifica unicamente cada registro.
- Pode ser utilizada por outras tabelas para estabelecer relacionamentos.

Na TechStore, exemplos incluem:

- `clientes.id`
- `pedidos.id`
- `produtos.id`
- `funcionarios.id`

## 2.2 Chave estrangeira (FOREIGN KEY)

Uma chave estrangeira estabelece uma referência entre uma tabela e outra.

Exemplo conceitual:

```sql
cliente_id BIGINT REFERENCES clientes(id)
```

Isso significa que o valor de `cliente_id` referencia um registro da tabela `clientes`.

Na TechStore:

- `pedidos.cliente_id` referencia `clientes.id`.
- `itens_pedido.pedido_id` referencia `pedidos.id`.
- `itens_pedido.produto_id` referencia `produtos.id`.
- `estoque.produto_id` referencia `produtos.id`.

## 2.3 Relacionamento 1:1

Um registro de uma tabela está associado a, no máximo, um registro de outra tabela, e vice-versa.

Exemplo conceitual:

```text
Pessoa
  |
  | 1:1
  |
Documento
```

Esse tipo de relacionamento normalmente depende de uma restrição UNIQUE na chave estrangeira ou de uma chave compartilhada.

## 2.4 Relacionamento 1:N

Um registro da primeira tabela pode estar associado a vários registros da segunda.

Exemplo na TechStore:

```text
clientes
   |
   | 1:N
   |
pedidos
```

Um cliente pode possuir vários pedidos.

Entretanto, cada pedido referencia um único cliente.

Outro exemplo:

```text
pedidos
   |
   | 1:N
   |
itens_pedido
```

Um pedido pode possuir vários itens.

## 2.5 Relacionamento N:N

Vários registros de uma tabela podem estar associados a vários registros de outra.

Normalmente esse relacionamento utiliza uma tabela intermediária.

Exemplo:

```text
pedidos
   |
   | 1:N
   |
itens_pedido
   |
   | N:1
   |
produtos
```

Um pedido pode possuir vários produtos, e um produto pode aparecer em vários pedidos.

A tabela `itens_pedido` representa o relacionamento entre pedidos e produtos.

Essa estrutura é conhecida como tabela associativa.

## 2.6 Cardinalidade

Cardinalidade representa a quantidade de registros que podem participar de um relacionamento.

É fundamental compreender que a cardinalidade influencia diretamente a quantidade de linhas produzidas por um JOIN.

Exemplo:

Um cliente possui três pedidos.

Ao combinar clientes e pedidos, o resultado poderá apresentar três linhas para aquele cliente.

Portanto:

- Uma linha na tabela de origem pode produzir várias linhas no resultado.
- O número de registros não necessariamente será preservado.
- A quantidade final depende dos relacionamentos e das condições de junção.

---

# 3. Sintaxe geral do JOIN

A estrutura básica é:

```sql
SELECT
    colunas
FROM tabela_a
JOIN tabela_b
    ON condicao_de_relacionamento;
```

Componentes:

| Elemento | Função |
|---|---|
| SELECT | Define as colunas retornadas |
| FROM | Define a tabela inicial |
| JOIN | Define a tabela que será combinada |
| ON | Define a condição de correspondência |

Exemplo:

```sql
SELECT
    clientes.nome,
    pedidos.id
FROM techstore.clientes AS clientes
INNER JOIN techstore.pedidos AS pedidos
    ON pedidos.cliente_id = clientes.id;
```

## 3.1 Aliases

Aliases permitem atribuir nomes temporários às tabelas.

Exemplo:

```sql
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
```

Vantagens:

- Reduzem a repetição de nomes.
- Melhoram a legibilidade.
- Facilitam consultas com muitas tabelas.
- Ajudam a diferenciar tabelas com colunas de nomes iguais.

Em consultas profissionais, aliases devem ser claros e consistentes.

## 3.2 Qualificação de colunas

Quando duas tabelas possuem colunas com o mesmo nome, devemos identificar de qual tabela estamos falando.

Exemplo:

```sql
SELECT
    c.id,
    p.id
```

Nesse caso, cada coluna é identificada pelo alias correspondente.

A ausência de qualificação pode gerar erros de ambiguidade.

---

# 4. INNER JOIN

## 4.1 Conceito

INNER JOIN retorna somente os registros que possuem correspondência nas duas tabelas, conforme a condição definida.

Representação conceitual:

```text
Tabela A       Tabela B
   [ A ] ∩ [ B ]
```

Somente as correspondências são retornadas.

## 4.2 Sintaxe

```sql
SELECT
    c.nome,
    p.id,
    p.data_pedido
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id;
```

A consulta retorna clientes que possuem pedidos.

Clientes sem pedidos não aparecem no resultado.

## 4.3 Características

- Exige correspondência conforme a condição de junção.
- Pode retornar várias linhas para um mesmo registro da tabela de origem.
- Pode combinar mais de duas tabelas.
- Não preserva registros sem correspondência.

## 4.4 Quando utilizar?

Utilize INNER JOIN quando o resultado precisar conter apenas registros relacionados.

Exemplos:

- Clientes que realizaram pedidos.
- Produtos que aparecem em itens de pedidos.
- Pedidos que possuem pagamentos correspondentes.
- Funcionários associados a departamentos.

---

# 5. LEFT JOIN

## 5.1 Conceito

LEFT JOIN retorna todos os registros da tabela à esquerda e as correspondências encontradas na tabela à direita.

Quando não existe correspondência, as colunas da tabela à direita recebem NULL no resultado.

Representação conceitual:

```text
Tabela A       Tabela B
   [ A ------------- ]
       correspondências
```

## 5.2 Sintaxe

```sql
SELECT
    c.nome,
    p.id AS pedido_id
FROM techstore.clientes AS c
LEFT JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id;
```

A consulta retorna todos os clientes.

Quando um cliente não possui pedidos, `pedido_id` será NULL.

## 5.3 Identificando registros sem correspondência

Uma aplicação importante do LEFT JOIN é encontrar registros sem relacionamento correspondente.

Exemplo:

```sql
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
LEFT JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
WHERE p.id IS NULL;
```

Essa consulta identifica clientes sem pedidos.

O raciocínio é:

1. Todos os clientes são preservados.
2. Pedidos correspondentes são associados.
3. Clientes sem pedidos recebem NULL nas colunas de pedidos.
4. O filtro identifica esses casos.

## 5.4 LEFT JOIN e COUNT

Um cuidado importante surge ao utilizar COUNT.

Considere:

```sql
SELECT
    c.id,
    c.nome,
    COUNT(p.id) AS total_pedidos
FROM techstore.clientes AS c
LEFT JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
GROUP BY
    c.id,
    c.nome;
```

Por que utilizar `COUNT(p.id)` em vez de `COUNT(*)`?

Porque, quando não existe correspondência, o LEFT JOIN ainda produz uma linha para o cliente, mas as colunas de pedidos ficam NULL.

- `COUNT(*)` conta a linha preservada.
- `COUNT(p.id)` ignora o NULL da tabela de pedidos.

Essa diferença é fundamental para produzir indicadores corretos.

---

# 6. RIGHT JOIN

## 6.1 Conceito

RIGHT JOIN retorna todos os registros da tabela à direita e as correspondências encontradas na tabela à esquerda.

Quando não existe correspondência, as colunas da tabela à esquerda recebem NULL.

## 6.2 Sintaxe

```sql
SELECT
    c.nome,
    p.id AS pedido_id
FROM techstore.clientes AS c
RIGHT JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id;
```

Nesse exemplo, todos os pedidos serão preservados.

## 6.3 Comparação com LEFT JOIN

RIGHT JOIN é conceitualmente equivalente a inverter a ordem das tabelas e utilizar LEFT JOIN, mantendo corretamente a condição de junção.

Exemplo equivalente:

```sql
SELECT
    c.nome,
    p.id AS pedido_id
FROM techstore.pedidos AS p
LEFT JOIN techstore.clientes AS c
    ON c.id = p.cliente_id;
```

Na prática, LEFT JOIN costuma ser preferido por facilitar a leitura sequencial das consultas.

## 6.4 Quando utilizar?

Pode ser útil quando a organização da consulta torna mais natural preservar a tabela à direita.

Entretanto, não é obrigatório utilizar RIGHT JOIN para resolver um problema.

---

# 7. FULL OUTER JOIN

## 7.1 Conceito

FULL OUTER JOIN retorna:

- Registros correspondentes.
- Registros existentes somente na tabela esquerda.
- Registros existentes somente na tabela direita.

Quando não existe correspondência, as colunas da outra tabela recebem NULL.

## 7.2 Sintaxe

```sql
SELECT
    c.id AS cliente_id,
    c.nome,
    p.id AS pedido_id
FROM techstore.clientes AS c
FULL OUTER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id;
```

## 7.3 Aplicações

- Comparação entre conjuntos de dados.
- Auditoria de relacionamentos.
- Identificação de registros exclusivos de cada conjunto.
- Reconciliação de informações.

## 7.4 Características

FULL OUTER JOIN não elimina registros sem correspondência de nenhum dos lados.

É importante lembrar que, se a relação for 1:N, os registros correspondentes ainda poderão aparecer em várias linhas.

---

# 8. CROSS JOIN

## 8.1 Conceito

CROSS JOIN produz o produto cartesiano entre duas tabelas.

Cada registro da primeira tabela é combinado com cada registro da segunda.

## 8.2 Sintaxe

```sql
SELECT
    c.id AS cliente_id,
    cp.id AS campanha_id
FROM techstore.clientes AS c
CROSS JOIN techstore.campanhas AS cp;
```

## 8.3 Quantidade de linhas

Se a primeira tabela possuir 100 registros e a segunda possuir 20, o resultado terá:

```text
100 × 20 = 2.000 linhas
```

A quantidade de linhas cresce multiplicativamente.

## 8.4 Aplicações

- Construção de combinações.
- Geração de matrizes de possibilidades.
- Combinação de dimensões.
- Cenários analíticos específicos.

## 8.5 Cuidados

CROSS JOIN pode gerar conjuntos extremamente grandes.

Antes de executá-lo, considere:

- Quantidade de registros de cada tabela.
- Quantidade de combinações esperadas.
- Necessidade real do produto cartesiano.
- Impacto em memória, CPU e tempo de execução.

---

# 9. SELF JOIN

## 9.1 Conceito

SELF JOIN é uma junção de uma tabela com ela mesma.

Não existe uma palavra-chave SELF JOIN específica. Utilizamos um JOIN comum, mas referenciando a mesma tabela por aliases diferentes.

## 9.2 Exemplo conceitual

Imagine uma tabela de funcionários que possui uma coluna indicando o funcionário responsável por outro funcionário.

```text
funcionarios
├── id
├── nome
└── gestor_id
```

Nesse caso, um funcionário pode estar relacionado a outro funcionário da mesma tabela.

## 9.3 Sintaxe conceitual

```sql
SELECT
    funcionario.nome AS funcionario,
    gestor.nome AS gestor
FROM funcionarios AS funcionario
LEFT JOIN funcionarios AS gestor
    ON funcionario.gestor_id = gestor.id;
```

O exemplo é ilustrativo e não representa necessariamente as colunas existentes na tabela `techstore.funcionarios`.

## 9.4 Aplicações

- Hierarquias organizacionais.
- Estruturas de supervisão.
- Relacionamentos entre registros da mesma entidade.
- Comparações entre registros.

---

# 10. JOIN com múltiplas tabelas

## 10.1 Conceito

Uma consulta pode combinar várias tabelas em sequência.

Cada junção acrescenta informações ao conjunto de resultados.

Exemplo da estrutura de relacionamento da TechStore:

```text
clientes
   |
   | cliente_id
   |
pedidos
   |
   | pedido_id
   |
itens_pedido
   |
   | produto_id
   |
produtos
```

## 10.2 Sintaxe

```sql
SELECT
    c.nome AS cliente,
    p.id AS pedido,
    ip.quantidade,
    pr.nome AS produto
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
INNER JOIN techstore.itens_pedido AS ip
    ON ip.pedido_id = p.id
INNER JOIN techstore.produtos AS pr
    ON pr.id = ip.produto_id;
```

A consulta combina quatro tabelas.

## 10.3 Ordem de escrita

A sequência de JOINs deve acompanhar os relacionamentos necessários para construir o resultado.

Uma boa prática é:

1. Identificar a tabela que representa o assunto principal.
2. Identificar as tabelas relacionadas.
3. Localizar as chaves utilizadas.
4. Definir a condição de cada junção.
5. Selecionar as colunas necessárias.
6. Validar a quantidade e a granularidade dos resultados.

Não devemos adicionar tabelas sem necessidade.

## 10.4 Junções sucessivas

Cada JOIN pode alterar a quantidade de linhas.

Portanto, uma consulta com quatro tabelas não significa necessariamente que terá a mesma quantidade de registros da primeira tabela.

É necessário compreender cada relacionamento individualmente.

---

# 11. JOIN e relacionamentos N:N

Relacionamentos N:N são especialmente importantes porque exigem uma tabela intermediária.

Na TechStore:

```text
pedidos
   |
   | 1:N
   |
itens_pedido
   |
   | N:1
   |
produtos
```

A tabela `itens_pedido` conecta pedidos e produtos.

Exemplo:

Um pedido pode conter:

| produto | quantidade |
|---|---:|
| Produto A | 2 |
| Produto B | 1 |
| Produto C | 4 |

O mesmo produto pode aparecer em diversos pedidos.

Por isso, não existe necessariamente uma relação direta e exclusiva entre pedido e produto.

A tabela intermediária armazena informações próprias do relacionamento, como:

- Quantidade.
- Preço unitário.
- Desconto aplicado.

Isso demonstra que uma tabela associativa não é apenas uma ligação técnica: ela pode representar uma operação de negócio.

---

# 12. Condições ON e WHERE

Um dos assuntos mais importantes do módulo é compreender a diferença entre ON e WHERE.

## 12.1 ON

ON define a condição utilizada para relacionar os registros.

Exemplo:

```sql
SELECT
    c.nome,
    p.id
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id;
```

## 12.2 WHERE

WHERE filtra os registros do resultado lógico da consulta.

Exemplo:

```sql
SELECT
    c.nome,
    p.id
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
WHERE p.status = 'entregue';
```

## 12.3 Diferença importante com LEFT JOIN

Considere:

```sql
SELECT
    c.nome,
    p.id
FROM techstore.clientes AS c
LEFT JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
   AND p.status = 'entregue';
```

Nesse caso, todos os clientes continuam preservados, mas somente pedidos entregues serão associados.

Agora observe:

```sql
SELECT
    c.nome,
    p.id
FROM techstore.clientes AS c
LEFT JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
WHERE p.status = 'entregue';
```

Nesse caso, o WHERE elimina os registros em que `p.status` é NULL.

Consequentemente, clientes sem pedidos entregues deixam de aparecer.

Essa diferença é fundamental.

**Regra prática:**

- ON define como os registros serão relacionados.
- WHERE filtra os resultados produzidos pela operação lógica da consulta.

A posição de uma condição pode alterar o significado da consulta.

---

# 13. JOIN com GROUP BY e HAVING

JOIN pode ser combinado com agregações para produzir relatórios analíticos.

Exemplo:

```sql
SELECT
    c.id,
    c.nome,
    COUNT(p.id) AS total_pedidos
FROM techstore.clientes AS c
LEFT JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
GROUP BY
    c.id,
    c.nome;
```

Essa consulta apresenta a quantidade de pedidos por cliente.

## 13.1 Utilizando HAVING

```sql
SELECT
    c.id,
    c.nome,
    COUNT(p.id) AS total_pedidos
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id
GROUP BY
    c.id,
    c.nome
HAVING COUNT(p.id) > 5;
```

Nesse caso, somente clientes com mais de cinco pedidos serão apresentados.

## 13.2 Granularidade

É importante entender o nível de detalhe do resultado.

No primeiro exemplo, cada linha representa um cliente.

No segundo, cada linha também representa um cliente, mas somente aqueles que atendem à condição do HAVING.

Se incluirmos colunas de itens de pedidos, o nível de detalhe poderá mudar.

---

# 14. JOIN com funções agregadas

Combinar JOIN e agregações é uma das aplicações mais comuns em sistemas reais.

Entretanto, também é uma das principais fontes de erros de cálculo.

## 14.1 COUNT

Ao utilizar LEFT JOIN, é importante decidir o que será contado.

- COUNT(*) conta as linhas do resultado.
- COUNT(coluna) ignora valores NULL.
- COUNT(DISTINCT coluna) conta valores únicos não nulos.

## 14.2 SUM

Considere a combinação de pedidos e itens de pedidos.

Um pedido pode possuir vários itens.

Se o valor do pedido estiver armazenado em uma tabela com uma linha por pedido, sua soma poderá ser multiplicada quando combinada diretamente com itens.

Isso ocorre porque os valores da tabela de pedidos são repetidos para cada item correspondente.

## 14.3 Exemplo de multiplicação

Considere:

**pedidos**

| pedido | frete |
|---:|---:|
| 101 | 20 |
| 102 | 15 |

**itens_pedido**

| pedido | item |
|---:|---|
| 101 | A |
| 101 | B |
| 101 | C |
| 102 | D |

Após o JOIN:

| pedido | frete | item |
|---:|---:|---|
| 101 | 20 | A |
| 101 | 20 | B |
| 101 | 20 | C |
| 102 | 15 | D |

Se somarmos o frete diretamente nesse resultado, o valor do pedido 101 será contabilizado três vezes.

A soma correta dos fretes originais é 35, mas a soma após a multiplicação será 75.

O erro não está necessariamente no JOIN.

O erro está em ignorar a granularidade dos dados ao realizar a agregação.

## 14.4 Estratégias para evitar dupla contagem

Algumas abordagens incluem:

- Agregar os dados antes de realizar a junção.
- Utilizar subconsultas.
- Utilizar CTEs.
- Definir corretamente a granularidade.
- Utilizar COUNT(DISTINCT) quando a métrica realmente exigir entidades únicas.

Não devemos utilizar DISTINCT indiscriminadamente para esconder problemas de cardinalidade.

A solução deve preservar a regra de negócio.

---

# 15. Identificação de registros sem correspondência

LEFT JOIN e FULL OUTER JOIN permitem identificar registros que não possuem correspondência.

## 15.1 LEFT JOIN com IS NULL

Exemplo:

```sql
SELECT
    pr.id,
    pr.nome
FROM techstore.produtos AS pr
LEFT JOIN techstore.itens_pedido AS ip
    ON ip.produto_id = pr.id
WHERE ip.produto_id IS NULL;
```

Essa consulta identifica produtos que não aparecem nos itens de pedidos.

## 15.2 Diferença entre NULL original e NULL produzido pelo JOIN

É importante distinguir:

1. Um valor NULL que já existia na tabela.
2. Um valor NULL criado pela ausência de correspondência em uma junção externa.

Essas situações têm significados diferentes.

Por isso, é importante utilizar uma coluna identificadora da tabela relacionada para verificar ausência de correspondência.

## 15.3 Integridade referencial

Quando existe uma FOREIGN KEY válida e corretamente aplicada, ela impede determinadas referências inválidas.

Mesmo assim, consultas de auditoria continuam sendo úteis para:

- Identificar registros sem relacionamento.
- Verificar situações permitidas pelo modelo.
- Encontrar dados opcionais.
- Avaliar a completude das informações.

---

# 16. Duplicações e cardinalidade

Este é um dos temas mais importantes do módulo.

## 16.1 Por que um JOIN pode multiplicar registros?

Imagine:

- Um pedido com quatro itens.
- Cada item relacionado a um produto.
- Cada produto com várias avaliações.

Ao combinar essas tabelas, a quantidade de linhas poderá crescer significativamente.

O resultado dependerá das correspondências existentes.

## 16.2 Duplicação não significa necessariamente erro

Uma linha de pedido pode aparecer várias vezes porque possui vários itens.

Um produto pode aparecer várias vezes porque foi vendido em pedidos diferentes.

Isso é esperado em relacionamentos 1:N e N:N.

O erro acontece quando interpretamos cada linha resultante como se representasse uma entidade única.

## 16.3 Granularidade

Granularidade representa o nível de detalhe de cada linha.

Exemplos:

| Resultado | Granularidade |
|---|---|
| Clientes | Uma linha por cliente |
| Pedidos | Uma linha por pedido |
| Itens de pedido | Uma linha por item |
| Avaliações | Uma linha por avaliação |
| Pedidos com itens | Uma linha por item associado ao pedido |

Antes de construir uma consulta, pergunte:

**O que cada linha do resultado representa?**

Essa pergunta evita grande parte dos erros de JOIN.

## 16.4 COUNT(DISTINCT)

COUNT(DISTINCT) pode ser utilizado para contar entidades únicas mesmo quando o JOIN produz várias linhas para a mesma entidade.

Entretanto, ele não resolve automaticamente todos os problemas de duplicação.

Por exemplo, se o objetivo for somar valores de itens, eliminar valores repetidos pode remover valores legítimos de itens diferentes.

A escolha deve seguir a regra de negócio.

---

# 17. Estratégias de execução de JOIN no PostgreSQL

O PostgreSQL possui diferentes estratégias físicas para executar junções.

O planejador escolhe uma estratégia considerando as estatísticas, os custos estimados e as características da consulta.

As principais são:

## 17.1 Nested Loop

O Nested Loop compara registros de uma entrada com registros da outra entrada.

Conceitualmente:

```text
Para cada registro da tabela A:
    procurar correspondências na tabela B
```

É frequentemente eficiente quando:

- Um dos conjuntos é pequeno.
- Existe um índice útil para localizar correspondências.
- O número de buscas é relativamente baixo.

Pode se tornar caro quando o número de iterações cresce excessivamente.

## 17.2 Hash Join

O Hash Join utiliza uma estrutura de hash para localizar correspondências.

Conceitualmente:

1. Constrói uma estrutura hash com uma das entradas.
2. Percorre a outra entrada.
3. Procura correspondências na estrutura.

Pode ser eficiente em junções entre conjuntos maiores, especialmente quando não existe um índice adequado para a operação.

O consumo de memória e a possibilidade de operações temporárias em disco influenciam seu desempenho.

## 17.3 Merge Join

O Merge Join combina conjuntos ordenados pelas colunas de junção.

Conceitualmente:

1. Percorre os dois conjuntos ordenados.
2. Compara as chaves.
3. Avança conforme as correspondências encontradas.

Pode ser eficiente quando as entradas já estão ordenadas ou quando o custo de ordenação é compensado pela operação.

## 17.4 Comparação

| Estratégia | Característica |
|---|---|
| Nested Loop | Busca correspondências por iterações |
| Hash Join | Utiliza estrutura hash |
| Merge Join | Combina entradas ordenadas |

Nenhuma estratégia é universalmente melhor.

O plano mais adequado depende dos dados e do contexto.

---

# 18. Índices e desempenho

Índices podem melhorar determinadas operações de JOIN, especialmente quando permitem localizar registros com menos leituras.

Na TechStore, existem chaves primárias e índices secundários já criados.

Exemplos de colunas importantes:

- `clientes.id`
- `pedidos.cliente_id`
- `pedidos.id`
- `itens_pedido.pedido_id`
- `itens_pedido.produto_id`
- `produtos.id`

## 18.1 Índice na chave primária

Chaves primárias normalmente possuem um índice UNIQUE criado automaticamente pelo PostgreSQL.

Esse índice pode ser utilizado para localizar registros relacionados.

## 18.2 Índices em chaves estrangeiras

O PostgreSQL não cria automaticamente um índice na coluna que referencia uma FOREIGN KEY.

Isso significa que uma chave estrangeira não garante, por si só, a existência de um índice na coluna relacionada.

A necessidade de um índice deve ser avaliada conforme:

- Volume de registros.
- Frequência das consultas.
- Seletividade.
- Plano de execução.
- Custos de manutenção.

## 18.3 Cuidado com índices

Mais índices não significam necessariamente mais desempenho.

Índices também possuem custos de armazenamento e manutenção.

Neste módulo, analisaremos os índices existentes, sem modificá-los no banco principal.

---

# 19. EXPLAIN e EXPLAIN ANALYZE

A análise do plano de execução permite compreender como o PostgreSQL executa uma consulta.

Exemplo:

```sql
EXPLAIN
SELECT
    c.nome,
    p.id
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id;
```

O EXPLAIN apresenta o plano estimado.

Para executar e observar métricas reais:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.nome,
    p.id
FROM techstore.clientes AS c
INNER JOIN techstore.pedidos AS p
    ON p.cliente_id = c.id;
```

## 19.1 Informações importantes

| Informação | Significado |
|---|---|
| Planning Time | Tempo de planejamento |
| Execution Time | Tempo de execução |
| Node Type | Operação executada |
| Cost | Estimativa de custo |
| Rows | Quantidade estimada de linhas |
| Actual Rows | Quantidade real de linhas |
| Loops | Quantidade de execuções do nó |
| Shared Hit Blocks | Blocos encontrados no cache |
| Shared Read Blocks | Blocos lidos do armazenamento |

## 19.2 Identificando problemas

Alguns sinais que merecem investigação:

- Grande diferença entre linhas estimadas e reais.
- Muitas iterações em Nested Loop.
- Ordenações muito custosas.
- Hash Join com operações temporárias em disco.
- Grande quantidade de blocos lidos.
- Resultado intermediário muito maior que o esperado.

Esses sinais não significam necessariamente que a consulta esteja errada.

É preciso interpretar o plano completo.

## 19.3 EXPLAIN ANALYZE executa a consulta

EXPLAIN ANALYZE realmente executa o comando analisado.

Para SELECT, ele não modifica os dados, mas pode consumir recursos relevantes.

Por isso, consultas que combinam tabelas grandes deverão ser executadas individualmente e com atenção ao volume esperado.

---

# 20. Erros frequentes

## 20.1 Esquecer a condição ON

Uma junção sem condição apropriada pode produzir um produto cartesiano ou um resultado incorreto.

## 20.2 Utilizar a coluna errada

Relacionar colunas que não representam o mesmo identificador pode gerar correspondências incorretas.

## 20.3 Confundir ON e WHERE

Em junções externas, mover uma condição entre ON e WHERE pode alterar quais registros são preservados.

## 20.4 Utilizar COUNT(*) incorretamente

Em LEFT JOIN, COUNT(*) pode contabilizar a linha preservada mesmo sem correspondência.

## 20.5 Somar valores duplicados

Relacionamentos 1:N podem repetir valores da tabela do lado 1.

## 20.6 Utilizar DISTINCT para esconder erros

DISTINCT não substitui a compreensão dos relacionamentos.

## 20.7 Esquecer a granularidade

Não saber o que cada linha representa torna as agregações perigosas.

## 20.8 Utilizar CROSS JOIN sem necessidade

O produto cartesiano pode aumentar muito o resultado.

## 20.9 Não qualificar colunas

Consultas com várias tabelas podem apresentar nomes de colunas ambíguos.

## 20.10 Adicionar tabelas desnecessárias

Cada junção deve possuir uma finalidade clara.

---

# 21. Boas práticas profissionais

1. Entenda o relacionamento antes de escrever o JOIN.
2. Identifique a granularidade desejada.
3. Utilize aliases claros.
4. Qualifique as colunas.
5. Utilize a condição ON correta.
6. Prefira LEFT JOIN quando precisar preservar todos os registros da tabela principal.
7. Utilize INNER JOIN quando somente correspondências forem necessárias.
8. Avalie a cardinalidade de cada relacionamento.
9. Verifique a possibilidade de duplicação antes de agregar.
10. Utilize COUNT(DISTINCT) somente quando representar a métrica desejada.
11. Analise consultas grandes com EXPLAIN.
12. Compare estimativas e resultados reais.
13. Evite selecionar colunas desnecessárias.
14. Valide os resultados independentemente.
15. Priorize correção lógica antes de otimização.

---

# 22. Referência rápida

| JOIN | Resultado |
|---|---|
| INNER JOIN | Somente correspondências |
| LEFT JOIN | Todos da esquerda e correspondências da direita |
| RIGHT JOIN | Todos da direita e correspondências da esquerda |
| FULL OUTER JOIN | Todos dos dois lados |
| CROSS JOIN | Produto cartesiano |
| SELF JOIN | Uma tabela relacionada a ela mesma |

### Conceitos fundamentais

| Conceito | Significado |
|---|---|
| PK | Chave primária |
| FK | Chave estrangeira |
| Cardinalidade | Quantidade de correspondências |
| Granularidade | Nível de detalhe de cada linha |
| ON | Condição de junção |
| WHERE | Filtro de registros |
| HAVING | Filtro de grupos |
| Hash Join | Junção baseada em hash |
| Nested Loop | Junção por iterações |
| Merge Join | Junção de entradas ordenadas |

---

# 23. Referências oficiais

Documentação PostgreSQL 16:

- JOINs: https://www.postgresql.org/docs/16/queries-table-expressions.html
- SELECT: https://www.postgresql.org/docs/16/sql-select.html
- Funções agregadas: https://www.postgresql.org/docs/16/functions-aggregate.html
- EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html
- Índices: https://www.postgresql.org/docs/16/indexes.html
- Constraints: https://www.postgresql.org/docs/16/ddl-constraints.html
- Using EXPLAIN: https://www.postgresql.org/docs/16/using-explain.html

---

# 24. Resultados esperados

Ao finalizar a teoria e as atividades, o estudante deverá ser capaz de:

- Construir consultas com diferentes tipos de JOIN.
- Relacionar corretamente tabelas da TechStore.
- Combinar várias tabelas em uma consulta.
- Identificar registros sem correspondência.
- Compreender relacionamentos 1:1, 1:N e N:N.
- Explicar a multiplicação de registros.
- Identificar a granularidade de um resultado.
- Construir agregações sem dupla contagem.
- Diferenciar condições ON e WHERE.
- Interpretar estratégias de execução do PostgreSQL.
- Analisar desempenho com EXPLAIN ANALYZE.
- Validar os resultados de maneira independente.

**O principal resultado esperado não é apenas saber escrever JOINs, mas conseguir combinar informações de diferentes tabelas sem perder o controle sobre a lógica e a precisão dos resultados.**