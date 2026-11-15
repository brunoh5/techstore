# Módulo 10 — Atividades: DML e Transações

## 1. Orientações gerais

Neste módulo, você trabalhará com comandos que podem modificar os dados do banco.

Por esse motivo, as regras de execução serão mais rigorosas.

### 1.1. Regras obrigatórias

- Não executar operações destrutivas no TechStore principal.
- Não executar novamente a seed.
- Não utilizar TRUNCATE ou DROP no banco principal.
- Não realizar UPDATE ou DELETE sem validação prévia.
- Não deixar transações abertas desnecessariamente.
- Utilizar ROLLBACK durante experimentações.
- Não confirmar alterações no banco principal sem autorização.
- Não criar índices ou alterar estruturas permanentes no banco principal.
- Utilizar um ambiente isolado ou tabelas temporárias para os exercícios práticos de escrita.

### 1.2. Ambiente recomendado

Os exercícios de escrita deverão utilizar uma destas alternativas:

1. Banco de testes separado.
2. Tabelas temporárias criadas exclusivamente para os exercícios.
3. Transações controladas com ROLLBACK.

Para este módulo, a opção preferencial será trabalhar com tabelas temporárias.

Uma tabela temporária permite experimentar operações de escrita sem modificar as tabelas permanentes do TechStore.

Ela será removida automaticamente ao final da sessão ou conforme a configuração de duração escolhida.

**Importante:** tabelas temporárias são estruturas reais criadas na sessão. Não confunda sua utilização com alterações permanentes no banco principal.

---

# 2. Preparação do ambiente

Antes de iniciar as atividades, prepare um pequeno ambiente de testes.

Você deverá criar tabelas temporárias que representem cenários simples de uma loja.

### AT-00 — Preparação do laboratório

Crie tabelas temporárias para representar:

- Produtos.
- Categorias.
- Clientes.
- Pedidos.
- Itens de pedidos.
- Estoque.

Requisitos:

- Produtos precisam possuir identificador, nome, preço e categoria.
- Categorias precisam possuir identificador e nome.
- Clientes precisam possuir identificador, nome e e-mail.
- Pedidos precisam possuir identificador, cliente e status.
- Itens precisam possuir identificador, pedido, produto e quantidade.
- Estoque precisa possuir identificador do produto, quantidade e estoque mínimo.

Configure restrições adequadas, incluindo chaves primárias e estrangeiras onde fizer sentido.

Não utilize dados do TechStore principal para preencher essas tabelas.

**Resultado esperado:** laboratório isolado, com estruturas suficientes para realizar as atividades seguintes.

---

# 3. INSERT — Inserção de dados

## Nível 1 — Fundamentos

### AT-01 — Inserção simples

Insira um produto no laboratório.

Requisitos:

- Informar explicitamente as colunas.
- Preencher nome.
- Preencher preço.
- Informar categoria.
- Validar o registro inserido.

### AT-02 — Inserção de múltiplos registros

Insira pelo menos cinco produtos em uma única instrução.

Requisitos:

- Utilizar INSERT com múltiplas linhas.
- Utilizar diferentes preços.
- Utilizar categorias existentes.
- Validar a quantidade inserida.

### AT-03 — Inserção com DEFAULT

Configure um valor padrão para uma coluna apropriada no laboratório.

Depois, insira registros omitindo essa coluna.

Valide se o valor padrão foi aplicado corretamente.

### AT-04 — Inserção com NULL

Insira um cliente com um campo opcional preenchido com NULL.

Depois:

- Consulte o registro.
- Diferencie NULL de texto vazio.
- Teste a condição de nulidade.
- Explique o comportamento observado.

### AT-05 — Inserção com RETURNING

Insira um produto utilizando RETURNING.

Requisitos:

- Recuperar o identificador gerado.
- Recuperar o nome.
- Recuperar o preço.
- Explicar por que RETURNING evita uma consulta adicional em determinados cenários.

### AT-06 — Inserção com erro controlado

Prepare uma tentativa de inserção que viole uma restrição de unicidade.

Requisitos:

- Identificar a restrição violada.
- Observar a mensagem de erro.
- Explicar por que a operação foi rejeitada.
- Garantir que a transação de teste seja encerrada corretamente.

Não utilize dados permanentes para provocar o erro.

## Nível 2 — Inserção intermediária

