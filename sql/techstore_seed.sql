-- TechStore SQL Lab | Carga de dados sintéticos
-- Execute schema.sql antes deste arquivo.
-- A carga completa cria milhões de registros e pode levar alguns minutos.
SET search_path TO techstore, public;

INSERT INTO estados(uf,nome) VALUES
('AC','Acre'),('AL','Alagoas'),('AP','Amapá'),('AM','Amazonas'),('BA','Bahia'),
('CE','Ceará'),('DF','Distrito Federal'),('ES','Espírito Santo'),('GO','Goiás'),
('MA','Maranhão'),('MT','Mato Grosso'),('MS','Mato Grosso do Sul'),('MG','Minas Gerais'),
('PA','Pará'),('PB','Paraíba'),('PR','Paraná'),('PE','Pernambuco'),('PI','Piauí'),
('RJ','Rio de Janeiro'),('RN','Rio Grande do Norte'),('RS','Rio Grande do Sul'),
('RO','Rondônia'),('RR','Roraima'),('SC','Santa Catarina'),('SP','São Paulo'),
('SE','Sergipe'),('TO','Tocantins') ON CONFLICT DO NOTHING;

INSERT INTO cidades(estado_id,nome)
SELECT e.id, 'Cidade ' || n FROM estados e CROSS JOIN generate_series(1,10) n
ON CONFLICT DO NOTHING;

INSERT INTO categorias(nome) VALUES
('Notebooks'),('Smartphones'),('Periféricos'),('Monitores'),('Áudio'),
('Componentes'),('Armazenamento'),('Games'),('Acessórios'),('Redes')
ON CONFLICT DO NOTHING;
INSERT INTO marcas(nome) SELECT 'Marca ' || n FROM generate_series(1,40) n ON CONFLICT DO NOTHING;
INSERT INTO fornecedores(razao_social,cnpj)
SELECT 'Fornecedor '||n, lpad(n::text,14,'0') FROM generate_series(1,100) n
ON CONFLICT DO NOTHING;
INSERT INTO departamentos(nome) VALUES
('Vendas'),('Logística'),('Financeiro'),('Atendimento'),('Tecnologia'),('Marketing')
ON CONFLICT DO NOTHING;
INSERT INTO funcionarios(departamento_id,nome,email,data_admissao,salario)
SELECT 1+((n-1)%6), 'Funcionário '||n, 'func'||n||'@techstore.test',
       DATE '2018-01-01'+(((n*13)%2800)::int), 2200+((n*173)%8500)
FROM generate_series(1,120) n ON CONFLICT DO NOTHING;
INSERT INTO formas_pagamento(descricao) VALUES ('PIX'),('Cartão de crédito'),('Cartão de débito'),('Boleto')
ON CONFLICT DO NOTHING;
INSERT INTO transportadoras(nome,prazo_medio_dias)
SELECT 'Transportadora '||n, 2+(n%8) FROM generate_series(1,20) n;
INSERT INTO cupons(codigo,percentual_desconto,validade)
SELECT 'TECH'||lpad(n::text,3,'0'), 5+(n%25), DATE '2027-12-31' FROM generate_series(1,50) n
ON CONFLICT DO NOTHING;
INSERT INTO campanhas(nome,inicio,fim,orcamento)
SELECT 'Campanha '||n, DATE '2024-01-01'+((n*20)::int), DATE '2024-01-15'+((n*20)::int), 5000+n*125
FROM generate_series(1,30) n;

-- 100 mil clientes
INSERT INTO clientes(nome,email,telefone,data_cadastro,data_nascimento,genero,ativo)
SELECT 'Cliente '||n, 'cliente'||n||'@email.test', '31'||lpad((900000000+n%99999999)::text,9,'0'),
       DATE '2019-01-01'+((n%2500)::int), DATE '1960-01-01'+((n%16000)::int),
       (ARRAY['F','M','Não informado'])[(n%3)+1], (n%20<>0)
FROM generate_series(1,100000) n;

