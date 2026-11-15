# Módulo 01 — Fundamentos e domínio do ambiente PostgreSQL

# Material teórico

**Formação:** SQL e PostgreSQL — TechStore  
**Módulo:** 01 — Fundamentos e domínio do ambiente PostgreSQL  
**Nível:** Profissional  
**Banco de dados:** PostgreSQL 16

---

# Sumário

1. Fundamentos de bancos de dados relacionais
2. Arquitetura e funcionamento do PostgreSQL
3. Estrutura de tabelas
4. Tipos de dados
5. Chaves e relacionamentos
6. Constraints
7. pgAdmin e exploração do banco
8. Catálogos e metadados do PostgreSQL
9. Glossário técnico
10. Referências oficiais

---

# 1. Fundamentos de bancos de dados relacionais

## 1.1. O que é um banco de dados?

Um banco de dados é uma estrutura organizada para armazenar, consultar, modificar e administrar informações.

Aplicações utilizam bancos de dados para preservar informações importantes durante seu funcionamento.

Em um sistema de e-commerce, por exemplo, podemos armazenar:

- Clientes.
- Produtos.
- Pedidos.
- Pagamentos.
- Estoque.
- Entregas.
- Avaliações.

Sem uma estrutura adequada de armazenamento, seria difícil manter essas informações organizadas, relacionadas e consistentes.

Um banco de dados não é simplesmente um arquivo com informações. É um ambiente estruturado que permite armazenar e administrar dados de maneira controlada.

## 1.2. O que é um SGBD?

SGBD significa Sistema Gerenciador de Banco de Dados.

É o software responsável por administrar os bancos de dados.

Entre suas responsabilidades estão:

- Armazenamento de informações.
- Processamento de consultas.
- Controle de acesso.
- Gerenciamento de transações.
- Controle de concorrência.
- Integridade dos dados.
- Recuperação após falhas.
- Administração de estruturas.

O PostgreSQL é um SGBD relacional.

Outros exemplos são:

- MySQL.
- MariaDB.
- Microsoft SQL Server.
- Oracle Database.
- SQLite.

Cada sistema possui características próprias, embora muitos compartilhem conceitos e sintaxes SQL.

## 1.3. Banco relacional e não relacional

Os bancos relacionais organizam os dados em estruturas como tabelas, compostas por linhas e colunas.

Os relacionamentos entre tabelas são estabelecidos por meio de chaves e regras de integridade.

Exemplo conceitual:

**Tabela clientes**

| id | nome | email |
|---:|---|---|
| 1 | Ana | ana@email.com |
| 2 | Carlos | carlos@email.com |
| 3 | Maria | maria@email.com |

**Tabela pedidos**

| id | cliente_id | valor |
|---:|---:|---:|
| 101 | 1 | 250.00 |
| 102 | 2 | 180.00 |
| 103 | 1 | 320.00 |

A coluna `cliente_id` permite relacionar cada pedido ao cliente correspondente.

Já os bancos não relacionais, frequentemente chamados de NoSQL, podem utilizar estruturas diferentes, como:

- Documentos.
- Chave-valor.
- Grafos.
- Colunas distribuídas.

Exemplos incluem MongoDB, Redis e Neo4j.

A escolha entre relacional e não relacional depende das características da aplicação, do modelo dos dados e dos requisitos operacionais.

**Importante:** NoSQL não significa ausência de estrutura ou ausência de relacionamentos. Significa que o modelo de organização e consulta não segue necessariamente o modelo relacional tradicional.

## 1.4. O modelo relacional

O modelo relacional organiza os dados por meio de relações, normalmente representadas por tabelas.

Cada tabela representa um conjunto de informações de determinada entidade ou assunto.

Exemplos na TechStore:

| Tabela | Representação |
|---|---|
| clientes | Clientes cadastrados |
| produtos | Produtos comercializados |
| pedidos | Pedidos realizados |
| pagamentos | Pagamentos registrados |
| categorias | Categorias de produtos |
| estoque | Quantidades disponíveis |

