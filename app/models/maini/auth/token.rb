module Maini
  module Auth
    class Token
      alias :read_attribute_for_serialization :send

      attr_reader :user, :device

      def initialize(user, device = nil)
        @user   = user
        @device = device
      end

    end
  end
end