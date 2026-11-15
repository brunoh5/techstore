# Módulo 10 — DML e Transações

# 1. Introdução à manipulação de dados

Até agora, trabalhamos principalmente com consultas para recuperar, filtrar, organizar e analisar informações.

Neste módulo, começaremos a trabalhar com operações capazes de modificar os dados armazenados no banco.

Essas operações fazem parte da linguagem SQL e são fundamentais para qualquer sistema que precise cadastrar, atualizar ou remover informações.

Imagine alguns cenários do TechStore:

- Um novo produto precisa ser cadastrado.
- O preço de um produto foi alterado.
- Um cliente atualizou seus dados.
- Um pedido teve seu status modificado.
- Uma movimentação de estoque precisa ser registrada.
- Um registro precisa ser removido.

Todos esses cenários envolvem manipulação de dados.

Entretanto, existe uma diferença importante entre executar uma consulta e executar uma operação de escrita.

Uma consulta normalmente recupera informações. Uma operação de escrita pode alterar permanentemente o estado do banco.

Por isso, neste módulo, aprenderemos não apenas a sintaxe, mas também como controlar, validar e proteger essas operações.

# 2. Classificação dos comandos SQL

SQL possui diferentes categorias de comandos.

As principais são:

| Categoria | Significado | Finalidade |
|---|---|---|
| DQL | Data Query Language | Consultar dados |
| DML | Data Manipulation Language | Manipular dados |
| DDL | Data Definition Language | Definir estruturas |
| DCL | Data Control Language | Controlar permissões |
| TCL | Transaction Control Language | Controlar transações |

## 2.1. DQL

DQL representa operações de consulta.

O principal comando é:

```sql
SELECT
```

Exemplo:

```sql
SELECT
    id,
    nome,
    preco
FROM techstore.produtos;
```

Essa operação recupera informações sem modificar os registros.

## 2.2. DML

DML representa operações de manipulação de dados.

Seus principais comandos são:

- INSERT: inserir registros.
- UPDATE: atualizar registros.
- DELETE: remover registros.
- MERGE: realizar operações condicionais de inserção, atualização ou exclusão, quando aplicável.

No PostgreSQL também temos recursos como UPSERT, implementado por meio de INSERT ... ON CONFLICT.

## 2.3. DDL

DDL representa operações de definição da estrutura do banco.

Exemplos:

- CREATE.
- ALTER.
- DROP.
- TRUNCATE.

Esses comandos não devem ser confundidos com operações comuns de manipulação de registros.

## 2.4. TCL

TCL representa o controle de transações.

Principais comandos:

- BEGIN.
- COMMIT.
- ROLLBACK.
- SAVEPOINT.
- RELEASE SAVEPOINT.

Esses comandos permitem controlar quando as alterações são confirmadas ou descartadas.

# 3. INSERT — Inserindo registros

INSERT é utilizado para adicionar novos registros a uma tabela.

Sua estrutura básica é:

```sql
INSERT INTO tabela (
    coluna1,
    coluna2
)
VALUES (
    valor1,
    valor2
);
```

A lista de colunas define a correspondência entre os valores e os campos da tabela.

## 3.1. Inserindo um registro

Exemplo conceitual:

```sql
INSERT INTO tabela_exemplo (
    nome,
    ativo
)
VALUES (
    'Produto demonstrativo',
    TRUE
);
```

O banco cria um novo registro com os valores informados.

As colunas não informadas precisam permitir um valor padrão, NULL ou possuir algum mecanismo de preenchimento automático.

## 3.2. Inserindo múltiplos registros

É possível inserir várias linhas em uma única instrução.

```sql
INSERT INTO tabela_exemplo (
    nome,
    ativo
)
VALUES
    ('Produto A', TRUE),
    ('Produto B', TRUE),
    ('Produto C', FALSE);
```

Essa abordagem reduz a quantidade de instruções necessárias.

Entretanto, o tamanho adequado de um lote depende do volume de dados, memória disponível, índices, constraints e custo da operação.

## 3.3. DEFAULT

DEFAULT permite utilizar o valor padrão definido para uma coluna.

```sql
INSERT INTO tabela_exemplo (
    nome,
    ativo
)
VALUES (
    'Produto demonstrativo',
    DEFAULT
);
```

Também é possível omitir uma coluna da lista de inserção para que seu valor padrão seja aplicado.

Se não existir um DEFAULT, o comportamento dependerá das demais restrições da coluna.

## 3.4. NULL

NULL representa ausência de valor conhecido.

