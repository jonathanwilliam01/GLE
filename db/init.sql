-- ==================================================
-- Script de Inicialização do Banco de Dados GLE
-- Gestão de Link Embras
-- ==================================================

-- Conexão ao banco de dados GLE
\c GLE;

-- ==================================================
-- DROP DAS TABELAS (executar para recriar estrutura)
-- ==================================================

DROP TRIGGER IF EXISTS trg_auditoria_links ON links;
DROP FUNCTION IF EXISTS fn_auditoria_links();
DROP VIEW IF EXISTS vw_links_completo;
DROP VIEW IF EXISTS vw_auditoria_completo;
DROP TABLE IF EXISTS auditoria CASCADE;
DROP TABLE IF EXISTS links CASCADE;
DROP TABLE IF EXISTS secoes CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;

-- ==================================================
-- CRIAÇÃO DAS TABELAS
-- ==================================================

-- 1. Tabela: categorias (sem dependências)
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria SERIAL PRIMARY KEY,
    ds_categoria VARCHAR(255) NOT NULL,
    area_tecnica VARCHAR(100),
    icone VARCHAR(255),
    dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE categorias IS 'Armazena as categorias para organização dos links';
COMMENT ON COLUMN categorias.id_categoria IS 'Identificador único da categoria';
COMMENT ON COLUMN categorias.ds_categoria IS 'Descrição/nome da categoria';
COMMENT ON COLUMN categorias.area_tecnica IS 'Área técnica relacionada à categoria';
COMMENT ON COLUMN categorias.icone IS 'Ícone representativo da categoria';
-- 2. Tabela: secoes (sem dependências)
CREATE TABLE IF NOT EXISTS secoes (
    id_secao SERIAL PRIMARY KEY,
    ds_secao VARCHAR(50) NOT NULL,
    sigla_secao VARCHAR(10)
);

COMMENT ON TABLE secoes IS 'Armazena as seções de agrupamento dos links';
COMMENT ON COLUMN secoes.id_secao IS 'Identificador único da seção';
COMMENT ON COLUMN secoes.ds_secao IS 'Descrição/nome da seção';
COMMENT ON COLUMN secoes.sigla_secao IS 'Sigla da seção (ex: SP, RJ)';

