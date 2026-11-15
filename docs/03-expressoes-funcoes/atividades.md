# Módulo 03 — Atividades: Expressões e Funções SQL

**Banco:** TechStore  
**SGBD:** PostgreSQL 16  
**Schema:** `techstore`  
**Nível:** Profissional  
**Pré-requisito:** Módulos 01 e 02

---

# 1. Orientações gerais

Neste módulo, o objetivo não é apenas conseguir executar funções SQL, mas compreender como utilizá-las para resolver problemas.

Para cada atividade:

1. Leia o problema.
2. Identifique as tabelas e colunas necessárias.
3. Identifique as funções e expressões adequadas.
4. Construa sua consulta.
5. Execute no PostgreSQL.
6. Analise o resultado.
7. Verifique se o resultado atende ao problema.
8. Registre dúvidas e dificuldades.

## Regras

- Utilize exclusivamente consultas de leitura (`SELECT`).
- Não altere dados ou estruturas do banco.
- Não execute novamente o seed.
- Não utilize consultas prontas encontradas na teoria como substituição do raciocínio.
- Não avance automaticamente para atividades mais complexas sem compreender as anteriores.
- Quando uma consulta apresentar resultado inesperado, investigue a causa antes de modificá-la.

## Padrão de entrega

Para cada atividade, mantenha:

- Número da atividade.
- Consulta SQL desenvolvida.
- Resultado observado.
- Explicação da lógica utilizada.
- Dificuldades encontradas.
- Validação realizada.

---

# 2. Etapa 01 — Expressões e operações

**Objetivo:** compreender expressões aritméticas, operadores, precedência e valores calculados.

### AT-01 — Diferença entre preço e custo

Na tabela `produtos`, apresente:

- ID do produto.
- Nome.
- Preço.
- Custo.
- Diferença entre preço e custo.

A diferença deverá ser calculada durante a consulta, sem criar ou modificar colunas.

**Desafio adicional:** ordene os resultados pela diferença calculada, do maior para o menor.

### AT-02 — Simulação de acréscimo

A equipe comercial deseja visualizar quanto custariam os produtos caso recebessem um acréscimo de 12% sobre o preço atual.

Apresente:

- Nome do produto.
- Preço atual.
- Valor do acréscimo.
- Preço simulado.

Não altere os preços armazenados.

### AT-03 — Cálculo de margem percentual

Calcule a diferença entre preço e custo como percentual do preço de venda.

Apresente:

- Nome.
- Preço.
- Custo.
- Diferença.
- Percentual calculado.

**Atenção:** considere os tipos numéricos e a possibilidade de divisão por zero, mesmo que as restrições atuais da tabela impeçam determinadas situações.

### AT-04 — Precedência matemática

Construa duas expressões que utilizem os mesmos valores, mas produzam resultados diferentes devido à utilização de parênteses.

Explique:

- Qual operação é executada primeiro em cada caso.
- Por que os resultados são diferentes.
- Como os parênteses modificam a expressão.

Utilize apenas valores numéricos literais nesta atividade.

---

# 3. Etapa 02 — Funções de texto

**Objetivo:** manipular informações textuais e compreender o comportamento das funções de string.

### AT-05 — Padronização de nomes

Na tabela `clientes`, apresente:

- Nome original.
- Nome em letras maiúsculas.
- Nome em letras minúsculas.
- Nome utilizando capitalização de palavras.

Utilize as funções adequadas para cada transformação.

### AT-06 — Análise de nomes de produtos

Na tabela `produtos`, apresente:

- Nome.
- Quantidade de caracteres.
- Primeiros caracteres do nome.
- Resultado de uma substituição textual.

A substituição deverá modificar uma parte do texto sem alterar o conteúdo armazenado.

### AT-07 — Padronização de e-mails

Na tabela `clientes`, desenvolva uma consulta que:

- Apresente o e-mail original.
- Apresente o e-mail em letras minúsculas.
- Identifique a posição do caractere `@`.
- Extraia a parte anterior ao caractere `@`.
- Extraia a parte posterior ao caractere `@`.

Utilize pelo menos três funções de texto diferentes.

### AT-08 — Construção de identificação textual

Crie uma identificação textual para cada cliente utilizando nome, e-mail e telefone.

Requisitos:

- Utilize um separador entre as informações.
- Considere a possibilidade de telefone ausente.
- Evite que valores `NULL` comprometam toda a identificação.
- Apresente o resultado com um alias descritivo.

### AT-09 — Análise de mensagens do sistema

Na tabela `logs_sistema`, apresente:

- ID.
- Nível.
- Módulo.
- Mensagem original.
- Quantidade de caracteres da mensagem.
- Mensagem convertida para letras maiúsculas.

Limite a apresentação a 30 registros.

---

