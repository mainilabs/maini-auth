class User < ActiveRecord::Base

  # Inclui o devise com os módulos padrões, e também cria uma relação has_many com devices
  # Para alterar os módulos do devise, utilize o arquivo de configurações config/initializers/maini/auth.rb
  maini_auth

end