### AT-07 — INSERT INTO SELECT

Insira registros em uma tabela temporária de destino utilizando uma consulta SELECT.

Requisitos:

- Criar uma origem temporária.
- Criar uma tabela de destino compatível.
- Transferir os dados.
- Validar a quantidade de registros.
- Comparar os dados de origem e destino.

### AT-08 — Inserção em lote

Realize uma inserção de pelo menos 100 registros.

Observe:

- Tempo de execução.
- Quantidade inserida.
- Quantidade de instruções executadas.
- Comportamento de RETURNING.

### AT-09 — Inserção com múltiplas constraints

Crie um cenário com:

- PRIMARY KEY.
- FOREIGN KEY.
- UNIQUE.
- NOT NULL.
- CHECK.

Realize inserções válidas e inválidas.

Explique o comportamento de cada restrição.

### AT-10 — Inserção com validação referencial

Tente inserir um pedido que utilize um cliente inexistente.

Depois, corrija a referência e repita a operação.

Explique como a chave estrangeira protege a integridade dos dados.

---

# 4. UPDATE — Atualização de dados

## Nível 1 — Fundamentos

### AT-11 — Atualização simples

Atualize o preço de um produto do laboratório.

Requisitos:

- Identificar o produto.
- Atualizar o preço.
- Recuperar o resultado com RETURNING.
- Confirmar que outros produtos não foram alterados.

### AT-12 — Atualização múltipla

Atualize simultaneamente o nome e o preço de um produto.

Valide todas as colunas modificadas.

### AT-13 — Atualização utilizando expressões

Atualize o preço de um conjunto de produtos aplicando um percentual de aumento.

Requisitos:

- Utilizar uma expressão matemática.
- Selecionar os registros por condição.
- Validar os valores anteriores e posteriores.
- Explicar como o cálculo foi aplicado.

### AT-14 — UPDATE com CASE

Atualize uma coluna de classificação de produtos utilizando condições diferentes.

Exemplo de classificação conceitual:

- Preço baixo.
- Preço intermediário.
- Preço alto.

Utilize CASE dentro do UPDATE.

### AT-15 — UPDATE com RETURNING

Atualize múltiplos registros e retorne as informações modificadas.

Responda:

- Quantas linhas foram afetadas?
- Como o RETURNING ajuda na validação?
- O retorno significa que a transação já foi confirmada?

## Nível 2 — Atualização intermediária

### AT-16 — UPDATE com subconsulta

Atualize uma coluna utilizando um valor obtido de outra tabela.

Requisitos:

- Utilizar uma subconsulta escalar.
- Garantir que ela retorne no máximo uma linha.
- Validar o resultado.
- Explicar o que aconteceria se retornasse múltiplas linhas.

### AT-17 — UPDATE FROM

Atualize registros utilizando informações de uma tabela relacionada.

Requisitos:

- Utilizar UPDATE FROM.
- Estabelecer o relacionamento.
- Verificar a cardinalidade da origem.
- Evitar múltiplas correspondências para a mesma linha de destino.

### AT-18 — Atualização condicional

Atualize o estoque de produtos somente quando uma condição específica for satisfeita.

Explique:

- Qual era a quantidade anterior.
- Qual foi a nova quantidade.
- Quais registros foram modificados.
- Como impedir quantidades inválidas.

### AT-19 — Atualização sem WHERE

Em uma tabela temporária descartável, execute uma atualização sem WHERE.

Observe o resultado.

Depois:

- Identifique quantos registros foram afetados.
- Explique o risco.
- Desfaça a operação com ROLLBACK.
- Demonstre que os dados anteriores foram preservados.

Não execute esse exercício em tabelas permanentes.

---

# 5. DELETE — Remoção de dados

## Nível 1 — Fundamentos

### AT-20 — Exclusão específica

Remova um produto do laboratório utilizando seu identificador.

Requisitos:

- Consultar o registro antes da exclusão.
- Executar DELETE.
- Utilizar RETURNING.
- Confirmar que o registro não está mais disponível.

### AT-21 — Exclusão condicional

Remova todos os registros que atendam a uma condição definida por você.

Antes da execução:

- Identifique os registros.
- Conte quantos serão removidos.
- Avalie possíveis dependências.
- Execute dentro de uma transação controlada.

### AT-22 — DELETE com subconsulta

