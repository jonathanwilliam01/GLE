class Link < ApplicationRecord
  self.table_name  = 'gle_links'
  self.primary_key = 'id_link'
  self.record_timestamps = false

  belongs_to :secao,      foreign_key: 'id_secao',      primary_key: 'id_secao',      optional: true
  belongs_to :categoria,  foreign_key: 'id_categoria',  primary_key: 'id_categoria',  optional: true

  scope :ativos, -> { where(ativo: true, dt_exclusao: nil) }

  def as_json(_options = {})
    {
      id:             id_link,
      titulo:         titulo,
      url:            link,
      id_secao:       id_secao,
      secao:          secao&.ds_secao || 'Sem Seção',
      id_categoria:   id_categoria,
      categoria_nome: categoria&.ds_categoria || '',
      qtd_cliques:    qtd_cliques || 0,
      dt_exclusao:    dt_exclusao
    }
  end
end