# 4. Etapa 03 — Funções numéricas

**Objetivo:** utilizar funções matemáticas em cálculos comerciais.

### AT-10 — Análise de preços

Na tabela `produtos`, apresente:

- Nome.
- Preço original.
- Preço arredondado para uma casa decimal.
- Preço arredondado para duas casas decimais.
- Valor inteiro obtido pelo arredondamento para cima.
- Valor inteiro obtido pelo arredondamento para baixo.

Utilize as funções numéricas apropriadas.

### AT-11 — Análise de estoque

Na tabela `estoque`, desenvolva uma consulta que apresente:

- ID do produto.
- Quantidade disponível.
- Estoque mínimo.
- Diferença entre quantidade e estoque mínimo.
- Resto da divisão da quantidade por 2.

O objetivo é compreender operações matemáticas aplicadas a dados de estoque.

### AT-12 — Simulação financeira

Na tabela `produtos`, simule um cenário em que o custo de cada produto receba um acréscimo de 15%.

Apresente:

- Nome.
- Custo original.
- Custo simulado.
- Diferença entre custo original e simulado.
- Valor simulado arredondado para duas casas decimais.

Não modifique os dados originais.

---

# 5. Etapa 04 — Datas e horários

**Objetivo:** extrair informações temporais, calcular intervalos e manipular datas.

### AT-13 — Tempo de cadastro dos clientes

Na tabela `clientes`, apresente:

- Nome.
- Data de cadastro.
- Ano do cadastro.
- Mês do cadastro.
- Dia do cadastro.
- Tempo transcorrido desde o cadastro.

Utilize funções de data e hora.

### AT-14 — Tempo de empresa dos funcionários

Na tabela `funcionarios`, apresente:

- Nome.
- Data de admissão.
- Tempo transcorrido desde a admissão.
- Ano da admissão.
- Mês da admissão.

O resultado deverá permitir identificar há quanto tempo cada funcionário trabalha na empresa.

### AT-15 — Análise temporal dos pedidos

Na tabela `pedidos`, apresente:

- ID.
- Data do pedido.
- Ano.
- Mês.
- Dia.
- Hora.
- Minuto.

Ordene os resultados pela data do pedido, da mais recente para a mais antiga.

### AT-16 — Agrupamento temporal sem agregação

Utilizando `DATE_TRUNC`, apresente a data de cada pedido reduzida ao início do respectivo mês.

A consulta deverá mostrar:

- ID do pedido.
- Data original.
- Mês correspondente.

O objetivo é compreender como timestamps podem ser normalizados para uma unidade temporal.

### AT-17 — Diferença entre datas de entrega

Na tabela `entregas`, apresente:

- ID da entrega.
- Data de envio.
- Data de entrega.
- Quantidade de dias entre envio e entrega.

Considere que algumas entregas podem não possuir data de entrega.

Sua consulta deverá tratar esses casos sem gerar erros.

---

# 6. Etapa 05 — Conversão de tipos

**Objetivo:** compreender conversões explícitas e implícitas.

### AT-18 — Conversões básicas

Construa uma consulta que converta:

- Um texto numérico para inteiro.
- Um texto numérico decimal para `NUMERIC`.
- Um texto no formato de data para `DATE`.
- Um texto no formato de data e horário para timestamp.

Utilize `CAST` em parte das conversões e `::` nas demais.

Explique a diferença entre as duas sintaxes.

### AT-19 — Formatação de datas

Utilize dados da tabela `clientes` para apresentar:

- Nome.
- Data de cadastro original.
- Data de cadastro formatada no padrão dia/mês/ano.
- Ano do cadastro como texto.

Utilize `TO_CHAR`.

### AT-20 — Formatação de valores

Na tabela `produtos`, apresente:

- Nome.
- Preço numérico original.
- Preço formatado como texto com duas casas decimais.

Explique a diferença entre o tipo original e o tipo retornado pela função de formatação.

---

# 7. Etapa 06 — Tratamento de NULL

**Objetivo:** compreender ausência de valores e construir resultados consistentes.

### AT-21 — Clientes sem telefone

Na tabela `clientes`, identifique clientes cujo telefone não esteja preenchido.

Apresente:

- ID.
- Nome.
- Telefone original.
- Telefone com um texto alternativo quando estiver ausente.

Utilize a função apropriada para tratar `NULL`.

### AT-22 — Acessos sem cliente associado

Na tabela `acessos`, existem registros que podem não possuir cliente associado.

Apresente:

- ID do acesso.
- ID do cliente.
- Página.
- Dispositivo.
- Uma identificação textual que diferencie acessos identificados e anônimos.

Utilize uma expressão condicional ou função de tratamento de `NULL`.

### AT-23 — Proteção contra divisão por zero