Não é equivalente a:

- Zero.
- Texto vazio.
- FALSE.
- Uma string contendo a palavra NULL.

Exemplo:

```sql
INSERT INTO tabela_exemplo (
    nome,
    descricao
)
VALUES (
    'Produto demonstrativo',
    NULL
);
```

A operação somente será permitida se a coluna aceitar NULL.

## 3.5. INSERT INTO ... SELECT

Também podemos inserir registros utilizando o resultado de outra consulta.

```sql
INSERT INTO tabela_destino (
    codigo,
    descricao
)
SELECT
    codigo,
    descricao
FROM tabela_origem;
```

Esse recurso é útil para:

- Copiar informações.
- Criar tabelas auxiliares previamente existentes.
- Consolidar dados.
- Migrar registros.
- Popular estruturas de apoio.

A quantidade e os tipos das colunas retornadas pelo SELECT precisam ser compatíveis com as colunas de destino.

## 3.6. RETURNING

PostgreSQL permite recuperar informações dos registros inseridos sem executar uma segunda consulta.

```sql
INSERT INTO tabela_exemplo (
    nome,
    ativo
)
VALUES (
    'Produto demonstrativo',
    TRUE
)
RETURNING *;
```

Também podemos retornar somente determinadas colunas.

```sql
INSERT INTO tabela_exemplo (
    nome,
    ativo
)
VALUES (
    'Produto demonstrativo',
    TRUE
)
RETURNING id, nome;
```

RETURNING é especialmente útil quando uma inserção gera um identificador automaticamente.

**Ponto importante:** receber um resultado de RETURNING não significa necessariamente que a transação foi confirmada. Se a operação estiver dentro de uma transação ainda aberta, ela poderá ser desfeita com ROLLBACK.

# 4. UPDATE — Atualizando registros

UPDATE modifica registros existentes.

Estrutura:

```sql
UPDATE tabela
SET coluna = valor
WHERE condicao;
```

## 4.1. Atualização simples

Exemplo conceitual:

```sql
UPDATE tabela_exemplo
SET nome = 'Novo nome'
WHERE id = 10;
```

A condição identifica quais registros serão modificados.

## 4.2. Atualizando múltiplas colunas

```sql
UPDATE tabela_exemplo
SET
    nome = 'Novo nome',
    ativo = FALSE
WHERE id = 10;
```

Uma única operação pode atualizar diversas colunas do mesmo conjunto de registros.

## 4.3. Atualização utilizando expressões

É possível utilizar o valor atual da própria coluna.

```sql
UPDATE tabela_exemplo
SET quantidade = quantidade + 10
WHERE id = 10;
```

Isso permite realizar cálculos diretamente no banco.

Outras possibilidades incluem:

- Multiplicações.
- Subtrações.
- Expressões CASE.
- Funções SQL.
- Conversões de tipos.
- Operações condicionais.

## 4.4. UPDATE sem WHERE

Um dos erros mais perigosos em DML é esquecer a condição WHERE.

Exemplo:

```sql
UPDATE tabela_exemplo
SET ativo = FALSE;
```

Essa operação modifica todos os registros da tabela.

Não existe uma proteção automática que impeça esse comportamento.

Por isso, antes de atualizar dados, devemos identificar o conjunto de registros que será afetado.

Uma prática importante é executar primeiro uma consulta SELECT utilizando exatamente a condição que será utilizada no UPDATE.

## 4.5. UPDATE ... FROM

PostgreSQL permite atualizar registros utilizando informações de outras tabelas.

```sql
UPDATE tabela_destino AS d
SET descricao = o.descricao
FROM tabela_origem AS o
WHERE o.codigo = d.codigo;
```

Esse recurso é útil para atualizações baseadas em relacionamentos.

É necessário garantir que o relacionamento utilizado não produza múltiplas correspondências para a mesma linha de destino.

Quando várias linhas da origem correspondem a uma linha de destino, o resultado escolhido pode não ser previsível.

## 4.6. UPDATE com subconsulta

Também podemos utilizar subconsultas para determinar os valores de atualização.

Exemplo conceitual:

```sql
UPDATE tabela_exemplo
SET categoria_id = (
    SELECT categoria_id
    FROM tabela_referencia
    WHERE tabela_referencia.id = 10
)
WHERE id = 20;
```

Uma subconsulta utilizada como expressão escalar precisa retornar no máximo uma linha.

Se retornar mais de uma linha, o PostgreSQL produzirá um erro.

## 4.7. RETURNING no UPDATE

