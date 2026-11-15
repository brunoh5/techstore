# Validação — Módulo 01: Fundamentos e domínio do ambiente PostgreSQL

## 1. Objetivo

Este documento define os procedimentos de validação técnica e os critérios de aprovação do Módulo 01.

A validação deverá confirmar que o estudante compreende o ambiente PostgreSQL, consegue investigar a estrutura do banco TechStore e sabe identificar os principais elementos de um banco de dados relacional.

O foco não será apenas obter informações, mas também demonstrar que o estudante consegue interpretar os resultados e justificar suas conclusões.

**Importante:** as verificações deste módulo são predominantemente de leitura. Não execute comandos que modifiquem a estrutura ou os dados do banco principal.

---

## 2. Ambiente de validação

| Item | Configuração esperada |
|---|---|
| SGBD | PostgreSQL |
| Versão principal | 16 |
| Banco | techstore |
| Schema principal | techstore |
| Ferramenta gráfica | pgAdmin |
| Acesso | Conexão local via Docker |
| Porta do host | 5433 |
| Operações permitidas | Consultas e inspeções |

### 2.1. Regras de segurança

Durante este módulo:

- Não executar novamente o seed.
- Não excluir, recriar ou restaurar o banco.
- Não modificar tabelas ou relacionamentos.
- Não inserir, atualizar ou excluir registros.
- Não alterar configurações globais do PostgreSQL.
- Não executar comandos destrutivos para testar permissões.

Toda validação deverá preservar o estado atual do ambiente.

---

## 3. Categorias de validação

As verificações estão divididas em oito categorias.

| Código | Categoria | Objetivo |
|---|---|---|
| VAL-01 | Conexão e ambiente | Confirmar acesso ao PostgreSQL |
| VAL-02 | Banco e schemas | Identificar a organização lógica |
| VAL-03 | Inventário de tabelas | Reconhecer a estrutura da TechStore |
| VAL-04 | Colunas e tipos | Interpretar a definição das tabelas |
| VAL-05 | Chaves primárias | Identificar a identificação única |
| VAL-06 | Relacionamentos | Reconhecer as referências entre tabelas |
| VAL-07 | Constraints | Verificar as regras estruturais |
| VAL-08 | Catálogos e metadados | Consultar informações internas do PostgreSQL |

---

## 4. VAL-01 — Conexão e ambiente

### Objetivo

Confirmar que o estudante consegue identificar a instância PostgreSQL utilizada pelo projeto.

### Verificações

- [ ] Conexão estabelecida pelo pgAdmin.
- [ ] Banco `techstore` identificado.
- [ ] Versão do PostgreSQL identificada.
- [ ] Usuário da conexão identificado.
- [ ] Schema principal identificado.
- [ ] Porta de conexão compreendida.

### Critérios de aprovação

O estudante deverá demonstrar que consegue distinguir:

- Servidor PostgreSQL.
- Banco de dados.
- Schema.
- Tabela.
- Usuário de conexão.

Também deverá explicar a diferença entre a porta exposta pelo Docker no host e a porta utilizada internamente pelo container.

---

## 5. VAL-02 — Banco de dados e schemas

### Objetivo

Verificar se o estudante compreende a organização lógica dos objetos do PostgreSQL.

### Verificações

- [ ] Identificar o banco conectado.
- [ ] Identificar os schemas disponíveis.
- [ ] Reconhecer o schema `techstore`.
- [ ] Diferenciar o schema principal do schema `public`.
- [ ] Identificar a finalidade dos schemas do sistema.

### Critérios de aprovação

O inventário deverá apresentar corretamente os schemas relevantes e explicar por que tabelas pertencentes a schemas diferentes podem ter o mesmo nome.

O estudante também deverá compreender o conceito de qualificação de objetos:

`schema.tabela`

---

## 6. VAL-03 — Inventário de tabelas

### Objetivo

Verificar se o estudante consegue reconhecer os objetos que compõem a estrutura da TechStore.