Uma tabela possui:

- Nome.
- Colunas.
- Tipos de dados.
- Restrições.
- Registros.

As tabelas podem se relacionar para representar situações mais complexas.

Por exemplo, um cliente pode realizar vários pedidos, e cada pedido pode conter vários itens.

Essa organização evita a necessidade de repetir todas as informações do cliente em cada registro de pedido.

## 1.5. Linhas, colunas e valores

Considere uma tabela de produtos:

| id | nome | preco | ativo |
|---:|---|---:|---|
| 1 | Notebook | 4500.00 | true |
| 2 | Mouse | 120.00 | true |
| 3 | Teclado | 250.00 | false |

Nesse exemplo:

- A tabela representa produtos.
- Cada linha representa um registro.
- Cada coluna representa um atributo.
- Cada célula contém um valor.

O `id` identifica um produto.

O `nome` armazena sua descrição.

O `preco` representa seu valor.

O `ativo` informa se está disponível para comercialização, conforme a regra definida pela aplicação.

## 1.6. Integridade dos dados

Integridade significa manter os dados corretos, consistentes e de acordo com as regras estabelecidas.

Exemplos:

- Um pedido não deve apontar para um cliente inexistente.
- Um produto não deve possuir um identificador duplicado.
- Uma quantidade de estoque não deve assumir valores proibidos pela regra de negócio.
- Um e-mail que deve ser único não deve aparecer repetido.

O PostgreSQL oferece mecanismos para implementar essas regras.

Entre eles estão:

- PRIMARY KEY.
- FOREIGN KEY.
- UNIQUE.
- NOT NULL.
- CHECK.
- DEFAULT.

Esses mecanismos serão estudados em profundidade nos temas seguintes.

## 1.7. Quando utilizar bancos relacionais?

São especialmente adequados quando existe necessidade de:

- Estruturas bem definidas.
- Relacionamentos entre entidades.
- Integridade referencial.
- Transações.
- Consultas envolvendo várias tabelas.
- Consistência dos dados.

Um sistema de e-commerce é um exemplo natural de aplicação relacional, pois clientes, produtos, pedidos e pagamentos possuem relações importantes entre si.

---

# 2. Arquitetura e funcionamento do PostgreSQL

## 2.1. O que é PostgreSQL?

O PostgreSQL é um SGBD objeto-relacional de código aberto.

Ele oferece:

- SQL.
- Transações.
- Integridade referencial.
- Controle de concorrência.
- Índices.
- Views.
- Funções.
- Procedures.
- Triggers.
- JSON e JSONB.
- Recursos de extensibilidade.

É utilizado em aplicações pequenas, sistemas corporativos e plataformas de grande escala.

Neste curso utilizaremos PostgreSQL 16.

## 2.2. Arquitetura cliente-servidor

O PostgreSQL utiliza uma arquitetura cliente-servidor.

Isso significa que um cliente envia solicitações ao servidor, e o servidor processa essas solicitações.

Exemplos de clientes:

- pgAdmin.
- psql.
- Aplicações Node.js.
- Aplicações Python.
- Sistemas Java.
- Ferramentas de BI.

No ambiente TechStore, temos:

1. PostgreSQL executando dentro de um container Docker.
2. Uma porta disponibilizada pelo Docker.
3. pgAdmin executando no computador.
4. Uma conexão estabelecida entre o pgAdmin e o PostgreSQL.

Fluxo simplificado:

```text
pgAdmin
   |
   | Conexão SQL
   |
   v
Docker
   |
   v
PostgreSQL
   |
   v
Database TechStore
   |
   v
Schemas e tabelas
```

O pgAdmin não é o banco de dados. Ele é uma ferramenta cliente que permite administrar e consultar o servidor.

## 2.3. O que acontece quando executamos uma consulta?

Quando um cliente envia uma consulta SQL, o PostgreSQL precisa processá-la.

De forma simplificada, o fluxo envolve:

1. Recebimento da solicitação.
2. Análise sintática e semântica.
3. Reescrita da consulta quando aplicável.
4. Planejamento e otimização.
5. Execução do plano.
6. Retorno dos resultados ao cliente.

