# Validação — Módulo 10: DML e Transações

## 1. Objetivo da validação

Esta etapa verifica se o aluno consegue manipular dados com segurança, controlar transações, preservar a integridade das informações e compreender o comportamento do PostgreSQL diante de operações concorrentes.

A validação não consiste apenas em verificar se os comandos executam corretamente. É necessário demonstrar que o aluno entende os efeitos de cada operação, sabe identificar riscos e consegue comprovar os resultados.

### Competências avaliadas

Ao concluir esta etapa, o aluno deverá ser capaz de:

- Executar INSERT, UPDATE e DELETE corretamente.
- Utilizar RETURNING para verificar operações.
- Aplicar UPSERT com ON CONFLICT.
- Controlar transações com BEGIN, COMMIT e ROLLBACK.
- Utilizar SAVEPOINT e recuperação parcial.
- Explicar e demonstrar as propriedades ACID.
- Compreender constraints e integridade referencial.
- Identificar problemas de concorrência.
- Trabalhar com bloqueios e níveis de isolamento.
- Interpretar efeitos de operações DML no desempenho.
- Utilizar EXPLAIN e EXPLAIN ANALYZE conscientemente.
- Proteger dados contra alterações acidentais.

---

## 2. Regras do ambiente de validação

### 2.1. Banco principal TechStore

O banco principal deverá permanecer preservado.

Não são permitidos:

- INSERT permanente nas tabelas originais.
- UPDATE nas tabelas originais.
- DELETE nas tabelas originais.
- TRUNCATE nas tabelas originais.
- Alterações de estrutura sem autorização.
- Criação de índices permanentes para experimentação.
- Execução de novamente do seed.

### 2.2. Laboratório temporário

Para os testes individuais, poderá ser utilizado o laboratório criado nas atividades do módulo.

As tabelas temporárias são suficientes para os exercícios que acontecem em uma única sessão.

Entretanto, tabelas temporárias não são compartilhadas entre sessões PostgreSQL. Portanto, não devem ser utilizadas para demonstrar concorrência entre duas conexões independentes.

### 2.3. Laboratório compartilhado

Os testes de concorrência, isolamento e durabilidade deverão utilizar:

- Um banco de testes separado; ou
- Um schema de laboratório compartilhado, criado em um ambiente de testes separado.

As tabelas utilizadas nesses testes deverão ser permanentes dentro do ambiente de laboratório.

O laboratório deverá ser preparado exclusivamente para essa finalidade, sem modificar o banco principal TechStore.

Ao finalizar, o ambiente de testes deverá ser encerrado de maneira controlada.

### 2.4. Execução segura

Antes de qualquer operação:

1. Identificar a tabela de destino.
2. Verificar os registros envolvidos.
3. Avaliar as constraints existentes.
4. Identificar as relações com outras tabelas.
5. Iniciar uma transação quando apropriado.
6. Executar a operação.
7. Conferir o resultado.
8. Confirmar ou desfazer a operação.

O aluno deverá justificar quando utilizar COMMIT ou ROLLBACK.

---

## 3. Validação de DML

### VAL-01 — INSERT básico

Demonstrar a capacidade de inserir um registro em uma tabela de laboratório.

Critérios:

- Sintaxe correta.
- Correspondência entre colunas e valores.
- Tipos de dados compatíveis.
- Respeito às constraints.
- Verificação do registro inserido.

### VAL-02 — INSERT com múltiplos registros

Demonstrar inserção de múltiplas linhas em uma única operação.

Critérios:

- Estrutura correta.
- Quantidade de registros esperada.
- Compatibilidade dos valores.
- Ausência de duplicações indevidas.

### VAL-03 — INSERT com DEFAULT e NULL

Demonstrar a diferença entre:

- Utilizar DEFAULT.
- Informar NULL explicitamente.
- Omitir uma coluna.
- Utilizar valores obrigatórios.

O aluno deverá explicar por que esses comportamentos podem produzir resultados diferentes.

### VAL-04 — RETURNING

Demonstrar a utilização de RETURNING em uma operação DML.

