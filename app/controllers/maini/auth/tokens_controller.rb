# encoding: utf-8
class Maini::Auth::TokensController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  skip_before_action :verify_signed_out_user
  skip_before_action :authenticate_user_from_token!, only: [:create]

=begin
@apiVersion 0.0.1
@api {post} /auth/tokens 01 - Solicitar Token de acesso
@apiName postCreateTokens
@apiGroup 00 - Acesso

@apiExample Header
  HTTP_ACCEPT: application/json

@apiParam {String} login E-mail utilizado para login.
@apiParam {String} password Senha.
@apiParam {String} register Número de registro do aparelho.
@apiParam {String} platform Plataforma (android|ios|web).
@apiParam {String} user_locale Locale do usuário (pt-BR, en, es).

@apiExample Exemplo de Json para request
  {
    "login": "marcos@maini.com.br",
    "password": "123123123",
    "register": "APA91bFd2JaapE_ZCNvB12SS-P2_RQ3Y-c3kkStrBRv6gjIDjbWq9_xRK7ddkK1BrZDAN1l5fK2In8KQGiToGIHzM8RCWmrB97NFDiDlZ_avtzpdYCBgzTeeIFtsvcnve9aEG8C2zVVb4CejlXA6XvqnHmVjE2zOxNgm_oTHE3ZWLA-nFtZUh5A",
    "platform": "android",
    "user_locale": "pt-BR"
  }

@apiSuccessExample Success-Response-Example:
  HTTP/1.1 200 OK
  {
    "user": {
      "id": 5
      "login": "marcos@maini.com.br",
      "profile": {
        "id": 1,
        "name": "Administrador"
      }
    },
    "device_id": 6,
    "token": "x5Qx8qujZfqUV38GJyBv"
  }

@apiErrorExample  Formato inválido
  HTTP/1.1 401 Unauthorized
  {
    "errors":{
      "format_error":["The request must be json."]
    }
  }
@apiErrorExample  Não informou login ou password
  HTTP/1.1 401 Unauthorized
  {
    "errors":{
      "request_login_and_password":["The request must contain the user login and password."]
    }
  }
@apiErrorExample  Não informou o Register ID
  HTTP/1.1 401 Unauthorized
  {
    "errors":{
      "request_device_register":["The request must contain the device register."]
    }
  }
@apiErrorExample  Não informou a plataforma
  HTTP/1.1 401 Unauthorized
  {
    "errors":{
      "request_device_platform":["The request must contain the device platform."]
    }
  }
@apiErrorExample  Login/Email inválido
  HTTP/1.1 401 Unauthorized
  {
    "errors":{
      "invalid_login":["Invalid login."]
    }
  }
@apiErrorExample  Senha inválida
  HTTP/1.1 401 Unauthorized
  {
    "errors":{
      "invalid_password":["Invalid password."]
    }
  }

=end
  def create
    login     = params[Maini::Auth::Configuration.login_params[:login]]
    password  = params[Maini::Auth::Configuration.login_params[:password]]
    register  = params[Maini::Auth::Configuration.login_params[:register]]
    platform  = params[Maini::Auth::Configuration.login_params[:platform]]

    if request.format != :json
      render :status=>406, :json => Maini::Error.new('format_error', I18n.t('maini.auth.token.format_error'))
      return
    end

    if register.nil?
      render :status=>401, :json=> Maini::Error.new('request_device_register', I18n.t('maini.auth.token.request_device_register'))
      return
    end

    if platform.nil?
      render :status=>401, :json=> Maini::Error.new('request_device_platform', I18n.t('maini.auth.token.request_device_platform'))
      return
    end


    if login.nil? or password.nil?
      render :status=>401, :json => Maini::Error.new('request_login_and_password', I18n.t('maini.auth.token.request_login_and_password'))
      return
    end

    @user = User.find_by(email: login.downcase)

    if @user.nil?
      render :status=>401, :json=> Maini::Error.new('invalid_login', I18n.t('maini.auth.token.invalid_login'))
      return
    end

    valid_password = @user.valid_password?(password)

    unless valid_password
      render :status=> 401, :json=> Maini::Error.new('invalid_password', I18n.t('maini.auth.token.invalid_password'))
      return
    else

      @device = @user.devices.find_by(register: register)

      unless @device
        @device = @user.devices.create(register: register, platform: platform)
      end

      @user.devices.where.not(id: @device.id).delete_all

      @device.ensure_authentication_token
      @device.save!

      if params[:user_locale].presence

        @user.user_locale = params[:user_locale]

        if I18n.available_locales.include?(@user.user_locale.to_sym)
          I18n.locale = @user.user_locale
        else
          I18n.locale = I18n.default_locale
        end

      end

      @user.save

    end

    token_object = Maini::Auth::Configuration.token_model
    token_serializer = Maini::Auth::Configuration.token_serializer

    response.headers[Maini::Auth::Configuration.auth_headers[:token]]     = @device.authentication_token
    response.headers[Maini::Auth::Configuration.auth_headers[:login]]     = @user.email
    response.headers[Maini::Auth::Configuration.auth_headers[:register]]  = @device.register

    render json: token_object.new(@user, @device), serializer: token_serializer

  end

  def destroy
    param_user_token      = params[Maini::Auth::Configuration.auth_params[:login]]
    param_login_token     = params[Maini::Auth::Configuration.auth_params[:token]]
    param_device_register = params[Maini::Auth::Configuration.auth_params[:register]]

    if param_user_token.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:token]]
      param_user_token = request.headers[Maini::Auth::Configuration.auth_headers[:token]]
    end

    if param_login_token.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:login]]
      param_login_token = request.headers[Maini::Auth::Configuration.auth_headers[:login]]
    end

    if param_device_register.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:register]]
      param_device_register = request.headers[Maini::Auth::Configuration.auth_headers[:register]]
    end

    user_token = param_user_token.presence
    user_login = param_login_token.presence
    device_register = param_device_register.presence

    @user = user_login && User.find_by(email: user_login)

    @device = @user && device_register && @user.devices.find_by(register: device_register)

    if @device.nil?

      render :status=>401, :json=> Maini::Error.new('invalid_token', I18n.t('maini.auth.token.invalid_token'))

    else

      @device.destroy!

      sign_out @user

      token_object = Maini::Auth::Configuration.token_model
      token_serializer = Maini::Auth::Configuration.token_serializer

      render json: token_object.new(@user, @device), serializer: token_serializer
    end


  end