### Análise

O PostgreSQL verifica se a instrução possui sintaxe válida e se os objetos e operações utilizados são reconhecidos.

### Planejamento

O PostgreSQL avalia alternativas para executar a consulta.

Por exemplo, pode considerar:

- Leitura sequencial de uma tabela.
- Utilização de um índice.
- Diferentes estratégias de JOIN.
- Ordenação.
- Agregação.

O objetivo do planner é escolher um plano com custo estimado adequado.

### Execução

O executor realiza as operações determinadas pelo plano.

Os resultados são enviados ao cliente.

O funcionamento interno será aprofundado nos módulos de EXPLAIN e otimização.

## 2.4. Database cluster

No PostgreSQL, o termo cluster possui um significado específico.

Um database cluster é a coleção de bancos de dados administrados por uma mesma instância do servidor PostgreSQL e armazenados em um diretório de dados.

Não deve ser confundido com um conjunto de servidores distribuídos.

Um único database cluster pode conter vários bancos de dados.

Exemplo:

```text
Instância PostgreSQL
│
├── Database: techstore
├── Database: financeiro
└── Database: laboratorio
```

Esses bancos compartilham a mesma instância do servidor, mas possuem suas próprias estruturas de banco.

## 2.5. Database

Um database é uma unidade lógica que contém objetos relacionados.

Dentro dele podemos encontrar:

- Schemas.
- Tabelas.
- Views.
- Índices.
- Functions.
- Procedures.
- Sequences.
- Outros objetos.

No nosso laboratório, o database principal é `techstore`.

## 2.6. Schema

Um schema é uma estrutura lógica utilizada para organizar objetos dentro de um database.

É possível possuir vários schemas dentro do mesmo banco.

Exemplo:

```text
Database: techstore
│
├── Schema: public
│
├── Schema: vendas
│
├── Schema: estoque
│
└── Schema: auditoria
```

Uma tabela pertence a um schema.

O nome completo de uma tabela pode ser representado assim:

```sql
schema.tabela
```

Exemplo:

```sql
techstore.clientes
```

Nesse exemplo, `techstore` representa o schema e `clientes` representa a tabela.

A distinção entre database e schema é importante: database é uma unidade de banco de dados; schema é uma estrutura de organização de objetos dentro dele.

## 2.7. Schema search_path

O PostgreSQL possui o parâmetro `search_path`, que determina em quais schemas procura objetos quando seus nomes são utilizados sem qualificação.

Exemplo:

```sql
SHOW search_path;
```

Se uma tabela for acessada sem informar o schema, o PostgreSQL procurará conforme a ordem definida no `search_path`.

Isso pode ser útil, mas também pode gerar ambiguidades quando existem objetos com nomes iguais em schemas diferentes.

Para consultas profissionais e ambientes com vários schemas, é importante compreender quando utilizar nomes totalmente qualificados.

## 2.8. Armazenamento lógico e físico

É importante diferenciar a organização lógica dos dados de sua representação física.

Organização lógica:

- Database.
- Schema.
- Tabela.
- Coluna.
- Registro.
- Índice.

Organização física:

- Diretório de dados.
- Arquivos de relação.
- Arquivos de índices.
- WAL.
- Estruturas internas de armazenamento.

O PostgreSQL administra essas estruturas internamente.

O estudante não deve manipular diretamente os arquivos internos do banco.

No ambiente Docker da TechStore, o volume persistente é responsável por preservar os dados mesmo quando o container é recriado.

## 2.9. Processos e memória

O PostgreSQL utiliza processos e estruturas de memória para administrar conexões e executar operações.

Alguns conceitos importantes:

- Processos do servidor.
- Processos de backend.
- Shared Buffers.
- Work Memory.
- WAL Buffers.
- Background Writer.
- Checkpointer.
- Autovacuum.

Esses componentes serão aprofundados em módulos de desempenho e administração.

