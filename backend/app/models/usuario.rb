class Usuario < ApplicationRecord
  has_secure_password

  self.table_name = 'usuarios'
  self.primary_key = 'id_usuario'

  validates :usuario, presence: true, uniqueness: true
  validates :nome, presence: true
end
