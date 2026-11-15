-- ============================================================
-- TECHSTORE | MODULO 03
-- EXPRESSOES E FUNCOES SQL
-- PostgreSQL 16
-- ============================================================
--
-- Objetivo:
-- Demonstrar expressoes, funcoes de texto, funcoes numericas,
-- datas, conversoes, NULL, CASE e recursos do PostgreSQL.
--
-- Ambiente:
-- Banco de dados: techstore
-- Schema: techstore
--
-- IMPORTANTE:
-- Este arquivo contem somente consultas de leitura.
-- Nenhuma tabela ou registro sera modificado.
--
-- Execute os blocos individualmente e observe os resultados.
-- ============================================================


-- ============================================================
-- 01. EXPRESSOES ARITMETICAS
-- ============================================================

-- Operacoes matematicas basicas.
SELECT
    100 + 50 AS adicao,
    100 - 50 AS subtracao,
    100 * 2 AS multiplicacao,
    100.0 / 3 AS divisao,
    100 % 30 AS resto_divisao;

-- Precedencia dos operadores.
SELECT
    10 + 5 * 2 AS resultado_sem_parenteses,
    (10 + 5) * 2 AS resultado_com_parenteses;

-- Expressoes aplicadas aos produtos.
SELECT
    id,
    nome,
    preco,
    custo,
    preco - custo AS margem_bruta,
    preco * 0.10 AS desconto_simulado
FROM techstore.produtos
ORDER BY id
LIMIT 10;


-- ============================================================
-- 02. FUNCOES DE TEXTO
-- ============================================================

-- Transformacao de maiusculas e minusculas.
SELECT
    nome,
    UPPER(nome) AS nome_maiusculo,
    LOWER(nome) AS nome_minusculo,
    INITCAP(nome) AS nome_formatado
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Comprimento e remocao de espacos.
SELECT
    nome,
    LENGTH(nome) AS quantidade_caracteres,
    TRIM(nome) AS nome_sem_espacos_externos,
    UPPER(TRIM(nome)) AS nome_normalizado
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Substituicao de caracteres.
SELECT
    email,
    REPLACE(email, '@', ' [ARROBA] ') AS email_modificado
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Extracao de parte de um texto.
SELECT
    nome,
    SUBSTRING(nome FROM 1 FOR 5) AS primeiros_caracteres
FROM techstore.produtos
ORDER BY id
LIMIT 10;

-- Concatenacao de textos.
SELECT
    nome,
    email,
    CONCAT(nome, ' - ', email) AS identificacao
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Concatenacao com separador.
SELECT
    CONCAT_WS(' | ', nome, email, telefone) AS dados_cliente
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Localizacao de um trecho dentro do texto.
SELECT
    email,
    POSITION('@' IN email) AS posicao_arroba
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Separacao de partes de um texto.
SELECT
    email,
    SPLIT_PART(email, '@', 1) AS usuario_email,
    SPLIT_PART(email, '@', 2) AS dominio_email
FROM techstore.clientes
ORDER BY id
LIMIT 10;


-- ============================================================
-- 03. FUNCOES NUMERICAS
-- ============================================================

-- Arredondamento.
SELECT
    preco,
    ROUND(preco, 0) AS arredondamento_inteiro,
    ROUND(preco, 1) AS uma_casa_decimal,
    ROUND(preco, 2) AS duas_casas_decimais
FROM techstore.produtos
ORDER BY id
LIMIT 10;

-- Arredondamento para cima e para baixo.
SELECT
    preco,
    CEIL(preco) AS arredondado_para_cima,
    FLOOR(preco) AS arredondado_para_baixo
FROM techstore.produtos
ORDER BY id
LIMIT 10;

-- Valor absoluto e resto da divisao.
SELECT
    ABS(-150) AS valor_absoluto,
    MOD(17, 5) AS resto_divisao,
    POWER(2, 3) AS potencia,
    SQRT(81) AS raiz_quadrada;

-- Diferenca entre preco e custo.
SELECT
    id,
    nome,
    preco,
    custo,
    ABS(preco - custo) AS diferenca_absoluta,
    ROUND(preco - custo, 2) AS diferenca_arredondada
FROM techstore.produtos
ORDER BY id
LIMIT 10;

-- Protecao contra divisao por zero.
SELECT
    preco,
    custo,
    CASE
        WHEN preco = 0 THEN NULL
        ELSE ROUND(((preco - custo) / preco) * 100, 2)
    END AS margem_percentual
FROM techstore.produtos
ORDER BY id
LIMIT 10;


-- ============================================================
-- 04. DATAS E HORARIOS
-- ============================================================

-- Data e horario atuais.
SELECT
    CURRENT_DATE AS data_atual,
    CURRENT_TIME AS horario_atual,
    CURRENT_TIMESTAMP AS data_hora_atual;