Neste primeiro contato, o objetivo é compreender que o PostgreSQL possui mecanismos próprios para administrar memória, armazenamento, conexões e operações.

---

# 3. Estrutura de tabelas

## 3.1. O que é uma tabela?

Uma tabela é uma estrutura que organiza informações em linhas e colunas.

Na TechStore, a tabela `clientes` armazena informações dos clientes cadastrados.

A tabela `produtos` armazena informações dos produtos.

A tabela `pedidos` registra os pedidos realizados.

Cada tabela possui uma finalidade específica.

## 3.2. Colunas

Uma coluna representa um atributo de uma tabela.

Exemplo:

```text
clientes
│
├── id
├── nome
├── email
├── telefone
└── data_cadastro
```

Cada coluna possui características próprias, incluindo:

- Nome.
- Tipo de dado.
- Possibilidade de receber NULL.
- Valor padrão.
- Restrições.
- Participação em chaves.

## 3.3. Registros

Um registro representa uma linha da tabela.

Exemplo:

| id | nome | email |
|---:|---|---|
| 1 | Ana | ana@email.com |
| 2 | Carlos | carlos@email.com |

Cada linha representa um cliente.

Uma tabela pode conter poucos registros ou milhões de registros.

A TechStore possui tabelas com milhões de linhas, o que permitirá estudar consultas em volumes significativos de dados.

## 3.4. Esquema de uma tabela

O esquema de uma tabela representa sua definição estrutural.

Por exemplo:

```sql
CREATE TABLE exemplo (
    id BIGINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);
```

Esse exemplo define:

- Uma tabela chamada `exemplo`.
- Uma coluna `id` do tipo BIGINT.
- Uma chave primária.
- Uma coluna `nome` com limite de tamanho.
- Uma restrição NOT NULL.
- Uma coluna booleana com valor padrão TRUE.

A definição da tabela não é a mesma coisa que seus registros.

Uma tabela pode existir sem possuir nenhuma linha.

## 3.5. NULL e ausência de valor

NULL representa a ausência de um valor conhecido ou aplicável.

Não significa necessariamente:

- Zero.
- Texto vazio.
- FALSE.
- Espaço em branco.

Exemplo conceitual:

Um cliente pode não possuir telefone cadastrado.

Nesse caso, a coluna pode conter NULL, caso a definição da tabela permita.

NULL possui regras próprias de comparação e tratamento, que serão estudadas no módulo de SELECT e filtros.

## 3.6. Estrutura versus conteúdo

É importante distinguir duas coisas:

**Estrutura:** definição das tabelas, colunas, tipos, constraints e índices.

**Conteúdo:** registros armazenados nas tabelas.

Podemos investigar a estrutura sem precisar consultar todos os registros.

Essa distinção será importante para administração e diagnóstico do banco.

---

# 4. Tipos de dados

## 4.1. Por que existem tipos de dados?

Tipos de dados definem quais valores podem ser armazenados em uma coluna e como esses valores serão interpretados pelo PostgreSQL.

Escolher corretamente um tipo de dado ajuda a garantir:

- Integridade.
- Consistência.
- Uso adequado de armazenamento.
- Operações corretas.
- Comparações apropriadas.

## 4.2. Tipos inteiros

Os tipos inteiros armazenam números sem casas decimais.

| Tipo | Tamanho | Faixa aproximada |
|---|---:|---|
| SMALLINT | 2 bytes | -32 mil a 32 mil |
| INTEGER | 4 bytes | -2,1 bilhões a 2,1 bilhões |
| BIGINT | 8 bytes | Aproximadamente -9,2 quintilhões a 9,2 quintilhões |

Exemplos de utilização:

- Quantidades.
- Identificadores numéricos.
- Contadores.
- Sequências.

A escolha deve considerar a faixa de valores necessária.

Utilizar BIGINT em uma coluna que nunca precisará de valores tão grandes pode aumentar o armazenamento em comparação com INTEGER.

## 4.3. Tipos numéricos decimais

### NUMERIC e DECIMAL

Armazenam números com precisão decimal exata, conforme a precisão e escala definidas.