### Referência estrutural

O schema principal deverá conter as seguintes 25 tabelas:

| Nº | Tabela |
|---:|---|
| 1 | estados |
| 2 | cidades |
| 3 | categorias |
| 4 | marcas |
| 5 | fornecedores |
| 6 | departamentos |
| 7 | funcionarios |
| 8 | clientes |
| 9 | enderecos |
| 10 | produtos |
| 11 | estoque |
| 12 | pedidos |
| 13 | itens_pedido |
| 14 | formas_pagamento |
| 15 | pagamentos |
| 16 | transportadoras |
| 17 | entregas |
| 18 | cupons |
| 19 | avaliacoes |
| 20 | devolucoes |
| 21 | movimentacoes_estoque |
| 22 | historico_precos |
| 23 | campanhas |
| 24 | acessos |
| 25 | logs_sistema |

### Verificações

- [ ] Quantidade total de tabelas identificada.
- [ ] Todas as tabelas listadas.
- [ ] Nenhuma tabela de outro schema contabilizada indevidamente.
- [ ] Nomes e finalidades gerais compreendidos.
- [ ] Diferença entre tabela e view compreendida.

### Critérios de aprovação

O inventário deverá identificar corretamente as 25 tabelas do schema `techstore`.

Não será considerado suficiente apresentar apenas a quantidade: os nomes também deverão estar corretos.

---

## 7. VAL-04 — Colunas e tipos de dados

### Objetivo

Verificar se o estudante consegue interpretar a estrutura interna das tabelas.

### Verificações

- [ ] Identificar todas as colunas de uma tabela.
- [ ] Identificar os tipos de dados.
- [ ] Reconhecer colunas obrigatórias e opcionais.
- [ ] Identificar valores padrão.
- [ ] Diferenciar tipos numéricos, textuais, temporais e booleanos.
- [ ] Reconhecer tipos apropriados para valores monetários.
- [ ] Identificar colunas que armazenam identificadores.

### Critérios de aprovação

O estudante deverá conseguir explicar a finalidade dos tipos encontrados e justificar por que diferentes informações exigem tipos de dados diferentes.

Também deverá compreender a diferença entre:

- `NULL` e string vazia.
- Número inteiro e decimal.
- `DATE` e `TIMESTAMP`.
- `VARCHAR` e `TEXT`.
- Valor armazenado e valor padrão.

---

## 8. VAL-05 — Chaves primárias

### Objetivo

Confirmar que o estudante compreende a função das chaves primárias na identificação dos registros.

### Verificações

- [ ] Identificar as chaves primárias das tabelas.
- [ ] Reconhecer chaves simples.
- [ ] Reconhecer possíveis chaves compostas.
- [ ] Verificar quais colunas participam de cada chave.
- [ ] Explicar a relação entre chave primária e unicidade.
- [ ] Explicar por que uma chave primária não pode aceitar `NULL`.

### Critérios de aprovação

O estudante deverá conseguir identificar as constraints de chave primária e explicar como elas garantem a identificação dos registros.

Não basta localizar uma coluna chamada `id`: é necessário confirmar a existência da constraint correspondente.

---

## 9. VAL-06 — Relacionamentos

### Objetivo

Verificar se o estudante compreende como as tabelas se relacionam por meio das chaves estrangeiras.

### Verificações

- [ ] Identificar as chaves estrangeiras.
- [ ] Identificar tabela de origem e tabela referenciada.
- [ ] Identificar as colunas envolvidas.
- [ ] Reconhecer relacionamentos um para muitos.
- [ ] Reconhecer relacionamentos entre tabelas associativas.
- [ ] Interpretar a finalidade dos relacionamentos.
- [ ] Diferenciar relacionamento lógico de simples coincidência entre nomes de colunas.

### Critérios de aprovação

O estudante deverá apresentar um inventário dos relacionamentos encontrados, contendo:

- Tabela de origem.
- Coluna de origem.
- Tabela referenciada.
- Coluna referenciada.
- Nome da constraint, quando disponível.

Também deverá explicar como as chaves estrangeiras ajudam a preservar a integridade referencial.

---

## 10. VAL-07 — Constraints

### Objetivo

Verificar se o estudante reconhece as regras estruturais aplicadas às tabelas.

### Elementos esperados

- `PRIMARY KEY`
- `FOREIGN KEY`
- `UNIQUE`
- `NOT NULL`
- `CHECK`
- `DEFAULT`

### Verificações

- [ ] Identificar constraints de chave primária.
- [ ] Identificar constraints de chave estrangeira.
- [ ] Identificar restrições de unicidade.
- [ ] Identificar colunas obrigatórias.
- [ ] Identificar regras de validação com `CHECK`.
- [ ] Identificar valores padrão.
- [ ] Explicar a finalidade de cada categoria.

### Critérios de aprovação

O estudante deverá demonstrar que compreende a diferença entre:

- Restrição de unicidade e chave primária.
- Chave estrangeira e chave primária.
- `NOT NULL` e `CHECK`.
- Valor padrão e obrigatoriedade.

A identificação deverá ser feita por meio das definições reais do banco, e não apenas pela observação dos nomes das colunas.

---

## 11. VAL-08 — Catálogos e metadados

### Objetivo

Verificar se o estudante consegue utilizar os recursos internos do PostgreSQL para investigar o banco.

### Fontes de informação

- `information_schema`
- `pg_catalog`
- Views administrativas.
- Metadados disponibilizados pelo PostgreSQL.

### Verificações

- [ ] Identificar a finalidade do `information_schema`.
- [ ] Identificar a finalidade do `pg_catalog`.
- [ ] Consultar metadados de tabelas.
- [ ] Consultar metadados de colunas.
- [ ] Consultar informações de constraints.
- [ ] Identificar índices existentes.
- [ ] Diferenciar informações padronizadas de informações específicas do PostgreSQL.

### Critérios de aprovação

O estudante deverá conseguir obter informações estruturais utilizando os catálogos do banco.

Também deverá explicar por que essas fontes são úteis para auditorias, documentação, diagnóstico e automação.

---

## 12. Auditoria estrutural consolidada

Ao final das oito categorias, o estudante deverá produzir um inventário técnico consolidado da TechStore.

### Entregáveis obrigatórios

| Entregável | Conteúdo esperado |
|---|---|
| Ambiente | Identificação da instância e conexão |
| Schemas | Inventário dos schemas relevantes |
| Tabelas | Relação das 25 tabelas |
| Colunas | Nome, tipo e nulabilidade |
| Chaves primárias | Relação das PKs |
| Chaves estrangeiras | Mapeamento dos relacionamentos |
| Constraints | Inventário das regras estruturais |
| Metadados | Evidências de consultas aos catálogos |

### Requisitos de qualidade

O material deverá:

- Ser baseado na estrutura real do banco.
- Conter informações verificáveis.
- Não apresentar tabelas ou relacionamentos inventados.
- Diferenciar claramente observações de conclusões.
- Apresentar resultados organizados.
- Permitir que outra pessoa reproduza as verificações.

---

## 13. Testes de consistência

Além da inspeção estrutural, serão realizados testes de consistência.

Esses testes não devem alterar os dados.

### Verificações esperadas

- [ ] Quantidade de tabelas compatível com a referência.
- [ ] Todas as tabelas possuem suas estruturas identificáveis.
- [ ] Chaves primárias identificadas corretamente.
- [ ] Chaves estrangeiras identificadas corretamente.
- [ ] Constraints identificadas corretamente.
- [ ] Relacionamentos documentados de acordo com o banco.
- [ ] Nenhuma informação estrutural foi presumida sem evidência.

### Observação

A existência de uma chave estrangeira demonstra que o banco possui uma regra de integridade referencial. Isso não substitui a compreensão do significado do relacionamento no domínio da aplicação.

---