É possível recuperar os registros modificados.

```sql
UPDATE tabela_exemplo
SET ativo = FALSE
WHERE id = 10
RETURNING id, nome, ativo;
```

No PostgreSQL também é possível utilizar as referências OLD e NEW para comparar valores anteriores e posteriores em versões que oferecem esse recurso.

No PostgreSQL 16, o RETURNING convencional permite retornar os valores resultantes da atualização, mas não oferece a sintaxe geral OLD/NEW disponível em versões posteriores.

# 5. DELETE — Removendo registros

DELETE remove registros de uma tabela.

Estrutura:

```sql
DELETE FROM tabela
WHERE condicao;
```

## 5.1. Exclusão específica

```sql
DELETE FROM tabela_exemplo
WHERE id = 10;
```

Somente os registros que atendem à condição serão removidos.

## 5.2. DELETE sem WHERE

```sql
DELETE FROM tabela_exemplo;
```

Essa operação remove todos os registros da tabela.

A estrutura da tabela permanece existente.

Esse comportamento é diferente de DROP TABLE.

## 5.3. DELETE com subconsulta

É possível utilizar uma subconsulta para identificar os registros que serão removidos.

```sql
DELETE FROM tabela_exemplo
WHERE categoria_id IN (
    SELECT id
    FROM tabela_categorias
    WHERE ativo = FALSE
);
```

A subconsulta determina quais registros atendem à condição.

## 5.4. DELETE ... USING

PostgreSQL permite utilizar outra tabela como referência para a exclusão.

```sql
DELETE FROM tabela_destino AS d
USING tabela_origem AS o
WHERE d.codigo = o.codigo;
```

A operação remove os registros da tabela indicada após DELETE que correspondem à condição estabelecida.

## 5.5. RETURNING no DELETE

Podemos identificar os registros removidos.

```sql
DELETE FROM tabela_exemplo
WHERE id = 10
RETURNING *;
```

Esse recurso é útil para auditoria, conferência e validação de operações.

## 5.6. Chaves estrangeiras e DELETE

Uma exclusão pode ser impedida por relacionamentos com outras tabelas.

Considere:

- Uma tabela de clientes.
- Uma tabela de pedidos.
- Uma chave estrangeira de pedidos apontando para clientes.

Se um cliente possui pedidos relacionados, a exclusão pode ser bloqueada.

O comportamento depende da configuração da chave estrangeira.

Principais opções:

| Ação | Comportamento |
|---|---|
| NO ACTION | Impede a operação quando a restrição não é satisfeita |
| RESTRICT | Impede a exclusão quando existem dependências |
| CASCADE | Propaga a exclusão para registros relacionados |
| SET NULL | Define a referência como NULL |
| SET DEFAULT | Define a referência como DEFAULT |

CASCADE exige atenção especial porque pode remover muitos registros relacionados a partir de uma única operação.

## 5.7. DELETE, TRUNCATE e DROP

Embora os três possam remover informações, seus efeitos são diferentes.

| Comando | Efeito |
|---|---|
| DELETE | Remove registros |
| TRUNCATE | Remove todos os registros de uma tabela |
| DROP | Remove o objeto do banco |

DELETE permite utilizar WHERE.

TRUNCATE não permite selecionar registros individualmente.

DROP remove a estrutura do objeto.

No PostgreSQL, TRUNCATE é transacional, mas pode exigir bloqueios mais fortes e possui comportamento próprio em relação a triggers e identidade.

**Regra de segurança:** não utilizar DELETE sem filtro, TRUNCATE ou DROP no TechStore principal durante os estudos.

# 6. UPSERT — Inserção com tratamento de conflitos

UPSERT combina a ideia de INSERT e UPDATE.

É útil quando desejamos inserir um registro, mas precisamos tratar a situação em que ele já existe.

No PostgreSQL, esse comportamento é implementado por:

```sql
INSERT ... ON CONFLICT
```

## 6.1. ON CONFLICT DO NOTHING

Ignora a inserção quando ocorre um conflito com uma restrição ou índice único aplicável.

```sql
INSERT INTO tabela_exemplo (
    id,
    nome
)
VALUES (
    10,
    'Produto demonstrativo'
)
ON CONFLICT (id) DO NOTHING;
```

Se já existir um registro com o mesmo identificador, a inserção não será realizada.

## 6.2. ON CONFLICT DO UPDATE

Permite atualizar o registro existente quando ocorre um conflito.

