# Módulo 09 — Window Functions

## 1. Apresentação

Window Functions (funções de janela) permitem realizar cálculos sobre um conjunto de linhas relacionadas à linha atual, sem reduzir o resultado a uma única linha por grupo.

Diferentemente das agregações tradicionais com `GROUP BY`, as funções de janela preservam as linhas individuais enquanto calculam informações adicionais.

Este módulo desenvolverá a capacidade de construir consultas analíticas mais avançadas, utilizando os dados da TechStore.

O foco será compreender não apenas a sintaxe, mas também o comportamento das janelas, particionamento, ordenação, frames, empates e desempenho.

**Banco utilizado:** PostgreSQL 16  
**Schema principal:** `techstore`  
**Nível:** Profissional  
**Metodologia:** Mastery Learning

---

## 2. Objetivos do módulo

Ao concluir este módulo, o aluno deverá ser capaz de:

- Compreender o funcionamento das Window Functions.
- Diferenciar agregações tradicionais de funções de janela.
- Utilizar `OVER`.
- Definir partições com `PARTITION BY`.
- Definir ordenação com `ORDER BY`.
- Compreender e configurar window frames.
- Utilizar funções de ranking.
- Identificar e tratar empates.
- Utilizar funções de navegação entre linhas.
- Trabalhar com valores anteriores e posteriores.
- Calcular acumulados.
- Calcular médias móveis.
- Comparar linhas dentro de grupos.
- Construir análises temporais.
- Combinar Window Functions com CTEs, JOINs e agregações.
- Interpretar planos de execução.
- Identificar oportunidades de otimização.

---

## 3. Conteúdo programático

### 3.1 Fundamentos de Window Functions

- Conceito de janela.
- Diferença entre `GROUP BY` e Window Functions.
- Funcionamento da cláusula `OVER`.
- Ordem lógica de processamento.
- Resultado por linha.
- Aplicações analíticas.

### 3.2 PARTITION BY

- Conceito de partição.
- Separação de grupos.
- Particionamento por uma coluna.
- Particionamento por múltiplas colunas.
- Comparações dentro de grupos.
- Diferença entre partição e agrupamento.

### 3.3 ORDER BY em janelas

- Ordenação dentro da janela.
- Ordenação ascendente e descendente.
- Empates.
- Ordenação composta.
- Determinismo dos resultados.
- Diferença entre ordenação da janela e ordenação final.

### 3.4 Window Frames

- Conceito de frame.
- `ROWS`.
- `RANGE`.
- `GROUPS`.
- `UNBOUNDED PRECEDING`.
- `UNBOUNDED FOLLOWING`.
- `CURRENT ROW`.
- `PRECEDING`.
- `FOLLOWING`.
- Limites da janela.
- Frame padrão do PostgreSQL.
- Diferenças práticas entre os tipos de frame.

### 3.5 Funções de ranking

- `ROW_NUMBER`.
- `RANK`.
- `DENSE_RANK`.
- `NTILE`.
- Diferenças entre as funções.
- Tratamento de empates.
- Classificações por grupo.
- Rankings comerciais.

### 3.6 Funções de navegação

- `LAG`.
- `LEAD`.
- Acesso a linhas anteriores.
- Acesso a linhas posteriores.
- Definição de deslocamento.
- Valores padrão.
- Comparação entre registros.
- Identificação de mudanças.

### 3.7 Funções de valor

- `FIRST_VALUE`.
- `LAST_VALUE`.
- `NTH_VALUE`.
- Comportamento dos frames.
- Diferença entre primeira linha da partição e primeira linha do frame.
- Tratamento de valores nulos.
- Configuração de frames completos.

### 3.8 Agregações como Window Functions

- `COUNT() OVER`.
- `SUM() OVER`.
- `AVG() OVER`.
- `MIN() OVER`.
- `MAX() OVER`.
- Totais por partição.
- Acumulados.
- Médias móveis.
- Comparação entre grupos.
- Agregações sem perder a granularidade.

### 3.9 Análises temporais

- Sequência cronológica.
- Comparação entre períodos.
- Variação entre registros.
- Crescimento percentual.
- Acumulados temporais.
- Médias móveis por período.
- Identificação de períodos anteriores e posteriores.
- Ordenação por datas e critérios de desempate.

### 3.10 Combinação com outros recursos SQL

- Window Functions com CTEs.
- Window Functions com subconsultas.
- Window Functions com JOINs.
- Window Functions com agregações.
- Window Functions com operações de conjuntos.
- Filtragem de resultados de janelas.
- Utilização de subconsultas e CTEs para filtrar rankings.
- `QUALIFY` e alternativas no PostgreSQL.

### 3.11 Desempenho e otimização

- Ordenação e particionamento.
- Sort.
- WindowAgg.
- Memória e processamento.
- Impacto de grandes partições.
- Índices e ordenação.
- `EXPLAIN`.
- `EXPLAIN ANALYZE`.
- `BUFFERS`.
- Comparação de estratégias.
- Identificação de gargalos.

### 3.12 Boas práticas e erros frequentes

- Frames incorretos.
- Empates não tratados.
- Ordenação não determinística.
- Uso inadequado de `LAST_VALUE`.
- Confusão entre `ROWS` e `RANGE`.
- Particionamento incorreto.
- Filtragem antes ou depois da janela.
- Cálculos sobre granularidade inadequada.
- Uso desnecessário de subconsultas.
- Consultas analíticas difíceis de manter.

---

## 4. Aplicações práticas na TechStore

As Window Functions serão utilizadas para resolver problemas analíticos próximos de situações reais.

