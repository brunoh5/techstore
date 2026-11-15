# Teoria — Módulo 02: SELECT e filtros

## 1. Introdução

O comando `SELECT` é utilizado para recuperar informações armazenadas em um banco de dados relacional.

Diferentemente dos comandos responsáveis por inserir, modificar ou excluir registros, o SELECT permite consultar os dados sem alterar seu conteúdo.

Neste módulo, o estudante desenvolverá a capacidade de formular perguntas ao banco de dados e transformar essas perguntas em consultas SQL.

Exemplos de perguntas que poderão ser respondidas:

- Quais produtos estão cadastrados?
- Quais produtos pertencem a determinada categoria?
- Quais clientes estão localizados em uma cidade específica?
- Quais pedidos foram realizados em determinado período?
- Quais produtos possuem preço acima de determinado valor?
- Quais registros ainda não possuem uma informação preenchida?
- Quais foram os acessos mais recentes?
- Como localizar registros que atendam a várias condições simultaneamente?

A capacidade de construir essas consultas é uma das competências fundamentais para trabalhar com bancos de dados.

---

# Tema 01 — Introdução ao SELECT

## 1.1. O que é SELECT?

`SELECT` é uma instrução SQL utilizada para recuperar dados.

Uma consulta básica possui duas partes fundamentais:

- `SELECT`: determina quais informações serão retornadas.
- `FROM`: determina de onde essas informações serão obtidas.

Estrutura conceitual:

```sql
SELECT coluna
FROM tabela;
```

O banco recebe a instrução, interpreta sua estrutura e produz um conjunto de resultados.

Esse conjunto é frequentemente chamado de resultado da consulta ou result set.

## 1.2. Selecionando todas as colunas

O caractere `*` representa todas as colunas disponíveis na origem consultada.

Exemplo:

```sql
SELECT *
FROM techstore.produtos;
```

Essa consulta solicita todas as colunas da tabela de produtos.

Embora seja útil durante a exploração inicial, utilizar `SELECT *` indiscriminadamente não é uma boa prática em consultas profissionais.

### Por que evitar SELECT *?

Considere uma tabela com 30 colunas, mas uma consulta que precisa apenas do nome e do preço do produto.

Solicitar todas as colunas pode:

- Transferir informações desnecessárias.
- Aumentar o volume de dados retornados.
- Dificultar a leitura dos resultados.
- Aumentar o consumo de memória da aplicação.
- Criar dependência desnecessária da estrutura completa da tabela.
- Expor informações que não deveriam ser utilizadas.

Sempre que possível, selecione somente as colunas necessárias.

## 1.3. Selecionando colunas específicas

É possível determinar exatamente quais colunas devem aparecer no resultado.

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM techstore.produtos;
```

O resultado apresentará somente as colunas solicitadas.

A ordem das colunas no resultado segue a ordem em que foram declaradas no SELECT.

Isso permite controlar a apresentação das informações.

## 1.4. Identificação de tabelas e schemas

No PostgreSQL, os objetos podem ser referenciados pelo nome da tabela ou pelo nome qualificado.

Exemplo:

```sql
SELECT nome
FROM techstore.produtos;
```

A expressão `techstore.produtos` identifica:

- `techstore`: schema.
- `produtos`: tabela.

Utilizar o schema explicitamente ajuda a evitar ambiguidades quando existem tabelas com nomes iguais em schemas diferentes.

## 1.5. Alias de colunas

Um alias permite atribuir outro nome a uma coluna no resultado da consulta.

Exemplo:

```sql
SELECT
    nome AS nome_produto,
    preco AS valor_venda
FROM techstore.produtos;
```

O alias modifica o nome apresentado no resultado, não o nome real da coluna no banco.

Também é possível utilizar alias sem a palavra AS, embora seja recomendável manter uma escrita consistente.

## 1.6. Como o PostgreSQL interpreta uma consulta?

Uma consulta SQL possui uma ordem de escrita, mas o processamento lógico de suas cláusulas segue uma sequência conceitual diferente.

Em uma consulta comum, podemos representar essa ordem simplificadamente como:

1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. DISTINCT
7. ORDER BY
8. LIMIT e OFFSET

Nem todas essas cláusulas serão estudadas neste módulo.

É importante compreender que o banco não simplesmente executa cada linha de cima para baixo. O planejador PostgreSQL pode reorganizar operações internamente quando isso preserva a semântica da consulta.

### Atenção

Um alias criado no SELECT geralmente não pode ser utilizado no WHERE da mesma consulta, pois o WHERE é avaliado logicamente antes da lista de seleção.

Essa diferença será importante nos próximos módulos.

## 1.7. Erros frequentes

- Solicitar uma coluna que não existe.
- Informar o nome de uma tabela incorretamente.
- Esquecer a origem dos dados.
- Confundir nome de coluna com alias.
- Utilizar SELECT * em consultas desnecessariamente grandes.
- Não qualificar o schema quando isso é necessário.

---

# Tema 02 — DISTINCT

## 2.1. O que é DISTINCT?

O operador `DISTINCT` elimina linhas duplicadas do resultado de uma consulta.

Ele não exclui registros da tabela original.

Seu funcionamento acontece somente sobre o conjunto de resultados produzido pela consulta.

Estrutura:

```sql
SELECT DISTINCT coluna
FROM tabela;
```

Exemplo conceitual:

Imagine que uma tabela de produtos possua os seguintes valores em uma coluna de categoria:

| Categoria |
|---|
| Informática |
| Informática |
| Escritório |
| Escritório |
| Eletrônicos |

Uma consulta com DISTINCT retornaria cada valor distinto uma única vez.

## 2.2. DISTINCT em múltiplas colunas

Também é possível aplicar DISTINCT sobre mais de uma coluna.

Exemplo:

```sql
SELECT DISTINCT
    categoria,
    marca