Remova registros utilizando uma subconsulta para determinar quais deles atendem à condição.

Explique como a subconsulta influencia o conjunto de registros removidos.

### AT-23 — DELETE USING

Realize uma exclusão utilizando duas tabelas temporárias relacionadas.

Requisitos:

- Utilizar DELETE USING.
- Definir a condição de relacionamento.
- Identificar os registros afetados.
- Validar o resultado.

### AT-24 — Exclusão com chave estrangeira

Crie um cenário em que um registro seja referenciado por outra tabela.

Tente removê-lo.

Observe o comportamento da chave estrangeira.

Depois, avalie a diferença entre:

- NO ACTION.
- RESTRICT.
- CASCADE.
- SET NULL.

Não configure CASCADE em tabelas permanentes.

## Nível 2 — Análise e segurança

### AT-25 — DELETE sem WHERE

Em uma tabela temporária descartável:

- Execute uma exclusão sem WHERE.
- Observe a quantidade de registros removidos.
- Analise o RETURNING.
- Desfaça a operação.
- Valide a recuperação dos registros.

### AT-26 — DELETE versus TRUNCATE

Utilize tabelas temporárias independentes para comparar os dois comandos.

Analise:

- Seleção de registros.
- Quantidade de registros removidos.
- Comportamento de identidade.
- Triggers.
- Bloqueios.
- Possibilidade de rollback no PostgreSQL.

Não execute TRUNCATE no TechStore principal.

### AT-27 — DELETE versus DROP

Explique a diferença entre remover registros e remover uma estrutura.

Utilize um ambiente isolado para demonstrar o comportamento.

---

# 6. UPSERT — Tratamento de conflitos

### AT-28 — ON CONFLICT DO NOTHING

Crie uma situação em que uma inserção gere conflito de chave primária.

Utilize DO NOTHING.

Valide:

- Se o registro original foi preservado.
- Se um novo registro foi criado.
- Como o banco se comportou diante do conflito.

### AT-29 — ON CONFLICT DO UPDATE

Insira um registro que possa gerar conflito.

Utilize DO UPDATE para atualizar os dados existentes.

Valide:

- O comportamento sem conflito.
- O comportamento com conflito.
- Os valores finais.
- O retorno da operação.

### AT-30 — UPSERT com múltiplas colunas

Crie uma restrição UNIQUE composta no laboratório.

Utilize ON CONFLICT para tratar conflitos envolvendo a combinação de colunas.

Explique por que a combinação é importante.

### AT-31 — UPSERT condicional

Implemente um UPSERT em que a atualização somente aconteça quando uma condição for satisfeita.

Explique como a condição influencia a decisão de atualizar ou preservar o registro existente.

### AT-32 — Limites do UPSERT

Prepare tentativas controladas de violação de:

- NOT NULL.
- CHECK.
- FOREIGN KEY.
- UNIQUE.

Identifique quais situações podem ser tratadas com ON CONFLICT e quais continuam produzindo erros.

---

# 7. Transações

## Nível 1 — Fundamentos

### AT-33 — BEGIN e COMMIT

Crie uma transação.

Realize uma inserção em uma tabela temporária.

Confirme a operação utilizando COMMIT.

Valide que o registro permaneceu disponível após a confirmação.

### AT-34 — BEGIN e ROLLBACK

Crie uma transação.

Insira um registro.

Antes de confirmar, execute ROLLBACK.

Valide que o registro não foi mantido.

### AT-35 — Múltiplas operações na mesma transação

Realize:

1. Inserção de uma categoria.
2. Inserção de um produto relacionado.
3. Inserção de uma quantidade inicial de estoque.

Agrupe as operações em uma única transação.

Valide os relacionamentos antes de decidir pela confirmação ou pelo rollback.

### AT-36 — Falha durante uma transação

Crie uma transação contendo operações válidas e uma operação que provoque erro controlado.

Observe:

- O resultado da instrução inválida.
- O estado da transação.
- O comportamento dos comandos seguintes.
- A necessidade de executar ROLLBACK.

### AT-37 — Atomicidade

Monte um cenário em que uma operação dependa de duas ou mais inserções.

Simule uma falha em uma das etapas.

Demonstre que nenhuma alteração parcial precisa ser mantida quando toda a operação é desfeita.

## Nível 2 — SAVEPOINT

