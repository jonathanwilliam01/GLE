class AreaTecnica < ApplicationRecord
  self.table_name  = 'gle_areas_tecnicas'
  self.primary_key = 'id_area'

  validates :nome_area, presence: true

  def as_json(_options = {})
    { id: id_area, nome: nome_area }
  end
end
