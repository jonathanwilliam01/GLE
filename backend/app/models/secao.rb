class Secao < ApplicationRecord
  self.table_name  = 'gle_secoes'
  self.primary_key = 'id_secao'
  self.record_timestamps = false
end
