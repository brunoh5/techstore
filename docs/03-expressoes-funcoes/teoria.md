# Módulo 03 — Expressões e Funções SQL

**Banco de dados:** TechStore  
**SGBD:** PostgreSQL 16  
**Schema:** `techstore`  
**Nível:** Profissional  
**Metodologia:** Mastery Learning

---

# 1. Introdução

No módulo anterior, aprendemos a recuperar informações utilizando `SELECT`, filtrar registros com `WHERE`, ordenar resultados e limitar a quantidade de registros retornados.

Neste módulo, avançaremos para uma nova capacidade: transformar os dados durante a execução das consultas.

O banco de dados não precisa apenas devolver os valores armazenados. Ele também pode:

- Realizar cálculos.
- Manipular textos.
- Calcular diferenças entre datas.
- Converter tipos de dados.
- Tratar valores ausentes.
- Classificar registros dinamicamente.
- Formatar informações.
- Construir resultados derivados de outros valores.

Essas operações são realizadas por meio de expressões, operadores e funções SQL.

## 1.1 O que é uma expressão SQL?

Uma expressão SQL é uma combinação de valores, colunas, operadores, funções e constantes que produz um resultado.

Exemplo conceitual:

```sql
preco * quantidade
```

Essa expressão recebe dois valores e produz um resultado numérico.

Outro exemplo:

```sql
UPPER(nome)
```

Recebe um texto e produz uma versão em letras maiúsculas.

Uma expressão pode ser utilizada em diferentes partes de uma consulta, incluindo:

- `SELECT`
- `WHERE`
- `ORDER BY`
- `GROUP BY`
- `HAVING`
- `JOIN`

O uso em `GROUP BY`, `HAVING` e `JOIN` será aprofundado nos módulos correspondentes.

## 1.2 Diferença entre coluna armazenada e valor calculado

Considere a tabela `produtos`.

Ela possui as colunas:

- `preco`
- `custo`

Podemos calcular a diferença entre esses valores sem criar uma nova coluna na tabela.

```sql
SELECT
    nome,
    preco,
    custo,
    preco - custo AS diferenca
FROM techstore.produtos;
```

A coluna `diferenca` é calculada durante a consulta.

Ela não é armazenada automaticamente no banco.

Esse conceito é importante: uma consulta pode produzir informações que não existem fisicamente como colunas.

---

# 2. Expressões SQL

## 2.1 Expressões aritméticas

São expressões que realizam operações matemáticas.

| Operador | Operação |
|---|---|
| `+` | Adição |
| `-` | Subtração |
| `*` | Multiplicação |
| `/` | Divisão |
| `%` | Resto da divisão |
| `^` | Potenciação |

Exemplo:

```sql
SELECT
    nome,
    preco,
    custo,
    preco - custo AS lucro_bruto,
    preco * 1.10 AS preco_com_acrescimo
FROM techstore.produtos;
```

Observe que o PostgreSQL executa os cálculos para cada registro retornado.

### Divisão numérica

É importante conhecer o comportamento dos tipos numéricos.

Uma divisão entre inteiros pode produzir um resultado inteiro, descartando a parte fracionária.

Exemplo conceitual:

```sql
SELECT 10 / 3;
```

Resultado:

```text
3
```

Para obter uma divisão decimal, pelo menos um dos operandos deve utilizar um tipo numérico apropriado.

```sql
SELECT 10.0 / 3;
```

Resultado aproximado:

```text
3.3333333333333333
```

### Divisão por zero

Uma divisão por zero gera erro no PostgreSQL.

Quando o denominador puder ser zero, é necessário considerar essa possibilidade.

Uma estratégia possível é utilizar `NULLIF`, que será estudado posteriormente.

## 2.2 Precedência dos operadores

O PostgreSQL respeita regras de precedência para determinar a ordem de execução das operações.

Exemplo:

```sql
SELECT 10 + 5 * 2;
```

O resultado é `20`, porque a multiplicação acontece antes da adição.

Com parênteses:

```sql
SELECT (10 + 5) * 2;
```

O resultado é `30`.

**Boa prática:** utilize parênteses quando a intenção da expressão puder gerar dúvidas.

Isso melhora a legibilidade e reduz erros de interpretação.

## 2.3 Expressões de comparação e lógicas

Também podemos construir expressões que retornam valores booleanos.

Exemplo:

```sql
SELECT
    nome,
    preco,
    preco > 1000 AS preco_acima_de_1000
FROM techstore.produtos;
```

O resultado da expressão será `TRUE` ou `FALSE`.

Entretanto, quando existe `NULL` envolvido, também podemos obter `UNKNOWN`, seguindo a lógica de três valores do SQL.

Esse comportamento foi introduzido no módulo anterior e continuará sendo importante neste módulo.

---

# 3. Funções de texto

Funções de texto permitem manipular, transformar, pesquisar e formatar informações armazenadas em colunas textuais.

Na TechStore, elas podem ser utilizadas em:

- Nomes de clientes.
- E-mails.
- Nomes de produtos.
- Categorias.
- Mensagens de logs.
- Identificadores textuais.

## 3.1 UPPER

Converte um texto para letras maiúsculas.

```sql
SELECT
    nome,
    UPPER(nome) AS nome_maiusculo
FROM techstore.clientes
LIMIT 10;
```

Exemplo:

```text
Cliente 100
CLIENTE 100
```

## 3.2 LOWER

Converte um texto para letras minúsculas.

```sql
SELECT
    email,
    LOWER(email) AS email_normalizado
FROM techstore.clientes
LIMIT 10;
```

É útil para padronizar comparações e apresentações textuais.

## 3.3 INITCAP

Converte o primeiro caractere de cada palavra para maiúsculo e os demais para minúsculo, conforme as regras de capitalização do PostgreSQL.

```sql
SELECT
    INITCAP(nome)
FROM techstore.categorias;
```

Não deve ser tratado como uma solução universal para formatação de nomes próprios, pois existem regras linguísticas e nomes compostos que podem exigir tratamentos específicos.

## 3.4 LENGTH

Retorna a quantidade de caracteres de uma string.

```sql
SELECT
    nome,
    LENGTH(nome) AS quantidade_caracteres
FROM techstore.produtos
LIMIT 10;
```

No PostgreSQL, `LENGTH` retorna a quantidade de caracteres, não a quantidade de bytes.

Para analisar bytes, existe `OCTET_LENGTH`.

## 3.5 TRIM, LTRIM e RTRIM

Removem caracteres das extremidades de uma string.

| Função | Comportamento |
|---|---|
| `TRIM` | Remove dos dois lados |
| `LTRIM` | Remove do lado esquerdo |
| `RTRIM` | Remove do lado direito |

Exemplo:

```sql
SELECT
    TRIM('   TechStore   ') AS texto_tratado;
```

Resultado:

```text
TechStore
```

Essas funções são úteis quando os dados possuem espaços desnecessários.

## 3.6 REPLACE

Substitui ocorrências de um trecho de texto por outro.

Sintaxe:

```sql
REPLACE(texto, trecho_antigo, trecho_novo)
```

Exemplo:

```sql
SELECT
    REPLACE('Produto Tech 100', 'Tech', 'Store');
```

Resultado:

```text
Produto Store 100
```

## 3.7 SUBSTRING

Extrai uma parte de uma string.

Sintaxe:

```sql
SUBSTRING(texto FROM inicio FOR quantidade)
```

Exemplo:

```sql
SELECT
    SUBSTRING('TECHSTORE' FROM 1 FOR 4);
```

Resultado:

```text
TECH
```

É importante observar que a posição inicial começa em 1.

## 3.8 CONCAT

Combina dois ou mais valores textuais.

```sql
SELECT
    CONCAT(nome, ' - ', email) AS identificacao
FROM techstore.clientes
LIMIT 10;
```

Uma característica importante do PostgreSQL é que `CONCAT` trata argumentos `NULL` como strings vazias.

## 3.9 CONCAT_WS

Combina valores utilizando um separador.

Sintaxe:

```sql
CONCAT_WS(separador, valor1, valor2, ...)
```

Exemplo:

```sql
SELECT
    CONCAT_WS(' | ', nome, email, telefone) AS contato
FROM techstore.clientes
LIMIT 10;
```

Diferentemente de `CONCAT`, `CONCAT_WS` ignora argumentos `NULL` após o separador.

## 3.10 POSITION

Retorna a posição de uma substring dentro de outra string.

```sql
SELECT
    POSITION('@' IN 'cliente@email.test');
```

Resultado:

```text
8
```

Se o trecho não for encontrado, o resultado será zero.

## 3.11 SPLIT_PART

