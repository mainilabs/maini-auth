ActionController::Base.class_eval do
  include Maini::Auth::Handler
  include Maini::Auth::ControllerAddictions
end