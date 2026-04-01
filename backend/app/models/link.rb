class Link < ApplicationRecord
  self.table_name  = 'gle_links'
  self.primary_key = 'id_link'
  self.record_timestamps = false

  belongs_to :secao, foreign_key: 'id_secao', optional: true

  scope :ativos, -> { where(ativo: true) }

  def as_json(_options = {})
    {
      id:           id_link,
      titulo:       titulo,
      url:          link,
      id_secao:     id_secao,
      secao:        secao&.ds_secao || 'Sem Seção',
      id_categoria: id_categoria
    }
  end
end