Exemplo:

```sql
NUMERIC(10,2)
```

Significa:

- Precisão total de até 10 dígitos.
- Até 2 casas decimais.

É uma escolha comum para valores monetários.

### REAL e DOUBLE PRECISION

São tipos de ponto flutuante.

Armazenam valores aproximados, e não decimais exatos.

São utilizados em cálculos científicos e situações nas quais a representação aproximada é aceitável.

Para valores financeiros, normalmente é preferível utilizar NUMERIC.

## 4.4. Tipos de texto

### CHAR

Armazena texto de tamanho fixo.

### VARCHAR

Armazena texto com limite máximo definido.

Exemplo:

```sql
VARCHAR(100)
```

### TEXT

Armazena textos de tamanho variável sem limite declarado pelo usuário.

No PostgreSQL, VARCHAR sem limite e TEXT possuem comportamento de armazenamento bastante semelhante.

A escolha entre eles deve considerar principalmente as regras de negócio e a necessidade de impor limites.

## 4.5. Tipo BOOLEAN

Representa valores lógicos:

- TRUE.
- FALSE.
- NULL.

Exemplos de utilização:

- Produto ativo.
- Pedido aprovado.
- Cliente bloqueado.
- Entrega concluída.

Uma coluna BOOLEAN pode possuir NULL se não houver restrição NOT NULL.

## 4.6. Tipos de data e hora

| Tipo | Finalidade |
|---|---|
| DATE | Data sem horário |
| TIME | Horário sem data |
| TIMESTAMP | Data e horário sem fuso associado |
| TIMESTAMPTZ | Instante de tempo com tratamento de fuso horário |

O PostgreSQL armazena TIMESTAMPTZ internamente como um instante temporal e realiza conversões de apresentação conforme o fuso da sessão.

A escolha depende da informação que precisa ser representada.

Exemplos:

- Data de nascimento: DATE.
- Horário de abertura: TIME.
- Data e hora local sem necessidade de fuso: TIMESTAMP.
- Momento de uma transação entre sistemas e regiões: TIMESTAMPTZ.

## 4.7. UUID

UUID é um identificador universalmente único, representado por 128 bits.

É utilizado como alternativa a identificadores numéricos sequenciais.

Pode ser útil em sistemas distribuídos, integrações e aplicações que precisam gerar identificadores sem depender de uma sequência central.

## 4.8. JSON e JSONB

O PostgreSQL oferece suporte a dados no formato JSON.

### JSON

Armazena o texto JSON e preserva sua representação textual.

### JSONB

Armazena os dados em uma representação binária decomposta, permitindo operações e indexação eficientes em diversos cenários.

São úteis quando parte dos dados possui estrutura flexível.

Não substituem automaticamente o modelo relacional. É importante avaliar se uma informação deve ser armazenada em uma coluna tradicional ou em uma estrutura JSON.

Esses tipos serão estudados com maior profundidade no módulo de recursos avançados.

## 4.9. Escolha adequada dos tipos

A escolha deve considerar:

1. Natureza da informação.
2. Faixa de valores.
3. Precisão necessária.
4. Necessidade de operações.
5. Armazenamento.
6. Regras de negócio.
7. Compatibilidade com aplicações.

Não se deve escolher um tipo apenas porque ele aceita o valor desejado naquele momento.

É necessário considerar a evolução dos dados e o comportamento esperado da aplicação.

---

# 5. Chaves e relacionamentos

## 5.1. O que é uma chave?

Uma chave é um atributo ou conjunto de atributos utilizado para identificar registros ou estabelecer relações entre tabelas.

As chaves são fundamentais para organizar e relacionar informações.

## 5.2. Primary Key

A PRIMARY KEY identifica unicamente cada registro de uma tabela.

Características:

- Não permite valores duplicados.
- Não permite NULL.
- Pode ser composta por uma ou mais colunas.
- Cada tabela pode possuir apenas uma constraint PRIMARY KEY.

Exemplo conceitual:

```sql
id BIGINT PRIMARY KEY
```

