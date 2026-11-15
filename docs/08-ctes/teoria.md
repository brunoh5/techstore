# Teoria — Módulo 08: CTEs (Common Table Expressions)

## 1. Introdução às CTEs

CTE significa *Common Table Expression*, ou Expressão de Tabela Comum.

É um recurso SQL que permite definir um resultado intermediário nomeado e utilizá-lo dentro de uma consulta maior.

Uma CTE funciona como uma fonte temporária de dados durante a execução da instrução SQL.

Seu principal objetivo é permitir que consultas complexas sejam organizadas em etapas lógicas.

Imagine uma consulta que precisa:

1. Identificar pedidos realizados.
2. Calcular o total de cada pedido.
3. Identificar os clientes responsáveis.
4. Calcular o valor total comprado por cliente.
5. Classificar os clientes conforme o volume de compras.

É possível construir tudo em uma única consulta, mas isso pode dificultar a leitura e a manutenção.

Com CTEs, podemos separar essas etapas e dar nomes aos resultados intermediários.

### 1.1 CTE não é uma tabela física

Uma CTE não cria automaticamente uma tabela permanente no banco.

Ela existe somente durante a execução da instrução SQL em que foi declarada.

Compare:

| Recurso | Característica |
|---|---|
| CTE | Resultado nomeado dentro de uma instrução |
| Tabela física | Estrutura persistente no banco |
| Tabela temporária | Estrutura temporária criada na sessão |
| Subconsulta | Consulta aninhada dentro de outra consulta |
| View | Consulta armazenada no banco |

Uma CTE não deve ser confundida com uma tabela temporária. Apesar de ambas poderem representar resultados intermediários, possuem funcionamento e escopo diferentes.

---

## 2. Sintaxe da cláusula WITH

A estrutura básica de uma CTE é:

```sql
WITH nome_cte AS (
    SELECT ...
)
SELECT *
FROM nome_cte;
```

A cláusula `WITH` declara a CTE antes da consulta principal.

Observe a estrutura:

- `WITH`: inicia a declaração.
- `nome_cte`: identifica o resultado intermediário.
- `AS`: introduz a consulta que define o resultado.
- Parênteses: delimitam a consulta interna.
- Consulta principal: utiliza a CTE como fonte de dados.

### 2.1 Primeiro exemplo na TechStore

```sql
WITH produtos_ativos AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
    WHERE ativo = TRUE
)
SELECT *
FROM produtos_ativos;
```

A primeira parte define uma CTE chamada `produtos_ativos`.

A consulta principal utiliza essa CTE como se fosse uma relação disponível para consulta.

Observe que não foi criada nenhuma tabela física.

### 2.2 CTE com alias

É possível definir nomes para as colunas da CTE:

```sql
WITH produtos_ativos (
    produto_id,
    descricao,
    preco_venda
) AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
    WHERE ativo = TRUE
)
SELECT *
FROM produtos_ativos;
```

Os nomes declarados após o nome da CTE correspondem às colunas retornadas pela consulta interna, na ordem em que aparecem.

A quantidade de nomes precisa corresponder à quantidade de colunas retornadas.

---

## 3. CTE com filtros

Uma CTE pode utilizar `WHERE`, operadores lógicos, expressões e funções normalmente disponíveis em uma consulta SQL.

Exemplo:

```sql
WITH produtos_economicos AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
    WHERE preco < 100
)
SELECT
    id,
    nome,
    preco
FROM produtos_economicos
ORDER BY preco;
```

A CTE define o conjunto de produtos que atende à condição.

A consulta principal decide como utilizar esse conjunto.

### 3.1 Filtro na CTE versus filtro externo

Considere:

```sql
WITH produtos AS (
    SELECT
        id,
        nome,
        preco,
        ativo
    FROM techstore.produtos
)
SELECT *
FROM produtos
WHERE ativo = TRUE;
```

Agora compare com:

```sql
WITH produtos AS (
    SELECT
        id,
        nome,
        preco,
        ativo
    FROM techstore.produtos
    WHERE ativo = TRUE
)
SELECT *
FROM produtos;
```

Os resultados podem ser equivalentes.

Entretanto, a organização da consulta é diferente.

A escolha depende da responsabilidade de cada etapa e de como o resultado será utilizado.

Também é importante compreender que o PostgreSQL pode otimizar a consulta e empurrar filtros para etapas anteriores, dependendo da possibilidade de otimização e da materialização.

