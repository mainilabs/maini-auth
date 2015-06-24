Maini::Auth.setup do |config|

  # =========================================================================================================================================================
  # CUSTOMIZAÇÕES PARA O DEVISE
  # =========================================================================================================================================================

  # ===> @devise_options: Array
  #
  # Definição para módulos do Devise que serão utilizados
  # Lembrando que dependendo do módulo habilitado, é preciso mudar a migration do devise para adicionar os campos correspondetes no banco de dados
  #
  # config.devise_options = [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable]

  # ===> @devise_route_config: Hash
  #
  # Definição para as rotas que serão criadas pela Devise
  # Lembrando que estas opções também podem ser alteradas no método maini_auth, encontrado em config/routes.rb
  #
  # config.devise_route_config = {path: 'auth', path_names: { :password => 'secret', :confirmation => 'verification', :unlock => 'unblock' }}

  # =========================================================================================================================================================
  # CUSTOMIZAÇÕES PARA A AGILIB AUTH
  # =========================================================================================================================================================

  # ===> @routing: Hash
  #
  # Definição do path para a rota criada pela Maini Auth para acesso ao controller de Tokens
  # Lembrando que estas opções também podem ser alteradas no método maini_auth, encontrado em config/routes.rb
  #
  # config.routing = {path: 'auth/tokens', controller: 'maini/auth/tokens'}

  # ===> @login_params: Hash
  #
  # Definição do nome dos parâmetros que serão recebidos para fazer o login
  # Estes parâmetros são utilizados na chamada da rota auth/tokens#create
  #
  # config.login_params = {login: :login, password: :password, register: :register, platform: :platform}

  # ===> @auth_params: Hash
  #
  # config.auth_params = {login: :auth_login, token: :auth_token, register: :register}

  # ===> @auth_headers: Hash
  #
  # config.auth_headers = {login: 'X-Auth-Login', token: 'X-Auth-Token', register: 'X-Auth-Register'}

  # ===> @locale_param: Symbol
  #
  # config.locale_param = :locale

end