module Maini
  module Auth
    class Device < ActiveRecord::Base
      belongs_to :user

      def ensure_authentication_token
        if authentication_token.blank?
          self.authentication_token = generate_authentication_token
        end
      end

      def generate_authentication_token
        loop do
          token = Devise.friendly_token
          break token unless Device.where(authentication_token: token).first
        end
      end

    end
  end
end