Portanto, a posição visual do filtro não determina necessariamente a ordem física de execução.

---

## 4. CTE com agregações

CTEs são muito úteis para separar cálculos agregados da consulta principal.

Exemplo:

```sql
WITH vendas_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade_pedidos
    FROM techstore.pedidos
    GROUP BY cliente_id
)
SELECT
    c.id,
    c.nome,
    COALESCE(v.quantidade_pedidos, 0) AS quantidade_pedidos
FROM techstore.clientes AS c
LEFT JOIN vendas_por_cliente AS v
    ON v.cliente_id = c.id
ORDER BY quantidade_pedidos DESC;
```

Observe as responsabilidades:

1. A CTE calcula a quantidade de pedidos por cliente.
2. A consulta principal relaciona o resultado com os clientes.
3. O `LEFT JOIN` preserva clientes sem pedidos.
4. O `COALESCE` substitui o resultado `NULL` por zero.

Essa separação facilita a compreensão da consulta.

### 4.1 CTE com HAVING

Também podemos aplicar condições sobre resultados agregados:

```sql
WITH vendas_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade_pedidos
    FROM techstore.pedidos
    GROUP BY cliente_id
    HAVING COUNT(*) > 5
)
SELECT *
FROM vendas_por_cliente
ORDER BY quantidade_pedidos DESC;
```

O `HAVING` filtra os grupos antes de a consulta principal utilizar o resultado da CTE.

---

## 5. Múltiplas CTEs

Uma consulta pode declarar várias CTEs utilizando a mesma cláusula `WITH`.

Cada CTE é separada por vírgula.

Sintaxe:

```sql
WITH cte_1 AS (
    SELECT ...
),
cte_2 AS (
    SELECT ...
),
cte_3 AS (
    SELECT ...
)
SELECT ...
FROM cte_1;
```

As CTEs podem ser utilizadas pela consulta principal e por outras CTEs posteriores, respeitando as regras de escopo e dependência.

### 5.1 Exemplo com duas CTEs

```sql
WITH pedidos_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS quantidade_pedidos
    FROM techstore.pedidos
    GROUP BY cliente_id
),
clientes_compras AS (
    SELECT
        c.id,
        c.nome,
        p.quantidade_pedidos
    FROM techstore.clientes AS c
    INNER JOIN pedidos_por_cliente AS p
        ON p.cliente_id = c.id
)
SELECT *
FROM clientes_compras
ORDER BY quantidade_pedidos DESC;
```

A segunda CTE utiliza o resultado da primeira.

A consulta principal utiliza o resultado da segunda.

Isso cria uma sequência lógica de processamento.

### 5.2 Dependência entre CTEs

Uma CTE pode depender de outra CTE declarada anteriormente.

Exemplo conceitual:

```sql
WITH etapa_1 AS (
    SELECT ...
),
etapa_2 AS (
    SELECT ...
    FROM etapa_1
),
etapa_3 AS (
    SELECT ...
    FROM etapa_2
)
SELECT *
FROM etapa_3;
```

Esse formato é chamado de encadeamento de CTEs.

É especialmente útil quando cada etapa possui uma responsabilidade bem definida.

**Atenção:** uma CTE comum não pode referenciar livremente outra CTE que ainda não foi declarada. A recursividade possui regras específicas, estudadas posteriormente.

---

## 6. CTE com JOIN

Uma CTE pode realizar junções internamente ou ser utilizada como fonte em um JOIN externo.

Exemplo:

```sql
WITH produtos_vendidos AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT
    p.id,
    p.nome,
    COALESCE(v.unidades_vendidas, 0) AS unidades_vendidas
FROM techstore.produtos AS p
LEFT JOIN produtos_vendidos AS v
    ON v.produto_id = p.id
ORDER BY unidades_vendidas DESC;
```

A CTE calcula a quantidade vendida de cada produto.

A consulta externa relaciona esse resultado ao catálogo.

Observe que a agregação acontece antes da junção.

Isso ajuda a preservar a granularidade de uma linha por produto.

### 6.1 Por que a granularidade importa?

Imagine que um produto apareça em 100 itens de pedidos.

Se relacionarmos diretamente o catálogo com os itens, o produto poderá aparecer 100 vezes.

Se a intenção for apresentar uma linha por produto, podemos agregar os itens antes da junção.

A CTE ajuda a separar essas etapas.