FROM techstore.produtos;
```

Nesse caso, o PostgreSQL considera a combinação das colunas.

Isso significa que:

- Categoria A + Marca X é uma combinação.
- Categoria A + Marca Y é outra combinação.
- Categoria B + Marca X é outra combinação.

Mesmo que uma categoria apareça várias vezes, combinações diferentes continuarão aparecendo.

## 2.3. DISTINCT e NULL

O PostgreSQL considera valores NULL como não distintos entre si para a finalidade de DISTINCT.

Portanto, se várias linhas possuírem NULL na coluna consultada, o resultado distinto apresentará uma única ocorrência de NULL.

## 2.4. DISTINCT não é uma ferramenta de correção de dados

Um erro comum é utilizar DISTINCT para esconder duplicidades que deveriam ser investigadas.

Por exemplo, se uma consulta apresenta linhas repetidas inesperadamente, isso pode indicar:

- Problema na lógica da consulta.
- Combinação incorreta de dados.
- Duplicidades legítimas na origem.
- Necessidade de compreender melhor a estrutura dos registros.

DISTINCT pode ser correto em determinadas situações, mas não deve ser utilizado automaticamente para eliminar resultados que parecem inconvenientes.

## 2.5. DISTINCT e desempenho

A eliminação de duplicidades exige trabalho adicional do PostgreSQL.

Dependendo da consulta e do plano de execução, o banco poderá utilizar operações como:

- Sort.
- Unique.
- HashAggregate.

O custo depende da quantidade de registros, das colunas envolvidas e das condições de execução.

Não é correto afirmar que DISTINCT sempre será lento ou sempre utilizará uma operação específica.

---

# Tema 03 — WHERE

## 3.1. O que é WHERE?

A cláusula `WHERE` permite filtrar os registros que participarão do resultado.

Sem WHERE, uma consulta normalmente considera todas as linhas da origem, respeitando eventuais outras condições da consulta.

Com WHERE, somente os registros cuja condição seja avaliada como verdadeira são selecionados.

Estrutura:

```sql
SELECT colunas
FROM tabela
WHERE condição;
```

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco > 100;
```

A consulta retorna os produtos cujo preço é maior que 100.

## 3.2. Como funciona um filtro?

Uma condição é uma expressão que o PostgreSQL avalia para cada registro considerado pela consulta.

O resultado lógico de uma condição pode ser:

- TRUE.
- FALSE.
- UNKNOWN.

Somente registros cuja condição seja TRUE são mantidos pelo WHERE.

FALSE e UNKNOWN não passam pelo filtro.

O comportamento de UNKNOWN está relacionado principalmente aos valores NULL e será aprofundado no Tema 08.

## 3.3. Filtragem de registros

Um filtro pode trabalhar com diferentes tipos de dados.

Exemplos de critérios:

- Preço de um produto.
- Nome de um cliente.
- Data de um pedido.
- Situação de uma entrega.
- Quantidade em estoque.
- Identificador de uma categoria.

O tipo de dado da coluna influencia quais operadores e comparações fazem sentido.

## 3.4. Filtragem textual

Comparações de texto podem considerar igualdade entre valores.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.categorias
WHERE nome = 'Informática';
```

A comparação textual com `=` normalmente diferencia letras maiúsculas e minúsculas conforme as regras de comparação aplicáveis à expressão.

Para pesquisas textuais mais flexíveis, existem operadores específicos, estudados no Tema 07.

## 3.5. Filtragem temporal

Colunas de data e horário podem ser utilizadas em condições.

Exemplo conceitual:

```sql
SELECT
    id,
    data_pedido