Critérios:

- Recuperação dos dados afetados.
- Interpretação correta do resultado.
- Compreensão de que RETURNING não substitui a validação posterior.

### VAL-05 — INSERT SELECT

Demonstrar a inserção de dados provenientes de uma consulta.

Critérios:

- Compatibilidade entre origem e destino.
- Quantidade de registros inseridos.
- Tratamento de valores NULL.
- Prevenção de duplicações quando necessário.

### VAL-06 — Violação de UNIQUE

Provocar uma violação controlada de unicidade no laboratório.

O aluno deverá identificar:

- A constraint responsável.
- O motivo da falha.
- O código de erro apresentado pelo PostgreSQL.
- O estado da transação após o erro.

Código de referência: `23505`.

### VAL-07 — UPDATE básico

Demonstrar atualização de um registro específico.

Critérios:

- Condição de identificação correta.
- Quantidade de registros afetados.
- Verificação dos valores anteriores e posteriores.
- Ausência de alterações indevidas.

### VAL-08 — UPDATE com expressões

Demonstrar atualização utilizando expressões e valores calculados.

Critérios:

- Cálculo correto.
- Tipos compatíveis.
- Tratamento de valores NULL.
- Resultado esperado.

### VAL-09 — UPDATE com CASE

Demonstrar atualização condicional utilizando CASE.

Critérios:

- Condições corretas.
- Cobertura dos cenários esperados.
- ELSE adequadamente considerado.
- Ausência de atualizações inesperadas.

### VAL-10 — UPDATE sem WHERE

Demonstrar, exclusivamente em laboratório, o comportamento de um UPDATE sem WHERE.

O aluno deverá:

- Identificar o impacto da operação.
- Verificar quantas linhas foram afetadas.
- Recuperar o estado anterior por meio de ROLLBACK.
- Explicar por que esse comando representa um risco.

### VAL-11 — UPDATE FROM

Demonstrar atualização utilizando dados de outra tabela.

Critérios:

- Relacionamento correto entre origem e destino.
- Ausência de correspondências ambíguas.
- Resultado validado.
- Compreensão do risco de múltiplas correspondências para uma mesma linha de destino.

### VAL-12 — DELETE específico

Demonstrar remoção de registros identificados por uma condição.

Critérios:

- Condição correta.
- Quantidade de linhas removidas.
- Verificação dos registros restantes.
- Integridade referencial preservada.

### VAL-13 — DELETE sem WHERE

Demonstrar o comportamento de um DELETE sem WHERE em uma tabela de laboratório.

Critérios:

- Compreensão do impacto.
- Identificação da quantidade de linhas removidas.
- Recuperação por ROLLBACK.
- Explicação do risco operacional.

### VAL-14 — DELETE com relacionamento

Demonstrar exclusão utilizando subconsulta ou relacionamento com outra tabela.

Critérios:

- Identificação correta dos registros.
- Compreensão das dependências.
- Respeito às FKs.
- Resultado validado.

### VAL-15 — DELETE, TRUNCATE e DROP

Comparar os três comandos.

O aluno deverá explicar:

- O que cada comando remove.
- Como cada operação afeta a estrutura.
- Como se comportam em transações PostgreSQL.
- Diferenças de bloqueio.
- Diferenças relacionadas a triggers.
- Consequências de RESTART IDENTITY e CONTINUE IDENTITY no TRUNCATE.

---

## 4. Validação de UPSERT

### VAL-16 — ON CONFLICT DO NOTHING

Demonstrar inserção com prevenção de duplicidade.

Critérios:

- Identificação da constraint de conflito.
- Compreensão do comportamento quando existe conflito.
- Verificação dos registros inseridos.

### VAL-17 — ON CONFLICT DO UPDATE

Demonstrar atualização de um registro quando ocorre conflito de unicidade.

Critérios:

- Utilização correta de ON CONFLICT.
- Compreensão de EXCLUDED.
- Atualização dos campos esperados.
- Preservação dos demais valores.

### VAL-18 — Conflito com UNIQUE composta

