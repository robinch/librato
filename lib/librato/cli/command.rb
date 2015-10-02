require 'librato/store'

module Librato
  class Cli
    class Command < Struct.new(:client, :account, :space, :config)
      def store
        Store.new(space, dir: config['dir'], vars: config.account(account)['vars'])
      end
    end
  end
end
