# Módulo 05 — JOINs (Junções entre Tabelas)

## 1. Apresentação

Neste módulo, estudaremos JOINs, um dos recursos mais importantes da linguagem SQL.

Até o módulo anterior, trabalhamos principalmente com consultas e agregações sobre tabelas individuais. Agora aprenderemos a combinar informações armazenadas em diferentes tabelas, utilizando os relacionamentos existentes no banco de dados.

O objetivo é desenvolver a capacidade de construir consultas que representem situações reais de negócio, preservando a integridade dos resultados e compreendendo como o PostgreSQL executa as junções.

Este módulo utilizará exclusivamente o banco TechStore já populado.

---

## 2. Objetivos de aprendizagem

Ao concluir este módulo, o estudante deverá ser capaz de:

- Compreender o funcionamento dos relacionamentos entre tabelas.
- Identificar chaves primárias e estrangeiras utilizadas em JOINs.
- Diferenciar os tipos de junções disponíveis no PostgreSQL.
- Construir consultas com INNER JOIN, LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN.
- Utilizar CROSS JOIN e SELF JOIN.
- Combinar três ou mais tabelas em uma consulta.
- Compreender relacionamentos 1:1, 1:N e N:N.
- Diferenciar condições de junção e condições de filtragem.
- Combinar JOINs com WHERE, GROUP BY e HAVING.
- Utilizar agregações em consultas com múltiplas tabelas.
- Identificar registros sem correspondência.
- Reconhecer e evitar duplicações indevidas.
- Compreender cardinalidade e granularidade.
- Analisar planos de execução de consultas com JOIN.
- Identificar oportunidades de melhoria de desempenho.

---

## 3. Conteúdo programático

### Tema 01 — Fundamentos de relacionamentos

- Relacionamentos entre tabelas.
- Chaves primárias e estrangeiras.
- Colunas utilizadas em junções.
- Integridade referencial.
- Cardinalidade.
- Granularidade dos resultados.

### Tema 02 — INNER JOIN

- Funcionamento.
- Correspondência entre registros.
- Condição ON.
- Alias de tabelas.
- Consultas com uma ou mais junções.

### Tema 03 — LEFT JOIN

- Funcionamento.
- Preservação dos registros da tabela à esquerda.
- Correspondências ausentes.
- Valores NULL gerados pela junção.
- Aplicações práticas.

### Tema 04 — RIGHT JOIN

- Funcionamento.
- Preservação dos registros da tabela à direita.
- Comparação com LEFT JOIN.
- Organização e legibilidade das consultas.

### Tema 05 — FULL OUTER JOIN

- Funcionamento.
- Preservação dos registros dos dois lados.
- Correspondências e ausências.
- Aplicações em auditorias e comparações.

### Tema 06 — CROSS JOIN

- Produto cartesiano.
- Combinação de conjuntos.
- Quantidade de linhas produzidas.
- Cuidados com crescimento dos resultados.

### Tema 07 — SELF JOIN

- Junção de uma tabela com ela mesma.
- Utilização de aliases.
- Relacionamentos hierárquicos.
- Comparação de registros da mesma tabela.

### Tema 08 — JOIN com múltiplas tabelas

- Duas tabelas.
- Três ou mais tabelas.
- Sequência de junções.
- Relacionamentos intermediários.
- Organização de consultas complexas.

### Tema 09 — Tipos de relacionamento

- Relacionamento 1:1.
- Relacionamento 1:N.
- Relacionamento N:N.
- Tabelas associativas.
- Efeitos dos relacionamentos sobre os resultados.

### Tema 10 — Condições ON e WHERE

- Diferenças entre ON e WHERE.
- Condições de correspondência.
- Filtros aplicados após a junção.
- Efeitos em LEFT JOIN e outras junções externas.
- Erros frequentes de filtragem.

### Tema 11 — JOIN com GROUP BY e HAVING

- Agrupamento após junções.
- Agregações por dimensões relacionadas.
- Filtragem de grupos.
- Combinação de várias tabelas com indicadores.

### Tema 12 — JOIN com funções agregadas

- COUNT.
- SUM.
- AVG.
- MIN e MAX.
- COUNT(DISTINCT).
- Agregações condicionais.
- Cuidados com duplicações.

### Tema 13 — Identificação de registros sem correspondência