Demonstrar UPSERT utilizando uma constraint de unicidade composta.

Critérios:

- Identificação correta da combinação de colunas.
- Tratamento correto do conflito.
- Resultado esperado.

### VAL-19 — Limitações do UPSERT

Demonstrar que ON CONFLICT não é uma solução genérica para qualquer erro de integridade.

O aluno deverá diferenciar:

- Violação de UNIQUE.
- Violação de PRIMARY KEY.
- Violação de NOT NULL.
- Violação de CHECK.
- Violação de FOREIGN KEY.

Deverá compreender que ON CONFLICT trata conflitos de unicidade compatíveis com o alvo especificado, não substituindo a validação das demais constraints.

---

## 5. Validação de transações

### VAL-20 — BEGIN e COMMIT

Demonstrar uma transação com múltiplas operações.

Critérios:

- Início correto.
- Execução das operações.
- Verificação dos resultados.
- Confirmação com COMMIT.
- Compreensão da persistência após a confirmação.

### VAL-21 — BEGIN e ROLLBACK

Demonstrar uma transação desfeita.

Critérios:

- Identificação das operações realizadas.
- Execução do ROLLBACK.
- Verificação de que as alterações foram desfeitas.
- Explicação do resultado.

### VAL-22 — Estado de uma transação após erro

Provocar um erro controlado dentro de uma transação.

O aluno deverá identificar:

- O erro original.
- O estado de transação abortada.
- O comportamento dos comandos seguintes.
- A necessidade de ROLLBACK ou recuperação por SAVEPOINT.

Código de referência para transação abortada: `25P02`.

### VAL-23 — SAVEPOINT

Demonstrar a criação de um ponto intermediário de recuperação.

Critérios:

- Criação correta do SAVEPOINT.
- Execução de operações posteriores.
- Recuperação parcial.
- Preservação das operações anteriores ao ponto de recuperação.
- Finalização adequada da transação.

### VAL-24 — Múltiplos SAVEPOINTs

Demonstrar o uso de mais de um ponto de recuperação.

O aluno deverá explicar:

- A diferença entre ROLLBACK e ROLLBACK TO SAVEPOINT.
- O comportamento de RELEASE SAVEPOINT.
- A relação entre SAVEPOINT e a transação principal.

### VAL-25 — Atomicidade

Demonstrar uma operação composta em que todas as alterações precisam ser confirmadas ou desfeitas em conjunto.

Critérios:

- Identificação das operações dependentes.
- Demonstração de sucesso completo.
- Demonstração de falha controlada.
- Verificação da atomicidade.

### VAL-26 — Consistência

Demonstrar que as constraints mantêm a integridade dos dados.

O aluno deverá apresentar exemplos de:

- PRIMARY KEY.
- FOREIGN KEY.
- UNIQUE.
- NOT NULL.
- CHECK.

Deverá explicar como essas regras impedem estados inválidos.

### VAL-27 — Isolamento

Demonstrar o comportamento de duas transações independentes.

Critérios:

- Utilização de duas sessões.
- Identificação das operações concorrentes.
- Compreensão dos dados visíveis em cada sessão.
- Explicação do isolamento observado.

### VAL-28 — Durabilidade

Demonstrar a persistência de uma alteração confirmada.

O teste deverá utilizar uma tabela permanente em um banco de testes isolado.

Critérios:

- Inserção ou alteração controlada.
- COMMIT.
- Verificação em uma nova sessão.
- Compreensão da diferença entre tabela temporária e permanente.

Não é necessário reiniciar o servidor PostgreSQL para demonstrar o conceito.

---

## 6. Validação de concorrência e bloqueios

### VAL-29 — MVCC

Explicar como o PostgreSQL utiliza MVCC para permitir que transações trabalhem com diferentes versões dos dados.

O aluno deverá demonstrar compreensão de:

- Versões de registros.
- Snapshots.
- Visibilidade dos dados.
- Relação entre MVCC e isolamento.

### VAL-30 — SELECT FOR UPDATE

Demonstrar bloqueio de registros para atualização.