Divide uma string utilizando um delimitador e retorna uma parte específica.

Sintaxe:

```sql
SPLIT_PART(texto, delimitador, posicao)
```

Exemplo:

```sql
SELECT
    SPLIT_PART('cliente@email.test', '@', 1);
```

Resultado:

```text
cliente
```

É útil para extrair partes de identificadores textuais estruturados.

---

# 4. Funções numéricas

Funções numéricas permitem realizar cálculos e transformar valores numéricos.

Na TechStore, são especialmente importantes para:

- Preços.
- Custos.
- Descontos.
- Fretes.
- Salários.
- Quantidades.
- Percentuais.

## 4.1 ABS

Retorna o valor absoluto de um número.

```sql
SELECT ABS(-150);
```

Resultado:

```text
150
```

## 4.2 ROUND

Arredonda um número para uma quantidade determinada de casas decimais.

Sintaxe:

```sql
ROUND(valor, casas_decimais)
```

Exemplo:

```sql
SELECT ROUND(123.4567, 2);
```

Resultado:

```text
123.46
```

É muito utilizado em cálculos financeiros e apresentações de valores.

**Atenção:** arredondamento pode afetar cálculos financeiros quando aplicado em etapas diferentes. É importante definir em qual etapa o arredondamento deve acontecer.

## 4.3 CEIL e CEILING

Retornam o menor inteiro maior ou igual ao valor informado.

```sql
SELECT CEIL(10.2);
```

Resultado:

```text
11
```

`CEILING` é um nome alternativo para `CEIL`.

## 4.4 FLOOR

Retorna o maior inteiro menor ou igual ao valor informado.

```sql
SELECT FLOOR(10.9);
```

Resultado:

```text
10
```

## 4.5 MOD

Retorna o resto de uma divisão.

```sql
SELECT MOD(10, 3);
```

Resultado:

```text
1
```

Também podemos utilizar o operador `%`.

## 4.6 POWER

Calcula a potência de um número.

```sql
SELECT POWER(2, 3);
```

Resultado:

```text
8
```

## 4.7 SQRT

Retorna a raiz quadrada de um número.

```sql
SELECT SQRT(81);
```

Resultado:

```text
9
```

---

# 5. Funções de data e hora

O PostgreSQL possui um conjunto amplo de funções para manipular datas, horários e intervalos.

Na TechStore, podemos utilizar essas funções em:

- Data de cadastro dos clientes.
- Data de admissão dos funcionários.
- Data dos pedidos.
- Data dos pagamentos.
- Data de envio e entrega.
- Data de movimentações do estoque.
- Data de avaliações.

## 5.1 CURRENT_DATE

Retorna a data atual da sessão do PostgreSQL.

```sql
SELECT CURRENT_DATE;
```

O resultado é do tipo `DATE`.

## 5.2 CURRENT_TIME

Retorna o horário atual da sessão.

```sql
SELECT CURRENT_TIME;
```

O resultado inclui o fuso horário.

## 5.3 CURRENT_TIMESTAMP

Retorna a data e hora atuais da transação.

```sql
SELECT CURRENT_TIMESTAMP;
```

O resultado é do tipo `TIMESTAMP WITH TIME ZONE`.

No PostgreSQL, `CURRENT_TIMESTAMP` representa o início da transação, não necessariamente o instante exato de cada chamada.

## 5.4 EXTRACT

Extrai uma parte específica de uma data ou horário.

Sintaxe:

```sql
EXTRACT(campo FROM origem)
```

Exemplos:

```sql
SELECT
    EXTRACT(YEAR FROM CURRENT_DATE) AS ano,
    EXTRACT(MONTH FROM CURRENT_DATE) AS mes,
    EXTRACT(DAY FROM CURRENT_DATE) AS dia;
```

Outros campos possíveis incluem:

- `YEAR`
- `MONTH`
- `DAY`
- `HOUR`
- `MINUTE`
- `SECOND`
- `DOW`
- `DOY`
- `QUARTER`

`DOW` representa o dia da semana, sendo domingo igual a zero.

## 5.5 DATE_PART

Possui finalidade semelhante à função `EXTRACT`.

```sql
SELECT
    DATE_PART('year', CURRENT_DATE);
```

Ambas permitem extrair partes de datas, mas possuem diferenças de sintaxe e retorno que devem ser consideradas.

## 5.6 DATE_TRUNC