FROM techstore.pedidos
WHERE data_pedido >= TIMESTAMP '2026-01-01 00:00:00';
```

O tipo de dado precisa ser considerado.

Uma coluna DATE representa uma data. Uma coluna TIMESTAMP representa data e horário sem fuso horário. TIMESTAMPTZ representa um instante interpretado com regras de fuso horário.

O uso incorreto de tipos temporais pode produzir resultados inesperados.

## 3.6. Filtros e seletividade

Seletividade representa, de maneira simplificada, a proporção de registros que satisfazem determinada condição.

Imagine uma tabela com um milhão de registros:

- Um filtro que retorna 10 registros possui alta seletividade.
- Um filtro que retorna 900 mil registros possui baixa seletividade.

Essa característica influencia o planejamento da consulta e pode afetar a utilidade de um índice.

Entretanto, seletividade não determina sozinha qual será o melhor plano de execução.

## 3.7. Erros frequentes

- Utilizar operadores incompatíveis com o tipo de dado.
- Comparar texto com valores numéricos sem compreender a conversão.
- Esquecer aspas em literais textuais.
- Aplicar filtros sobre a coluna errada.
- Interpretar resultado vazio como prova de que não existem registros relacionados.
- Esquecer que NULL exige tratamento específico.

---

# Tema 04 — Operadores de comparação

## 4.1. Finalidade

Os operadores de comparação permitem avaliar relações entre dois valores.

São utilizados principalmente em condições de filtragem.

Os operadores fundamentais são:

| Operador | Significado |
|---|---|
| = | Igual |
| <> | Diferente |
| != | Diferente |
| > | Maior que |
| < | Menor que |
| >= | Maior ou igual |
| <= | Menor ou igual |

No PostgreSQL, `<>` e `!=` são aceitos como operadores de diferença. A forma padrão SQL é `<>`.

## 4.2. Comparação numérica

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco >= 500;
```

O filtro considera os produtos cujo preço seja maior ou igual a 500.

Operadores numéricos são comuns em:

- Preços.
- Quantidades.
- Estoques.
- Identificadores.
- Percentuais.
- Valores de transações.

## 4.3. Comparação textual

Valores textuais podem ser comparados.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.marcas
WHERE nome <> 'Marca X';
```

A comparação depende das regras de comparação e collation aplicáveis.

Não se deve presumir que comparações textuais sempre se comportam como comparações numéricas.

## 4.4. Comparação de datas

Datas podem ser comparadas cronologicamente.

Exemplo:

```sql
SELECT
    id,
    data_pedido
FROM techstore.pedidos
WHERE data_pedido >= DATE '2026-01-01';
```

É recomendável utilizar literais tipados quando isso torna a intenção mais clara.

## 4.5. Valores monetários

Para valores monetários, é importante compreender o tipo de dado utilizado.

O PostgreSQL oferece, entre outros:

- NUMERIC.
- DECIMAL.
- REAL.
- DOUBLE PRECISION.

NUMERIC e DECIMAL permitem representar valores decimais com precisão especificada, sendo frequentemente adequados para valores financeiros.

REAL e DOUBLE PRECISION são tipos de ponto flutuante e possuem representação aproximada.

O tipo real utilizado na tabela deve ser observado antes de construir comparações.

## 4.6. Comparações com NULL

Uma comparação comum não deve ser utilizada para verificar se uma coluna é NULL.

Exemplos conceitualmente incorretos:

```sql
coluna = NULL
```

```sql
coluna <> NULL
```

O resultado dessas comparações não é TRUE ou FALSE, mas UNKNOWN.

A maneira correta de verificar valores nulos será estudada no Tema 08.

---

# Tema 05 — Operadores lógicos

## 5.1. Introdução

Os operadores lógicos permitem combinar ou inverter condições.

São fundamentais para consultas que representam regras de negócio.

Os três operadores principais são:

- AND.
- OR.
- NOT.

## 5.2. AND

AND exige que todas as condições combinadas sejam verdadeiras.

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco > 100
  AND preco < 500;
```

A consulta considera apenas os registros que satisfazem as duas condições.

Uma condição verdadeira não é suficiente quando a outra é falsa ou desconhecida.

## 5.3. OR

OR permite que pelo menos uma das condições seja verdadeira.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.produtos
WHERE categoria_id = 1
   OR categoria_id = 2;
```

A consulta considera registros que satisfaçam pelo menos uma das condições.

## 5.4. NOT

NOT inverte o resultado lógico de uma expressão.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.produtos
WHERE NOT (preco > 500);
```

O NOT transforma TRUE em FALSE e FALSE em TRUE.

Quando o resultado original é UNKNOWN, o resultado continua UNKNOWN.

## 5.5. Precedência dos operadores

Quando AND e OR aparecem na mesma expressão, a precedência precisa ser compreendida.

No SQL, AND possui precedência maior que OR.

Considere:

```sql
WHERE categoria_id = 1
   OR categoria_id = 2
  AND preco > 100
```

A interpretação lógica é equivalente a:

```sql
WHERE categoria_id = 1
   OR (categoria_id = 2 AND preco > 100)
```

Isso pode ser diferente da intenção de quem escreveu a consulta.

## 5.6. Utilização de parênteses

Parênteses tornam explícita a ordem de avaliação desejada.

Exemplo:

```sql
WHERE (categoria_id = 1 OR categoria_id = 2)
  AND preco > 100
```

Agora o filtro de preço é aplicado às duas categorias.

Em consultas profissionais, utilizar parênteses para deixar regras complexas explícitas é uma boa prática, mesmo quando a precedência já é conhecida.

## 5.7. Tabela lógica simplificada

| A | B | A AND B | A OR B |
|---|---|---|---|
| TRUE | TRUE | TRUE | TRUE |
| TRUE | FALSE | FALSE | TRUE |
| FALSE | TRUE | FALSE | TRUE |
| FALSE | FALSE | FALSE | FALSE |

Essa tabela apresenta os casos sem NULL.

Quando valores nulos participam de uma condição, o SQL utiliza lógica de três valores.

## 5.8. Lógica de três valores