-- 3. Tabela: links (depende de categorias e secoes)
CREATE TABLE IF NOT EXISTS links (
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
        REFERENCES categorias(id_categoria)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_secao FOREIGN KEY (id_secao)
        REFERENCES secoes(id_secao)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE links IS 'Armazena todos os links cadastrados no sistema';
COMMENT ON COLUMN links.id_link IS 'Identificador único do link';
COMMENT ON COLUMN links.link IS 'URL do link';
COMMENT ON COLUMN links.ds_link IS 'Descrição do link';
COMMENT ON COLUMN links.titulo IS 'Título descritivo do link';
COMMENT ON COLUMN links.id_categoria IS 'Referência à categoria (FK)';
COMMENT ON COLUMN links.id_secao IS 'Referência à seção (FK)';
COMMENT ON COLUMN links.area_tecnica IS 'Área técnica relacionada';
COMMENT ON COLUMN links.ativo IS 'Indica se o link está ativo';

-- 4. Tabela: auditoria (depende de links)
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

COMMENT ON TABLE auditoria IS 'Registra todas as operações realizadas nos links para rastreabilidade';
COMMENT ON COLUMN auditoria.id_auditoria IS 'Identificador único do registro de auditoria';
COMMENT ON COLUMN auditoria.id_link IS 'Referência ao link auditado (FK)';
COMMENT ON COLUMN auditoria.id_usuario IS 'Identificador do usuário que realizou a ação';
COMMENT ON COLUMN auditoria.acao IS 'Tipo de ação realizada: INSERT, UPDATE ou DELETE';
COMMENT ON COLUMN auditoria.conteudo_antes IS 'Conteúdo do registro antes da alteração (JSON)';
COMMENT ON COLUMN auditoria.conteudo_depois IS 'Conteúdo do registro após a alteração (JSON)';
COMMENT ON COLUMN auditoria.dt_auditoria IS 'Data e hora da ação';

-- ==================================================
-- DADOS INICIAIS (SEED)
-- ==================================================

-- Seed: categorias
INSERT INTO categorias (ds_categoria, area_tecnica, icone) VALUES
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
INSERT INTO secoes (ds_secao, sigla_secao) VALUES
    ('São Paulo',      'SP'),
    ('Rio de Janeiro', 'RJ'),
    ('Minas Gerais',   'MG'),
    ('Documentos',     ''),
    ('Links',          ''),
    ('Adicionais',     '');

-- Seed: links
-- Categorias: 1=GoGlobal 2=IssOnline 3=IssOn Homol. 4=E-Gov 5=E-Gov Homol. 6=Config E-Gov 7=Login Novo 8=Geosiap Setup 9=Pessoas 10=Links Uteis
-- Secoes:     1=São Paulo(SP)  2=Rio de Janeiro(RJ)  3=Minas Gerais(MG)  4=Documentos  5=Links  6=Adicionais

INSERT INTO links (link, titulo, id_categoria, id_secao, area_tecnica) VALUES

-- ============================================================
-- GoGlobal (id_categoria=1)
-- ============================================================
-- São Paulo
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
-- Rio de Janeiro
('http://painel-pmbarradopirai.geosiap.net.br/',                  'Barra do Pirai',      1, 2, 'Todas'),
('https://painel-japeri.geosiap.net.br',                          'Japeri',              1, 2, 'Todas'),
('https://painel-pmnilopolis.geosiap.net.br/',                    'Nilópolis',           1, 2, 'Todas'),
('https://cloud.pmsg.rj.gov.br/#/client/ODIAYwBteXNxbA',         'São Gonçalo',         1, 2, 'Todas'),
-- Minas Gerais
('https://painel-pmibirite.geosiap.net.br/',                      'Ibiritê',             1, 3, 'Todas'),

-- ============================================================
-- IssOnline - Produção (id_categoria=2)
-- ============================================================
-- São Paulo
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
-- Rio de Janeiro
('https://pmjaperi.geosiap.net.br/pmjaperi/issonline/iss.login.php',                              'Japeri',             2, 2, 'Tributário'),
-- Minas Gerais
('https://pmitamonte.geosiap.net.br/pmitamonte/issonline/iss.login.php',                          'Itamonte',           2, 3, 'Tributário'),
('https://pmibirite.geosiap.net.br/pmibirite/issonline/iss.login.php',                            'Ibiritê',            2, 3, 'Tributário'),
('https://pmpousoalto.geosiap.net.br:8443/pmpousoalto/issonline/iss.login.php',                   'Pouso Alto',         2, 3, 'Tributário'),

-- ============================================================
-- IssOn Homol. - Homologação (id_categoria=3)
-- ============================================================
-- São Paulo
('https://dev.geosiap.net/pmpinda/issonline/iss.login.php',                                       'Pindamonhangaba',    3, 1, 'Tributário'),
('https://dev.geosiap.net/pmguaratingueta/issonline/iss.login.php',                               'Guaratinguetá',      3, 1, 'Tributário'),
('https://dev.geosiap.net/pmjacarei/issonline/iss.login.php',                                     'Jacareí',            3, 1, 'Tributário'),
('https://dev.geosiap.net/pmcachoeirapaulista/issonline/iss.login.php',                           'Cachoeira Paulista', 3, 1, 'Tributário'),
('https://dev.geosiap.net/pmlorena/issonline/iss.login.php',                                      'Lorena',             3, 1, 'Tributário'),
('https://dev.geosiap.net/pmbiritibamirim/issonline/iss.login.php',                               'Biritiba Mirim',     3, 1, 'Tributário'),
('https://dev.geosiap.net/pmcruzeiro/issonline/iss.login.php',                                    'Cruzeiro',           3, 1, 'Tributário'),
('https://dev.geosiap.net/pmlavrinhas/issonline/iss.login.php',                                   'Lavrinhas',          3, 1, 'Tributário'),
('https://dev.geosiap.net/pmcanas/issonline/iss.login.php',                                       'Canas',              3, 1, 'Tributário'),
('https://dev.geosiap.net/pmpompeia/issonline/iss.login.php',                                     'Pompeia',            3, 1, 'Tributário'),
('https://dev.geosiap.net/pmredencaodaserra/issonline/iss.login.php',                             'Redenção da Serra',  3, 1, 'Tributário'),
('https://dev.geosiap.net/pmsalesopolis/issonline/iss.login.php',                                 'Salesópolis',        3, 1, 'Tributário'),
('https://dev.geosiap.net/pmsantabranca/issonline/iss.login.php',                                 'Santa Branca',       3, 1, 'Tributário'),
('http://dev.geosiap.net/pmsilveiras/issonline/iss.login.php',                                    'Silveiras',          3, 1, 'Tributário'),
('https://dev.geosiap.net/pmarapei/issonline/iss.login.php',                                      'Arapei',             3, 1, 'Tributário'),
('https://dev.geosiap.net/pmqueluz/issonline/iss.login.php',                                      'Queluz',             3, 1, 'Tributário'),
('https://dev.geosiap.net/pmbananal/issonline/iss.login.php',                                     'Bananal',            3, 1, 'Tributário'),
('https://dev.geosiap.net/pmroseira/issonline/iss.login.php',                                     'Roseira',            3, 1, 'Tributário'),
('https://dev.geosiap.net/pmpedrotoledo/issonline/iss.login.php',                                 'Pedro de Toledo',    3, 1, 'Tributário'),
-- Rio de Janeiro
('https://dev.geosiap.net/pmjaperi/issonline/iss.login.php',                                      'Japeri',             3, 2, 'Tributário'),
-- Minas Gerais
('https://dev.geosiap.net/pmitamonte/issonline/iss.login.php',                                    'Itamonte',           3, 3, 'Tributário'),
('https://dev.geosiap.net/pmibirite/issonline/iss.login.php',                                     'Ibiritê',            3, 3, 'Tributário'),
('https://dev.geosiap.net/pmpousoalto/issonline/iss.login.php',                                   'Pouso Alto',         3, 3, 'Tributário'),

-- ============================================================
-- E-Gov - Produção (id_categoria=4)
-- ============================================================
-- São Paulo
('https://pmarapei.geosiap.net.br/pmarapei/websis/siapegov/portal/index.php',                     'Arapei',             4, 1, 'Tributário'),
('https://pmbananal.geosiap.net.br/pmbananal/websis/siapegov/portal/index.php',                   'Bananal',            4, 1, 'Tributário'),
('https://pmbiritibamirim.geosiap.net.br/pmbiritibamirim/websis/siapegov/portal/index.php',       'Biritiba Mirim',     4, 1, 'Tributário'),
('https://pmcachoeirapaulista.geosiap.net.br/pmcachoeirapaulista/websis/siapegov/portal/index.php','Cachoeira Paulista', 4, 1, 'Tributário'),
('https://pmcanas.geosiap.net.br/pmcanas/websis/siapegov/portal/',                                'Canas',              4, 1, 'Tributário'),
('https://pmcaraguatatuba.geosiap.net.br/pmcaraguatatuba/websis/siapegov/portal/index.php',       'Caraguatatuba',       4, 1, 'Tributário'),
('https://pmcruzeiro.geosiap.net.br/pmcruzeiro/websis/siapegov/portal/index.php',                 'Cruzeiro',           4, 1, 'Tributário'),
('https://portal.guararema.sp.gov.br/pmguararema/websis/siapegov/portal/index.php',               'Guararema',          4, 1, 'Tributário'),
('https://pmguaratingueta.geosiap.net.br/pmguaratingueta/websis/siapegov/portal/',                'Guaratinguetá',      4, 1, 'Tributário'),
('https://siap.jacarei.sp.gov.br/pmjacarei/websis/siapegov/portal/index.php',                     'Jacareí',            4, 1, 'Tributário'),
('https://lagoinha.geosiap.net.br/lagoinha/websis/siapegov/portal/index.php',                     'Lagoinha',           4, 1, 'Tributário'),
('https://pmlavrinhas.geosiap.net.br/pmlavrinhas/websis/siapegov/portal/index.php',               'Lavrinhas',          4, 1, 'Tributário'),
('https://siap.lorena.sp.gov.br/pmlorena/websis/siapegov/portal/index.php',                       'Lorena',             4, 1, 'Tributário'),
('https://pedrotoledo.geosiap.net.br:8843/pmpedrotoledo/websis/siapegov/portal/index.php',        'Pedro de Toledo',    4, 1, 'Tributário'),
('https://siapegov.pindamonhangaba.sp.gov.br/pmpinda/websis/siapegov/portal/index.php',           'Pindamonhangaba',    4, 1, 'Tributário'),
('https://siap.pompeia.sp.gov.br/pmpompeia/websis/siapegov/portal/index.php',                     'Pompeia',            4, 1, 'Tributário'),
('https://pmqueluz.geosiap.net.br/pmqueluz/websis/siapegov/portal/index.php',                     'Queluz',             4, 1, 'Tributário'),
('https://pmredencao.geosiap.net.br/pmredencaodaserra/websis/siapegov/portal/index.php',          'Redenção da Serra',  4, 1, 'Tributário'),
('https://pmroseira.geosiap.net.br:8443/pmroseira/websis/siapegov/portal/index.php',              'Roseira',            4, 1, 'Tributário'),
('https://pmsalesopolis.geosiap.net.br/pmsalesopolis/websis/siapegov/portal/',                    'Salesópolis',        4, 1, 'Tributário'),
('https://pmsantabranca.geosiap.net.br/pmsantabranca/websis/siapegov/portal/index.php',           'Santa Branca',       4, 1, 'Tributário'),
('https://online.saovicente.sp.gov.br/pmsaovicente/websis/siapegov/portal/index.php',             'São Vicente',        4, 1, 'Tributário'),
('https://pmsilveiras.geosiap.net.br:8443/pmsilveiras/websis/siapegov/portal/',                   'Silveiras',          4, 1, 'Tributário'),
-- Rio de Janeiro
('https://pmbarradopirai.geosiap.net.br/pmbarradopirai/websis/siapegov/portal/index.php',         'Barra do Pirai',     4, 2, 'Tributário'),
('https://pmjaperi.geosiap.net.br/pmjaperi/websis/siapegov/portal/index.php',                     'Japeri',             4, 2, 'Tributário'),
('https://pmnilopolis.geosiap.net.br/pmnilopolis/websis/siapegov/portal/index.php',               'Nilópolis',          4, 2, 'Tributário'),
('https://sistema.pmsg.rj.gov.br/pmsaogoncalo/websis/siapegov/portal/index.php',                  'São Gonçalo',        4, 2, 'Tributário'),
-- Minas Gerais
('https://pmibirite.geosiap.net.br/pmibirite/websis/siapegov/portal/index.php',                   'Ibiritê',            4, 3, 'Tributário'),
('https://pmitamonte.geosiap.net.br/pmitamonte/websis/siapegov/portal/index.php',                 'Itamonte',           4, 3, 'Tributário'),
('https://pmpousoalto.geosiap.net.br:8443/pmpousoalto/websis/siapegov/portal/index.php',          'Pouso Alto',         4, 3, 'Tributário'),

-- ============================================================
-- E-Gov Homol. - Homologação (id_categoria=5)
-- ============================================================
-- São Paulo
('https://dev.geosiap.net/pmarapei/websis/siapegov/portal/index.php',                             'Arapei',             5, 1, 'Tributário'),
('https://dev.geosiap.net/pmbananal/websis/siapegov/portal/index.php',                            'Bananal',            5, 1, 'Tributário'),
('https://dev.geosiap.net/pmbiritibamirim/websis/siapegov/portal/index.php',                      'Biritiba Mirim',     5, 1, 'Tributário'),
('https://dev.geosiap.net/pmcachoeirapaulista/websis/siapegov/portal/index.php',                  'Cachoeira Paulista', 5, 1, 'Tributário'),
('https://dev.geosiap.net/pmcanas/websis/siapegov/portal/',                                       'Canas',              5, 1, 'Tributário'),
('https://dev.geosiap.net/pmcaraguatatuba/websis/siapegov/portal/index.php',                      'Caraguatatuba',      5, 1, 'Tributário'),
('https://dev.geosiap.net/pmcruzeiro/websis/siapegov/portal/index.php',                           'Cruzeiro',           5, 1, 'Tributário'),
('https://dev.geosiap.net/pmguararema/websis/siapegov/portal/index.php',                          'Guararema',          5, 1, 'Tributário'),
('https://dev.geosiap.net/pmguaratingueta/websis/siapegov/portal/',                               'Guaratinguetá',      5, 1, 'Tributário'),
('https://dev.geosiap.net/pmjacarei/websis/siapegov/portal/index.php',                            'Jacareí',            5, 1, 'Tributário'),
('https://dev.geosiap.net/lagoinha/websis/siapegov/portal/index.php',                             'Lagoinha',           5, 1, 'Tributário'),
('https://dev.geosiap.net/pmlavrinhas/websis/siapegov/portal/index.php',                          'Lavrinhas',          5, 1, 'Tributário'),
('https://dev.geosiap.net/pmlorena/websis/siapegov/portal/index.php',                             'Lorena',             5, 1, 'Tributário'),
('https://dev.geosiap.net/pmpedrotoledo/websis/siapegov/portal/index.php',                        'Pedro de Toledo',    5, 1, 'Tributário'),
('https://dev.geosiap.net/pmpinda/websis/siapegov/portal/index.php',                              'Pindamonhangaba',    5, 1, 'Tributário'),
('https://dev.geosiap.net/pmpompeia/websis/siapegov/portal/index.php',                            'Pompeia',            5, 1, 'Tributário'),
('https://dev.geosiap.net/pmqueluz/websis/siapegov/portal/index.php',                             'Queluz',             5, 1, 'Tributário'),
('https://dev.geosiap.net/pmredencaodaserra/websis/siapegov/portal/index.php',                    'Redenção da Serra',  5, 1, 'Tributário'),
('https://dev.geosiap.net/pmroseira/websis/siapegov/portal/index.php',                            'Roseira',            5, 1, 'Tributário'),
('https://dev.geosiap.net/pmsalesopolis/websis/siapegov/portal/',                                 'Salesópolis',        5, 1, 'Tributário'),
('https://dev.geosiap.net/pmsantabranca/websis/siapegov/portal/index.php',                        'Santa Branca',       5, 1, 'Tributário'),
('https://dev.geosiap.net/pmsaovicente/websis/siapegov/portal/index.php',                         'São Vicente',        5, 1, 'Tributário'),
('https://dev.geosiap.net/pmsilveiras/websis/siapegov/portal/index.php',                          'Silveiras',          5, 1, 'Tributário'),
-- Rio de Janeiro
('https://dev.geosiap.net/pmbarradopirai/websis/siapegov/portal/index.php',                       'Barra do Pirai',     5, 2, 'Tributário'),
('https://dev.geosiap.net/pmjaperi/websis/siapegov/portal/index.php',                             'Japeri',             5, 2, 'Tributário'),
('https://dev.geosiap.net/pmnilopolis/websis/siapegov/portal/index.php',                          'Nilópolis',          5, 2, 'Tributário'),
('https://dev.geosiap.net/pmsaogoncalo/websis/siapegov/portal/index.php',                         'São Gonçalo',        5, 2, 'Tributário'),
('https://homolog-embras.pmsg.rj.gov.br/pmsaogoncalo/websis/siapegov/portal/index.php',           'São Gonçalo (Homol)',5, 2, 'Tributário'),
-- Minas Gerais
('https://dev.geosiap.net/pmibirite/websis/siapegov/portal/index.php',                            'Ibiritê',            5, 3, 'Tributário'),
('https://dev.geosiap.net/pmitamonte/websis/siapegov/portal/index.php',                           'Itamonte',           5, 3, 'Tributário'),
('https://dev.geosiap.net/pmpousoalto/websis/siapegov/portal/index.php',                          'Pouso Alto',         5, 3, 'Tributário'),

-- ============================================================
-- Config E-Gov - websis/config (id_categoria=6)
-- ============================================================
-- São Paulo
('https://pmarapei.geosiap.net.br/pmarapei/websis/config/login.php',                              'Arapei',             6, 1, 'Tributário'),
('https://pmbananal.geosiap.net.br/pmbananal/websis/config/login.php',                            'Bananal',            6, 1, 'Tributário'),
('https://pmbiritibamirim.geosiap.net.br/pmbiritibamirim/websis/config/login.php',                'Biritiba Mirim',     6, 1, 'Tributário'),
('https://pmcachoeirapaulista.geosiap.net.br/pmcachoeirapaulista/websis/config/login.php',        'Cachoeira Paulista', 6, 1, 'Tributário'),
('https://pmcanas.geosiap.net.br/pmcanas/websis/config/login.php',                                'Canas',              6, 1, 'Tributário'),
('https://pmcaraguatatuba.geosiap.net.br/pmcaraguatatuba/websis/config/login.php',                'Caraguatatuba',      6, 1, 'Tributário'),
('https://pmcruzeiro.geosiap.net.br/pmcruzeiro/websis/config/login.php',                          'Cruzeiro',           6, 1, 'Tributário'),
('https://portal.guararema.sp.gov.br/pmguararema/websis/config/login.php',                        'Guararema',          6, 1, 'Tributário'),
('https://pmguaratingueta.geosiap.net.br/pmguaratingueta/websis/config/login.php',                'Guaratinguetá',      6, 1, 'Tributário'),
('https://siap.jacarei.sp.gov.br/pmjacarei/websis/config/login.php',                              'Jacareí',            6, 1, 'Tributário'),
('https://pmlavrinhas.geosiap.net.br/pmlavrinhas/websis/config/login.php',                        'Lavrinhas',          6, 1, 'Tributário'),
('https://siap.lorena.sp.gov.br/pmlorena/websis/config/login.php',                                'Lorena',             6, 1, 'Tributário'),
('http://pmpedrotoledo.geosiap.net.br/pmpedrotoledo/websis/config/login.php',                     'Pedro de Toledo',    6, 1, 'Tributário'),
('https://siapegov.pindamonhangaba.sp.gov.br/pmpinda/websis/config/login.php',                    'Pindamonhangaba',    6, 1, 'Tributário'),
('https://siap.pompeia.sp.gov.br/pmpompeia/websis/config/login.php',                              'Pompeia',            6, 1, 'Tributário'),
('https://pmqueluz.geosiap.net.br/pmqueluz/websis/config/login.php',                              'Queluz',             6, 1, 'Tributário'),
('https://pmredencao.geosiap.net.br/pmredencaodaserra/websis/config/login.php',                   'Redenção da Serra',  6, 1, 'Tributário'),
('https://pmroseira.geosiap.net.br:8443/pmroseira/websis/config/login.php',                       'Roseira',            6, 1, 'Tributário'),
('https://pmsalesopolis.geosiap.net.br/pmsalesopolis/websis/config/login.php',                    'Salesópolis',        6, 1, 'Tributário'),
('https://pmsantabranca.geosiap.net.br/pmsantabranca/websis/config/login.php',                    'Santa Branca',       6, 1, 'Tributário'),
('https://online.saovicente.sp.gov.br/pmsaovicente/websis/config/login.php',                      'São Vicente',        6, 1, 'Tributário'),
-- Rio de Janeiro
('https://pmbarradopirai.geosiap.net.br/pmbarradopirai/websis/config/login.php',                  'Barra do Pirai',     6, 2, 'Tributário'),
('https://pmjaperi.geosiap.net.br/pmjaperi/websis/config/login.php',                              'Japeri',             6, 2, 'Tributário'),
('https://pmnilopolis.geosiap.net.br/pmnilopolis/websis/config/login.php',                        'Nilópolis',          6, 2, 'Tributário'),
('https://servidor.pmsg.rj.gov.br/pmsaogoncalo/websis/config/login.php',                          'São Gonçalo',        6, 2, 'Tributário'),
-- Minas Gerais
('https://pmibirite.geosiap.net.br/pmibirite/websis/config/login.php',                            'Ibiritê',            6, 3, 'Tributário'),
('https://pmitamonte.geosiap.net.br/pmitamonte/websis/config/login.php',                          'Itamonte',           6, 3, 'Tributário'),
('https://pousoalto.mg.gov.br/aviso-servicos-online-temporariamente-fora-do-ar/',                  'Pouso Alto',         6, 3, 'Tributário'),

-- ============================================================
-- Login Novo - contas/login + /config/ (id_categoria=7)
-- ============================================================
-- São Paulo
('https://arapei.geosiap.net.br/contas/login?returnUrl=https:%2F%2Farapei.geosiap.net.br%2Fconfig',                                   'Arapei',             7, 1, 'Todas'),
('https://pmbananal.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmbananal.geosiap.net.br%2Fconfig',                             'Bananal',            7, 1, 'Todas'),
('https://pmbiritibamirim.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmbiritibamirim.geosiap.net.br%2Fconfig',                 'Biritiba Mirim',     7, 1, 'Todas'),
('https://cachoeirapaulista.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fcachoeirapaulista.geosiap.net.br%2Fconfig',             'Cachoeira Paulista', 7, 1, 'Todas'),
('https://pmcanas.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmcanas.geosiap.net.br%2Fconfig',                                'Canas',              7, 1, 'Todas'),
('https://caraguatatuba.geosiap.net.br/config/',                                                                                       'Caraguatatuba',      7, 1, 'Todas'),
('https://pmcruzeiro.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmcruzeiro.geosiap.net.br%2Fconfig',                          'Cruzeiro',           7, 1, 'Todas'),
('https://guaratingueta.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fguaratingueta.geosiap.net.br%2Fconfig',                    'Guaratinguetá',      7, 1, 'Todas'),
('https://siap.jacarei.sp.gov.br/contas/login?returnUrl=https:%2F%2Fsiap.jacarei.sp.gov.br%2Fconfig',                                'Jacareí',            7, 1, 'Todas'),
('https://lagoinha.geosiap.net.br/config/',                                                                                            'Lagoinha',           7, 1, 'Todas'),
('https://pmlavrinhas.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmlavrinhas.geosiap.net.br%2Fconfig',                        'Lavrinhas',          7, 1, 'Todas'),
('https://siap.lorena.sp.gov.br/contas/login?returnUrl=https:%2F%2Fsiap.lorena.sp.gov.br%2Fconfig',                                  'Lorena',             7, 1, 'Todas'),
('https://pedrotoledo.geosiap.net.br:8843/contas/login?returnUrl=https:%2F%2Fpedrotoledo.geosiap.net.br:8843%2Fconfig',              'Pedro de Toledo',    7, 1, 'Todas'),
('https://siapegov.pindamonhangaba.sp.gov.br/contas/login?returnUrl=https:%2F%2Fsiapegov.pindamonhangaba.sp.gov.br%2Fconfig',        'Pindamonhangaba',    7, 1, 'Todas'),
('https://siap.pompeia.sp.gov.br/contas/login?returnUrl=https:%2F%2Fsiap.pompeia.sp.gov.br%2Fconfig',                                'Pompeia',            7, 1, 'Todas'),
('https://pmqueluz.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmqueluz.geosiap.net.br%2Fconfig',                              'Queluz',             7, 1, 'Todas'),
('https://redencaodaserra.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fredencaodaserra.geosiap.net.br%2Fconfig',                'Redenção da Serra',  7, 1, 'Todas'),
('https://pmroseira.geosiap.net.br:8443/contas/login?returnUrl=https:%2F%2Fpmroseira.geosiap.net.br:8443%2Fconfig',                  'Roseira',            7, 1, 'Todas'),
('https://pmsalesopolis.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmsalesopolis.geosiap.net.br%2Fconfig',                    'Salesópolis',        7, 1, 'Todas'),
('https://pmsantabranca.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmsantabranca.geosiap.net.br%2Fconfig',                    'Santa Branca',       7, 1, 'Todas'),
('https://pmsilveiras.geosiap.net.br:8443/config/',                                                                                    'Silveiras',          7, 1, 'Todas'),
-- Rio de Janeiro
('https://barradopirai.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fbarradopirai.geosiap.net.br%2Fconfig',                      'Barra do Pirai',     7, 2, 'Todas'),
('https://japeri.geosiap.net.br/config/',                                                                                              'Japeri',             7, 2, 'Todas'),
('https://sistema.pmsg.rj.gov.br/config/',                                                                                             'São Gonçalo',        7, 2, 'Todas'),
-- Minas Gerais
('https://pmibirite.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmibirite.geosiap.net.br%2Fconfig',                            'Ibiritê',            7, 3, 'Todas'),
('https://pmitamonte.geosiap.net.br/contas/login?returnUrl=https:%2F%2Fpmitamonte.geosiap.net.br%2Fconfig',                          'Itamonte',           7, 3, 'Todas'),
('https://pmpousoalto.geosiap.net.br:8443/contas/login?returnUrl=https:%2F%2Fpmpousoalto.geosiap.net.br:8443%2Fconfig',              'Pouso Alto',         7, 3, 'Todas'),

-- ============================================================
-- Geosiap Setup (id_categoria=8)
-- ============================================================
-- São Paulo
('https://arapei.geosiap.net.br/geosiap-setup/login',                                             'Arapei',             8, 1, 'Todas'),
('https://pmbananal.geosiap.net.br/geosiap-setup/login',                                          'Bananal',            8, 1, 'Todas'),
('https://pmbiritibamirim.geosiap.net.br/geosiap-setup/login',                                    'Biritiba Mirim',     8, 1, 'Todas'),
('https://cachoeirapaulista.geosiap.net.br/geosiap-setup/login',                                  'Cachoeira Paulista', 8, 1, 'Todas'),
('https://pmcanas.geosiap.net.br/geosiap-setup/login',                                            'Canas',              8, 1, 'Todas'),
('https://caraguatatuba.geosiap.net.br/geosiap-setup/login',                                      'Caraguatatuba',      8, 1, 'Todas'),
('https://pmcruzeiro.geosiap.net.br/geosiap-setup/login',                                         'Cruzeiro',           8, 1, 'Todas'),
('https://guaratingueta.geosiap.net.br/geosiap-setup/login',                                      'Guaratinguetá',      8, 1, 'Todas'),
('https://siap.jacarei.sp.gov.br/geosiap-setup/login',                                            'Jacareí',            8, 1, 'Todas'),
('https://pmlavrinhas.geosiap.net.br/geosiap-setup/login',                                        'Lavrinhas',          8, 1, 'Todas'),
('https://siap.lorena.sp.gov.br/geosiap-setup/login',                                             'Lorena',             8, 1, 'Todas'),
('https://pedrotoledo.geosiap.net.br:8843/geosiap-setup/login',                                   'Pedro de Toledo',    8, 1, 'Todas'),
('https://siap.pompeia.sp.gov.br/geosiap-setup/login',                                            'Pompeia',            8, 1, 'Todas'),
('https://pmqueluz.geosiap.net.br/geosiap-setup/login',                                           'Queluz',             8, 1, 'Todas'),
('https://redencaodaserra.geosiap.net.br/geosiap-setup/login',                                    'Redenção da Serra',  8, 1, 'Todas'),
('https://pmroseira.geosiap.net.br:8443/geosiap-setup/login',                                     'Roseira',            8, 1, 'Todas'),
('https://pmsalesopolis.geosiap.net.br/geosiap-setup/login',                                      'Salesópolis',        8, 1, 'Todas'),
('https://pmsantabranca.geosiap.net.br/geosiap-setup/login',                                      'Santa Branca',       8, 1, 'Todas'),
('https://pmsilveiras.geosiap.net.br:8443/geosiap-setup/login',                                   'Silveiras',          8, 1, 'Todas'),
-- Rio de Janeiro
('https://barradopirai.geosiap.net.br/geosiap-setup/login',                                       'Barra do Pirai',     8, 2, 'Todas'),
('https://japeri.geosiap.net.br/geosiap-setup/login',                                             'Japeri',             8, 2, 'Todas'),
('https://sistema.pmsg.rj.gov.br/geosiap-setup/login',                                            'São Gonçalo',        8, 2, 'Todas'),
-- Minas Gerais
('https://pmibirite.geosiap.net.br/geosiap-setup/login',                                          'Ibiritê',            8, 3, 'Todas'),
('https://pmitamonte.geosiap.net.br/geosiap-setup/login',                                         'Itamonte',           8, 3, 'Todas'),
('https://pmpousoalto.geosiap.net.br:8443/geosiap-setup/login',                                   'Pouso Alto',         8, 3, 'Todas'),

-- ============================================================
-- Pessoas (id_categoria=9)
-- ============================================================
-- São Paulo
('https://arapei.geosiap.net.br/pessoas/',                                                        'Arapei',             9, 1, 'Todas'),
('https://cachoeirapaulista.geosiap.net.br/pessoas/',                                             'Cachoeira Paulista', 9, 1, 'Todas'),
('https://canas.geosiap.net.br/pessoas/',                                                         'Canas',              9, 1, 'Todas'),
('https://guaratingueta.geosiap.net.br/pessoas/',                                                 'Guaratinguetá',      9, 1, 'Todas'),
('https://lagoinha.geosiap.net.br/pessoas/',                                                      'Lagoinha',           9, 1, 'Todas'),
('https://pmbiritibamirim.geosiap.net.br/pessoas/',                                               'Biritiba Mirim',     9, 1, 'Todas'),
('https://pmcruzeiro.geosiap.net.br/pessoas/',                                                    'Cruzeiro',           9, 1, 'Todas'),
('https://pmlavrinhas.geosiap.net.br/pessoas/',                                                   'Lavrinhas',          9, 1, 'Todas'),
('https://pmroseira.geosiap.net.br:8443/pessoas/',                                                'Roseira',            9, 1, 'Todas'),
('https://pmsalesopolis.geosiap.net.br/pessoas/',                                                 'Salesópolis',        9, 1, 'Todas'),
('https://pmsantabranca.geosiap.net.br/pessoas/',                                                 'Santa Branca',       9, 1, 'Todas'),
('https://portal.guararema.sp.gov.br/pessoas/',                                                   'Guararema',          9, 1, 'Todas'),
('https://redencaodaserra.geosiap.net.br/pessoas/',                                               'Redenção da Serra',  9, 1, 'Todas'),
('https://siap.lorena.sp.gov.br/pessoas/',                                                        'Lorena',             9, 1, 'Todas'),
('https://siapegov.pindamonhangaba.sp.gov.br/pessoas/',                                           'Pindamonhangaba',    9, 1, 'Todas'),
-- Minas Gerais
('https://pmibirite.geosiap.net.br/pessoas/',                                                     'Ibiritê',            9, 3, 'Todas'),
('https://pmitamonte.geosiap.net.br/pessoas/',                                                    'Itamonte',           9, 3, 'Todas'),
('https://pmpousoalto.geosiap.net.br:8443/pessoas/',                                              'Pouso Alto',         9, 3, 'Todas'),

-- ============================================================
-- Links Uteis (id_categoria=10)
-- ============================================================
-- Documentos (id_secao=4)
('https://docs.google.com/spreadsheets/d/1L1x8ciR39cm7Gy1FK3GqPam9p7SmWAoroaqxdwSgqac/edit#gid=0',                                                       'Cheat Sheet',               10, 4, 'Todas'),
('https://docs.google.com/spreadsheets/d/1pv1kqTiT7C0B01VUQn-6-N7jH7Y1tbgn7tgI7p4EwM8/edit#gid=0',                                                       'Controle Arrecadação',      10, 4, 'Todas'),
('https://docs.google.com/document/d/1lOPs3cfUF-W-5nU23Z5SZoCpNqdO7fwfLa36PR6WhMA/edit',                                                                  'Lembretes Tributário',      10, 4, 'Todas'),
('http://wiki.embras.net/books/comum-tributario',                                                                                                           'Wiki - Comum Tributário',   10, 4, 'Todas'),
('https://docs.google.com/spreadsheets/d/1BOOO4ETpJ4fXcVJOxQ5RN54Vy7N8R4lBFI6cHq6y47c/edit?gid=267894435#gid=267894435',                                  'Contatos Clientes',         10, 4, 'Todas'),
('http://manual.crabr.com.br/manual/',                                                                                                                     'Manual do CRA',             10, 4, 'Todas'),
('https://docs.google.com/spreadsheets/d/1VAEOFmKd4s2LzDbPjFytA6LlzysMY9rTEW8o_FeNpaM/edit?gid=84860749#gid=84860749',                                    'Revisão Pessoas',           10, 4, 'Todas'),
('https://manual.crabr.com.br/manual/transmissao-de-arquivos-xml/',                                                                                        'Manual Campos CRA',         10, 4, 'Todas'),
-- Links (id_secao=5)
('https://sos-legado.embras.net/index.php',                                                                                                                'SOS - Legado',              10, 5, 'Todas'),
('https://geosiap.eadplataforma.app/',                                                                                                                     'GeoSiap - EAD',             10, 5, 'Todas'),
('https://numeroserie-beta.geosiap.net/#/login',                                                                                                           'Geração de N° de Série',    10, 5, 'Todas'),
('http://suporte.cebi.com.br/Login.php?ret_link=%2FChamados.php&type=notLogged',                                                                           'Suporte CEBI',              10, 5, 'Todas'),
('https://github.com/orgs/geosiap-suporte/teams/suporte',                                                                                                 'Github - Geosiap Suporte',  10, 5, 'Todas'),
('http://wiki.embras.net/login',                                                                                                                           'Wiki Embras',               10, 5, 'Todas'),
('https://demandas.embras.net/v/',                                                                                                                         'TiFlux',                    10, 5, 'Todas'),
('https://dashboard.tawk.to/login#/dashboard/6172be7c86aee40a5737e13c',                                                                                   'Tawk.To',                   10, 5, 'Todas'),
('http://172.16.80.62/tunnel.php',                                                                                                                         'Tunel Bancos',              10, 5, 'Todas'),
('http://172.16.80.62/doc/',                                                                                                                               'Consulta Parâmetros',       10, 5, 'Todas'),
('https://dev.geosiap.net/contas/login',                                                                                                                   'Config Contas Local',       10, 5, 'Todas'),
('https://jwt.io/',                                                                                                                                        'JWT.IO',                    10, 5, 'Todas'),
('http://172.16.80.62:12345/logs',                                                                                                                         'Logs Local',                10, 5, 'Todas'),
('http://172.16.80.62/index.php?tab=bancos',                                                                                                               'Bancos Atualização',        10, 5, 'Todas'),
('https://dev.geosiap.net/core/entrar',                                                                                                                    'CORE Local',                10, 5, 'Todas'),
('https://tools.chilkat.io/xmlDsigVerify',                                                                                                                 'Testar XML WebService',     10, 5, 'Todas'),
('http://dl.embras.net/dlpessoas/index.php',                                                                                                               'EXEs Pessoas',              10, 5, 'Todas'),
-- Adicionais (id_secao=6)
('https://demandas.embras.net/v/knowledge/11353/25447',                                                                                                    'Bancos GoGlobal',           10, 6, 'Todas'),
('https://demandas.embras.net/v/knowledge_folder/11608',                                                                                                   'Histórico de Versões',      10, 6, 'Todas'),
('https://demandas.embras.net/v/knowledge_folders',                                                                                                        'Conhecimentos Tiflux',      10, 6, 'Todas'),
('https://protesto.com.br/cra/apresentantes/cra.php',                                                                                                      'Login CRA',                 10, 6, 'Todas'),
('https://atalhos-embras.vercel.app/',                                                                                                                     'Atalhos Embras',            10, 6, 'Todas'),
('http://172.16.80.74:8088/dashboard.php',                                                                                                                 'Facilita SP Pinda',         10, 6, 'Todas');

-- ==================================================
-- CRIAÇÃO DE ÍNDICES
-- ==================================================

CREATE INDEX IF NOT EXISTS idx_links_categoria    ON links(id_categoria);
CREATE INDEX IF NOT EXISTS idx_links_secao        ON links(id_secao);
CREATE INDEX IF NOT EXISTS idx_links_area_tecnica ON links(area_tecnica);
CREATE INDEX IF NOT EXISTS idx_links_ativo        ON links(ativo);
CREATE INDEX IF NOT EXISTS idx_auditoria_link     ON auditoria(id_link);
CREATE INDEX IF NOT EXISTS idx_auditoria_usuario  ON auditoria(id_usuario);
CREATE INDEX IF NOT EXISTS idx_auditoria_acao     ON auditoria(acao);
CREATE INDEX IF NOT EXISTS idx_auditoria_data     ON auditoria(dt_auditoria);

-- ==================================================
-- TRIGGER PARA AUDITORIA AUTOMÁTICA
-- ==================================================

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

CREATE TRIGGER trg_auditoria_links
AFTER INSERT OR UPDATE OR DELETE ON links
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_links();

-- ==================================================
-- VIEWS ÚTEIS
-- ==================================================

CREATE OR REPLACE VIEW vw_links_completo AS
SELECT
    l.id_link,
    l.link,
    l.titulo,
    l.ds_link,
    l.id_categoria,
    c.ds_categoria,
    l.id_secao,
    s.ds_secao,
    s.sigla_secao,
    l.area_tecnica,
    l.dt_inclusao,
    l.dt_exclusao,
    l.ativo
FROM links l
INNER JOIN categorias c ON l.id_categoria = c.id_categoria
LEFT  JOIN secoes     s ON l.id_secao     = s.id_secao;

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
