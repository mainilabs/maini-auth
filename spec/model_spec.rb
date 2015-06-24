require 'rspec'
require 'maini/auth'

describe 'Model' do

  before do
    class User < ActiveRecord::Base
      maini_auth
    end
  end

  it 'Verifica se incluiu o método' do
    # user = User.new
    # expect(user.respond_to?(:devices)).to be_true
  end

end