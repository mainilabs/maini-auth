require 'rspec'
require 'maini/auth'

describe 'Configuration' do

  it 'Verificando o valor padrão de uma propriedade' do
    expect(Maini::Auth::Configuration.name).to eq('default')
  end

  it 'Mudando uma propriedade diretamente' do
    Maini::Auth::Configuration.name = 'Marcos'
    expect(Maini::Auth::Configuration.name).to eq('Marcos')
  end

  it 'Mudando uma propriedade por bloco' do

    Maini::Auth::Configuration.setup do |config|
      config.name = 'Marcos'
    end

    expect(Maini::Auth::Configuration.name).to eq('Marcos')

  end

  it 'Usando o atalho em Maini::Auth.setup' do

    Maini::Auth.setup do |config|
      config.name = "Marcos"
    end

    expect(Maini::Auth::Configuration.name).to eq('Marcos')

  end

end