Entretanto, ela não corrige automaticamente problemas de cardinalidade. O aluno precisa compreender a granularidade de cada conjunto.

---

## 7. CTE com operações de conjuntos

As CTEs também podem conter `UNION`, `UNION ALL`, `INTERSECT` e `EXCEPT`.

Exemplo:

```sql
WITH clientes_com_pedidos AS (
    SELECT cliente_id
    FROM techstore.pedidos
    WHERE cliente_id IS NOT NULL

    UNION

    SELECT cliente_id
    FROM techstore.acessos
    WHERE cliente_id IS NOT NULL
)
SELECT
    c.id,
    c.nome
FROM techstore.clientes AS c
INNER JOIN clientes_com_pedidos AS cp
    ON cp.cliente_id = c.id;
```

A CTE consolida identificadores de clientes que aparecem em pedidos ou acessos.

A consulta principal utiliza o conjunto consolidado.

Esse tipo de construção combina os conhecimentos dos módulos anteriores.

---

## 8. CTE com Window Functions

Uma CTE pode preparar os dados para uma função de janela.

Exemplo:

```sql
WITH vendas_por_produto AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
),
ranking_produtos AS (
    SELECT
        produto_id,
        unidades_vendidas,
        RANK() OVER (
            ORDER BY unidades_vendidas DESC
        ) AS posicao
    FROM vendas_por_produto
)
SELECT
    p.nome,
    r.unidades_vendidas,
    r.posicao
FROM ranking_produtos AS r
INNER JOIN techstore.produtos AS p
    ON p.id = r.produto_id
ORDER BY r.posicao;
```

A primeira CTE calcula as unidades vendidas.

A segunda aplica uma função de janela para classificar os produtos.

A consulta principal recupera os nomes.

Essa estrutura demonstra como CTEs podem organizar consultas analíticas.

O conteúdo completo de Window Functions será aprofundado no Módulo 09.

---

## 9. CTE versus subconsulta

Uma CTE e uma subconsulta podem produzir resultados semelhantes.

A diferença principal está na forma de organização e em algumas características de planejamento e execução.

### 9.1 Exemplo com subconsulta

```sql
SELECT
    p.id,
    p.nome,
    v.unidades_vendidas
FROM techstore.produtos AS p
INNER JOIN (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
) AS v
    ON v.produto_id = p.id;
```

### 9.2 Exemplo equivalente com CTE

```sql
WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT
    p.id,
    p.nome,
    v.unidades_vendidas
FROM techstore.produtos AS p
INNER JOIN vendas AS v
    ON v.produto_id = p.id;
```

As duas consultas expressam a mesma ideia.

A CTE separa a definição do resultado intermediário da consulta principal.

A subconsulta mantém a definição dentro do `FROM`.

### 9.3 Quando utilizar cada uma?

| Situação | Alternativa possível |
|---|---|
| Consulta curta e localizada | Subconsulta |
| Consulta com várias etapas | CTE |
| Resultado intermediário reutilizado na mesma instrução | CTE |
| Consulta simples dentro do FROM | Tabela derivada |
| Necessidade de recursividade | CTE recursiva |
| Resultado persistente entre instruções | Tabela ou tabela temporária |

A escolha deve considerar clareza, semântica e desempenho.

Não existe uma regra universal segundo a qual CTE seja sempre mais rápida ou mais lenta.

---

## 10. Escopo e reutilização das CTEs

Uma CTE comum existe apenas durante a instrução em que foi declarada.

Exemplo:

```sql
WITH produtos AS (
    SELECT id, nome
    FROM techstore.produtos
)
SELECT *
FROM produtos;
```

Após a execução dessa instrução, o nome `produtos` deixa de estar disponível.

Uma nova instrução não pode utilizar essa CTE sem declará-la novamente.

### 10.1 Reutilização dentro da mesma instrução

Uma CTE pode ser referenciada mais de uma vez na consulta que a declara.

Exemplo:

```sql
WITH produtos AS (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT
    p1.nome AS produto_1,
    p2.nome AS produto_2
FROM produtos AS p1
CROSS JOIN produtos AS p2
WHERE p1.id < p2.id
  AND p1.preco = p2.preco
LIMIT 20;
```

O exemplo utiliza a mesma CTE em dois pontos da consulta.

Isso não significa que o resultado será obrigatoriamente recalculado a cada referência.

O comportamento depende do planejamento e das regras de materialização do PostgreSQL.

---

## 11. Introdução às CTEs recursivas