## 14. Avaliação de domínio

A avaliação final verificará se o estudante consegue investigar uma estrutura desconhecida sem depender de instruções passo a passo.

### Competências avaliadas

1. Identificar a instância e o banco conectado.
2. Navegar pela organização lógica do PostgreSQL.
3. Investigar tabelas e colunas.
4. Interpretar tipos de dados.
5. Identificar chaves e relacionamentos.
6. Interpretar constraints.
7. Consultar catálogos do sistema.
8. Produzir documentação técnica confiável.

### Critérios de avaliação

| Critério | Peso |
|---|---:|
| Correção das informações coletadas | 30% |
| Domínio dos conceitos | 25% |
| Capacidade de investigação independente | 20% |
| Interpretação dos resultados | 15% |
| Organização e documentação | 10% |
| **Total** | **100%** |

### Aprovação

- Nota mínima: 85%.
- Nenhum erro crítico de interpretação estrutural.
- Nenhuma alteração indevida no banco principal.
- Todos os entregáveis obrigatórios apresentados.

A nota mínima não substitui a demonstração das competências essenciais. Um erro crítico poderá exigir uma nova validação, mesmo que a pontuação numérica seja suficiente.

---

## 15. Diagnóstico de dificuldades

Quando uma validação falhar, o estudante deverá identificar a causa antes de tentar novamente.

| Problema | Área para investigar |
|---|---|
| Tabela não encontrada | Banco conectado e schema |
| Coluna não localizada | Nome e definição da tabela |
| Constraint não identificada | Catálogos e metadados |
| Resultado duplicado | Escopo da consulta e origem dos dados |
| Quantidade divergente | Filtros e schema consultado |
| Tipo de dado interpretado incorretamente | Definição da coluna |
| Relacionamento incorreto | Chave estrangeira e tabela referenciada |
| Permissão insuficiente | Usuário e privilégios de leitura |

O objetivo é desenvolver capacidade de diagnóstico, não apenas corrigir o resultado final.

---

## 16. Registro de progresso

O acompanhamento deverá ser atualizado durante as aulas.

| Categoria | Status | Resultado |
|---|---|---|
| VAL-01 — Ambiente | Pendente | — |
| VAL-02 — Banco e schemas | Pendente | — |
| VAL-03 — Tabelas | Pendente | — |
| VAL-04 — Colunas e tipos | Pendente | — |
| VAL-05 — Chaves primárias | Pendente | — |
| VAL-06 — Relacionamentos | Pendente | — |
| VAL-07 — Constraints | Pendente | — |
| VAL-08 — Metadados | Pendente | — |
| Auditoria consolidada | Pendente | — |
| Avaliação de domínio | Pendente | — |

Status possíveis:

- **Pendente:** ainda não realizado.
- **Em andamento:** em execução.
- **Aprovado:** validado.
- **Revisão necessária:** apresentou falhas.
- **Revalidado:** corrigido e aprovado.

---

## 17. Condições para liberar o Módulo 02

O próximo módulo somente será liberado quando:

- [ ] Todas as oito categorias estiverem aprovadas.
- [ ] A auditoria estrutural estiver concluída.
- [ ] A avaliação de domínio atingir os critérios mínimos.
- [ ] O estudante conseguir explicar a estrutura da TechStore.
- [ ] O estudante demonstrar autonomia na investigação do banco.

O objetivo é garantir que o estudante tenha uma base sólida antes de começar a trabalhar intensivamente com consultas SQL.

---

## 18. Estado do documento

| Informação | Estado |
|---|---|
| Documento | Validação do Módulo 01 |
| Módulo | Fundamentos e domínio do ambiente PostgreSQL |
| Banco utilizado | TechStore |
| Estratégia | Mastery Learning |
| Nível | Professional |
| Aulas | Ainda não iniciadas |
| Validações | Aguardando execução |

**Este documento define o protocolo de validação. Os resultados reais serão preenchidos durante o andamento do módulo.**