-- 120 mil endereços: um ou dois por cliente
INSERT INTO enderecos(cliente_id,cidade_id,logradouro,numero,cep,tipo)
SELECT c.id, 1+((c.id*7+j*13)%270), 'Rua das Consultas '||c.id, (1+(c.id%3000))::text,
       lpad((30000000+(c.id%69999999))::text,8,'0'),
       CASE WHEN j=1 THEN 'Principal' ELSE 'Entrega' END
FROM clientes c CROSS JOIN LATERAL generate_series(1,CASE WHEN c.id%5=0 THEN 2 ELSE 1 END) j;

-- 15 mil produtos
INSERT INTO produtos(categoria_id,marca_id,fornecedor_id,nome,sku,preco,custo,ativo,data_cadastro)
SELECT 1+(n%10), 1+(n%40), 1+(n%100), 'Produto Tech '||n, 'SKU'||lpad(n::text,6,'0'),
       round((80+(n%4000)*1.37)::numeric,2), round((50+(n%3000)*1.11)::numeric,2),
       (n%25<>0), DATE '2020-01-01'+((n%2200)::int)
FROM generate_series(1,15000) n;
INSERT INTO estoque(produto_id,quantidade,estoque_minimo)
SELECT id, (id*37)%500, 5+(id%20) FROM produtos;

-- 500 mil pedidos
-- Calcula o endereço principal uma vez por cliente.
WITH enderecos_principais AS (
    SELECT cliente_id, MIN(id) AS endereco_id
    FROM enderecos
    GROUP BY cliente_id
),
pedidos_base AS (
    SELECT
        n,
        (1 + ((n * 17) % 100000))::BIGINT AS cliente_id
    FROM generate_series(1,500000) AS serie(n)
)
INSERT INTO pedidos(cliente_id,funcionario_id,endereco_id,data_pedido,status,valor_frete,desconto)
SELECT
    pb.cliente_id,
    1 + ((pb.n * 7) % 120),
    ep.endereco_id,
    TIMESTAMP '2023-01-01'
        + ((pb.n % 1200) * INTERVAL '1 day')
        + ((pb.n % 86400) * INTERVAL '1 second'),
    (ARRAY['entregue','entregue','entregue','em transporte','cancelado','processando'])[(pb.n % 6) + 1],
    ROUND((5 + (pb.n % 70) * 0.7)::numeric, 2),
    ROUND(((pb.n % 8) * 3.5)::numeric, 2)
FROM pedidos_base pb
JOIN enderecos_principais ep
    ON ep.cliente_id = pb.cliente_id;

-- 1,5 milhão de itens (3 por pedido)
INSERT INTO itens_pedido(pedido_id,produto_id,quantidade,preco_unitario,desconto_item)
SELECT p.id, 1+((p.id*11+k*97)%15000), 1+((p.id+k)%4),
       pr.preco, CASE WHEN (p.id+k)%10=0 THEN round(pr.preco*0.05,2) ELSE 0 END
FROM pedidos p CROSS JOIN generate_series(1,3) k
JOIN produtos pr ON pr.id=1+((p.id*11+k*97)%15000);

-- Calcula o total dos itens uma única vez por pedido.
WITH totais_itens AS (
    SELECT
        pedido_id,
        SUM(quantidade * preco_unitario - desconto_item) AS total_itens
    FROM itens_pedido
    GROUP BY pedido_id
)
INSERT INTO pagamentos(pedido_id,forma_pagamento_id,data_pagamento,valor,status,parcelas)
SELECT
    p.id,
    1 + (p.id % 4),
    p.data_pedido + INTERVAL '1 hour',
    ROUND(ti.total_itens + p.valor_frete - p.desconto, 2),
    CASE WHEN p.status = 'cancelado' THEN 'estornado' ELSE 'aprovado' END,
    CASE WHEN p.id % 4 = 0 THEN 3 ELSE 1 END
FROM pedidos p
JOIN totais_itens ti
    ON ti.pedido_id = p.id;