Na TechStore, o identificador de um cliente permite distinguir um registro de todos os outros.

## 5.3. Foreign Key

A FOREIGN KEY estabelece uma referência entre tabelas.

Exemplo:

```text
clientes
---------
id
nome

pedidos
---------
id
cliente_id
valor
```

A coluna `cliente_id` referencia `clientes.id`.

Isso permite que o banco valide a existência do cliente referenciado.

Uma FOREIGN KEY protege a integridade referencial.

## 5.4. Chaves compostas

Uma chave composta utiliza duas ou mais colunas para identificar um registro.

Exemplo conceitual:

```text
pedido_id + produto_id
```

Essa combinação pode identificar uma associação entre pedido e produto, dependendo das regras da tabela.

Uma chave composta é útil quando nenhum atributo isolado representa adequadamente a identidade do registro.

## 5.5. Chaves naturais e substitutas

### Chave natural

É um atributo que possui significado no domínio do negócio e pode identificar uma entidade.

Exemplos possíveis:

- CPF.
- Código de produto.
- Número de documento.

### Chave substituta

É um identificador criado especificamente para representar o registro.

Exemplos:

- ID numérico.
- UUID.

Chaves substitutas são comuns porque evitam depender de atributos de negócio que podem mudar.

## 5.6. Relacionamento 1:1

Um registro de uma tabela está relacionado a, no máximo, um registro de outra tabela.

Exemplo:

Um usuário pode possuir um perfil adicional exclusivo.

## 5.7. Relacionamento 1:N

Um registro de uma tabela pode estar relacionado a vários registros de outra.

Exemplo na TechStore:

```text
cliente
   |
   | 1
   |
   | N
pedidos
```

Um cliente pode realizar vários pedidos.

Cada pedido pertence a um cliente, conforme a regra do modelo.

## 5.8. Relacionamento N:N

Vários registros de uma tabela podem estar relacionados a vários registros de outra.

Exemplo:

Um pedido pode conter vários produtos.

Um produto pode aparecer em vários pedidos.

Normalmente, esse relacionamento é implementado por uma tabela associativa.

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

A tabela `itens_pedido` representa a associação entre pedidos e produtos.

## 5.9. Integridade referencial

A integridade referencial impede que referências inválidas sejam mantidas quando as constraints estão corretamente configuradas e aplicadas.

Exemplo:

Um pedido não deve apontar para um cliente inexistente.

As regras de exclusão e atualização de referências podem variar conforme a definição da FOREIGN KEY.

Entre as possibilidades estão:

- RESTRICT.
- NO ACTION.
- CASCADE.
- SET NULL.
- SET DEFAULT.

Esses comportamentos serão explorados em atividades e módulos posteriores.

---

# 6. Constraints

## 6.1. O que são constraints?

Constraints são restrições definidas sobre os dados.

Elas permitem que o próprio banco de dados impeça determinadas operações inválidas.

Em vez de depender exclusivamente da aplicação para validar informações, podemos estabelecer regras diretamente no PostgreSQL.

## 6.2. NOT NULL

Impede que uma coluna receba NULL.

Exemplo:

```sql
nome VARCHAR(100) NOT NULL
```

Isso significa que um registro precisa possuir um valor para a coluna `nome`.

## 6.3. UNIQUE

Impede valores duplicados na coluna ou combinação de colunas definida pela constraint.

Exemplo:

```sql
email VARCHAR(150) UNIQUE
```

Isso impede que dois registros possuam o mesmo valor de e-mail.

Uma observação importante: a forma como NULL é tratado em constraints UNIQUE no PostgreSQL depende da configuração e da versão. Por padrão, múltiplos NULLs são permitidos.

## 6.4. PRIMARY KEY

Combina as características fundamentais de unicidade e ausência de NULL.

É utilizada para identificar os registros de uma tabela.

## 6.5. FOREIGN KEY

Garante que os valores referenciados existam na tabela relacionada, conforme as regras estabelecidas.

## 6.6. CHECK