| A | B | A AND B | A OR B |
|---|---|---|---|
| TRUE | UNKNOWN | UNKNOWN | TRUE |
| FALSE | UNKNOWN | FALSE | UNKNOWN |
| UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN |

Essa lógica é uma das principais fontes de erros em filtros SQL.

---

# Tema 06 — IN e BETWEEN

## 6.1. Operador IN

IN permite verificar se um valor pertence a um conjunto de valores.

Estrutura:

```sql
WHERE coluna IN (valor1, valor2, valor3)
```

Exemplo:

```sql
SELECT
    id,
    nome,
    categoria_id
FROM techstore.produtos
WHERE categoria_id IN (1, 2, 3);
```

É uma alternativa mais legível do que escrever várias condições de igualdade ligadas por OR.

## 6.2. NOT IN

NOT IN verifica se um valor não pertence ao conjunto informado.

Exemplo:

```sql
WHERE categoria_id NOT IN (1, 2, 3)
```

### Atenção com NULL

O NOT IN pode produzir resultados inesperados quando o conjunto contém NULL.

Em particular, uma expressão equivalente a:

```sql
valor NOT IN (1, 2, NULL)
```

não será TRUE para valores que não correspondam a 1 ou 2: a presença de NULL pode fazer a condição resultar em UNKNOWN.

É necessário compreender a origem dos valores e tratar NULL adequadamente.

## 6.3. Operador BETWEEN

BETWEEN verifica se um valor está dentro de um intervalo inclusivo.

Estrutura:

```sql
WHERE coluna BETWEEN valor_inicial AND valor_final
```

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco BETWEEN 100 AND 500;
```

Os limites são inclusivos.

Isso significa que valores iguais a 100 e 500 também satisfazem a condição.

## 6.4. NOT BETWEEN

NOT BETWEEN verifica se o valor está fora do intervalo.

Exemplo:

```sql
WHERE preco NOT BETWEEN 100 AND 500
```

Assim como outras comparações, a presença de NULL precisa ser considerada.

## 6.5. BETWEEN com datas

O uso de BETWEEN em colunas temporais exige atenção especial.

Imagine uma coluna TIMESTAMP e uma necessidade de buscar todos os registros de determinado dia.

Um intervalo com limite final representado apenas pela data pode equivaler à meia-noite do início daquele dia.

Portanto, o intervalo pode não incluir os horários posteriores.

Uma abordagem frequentemente mais segura é utilizar um intervalo semiaberto:

```sql
WHERE data_pedido >= TIMESTAMP '2026-01-01 00:00:00'
  AND data_pedido <  TIMESTAMP '2026-01-02 00:00:00'
```

O início é inclusivo e o fim é exclusivo.

Essa técnica evita problemas com frações de segundo e diferentes precisões temporais.

## 6.6. Quando utilizar cada operador?

| Necessidade | Operador |
|---|---|
| Verificar igualdade com vários valores | IN |
| Excluir valores de um conjunto | NOT IN |
| Verificar um intervalo inclusivo | BETWEEN |
| Verificar valores fora de um intervalo | NOT BETWEEN |

---

# Tema 07 — LIKE e ILIKE

## 7.1. Introdução

LIKE e ILIKE são operadores utilizados para comparar padrões textuais.

São especialmente úteis quando não se conhece o conteúdo completo de uma coluna.

Exemplos de aplicações:

- Pesquisar produtos pelo nome.
- Localizar clientes pelo sobrenome.
- Encontrar descrições que contenham determinado termo.
- Identificar registros com um prefixo específico.

## 7.2. Caracteres especiais

LIKE utiliza dois caracteres especiais:

| Caractere | Significado |
|---|---|
| % | Representa zero ou mais caracteres |
| _ | Representa exatamente um caractere |

## 7.3. Pesquisa com %

O caractere `%` permite representar qualquer sequência de caracteres.

Exemplos conceituais:

| Padrão | Comportamento |
|---|---|
| `'A%'` | Começa com A |
| `'%A'` | Termina com A |
| `'%A%'` | Contém A |
| `'A%B'` | Começa com A e termina com B |

## 7.4. Pesquisa com _

O caractere `_` representa exatamente um caractere.

Exemplo conceitual:

```sql
WHERE codigo LIKE 'A_1'
```

O padrão corresponde a um texto que tenha três caracteres, começando com A e terminando com 1.

O caractere intermediário pode ser qualquer caractere.

## 7.5. Diferença entre LIKE e ILIKE

LIKE realiza correspondência de padrão considerando as regras de comparação textual aplicáveis.

ILIKE é uma extensão do PostgreSQL que realiza correspondência sem diferenciar maiúsculas e minúsculas, de acordo com as regras de locale/collation aplicáveis.

Exemplo:

```sql
SELECT nome
FROM techstore.produtos
WHERE nome ILIKE '%notebook%';
```

Essa consulta permite encontrar variações de capitalização do termo.

ILIKE é específico do PostgreSQL e não faz parte do padrão SQL.

## 7.6. Caracteres especiais literais

Se for necessário pesquisar literalmente um caractere `%` ou `_`, é preciso utilizar uma estratégia de escape.

O PostgreSQL permite especificar o caractere de escape com ESCAPE.

Isso é importante em pesquisas que envolvem códigos, identificadores e textos que realmente contêm esses símbolos.

## 7.7. LIKE e desempenho

Pesquisas textuais podem apresentar comportamentos diferentes dependendo do padrão.

Em termos gerais:

- Padrões com prefixo fixo podem permitir determinadas estratégias de indexação.
- Padrões iniciados com `%` normalmente são mais difíceis de otimizar com índices B-tree convencionais.
- Índices especializados, como trigramas, podem ajudar em determinadas pesquisas.

Não se deve concluir que toda pesquisa LIKE é lenta ou que todo índice resolverá o problema.

O desempenho precisa ser avaliado no plano de execução.

---

# Tema 08 — Tratamento de NULL

## 8.1. O que é NULL?

NULL representa a ausência de um valor conhecido.

Ele não significa necessariamente:

- Zero.
- String vazia.
- Falso.
- Valor inválido.
- Espaço em branco.

Uma coluna NULL pode indicar que a informação não foi fornecida, não é conhecida ou não está disponível.

O significado de NULL também depende do contexto da aplicação.

## 8.2. NULL e string vazia

Os valores abaixo são diferentes:

| Valor | Significado |
|---|---|
| NULL | Ausência de valor conhecido |
| `''` | Texto vazio |
| `' '` | Texto contendo um espaço |
| `0` | Número zero |
| FALSE | Valor booleano falso |

Confundir esses valores pode provocar erros de interpretação e filtragem.

## 8.3. IS NULL

IS NULL verifica se uma expressão possui valor nulo.

Exemplo:

```sql
SELECT
    id,
    nome,
    telefone