Critérios:

- Identificação das linhas bloqueadas.
- Compreensão do comportamento de outra sessão.
- Finalização correta da transação.
- Liberação dos bloqueios.

### VAL-31 — SELECT FOR SHARE

Demonstrar o comportamento de bloqueios compartilhados.

O aluno deverá comparar o comportamento com FOR UPDATE.

### VAL-32 — Identificação de bloqueios

Demonstrar capacidade de identificar sessões e operações que estejam aguardando bloqueios.

Critérios:

- Identificação das sessões envolvidas.
- Compreensão da relação entre bloqueador e bloqueado.
- Interpretação das informações de monitoramento.
- Identificação de possíveis causas.

### VAL-33 — Deadlock

Demonstrar, em laboratório isolado, como um deadlock pode ocorrer.

Critérios:

- Compreensão da sequência de bloqueios.
- Identificação do conflito.
- Reconhecimento do erro.
- Explicação de como reduzir o risco.

Código de referência: `40P01`.

O teste deverá utilizar duas sessões independentes, tabelas permanentes de laboratório e procedimentos controlados.

### VAL-34 — Prevenção de deadlocks

Apresentar estratégias para reduzir a ocorrência de deadlocks.

O aluno deverá abordar:

- Ordem consistente de aquisição de bloqueios.
- Transações menores.
- Redução do tempo de retenção de locks.
- Tratamento de falhas.
- Estratégias de repetição segura quando apropriado.

---

## 7. Validação dos níveis de isolamento

### VAL-35 — READ COMMITTED

Demonstrar o comportamento padrão do PostgreSQL.

Critérios:

- Compreensão do snapshot por comando.
- Identificação de alterações confirmadas por outras transações.
- Explicação do comportamento observado.

### VAL-36 — REPEATABLE READ

Demonstrar o comportamento de uma transação com snapshot estável.

Critérios:

- Comparação entre leituras na mesma transação.
- Compreensão da visibilidade dos dados.
- Identificação de possíveis conflitos.

### VAL-37 — SERIALIZABLE

Demonstrar o comportamento do nível SERIALIZABLE.

Critérios:

- Compreensão da serialização.
- Identificação de falhas de serialização.
- Tratamento adequado da transação abortada.
- Compreensão da necessidade de repetir a transação quando apropriado.

Código de referência: `40001`.

### VAL-38 — Comparação dos níveis de isolamento

Comparar:

- READ COMMITTED.
- REPEATABLE READ.
- SERIALIZABLE.

O aluno deverá explicar:

- Diferenças de visibilidade.
- Anomalias possíveis.
- Custos e limitações.
- Cenários adequados para cada nível.

Observação: no PostgreSQL, READ UNCOMMITTED se comporta como READ COMMITTED.

---

## 8. Validação de desempenho DML

### VAL-39 — INSERT individual versus em lote

Comparar inserções individuais e inserções em lote.

Critérios:

- Mesmo volume de registros.
- Mesmas constraints.
- Mesmos índices.
- Condições de execução comparáveis.
- Repetição dos testes.
- Comparação de tempos.

### VAL-40 — UPDATE e desempenho

Avaliar o impacto de uma operação UPDATE.

O aluno deverá considerar:

- Quantidade de linhas afetadas.
- Condições de filtragem.
- Índices utilizados.
- Volume de alterações.
- Custo de manutenção dos índices.

### VAL-41 — DELETE e desempenho

Avaliar o desempenho de exclusões em diferentes volumes.

Critérios:

- Identificação das linhas afetadas.
- Análise do plano quando aplicável.
- Compreensão dos custos de exclusão.
- Relação com VACUUM e manutenção posterior.

### VAL-42 — EXPLAIN versus EXPLAIN ANALYZE

Demonstrar a diferença entre os dois comandos.

O aluno deverá explicar:

- O que EXPLAIN apresenta.
- O que EXPLAIN ANALYZE executa.
- Como interpretar o tempo real.
- Por que ANALYZE pode modificar dados quando aplicado a DML.