Permite estabelecer uma condição que os valores devem satisfazer.

Exemplo:

```sql
CHECK (preco >= 0)
```

Essa condição impede valores negativos para o preço.

As expressões CHECK precisam ser projetadas considerando o comportamento de NULL.

## 6.7. DEFAULT

Define um valor padrão quando uma coluna não recebe um valor explicitamente na inserção.

Exemplo:

```sql
ativo BOOLEAN DEFAULT TRUE
```

Quando a coluna é omitida em uma inserção, o PostgreSQL utiliza o valor padrão.

DEFAULT não impede que um valor explícito seja informado e não substitui NOT NULL.

## 6.8. Importância das constraints

Constraints ajudam a garantir:

- Consistência.
- Integridade.
- Regras de negócio estruturais.
- Proteção contra registros inválidos.
- Confiabilidade dos dados.

Elas são parte essencial de uma modelagem relacional bem construída.

---

# 7. pgAdmin e exploração do banco

## 7.1. O que é pgAdmin?

O pgAdmin é uma ferramenta gráfica de administração do PostgreSQL.

Permite:

- Gerenciar conexões.
- Navegar por databases.
- Explorar schemas.
- Visualizar tabelas.
- Consultar propriedades de objetos.
- Executar SQL.
- Visualizar resultados.
- Administrar permissões.
- Acompanhar informações do servidor.

Ele facilita a administração, mas não substitui o conhecimento de SQL.

## 7.2. Servidor e conexão

Ao registrar um servidor no pgAdmin, são configuradas informações como:

- Host.
- Porta.
- Usuário.
- Senha.
- Database de manutenção.
- Parâmetros de conexão.

No laboratório TechStore, a porta publicada no computador é 5433, que é encaminhada pelo Docker para a porta 5432 do container.

É importante distinguir a porta do host da porta interna do container.

## 7.3. Navegação

A árvore de navegação permite explorar:

```text
Servers
  |
  └── PostgreSQL TechStore
        |
        └── Databases
              |
              └── techstore
                    |
                    └── Schemas
                          |
                          └── techstore
                                |
                                └── Tables
```

A estrutura real depende dos schemas configurados no banco.

A navegação gráfica permite localizar objetos, mas é importante aprender a obter as mesmas informações utilizando SQL.

## 7.4. Query Tool

O Query Tool é o editor SQL do pgAdmin.

Ele permite:

- Escrever consultas.
- Executar instruções.
- Visualizar resultados.
- Identificar erros.
- Analisar o tempo de execução.
- Consultar mensagens retornadas pelo servidor.

Durante o curso, será nossa principal interface de interação com o PostgreSQL.

## 7.5. Boas práticas

- Verificar o database selecionado antes de executar consultas.
- Conferir o schema das tabelas.
- Evitar executar comandos destrutivos sem necessidade.
- Organizar consultas em arquivos.
- Utilizar nomes claros.
- Observar mensagens de erro.
- Conferir os resultados retornados.
- Preservar o banco principal.

---

# 8. Catálogos e metadados do PostgreSQL

## 8.1. O que são metadados?

Metadados são informações sobre os próprios dados e objetos do banco.

Exemplos:

- Nome das tabelas.
- Nome das colunas.
- Tipos de dados.
- Constraints.
- Índices.
- Schemas.
- Sequências.
- Proprietários.
- Permissões.

O PostgreSQL mantém informações estruturais para administrar seus objetos.

## 8.2. information_schema

O information_schema é um conjunto padronizado de views que permite consultar informações sobre objetos do banco.

É uma interface organizada para investigar metadados.

Entre as views importantes estão:

| View | Informação |
|---|---|
| tables | Tabelas e views |
| columns | Colunas |
| table_constraints | Constraints |
| key_column_usage | Colunas utilizadas em chaves |
| referential_constraints | Restrições referenciais |
| views | Views existentes |
| schemata | Schemas |

O information_schema é útil quando queremos uma interface mais padronizada e legível.

As informações retornadas também respeitam as permissões do usuário conectado.