Reduz uma data ou timestamp para uma determinada unidade temporal.

Exemplo:

```sql
SELECT
    DATE_TRUNC('month', CURRENT_TIMESTAMP);
```

O resultado representa o início do mês atual.

Unidades comuns:

- `year`
- `quarter`
- `month`
- `week`
- `day`
- `hour`
- `minute`
- `second`

É útil quando precisamos trabalhar com períodos completos.

## 5.7 AGE

Calcula a diferença entre datas ou timestamps, retornando um intervalo com componentes temporais.

```sql
SELECT
    AGE(CURRENT_DATE, DATE '2000-01-01');
```

Também podemos calcular o tempo desde o cadastro de um cliente:

```sql
SELECT
    nome,
    data_cadastro,
    AGE(CURRENT_DATE, data_cadastro) AS tempo_cadastrado
FROM techstore.clientes
LIMIT 10;
```

O resultado é um intervalo, não simplesmente uma quantidade fixa de dias.

## 5.8 Intervalos

O PostgreSQL possui o tipo `INTERVAL`, que representa períodos de tempo.

Exemplos:

```sql
SELECT INTERVAL '7 days';
```

```sql
SELECT INTERVAL '2 months';
```

```sql
SELECT INTERVAL '1 year 3 months';
```

Também podemos somar intervalos a datas:

```sql
SELECT
    CURRENT_DATE + INTERVAL '7 days';
```

E subtrair datas:

```sql
SELECT
    DATE '2026-12-15' - DATE '2026-12-01';
```

A subtração de dois valores `DATE` retorna a quantidade de dias entre eles.

## 5.9 Aritmética de datas

Operações possíveis incluem:

| Operação | Resultado |
|---|---|
| DATE + INTEGER | DATE |
| DATE - INTEGER | DATE |
| DATE - DATE | INTEGER |
| TIMESTAMP + INTERVAL | TIMESTAMP |
| TIMESTAMP - INTERVAL | TIMESTAMP |
| TIMESTAMP - TIMESTAMP | INTERVAL |

É importante conhecer os tipos envolvidos para evitar conversões inesperadas.

---

# 6. Conversão de tipos

Conversão de tipos é a transformação de um valor de um tipo de dado para outro.

No PostgreSQL, esse processo pode ocorrer de maneira explícita ou implícita.

## 6.1 CAST

Permite converter explicitamente um valor.

Sintaxe:

```sql
CAST(valor AS tipo)
```

Exemplo:

```sql
SELECT CAST('150' AS INTEGER);
```

Resultado:

```text
150
```

Outro exemplo:

```sql
SELECT CAST('2026-11-15' AS DATE);
```

## 6.2 Operador ::

O PostgreSQL oferece uma sintaxe própria para conversões.

```sql
SELECT '150'::INTEGER;
```

O resultado é equivalente ao exemplo com `CAST`.

Outra possibilidade:

```sql
SELECT '2026-11-15'::DATE;
```

As duas formas são válidas.

`CAST` segue a sintaxe padrão SQL, enquanto `::` é uma extensão característica do PostgreSQL.

## 6.3 Conversões implícitas

O PostgreSQL pode converter automaticamente alguns tipos quando a operação permite.

Entretanto, não devemos depender indiscriminadamente dessas conversões.

Elas podem:

- Produzir resultados inesperados.
- Gerar ambiguidades.
- Impedir a utilização de determinados índices.
- Causar erros quando os valores não forem compatíveis.

## 6.4 Conversões inválidas

Nem todo valor pode ser convertido para qualquer tipo.

Exemplo:

```sql
SELECT 'ABC'::INTEGER;
```

Essa operação gera erro porque o conteúdo não representa um número inteiro válido.

**Boa prática:** conheça a origem dos dados e os tipos envolvidos antes de realizar conversões.

---

# 7. Tratamento de NULL

`NULL` representa ausência de valor conhecido.

Não deve ser confundido com:

- Zero.
- String vazia.
- `FALSE`.
- Espaço em branco.

O PostgreSQL possui funções específicas para tratar esse cenário.

## 7.1 COALESCE

Retorna o primeiro argumento que não seja `NULL`.

Sintaxe:

```sql
COALESCE(valor1, valor2, valor3, ...)
```

Exemplo:

```sql
SELECT
    nome,
    COALESCE(telefone, 'Telefone não informado') AS telefone
FROM techstore.clientes
LIMIT 20;
```