### AT-38 — Criação de SAVEPOINT

Crie uma transação com três etapas.

Adicione um SAVEPOINT entre a segunda e a terceira etapa.

Explique a posição do ponto de recuperação.

### AT-39 — ROLLBACK TO SAVEPOINT

Execute operações após um SAVEPOINT.

Depois, retorne ao ponto de recuperação.

Valide:

- Quais operações permaneceram.
- Quais operações foram desfeitas.
- Se a transação continua aberta.

### AT-40 — RELEASE SAVEPOINT

Crie dois savepoints.

Libere um deles e continue trabalhando.

Explique a diferença entre RELEASE SAVEPOINT e COMMIT.

### AT-41 — Múltiplos SAVEPOINTS

Monte uma transação com três pontos de recuperação.

Execute alterações entre eles.

Realize rollback para um ponto intermediário.

Analise o estado final da transação.

---

# 8. Propriedades ACID

### AT-42 — Atomicidade

Crie uma transação com múltiplas operações relacionadas.

Demonstre que o rollback desfaz as alterações da transação.

### AT-43 — Consistência

Crie um cenário com restrições de integridade.

Tente executar operações que violem essas restrições.

Explique como o banco impede a confirmação de estados inválidos.

### AT-44 — Isolamento

Utilize duas sessões do pgAdmin conectadas ao ambiente de testes.

Execute transações simultâneas.

Observe como uma sessão enxerga as alterações realizadas pela outra.

### AT-45 — Durabilidade

Realize uma alteração controlada em uma tabela temporária e depois em um ambiente de testes separado.

Compare o comportamento das alterações após o encerramento da sessão.

Explique por que tabelas temporárias não são adequadas para demonstrar durabilidade de dados permanentes.

---

# 9. Concorrência e bloqueios

## Nível 1 — Fundamentos

### AT-46 — Duas sessões simultâneas

Abra duas sessões SQL independentes.

Utilize uma tabela de testes compartilhada entre elas.

Realize consultas e alterações simultâneas.

Observe o comportamento de cada sessão.

### AT-47 — SELECT FOR UPDATE

Na primeira sessão:

- Inicie uma transação.
- Selecione uma linha com FOR UPDATE.
- Mantenha a transação aberta.

Na segunda sessão:

- Tente atualizar a mesma linha.
- Observe o comportamento.
- Finalize a primeira transação.
- Observe o resultado na segunda sessão.

### AT-48 — SELECT FOR SHARE

Repita o cenário anterior utilizando FOR SHARE.

Compare o comportamento com FOR UPDATE.

### AT-49 — Bloqueios de linha

Utilize duas sessões para testar operações em linhas diferentes de uma mesma tabela.

Compare com operações realizadas sobre a mesma linha.

Explique como o bloqueio afeta a concorrência.

### AT-50 — Deadlock

Em ambiente de testes isolado, crie duas transações que bloqueiem linhas em ordem diferente.

Simule uma situação de espera circular.

Observe:

- O comportamento das sessões.
- A detecção de deadlock.
- A transação cancelada.
- A necessidade de tratamento do erro.

Execute este exercício somente em tabelas de teste.

---

# 10. Níveis de isolamento

### AT-51 — READ COMMITTED

Configure duas sessões utilizando READ COMMITTED.

Execute consultas repetidas na primeira sessão enquanto a segunda confirma alterações.

Observe se os resultados podem mudar durante a mesma transação.

### AT-52 — REPEATABLE READ

Repita o cenário utilizando REPEATABLE READ.

Compare os resultados com READ COMMITTED.

### AT-53 — SERIALIZABLE

Execute duas transações concorrentes com SERIALIZABLE.

Crie um cenário em que exista conflito de serialização.

Observe:

- A mensagem de erro.
- O encerramento da transação.
- A necessidade de repetir a operação.
- A diferença em relação aos outros níveis.

### AT-54 — Comparação dos níveis de isolamento

Monte uma tabela comparativa contendo:

- Nível.
- Visibilidade dos dados.
- Comportamento diante de alterações concorrentes.
- Possíveis anomalias.
- Possibilidade de abortos.
- Custo operacional.

---

# 11. Desempenho de DML

### AT-55 — INSERT individual versus lote

Insira a mesma quantidade de registros utilizando:

- Instruções INSERT individuais.
- INSERT com múltiplas linhas.