Uma CTE recursiva é uma CTE capaz de referenciar seu próprio resultado.

Ela é declarada utilizando:

```sql
WITH RECURSIVE
```

Esse recurso permite trabalhar com dados que possuem relações hierárquicas ou estruturas que exigem expansão progressiva.

Exemplos de aplicações:

- Hierarquia organizacional.
- Estrutura de categorias.
- Árvore de comentários.
- Estrutura de pastas.
- Caminhos em grafos.
- Relacionamentos entre elementos.
- Sequências numéricas.

### 11.1 Por que utilizar recursividade?

Imagine uma estrutura hierárquica:

```text
Diretoria
├── Gerência A
│   ├── Equipe A1
│   └── Equipe A2
└── Gerência B
    └── Equipe B1
```

Se quisermos localizar todos os níveis abaixo da diretoria, uma consulta simples pode não ser suficiente.

O número de níveis pode variar.

Uma CTE recursiva permite percorrer a estrutura progressivamente.

---

## 12. Estrutura de uma CTE recursiva

Uma CTE recursiva normalmente possui duas partes:

1. Consulta âncora.
2. Consulta recursiva.

Estrutura:

```sql
WITH RECURSIVE nome_cte AS (

    -- Consulta âncora
    SELECT ...

    UNION ALL

    -- Parte recursiva
    SELECT ...
    FROM tabela
    INNER JOIN nome_cte
        ON ...

)
SELECT *
FROM nome_cte;
```

### 12.1 Consulta âncora

É a consulta inicial.

Ela estabelece os primeiros registros que farão parte do resultado.

A consulta âncora não depende de iterações anteriores.

### 12.2 Parte recursiva

É a consulta que referencia a própria CTE.

Ela utiliza os resultados encontrados anteriormente para localizar novos registros.

### 12.3 UNION ALL

O operador utilizado normalmente entre a parte âncora e a parte recursiva é `UNION ALL`.

Ele preserva as ocorrências e evita a deduplicação automática de cada etapa.

O uso de `UNION` também é possível em determinadas situações, mas pode modificar o comportamento da recursão e adicionar custo de deduplicação.

A escolha precisa considerar a semântica pretendida.

---

## 13. Primeiro exemplo recursivo

Podemos utilizar uma sequência numérica para compreender a recursividade sem depender de tabelas.

```sql
WITH RECURSIVE numeros AS (
    SELECT 1 AS numero

    UNION ALL

    SELECT numero + 1
    FROM numeros
    WHERE numero < 10
)
SELECT *
FROM numeros;
```

A consulta funciona da seguinte maneira:

**Etapa inicial:**

A consulta âncora produz o número 1.

**Primeira iteração:**

A parte recursiva recebe 1 e produz 2.

**Segunda iteração:**

Recebe 2 e produz 3.

O processo continua até atingir o limite estabelecido.

**Finalização:**

Quando o número chega a 10, a condição deixa de permitir novos registros.

A recursão termina quando a parte recursiva não produz novas linhas.

Esse exemplo é fundamental para compreender o mecanismo.

---

## 14. Como o PostgreSQL executa uma CTE recursiva

O PostgreSQL utiliza um mecanismo iterativo para executar CTEs recursivas.

De forma simplificada:

1. Executa a consulta âncora.
2. Armazena seu resultado inicial.
3. Utiliza esse resultado como entrada da parte recursiva.
4. Produz uma nova geração de registros.
5. Utiliza os novos registros como entrada da próxima iteração.
6. Repete o processo enquanto existirem novos registros.

O resultado final reúne as linhas produzidas pela consulta âncora e pelas iterações recursivas.

### 14.1 Conceitos importantes

- **Resultado inicial:** linhas produzidas pela âncora.
- **Conjunto de trabalho:** linhas utilizadas na iteração atual.
- **Novo resultado:** linhas produzidas pela parte recursiva.
- **Iteração:** uma execução da parte recursiva sobre o conjunto de trabalho.
- **Condição de parada:** regra que impede novas iterações.

Esse mecanismo é iterativo, embora a consulta seja descrita de maneira recursiva.

### 14.2 Nós do plano

Em planos de execução, uma CTE recursiva pode apresentar nós como:

- `Recursive Union`.
- `WorkTable Scan`.
- `CTE Scan`.

A interpretação desses nós será aprofundada nos estudos de desempenho.

---

## 15. Condições de parada

