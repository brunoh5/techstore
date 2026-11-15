# Módulo 01 — Fundamentos e domínio do ambiente PostgreSQL

# Atividades práticas

**Formação:** SQL e PostgreSQL — TechStore  
**Módulo:** 01 — Fundamentos e domínio do ambiente PostgreSQL  
**Banco de dados:** PostgreSQL 16  
**Nível:** Progressivo — Básico ao Profissional  
**Status:** Aguardando início das atividades

---

# 1. Orientações gerais

Este documento contém as atividades práticas do primeiro módulo da formação SQL e PostgreSQL.

O objetivo é aplicar os conhecimentos teóricos sobre bancos relacionais, arquitetura PostgreSQL, estrutura de tabelas, tipos de dados, relacionamentos, constraints, pgAdmin e metadados.

As atividades serão realizadas no banco TechStore.

## 1.1. Regras de execução

1. Todas as atividades devem ser desenvolvidas pelo estudante.
2. Não serão fornecidas soluções prontas antes da tentativa.
3. As consultas deverão ser executadas no PostgreSQL.
4. Os resultados deverão ser apresentados quando solicitados.
5. As conclusões deverão ser justificadas tecnicamente.
6. O banco principal deverá ser preservado.
7. Não executar comandos de alteração ou exclusão sem autorização.
8. Priorizar consultas de leitura.
9. Utilizar SQL para investigar a estrutura do banco, sem depender exclusivamente da interface gráfica.
10. Registrar erros encontrados e explicar como foram investigados.

## 1.2. Níveis de dificuldade

| Nível | Descrição |
|---|---|
| Básico | Reconhecimento e compreensão |
| Intermediário | Investigação e combinação de conhecimentos |
| Avançado | Análise estrutural e interpretação |
| Profissional | Investigação técnica integrada |
| Domínio | Desafio completo do módulo |

---

# 2. Atividades básicas

## Atividade 01 — Reconhecimento do ambiente

**Nível:** Básico  
**Tema:** Arquitetura e funcionamento do PostgreSQL

### Contexto

A TechStore utiliza PostgreSQL executando em um container Docker, enquanto o pgAdmin é utilizado como ferramenta de administração.

Antes de trabalhar com consultas, é necessário compreender como os componentes estão conectados.

### Objetivos

- Identificar o servidor PostgreSQL.
- Identificar o database utilizado.
- Compreender a conexão do pgAdmin.
- Diferenciar cliente e servidor.
- Compreender o encaminhamento de portas do Docker.

### Requisitos

Identifique e documente:

1. Qual ferramenta funciona como cliente SQL.
2. Qual componente executa o servidor PostgreSQL.
3. Qual é o nome do database principal.
4. Qual porta é utilizada no host.
5. Qual porta é utilizada dentro do container.
6. Qual é a função do volume persistente.
7. O que aconteceria com os dados se o container fosse recriado mantendo o volume.
8. Qual a diferença entre reiniciar o container e remover o volume de dados.

### Entrega

Produza uma explicação curta da arquitetura do ambiente TechStore.

### Critérios de aceitação

- Todos os componentes devem ser identificados corretamente.
- A diferença entre cliente e servidor deve estar clara.
- As portas do host e do container devem ser diferenciadas.
- O funcionamento do volume persistente deve ser explicado.

---

## Atividade 02 — Exploração dos bancos e schemas

**Nível:** Básico  
**Tema:** Database e schemas

### Contexto

Um ambiente PostgreSQL pode conter vários bancos de dados e schemas.

Um profissional precisa compreender essa organização antes de investigar as tabelas.

### Requisitos

Investigue o ambiente e identifique:

1. O database ao qual o pgAdmin está conectado.
2. Os schemas existentes.
3. O schema utilizado pelas tabelas da TechStore.
4. A diferença entre database e schema.
5. Como uma tabela pode ser referenciada utilizando seu nome qualificado.
6. O valor atual de `search_path`.