**Atenção:** EXPLAIN ANALYZE executa a operação. Em DML, o uso deverá ocorrer exclusivamente em laboratório controlado, preferencialmente dentro de uma transação desfeita com ROLLBACK. Mesmo assim, efeitos externos de triggers, chamadas externas e consumo de sequências podem não ser revertidos da mesma maneira que as alterações transacionais.

### VAL-43 — Análise integrada de desempenho

Realizar uma análise comparativa de operações DML.

O aluno deverá registrar:

- Tempo de execução.
- Planning Time, quando aplicável.
- Actual Rows.
- Nós do plano.
- Índices envolvidos.
- Volume de dados.
- Condições de execução.

A análise deverá apresentar uma hipótese, uma alteração por vez e uma comparação posterior.

---

## 9. Desafios de domínio

Os desafios deverão ser realizados sem consultar soluções prontas.

O aluno poderá consultar a documentação oficial do PostgreSQL e seus próprios materiais teóricos.

### DES-01 — Cadastro transacional

Criar um fluxo de cadastro em laboratório que envolva mais de uma tabela relacionada.

Objetivos:

- Inserção de registros relacionados.
- Respeito às FKs.
- Controle transacional.
- Recuperação em caso de falha.
- Verificação dos resultados.

### DES-02 — Controle de estoque

Desenvolver uma operação de atualização de estoque que considere concorrência.

Objetivos:

- Evitar quantidades negativas.
- Impedir atualizações inconsistentes.
- Considerar duas sessões simultâneas.
- Garantir integridade dos dados.

### DES-03 — Processamento de pedido

Simular o processamento de um pedido em laboratório.

O fluxo deverá considerar:

- Cadastro do pedido.
- Inclusão dos itens.
- Atualização do estoque.
- Registro do pagamento.
- Confirmação ou cancelamento da transação.

O aluno deverá justificar quais operações pertencem à mesma transação.

### DES-04 — Importação com UPSERT

Desenvolver uma rotina de importação que trate registros novos e registros já existentes.

Objetivos:

- Identificar conflitos.
- Atualizar registros quando necessário.
- Evitar duplicações.
- Tratar erros de integridade.
- Validar o resultado final.

### DES-05 — Recuperação com SAVEPOINT

Criar um processo com várias operações independentes e dependentes.

O aluno deverá demonstrar recuperação parcial sem perder operações válidas anteriores ao ponto de recuperação.

### DES-06 — Auditoria de alterações

Simular uma rotina de atualização que mantenha um histórico das alterações realizadas.

Objetivos:

- Registrar informações relevantes.
- Manter consistência entre alteração e auditoria.
- Compreender o comportamento em caso de ROLLBACK.
- Diferenciar registros transacionais de efeitos externos.

### DES-07 — Concorrência e isolamento

Construir um cenário com duas sessões independentes que atualizem informações relacionadas.

Objetivos:

- Identificar bloqueios.
- Comparar níveis de isolamento.
- Reconhecer conflitos.
- Demonstrar estratégias de recuperação.
- Preservar a integridade.

### DES-08 — Otimização DML

Investigar uma operação DML com desempenho insatisfatório em laboratório.

O aluno deverá:

1. Estabelecer uma medição inicial.
2. Identificar o possível gargalo.
3. Formular uma hipótese.
4. Aplicar uma alteração por vez.
5. Medir novamente.
6. Comparar os resultados.
7. Justificar se a otimização trouxe benefício real.

---

## 10. Testes independentes

Além das atividades e dos desafios, o instrutor poderá aplicar testes não apresentados previamente.

Os testes independentes deverão avaliar se o aluno consegue transferir o conhecimento para situações diferentes.

Exemplos de situações:

- Inserção com combinação de DEFAULT e NULL.
- Atualização condicionada por dados de outra tabela.
- Exclusão bloqueada por FK.
- UPSERT com constraint composta.
- Recuperação parcial de transação.
- Falha em uma transação após uma operação válida.
- Duas sessões disputando o mesmo registro.
- Comparação entre READ COMMITTED e REPEATABLE READ.
- Falha de serialização.
- Investigação de deadlock.
- Análise de desempenho de um lote de inserções.