Toda recursão precisa possuir uma estratégia de encerramento.

No exemplo anterior:

```sql
WHERE numero < 10
```

A condição limita a geração de novos números.

Sem uma condição adequada, a recursão pode continuar indefinidamente ou consumir recursos excessivos.

### 15.1 Riscos de recursão infinita

Uma estrutura hierárquica pode possuir ciclos.

Exemplo conceitual:

```text
A → B
B → C
C → A
```

Se a consulta não controlar a repetição, poderá continuar percorrendo os mesmos elementos.

Problemas possíveis:

- Consumo elevado de CPU.
- Consumo de memória.
- Crescimento do resultado intermediário.
- Tempo excessivo de execução.
- Interrupção por limites de recursos.

A prevenção de ciclos será obrigatória nos exercícios que envolvam grafos ou relacionamentos potencialmente cíclicos.

---

## 16. Hierarquias e caminhos

Uma aplicação importante das CTEs recursivas é percorrer hierarquias.

Para estudar esse comportamento sem modificar a TechStore, podemos utilizar uma estrutura de demonstração com `VALUES`.

Exemplo:

```sql
WITH RECURSIVE hierarquia AS (
    SELECT
        id,
        nome,
        gestor_id
    FROM (
        VALUES
            (1, 'Diretoria', NULL::INTEGER),
            (2, 'Gerencia A', 1),
            (3, 'Gerencia B', 1),
            (4, 'Equipe A1', 2),
            (5, 'Equipe A2', 2),
            (6, 'Equipe B1', 3)
    ) AS estrutura(id, nome, gestor_id)
    WHERE gestor_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.nome,
        e.gestor_id
    FROM (
        VALUES
            (1, 'Diretoria', NULL::INTEGER),
            (2, 'Gerencia A', 1),
            (3, 'Gerencia B', 1),
            (4, 'Equipe A1', 2),
            (5, 'Equipe A2', 2),
            (6, 'Equipe B1', 3)
    ) AS e(id, nome, gestor_id)
    INNER JOIN hierarquia AS h
        ON e.gestor_id = h.id
)
SELECT *
FROM hierarquia;
```

A consulta começa pela raiz da estrutura e encontra progressivamente os elementos subordinados.

O exemplo é exclusivamente didático. Não pressupõe que a tabela `funcionarios` da TechStore possua uma coluna `gestor_id`.

### 16.1 Controle de profundidade

Podemos adicionar uma coluna que represente o nível hierárquico.

Conceitualmente:

- Raiz: nível 0.
- Primeiro nível: nível 1.
- Segundo nível: nível 2.
- Terceiro nível: nível 3.

Essa informação permite limitar a profundidade da recursão e facilitar a interpretação do resultado.

### 16.2 Construção de caminhos

Também podemos construir uma representação textual do caminho percorrido.

Por exemplo:

```text
Diretoria
Diretoria > Gerencia A
Diretoria > Gerencia A > Equipe A1
Diretoria > Gerencia A > Equipe A2
```

O caminho ajuda a identificar a posição de cada elemento dentro da hierarquia.

---

## 17. Prevenção de ciclos

Existem diferentes estratégias para impedir que a recursão percorra elementos repetidamente.

### 17.1 Rastreamento de caminho

Podemos armazenar os identificadores visitados em um array.

Antes de visitar um novo elemento, verificamos se ele já aparece no caminho.

Exemplo conceitual:

```sql
WITH RECURSIVE caminhos AS (
    SELECT
        id,
        gestor_id,
        ARRAY[id] AS caminho
    FROM estrutura
    WHERE gestor_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.gestor_id,
        c.caminho || e.id
    FROM estrutura AS e
    INNER JOIN caminhos AS c
        ON e.gestor_id = c.id
    WHERE NOT e.id = ANY(c.caminho)
)
SELECT *
FROM caminhos;
```

O array registra os elementos visitados.

A condição impede que um identificador já presente no caminho seja visitado novamente.

### 17.2 Cláusula CYCLE

O PostgreSQL 16 oferece a cláusula `CYCLE` para detectar ciclos em consultas recursivas.

Sua utilização permite declarar:

- Colunas utilizadas para identificar ciclos.
- Coluna que indicará se um ciclo foi encontrado.
- Coluna que armazenará o caminho.

Exemplo conceitual:

```sql
WITH RECURSIVE caminhos AS (
    SELECT
        id,
        gestor_id
    FROM estrutura
    WHERE gestor_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.gestor_id
    FROM estrutura AS e
    INNER JOIN caminhos AS c
        ON e.gestor_id = c.id
)
CYCLE id SET ciclo_detectado USING caminho
SELECT *
FROM caminhos;
```

A cláusula adiciona informações para identificar ciclos e controlar sua expansão.

É importante compreender que a detecção de ciclos depende das colunas escolhidas para representar a identidade dos elementos.

A estratégia precisa refletir corretamente a estrutura dos dados.

---

## 18. Cláusula SEARCH

O PostgreSQL também oferece a cláusula `SEARCH` para definir uma coluna de ordenação de percurso em CTEs recursivas.

Ela permite solicitar uma ordenação que represente:

- Busca em profundidade (*Depth First*).
- Busca em largura (*Breadth First*).

Exemplo conceitual:

```sql
WITH RECURSIVE arvore AS (
    SELECT
        id,
        gestor_id,
        nome
    FROM estrutura
    WHERE gestor_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.gestor_id,
        e.nome
    FROM estrutura AS e
    INNER JOIN arvore AS a
        ON e.gestor_id = a.id
)
SEARCH DEPTH FIRST BY id SET ordem
SELECT *
FROM arvore
ORDER BY ordem;
```

A coluna `ordem` é gerada para representar a sequência de percurso.

**Importante:** `SEARCH` define uma coluna de ordenação para o resultado. Ela não deve ser confundida com uma garantia de ordem física de execução das iterações internas.

---

## 19. Materialização de CTEs

Um dos assuntos mais importantes deste módulo é compreender como o PostgreSQL trata CTEs durante o planejamento e a execução.

Uma CTE pode ser materializada.

Materializar significa produzir e armazenar um resultado intermediário para que ele seja consumido posteriormente.

Entretanto, nem toda CTE é obrigatoriamente materializada.

### 19.1 Comportamento padrão no PostgreSQL 16

No PostgreSQL 16, o comportamento depende das características da CTE.

Em termos gerais:

- Uma CTE não recursiva, sem efeitos colaterais e referenciada uma única vez pode ser incorporada à consulta principal.
- Uma CTE referenciada várias vezes normalmente é materializada por padrão.
- CTEs recursivas não seguem a mesma regra de incorporação das CTEs comuns.
- CTEs com características que impedem a otimização conjunta podem permanecer materializadas.

A possibilidade de incorporação permite ao otimizador analisar a consulta de forma mais ampla.

Isso pode possibilitar o empurramento de filtros e outras otimizações.

### 19.2 MATERIALIZED

A palavra-chave `MATERIALIZED` força a materialização de uma CTE.

Exemplo:

```sql
WITH vendas AS MATERIALIZED (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT *
FROM vendas;
```

A materialização pode ser interessante quando um resultado intermediário será utilizado várias vezes.

Entretanto, também pode impedir certas otimizações que seriam possíveis se a CTE fosse incorporada à consulta principal.

### 19.3 NOT MATERIALIZED

A palavra-chave `NOT MATERIALIZED` permite solicitar que uma CTE elegível seja incorporada à consulta principal.

Exemplo:

```sql
WITH produtos AS NOT MATERIALIZED (
    SELECT
        id,
        nome,
        preco
    FROM techstore.produtos
)
SELECT *
FROM produtos
WHERE preco > 100;
```

O PostgreSQL pode tratar essa consulta de maneira semelhante a uma consulta direta sobre a tabela.

Isso permite que o filtro seja considerado no planejamento da consulta principal.

**Atenção:** `NOT MATERIALIZED` não significa que o resultado nunca será armazenado em estruturas intermediárias durante a execução. A opção trata da estratégia de planejamento da CTE, não de uma proibição absoluta de qualquer armazenamento temporário.

Também não pode ser aplicada a CTEs recursivas.

### 19.4 Comparação

| Característica | MATERIALIZED | NOT MATERIALIZED |
|---|---|---|
| Estratégia | Resultado intermediário materializado | Permite incorporação |
| Filtros externos | Podem não ser empurrados para dentro | Podem ser empurrados |
| Reutilização | Pode evitar recomputação | Pode repetir trabalho |
| Otimização conjunta | Mais limitada | Mais flexível |
| Uso ideal | Reutilização e isolamento do resultado | Otimização conjunta e filtros seletivos |

Nenhuma das duas opções é universalmente melhor.

