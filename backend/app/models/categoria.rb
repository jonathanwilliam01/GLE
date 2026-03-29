# ==================================================
# Model: Categoria
# Tabela: categorias
# ==================================================
# Colunas:
#   id_categoria  - PK (SERIAL)
#   ds_categoria  - nome da categoria
#   area_tecnica  - área(s) técnica(s) separadas por vírgula
#   icone         - classe CSS do ícone PrimeNG (ex: "pi pi-globe")
#   dt_criacao    - data/hora de criação (preenchida pelo banco)
#   dt_atualizacao- data/hora de atualização (preenchida pelo banco)
# ==================================================

class Categoria < ApplicationRecord
  self.table_name  = 'categorias'
  self.primary_key = 'id_categoria'

  # O banco preenche dt_criacao e dt_atualizacao com DEFAULT CURRENT_TIMESTAMP
  self.record_timestamps = false

  validates :ds_categoria, presence: true, length: { maximum: 255 }

  # Conta os links associados a esta categoria
  def links_count
    ActiveRecord::Base.connection
      .select_value("SELECT COUNT(*) FROM links WHERE id_categoria = #{id_categoria}")
      .to_i
  end

  # Serialização para JSON — define exatamente o que o frontend recebe
  def as_json(_options = {})
    {
      id:    id_categoria,
      nome:  ds_categoria,
      icon:  icone.presence || 'pi pi-folder',
      areas: area_tecnica.present? ? area_tecnica.split(',').map(&:strip) : [],
      count: links_count
    }
  end
end