```sql
INSERT INTO tabela_exemplo (
    id,
    nome
)
VALUES (
    10,
    'Novo nome'
)
ON CONFLICT (id)
DO UPDATE SET
    nome = EXCLUDED.nome;
```

EXCLUDED representa os valores que seriam inseridos caso não houvesse conflito.

Isso permite escolher quais valores serão utilizados na atualização.

## 6.3. Condições de conflito

O PostgreSQL precisa identificar qual restrição ou índice único determina o conflito.

Podemos utilizar:

- Uma coluna com restrição UNIQUE.
- Uma chave primária.
- Um conjunto de colunas com restrição UNIQUE.
- Um índice único compatível.

Nem todo erro de INSERT é um conflito tratável por ON CONFLICT.

Por exemplo, uma violação de NOT NULL ou de uma restrição CHECK não será automaticamente resolvida por DO NOTHING.

## 6.4. Cuidados com UPSERT

UPSERT não significa que qualquer operação será segura.

Devemos avaliar:

- Quais colunas identificam o conflito.
- Quais campos serão atualizados.
- Se a atualização pode sobrescrever informações importantes.
- Se existem triggers.
- Se existem restrições adicionais.
- Como a operação se comporta sob concorrência.

# 7. Transações

Uma transação é um conjunto de operações tratado como uma unidade lógica.

Imagine que um sistema precisa realizar duas operações:

1. Registrar um pedido.
2. Registrar os itens desse pedido.

Se a primeira operação funcionar e a segunda falhar, o banco poderá ficar em um estado inconsistente caso não exista controle transacional adequado.

Uma transação permite agrupar essas operações.

O objetivo é garantir que todas sejam confirmadas ou que as alterações sejam desfeitas.

## 7.1. BEGIN

BEGIN inicia uma transação explícita.

```sql
BEGIN;
```

A partir desse ponto, as operações seguintes participam da transação até sua confirmação ou cancelamento.

## 7.2. COMMIT

COMMIT confirma as alterações realizadas.

```sql
COMMIT;
```

Depois da confirmação, as alterações passam a fazer parte do estado persistente do banco, respeitando as garantias de durabilidade configuradas.

## 7.3. ROLLBACK

ROLLBACK desfaz as alterações ainda não confirmadas da transação.

```sql
ROLLBACK;
```

É especialmente importante durante experimentações e testes.

## 7.4. Fluxo básico

Uma transação simples segue esta lógica:

```sql
BEGIN;

-- Operacoes de manipulacao de dados.

-- Consultas para validar os resultados.

COMMIT;
```

Caso algo esteja incorreto:

```sql
ROLLBACK;
```

A decisão entre COMMIT e ROLLBACK deve acontecer somente depois da validação.

## 7.5. Transações com múltiplas operações

Uma transação pode conter várias instruções.

Exemplo conceitual:

```sql
BEGIN;

-- Inserir registro principal.

-- Inserir registros relacionados.

-- Atualizar indicadores ou quantidades.

-- Validar os resultados.

COMMIT;
```

Se alguma operação falhar, podemos interromper a transação e desfazer as alterações.

No PostgreSQL, depois de determinados erros dentro de uma transação, ela entra em estado abortado. Nesse estado, comandos comuns não podem continuar sendo executados até que a transação seja desfeita ou seja realizado um rollback até um savepoint válido.

# 8. SAVEPOINT

SAVEPOINT permite criar pontos intermediários dentro de uma transação.

Isso possibilita desfazer apenas parte das operações sem cancelar necessariamente toda a transação.

## 8.1. Criando um SAVEPOINT

```sql
BEGIN;

SAVEPOINT ponto_1;
```

A transação continua aberta.

## 8.2. ROLLBACK TO SAVEPOINT

```sql
ROLLBACK TO SAVEPOINT ponto_1;
```

Desfaz as operações realizadas depois do ponto de salvamento.

As operações anteriores ao SAVEPOINT continuam dentro da transação.

## 8.3. RELEASE SAVEPOINT

```sql
RELEASE SAVEPOINT ponto_1;
```

Remove o savepoint.

Isso não confirma a transação.

O COMMIT continua sendo necessário para confirmar todas as alterações restantes.

## 8.4. Utilização prática

Imagine uma operação com três etapas:

1. Inserção de um registro principal.
2. Inserção de informações complementares.
3. Atualização de dados auxiliares.

Se a terceira etapa falhar, podemos voltar a um savepoint criado antes dela.

Isso permite preservar parte do trabalho sem abandonar toda a transação.