Construa uma expressão que divida um valor numérico por outro, mas que evite erro quando o denominador for zero.

A consulta deverá demonstrar:

- Um caso com denominador diferente de zero.
- Um caso com denominador igual a zero.
- O comportamento do resultado em cada situação.

Utilize `NULLIF`.

### AT-24 — Combinação de funções de NULL

Construa uma consulta utilizando `NULLIF` e `COALESCE` na mesma expressão.

Demonstre uma situação em que:

1. Um valor seja comparado com outro.
2. O resultado possa se tornar `NULL`.
3. Um valor alternativo seja apresentado.

Explique a ordem de avaliação e o resultado.

---

# 8. Etapa 07 — Expressões condicionais

**Objetivo:** construir classificações e decisões diretamente no PostgreSQL.

### AT-25 — Classificação de produtos

Na tabela `produtos`, classifique os produtos em três faixas de preço:

- Econômico.
- Intermediário.
- Premium.

Defina os limites de preço e apresente:

- ID.
- Nome.
- Preço.
- Classificação.

Utilize `CASE`.

### AT-26 — Classificação de avaliações

Na tabela `avaliacoes`, construa uma classificação para as notas:

- Nota 1: classificação negativa.
- Nota 2: classificação abaixo do esperado.
- Nota 3: classificação regular.
- Nota 4: classificação positiva.
- Nota 5: classificação excelente.

Apresente:

- ID da avaliação.
- Produto.
- Nota.
- Classificação textual.

### AT-27 — Situação dos pedidos

Na tabela `pedidos`, apresente uma classificação textual dos pedidos com base no campo `status`.

A classificação deverá diferenciar:

- Pedidos entregues.
- Pedidos em transporte.
- Pedidos em processamento.
- Pedidos cancelados.
- Outros estados não previstos.

Não modifique o status original.

### AT-28 — Ordenação personalizada

Crie uma consulta de pedidos que apresente os status em uma ordem definida pelo negócio, em vez de uma ordem alfabética.

Utilize uma expressão `CASE` dentro do `ORDER BY`.

Explique como essa estratégia modifica a ordenação.

---

# 9. Etapa 08 — Funções compostas

**Objetivo:** combinar funções e construir expressões mais elaboradas.

### AT-29 — Identificação padronizada de clientes

Construa uma consulta que gere uma identificação textual contendo:

- Nome padronizado.
- E-mail em letras minúsculas.
- Telefone ou texto alternativo.
- Uma separação visual entre as informações.

Utilize pelo menos três funções de texto e uma função de tratamento de `NULL`.

### AT-30 — Análise comercial de produtos

Construa uma consulta que apresente:

- Nome do produto.
- Preço.
- Custo.
- Diferença entre preço e custo.
- Percentual da diferença em relação ao preço.
- Classificação da faixa de preço.
- Valor formatado para apresentação.

A consulta deverá combinar expressões aritméticas, funções numéricas, `CASE` e formatação.

### AT-31 — Análise de tempo dos funcionários

Construa uma consulta que apresente:

- Nome.
- Data de admissão.
- Tempo de empresa.
- Ano de admissão.
- Classificação de tempo de empresa.

Defina três faixas de tempo e justifique os limites utilizados.

### AT-32 — Resumo de pedidos

Na tabela `pedidos`, construa uma consulta que apresente:

- ID.
- Data do pedido.
- Status original.
- Status apresentado em letras maiúsculas.
- Ano e mês do pedido.
- Valor do frete.
- Valor do desconto.

Crie também uma classificação textual baseada no status.

---

# 10. Etapa 09 — Desafios profissionais

Esta etapa exige que você escolha as funções adequadas sem receber a indicação exata de quais utilizar.

O objetivo é avaliar sua capacidade de interpretar um problema e transformá-lo em uma consulta SQL.

## DES-01 — Painel de análise de produtos

A equipe comercial precisa de uma consulta para analisar o catálogo.

A consulta deverá apresentar:

- Identificação do produto.
- Nome padronizado.
- Preço.
- Custo.
- Diferença entre preço e custo.
- Percentual calculado.
- Faixa comercial.
- Data de cadastro formatada.
- Situação do produto.

Requisitos:

- Utilizar funções de texto.
- Utilizar funções numéricas.
- Utilizar conversão ou formatação.
- Utilizar `CASE`.
- Utilizar expressões compostas.
- Ordenar por uma informação relevante para a análise.

## DES-02 — Análise de relacionamento com clientes

A equipe de atendimento deseja uma consulta para visualizar informações cadastrais dos clientes.

A consulta deverá apresentar:

- Nome padronizado.
- E-mail normalizado.
- Telefone tratado.
- Data de cadastro formatada.
- Tempo de cadastro.
- Classificação temporal do relacionamento.
- Situação do cliente.

Requisitos:

- Tratar campos nulos.
- Combinar funções de texto e data.
- Construir classificações.
- Evitar alterar os dados originais.

## DES-03 — Análise de entregas

A equipe logística precisa identificar o tempo de entrega dos pedidos.

A consulta deverá apresentar:

- ID da entrega.
- Pedido relacionado.
- Data de envio.
- Data de entrega.
- Tempo transcorrido.
- Classificação da entrega.
- Situação textual.

Requisitos:

- Considerar entregas ainda não concluídas.
- Evitar cálculos inválidos.
- Utilizar expressões condicionais.
- Trabalhar corretamente com datas e intervalos.

## DES-04 — Consulta integrada de diagnóstico

Construa uma consulta que utilize funções e expressões de pelo menos quatro categorias diferentes estudadas neste módulo.

Você deverá:

1. Definir um problema realista da TechStore.
2. Identificar as tabelas e colunas.
3. Escolher as funções necessárias.
4. Construir a consulta.
5. Explicar cada expressão.
6. Identificar possíveis casos extremos.
7. Validar os resultados.
8. Analisar o plano de execução.

A escolha do problema e das funções é livre, desde que todos os requisitos sejam atendidos.

---

# 11. Etapa 10 — Validação individual

Após concluir as atividades, responda sem consultar os exemplos da teoria:

1. Qual é a diferença entre uma coluna armazenada e uma expressão calculada?
2. Qual é a diferença entre `ROUND`, `CEIL` e `FLOOR`?
3. Por que uma divisão entre inteiros pode produzir um resultado diferente de uma divisão decimal?
4. Qual é a diferença entre `CONCAT` e `CONCAT_WS` no tratamento de `NULL`?
5. Qual é a diferença entre `EXTRACT` e `DATE_TRUNC`?
6. Qual é a diferença entre `CAST` e `::`?
7. Qual é a finalidade de `COALESCE`?
8. Qual é a finalidade de `NULLIF`?
9. Qual é a diferença entre `CASE` simples e pesquisado?
10. Por que `TO_CHAR` pode ser inadequado antes de um cálculo numérico?
11. Como uma função aplicada sobre uma coluna pode influenciar o uso de índices?
12. O que significa uma função ser `IMMUTABLE`, `STABLE` ou `VOLATILE`?

As respostas deverão conter explicações próprias e exemplos quando necessário.

---

# 12. Critérios de conclusão

O estudante deverá demonstrar domínio dos seguintes grupos:

| Grupo | Competência |
|---|---|
| 01 | Expressões e operadores |
| 02 | Funções de texto |
| 03 | Funções numéricas |
| 04 | Datas e horários |
| 05 | Conversões de tipos |
| 06 | Tratamento de NULL |
| 07 | Expressões condicionais |
| 08 | Funções compostas |
| 09 | Desafios profissionais |
| 10 | Validação conceitual |

## Avaliação

A avaliação seguirá os critérios gerais do curso:

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

**Nota mínima de referência:** 85%.

Erros críticos de lógica, tratamento de valores ausentes ou interpretação de resultados deverão ser corrigidos independentemente da nota numérica.

## Condições para aprovação

- Concluir as atividades essenciais.
- Demonstrar domínio das principais categorias de funções.
- Resolver os desafios profissionais.
- Explicar as decisões tomadas nas consultas.
- Validar os resultados.
- Demonstrar que compreende os casos extremos.
- Atingir a nota mínima de referência.

---

# 13. Registro de progresso

Utilize esta seção para acompanhar sua evolução.

| Atividade | Status | Observações |
|---|---|---|
| AT-01 a AT-04 | Pendente | Expressões |
| AT-05 a AT-09 | Pendente | Texto |
| AT-10 a AT-12 | Pendente | Numéricas |
| AT-13 a AT-17 | Pendente | Datas |
| AT-18 a AT-20 | Pendente | Conversões |
| AT-21 a AT-24 | Pendente | NULL |
| AT-25 a AT-28 | Pendente | CASE |
| AT-29 a AT-32 | Pendente | Funções compostas |
| DES-01 a DES-04 | Pendente | Desafios |
| Validação individual | Pendente | Conceitos |

---

# 14. Regras de evolução

O módulo será realizado com acompanhamento.

O estudante não precisa resolver todas as atividades de uma só vez.

A progressão ocorrerá por etapas:

1. Estudo do conceito.
2. Demonstração orientada.
3. Resolução individual.
4. Análise da consulta.
5. Validação independente.
6. Correção de dificuldades.
7. Liberação da próxima etapa.

Quando houver dificuldade, o conteúdo será reforçado especificamente no ponto necessário.

O objetivo não é terminar rapidamente, mas desenvolver domínio real de SQL.

**Status:** Atividades preparadas. Aulas ainda não iniciadas.