-- ==================================================
-- Script de Inicialização do Banco de Dados GLE
-- Gestão de Link Embras
-- Todas as tabelas com prefixo gle_
-- ==================================================

-- ==================================================
-- DROP DAS TABELAS (executar para recriar estrutura)
-- ==================================================

DROP TRIGGER IF EXISTS gle_trg_auditoria_links ON gle_links;
DROP FUNCTION IF EXISTS gle_fn_auditoria_links();
DROP VIEW IF EXISTS gle_vw_links_completo;
DROP VIEW IF EXISTS gle_vw_auditoria_completo;
DROP TABLE IF EXISTS gle_auditoria CASCADE;
DROP TABLE IF EXISTS gle_links CASCADE;
DROP TABLE IF EXISTS gle_secoes CASCADE;
DROP TABLE IF EXISTS gle_categorias CASCADE;

-- ==================================================
-- CRIAÇÃO DAS TABELAS
-- ==================================================

-- 1. Tabela: gle_categorias (sem dependências)
CREATE TABLE IF NOT EXISTS gle_categorias (
    id_categoria SERIAL PRIMARY KEY,
    ds_categoria VARCHAR(255) NOT NULL,
    area_tecnica VARCHAR(100),
    icone VARCHAR(255),
    dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE gle_categorias IS 'Armazena as categorias para organização dos links';

-- 2. Tabela: gle_secoes (sem dependências)
CREATE TABLE IF NOT EXISTS gle_secoes (
    id_secao SERIAL PRIMARY KEY,
    ds_secao VARCHAR(50) NOT NULL,
    sigla_secao VARCHAR(10)
);

-- 3. Tabela: gle_links (depende de gle_categorias e gle_secoes)
CREATE TABLE IF NOT EXISTS gle_links (
    id_link SERIAL PRIMARY KEY,
    link VARCHAR(500) NOT NULL,
    ds_link VARCHAR(250),
    titulo VARCHAR(255) NOT NULL,
    id_categoria INTEGER NOT NULL,
    id_secao INTEGER,
    area_tecnica VARCHAR(100),
    dt_inclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_exclusao TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_categoria FOREIGN KEY (id_categoria)
        REFERENCES gle_categorias(id_categoria)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_secao FOREIGN KEY (id_secao)
        REFERENCES gle_secoes(id_secao)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- 4. Tabela: gle_auditoria (depende de gle_links)
CREATE TABLE IF NOT EXISTS gle_auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_link INTEGER,
    id_usuario INTEGER,
    acao VARCHAR(50) NOT NULL,
    conteudo_antes TEXT,
    conteudo_depois TEXT,
    dt_auditoria TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_link_auditoria FOREIGN KEY (id_link)
        REFERENCES gle_links(id_link)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT chk_acao CHECK (acao IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- ==================================================
-- DADOS INICIAIS (SEED)
-- ==================================================

-- Seed: categorias
INSERT INTO gle_categorias (ds_categoria, area_tecnica, icone) VALUES
    ('GoGlobal',              'Todas',        'pi pi-globe'),
    ('IssOnline',             'Tributário',   'pi pi-desktop'),
    ('IssOn Homol.',          'Tributário',   'pi pi-desktop'),
    ('E-Gov',                 'E-Gov',        'pi pi-building'),
    ('E-Gov Homol.',          'E-Gov',        'pi pi-building'),
    ('Config E-Gov',          'E-Gov',        'pi pi-cog'),
    ('Login Novo',            'Todas',        'pi pi-user'),
    ('Geosiap Setup',         'Geosiap',      'pi pi-sliders-h'),
    ('Pessoas',               'Todas',        'pi pi-users'),
    ('Links Uteis',           'Todas',        'pi pi-link');

-- Seed: secoes
INSERT INTO gle_secoes (ds_secao, sigla_secao) VALUES
    ('São Paulo',      'SP'),
    ('Rio de Janeiro', 'RJ'),
    ('Minas Gerais',   'MG'),
    ('Documentos',     ''),
    ('Links',          ''),
    ('Adicionais',     '');

-- Seed: links
INSERT INTO gle_links (link, titulo, id_categoria, id_secao, area_tecnica) VALUES
-- GoGlobal (id_categoria=1)
('https://painel-arapei.geosiap.net.br/',                        'Arapei',             1, 1, 'Todas'),
('http://painel-biritibamirim.geosiap.net.br/',                   'Biritiba Mirim',     1, 1, 'Todas'),
('https://painel-pmcaraguatatuba.geosiap.net.br/',                'Caraguatatuba',       1, 1, 'Todas'),
('https://painel-pmcruzeiro.geosiap.net.br/',                     'Cruzeiro',            1, 1, 'Todas'),
('http://geosiap.guararema.sp.gov.br/',                           'Guararema',           1, 1, 'Todas'),
('https://painel-pmguaratingueta.geosiap.net.br/',                'Guaratinguetá',       1, 1, 'Todas'),
('https://painel-pmjacarei.geosiap.net.br/',                      'Jacareí',             1, 1, 'Todas'),
('http://painel-lavrinhas.geosiap.net.br/',                       'Lavrinhas',           1, 1, 'Todas'),
('https://painel-pindamonhangaba.geosiap.net.br/',                'Pindamonhangaba',     1, 1, 'Todas'),
('https://painel-santabranca.geosiap.net.br/',                    'Santa Branca',        1, 1, 'Todas'),
('https://painel-salesopolis.geosiap.net.br/',                    'Salesópolis',         1, 1, 'Todas'),
('http://painel-pmsaovicente.geosiap.net.br/',                    'São Vicente',         1, 1, 'Todas'),
('https://painel-cachoeirapaulista.geosiap.net.br/',              'Cachoeira Paulista',  1, 1, 'Todas'),
('https://painel-lagoinha.geosiap.net.br/',                       'Lagoinha',            1, 1, 'Todas'),
('https://painel-caraguatatuba-homologacao.geosiap.net.br/',      'Caragua Homolog.',    1, 1, 'Todas'),
('http://painel-pmbarradopirai.geosiap.net.br/',                  'Barra do Pirai',      1, 2, 'Todas'),
('https://painel-japeri.geosiap.net.br',                          'Japeri',              1, 2, 'Todas'),
('https://painel-pmnilopolis.geosiap.net.br/',                    'Nilópolis',           1, 2, 'Todas'),
('https://cloud.pmsg.rj.gov.br/#/client/ODIAYwBteXNxbA',         'São Gonçalo',         1, 2, 'Todas'),
('https://painel-pmibirite.geosiap.net.br/',                      'Ibiritê',             1, 3, 'Todas'),
-- IssOnline (id_categoria=2)
('https://siapegov.pindamonhangaba.sp.gov.br/pmpinda/issonline/iss.login.php',                     'Pindamonhangaba',    2, 1, 'Tributário'),
('https://pmguaratingueta.geosiap.net.br/pmguaratingueta/issonline/iss.login.php',                 'Guaratinguetá',      2, 1, 'Tributário'),
('https://egov.jacarei.sp.gov.br/pmjacarei/issonline/iss.login.php',                              'Jacareí',            2, 1, 'Tributário'),
('https://pmcachoeirapaulista.geosiap.net.br/pmcachoeirapaulista/issonline/iss.login.php',         'Cachoeira Paulista', 2, 1, 'Tributário'),
('https://siap.lorena.sp.gov.br/pmlorena/issonline/iss.login.php',                                'Lorena',             2, 1, 'Tributário'),
('https://pmbiritibamirim.geosiap.net.br/pmbiritibamirim/issonline/iss.login.php',                'Biritiba Mirim',     2, 1, 'Tributário'),
('https://pmcruzeiro.geosiap.net.br/pmcruzeiro/issonline/iss.login.php',                          'Cruzeiro',           2, 1, 'Tributário'),
('https://pmlavrinhas.geosiap.net.br/pmlavrinhas/issonline/iss.login.php',                        'Lavrinhas',          2, 1, 'Tributário'),
('https://pmcanas.geosiap.net.br/pmcanas/issonline/iss.login.php',                                'Canas',              2, 1, 'Tributário'),
('https://siap.pompeia.sp.gov.br/pmpompeia/issonline/iss.login.php',                              'Pompeia',            2, 1, 'Tributário'),
('https://pmredencao.geosiap.net.br/pmredencaodaserra/issonline/iss.login.php',                   'Redenção da Serra',  2, 1, 'Tributário'),
('https://pmsalesopolis.geosiap.net.br/pmsalesopolis/issonline/iss.login.php',                    'Salesópolis',        2, 1, 'Tributário'),
('https://pmsantabranca.geosiap.net.br/pmsantabranca/issonline/iss.login.php',                    'Santa Branca',       2, 1, 'Tributário'),
('http://pmsilveiras.geosiap.net.br:8080/pmsilveiras/issonline/iss.login.php',                    'Silveiras',          2, 1, 'Tributário'),
('https://pmarapei.geosiap.net.br/pmarapei/issonline/iss.login.php',                              'Arapei',             2, 1, 'Tributário'),
('https://pmqueluz.geosiap.net.br/pmqueluz/issonline/iss.login.php',                              'Queluz',             2, 1, 'Tributário'),
('https://pmbananal.geosiap.net.br/pmbananal/issonline/iss.login.php',                            'Bananal',            2, 1, 'Tributário'),
('https://pmroseira.geosiap.net.br:8443/pmroseira/issonline/iss.login.php',                       'Roseira',            2, 1, 'Tributário'),
('https://pedrotoledo.geosiap.net.br:8843/pmpedrotoledo/issonline/iss.login.php',                 'Pedro de Toledo',    2, 1, 'Tributário'),
('https://lagoinha.geosiap.net.br/pmlagoinha/issonline/iss.login.php',                            'Lagoinha',           2, 1, 'Tributário'),
('https://pmjaperi.geosiap.net.br/pmjaperi/issonline/iss.login.php',                              'Japeri',             2, 2, 'Tributário'),
('https://pmitamonte.geosiap.net.br/pmitamonte/issonline/iss.login.php',                          'Itamonte',           2, 3, 'Tributário'),
('https://pmibirite.geosiap.net.br/pmibirite/issonline/iss.login.php',                            'Ibiritê',            2, 3, 'Tributário'),
('https://pmpousoalto.geosiap.net.br:8443/pmpousoalto/issonline/iss.login.php',                   'Pouso Alto',         2, 3, 'Tributário');

-- ==================================================
-- CRIAÇÃO DE ÍNDICES
-- ==================================================

CREATE INDEX IF NOT EXISTS gle_idx_links_categoria    ON gle_links(id_categoria);
CREATE INDEX IF NOT EXISTS gle_idx_links_secao        ON gle_links(id_secao);
CREATE INDEX IF NOT EXISTS gle_idx_links_area_tecnica ON gle_links(area_tecnica);
CREATE INDEX IF NOT EXISTS gle_idx_links_ativo        ON gle_links(ativo);
CREATE INDEX IF NOT EXISTS gle_idx_auditoria_link     ON gle_auditoria(id_link);
CREATE INDEX IF NOT EXISTS gle_idx_auditoria_usuario  ON gle_auditoria(id_usuario);
CREATE INDEX IF NOT EXISTS gle_idx_auditoria_acao     ON gle_auditoria(acao);
CREATE INDEX IF NOT EXISTS gle_idx_auditoria_data     ON gle_auditoria(dt_auditoria);

-- ==================================================
-- TRIGGER PARA AUDITORIA AUTOMÁTICA
-- ==================================================

CREATE OR REPLACE FUNCTION gle_fn_auditoria_links()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO gle_auditoria (id_link, id_usuario, acao, conteudo_antes, conteudo_depois)
        VALUES (OLD.id_link, 0, 'DELETE', row_to_json(OLD)::TEXT, NULL);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO gle_auditoria (id_link, id_usuario, acao, conteudo_antes, conteudo_depois)
        VALUES (NEW.id_link, 0, 'UPDATE', row_to_json(OLD)::TEXT, row_to_json(NEW)::TEXT);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO gle_auditoria (id_link, id_usuario, acao, conteudo_antes, conteudo_depois)
        VALUES (NEW.id_link, 0, 'INSERT', NULL, row_to_json(NEW)::TEXT);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER gle_trg_auditoria_links
AFTER INSERT OR UPDATE OR DELETE ON gle_links
FOR EACH ROW
EXECUTE FUNCTION gle_fn_auditoria_links();

-- ==================================================
-- VIEWS ÚTEIS
-- ==================================================

CREATE OR REPLACE VIEW gle_vw_links_completo AS
SELECT
    l.id_link, l.link, l.titulo, l.ds_link, l.id_categoria,
    c.ds_categoria, l.id_secao, s.ds_secao, s.sigla_secao,
    l.area_tecnica, l.dt_inclusao, l.dt_exclusao, l.ativo
FROM gle_links l
INNER JOIN gle_categorias c ON l.id_categoria = c.id_categoria
LEFT  JOIN gle_secoes     s ON l.id_secao     = s.id_secao;

CREATE OR REPLACE VIEW gle_vw_auditoria_completo AS
SELECT
    a.id_auditoria, a.id_link, l.titulo AS titulo_link,
    a.id_usuario, a.acao, a.conteudo_antes, a.conteudo_depois, a.dt_auditoria
FROM gle_auditoria a
LEFT JOIN gle_links l ON a.id_link = l.id_link
ORDER BY a.dt_auditoria DESC;

-- ==================================================
-- FIM DO SCRIPT
-- ==================================================