**Importante:** SAVEPOINT não substitui uma estratégia de validação. Ele apenas oferece controle adicional sobre o escopo do rollback.

# 9. Propriedades ACID

ACID representa quatro propriedades fundamentais das transações.

São elas:

- Atomicidade.
- Consistência.
- Isolamento.
- Durabilidade.

## 9.1. Atomicidade

Atomicidade significa que uma transação deve ser tratada como uma unidade.

Ou todas as operações são confirmadas, ou as alterações da transação são desfeitas.

Exemplo:

Um pedido depende da inserção de diversos itens.

Se uma operação obrigatória falhar, o sistema não deve confirmar parcialmente o pedido.

## 9.2. Consistência

Consistência significa que uma transação deve preservar as regras de integridade do banco.

Exemplos:

- Chaves primárias únicas.
- Chaves estrangeiras válidas.
- Campos obrigatórios preenchidos.
- Valores respeitando CHECK.
- Restrições de unicidade.

Uma transação não deve deixar o banco em um estado que viole suas restrições.

## 9.3. Isolamento

Isolamento trata do comportamento de transações concorrentes.

Duas sessões podem executar operações simultaneamente.

O banco precisa controlar a visibilidade dos dados e os conflitos entre essas operações.

O nível de isolamento determina quais fenômenos de concorrência podem ocorrer.

## 9.4. Durabilidade

Durabilidade significa que alterações confirmadas devem sobreviver a falhas, conforme as garantias oferecidas pela configuração e infraestrutura do banco.

O PostgreSQL utiliza mecanismos como WAL para permitir recuperação após falhas.

## 9.5. Resumo ACID

| Propriedade | Pergunta principal |
|---|---|
| Atomicidade | Todas as operações serão confirmadas juntas? |
| Consistência | As regras do banco serão preservadas? |
| Isolamento | Como operações concorrentes interagem? |
| Durabilidade | As alterações confirmadas serão preservadas? |

# 10. Constraints durante operações DML

Constraints são regras aplicadas aos dados.

Elas são verificadas durante operações de inserção e atualização, e também podem restringir exclusões.

## 10.1. PRIMARY KEY

Identifica unicamente cada registro.

Não permite valores duplicados nem NULL.

## 10.2. FOREIGN KEY

Garante que uma referência a outra tabela seja válida, respeitando a ação referencial configurada.

Uma inserção ou atualização pode falhar se apontar para um registro inexistente.

Uma exclusão pode ser bloqueada se houver registros dependentes.

## 10.3. UNIQUE

Impede duplicidade nos valores ou combinações de valores definidos pela restrição.

No PostgreSQL, NULL possui comportamento específico em restrições UNIQUE. Por padrão, múltiplos NULLs podem ser aceitos, pois são tratados como distintos para essa finalidade.

## 10.4. NOT NULL

Impede que uma coluna receba NULL.

## 10.5. CHECK

Define uma condição que precisa ser satisfeita pelos valores armazenados.

Exemplo conceitual:

```sql
CHECK (quantidade >= 0)
```

## 10.6. DEFAULT

Define um valor padrão quando a inserção não fornece outro valor para a coluna ou solicita explicitamente DEFAULT.

## 10.7. Constraints e transações

Uma violação de constraint pode interromper uma instrução.

Dentro de uma transação explícita, determinados erros deixam a transação em estado abortado.

É necessário compreender esse comportamento para evitar tentativas de continuar uma transação inválida.

# 11. Concorrência

Concorrência acontece quando duas ou mais transações acessam ou modificam dados ao mesmo tempo.

Exemplo:

Duas sessões tentam atualizar a quantidade de estoque do mesmo produto.

Sem controle adequado, uma operação pode interferir na outra.

O PostgreSQL utiliza mecanismos de concorrência para controlar essas situações.

## 11.1. MVCC

MVCC significa Multi-Version Concurrency Control.

É o mecanismo de controle de concorrência multiversão utilizado pelo PostgreSQL.

Em vez de depender exclusivamente de bloqueios para leituras, o PostgreSQL mantém versões de registros.

Isso permite que consultas leiam versões consistentes dos dados enquanto outras transações realizam alterações.

Principais benefícios:

- Redução de conflitos entre leitura e escrita.
- Leituras consistentes.
- Melhor concorrência.
- Controle de visibilidade das versões.

MVCC não elimina todos os bloqueios.

Operações de escrita, alterações estruturais e determinadas consultas podem adquirir locks.

## 11.2. Locks

Locks são mecanismos de bloqueio utilizados para controlar acesso concorrente.