Compare o tempo de execução.

Utilize o mesmo conjunto de dados e condições de teste.

### AT-56 — UPDATE com filtro

Crie uma tabela temporária com volume suficiente para permitir comparação.

Execute atualizações com diferentes condições de filtragem.

Analise os planos de execução.

### AT-57 — DELETE com filtro

Compare diferentes estratégias para identificar os registros que serão removidos.

Utilize EXPLAIN para analisar os planos.

### AT-58 — Impacto dos índices

Crie tabelas de teste equivalentes, com e sem índices apropriados.

Compare o comportamento das operações de escrita.

Não altere os índices permanentes do TechStore principal.

### AT-59 — EXPLAIN versus EXPLAIN ANALYZE

Compare a análise de uma operação de escrita com EXPLAIN e EXPLAIN ANALYZE.

Explique:

- Qual deles executa a operação?
- Quais métricas são apresentadas?
- Como evitar persistir alterações durante o teste?
- Quais efeitos operacionais podem continuar existindo mesmo após ROLLBACK?

### AT-60 — Análise de uma operação completa

Monte uma operação transacional contendo:

- Inserção de registros.
- Atualização de registros.
- Validação de integridade.
- Consulta de conferência.
- Decisão de COMMIT ou ROLLBACK.

Analise o tempo de execução e os possíveis pontos de custo.

---

# 12. Desafios complexos

Os desafios exigem combinar vários conceitos.

Não há uma única solução obrigatória. O importante é que a estratégia seja correta, segura, validada e justificada.

## DES-01 — Cadastro completo de produto

Implemente uma operação de cadastro que envolva:

- Produto.
- Categoria.
- Estoque inicial.

Requisitos:

- Validar a categoria.
- Inserir o produto.
- Inserir o estoque.
- Utilizar RETURNING quando apropriado.
- Agrupar as operações em uma transação.
- Garantir atomicidade.
- Demonstrar rollback em caso de falha.

## DES-02 — Atualização de estoque

Crie uma operação que represente uma saída de estoque.

Requisitos:

- Identificar o produto.
- Verificar a quantidade disponível.
- Impedir estoque negativo.
- Utilizar controle transacional.
- Considerar concorrência.
- Validar o resultado final.

Explique por que uma consulta seguida de UPDATE sem controle de concorrência pode apresentar problemas.

## DES-03 — Processamento de pedido

Implemente um fluxo de processamento de pedido no laboratório.

A operação deverá:

1. Identificar um cliente.
2. Criar um pedido.
3. Inserir itens.
4. Atualizar o estoque.
5. Validar todos os registros.
6. Confirmar a transação.

Simule uma falha durante o processamento e demonstre como evitar um pedido parcialmente registrado.

## DES-04 — Importação com UPSERT

Simule a importação de dados de uma origem externa.

Requisitos:

- Inserir novos registros.
- Identificar conflitos.
- Atualizar registros existentes.
- Preservar informações que não devem ser sobrescritas.
- Validar os resultados.
- Identificar registros ignorados.

## DES-05 — Recuperação de operação

Monte uma transação com várias etapas.

Introduza um erro em uma etapa intermediária.

Utilize SAVEPOINT para recuperar parcialmente a operação.

Explique quais alterações devem permanecer e quais devem ser desfeitas.

## DES-06 — Auditoria e segurança

Crie um cenário de alteração de dados que precise de auditoria.

Registre:

- Identificador do registro.
- Operação executada.
- Valor anterior.
- Valor posterior.
- Momento da alteração.

Demonstre como validar a auditoria dentro do mesmo fluxo transacional.

Explique o que deve acontecer com o registro de auditoria caso a operação principal seja desfeita.

## DES-07 — Concorrência de estoque

Simule duas sessões tentando retirar unidades do mesmo produto simultaneamente.

Requisitos:

- Demonstrar o problema potencial.
- Utilizar bloqueio de linha ou estratégia transacional adequada.
- Impedir estoque negativo.
- Explicar como a segunda operação será tratada.
- Comparar o comportamento com e sem bloqueio explícito.

## DES-08 — Otimização de operações DML

Crie um cenário de manipulação de dados com volume relevante em um banco de testes.

Compare:

- INSERT individual.
- INSERT em lote.
- UPDATE com diferentes condições.
- DELETE com diferentes condições.