A decisão deve ser baseada em evidências do plano de execução e na semântica da consulta.

---

## 20. CTE versus tabela temporária

É importante diferenciar esses recursos.

### CTE

- Existe dentro de uma instrução.
- Não exige criação de uma tabela física.
- Pode ser recursiva.
- Ajuda a organizar consultas.
- Não é reutilizável automaticamente em outra instrução.

### Tabela temporária

- É criada como um objeto temporário.
- Pode ser utilizada em várias instruções durante sua existência.
- Pode receber índices.
- Pode armazenar resultados intermediários entre etapas.
- Possui ciclo de vida associado à sessão ou transação, conforme sua configuração.

Uma tabela temporária pode ser útil quando precisamos reutilizar um resultado em várias instruções.

Uma CTE costuma ser mais apropriada quando o objetivo é estruturar uma única consulta.

---

## 21. CTEs e DML

CTEs também podem ser utilizadas com operações de modificação de dados no PostgreSQL.

O PostgreSQL permite que uma cláusula `WITH` contenha instruções como:

- `INSERT`.
- `UPDATE`.
- `DELETE`.
- `MERGE`.

Essas construções são conhecidas como *data-modifying statements in WITH*.

Exemplo meramente estrutural:

```sql
WITH resultado AS (
    DELETE FROM tabela_exemplo
    WHERE id = 1
    RETURNING *
)
SELECT *
FROM resultado;
```

A instrução demonstra que uma CTE não está restrita a consultas `SELECT`.

**Regra para este curso:** os exercícios deste módulo utilizarão consultas de leitura. Não execute exemplos de DML na TechStore principal.

As operações de modificação de dados serão estudadas com controle de transações e ambientes apropriados no Módulo 10.

---

## 22. Desempenho de CTEs

Uma CTE não garante melhoria de desempenho.

Ela pode melhorar a organização da consulta sem modificar significativamente seu custo.

Em determinadas situações, pode até produzir um plano menos eficiente do que uma consulta equivalente com subconsulta ou JOIN.

O desempenho depende de fatores como:

- Volume de dados.
- Seletividade dos filtros.
- Quantidade de referências à CTE.
- Materialização.
- Reutilização do resultado.
- Índices disponíveis.
- Cardinalidade.
- Estratégia do otimizador.
- Custos de ordenação e agregação.

### 22.1 EXPLAIN

O comando `EXPLAIN` apresenta o plano estimado.

Exemplo:

```sql
EXPLAIN
WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT *
FROM vendas;
```

Observe:

- Nós de agregação.
- Estimativas de linhas.
- Custos estimados.
- Possíveis operações de leitura.
- Presença de materialização, quando aplicável.

### 22.2 EXPLAIN ANALYZE

Para obter informações reais de execução:

```sql
EXPLAIN (ANALYZE, BUFFERS)
WITH vendas AS (
    SELECT
        produto_id,
        SUM(quantidade) AS unidades_vendidas
    FROM techstore.itens_pedido
    GROUP BY produto_id
)
SELECT *
FROM vendas;
```

Esse comando executa a consulta.

Observe:

- Planning Time.
- Execution Time.
- Actual Rows.
- Estimated Rows.
- Shared Hit Blocks.
- Shared Read Blocks.
- Nós do plano.
- Diferenças entre estimativas e resultados reais.

Execute análises individualmente.

### 22.3 CTE Scan

Um plano pode apresentar o nó `CTE Scan`.

Esse nó indica a leitura do resultado de uma CTE materializada.

Sua presença deve ser interpretada em conjunto com o restante do plano.

Não é necessariamente um problema.

### 22.4 Otimização e empurramento de filtros

Quando uma CTE é incorporada à consulta principal, o otimizador pode conseguir aplicar filtros mais cedo.

Isso pode reduzir o volume de dados processados.

Por outro lado, quando a CTE é materializada, filtros externos podem não ser incorporados à consulta interna.

Essa diferença pode afetar o custo total.

O objetivo da análise é verificar se a estratégia escolhida realmente ajuda.

---

## 23. Erros frequentes

### 23.1 Acreditar que toda CTE é mais rápida

CTEs melhoram a organização, mas não garantem desempenho superior.

### 23.2 Criar CTEs desnecessárias

Separar uma consulta simples em muitas etapas pode aumentar a complexidade sem trazer benefícios.

### 23.3 Não compreender a dependência entre CTEs