Se `telefone` possuir um valor, ele será retornado.

Caso seja `NULL`, será retornado o texto alternativo.

É uma função muito importante para construção de resultados consistentes.

## 7.2 NULLIF

Compara dois valores.

Se forem iguais, retorna `NULL`. Caso contrário, retorna o primeiro valor.

Sintaxe:

```sql
NULLIF(valor1, valor2)
```

Exemplo:

```sql
SELECT NULLIF(10, 10);
```

Resultado:

```text
NULL
```

Outro exemplo:

```sql
SELECT NULLIF(10, 5);
```

Resultado:

```text
10
```

### Aplicação em divisões

Podemos utilizar `NULLIF` para evitar divisão por zero.

```sql
SELECT
    100.0 / NULLIF(quantidade, 0)
FROM techstore.estoque;
```

Quando `quantidade` for zero, o denominador será `NULL` e o resultado da divisão também será `NULL`, em vez de gerar erro de divisão por zero.

## 7.3 COALESCE e NULLIF juntos

As duas funções podem ser combinadas.

Exemplo:

```sql
SELECT
    COALESCE(NULLIF('', ''), 'Sem informação');
```

Resultado:

```text
Sem informação
```

Esse exemplo demonstra como podemos construir tratamentos mais elaborados.

## 7.4 NULL em expressões

Uma expressão aritmética que envolve `NULL` geralmente resulta em `NULL`.

Exemplo:

```sql
SELECT 100 + NULL;
```

Resultado:

```text
NULL
```

Isso é importante porque uma operação pode não produzir o resultado esperado quando algum dos seus operandos estiver ausente.

---

# 8. Expressões condicionais — CASE

`CASE` permite construir decisões dentro de uma consulta SQL.

É semelhante a uma estrutura condicional encontrada em linguagens de programação.

## 8.1 Estrutura básica

```sql
CASE
    WHEN condicao THEN resultado
    ELSE resultado_padrao
END
```

O PostgreSQL avalia as condições na ordem apresentada.

A primeira condição verdadeira determina o resultado.

## 8.2 CASE pesquisado

Avalia condições booleanas.

Exemplo:

```sql
SELECT
    nome,
    preco,
    CASE
        WHEN preco >= 3000 THEN 'Premium'
        WHEN preco >= 1000 THEN 'Intermediario'
        ELSE 'Economico'
    END AS faixa_preco
FROM techstore.produtos;
```

Observe que a ordem das condições importa.

Se colocarmos uma condição muito abrangente antes de outra mais específica, alguns resultados poderão nunca alcançar a segunda condição.

## 8.3 CASE simples

Compara uma expressão com diferentes valores.

Exemplo:

```sql
SELECT
    id,
    status,
    CASE status
        WHEN 'entregue' THEN 'Finalizado'
        WHEN 'cancelado' THEN 'Cancelado'
        WHEN 'processando' THEN 'Em andamento'
        ELSE 'Outro status'
    END AS situacao
FROM techstore.pedidos;
```

## 8.4 CASE sem ELSE

Quando nenhuma condição é verdadeira e não existe `ELSE`, o resultado será `NULL`.

É importante considerar isso ao construir classificações.

## 8.5 CASE e tipos de dados

Os resultados dos diferentes caminhos do `CASE` precisam ser compatíveis.

Exemplo inadequado conceitualmente:

```sql
CASE
    WHEN preco > 1000 THEN 100
    ELSE 'Baixo'
END
```

O PostgreSQL precisa determinar um tipo de retorno compatível para a expressão.

Misturar tipos incompatíveis pode gerar erro.

## 8.6 CASE em diferentes partes da consulta

`CASE` pode ser utilizado em:

- `SELECT`, para criar classificações.
- `ORDER BY`, para criar ordenações personalizadas.
- `WHERE`, para construir condições.
- Expressões aritméticas, para cálculos condicionais.

Exemplo de ordenação personalizada:

```sql
SELECT
    id,
    status,
    data_pedido
FROM techstore.pedidos
ORDER BY
    CASE status
        WHEN 'processando' THEN 1
        WHEN 'em transporte' THEN 2
        WHEN 'entregue' THEN 3
        WHEN 'cancelado' THEN 4
        ELSE 5
    END;
```

---

# 9. Funções específicas do PostgreSQL

