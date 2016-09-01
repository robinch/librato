require 'json'
require 'librato/space'

module Librato
  class Spaces < Struct.new(:client, :account)
    def find_all(config)
      config.map do |config|
        find(config['name']).tap { |space| space.config = config }
      end
    end

    private

      def all
        @all ||= fetch['spaces'].map do |data|
          Space.new(client, normalize(data))
        end
      end

      def find(name)
        space = all.detect { |space| space.name == name }
        space || fail("Could not find space #{name}")
      end

      def fetch
        JSON.parse(client.get(path).body)
      end

      def path
        '/v1/spaces'
      end

      def normalize(data)
        data.merge('name' => data['name'].to_s.sub(/\s*\(#{account}\)\s*/, ''))
      end
  end
end