No PostgreSQL existem diferentes modalidades de bloqueios.

Entre elas:

- Bloqueios de tabela.
- Bloqueios de linha.
- Bloqueios utilizados por comandos de leitura.
- Bloqueios utilizados por comandos de escrita.

O objetivo é preservar a consistência das operações concorrentes.

## 11.3. SELECT FOR UPDATE

SELECT FOR UPDATE permite selecionar registros e adquirir bloqueios de linha para impedir modificações concorrentes incompatíveis até o encerramento da transação.

Exemplo:

```sql
BEGIN;

SELECT
    id,
    quantidade
FROM tabela_estoque
WHERE id = 10
FOR UPDATE;

-- Operacao controlada sobre o registro.

COMMIT;
```

A linha selecionada fica bloqueada contra determinadas operações concorrentes até o encerramento da transação.

Isso é útil em cenários como:

- Atualização de estoque.
- Processamento de pedidos.
- Reserva de recursos.
- Controle de saldos.

O bloqueio deve ser mantido pelo menor tempo possível.

## 11.4. SELECT FOR SHARE

SELECT FOR SHARE também adquire bloqueios de linha, mas permite uma combinação diferente de operações concorrentes.

Ele impede modificações incompatíveis na linha enquanto permite determinados bloqueios compartilhados.

A escolha entre FOR UPDATE e FOR SHARE depende do comportamento necessário.

## 11.5. Deadlocks

Deadlock acontece quando duas ou mais transações ficam esperando umas pelas outras de maneira circular.

Exemplo:

- Transação A bloqueia o registro 1 e tenta acessar o registro 2.
- Transação B bloqueia o registro 2 e tenta acessar o registro 1.
- Ambas ficam aguardando.

O PostgreSQL possui mecanismos de detecção de deadlocks.

Quando identifica uma situação desse tipo, pode cancelar uma das transações para permitir que a outra prossiga.

Boas práticas:

- Acessar registros em uma ordem consistente.
- Manter transações curtas.
- Evitar bloqueios desnecessários.
- Tratar erros de deadlock.
- Implementar repetição controlada quando apropriado.

# 12. Níveis de isolamento

O isolamento define o comportamento de transações simultâneas.

O PostgreSQL oferece os seguintes níveis:

| Nível | Comportamento |
|---|---|
| READ UNCOMMITTED | No PostgreSQL, comporta-se como READ COMMITTED |
| READ COMMITTED | Cada comando enxerga um snapshot no início da instrução |
| REPEATABLE READ | A transação mantém um snapshot consistente |
| SERIALIZABLE | Busca garantir resultado equivalente a uma execução serial |

## 12.1. READ COMMITTED

É o nível padrão do PostgreSQL.

Cada comando enxerga os dados confirmados antes do início daquele comando.

Duas consultas dentro da mesma transação podem retornar resultados diferentes se outra transação confirmar alterações entre elas.

## 12.2. REPEATABLE READ

Mantém um snapshot consistente durante a transação.

Consultas repetidas não passam a enxergar alterações confirmadas por outras transações depois do início do snapshot.

Ainda podem ocorrer situações de concorrência que exigem tratamento específico.

## 12.3. SERIALIZABLE

É o nível mais rigoroso.

O PostgreSQL monitora dependências entre transações para impedir resultados que não poderiam ocorrer em uma execução serial equivalente.

Uma transação pode ser abortada se o sistema detectar uma anomalia de serialização.

A aplicação precisa estar preparada para repetir operações abortadas quando apropriado.

## 12.4. Definindo o isolamento

Exemplo:

```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Operacoes da transacao.

COMMIT;
```

O nível de isolamento deve ser escolhido conforme os requisitos da aplicação.

Um nível mais rigoroso não significa automaticamente melhor desempenho ou melhor arquitetura.

# 13. Segurança em operações DML

Operações de escrita precisam ser executadas com cuidado.

Um erro pode afetar milhares ou milhões de registros.

## 13.1. Validar antes de alterar

Antes de executar um UPDATE ou DELETE, identifique os registros afetados com SELECT.

Exemplo conceitual:

```sql
SELECT *
FROM tabela_exemplo
WHERE condicao;
```

Depois, avalie:

- Quantos registros serão afetados?
- Os registros correspondem ao objetivo?
- Existem dependências?
- A operação pode gerar efeitos indiretos?

## 13.2. Utilizar transações

Sempre que apropriado, execute operações relacionadas dentro de uma transação.

Isso permite revisar os resultados antes de confirmar as alterações.