## 8.3. pg_catalog

O pg_catalog é o schema que contém os catálogos do sistema PostgreSQL.

Ele armazena informações utilizadas internamente pelo próprio banco.

Alguns catálogos importantes:

| Catálogo | Finalidade |
|---|---|
| pg_class | Relações e objetos como tabelas e índices |
| pg_attribute | Atributos e colunas |
| pg_type | Tipos de dados |
| pg_namespace | Schemas |
| pg_constraint | Constraints |
| pg_index | Informações de índices |
| pg_database | Databases |
| pg_roles | Roles |

O pg_catalog permite investigações mais específicas e acesso a informações próprias do PostgreSQL.

## 8.4. Diferenças entre information_schema e pg_catalog

| Característica | information_schema | pg_catalog |
|---|---|---|
| Padronização | SQL padrão | Específico do PostgreSQL |
| Organização | Views | Catálogos e funções |
| Portabilidade | Maior | Menor |
| Profundidade | Informações padronizadas | Informações mais detalhadas |
| Utilização | Consultas estruturais comuns | Administração e diagnóstico avançado |

Não existe uma regra dizendo que um deve sempre substituir o outro.

A escolha depende da informação que precisamos investigar.

## 8.5. Por que consultar metadados por SQL?

Imagine que precisamos descobrir:

- Quantas tabelas existem em determinado schema.
- Quais colunas pertencem à tabela pedidos.
- Quais tabelas possuem uma FOREIGN KEY.
- Quais índices estão disponíveis.
- Quais tipos foram utilizados em uma estrutura.

Podemos obter essas informações sem depender exclusivamente da interface gráfica.

Essa habilidade será utilizada durante todo o curso, especialmente em administração, diagnóstico e auditoria.

---

# 9. Glossário técnico

| Termo | Significado |
|---|---|
| Database | Banco de dados |
| SGBD | Sistema Gerenciador de Banco de Dados |
| Schema | Estrutura lógica de organização de objetos |
| Table | Tabela |
| Row | Linha ou registro |
| Column | Coluna |
| Constraint | Restrição de integridade |
| Primary Key | Chave primária |
| Foreign Key | Chave estrangeira |
| Metadata | Informação sobre os dados |
| Catalog | Estrutura interna de metadados |
| Query | Consulta ou instrução SQL |
| Client | Aplicação que se conecta ao servidor |
| Server | Processo ou serviço que administra o banco |
| NULL | Ausência de valor conhecido ou aplicável |
| Index | Estrutura auxiliar para acesso aos dados |
| Transaction | Unidade lógica de operações |
| Referential Integrity | Integridade referencial |

---

# 10. Referências oficiais

As referências abaixo serão utilizadas como apoio e aprofundamento.

- PostgreSQL 16 — Documentação oficial: https://www.postgresql.org/docs/16/
- PostgreSQL — Introduction: https://www.postgresql.org/docs/16/tutorial.html
- PostgreSQL — Database Concepts: https://www.postgresql.org/docs/16/tutorial-concepts.html
- PostgreSQL — Architecture: https://www.postgresql.org/docs/16/tutorial-arch.html
- PostgreSQL — Data Types: https://www.postgresql.org/docs/16/datatype.html
- PostgreSQL — Constraints: https://www.postgresql.org/docs/16/ddl-constraints.html
- PostgreSQL — Schemas: https://www.postgresql.org/docs/16/ddl-schemas.html
- PostgreSQL — System Catalogs: https://www.postgresql.org/docs/16/catalogs.html
- PostgreSQL — Information Schema: https://www.postgresql.org/docs/16/information-schema.html
- pgAdmin Documentation: https://www.pgadmin.org/docs/

---

## Encerramento

Este documento estabelece a base teórica do primeiro módulo.

O estudante deverá compreender os conceitos apresentados antes de avançar para as atividades práticas.

As explicações poderão ser complementadas durante as aulas com demonstrações, exemplos da TechStore, consultas SQL e análises de comportamento do PostgreSQL.

**Status:** Material teórico inicial documentado.