FROM techstore.clientes
WHERE telefone IS NULL;
```

A consulta retorna clientes cuja coluna telefone não possui valor conhecido.

## 8.4. IS NOT NULL

IS NOT NULL verifica se a expressão possui algum valor diferente de NULL.

Exemplo:

```sql
SELECT
    id,
    nome,
    telefone
FROM techstore.clientes
WHERE telefone IS NOT NULL;
```

## 8.5. Lógica de três valores

O SQL utiliza três estados lógicos:

- TRUE.
- FALSE.
- UNKNOWN.

Uma comparação envolvendo NULL normalmente resulta em UNKNOWN.

Exemplo conceitual:

```sql
NULL = 10
```

O resultado não é FALSE, mas UNKNOWN.

Essa característica explica por que filtros aparentemente corretos podem não retornar os registros esperados.

## 8.6. NULL em operações lógicas

Considere:

| Expressão | Resultado |
|---|---|
| TRUE AND UNKNOWN | UNKNOWN |
| FALSE AND UNKNOWN | FALSE |
| TRUE OR UNKNOWN | TRUE |
| FALSE OR UNKNOWN | UNKNOWN |
| NOT UNKNOWN | UNKNOWN |

O WHERE seleciona somente condições que resultem em TRUE.

## 8.7. NULL em ordenações

O PostgreSQL permite controlar explicitamente a posição dos valores NULL com:

- NULLS FIRST.
- NULLS LAST.

O comportamento padrão depende da direção da ordenação:

- ASC: NULLS LAST.
- DESC: NULLS FIRST.

É possível substituir esse comportamento explicitamente.

## 8.8. Erros frequentes

- Utilizar `= NULL`.
- Utilizar `<> NULL`.
- Tratar NULL como zero.
- Confundir ausência de valor com texto vazio.
- Ignorar o impacto de NULL em NOT IN.
- Presumir que NOT transforma UNKNOWN em TRUE.

---

# Tema 09 — ORDER BY

## 9.1. Finalidade

ORDER BY define a ordem dos registros apresentados no resultado.

Sem ORDER BY, não existe garantia de uma ordem específica.

Mesmo que uma consulta pareça retornar os registros sempre na mesma sequência, isso não constitui uma garantia contratual do PostgreSQL.

Estrutura:

```sql
SELECT colunas
FROM tabela
ORDER BY coluna;
```

## 9.2. ASC

ASC indica ordenação crescente.

É a direção padrão quando nenhuma direção é informada.

Exemplos:

- Números: menor para maior.
- Datas: mais antiga para mais recente.
- Textos: ordem conforme as regras de comparação textual.

## 9.3. DESC

DESC indica ordenação decrescente.

Exemplos:

- Números: maior para menor.
- Datas: mais recente para mais antiga.
- Textos: ordem inversa conforme as regras de comparação textual.

## 9.4. Ordenação por múltiplas colunas

É possível utilizar mais de uma coluna para ordenar os resultados.

Exemplo:

```sql
SELECT
    id,
    categoria_id,
    nome,
    preco
FROM techstore.produtos
ORDER BY
    categoria_id ASC,
    preco DESC;
```

A primeira coluna determina a ordenação principal.

Quando houver empate na primeira coluna, a segunda coluna será utilizada.

É possível adicionar outras colunas conforme a necessidade.

## 9.5. Ordenação determinística

Uma consulta pode ordenar por uma coluna que possui valores repetidos.

Nesse caso, os registros empatados não possuem necessariamente uma ordem garantida entre si.

Para garantir uma sequência estável, pode ser necessário acrescentar uma coluna única, como uma chave primária.

Exemplo:

```sql
ORDER BY
    data_pedido DESC,
    id DESC;