Além das funções mais comuns, o PostgreSQL disponibiliza funções próprias e recursos adicionais.

## 9.1 GREATEST

Retorna o maior valor de uma lista de expressões.

```sql
SELECT GREATEST(10, 20, 5, 30);
```

Resultado:

```text
30
```

## 9.2 LEAST

Retorna o menor valor de uma lista.

```sql
SELECT LEAST(10, 20, 5, 30);
```

Resultado:

```text
5
```

No PostgreSQL, `GREATEST` e `LEAST` ignoram argumentos `NULL` quando existe pelo menos um argumento não nulo. Se todos forem `NULL`, o resultado será `NULL`.

Esse comportamento é importante porque não é idêntico ao comportamento de todas as funções de outros SGBDs.

## 9.3 TO_CHAR

Formata números e datas como texto.

Exemplo com número:

```sql
SELECT
    TO_CHAR(12345.67, 'FM999G999D00');
```

A apresentação depende das configurações regionais da sessão.

Exemplo com data:

```sql
SELECT
    TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY');
```

Resultado ilustrativo:

```text
15/11/2026
```

Alguns padrões de formatação:

| Máscara | Significado |
|---|---|
| `DD` | Dia |
| `MM` | Mês |
| `YYYY` | Ano com quatro dígitos |
| `HH24` | Hora de 00 a 23 |
| `MI` | Minutos |
| `SS` | Segundos |

## 9.4 TO_DATE

Converte uma string para um valor `DATE` utilizando uma máscara de formato.

```sql
SELECT
    TO_DATE('15/11/2026', 'DD/MM/YYYY');
```

## 9.5 TO_TIMESTAMP

Converte uma string para `TIMESTAMP WITH TIME ZONE` utilizando uma máscara.

```sql
SELECT
    TO_TIMESTAMP(
        '15/11/2026 14:30:00',
        'DD/MM/YYYY HH24:MI:SS'
    );
```

É importante diferenciar a conversão de texto para data da simples formatação de uma data já existente.

## 9.6 FORMAT

Permite construir strings formatadas.

```sql
SELECT
    FORMAT(
        'Produto: %s | Preco: %s',
        nome,
        preco
    )
FROM techstore.produtos
LIMIT 10;
```

A função aceita especificadores de formatação, como:

- `%s`: representação textual.
- `%I`: identificador SQL.
- `%L`: literal SQL.

Os especificadores `%I` e `%L` são especialmente importantes em contextos de SQL dinâmico.

Não substituem o uso adequado de parâmetros em aplicações.

---

# 10. Funções compostas e aninhadas

Uma função pode receber como argumento o resultado de outra função.

Isso permite construir expressões mais complexas.

Exemplo:

```sql
SELECT
    UPPER(TRIM(nome)) AS nome_padronizado
FROM techstore.clientes
LIMIT 10;
```

O PostgreSQL executa conceitualmente:

1. `TRIM` remove espaços nas extremidades.
2. `UPPER` transforma o resultado em maiúsculas.
3. O resultado recebe o alias `nome_padronizado`.

Outro exemplo:

```sql
SELECT
    nome,
    ROUND(preco - custo, 2) AS margem_bruta
FROM techstore.produtos;
```

Também podemos combinar funções de datas:

```sql
SELECT
    nome,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento))
        AS idade_aproximada
FROM techstore.clientes
WHERE data_nascimento IS NOT NULL
LIMIT 20;
```

O resultado é uma idade aproximada em anos completos, sujeita à semântica do intervalo retornado por `AGE`.

## 10.1 Legibilidade

Funções aninhadas podem deixar consultas difíceis de compreender.

Compare:

```sql
UPPER(TRIM(nome))
```

com uma expressão que possui várias camadas de conversão, formatação e tratamento de valores.

Quando a expressão ficar complexa, utilize:

- Quebras de linha.
- Indentação.
- Aliases descritivos.
- Parênteses.
- CTEs, que serão estudadas posteriormente.

O objetivo não é apenas fazer a consulta funcionar, mas permitir que outra pessoa compreenda sua intenção.

---

# 11. Expressões e desempenho

Uma consulta correta não é necessariamente uma consulta eficiente.

Expressões e funções podem influenciar a maneira como o PostgreSQL executa uma consulta.

## 11.1 Funções aplicadas sobre colunas

Considere:

```sql
SELECT
    id,
    email
FROM techstore.clientes
WHERE LOWER(email) = 'cliente100@email.test';
```

A função `LOWER` é aplicada sobre a coluna.

Se existir um índice convencional sobre `email`, o PostgreSQL pode não conseguir utilizá-lo diretamente para atender a essa expressão.

Isso depende do plano de execução e das características da consulta.

## 11.2 Comparação de abordagens

Uma alternativa pode ser:

```sql
SELECT
    id,
    email
FROM techstore.clientes
WHERE email = 'cliente100@email.test';
```

Essa abordagem não aplica uma função sobre a coluna.

Entretanto, as duas consultas não são necessariamente equivalentes em termos de comportamento, especialmente quando existem diferenças de capitalização.

Não devemos trocar uma consulta por outra apenas por desempenho sem preservar a regra de negócio.

## 11.3 Índices de expressão

O PostgreSQL permite criar índices baseados em expressões.

Exemplo conceitual:

```sql
CREATE INDEX idx_clientes_email_lower
ON techstore.clientes (LOWER(email));
```

Esse índice pode auxiliar consultas que utilizem a mesma expressão.

**Atenção:** esse exemplo é apenas explicativo. Não execute comandos de criação de índices neste módulo.

O estudo de índices será aprofundado no Módulo 12.

## 11.4 EXPLAIN

Para analisar o comportamento de uma consulta, podemos utilizar:

```sql
EXPLAIN
SELECT
    id,
    nome
FROM techstore.clientes
WHERE LOWER(email) = 'cliente100@email.test';
```