Apresente métricas, planos e conclusões.

Não altere as tabelas permanentes do TechStore.

---

# 13. Perguntas de compreensão

Responda sem consultar os exemplos sempre que possível.

1. Qual a diferença entre DQL e DML?
2. Quais são os principais comandos DML?
3. Por que é importante informar as colunas em INSERT?
4. Qual a diferença entre DEFAULT e NULL?
5. Para que serve RETURNING?
6. O que acontece quando UPDATE é executado sem WHERE?
7. Qual a diferença entre UPDATE FROM e uma subconsulta?
8. Como uma chave estrangeira pode impedir um DELETE?
9. Qual a diferença entre DELETE, TRUNCATE e DROP?
10. O que caracteriza uma operação UPSERT?
11. Qual a diferença entre DO NOTHING e DO UPDATE?
12. O que acontece quando uma transação recebe COMMIT?
13. Qual a diferença entre COMMIT e ROLLBACK?
14. Para que serve SAVEPOINT?
15. SAVEPOINT confirma uma transação?
16. O que representam as propriedades ACID?
17. Como o PostgreSQL implementa MVCC?
18. Qual a diferença entre READ COMMITTED e REPEATABLE READ?
19. O que caracteriza um deadlock?
20. Qual a finalidade de SELECT FOR UPDATE?
21. Qual a diferença entre FOR UPDATE e FOR SHARE?
22. Por que transações longas podem prejudicar o desempenho?
23. Como índices afetam operações de escrita?
24. Qual a relação entre WAL e durabilidade?
25. Qual a diferença entre EXPLAIN e EXPLAIN ANALYZE?
26. Por que EXPLAIN ANALYZE de UPDATE pode ser perigoso?
27. O que acontece quando uma instrução falha dentro de uma transação?
28. Como evitar alterações acidentais em massa?
29. Por que a aplicação deve estar preparada para falhas de serialização?
30. Qual a importância de validar dados antes de COMMIT?

---

# 14. Critérios de avaliação

A avaliação seguirá os pesos oficiais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |

**Nota mínima de referência: 85%.**

## 14.1. Erros críticos

Os seguintes erros impedem a aprovação, independentemente da nota:

- Modificar acidentalmente o banco principal.
- Executar operações destrutivas sem autorização.
- Não compreender o efeito de UPDATE ou DELETE.
- Ignorar violações de integridade.
- Confirmar transações sem validar operações críticas.
- Permitir inconsistências no processamento de pedidos ou estoque.
- Não tratar adequadamente falhas de concorrência.

## 14.2. O que será avaliado

Além de verificar se a instrução SQL funciona, será avaliado se você:

- Compreende o estado do banco antes e depois da operação.
- Sabe identificar os registros afetados.
- Utiliza transações corretamente.
- Sabe desfazer operações.
- Entende o comportamento de constraints.
- Consegue lidar com concorrência.
- Justifica decisões de segurança.
- Analisa o custo das operações.

---

# 15. Registro de progresso

| Etapa | Status |
|---|---|
| Preparação do laboratório | Pendente |
| INSERT | Pendente |
| UPDATE | Pendente |
| DELETE | Pendente |
| UPSERT | Pendente |
| Transações | Pendente |
| SAVEPOINT | Pendente |
| ACID | Pendente |
| Concorrência | Pendente |
| Níveis de isolamento | Pendente |
| Desempenho | Pendente |
| Desafios complexos | Pendente |
| Perguntas de compreensão | Pendente |
| Validação independente | Pendente |
| Avaliação final | Pendente |

---

# 16. Condição para avançar

Para liberar o Módulo 11, será necessário demonstrar:

- Domínio de INSERT, UPDATE e DELETE.
- Compreensão de UPSERT.
- Uso correto de transações.
- Domínio de COMMIT, ROLLBACK e SAVEPOINT.
- Compreensão das propriedades ACID.
- Conhecimento de MVCC e bloqueios.
- Capacidade de identificar e tratar problemas de concorrência.
- Segurança na manipulação de dados.
- Capacidade de validar resultados.
- Desempenho satisfatório nos desafios.

**Nota mínima de referência: 85%, sem erros críticos.**

O objetivo é garantir que você consiga manipular dados de forma profissional, sem comprometer a integridade ou a disponibilidade do banco.