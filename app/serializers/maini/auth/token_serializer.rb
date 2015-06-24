module Maini
  module Auth
    class TokenSerializer < ActiveModel::Serializer
      attributes :token

      has_one :user
      has_one :device

      def token
        device.authentication_token
      end

    end

  end
end