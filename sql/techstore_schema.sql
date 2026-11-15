-- TechStore SQL Lab | PostgreSQL
-- Execute este arquivo primeiro. Ele cria o schema e as 25 tabelas.
CREATE SCHEMA IF NOT EXISTS techstore;
SET search_path TO techstore, public;

CREATE TABLE IF NOT EXISTS estados (
  id SERIAL PRIMARY KEY, uf CHAR(2) UNIQUE NOT NULL, nome VARCHAR(60) NOT NULL
);
CREATE TABLE IF NOT EXISTS cidades (
  id SERIAL PRIMARY KEY, estado_id INT NOT NULL REFERENCES estados(id),
  nome VARCHAR(100) NOT NULL
);
CREATE TABLE IF NOT EXISTS categorias (
  id SERIAL PRIMARY KEY, nome VARCHAR(80) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS marcas (
  id SERIAL PRIMARY KEY, nome VARCHAR(80) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS fornecedores (
  id SERIAL PRIMARY KEY, razao_social VARCHAR(140) NOT NULL,
  cnpj CHAR(14) UNIQUE NOT NULL, ativo BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE IF NOT EXISTS departamentos (
  id SERIAL PRIMARY KEY, nome VARCHAR(80) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS funcionarios (
  id BIGSERIAL PRIMARY KEY, departamento_id INT REFERENCES departamentos(id),
  nome VARCHAR(120) NOT NULL, email VARCHAR(160) UNIQUE NOT NULL,
  data_admissao DATE NOT NULL, salario NUMERIC(12,2) NOT NULL
);
CREATE TABLE IF NOT EXISTS clientes (
  id BIGSERIAL PRIMARY KEY, nome VARCHAR(140) NOT NULL,
  email VARCHAR(160) UNIQUE NOT NULL, telefone VARCHAR(20),
  data_cadastro DATE NOT NULL, data_nascimento DATE,
  genero VARCHAR(20), ativo BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE IF NOT EXISTS enderecos (
  id BIGSERIAL PRIMARY KEY, cliente_id BIGINT NOT NULL REFERENCES clientes(id),
  cidade_id INT NOT NULL REFERENCES cidades(id), logradouro VARCHAR(160) NOT NULL,
  numero VARCHAR(12), cep CHAR(8), tipo VARCHAR(20) NOT NULL
);
CREATE TABLE IF NOT EXISTS produtos (
  id BIGSERIAL PRIMARY KEY, categoria_id INT REFERENCES categorias(id),
  marca_id INT REFERENCES marcas(id), fornecedor_id INT REFERENCES fornecedores(id),
  nome VARCHAR(160) NOT NULL, sku VARCHAR(30) UNIQUE NOT NULL,
  preco NUMERIC(12,2) NOT NULL CHECK (preco >= 0),
  custo NUMERIC(12,2) NOT NULL CHECK (custo >= 0),
  ativo BOOLEAN NOT NULL DEFAULT TRUE, data_cadastro DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS estoque (
  produto_id BIGINT PRIMARY KEY REFERENCES produtos(id),
  quantidade INT NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
  estoque_minimo INT NOT NULL DEFAULT 5, atualizado_em TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS pedidos (
  id BIGSERIAL PRIMARY KEY, cliente_id BIGINT NOT NULL REFERENCES clientes(id),
  funcionario_id BIGINT REFERENCES funcionarios(id), endereco_id BIGINT REFERENCES enderecos(id),
  data_pedido TIMESTAMP NOT NULL, status VARCHAR(25) NOT NULL,
  valor_frete NUMERIC(10,2) NOT NULL DEFAULT 0,
  desconto NUMERIC(10,2) NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS itens_pedido (
  id BIGSERIAL PRIMARY KEY, pedido_id BIGINT NOT NULL REFERENCES pedidos(id),
  produto_id BIGINT NOT NULL REFERENCES produtos(id), quantidade INT NOT NULL CHECK (quantidade > 0),
  preco_unitario NUMERIC(12,2) NOT NULL, desconto_item NUMERIC(10,2) NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS formas_pagamento (
  id SERIAL PRIMARY KEY, descricao VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS pagamentos (
  id BIGSERIAL PRIMARY KEY, pedido_id BIGINT NOT NULL REFERENCES pedidos(id),
  forma_pagamento_id INT NOT NULL REFERENCES formas_pagamento(id),
  data_pagamento TIMESTAMP, valor NUMERIC(12,2) NOT NULL,
  status VARCHAR(25) NOT NULL, parcelas INT NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS transportadoras (
  id SERIAL PRIMARY KEY, nome VARCHAR(100) NOT NULL, prazo_medio_dias INT NOT NULL
);
CREATE TABLE IF NOT EXISTS entregas (
  id BIGSERIAL PRIMARY KEY, pedido_id BIGINT NOT NULL REFERENCES pedidos(id),
  transportadora_id INT NOT NULL REFERENCES transportadoras(id),
  data_envio DATE, data_entrega DATE, status VARCHAR(25) NOT NULL
);
CREATE TABLE IF NOT EXISTS cupons (
  id SERIAL PRIMARY KEY, codigo VARCHAR(30) UNIQUE NOT NULL,
  percentual_desconto NUMERIC(5,2) NOT NULL, validade DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS avaliacoes (
  id BIGSERIAL PRIMARY KEY, cliente_id BIGINT NOT NULL REFERENCES clientes(id),
  produto_id BIGINT NOT NULL REFERENCES produtos(id), nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
  comentario TEXT, data_avaliacao DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS devolucoes (
  id BIGSERIAL PRIMARY KEY, item_pedido_id BIGINT NOT NULL REFERENCES itens_pedido(id),
  data_devolucao DATE NOT NULL, motivo VARCHAR(100) NOT NULL, status VARCHAR(25) NOT NULL
);
CREATE TABLE IF NOT EXISTS movimentacoes_estoque (
  id BIGSERIAL PRIMARY KEY, produto_id BIGINT NOT NULL REFERENCES produtos(id),
  funcionario_id BIGINT REFERENCES funcionarios(id), tipo VARCHAR(20) NOT NULL,
  quantidade INT NOT NULL, data_movimentacao TIMESTAMP NOT NULL
);
CREATE TABLE IF NOT EXISTS historico_precos (
  id BIGSERIAL PRIMARY KEY, produto_id BIGINT NOT NULL REFERENCES produtos(id),
  preco_anterior NUMERIC(12,2) NOT NULL, preco_novo NUMERIC(12,2) NOT NULL,
  alterado_em TIMESTAMP NOT NULL
);
CREATE TABLE IF NOT EXISTS campanhas (
  id SERIAL PRIMARY KEY, nome VARCHAR(120) NOT NULL,
  inicio DATE NOT NULL, fim DATE NOT NULL, orcamento NUMERIC(14,2) NOT NULL
);
CREATE TABLE IF NOT EXISTS acessos (
  id BIGSERIAL PRIMARY KEY, cliente_id BIGINT REFERENCES clientes(id),
  data_acesso TIMESTAMP NOT NULL, pagina VARCHAR(160) NOT NULL,
  dispositivo VARCHAR(30), origem VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS logs_sistema (
  id BIGSERIAL PRIMARY KEY, funcionario_id BIGINT REFERENCES funcionarios(id),
  ocorrido_em TIMESTAMP NOT NULL, nivel VARCHAR(15) NOT NULL,
  modulo VARCHAR(60) NOT NULL, mensagem TEXT NOT NULL
);

-- CREATE INDEX IF NOT EXISTS idx_pedidos_cliente_data ON pedidos(cliente_id, data_pedido);
-- CREATE INDEX IF NOT EXISTS idx_pedidos_data ON pedidos(data_pedido);
-- CREATE INDEX IF NOT EXISTS idx_itens_pedido_pedido ON itens_pedido(pedido_id);
-- CREATE INDEX IF NOT EXISTS idx_itens_pedido_produto ON itens_pedido(produto_id);
-- CREATE INDEX IF NOT EXISTS idx_acessos_data ON acessos(data_acesso);