| Área | Aplicação |
|---|---|
| Comercial | Ranking de produtos por faturamento |
| Comercial | Ranking de clientes por quantidade de pedidos |
| Produtos | Comparação de preços dentro de categorias |
| Produtos | Participação de cada produto no total da categoria |
| Pedidos | Comparação entre pedidos consecutivos |
| Clientes | Primeiro e último pedido |
| Clientes | Intervalo entre compras |
| Estoque | Classificação de produtos por quantidade disponível |
| Avaliações | Ranking de produtos por nota média |
| Funcionários | Comparação de movimentações por funcionário |
| Marketing | Análise de acessos por período |
| Financeiro | Acumulados e variações temporais |

Os exemplos utilizarão as colunas existentes no schema TechStore.

---

## 5. Organização dos estudos

O módulo seguirá a seguinte estrutura:

```text
docs/
└── modulo-09-window-functions/
    ├── README.md
    ├── teoria.md
    ├── atividades.md
    ├── validacao.md
    └── consultas.sql
```

### README.md

Documento de apresentação, objetivos, conteúdo programático e critérios do módulo.

### teoria.md

Explicações detalhadas dos conceitos, sintaxe, funcionamento, exemplos e comparações.

### atividades.md

Exercícios progressivos para desenvolver domínio prático.

### validacao.md

Testes independentes para avaliar a compreensão e a capacidade de aplicação.

### consultas.sql

Arquivo de referência com exemplos comentados para execução no PostgreSQL.

---

## 6. Metodologia de aprendizagem

Será utilizado o modelo Mastery Learning.

Cada conteúdo seguirá um processo progressivo:

1. Estudo da teoria.
2. Análise dos exemplos.
3. Execução das consultas.
4. Resolução das atividades.
5. Validação independente.
6. Correção dos erros.
7. Reforço direcionado.
8. Avaliação de domínio.

O próximo conteúdo será liberado quando os critérios de domínio forem alcançados.

O objetivo não é apenas conseguir escrever uma Window Function, mas compreender por que ela produz determinado resultado.

---

## 7. Desempenho e análise técnica

Neste módulo, o desempenho será observado em consultas analíticas.

Serão avaliadas métricas como:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Node Type.
- Sort.
- WindowAgg.
- Uso de índices.
- Consumo de recursos em grandes conjuntos de dados.

### Protocolo de benchmark

1. Executar a consulta original.
2. Registrar o plano e as métricas.
3. Identificar o principal gargalo.
4. Formular uma hipótese de melhoria.
5. Alterar uma variável por vez.
6. Comparar os resultados.
7. Confirmar que a lógica permaneceu equivalente.
8. Repetir as medições quando necessário.

Não será utilizada uma meta universal de tempo de execução. O desempenho será avaliado conforme a complexidade e o volume de dados de cada exercício.

---

## 8. Avaliação

A avaliação seguirá os mesmos critérios gerais do curso.

| Critério | Peso |
|---|---:|
| Correção lógica e resultados | 35% |
| Sintaxe e domínio SQL | 20% |
| Casos extremos e validação | 15% |
| Desempenho e otimização | 20% |
| Legibilidade e boas práticas | 10% |
| **Total** | **100%** |

**Nota mínima de referência: 85%.**

Erros críticos de lógica, granularidade ou segurança impedirão a aprovação até serem corrigidos.

---

## 9. Regras de preservação do banco

A TechStore continuará sendo utilizada como ambiente principal de estudo.

Regras obrigatórias:

- Não executar novamente o seed.
- Não alterar registros.
- Não excluir dados.
- Não modificar a estrutura das tabelas.
- Não criar índices durante as atividades.
- Priorizar consultas `SELECT`.
- Utilizar estruturas temporárias ou `VALUES` somente quando necessário e autorizado.
- Executar `EXPLAIN ANALYZE` individualmente.

As atividades serão projetadas para utilizar os dados existentes.

---

## 10. Pré-requisitos

Antes de iniciar este módulo, o aluno deverá dominar:

- SELECT e filtros.
- Expressões e funções SQL.
- Agregações.
- JOINs.
- Subconsultas.
- Operações de conjuntos.
- CTEs comuns e recursivas.
- Interpretação básica de planos de execução.

Especialmente importante: compreender a diferença entre agrupar linhas com `GROUP BY` e preservar as linhas utilizando funções de janela.

---

## 11. Resultados esperados

Ao concluir o módulo, o aluno deverá conseguir:

- Construir rankings com diferentes regras de empate.
- Calcular totais sem reduzir o número de linhas.
- Produzir acumulados e médias móveis.
- Comparar registros anteriores e posteriores.
- Analisar sequências temporais.
- Calcular indicadores dentro de partições.
- Combinar Window Functions com CTEs e JOINs.
- Evitar erros relacionados a frames.
- Interpretar planos com WindowAgg e Sort.
- Otimizar consultas analíticas com justificativa técnica.

---

## 12. Próximo módulo

Após a aprovação, o curso seguirá para:

**Módulo 10 — DML e Transações**

Conteúdos previstos:

- INSERT.
- UPDATE.
- DELETE.
- RETURNING.
- BEGIN.
- COMMIT.
- ROLLBACK.
- SAVEPOINT.
- Integridade e segurança em operações de escrita.

Esse módulo exigirá cuidados adicionais para preservar os dados principais da TechStore.

---

## 13. Status do módulo

| Item | Situação |
|---|---|
| README.md | Preparado |
| teoria.md | Pendente |
| atividades.md | Pendente |
| validacao.md | Pendente |
| consultas.sql | Pendente |
| Aulas | Não iniciadas |
| Avaliação | Não realizada |

**Situação geral:** planejamento do módulo iniciado.