### Entrega

Apresente uma lista dos schemas encontrados e explique a função de cada um que for relevante para o laboratório.

### Critérios de aceitação

- Identificação correta do database.
- Identificação correta dos schemas.
- Explicação da diferença entre database e schema.
- Interpretação correta do search_path.

---

## Atividade 03 — Inventário de tabelas

**Nível:** Básico  
**Tema:** Estrutura de tabelas

### Contexto

A TechStore possui diversas áreas de negócio.

Um profissional precisa identificar quais tabelas existem antes de construir consultas.

### Requisitos

Produza um inventário das tabelas do schema principal.

Para cada tabela, identifique:

1. Nome.
2. Schema.
3. Finalidade provável.
4. Área de negócio relacionada.

Investigue pelo menos as seguintes tabelas:

- clientes
- enderecos
- produtos
- categorias
- marcas
- pedidos
- itens_pedido
- pagamentos
- estoque
- entregas
- funcionarios
- logs_sistema

### Entrega

Apresente uma tabela organizada com as informações encontradas.

### Critérios de aceitação

- Todas as tabelas solicitadas devem ser localizadas.
- Os schemas devem ser identificados corretamente.
- As finalidades devem ser coerentes com os nomes e estruturas.
- Não confundir tabelas com registros.

---

# 3. Atividades intermediárias

## Atividade 04 — Investigação de colunas e tipos

**Nível:** Intermediário  
**Tema:** Estrutura de tabelas e tipos de dados

### Contexto

Uma aplicação precisa compreender a estrutura das tabelas para desenvolver consultas e integrar seus dados corretamente.

### Requisitos

Investigue as seguintes tabelas:

- clientes
- produtos
- pedidos
- itens_pedido
- pagamentos

Para cada uma, identifique:

1. Nome das colunas.
2. Tipo de dado.
3. Se aceita NULL.
4. Se possui valor padrão.
5. Se participa de alguma constraint.
6. Qual parece ser sua finalidade.

### Análise complementar

Identifique exemplos de:

- Tipos inteiros.
- Tipos numéricos decimais.
- Tipos de texto.
- Tipos booleanos.
- Tipos de data e hora.

Responda também:

1. Por que um valor monetário não deve ser tratado automaticamente como ponto flutuante?
2. Qual a diferença entre DATE e TIMESTAMP?
3. Quando BIGINT pode ser necessário em vez de INTEGER?
4. Qual a diferença entre VARCHAR e TEXT no PostgreSQL?
5. Qual a finalidade de uma coluna BOOLEAN?

### Entrega

Apresente o inventário de colunas e responda às questões técnicas.

### Critérios de aceitação

- Tipos de dados identificados corretamente.
- Propriedades das colunas interpretadas.
- Respostas tecnicamente justificadas.
- Nenhuma alteração na estrutura do banco.

---

## Atividade 05 — Identificação de chaves primárias

**Nível:** Intermediário  
**Tema:** Primary Key

### Contexto

Uma tabela precisa possuir uma forma confiável de identificar seus registros.

### Requisitos

Investigue as tabelas:

- clientes
- produtos
- pedidos
- itens_pedido
- pagamentos
- categorias
- marcas

Identifique:

1. Qual coluna ou conjunto de colunas forma a chave primária.
2. Se a chave é simples ou composta.
3. Qual sua finalidade.
4. Por que a chave precisa ser única.
5. Como a chave pode ser identificada por meio dos metadados.

### Entrega

Produza uma tabela com o nome da tabela investigada, sua chave primária e a classificação da chave.

### Critérios de aceitação

- Chaves identificadas corretamente.
- Diferença entre chave simples e composta compreendida.
- Explicação coerente sobre unicidade e identificação.

---

## Atividade 06 — Identificação de relacionamentos

**Nível:** Intermediário  
**Tema:** Foreign Key e relacionamentos

### Contexto