## 13.3. Menor privilégio

O usuário conectado ao banco deve possuir apenas as permissões necessárias.

Não é uma boa prática utilizar uma conta administrativa para todas as operações da aplicação.

## 13.4. Evitar operações destrutivas

Durante o aprendizado, não execute operações irreversíveis ou destrutivas sem uma estratégia de recuperação.

O banco TechStore principal deve ser preservado.

## 13.5. Auditoria

Em sistemas profissionais, operações importantes podem precisar ser registradas.

Uma auditoria pode armazenar:

- Quem realizou a alteração.
- Quando ocorreu.
- Qual registro foi alterado.
- Qual era o valor anterior.
- Qual passou a ser o novo valor.
- Qual operação foi executada.

A implementação de auditoria pode envolver triggers, tabelas específicas, logs ou recursos externos.

Esses mecanismos serão aprofundados em módulos posteriores.

# 14. Desempenho de operações DML

Operações de escrita também possuem custos de execução.

## 14.1. INSERT

O custo pode envolver:

- Escrita da nova linha.
- Atualização de índices.
- Verificação de constraints.
- Verificação de chaves estrangeiras.
- Geração de WAL.
- Execução de triggers.

Inserções em lote podem ser mais eficientes do que executar milhares de instruções individuais.

## 14.2. UPDATE

Uma atualização pode exigir:

- Localização dos registros.
- Verificação de condições.
- Criação de novas versões das linhas.
- Atualização de índices quando necessário.
- Geração de WAL.
- Verificação de constraints.

No PostgreSQL, UPDATE normalmente cria uma nova versão da linha em vez de sobrescrever diretamente a versão anterior.

Esse comportamento está relacionado ao MVCC.

## 14.3. DELETE

DELETE precisa localizar os registros e marcar suas versões como removidas.

As versões antigas não são necessariamente removidas imediatamente do armazenamento.

O VACUUM participa da limpeza e reutilização do espaço associado a versões que já não são necessárias.

## 14.4. Índices e DML

Índices melhoram determinadas operações de leitura, mas possuem custos nas operações de escrita.

Uma inserção pode exigir a atualização de diversos índices.

Uma atualização que modifica colunas indexadas pode exigir manutenção desses índices.

Uma exclusão também precisa manter as estruturas de indexação consistentes.

Portanto, criar índices indiscriminadamente pode prejudicar o desempenho de escrita.

## 14.5. WAL

WAL significa Write-Ahead Logging.

É o mecanismo de registro de alterações utilizado pelo PostgreSQL.

Antes que alterações correspondentes sejam consideradas persistidas nos arquivos de dados, os registros necessários do WAL precisam ser gravados de acordo com as garantias de durabilidade configuradas.

WAL é importante para:

- Recuperação após falhas.
- Consistência do banco.
- Replicação física.
- Recuperação point-in-time quando configurada.

# 15. EXPLAIN e operações de escrita

EXPLAIN permite analisar o plano de execução de comandos.

No PostgreSQL, podemos analisar operações de escrita com EXPLAIN.

Exemplo:

```sql
EXPLAIN
UPDATE tabela_exemplo
SET ativo = FALSE
WHERE id = 10;
```

Esse comando apresenta o plano sem executar a operação de atualização.

## 15.1. EXPLAIN ANALYZE

EXPLAIN ANALYZE executa a instrução para medir seu comportamento real.

Exemplo:

```sql
EXPLAIN ANALYZE
UPDATE tabela_exemplo
SET ativo = FALSE
WHERE id = 10;
```

**ATENÇÃO:** diferentemente do EXPLAIN simples, EXPLAIN ANALYZE executa a operação.

Isso significa que um UPDATE ou DELETE analisado pode realmente modificar os dados.

Se estiver dentro de uma transação controlada, podemos desfazer as alterações com ROLLBACK.

Exemplo conceitual:

```sql
BEGIN;

EXPLAIN ANALYZE
UPDATE tabela_exemplo
SET ativo = FALSE
WHERE id = 10;

ROLLBACK;
```

Esse padrão pode ser utilizado para estudar o custo de operações de escrita sem manter suas alterações.

Ainda assim, a execução pode consumir recursos, adquirir bloqueios, gerar WAL e acionar triggers.

O ROLLBACK não elimina necessariamente todos os efeitos operacionais da execução.

# 16. Erros frequentes

## 16.1. UPDATE sem WHERE

**Problema:** atualização de todos os registros.

**Prevenção:** validar a condição com SELECT antes de executar.

