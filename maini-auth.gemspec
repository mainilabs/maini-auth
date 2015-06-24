# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maini/auth/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= #{Maini::Auth::RUBY_VERSION}"

  spec.name          = "maini-auth"
  spec.version       = Maini::Auth::VERSION
  spec.authors       = ["Marcos Junior"]
  spec.email         = ["marcos@maini.com.br"]
  spec.date           = Date.today.strftime('%Y-%m-%d')

  spec.summary       = 'Autenticação via Token, por device específico'
  spec.description   = ""
  spec.homepage      = "http://www.agivis.com.br"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://rubygems.agivis.com.br"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "rack-test"

  spec.add_dependency "rails", Maini::Auth::RAILS_VERSION
  spec.add_dependency "maini-utils", '~> 0'
  spec.add_dependency "devise", '~> 3.4', '>= 3.4.1'
  spec.add_dependency "active_model_serializers", '0.8.3'

end