- LEFT JOIN com ausência de correspondência.
- FULL OUTER JOIN para comparação.
- Identificação de registros órfãos.
- Auditoria de relacionamentos.
- Diferença entre ausência de correspondência e valores NULL existentes.

### Tema 14 — Duplicações e cardinalidade

- Multiplicação de registros.
- Relacionamentos 1:N e N:N.
- Efeitos de múltiplas junções.
- Duplicação de valores em agregações.
- Uso consciente de DISTINCT.
- Estratégias para preservar a granularidade.

### Tema 15 — Estratégias de execução de JOIN

- Nested Loop.
- Hash Join.
- Merge Join.
- Estimativas do planejador.
- Custos de execução.
- Escolha de estratégias pelo PostgreSQL.

### Tema 16 — Índices e desempenho

- Índices nas colunas utilizadas em junções.
- Índices de chaves primárias e estrangeiras.
- Seletividade.
- Estatísticas.
- Relação entre índices e estratégias de JOIN.

### Tema 17 — EXPLAIN ANALYZE aplicado a JOINs

- Leitura do plano de execução.
- Linhas estimadas e reais.
- Tempo de planejamento e execução.
- Buffers.
- Identificação de gargalos.
- Comparação de consultas equivalentes.

### Tema 18 — Boas práticas e otimização

- Clareza nas condições de junção.
- Uso de aliases.
- Seleção consciente de colunas.
- Controle de cardinalidade.
- Prevenção de dupla contagem.
- Organização de consultas complexas.
- Validação independente dos resultados.

---

## 4. Aplicação no banco TechStore

O banco possui relacionamentos que permitem trabalhar com situações próximas de sistemas comerciais reais.

As principais tabelas utilizadas serão:

| Tabela | Finalidade |
|---|---|
| clientes | Cadastro de clientes |
| enderecos | Endereços cadastrados |
| pedidos | Pedidos realizados |
| itens_pedido | Produtos associados aos pedidos |
| produtos | Catálogo de produtos |
| categorias | Classificação dos produtos |
| marcas | Marcas comerciais |
| fornecedores | Fornecedores |
| estoque | Quantidades disponíveis |
| pagamentos | Pagamentos dos pedidos |
| entregas | Informações de entrega |
| transportadoras | Empresas de transporte |
| funcionarios | Funcionários |
| departamentos | Departamentos |
| avaliacoes | Avaliações de produtos |
| devolucoes | Devoluções de itens |
| acessos | Histórico de acessos |

### Exemplos de problemas de negócio

Durante o módulo, serão trabalhadas situações como:

- Identificar clientes que realizaram pedidos.
- Encontrar clientes que nunca realizaram pedidos.
- Identificar produtos vendidos e não vendidos.
- Calcular valores comercializados por categoria.
- Analisar pedidos e seus pagamentos.
- Relacionar entregas e transportadoras.
- Avaliar desempenho de funcionários.
- Identificar produtos sem avaliações.
- Analisar devoluções relacionadas aos itens vendidos.
- Construir indicadores envolvendo várias tabelas.

Os exercícios deverão respeitar os relacionamentos reais definidos no schema da TechStore.

---

## 5. Estrutura de arquivos

O módulo seguirá a estrutura padronizada do curso:

```text
modulo-05-joins/
├── README.md
├── teoria.md
├── atividades.md
├── validacao.md
└── consultas.sql
```

### README.md

Apresentação do módulo, objetivos, conteúdo programático e organização.

### teoria.md

Explicações detalhadas, sintaxe, demonstrações, comparações, erros frequentes e boas práticas.

### atividades.md

Exercícios progressivos e desafios práticos utilizando o banco TechStore.

### validacao.md

Critérios de avaliação, testes independentes, verificação dos resultados e condições de aprovação.

### consultas.sql

Exemplos demonstrativos comentados para consulta e estudo.

---

## 6. Metodologia de aprendizagem

Será mantida a metodologia Mastery Learning.

Cada conteúdo seguirá uma progressão:

1. Apresentação do conceito.
2. Explicação teórica.
3. Demonstração prática.
4. Exercícios individuais.
5. Validação independente.
6. Correção e reforço direcionado.
7. Avaliação de domínio.

O estudante deverá compreender não apenas como escrever uma consulta, mas também por que ela funciona e como verificar se o resultado está correto.

### Progressão dos exercícios

Os exercícios serão organizados em níveis:

- **Nível 1 — Fundamentos:** junções simples entre duas tabelas.
- **Nível 2 — Aplicação:** combinações de diferentes tipos de JOIN.
- **Nível 3 — Intermediário:** junções com filtros e agregações.
- **Nível 4 — Avançado:** múltiplas tabelas e problemas de cardinalidade.
- **Nível 5 — Profissional:** consultas analíticas, validação e desempenho.

Os desafios não deverão entregar antecipadamente as soluções.

---

## 7. Validação independente

A correção não será baseada apenas na execução sem erros.

Será necessário verificar:

- Quantidade de registros retornados.
- Correspondências existentes e ausentes.
- Integridade dos relacionamentos.
- Duplicações inesperadas.
- Cardinalidade dos resultados.
- Granularidade de cada consulta.
- Coerência das agregações.
- Tratamento de valores NULL.
- Resultados vazios.
- Casos extremos.

Quando necessário, serão utilizadas consultas independentes para conferir os resultados.

---

## 8. Desempenho e otimização

Este módulo introduzirá a análise de desempenho aplicada às junções.

Serão observadas as seguintes métricas:

| Métrica | Finalidade |
|---|---|
| Planning Time | Tempo de planejamento |
| Execution Time | Tempo de execução |
| Actual Rows | Quantidade real de linhas |
| Estimated Rows | Quantidade estimada |
| Node Type | Estratégia de execução utilizada |
| Shared Hit Blocks | Blocos encontrados no cache compartilhado |
| Shared Read Blocks | Blocos lidos do armazenamento |

O processo de otimização seguirá estas etapas:

1. Executar uma consulta de referência.
2. Analisar seu plano de execução.
3. Identificar possíveis gargalos.
4. Formular uma hipótese.
5. Modificar uma variável por vez.
6. Comparar os resultados.
7. Verificar se a correção lógica foi preservada.
8. Registrar as conclusões.

Não serão estabelecidas metas universais de tempo. O desempenho será avaliado considerando o volume de dados, a complexidade da consulta e o ambiente utilizado.

**Importante:** não serão criados, removidos ou modificados índices no banco principal durante os exercícios sem autorização e planejamento específico.

---

## 9. Critérios de avaliação

A avaliação seguirá os pesos oficiais do curso:

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

### Nota mínima

A referência para aprovação será de **85%**.

Não será permitida a progressão com erros críticos pendentes, especialmente:

- Junções com condições incorretas.
- Multiplicação de registros não identificada.
- Agregações com dupla contagem.
- Perda indevida de registros em junções externas.
- Interpretação incorreta de NULL.
- Resultados incompatíveis com a regra de negócio.

---

## 10. Pré-requisitos

Para iniciar este módulo, é necessário dominar:

- Fundamentos do PostgreSQL.
- SELECT e filtros.
- Expressões e funções SQL.
- Agregações.
- GROUP BY e HAVING.
- COUNT, SUM, AVG, MIN e MAX.
- DISTINCT e agregações condicionais.
- Leitura básica de EXPLAIN ANALYZE.

Os conhecimentos dos módulos anteriores serão utilizados continuamente.

---

## 11. Próximo módulo

Após a conclusão do Módulo 05, o curso avançará para:

**Módulo 06 — Subconsultas (Subqueries)**

Serão estudadas consultas aninhadas, subconsultas escalares, correlacionadas, EXISTS, IN, ANY, ALL e suas aplicações.

---

## 12. Regras de preservação do banco

O banco TechStore deverá permanecer preservado durante este módulo.

Regras obrigatórias:

- Utilizar consultas de leitura.
- Não executar INSERT, UPDATE ou DELETE.
- Não modificar a estrutura das tabelas.
- Não apagar ou recriar o banco.
- Não executar novamente a seed.
- Não remover índices existentes.
- Não alterar configurações do PostgreSQL.
- Analisar consultas potencialmente pesadas antes de executá-las.

Qualquer exercício que exija modificação de dados deverá utilizar um ambiente separado ou uma estratégia explicitamente autorizada.

---

## 13. Status do módulo

| Documento | Status |
|---|---|
| README.md | Concluído |
| teoria.md | Pendente |
| atividades.md | Pendente |
| validacao.md | Pendente |
| consultas.sql | Pendente |
| Aulas | Não iniciadas |

**Situação atual:** planejamento e organização documental.

A documentação será preparada antes do início das aulas, mantendo o padrão adotado nos módulos anteriores.