-- Extracao de componentes de uma data.
SELECT
    data_pedido,
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    EXTRACT(DAY FROM data_pedido) AS dia
FROM techstore.pedidos
ORDER BY data_pedido
LIMIT 10;

-- DATE_PART.
SELECT
    data_pedido,
    DATE_PART('year', data_pedido) AS ano,
    DATE_PART('month', data_pedido) AS mes
FROM techstore.pedidos
ORDER BY data_pedido
LIMIT 10;

-- Agrupamento temporal por mes.
SELECT
    DATE_TRUNC('month', data_pedido) AS mes,
    COUNT(*) AS quantidade_pedidos
FROM techstore.pedidos
GROUP BY DATE_TRUNC('month', data_pedido)
ORDER BY mes;

-- Diferenca entre datas.
SELECT
    id,
    data_pedido,
    CURRENT_DATE - data_pedido::date AS dias_desde_pedido
FROM techstore.pedidos
ORDER BY data_pedido DESC
LIMIT 10;

-- Intervalos.
SELECT
    CURRENT_DATE AS hoje,
    CURRENT_DATE + INTERVAL '7 days' AS daqui_sete_dias,
    CURRENT_DATE - INTERVAL '30 days' AS trinta_dias_atras;

-- AGE.
SELECT
    data_nascimento,
    AGE(CURRENT_DATE, data_nascimento) AS idade_intervalo
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Tempo entre envio e entrega.
SELECT
    id,
    data_envio,
    data_entrega,
    AGE(data_entrega, data_envio) AS intervalo_entrega
FROM techstore.entregas
ORDER BY id
LIMIT 20;


-- ============================================================
-- 05. CONVERSAO DE TIPOS
-- ============================================================

-- Conversao explicita com CAST.
SELECT
    CAST(150 AS TEXT) AS numero_como_texto,
    CAST('250' AS INTEGER) AS texto_como_inteiro,
    CAST(125.75 AS INTEGER) AS decimal_como_inteiro;

-- Conversao com operador PostgreSQL.
SELECT
    150::TEXT AS numero_como_texto,
    '250'::INTEGER AS texto_como_inteiro,
    125.75::NUMERIC(10, 2) AS decimal_formatado;

-- Conversao de datas.
SELECT
    CAST('2026-01-15' AS DATE) AS data_convertida,
    '2026-01-15'::DATE AS data_convertida_postgresql;

-- Conversao de valores das tabelas.
SELECT
    id,
    preco,
    preco::TEXT AS preco_em_texto
FROM techstore.produtos
ORDER BY id
LIMIT 10;


-- ============================================================
-- 06. TRATAMENTO DE NULL
-- ============================================================

-- Identificacao de valores NULL.
SELECT
    id,
    cliente_id,
    data_acesso,
    pagina
FROM techstore.acessos
WHERE cliente_id IS NULL
ORDER BY id
LIMIT 20;

-- COALESCE: retorna o primeiro valor nao nulo.
SELECT
    id,
    cliente_id,
    COALESCE(cliente_id, 0) AS cliente_id_tratado
FROM techstore.acessos
ORDER BY id
LIMIT 20;

-- NULLIF: transforma valores iguais em NULL.
SELECT
    NULLIF(10, 10) AS resultado_igual,
    NULLIF(10, 5) AS resultado_diferente;

-- Comparacao entre COALESCE e NULLIF.
SELECT
    COALESCE(NULL, NULL, 'Valor padrao') AS coalesce_exemplo,
    NULLIF('A', 'A') AS nullif_exemplo;

-- Comportamento de expressoes com NULL.
SELECT
    10 + NULL AS soma_com_null,
    10 * NULL AS multiplicacao_com_null,
    'SQL' || NULL AS concatenacao_com_null;


-- ============================================================
-- 07. CASE
-- ============================================================

-- CASE simples.
SELECT
    id,
    status,
    CASE status
        WHEN 'entregue' THEN 'Concluido'
        WHEN 'em transporte' THEN 'Em andamento'
        WHEN 'cancelado' THEN 'Cancelado'
        WHEN 'processando' THEN 'Em processamento'
        ELSE 'Status desconhecido'
    END AS descricao_status
FROM techstore.pedidos
ORDER BY id
LIMIT 20;

-- CASE pesquisado.
SELECT
    id,
    preco,
    CASE
        WHEN preco >= 1000 THEN 'Alto'
        WHEN preco >= 500 THEN 'Medio'
        WHEN preco > 0 THEN 'Baixo'
        ELSE 'Sem preco positivo'
    END AS faixa_preco
FROM techstore.produtos
ORDER BY preco DESC
LIMIT 20;

-- CASE combinado com funcoes numericas.
SELECT
    id,
    preco,
    custo,
    CASE
        WHEN preco = 0 THEN 'Preco zero'
        WHEN preco > custo THEN 'Preco superior ao custo'
        WHEN preco = custo THEN 'Preco igual ao custo'
        ELSE 'Preco inferior ao custo'
    END AS situacao_comercial