Os dados da TechStore estão distribuídos em tabelas relacionadas.

É necessário compreender como essas tabelas se conectam.

### Requisitos

Investigue os relacionamentos envolvendo:

- clientes e pedidos.
- pedidos e itens_pedido.
- produtos e itens_pedido.
- pedidos e pagamentos.
- produtos e estoque.
- pedidos e entregas.
- produtos e categorias.

Para cada relacionamento, identifique:

1. Tabela de origem.
2. Coluna que estabelece a referência.
3. Tabela referenciada.
4. Coluna referenciada.
5. Tipo de relacionamento.
6. Finalidade da relação.

### Análise complementar

Responda:

- Por que uma FOREIGN KEY é importante?
- Uma tabela pode possuir várias FOREIGN KEYs?
- Uma FOREIGN KEY precisa obrigatoriamente apontar para uma PRIMARY KEY?
- Qual a diferença entre relacionamento lógico e integridade referencial implementada por constraint?
- Como uma tabela associativa representa um relacionamento N:N?

### Entrega

Apresente um mapa textual ou diagrama dos relacionamentos investigados.

### Critérios de aceitação

- Referências corretamente identificadas.
- Cardinalidades coerentes.
- Explicação da função das chaves estrangeiras.
- Relacionamentos não devem ser deduzidos apenas pelos nomes das colunas.

---

## Atividade 07 — Investigação de constraints

**Nível:** Intermediário  
**Tema:** Constraints

### Contexto

O banco possui regras estruturais que protegem a consistência dos dados.

Um profissional precisa identificar essas regras para compreender o comportamento das tabelas.

### Requisitos

Investigue as constraints das seguintes tabelas:

- clientes
- produtos
- pedidos
- itens_pedido
- pagamentos
- estoque

Classifique as constraints encontradas:

- PRIMARY KEY.
- FOREIGN KEY.
- UNIQUE.
- NOT NULL.
- CHECK.

Investigue também:

1. Quais colunas possuem valores padrão?
2. Quais colunas não aceitam NULL?
3. Quais regras impedem valores inválidos?
4. Quais regras protegem relacionamentos?
5. Quais constraints são compostas por várias colunas?

### Entrega

Apresente uma tabela contendo:

| Tabela | Constraint | Tipo | Coluna(s) | Finalidade |
|---|---|---|---|---|

### Critérios de aceitação

- Constraints classificadas corretamente.
- Finalidade compreendida.
- Diferença entre DEFAULT e NOT NULL demonstrada.
- Nenhuma modificação das regras existentes.

---

# 4. Atividades avançadas

## Atividade 08 — Investigação utilizando information_schema

**Nível:** Avançado  
**Tema:** Catálogos e metadados

### Contexto

Um administrador precisa investigar a estrutura do banco sem depender da interface gráfica.

### Requisitos

Utilizando consultas SQL e information_schema, investigue:

1. Schemas existentes.
2. Tabelas do schema principal.
3. Colunas da tabela clientes.
4. Tipos de dados da tabela produtos.
5. Constraints da tabela pedidos.
6. Colunas utilizadas em chaves.
7. Restrições referenciais existentes.
8. Views disponíveis.

### Restrições

- Utilizar consultas SQL.
- Não alterar estruturas.
- Não consultar arquivos internos do container.
- Não depender exclusivamente do pgAdmin para identificar os resultados.

### Entrega

Apresente as consultas utilizadas e explique o resultado de cada investigação.

### Critérios de aceitação

- Informações corretas.
- Utilização adequada das views do information_schema.
- Interpretação dos metadados.
- Consultas legíveis.

---

## Atividade 09 — Investigação utilizando pg_catalog

**Nível:** Avançado  
**Tema:** Catálogos internos

### Contexto

O information_schema apresenta informações padronizadas, mas algumas investigações exigem recursos específicos do PostgreSQL.

### Requisitos

Utilizando pg_catalog, investigue:

1. Schemas.
2. Tabelas.
3. Colunas.
4. Tipos de dados.
5. Constraints.
6. Índices.
7. Objetos relacionados às tabelas investigadas.

### Análise complementar

Compare os resultados com os obtidos no information_schema.

Responda:

- Qual a diferença entre pg_class e pg_attribute?
- Qual a finalidade de pg_namespace?
- Onde são registradas informações sobre constraints?
- Por que pg_catalog é específico do PostgreSQL?
- Quando utilizar information_schema em vez de pg_catalog?

### Entrega

Apresente as consultas e uma comparação entre os dois mecanismos de investigação.

### Critérios de aceitação

- Catálogos utilizados corretamente.
- Resultados interpretados.
- Comparação tecnicamente coerente.
- Diferenças entre informações padronizadas e específicas do PostgreSQL compreendidas.

---

# 5. Atividades profissionais

## Atividade 10 — Inventário técnico de uma área da TechStore

**Nível:** Profissional  
**Tema:** Investigação estrutural integrada

### Contexto

Uma equipe de desenvolvimento precisará implementar novas funcionalidades na área de vendas da TechStore.

Antes do desenvolvimento, é necessário produzir um levantamento técnico das estruturas existentes.

### Escopo

Investigue:

- clientes
- enderecos
- pedidos
- itens_pedido
- produtos
- pagamentos
- entregas

### Requisitos

Produza um inventário contendo:

1. Descrição da finalidade de cada tabela.
2. Colunas e tipos de dados.
3. Chaves primárias.
4. Chaves estrangeiras.
5. Constraints.
6. Relacionamentos.
7. Dependências entre tabelas.
8. Observações relevantes sobre a estrutura.

### Entrega

Um documento técnico que permita a outro desenvolvedor compreender como a área de vendas está organizada.

### Critérios de aceitação

- Levantamento completo.
- Informações verificadas no banco.
- Relações corretamente representadas.
- Linguagem técnica clara.
- Evidências SQL apresentadas.
- Nenhuma alteração no banco.

---

## Atividade 11 — Auditoria estrutural

**Nível:** Profissional  
**Tema:** Integridade e diagnóstico

### Contexto

Uma equipe recebeu a responsabilidade de analisar a estrutura do banco antes de uma nova etapa de desenvolvimento.

O objetivo é verificar se as estruturas e restrições existentes são compreensíveis e coerentes com as relações identificadas.

### Requisitos

Investigue uma seleção de tabelas da TechStore e responda:

1. Todas as tabelas investigadas possuem uma chave primária?
2. Quais tabelas possuem FOREIGN KEY?
3. Existem tabelas associativas?
4. Existem colunas que aceitam NULL?
5. Existem regras CHECK?
6. Existem restrições UNIQUE?
7. Existem valores padrão?
8. Há relações que parecem existir pelo modelo, mas não possuem FOREIGN KEY declarada?
9. Quais pontos merecem investigação adicional?

### Restrições

Não classifique automaticamente a ausência de uma FOREIGN KEY como erro.

É necessário considerar o modelo de dados e justificar cada observação.

### Entrega

Produza um relatório com:

- Estruturas analisadas.
- Evidências encontradas.
- Possíveis riscos.
- Recomendações de investigação.
- Conclusão técnica.

### Critérios de aceitação

- Diagnóstico baseado em evidências.
- Diferenciação entre problema comprovado e hipótese.
- Justificativas coerentes.
- Preservação integral do banco.

---

# 6. Desafio de domínio

## Atividade 12 — Mapeamento estrutural da TechStore

**Nível:** Desafio de domínio  
**Tema:** Integração de todo o módulo

### Contexto

Você foi designado para produzir uma documentação técnica inicial da estrutura de dados da TechStore.

O documento será utilizado por profissionais que ainda não conhecem o banco.

Seu trabalho é permitir que eles compreendam como o sistema organiza seus dados.