Para observar a execução real:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    nome
FROM techstore.clientes
WHERE LOWER(email) = 'cliente100@email.test';
```

Observe:

- Tipo de operação.
- Tempo de execução.
- Linhas estimadas.
- Linhas reais.
- Blocos encontrados em cache.
- Blocos lidos.

O estudo aprofundado de planos e otimização será realizado nos módulos 13 e 14.

## 11.5 Cuidado com funções não determinísticas

Nem todas as funções retornam o mesmo resultado para os mesmos argumentos em momentos diferentes.

Exemplo:

```sql
SELECT CURRENT_TIMESTAMP;
```

O resultado depende do momento da transação.

No PostgreSQL, funções possuem classificações de volatilidade:

| Classificação | Comportamento geral |
|---|---|
| IMMUTABLE | Mesmo resultado para os mesmos argumentos |
| STABLE | Resultado estável durante uma instrução SQL |
| VOLATILE | Pode mudar durante uma instrução SQL |

Essa classificação influencia as otimizações permitidas pelo PostgreSQL e as possibilidades de utilização de funções em índices e expressões.

Não confunda estabilidade com ausência de efeitos colaterais: a classificação também está relacionada às garantias que o PostgreSQL pode assumir sobre uma função.

---

# 12. Erros frequentes

## 12.1 Confundir NULL com string vazia

`NULL` representa ausência de valor.

`''` representa um texto existente com zero caracteres.

Esses valores possuem comportamentos diferentes.

## 12.2 Utilizar = NULL

Incorreto:

```sql
WHERE telefone = NULL
```

Correto:

```sql
WHERE telefone IS NULL
```

## 12.3 Dividir por zero

Uma divisão cujo denominador seja zero gera erro.

Considere `NULLIF` quando o zero representar um caso sem resultado definido.

## 12.4 Arredondar em etapas diferentes

Arredondar cada parcela antes de somar pode produzir um resultado diferente de somar primeiro e arredondar no final.

Em operações financeiras, a regra de arredondamento precisa ser definida.

## 12.5 Misturar tipos incompatíveis

Expressões condicionais e funções podem exigir tipos compatíveis.

Conversões explícitas ajudam a tornar a intenção clara.

## 12.6 Aplicar funções desnecessariamente em filtros

Uma função aplicada sobre uma coluna pode alterar a possibilidade de utilização de índices existentes.

Sempre avalie o plano antes de concluir que uma abordagem é melhor.

## 12.7 Confundir formatação com transformação de dados

`TO_CHAR` retorna texto.

Depois de formatar um número ou uma data como texto, o resultado não deve ser tratado automaticamente como o tipo original.

Prefira manter os tipos originais durante cálculos e filtros e formatar os valores apenas quando necessário para apresentação.

---

# 13. Boas práticas profissionais

1. Utilize nomes de aliases claros e descritivos.
2. Prefira expressões legíveis.
3. Conheça o tipo de retorno das funções.
4. Trate valores `NULL` explicitamente quando necessário.
5. Considere divisão por zero em cálculos.
6. Evite conversões desnecessárias.
7. Preserve a precisão numérica em operações financeiras.
8. Diferencie valores armazenados de valores calculados.
9. Analise o impacto de funções aplicadas sobre colunas.
10. Utilize `EXPLAIN` para investigar desempenho.
11. Não formate valores prematuramente como texto.
12. Considere os limites e casos extremos das funções utilizadas.

---

# 14. Referência rápida de funções

| Categoria | Função | Finalidade |
|---|---|---|
| Texto | UPPER | Maiúsculas |
| Texto | LOWER | Minúsculas |
| Texto | INITCAP | Capitalização de palavras |
| Texto | LENGTH | Quantidade de caracteres |
| Texto | TRIM | Remover espaços/caracteres das extremidades |
| Texto | REPLACE | Substituir trechos |
| Texto | SUBSTRING | Extrair parte do texto |
| Texto | CONCAT | Concatenar valores |
| Texto | CONCAT_WS | Concatenar com separador |
| Texto | POSITION | Localizar trecho |
| Texto | SPLIT_PART | Separar texto por delimitador |
| Numérica | ABS | Valor absoluto |
| Numérica | ROUND | Arredondar |
| Numérica | CEIL | Arredondar para cima |
| Numérica | FLOOR | Arredondar para baixo |
| Numérica | MOD | Resto da divisão |
| Numérica | POWER | Potenciação |
| Numérica | SQRT | Raiz quadrada |
| Data/hora | CURRENT_DATE | Data atual |
| Data/hora | CURRENT_TIME | Horário atual |
| Data/hora | CURRENT_TIMESTAMP | Data e hora atuais |
| Data/hora | EXTRACT | Extrair componente temporal |
| Data/hora | DATE_PART | Extrair componente temporal |
| Data/hora | DATE_TRUNC | Truncar período |
| Data/hora | AGE | Diferença entre datas |
| Conversão | CAST | Converter tipo |
| Conversão | :: | Converter tipo |
| NULL | COALESCE | Primeiro valor não nulo |
| NULL | NULLIF | Retornar NULL se os valores forem iguais |
| Condicional | CASE | Avaliar condições |
| PostgreSQL | GREATEST | Maior valor |
| PostgreSQL | LEAST | Menor valor |
| PostgreSQL | TO_CHAR | Formatar como texto |
| PostgreSQL | TO_DATE | Converter para DATE |
| PostgreSQL | TO_TIMESTAMP | Converter para TIMESTAMP WITH TIME ZONE |
| PostgreSQL | FORMAT | Construir texto formatado |

---

# 15. Referências oficiais

Documentação PostgreSQL 16:

- Funções e operadores: https://www.postgresql.org/docs/16/functions.html
- Funções de string: https://www.postgresql.org/docs/16/functions-string.html
- Funções matemáticas: https://www.postgresql.org/docs/16/functions-math.html
- Funções de data e hora: https://www.postgresql.org/docs/16/functions-datetime.html
- Conversões de tipos: https://www.postgresql.org/docs/16/typeconv.html
- Expressões condicionais: https://www.postgresql.org/docs/16/functions-conditional.html
- Tipos de dados: https://www.postgresql.org/docs/16/datatype.html
- Volatilidade de funções: https://www.postgresql.org/docs/16/xfunc-volatility.html
- EXPLAIN: https://www.postgresql.org/docs/16/using-explain.html

---

# 16. Resultado esperado

Ao concluir o estudo deste documento, o estudante deverá compreender como expressões e funções transformam os dados durante uma consulta.

Deverá conseguir:

- Realizar cálculos.
- Manipular strings.
- Trabalhar com datas e horários.
- Converter tipos.
- Tratar valores ausentes.
- Construir classificações condicionais.
- Combinar funções.
- Identificar situações que podem prejudicar o desempenho.

A memorização das funções não representa domínio do conteúdo.

O domínio será demonstrado pela capacidade de escolher a função correta, justificar sua utilização, prever seu resultado, validar casos extremos e construir consultas legíveis e eficientes.

**Próxima etapa:** atividades.md.

**Status:** Teoria preparada. Aulas ainda não iniciadas.