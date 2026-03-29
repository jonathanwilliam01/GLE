class Secao < ApplicationRecord
  self.table_name  = 'secoes'
  self.primary_key = 'id_secao'
  self.record_timestamps = false
end