### Escopo mínimo

Investigue as seguintes áreas:

**Clientes e vendas**
- clientes
- enderecos
- pedidos
- itens_pedido

**Produtos e estoque**
- produtos
- categorias
- marcas
- estoque
- fornecedores

**Financeiro**
- pagamentos
- formas_pagamento
- cupons

**Operações**
- entregas
- transportadoras
- devolucoes
- movimentacoes_estoque

### Requisitos obrigatórios

O levantamento deverá conter:

1. Identificação do database.
2. Identificação dos schemas.
3. Inventário das tabelas.
4. Colunas e tipos de dados.
5. Chaves primárias.
6. Chaves estrangeiras.
7. Constraints.
8. Relacionamentos.
9. Dependências estruturais.
10. Consultas SQL utilizadas na investigação.
11. Explicação da diferença entre information_schema e pg_catalog.
12. Conclusão sobre a organização do banco.

### Entrega final

Um documento técnico organizado, acompanhado das consultas SQL utilizadas.

O trabalho deverá permitir que outra pessoa compreenda a estrutura investigada sem precisar repetir toda a análise.

### Critérios de aprovação

- Todas as áreas solicitadas devem ser investigadas.
- Informações devem ser verificáveis.
- Estruturas e relacionamentos devem estar corretos.
- Consultas devem ser legíveis.
- A documentação deve ser compreensível.
- Não podem existir erros críticos de interpretação.
- O banco deverá permanecer intacto.

---

# 7. Registro de entregas

O progresso será acompanhado durante a realização do módulo.

| Atividade | Nível | Situação |
|---|---|---|
| 01 — Reconhecimento do ambiente | Básico | Aguardando |
| 02 — Bancos e schemas | Básico | Aguardando |
| 03 — Inventário de tabelas | Básico | Aguardando |
| 04 — Colunas e tipos | Intermediário | Aguardando |
| 05 — Chaves primárias | Intermediário | Aguardando |
| 06 — Relacionamentos | Intermediário | Aguardando |
| 07 — Constraints | Intermediário | Aguardando |
| 08 — information_schema | Avançado | Aguardando |
| 09 — pg_catalog | Avançado | Aguardando |
| 10 — Inventário técnico | Profissional | Aguardando |
| 11 — Auditoria estrutural | Profissional | Aguardando |
| 12 — Mapeamento completo | Domínio | Aguardando |

## 7.1. Estados possíveis

- Aguardando.
- Em andamento.
- Em revisão.
- Aprovada.
- Necessita reforço.

Uma atividade não será considerada aprovada apenas por ter sido executada sem erro.

A correção dos resultados e a interpretação técnica também serão avaliadas.

---

# 8. Padrão de apresentação das respostas

Quando uma atividade for entregue, o estudante deverá apresentar:

1. Número e nome da atividade.
2. Explicação do raciocínio.
3. Consulta SQL utilizada, quando aplicável.
4. Resultado obtido.
5. Interpretação do resultado.
6. Dificuldades encontradas.
7. Conclusão.

Para atividades exclusivamente conceituais, os itens relacionados a SQL poderão ser substituídos por explicações e evidências adequadas.

---

# 9. Regras de progressão

As atividades serão liberadas conforme o avanço das aulas.

Não será necessário realizar todas as atividades de uma só vez.

O professor poderá:

- Solicitar ajustes.
- Criar exercícios adicionais.
- Aprofundar determinados assuntos.
- Aplicar testes complementares.
- Repetir avaliações quando necessário.

A aprovação no desafio de domínio será necessária para concluir o módulo.

---

# 10. Situação das atividades

**Atividades documentadas:** 12.

**Níveis:** Básico, intermediário, avançado, profissional e domínio.

**Soluções:** Não fornecidas antecipadamente.

**Execução:** Aguardando início das aulas.

**Validação:** Dependente dos critérios definidos no documento `validacao.md`.