-- ==================================================
-- Script de Inicialização do Banco de Dados GLE
-- Gestão de Link Embras
-- ==================================================

-- Conexão ao banco de dados GLE
\c GLE;

-- ==================================================
-- CRIAÇÃO DAS TABELAS
-- ==================================================

-- Tabela: categorias
-- Armazena as categorias dos links
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria SERIAL PRIMARY KEY,
    ds_categoria VARCHAR(255) NOT NULL,
    area_tecnica VARCHAR(100),
    dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Comentários da tabela categorias
COMMENT ON TABLE categorias IS 'Armazena as categorias para organização dos links';
COMMENT ON COLUMN categorias.id_categoria IS 'Identificador único da categoria';
COMMENT ON COLUMN categorias.ds_categoria IS 'Descrição/nome da categoria';
COMMENT ON COLUMN categorias.area_tecnica IS 'Área técnica relacionada à categoria';

-- Tabela: links
-- Armazena os links cadastrados no sistema
CREATE TABLE IF NOT EXISTS links (
    id_link SERIAL PRIMARY KEY,
    link VARCHAR(500) NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    id_categoria INTEGER NOT NULL,
    estado VARCHAR(50),
    area_tecnica VARCHAR(100),
    dt_inclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_exclusao TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_categoria FOREIGN KEY (id_categoria) 
        REFERENCES categorias(id_categoria) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Comentários da tabela links
COMMENT ON TABLE links IS 'Armazena todos os links cadastrados no sistema';
COMMENT ON COLUMN links.id_link IS 'Identificador único do link';
COMMENT ON COLUMN links.link IS 'URL do link';
COMMENT ON COLUMN links.titulo IS 'Título descritivo do link';
COMMENT ON COLUMN links.id_categoria IS 'Referência à categoria (FK)';
COMMENT ON COLUMN links.estado IS 'Estado/status do link';
COMMENT ON COLUMN links.area_tecnica IS 'Área técnica relacionada';
COMMENT ON COLUMN links.ativo IS 'Indica se o link está ativo';

-- Tabela: auditoria
-- Armazena o histórico de todas as operações realizadas nos links
CREATE TABLE IF NOT EXISTS auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_link INTEGER,
    id_usuario INTEGER,
    acao VARCHAR(50) NOT NULL,
    conteudo_antes TEXT,
    conteudo_depois TEXT,
    dt_auditoria TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_link_auditoria FOREIGN KEY (id_link) 
        REFERENCES links(id_link) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    CONSTRAINT chk_acao CHECK (acao IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- Comentários da tabela auditoria
COMMENT ON TABLE auditoria IS 'Registra todas as operações realizadas nos links para rastreabilidade';
COMMENT ON COLUMN auditoria.id_auditoria IS 'Identificador único do registro de auditoria';
COMMENT ON COLUMN auditoria.id_link IS 'Referência ao link auditado (FK)';
COMMENT ON COLUMN auditoria.id_usuario IS 'Identificador do usuário que realizou a ação';
COMMENT ON COLUMN auditoria.acao IS 'Tipo de ação realizada: INSERT, UPDATE ou DELETE';
COMMENT ON COLUMN auditoria.conteudo_antes IS 'Conteúdo do registro antes da alteração (JSON)';
COMMENT ON COLUMN auditoria.conteudo_depois IS 'Conteúdo do registro após a alteração (JSON)';
COMMENT ON COLUMN auditoria.dt_auditoria IS 'Data e hora da ação';

-- ==================================================
-- CRIAÇÃO DE ÍNDICES
-- ==================================================

-- Índices para melhorar performance de consultas
CREATE INDEX IF NOT EXISTS idx_links_categoria ON links(id_categoria);
CREATE INDEX IF NOT EXISTS idx_links_area_tecnica ON links(area_tecnica);
CREATE INDEX IF NOT EXISTS idx_links_ativo ON links(ativo);
CREATE INDEX IF NOT EXISTS idx_auditoria_link ON auditoria(id_link);
CREATE INDEX IF NOT EXISTS idx_auditoria_usuario ON auditoria(id_usuario);
CREATE INDEX IF NOT EXISTS idx_auditoria_acao ON auditoria(acao);
CREATE INDEX IF NOT EXISTS idx_auditoria_data ON auditoria(dt_auditoria);

-- ==================================================
-- TRIGGER PARA AUDITORIA AUTOMÁTICA
-- ==================================================

-- Função para registrar auditoria automaticamente
CREATE OR REPLACE FUNCTION fn_auditoria_links()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO auditoria (id_link, id_usuario, acao, conteudo_antes, conteudo_depois)
        VALUES (OLD.id_link, 0, 'DELETE', row_to_json(OLD)::TEXT, NULL);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO auditoria (id_link, id_usuario, acao, conteudo_antes, conteudo_depois)
        VALUES (NEW.id_link, 0, 'UPDATE', row_to_json(OLD)::TEXT, row_to_json(NEW)::TEXT);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO auditoria (id_link, id_usuario, acao, conteudo_antes, conteudo_depois)
        VALUES (NEW.id_link, 0, 'INSERT', NULL, row_to_json(NEW)::TEXT);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger que executa a função de auditoria
CREATE TRIGGER trg_auditoria_links
AFTER INSERT OR UPDATE OR DELETE ON links
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_links();

-- ==================================================
-- DADOS INICIAIS (SEED)
-- ==================================================

-- Inserir categorias iniciais
INSERT INTO categorias (ds_categoria, area_tecnica) VALUES
    ('Documentação', 'Geral'),
    ('Ferramentas de Desenvolvimento', 'TI'),
    ('APIs Externas', 'Integração'),
    ('Repositórios', 'Desenvolvimento'),
    ('Tutoriais', 'Educação'),
    ('Monitoramento', 'Infraestrutura'),
    ('Segurança', 'InfoSec')
ON CONFLICT DO NOTHING;

-- Inserir links de exemplo
INSERT INTO links (link, titulo, id_categoria, estado, area_tecnica) VALUES
    ('https://github.com/embras/gle', 'Repositório GLE', 4, 'Ativo', 'Desenvolvimento'),
    ('https://www.postgresql.org/docs/', 'Documentação PostgreSQL', 1, 'Ativo', 'Banco de Dados'),
    ('https://guides.rubyonrails.org/', 'Ruby on Rails Guides', 1, 'Ativo', 'Backend'),
    ('https://angular.io/docs', 'Documentação Angular', 1, 'Ativo', 'Frontend'),
    ('https://primeng.org/', 'PrimeNG Components', 2, 'Ativo', 'Frontend')
ON CONFLICT DO NOTHING;

-- ==================================================
-- VIEWS ÚTEIS
-- ==================================================

-- View para visualizar links com nome da categoria
CREATE OR REPLACE VIEW vw_links_completo AS
SELECT 
    l.id_link,
    l.link,
    l.titulo,
    l.id_categoria,
    c.ds_categoria,
    l.estado,
    l.area_tecnica,
    l.dt_inclusao,
    l.dt_exclusao,
    l.ativo
FROM links l
INNER JOIN categorias c ON l.id_categoria = c.id_categoria;

-- View para histórico de auditoria com detalhes
CREATE OR REPLACE VIEW vw_auditoria_completo AS
SELECT 
    a.id_auditoria,
    a.id_link,
    l.titulo AS titulo_link,
    a.id_usuario,
    a.acao,
    a.conteudo_antes,
    a.conteudo_depois,
    a.dt_auditoria
FROM auditoria a
LEFT JOIN links l ON a.id_link = l.id_link
ORDER BY a.dt_auditoria DESC;

-- ==================================================
-- PERMISSÕES
-- ==================================================

-- Conceder permissões ao usuário (ajustar conforme necessário)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sysdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sysdba;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO sysdba;

-- ==================================================
-- FIM DO SCRIPT
-- ==================================================

-- Exibir estatísticas
SELECT 
    'Categorias' AS tabela, 
    COUNT(*) AS total_registros 
FROM categorias
UNION ALL
SELECT 
    'Links' AS tabela, 
    COUNT(*) AS total_registros 
FROM links
UNION ALL
SELECT 
    'Auditoria' AS tabela, 
    COUNT(*) AS total_registros 
FROM auditoria;

\echo '✓ Banco de dados GLE inicializado com sucesso!'