FROM techstore.produtos
ORDER BY id
LIMIT 20;

-- CASE com tratamento de NULL.
SELECT
    id,
    data_entrega,
    CASE
        WHEN data_entrega IS NULL THEN 'Sem data de entrega'
        ELSE 'Data de entrega registrada'
    END AS situacao_entrega
FROM techstore.entregas
ORDER BY id
LIMIT 20;


-- ============================================================
-- 08. FUNCOES ESPECIFICAS DO POSTGRESQL
-- ============================================================

-- GREATEST e LEAST.
SELECT
    GREATEST(10, 20, 30) AS maior_valor,
    LEAST(10, 20, 30) AS menor_valor;

-- Formatacao numerica.
SELECT
    preco,
    TO_CHAR(preco, 'FM999999990.00') AS preco_formatado
FROM techstore.produtos
ORDER BY id
LIMIT 10;

-- Formatacao de datas.
SELECT
    data_pedido,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada
FROM techstore.pedidos
ORDER BY id
LIMIT 10;

-- Conversao de texto para data.
SELECT
    TO_DATE('15/11/2026', 'DD/MM/YYYY') AS data_convertida;

-- Conversao de texto para timestamp.
SELECT
    TO_TIMESTAMP(
        '15/11/2026 14:30:00',
        'DD/MM/YYYY HH24:MI:SS'
    ) AS timestamp_convertido;

-- FORMAT.
SELECT
    FORMAT(
        'Produto: %s | Preco: %s',
        nome,
        preco
    ) AS descricao
FROM techstore.produtos
ORDER BY id
LIMIT 10;


-- ============================================================
-- 09. FUNCOES COMPOSTAS
-- ============================================================

-- Normalizacao de texto.
SELECT
    id,
    UPPER(TRIM(nome)) AS nome_normalizado
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Composicao de texto e tratamento de NULL.
SELECT
    id,
    CONCAT_WS(
        ' - ',
        UPPER(TRIM(nome)),
        COALESCE(email, 'Sem email'),
        COALESCE(telefone, 'Sem telefone')
    ) AS identificacao_cliente
FROM techstore.clientes
ORDER BY id
LIMIT 10;

-- Calculo e classificacao.
SELECT
    id,
    nome,
    preco,
    custo,
    ROUND(preco - custo, 2) AS margem_bruta,
    CASE
        WHEN preco = 0 THEN 'Nao calculavel'
        WHEN preco > custo THEN 'Margem positiva'
        WHEN preco = custo THEN 'Margem zero'
        ELSE 'Margem negativa'
    END AS classificacao
FROM techstore.produtos
ORDER BY id
LIMIT 20;

-- Composicao de funcoes temporais.
SELECT
    id,
    data_pedido,
    TO_CHAR(data_pedido, 'MM/YYYY') AS periodo,
    EXTRACT(YEAR FROM data_pedido) AS ano
FROM techstore.pedidos
ORDER BY data_pedido DESC
LIMIT 20;


-- ============================================================
-- 10. DESEMPENHO E EXPLAIN
-- ============================================================

-- Plano estimado de uma consulta.
EXPLAIN
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco > 500;

-- Plano com execucao real.
-- EXPLAIN ANALYZE executa a consulta.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco > 500;

-- Comparacao conceitual:
-- Consulta sem funcao aplicada a coluna.
EXPLAIN
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE preco >= 500;

-- Consulta com funcao aplicada a coluna.
EXPLAIN
SELECT
    id,
    nome,
    preco
FROM techstore.produtos
WHERE ROUND(preco) >= 500;


-- ============================================================
-- 11. EXPLORACAO FINAL
-- ============================================================

-- Combina funcoes de texto, numericas e condicionais.
SELECT
    id,
    UPPER(nome) AS produto,
    ROUND(preco, 2) AS preco,
    ROUND(custo, 2) AS custo,
    CASE
        WHEN preco = 0 THEN 'Preco zero'
        WHEN preco > custo THEN 'Preco acima do custo'
        WHEN preco = custo THEN 'Preco igual ao custo'
        ELSE 'Preco abaixo do custo'
    END AS classificacao
FROM techstore.produtos
ORDER BY preco DESC
LIMIT 30;

-- Combina funcoes temporais e condicionais.
SELECT
    id,
    data_pedido,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada,
    CASE
        WHEN data_pedido::date = CURRENT_DATE THEN 'Hoje'
        WHEN data_pedido::date > CURRENT_DATE THEN 'Futuro'
        ELSE 'Anterior a hoje'
    END AS classificacao_temporal
FROM techstore.pedidos
ORDER BY data_pedido DESC
LIMIT 30;


-- ============================================================
-- FIM DO MODULO 03
-- ============================================================