Uma CTE pode utilizar outra CTE declarada anteriormente, mas a ordem e o escopo das declarações precisam ser respeitados.

### 23.4 Esquecer a condição de parada

Uma CTE recursiva sem controle pode gerar uma execução excessivamente longa.

### 23.5 Não controlar ciclos

Estruturas hierárquicas podem conter referências circulares.

É necessário planejar uma estratégia de prevenção.

### 23.6 Confundir materialização com persistência

Uma CTE materializada não se transforma em uma tabela permanente.

Sua existência continua limitada à instrução.

### 23.7 Utilizar NOT MATERIALIZED sem analisar o plano

A incorporação pode aumentar o trabalho quando uma CTE é utilizada várias vezes.

### 23.8 Confundir ordenação do resultado com ordem de execução

A ordem de apresentação deve ser definida com `ORDER BY`.

A estrutura recursiva não deve ser interpretada como garantia de ordenação final.

### 23.9 Ignorar cardinalidade

Uma CTE pode produzir muitas linhas e multiplicar resultados em JOINs posteriores.

É necessário compreender a granularidade de cada etapa.

---

## 24. Boas práticas

1. Utilize nomes que representem claramente a finalidade da CTE.
2. Separe etapas quando isso melhorar a compreensão.
3. Evite criar CTEs sem necessidade.
4. Utilize aliases claros.
5. Declare explicitamente as colunas quando isso melhorar a legibilidade.
6. Observe a granularidade de cada resultado intermediário.
7. Evite reutilizar nomes que confundam tabelas e CTEs.
8. Utilize `WITH RECURSIVE` somente quando houver necessidade real de recursividade.
9. Defina condições de parada.
10. Considere a possibilidade de ciclos.
11. Utilize `CYCLE` quando apropriado.
12. Avalie `MATERIALIZED` e `NOT MATERIALIZED` com base em medições.
13. Compare alternativas equivalentes.
14. Utilize `EXPLAIN` antes de tirar conclusões sobre desempenho.
15. Preserve a semântica ao otimizar.

---

## 25. Referência rápida

| Recurso | Finalidade |
|---|---|
| `WITH` | Declarar CTEs |
| `WITH RECURSIVE` | Declarar CTEs recursivas |
| `AS` | Definir a consulta da CTE |
| `UNION ALL` | Combinar âncora e parte recursiva preservando ocorrências |
| `MATERIALIZED` | Forçar materialização |
| `NOT MATERIALIZED` | Permitir incorporação da CTE elegível |
| `SEARCH` | Gerar coluna de ordenação do percurso |
| `CYCLE` | Detectar ciclos |
| `EXPLAIN` | Examinar plano estimado |
| `EXPLAIN ANALYZE` | Executar e analisar plano real |

---

## 26. Documentação oficial

Referências do PostgreSQL 16:

- WITH Queries: https://www.postgresql.org/docs/16/queries-with.html
- SELECT: https://www.postgresql.org/docs/16/sql-select.html
- EXPLAIN: https://www.postgresql.org/docs/16/sql-explain.html
- Recursive Queries: https://www.postgresql.org/docs/16/queries-with.html#QUERIES-WITH-RECURSIVE
- Materialization: https://www.postgresql.org/docs/16/queries-with.html#QUERIES-WITH-CTE-MATERIALIZATION

A documentação oficial deve ser utilizada como referência para detalhes de sintaxe, comportamento e limitações.

---

## 27. Resultados esperados

Ao finalizar a teoria, o aluno deverá conseguir:

- Criar CTEs simples.
- Organizar consultas em múltiplas etapas.
- Encadear CTEs dependentes.
- Integrar CTEs com JOINs e agregações.
- Combinar CTEs com operações de conjuntos.
- Utilizar CTEs em análises com Window Functions.
- Explicar a diferença entre CTE e subconsulta.
- Explicar a diferença entre CTE e tabela temporária.
- Criar CTEs recursivas simples.
- Identificar âncora e parte recursiva.
- Definir condições de parada.
- Reconhecer e prevenir ciclos.
- Compreender `SEARCH` e `CYCLE`.
- Explicar materialização.
- Diferenciar `MATERIALIZED` e `NOT MATERIALIZED`.
- Analisar planos de execução.
- Comparar alternativas sem perder a correção lógica.

**O objetivo final é conseguir estruturar consultas complexas de maneira organizada, compreender como o PostgreSQL executa essas consultas e tomar decisões técnicas fundamentadas em resultados e medições.**