## 16.2. DELETE sem WHERE

**Problema:** remoção de todos os registros.

**Prevenção:** verificar o conjunto de registros e utilizar transação quando apropriado.

## 16.3. Violação de chave estrangeira

**Problema:** inserir ou atualizar uma referência inexistente, ou remover um registro que possui dependências.

**Prevenção:** compreender os relacionamentos e as ações referenciais.

## 16.4. Violação de UNIQUE

**Problema:** tentar inserir ou atualizar um valor que já existe em uma restrição de unicidade.

**Prevenção:** validar as chaves e compreender o uso de ON CONFLICT.

## 16.5. Transação esquecida aberta

**Problema:** manter uma transação aberta por muito tempo.

Consequências possíveis:

- Bloqueios prolongados.
- Retenção de versões antigas de registros.
- Consumo de recursos.
- Dificuldade para outras sessões trabalharem.

**Prevenção:** finalizar transações com COMMIT ou ROLLBACK.

## 16.6. Confundir SAVEPOINT com COMMIT

SAVEPOINT não confirma alterações.

Ele apenas cria um ponto de recuperação dentro da transação.

## 16.7. Confundir RETURNING com confirmação

RETURNING mostra o resultado da instrução.

Não confirma automaticamente a transação.

## 16.8. Ignorar concorrência

Uma operação que parece segura isoladamente pode apresentar problemas quando outras sessões trabalham simultaneamente.

**Prevenção:** compreender locks, MVCC e níveis de isolamento.

# 17. Boas práticas profissionais

1. Conheça a estrutura da tabela antes de realizar alterações.
2. Identifique as constraints relevantes.
3. Valide registros antes de UPDATE e DELETE.
4. Utilize transações para operações relacionadas.
5. Mantenha transações curtas.
6. Evite bloqueios desnecessários.
7. Utilize RETURNING para conferir alterações.
8. Trate conflitos de unicidade corretamente.
9. Não dependa exclusivamente da validação feita pela aplicação.
10. Preserve integridade referencial.
11. Utilize permissões adequadas.
12. Evite operações destrutivas sem estratégia de recuperação.
13. Analise o custo das operações.
14. Considere o impacto de índices e triggers.
15. Registre operações importantes quando necessário.

# 18. Referência rápida

| Comando | Finalidade |
|---|---|
| INSERT | Inserir registros |
| UPDATE | Atualizar registros |
| DELETE | Remover registros |
| ON CONFLICT | Tratar conflitos de unicidade |
| RETURNING | Retornar dados afetados |
| BEGIN | Iniciar transação |
| COMMIT | Confirmar transação |
| ROLLBACK | Desfazer transação |
| SAVEPOINT | Criar ponto intermediário |
| ROLLBACK TO | Voltar a um savepoint |
| RELEASE SAVEPOINT | Remover um savepoint |
| SELECT FOR UPDATE | Bloquear linhas para atualização |
| EXPLAIN | Analisar plano |
| EXPLAIN ANALYZE | Executar e analisar plano |

# 19. Resultados esperados

Ao concluir a teoria e as atividades, você deverá dominar:

- Classificação dos comandos SQL.
- Inserção de registros.
- Atualização de registros.
- Exclusão controlada.
- UPSERT.
- RETURNING.
- Transações.
- SAVEPOINT.
- Propriedades ACID.
- Constraints.
- Concorrência.
- MVCC.
- Locks.
- Deadlocks.
- Níveis de isolamento.
- Segurança de operações DML.
- Análise de desempenho.

O objetivo é alcançar domínio suficiente para realizar operações de escrita em ambientes reais sem comprometer a integridade dos dados.

# 20. Documentação oficial

Referências recomendadas para aprofundamento:

- INSERT: https://www.postgresql.org/docs/16/sql-insert.html
- UPDATE: https://www.postgresql.org/docs/16/sql-update.html
- DELETE: https://www.postgresql.org/docs/16/sql-delete.html
- MERGE: https://www.postgresql.org/docs/16/sql-merge.html
- Transactions: https://www.postgresql.org/docs/16/tutorial-transactions.html
- Transaction Isolation: https://www.postgresql.org/docs/16/transaction-iso.html
- Explicit Locking: https://www.postgresql.org/docs/16/explicit-locking.html
- MVCC: https://www.postgresql.org/docs/16/mvcc-intro.html
- WAL: https://www.postgresql.org/docs/16/wal-intro.html
- EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html

---

**Fim da teoria do Módulo 10.**