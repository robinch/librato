require 'librato/client'
require 'librato/config'
require 'librato/spaces'

module Librato
  class Cli < Struct.new(:account, :options)
    require 'librato/cli/command'
    require 'librato/cli/pull'
    require 'librato/cli/push'

    def fetch
      spaces.each do |space|
        Pull.new(client, account, space, config).run
      end
    end

    def push
      spaces.each do |space|
        Push.new(client, account, space, config).run
      end
    end

    private

      def spaces
        @spaces ||= Spaces.new(client, account).find_all(config.spaces)
      end

      def client
        Client.new(*config.account(account).values_at('user', 'token'))
      end

      def config
        @config ||= Config.new(options)
      end
  end
end