```

Isso é especialmente importante em paginação.

## 9.6. NULLS FIRST e NULLS LAST

Essas opções determinam a posição dos valores nulos.

Exemplo:

```sql
ORDER BY preco ASC NULLS LAST;
```

A consulta organiza os preços em ordem crescente e coloca valores nulos no final.

Esse comportamento pode ser definido explicitamente independentemente da direção da ordenação.

## 9.7. Ordenação por expressões

ORDER BY também pode ordenar resultados utilizando expressões.

Exemplo conceitual:

```sql
ORDER BY preco * 1.10 DESC;
```

O PostgreSQL ordenará de acordo com o resultado da expressão.

Esse recurso permite ordenar por valores calculados sem necessariamente apresentar a expressão no resultado.

## 9.8. ORDER BY e desempenho

A ordenação pode exigir trabalho adicional.

Dependendo do plano, o PostgreSQL poderá utilizar:

- Sort.
- Incremental Sort.
- Índices que atendam à ordenação.
- Outras estratégias compatíveis com a consulta.

A presença de um índice não garante que ele será escolhido.

O planejador avalia os custos estimados de cada estratégia.

---

# Tema 10 — LIMIT e OFFSET

## 10.1. LIMIT

LIMIT restringe a quantidade máxima de linhas retornadas.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.produtos
LIMIT 10;
```

A consulta retorna no máximo dez registros.

LIMIT é muito útil durante a exploração de tabelas grandes.

## 10.2. OFFSET

OFFSET determina quantas linhas serão ignoradas antes do início do resultado retornado.

Exemplo:

```sql
SELECT
    id,
    nome
FROM techstore.produtos
ORDER BY id
LIMIT 10 OFFSET 20;
```

A consulta ignora as primeiras vinte linhas da sequência ordenada e retorna as dez seguintes.

## 10.3. Paginação

LIMIT e OFFSET podem ser utilizados para implementar paginação.

Exemplo conceitual:

| Página | LIMIT | OFFSET |
|---|---:|---:|
| 1 | 10 | 0 |
| 2 | 10 | 10 |
| 3 | 10 | 20 |
| 4 | 10 | 30 |

A fórmula para calcular o OFFSET é:

\[
OFFSET = (página - 1) \times tamanho\_da\_página
\]

## 10.4. Por que ORDER BY é importante?

Utilizar LIMIT sem ORDER BY não garante quais registros serão retornados.

Além disso, utilizar OFFSET sem uma ordenação determinística pode causar inconsistências entre páginas.

Uma ordenação estável é fundamental para que a paginação seja previsível.

## 10.5. Limitações de OFFSET

Em tabelas grandes, valores elevados de OFFSET podem ser custosos.

Isso acontece porque o banco pode precisar localizar e descartar uma grande quantidade de registros antes de retornar a página desejada.

Em aplicações profissionais, existem alternativas, como paginação por cursor ou keyset pagination.

Essas técnicas serão estudadas em conteúdos posteriores, quando o conhecimento de filtros, ordenação e índices estiver mais consolidado.

## 10.6. LIMIT e segurança operacional

LIMIT reduz a quantidade de linhas retornadas, mas não garante que o PostgreSQL precise examinar somente essa quantidade de registros.

Uma consulta pode precisar ler ou ordenar muitos registros antes de retornar as primeiras linhas.

Portanto, LIMIT não substitui uma análise de desempenho.

---

# Tema 11 — Construção de consultas compostas

## 11.1. Integração dos conhecimentos

Até este ponto, os operadores foram estudados individualmente.

Na prática, consultas SQL normalmente combinam várias cláusulas.

Uma consulta pode:

1. Selecionar colunas específicas.
2. Definir uma tabela de origem.
3. Aplicar múltiplos filtros.
4. Combinar condições.
5. Ordenar os registros.
6. Limitar os resultados.

Exemplo didático:

```sql
SELECT
    id,
    nome,
    preco,
    categoria_id
FROM techstore.produtos
WHERE preco >= 100
  AND categoria_id IN (1, 2, 3)
ORDER BY preco DESC, id ASC
LIMIT 20;
```

Essa consulta combina conceitos apresentados nos temas anteriores.

Ela não representa a solução de uma atividade, mas demonstra como diferentes recursos SQL trabalham em conjunto.

## 11.2. Transformando requisitos em consultas

Antes de escrever SQL, é importante interpretar corretamente o requisito.

Considere a seguinte necessidade:

"Encontrar os produtos de determinadas categorias que possuam preço acima de um valor mínimo, apresentando os mais caros primeiro."

É necessário identificar:

- Qual tabela contém os dados?
- Quais colunas precisam aparecer?
- Quais categorias são aceitas?
- Qual é o limite de preço?
- Qual é a ordem de apresentação?
- Existe uma quantidade máxima de resultados?

A consulta deverá representar exatamente essas regras.

## 11.3. Decomposição de problemas

Consultas complexas ficam mais fáceis quando divididas em etapas conceituais.

Uma estratégia recomendada:

1. Identificar a origem dos dados.
2. Definir as colunas necessárias.
3. Construir o primeiro filtro.
4. Adicionar as condições restantes.
5. Conferir a lógica AND/OR.
6. Adicionar a ordenação.
7. Aplicar a limitação de resultados.
8. Conferir os registros retornados.
9. Testar casos extremos.

## 11.4. Validação lógica

Uma consulta sintaticamente correta pode produzir resultados incorretos.

Exemplo de possíveis problemas:

- Utilizar OR no lugar de AND.
- Esquecer parênteses.
- Aplicar um limite de data incorreto.
- Ignorar NULL.
- Filtrar uma coluna que não representa a regra de negócio desejada.
- Ordenar pela coluna errada.

A correção sintática não garante a correção lógica.

## 11.5. Legibilidade

Consultas profissionais precisam ser compreensíveis.

Boas práticas:

- Uma cláusula principal por bloco.
- Indentação consistente.
- Condições separadas por linha.
- Parênteses quando melhorarem a compreensão.
- Alias descritivos quando necessários.
- Seleção explícita das colunas.
- Evitar complexidade desnecessária.

Legibilidade também facilita manutenção e diagnóstico.

---

# Tema 12 — Diagnóstico e desempenho básico

## 12.1. Correção e desempenho são coisas diferentes

Uma consulta pode estar logicamente correta e apresentar desempenho ruim.

Também pode executar rapidamente e retornar informações incorretas.

Essas duas dimensões precisam ser avaliadas separadamente.

### Correção lógica

Verifica se a consulta retorna exatamente os registros esperados.

### Desempenho

Verifica o custo e o tempo necessários para produzir o resultado.

Uma consulta profissional deve atender às duas necessidades.

## 12.2. EXPLAIN

EXPLAIN apresenta o plano de execução estimado pelo PostgreSQL.

Ele permite investigar como o banco pretende executar uma consulta.

Exemplo:

```sql
EXPLAIN
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco > 100;
```

O resultado pode apresentar operações como:

- Seq Scan.
- Index Scan.
- Bitmap Index Scan.
- Sort.
- Limit.

O plano representa uma estimativa baseada nas estatísticas e nas informações disponíveis ao planejador.

EXPLAIN, sem ANALYZE, não executa normalmente a consulta para medir seu tempo real de execução.

## 12.3. EXPLAIN ANALYZE

EXPLAIN ANALYZE executa a consulta e apresenta informações reais da execução.

Exemplo:

```sql
EXPLAIN ANALYZE
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco > 100;
```

Entre as informações apresentadas estão:

- Planning Time.
- Execution Time.
- Actual Rows.
- Actual Loops.
- Operações utilizadas.

É importante lembrar que EXPLAIN ANALYZE realmente executa a consulta.

Neste módulo, utilize-o somente em consultas SELECT controladas.

Em instruções que modificam dados, EXPLAIN ANALYZE pode efetivamente executar a operação. Portanto, nunca deve ser utilizado indiscriminadamente em comandos de escrita.

## 12.4. Tipos de operações

### Sequential Scan

O PostgreSQL examina sequencialmente os registros da tabela.

Não significa necessariamente que a consulta está mal otimizada.

Pode ser a melhor estratégia quando uma parcela grande da tabela precisa ser examinada.

### Index Scan

O PostgreSQL utiliza um índice para localizar registros.

Pode ser vantajoso quando o filtro permite localizar uma parcela menor dos dados.

### Bitmap Index Scan

O PostgreSQL utiliza uma estrutura bitmap para identificar registros por meio de índices.

Pode ser útil em determinados cenários de filtragem.

### Sort

Representa uma operação de ordenação.

Pode exigir memória e, dependendo do volume de dados e das configurações, utilizar arquivos temporários.

### Limit

Representa a limitação da quantidade de registros retornados.

Não significa necessariamente que o banco examinou somente essa quantidade de linhas.

## 12.5. Métricas importantes

| Métrica | Significado |
|---|---|
| Planning Time | Tempo utilizado para planejar a consulta |
| Execution Time | Tempo de execução medido |
| Actual Rows | Quantidade real de linhas processadas ou retornadas pelo nó |
| Plan Rows | Quantidade estimada de linhas |
| Actual Loops | Quantidade de execuções do nó |
| Shared Hit Blocks | Blocos encontrados no cache compartilhado |
| Shared Read Blocks | Blocos lidos para o cache compartilhado |
| Node Type | Tipo de operação executada |

É importante interpretar essas métricas em conjunto.

Por exemplo, um nó pode apresentar poucas linhas retornadas, mas ter examinado muitos registros para encontrá-las.

## 12.6. Estimativas e resultados reais

O planejador utiliza estatísticas para estimar a quantidade de registros que cada operação produzirá.

Quando a estimativa fica muito distante do resultado real, a escolha do plano pode ser prejudicada.

A comparação entre Plan Rows e Actual Rows será uma das competências desenvolvidas nos módulos de desempenho.

## 12.7. Cache e repetição de consultas

O tempo de execução pode variar entre execuções.

Entre os fatores estão:

- Cache do PostgreSQL.
- Cache do sistema operacional.
- Estado do armazenamento.
- Concorrência.
- Quantidade de dados processados.
- Planejamento da consulta.

Uma consulta executada repetidamente pode apresentar tempos diferentes.

Por isso, uma única medição não deve ser tratada como verdade absoluta.

## 12.8. Protocolo inicial de análise

Neste módulo, a análise de desempenho será introdutória.

O procedimento recomendado é:

1. Confirmar que a consulta está logicamente correta.
2. Executar uma consulta de referência.
3. Observar o tempo de execução.
4. Examinar o plano com EXPLAIN.
5. Utilizar EXPLAIN ANALYZE em consultas SELECT controladas.
6. Identificar a operação predominante.
7. Formular uma hipótese sobre o comportamento.
8. Comparar alternativas quando houver uma razão técnica.

O estudo aprofundado de planos, índices e otimização será realizado nos módulos posteriores.

## 12.9. Cuidados com tabelas grandes da TechStore

O banco possui tabelas com milhões de registros, especialmente:

- logs_sistema.
- acessos.
- itens_pedido.
- movimentacoes_estoque.
- pedidos.

Essas tabelas serão úteis para compreender o comportamento de consultas em volumes maiores.

Entretanto:

- Evite executar contagens completas repetidamente.
- Utilize filtros adequados.
- Não presuma que LIMIT impede leituras extensas.
- Não execute várias consultas pesadas simultaneamente sem necessidade.
- Não altere índices ou configurações do banco durante este módulo.

---

# 13. Erros comuns e como raciocinar sobre eles

| Problema | Possível causa |
|---|---|
| Coluna inexistente | Nome incorreto ou tabela errada |
| Tabela inexistente | Schema ou nome incorreto |
| Resultado vazio | Filtro muito restritivo ou dados diferentes do esperado |
| Muitos resultados | Condição incompleta |
| Duplicidades | Dados repetidos ou lógica da consulta |
| Ordenação inesperada | Ausência de ORDER BY ou critérios insuficientes |
| NULL não aparece | Comparação inadequada |
| Paginação inconsistente | Ordenação não determinística |
| Consulta lenta | Volume de dados, filtros, ordenação ou plano de execução |

A primeira reação diante de um erro não deve ser modificar a consulta aleatoriamente.

É importante identificar a causa e testar uma hipótese por vez.

---

# 14. Glossário

| Termo | Definição |
|---|---|
| SELECT | Instrução para recuperar dados |
| FROM | Define a origem dos dados |
| WHERE | Filtra registros |
| DISTINCT | Elimina duplicidades do resultado |
| Alias | Nome alternativo utilizado na consulta |
| Predicate | Expressão utilizada para avaliar uma condição |
| AND | Combina condições que precisam ser verdadeiras |
| OR | Combina condições em que pelo menos uma deve ser verdadeira |
| NOT | Inverte o resultado lógico |
| IN | Verifica pertencimento a um conjunto |
| BETWEEN | Verifica pertencimento a um intervalo inclusivo |
| LIKE | Pesquisa por padrões textuais |
| ILIKE | Pesquisa textual sem diferenciar maiúsculas e minúsculas no PostgreSQL |
| NULL | Ausência de valor conhecido |
| ORDER BY | Ordena os resultados |
| LIMIT | Limita a quantidade de linhas retornadas |
| OFFSET | Ignora linhas antes do resultado |
| EXPLAIN | Apresenta o plano estimado |
| EXPLAIN ANALYZE | Executa e apresenta informações reais da execução |
| Selectividade | Proporção de registros que satisfazem uma condição |
| Result Set | Conjunto de resultados de uma consulta |

---

# 15. Competências ao concluir a teoria

Antes de iniciar as atividades, o estudante deverá compreender:

- A estrutura de uma consulta SELECT.
- A diferença entre selecionar todas as colunas e selecionar colunas específicas.
- O funcionamento do DISTINCT.
- A finalidade do WHERE.
- Os operadores de comparação.
- A lógica de AND, OR e NOT.
- A utilização de IN e BETWEEN.
- A pesquisa textual com LIKE e ILIKE.
- O tratamento correto de NULL.
- A ordenação de resultados.
- A limitação e paginação de registros.
- A combinação de diferentes cláusulas.
- Os conceitos iniciais de plano de execução.

A leitura da teoria não significa domínio automático do conteúdo.

O domínio será demonstrado por meio das atividades, dos testes de validação e da avaliação prática.

---

# 16. Referências oficiais

Documentação correspondente ao PostgreSQL 16.

- SELECT: https://www.postgresql.org/docs/16/sql-select.html
- Expressões e operadores: https://www.postgresql.org/docs/16/functions.html
- Operadores de comparação: https://www.postgresql.org/docs/16/functions-comparison.html
- Operadores de correspondência de padrões: https://www.postgresql.org/docs/16/functions-matching.html
- Ordenação de linhas: https://www.postgresql.org/docs/16/queries-order.html
- LIMIT e OFFSET: https://www.postgresql.org/docs/16/queries-limit.html
- EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html
- Planos de execução: https://www.postgresql.org/docs/16/using-explain.html

---

**Fim da teoria — Módulo 02: SELECT e filtros.**