Os dados utilizados deverão ser controlados e independentes do banco principal.

---

## 11. Códigos de erro importantes

O aluno deverá reconhecer os principais códigos de erro utilizados nos testes.

| Código SQLSTATE | Significado |
|---|---|
| 23502 | Violação de NOT NULL |
| 23503 | Violação de FOREIGN KEY |
| 23505 | Violação de UNIQUE |
| 23514 | Violação de CHECK |
| 25P02 | Transação já está em estado de erro |
| 40001 | Falha de serialização |
| 40P01 | Deadlock detectado |

A avaliação não exige memorização isolada dos códigos, mas exige capacidade de interpretar os erros e identificar suas causas.

---

## 12. Critérios de avaliação

A avaliação do módulo seguirá os mesmos pesos gerais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### Nota mínima

A nota de referência para aprovação é de **85%**.

Atingir a nota não será suficiente quando houver erros críticos.

### Erros críticos

São considerados erros críticos:

- Alterar permanentemente o banco principal sem autorização.
- Executar operações destrutivas fora do laboratório.
- Não compreender o impacto de UPDATE ou DELETE sem WHERE.
- Ignorar violações de integridade.
- Confirmar uma transação sem validar o resultado quando a validação é exigida.
- Não compreender o comportamento de ROLLBACK.
- Produzir atualizações inconsistentes sob concorrência.
- Não reconhecer falhas de serialização ou deadlocks.
- Apresentar uma otimização sem comprovar sua eficácia.

---

## 13. Liberação do próximo módulo

O Módulo 10 será considerado concluído quando o aluno demonstrar domínio suficiente dos seguintes grupos:

- DML: INSERT, UPDATE e DELETE.
- UPSERT e constraints.
- Transações e SAVEPOINT.
- Propriedades ACID.
- MVCC e concorrência.
- Bloqueios e níveis de isolamento.
- Desempenho de operações DML.
- Segurança e preservação de dados.

Após a aprovação, o aluno estará apto a avançar para:

**Módulo 11 — Modelagem e Objetos do Banco de Dados.**

---

## 14. Registro de progresso

Preencher ao concluir a avaliação.

| Indicador | Resultado |
|---|---|
| Validações concluídas | |
| Desafios concluídos | |
| Testes independentes | |
| Nota final | |
| Erros críticos | |
| Pontos de reforço | |
| Status | Pendente |

### Status possíveis

- Pendente: avaliação ainda não realizada.
- Em andamento: validações parcialmente concluídas.
- Em revisão: existem lacunas que precisam de reforço.
- Aprovado: critérios atendidos e nota mínima alcançada.
- Reprovado: critérios mínimos não atendidos.

---

## 15. Documentação oficial

Referências para consulta durante a validação:

- PostgreSQL 16 — INSERT: https://www.postgresql.org/docs/16/sql-insert.html
- PostgreSQL 16 — UPDATE: https://www.postgresql.org/docs/16/sql-update.html
- PostgreSQL 16 — DELETE: https://www.postgresql.org/docs/16/sql-delete.html
- PostgreSQL 16 — MERGE: https://www.postgresql.org/docs/16/sql-merge.html
- PostgreSQL 16 — Transactions: https://www.postgresql.org/docs/16/tutorial-transactions.html
- PostgreSQL 16 — Transaction Isolation: https://www.postgresql.org/docs/16/transaction-iso.html
- PostgreSQL 16 — Explicit Locking: https://www.postgresql.org/docs/16/explicit-locking.html
- PostgreSQL 16 — EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html

---

## 16. Encerramento

A conclusão deste módulo representa a transição do uso de SQL predominantemente voltado à consulta para a manipulação controlada e segura de dados.

O aluno deverá demonstrar não apenas que sabe executar comandos, mas que compreende seus efeitos sobre integridade, concorrência, consistência e desempenho.

**O banco de dados deve permanecer íntegro antes, durante e depois de qualquer operação.**