INSERT INTO entregas(pedido_id,transportadora_id,data_envio,data_entrega,status)
SELECT p.id, 1+(p.id%20), p.data_pedido::date+2,
       CASE WHEN p.status='entregue' THEN p.data_pedido::date+ (3+(p.id%9))::integer END,
       CASE WHEN p.status='entregue' THEN 'entregue' ELSE p.status END
FROM pedidos p;

-- 250 mil avaliações
INSERT INTO avaliacoes(cliente_id,produto_id,nota,comentario,data_avaliacao)
SELECT 1+((n*17)%100000), 1+((n*31)%15000), 1+(n%5),
       CASE WHEN n%4=0 THEN 'Produto atende às expectativas' ELSE 'Avaliação do produto '||n END,
       DATE '2023-01-01'+((n%1200)::int)
FROM generate_series(1,250000) n;

-- 800 mil movimentações de estoque
INSERT INTO movimentacoes_estoque(produto_id,funcionario_id,tipo,quantidade,data_movimentacao)
SELECT 1+((n*19)%15000), 1+(n%120),
       CASE WHEN n%2=0 THEN 'entrada' ELSE 'saida' END,
       1+(n%30), TIMESTAMP '2023-01-01'+(n%1200)*INTERVAL '1 day'
FROM generate_series(1,800000) n;

INSERT INTO historico_precos(produto_id,preco_anterior,preco_novo,alterado_em)
SELECT p.id, p.preco*0.9, p.preco, TIMESTAMP '2023-01-01'+(p.id%1000)*INTERVAL '1 day'
FROM produtos p CROSS JOIN generate_series(1,3) x;

INSERT INTO devolucoes(item_pedido_id,data_devolucao,motivo,status)
SELECT i.id, p.data_pedido::date+15, (ARRAY['Defeito','Arrependimento','Produto divergente'])[(i.id%3)+1],
       CASE WHEN i.id%2=0 THEN 'aprovada' ELSE 'em análise' END
FROM itens_pedido i JOIN pedidos p ON p.id=i.pedido_id WHERE i.id%30=0;

-- 2 milhões de acessos
INSERT INTO acessos(cliente_id,data_acesso,pagina,dispositivo,origem)
SELECT CASE WHEN n%10=0 THEN NULL ELSE 1+((n*29)%100000) END,
       TIMESTAMP '2024-01-01'+(n%900)*INTERVAL '1 day'+(n%86400)*INTERVAL '1 second',
       (ARRAY['/','/produtos','/produto/detalhe','/carrinho','/checkout','/minha-conta'])[(n%6)+1],
       (ARRAY['desktop','mobile','tablet'])[(n%3)+1],
       (ARRAY['busca','redes sociais','direto','email'])[(n%4)+1]
FROM generate_series(1,2000000) n;

-- 3 milhões de logs de sistema
INSERT INTO logs_sistema(funcionario_id,ocorrido_em,nivel,modulo,mensagem)
SELECT CASE WHEN n%8=0 THEN NULL ELSE 1+(n%120) END,
       TIMESTAMP '2024-01-01'+(n%900)*INTERVAL '1 day'+(n%86400)*INTERVAL '1 second',
       (ARRAY['INFO','INFO','WARNING','ERROR'])[(n%4)+1],
       (ARRAY['pedidos','estoque','pagamentos','usuarios','integracao'])[(n%5)+1],
       'Evento sintético de teste número '||n
FROM generate_series(1,3000000) n;

-- Índices secundários criados após a carga em massa.
CREATE INDEX idx_pedidos_cliente_data
    ON pedidos(cliente_id, data_pedido);

CREATE INDEX idx_pedidos_data
    ON pedidos(data_pedido);

CREATE INDEX idx_itens_pedido_pedido
    ON itens_pedido(pedido_id);

CREATE INDEX idx_itens_pedido_produto
    ON itens_pedido(produto_id);

CREATE INDEX idx_acessos_data
    ON acessos(data_acesso);

ANALYZE;
-- Fim da carga. Consulte os totais com COUNT(*) nas tabelas.