=begin
@apiVersion 0.0.1
@api {get} /auth/tokens/check 02 - Verificar validade do Token
@apiName getTokensCheck
@apiGroup 00 - Acesso

@apiExample Autenticação por Header
  HTTP_ACCEPT: application/json
  X-User-Token: "x7kqavrqwnbg5itmr5BA"
  X-User-Email: "marcos@maini.com.br"
  X-Maini::Auth::Device-Register: "APA91bFd2JaapE_ZCNvB12SS-P2_RQ3Y-c3kkStrBRv6gjIDjbWq9_xRK7ddkK1BrZDAN1l5fK2In8KQGiToGIHzM8RCWmrB97NFDiDlZ_avtzpdYCBgzTeeIFtsvcnve9aEG8C2zVVb4CejlXA6XvqnHmVjE2zOxNgm_oTHE3ZWLA-nFtZUh5A"

@apiSuccessExample Success-Response-Example:
  HTTP/1.1 200 OK
  {
    "user": {
      "id": 5
      "name": "Marcos Junior",
      "login": "marcos@maini.com.br",
      "profile": {
        "id": 1,
        "name": "Administrador"
      }
    },
    "device_id": 6,
    "token": "x5Qx8qujZfqUV38GJyBv"
  }


@apiErrorExample  Token Inválido
  HTTP/1.1 401 Unauthorized
  {
    "errors":{
      "invalid_token":["Invalid Token."]
    }
  }

=end
  def check
    param_user_token      = params[Maini::Auth::Configuration.auth_params[:login]]
    param_login_token     = params[Maini::Auth::Configuration.auth_params[:token]]
    param_device_register = params[Maini::Auth::Configuration.auth_params[:register]]

    if param_user_token.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:token]]
      param_user_token = request.headers[Maini::Auth::Configuration.auth_headers[:token]]
    end

    if param_login_token.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:login]]
      param_login_token = request.headers[Maini::Auth::Configuration.auth_headers[:login]]
    end

    if param_device_register.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:register]]
      param_device_register = request.headers[Maini::Auth::Configuration.auth_headers[:register]]
    end

    user_token      = param_user_token.presence
    user_login      = param_login_token.presence
    device_register = param_device_register.presence

    @user = user_login && User.find_by(email: user_login)

    @device = @user && device_register && @user.devices.find_by(register: device_register)

    unless @device && Devise.secure_compare(@device.authentication_token, user_token)
      render :status=>401, :json => Maini::Error.new('invalid_token', I18n.t('maini.auth.token.invalid_token'))
      return
    end

    token_object = Maini::Auth::Configuration.token_model
    token_serializer = Maini::Auth::Configuration.token_serializer

    render json: token_object.new(@user, @device), serializer: token_serializer
  end


=begin
  @apiVersion 0.0.1
  @api {post} /auth/secret 03 - Esqueci a Senha
  @apiName postAuthSecret
  @apiGroup 00 - Acesso

  @apiExample Autenticação por Header
  HTTP_ACCEPT: application/json
  X-User-Token: "x7kqavrqwnbg5itmr5BA"
  X-User-Email: "marcos@maini.com.br"
  X-Maini::Auth::Device-Register: "APA91bFd2JaapE_ZCNvB12SS-P2_RQ3Y-c3kkStrBRv6gjIDjbWq9_xRK7ddkK1BrZDAN1l5fK2In8KQGiToGIHzM8RCWmrB97NFDiDlZ_avtzpdYCBgzTeeIFtsvcnve9aEG8C2zVVb4CejlXA6XvqnHmVjE2zOxNgm_oTHE3ZWLA-nFtZUh5A"

@apiParam {Object} user
@apiParam {String} user.login E-mail utilizado para login.

=end


=begin
  @apiVersion 0.0.1
  @api {put} /auth/secret 04 - Alterar Senha
  @apiName putAuthSecret
  @apiGroup 00 - Acesso

  @apiExample Autenticação por Header
  HTTP_ACCEPT: application/json
  X-User-Token: "x7kqavrqwnbg5itmr5BA"
  X-User-Email: "marcos@maini.com.br"
  X-Maini::Auth::Device-Register: "APA91bFd2JaapE_ZCNvB12SS-P2_RQ3Y-c3kkStrBRv6gjIDjbWq9_xRK7ddkK1BrZDAN1l5fK2In8KQGiToGIHzM8RCWmrB97NFDiDlZ_avtzpdYCBgzTeeIFtsvcnve9aEG8C2zVVb4CejlXA6XvqnHmVjE2zOxNgm_oTHE3ZWLA-nFtZUh5A"

@apiParam {Object} user
@apiParam {String} user.reset_password_token Token que é enviado no login.
@apiParam {String} user.password Nova Senha.
@apiParam {String} user.password_confirmation Confirmação da Senha.

=end




end
