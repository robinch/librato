require 'json'
require 'librato/chart'

module Librato
  class Space < Struct.new(:client, :data, :config)
    def id
      data['id'] || fail("Unknown id: #{data}")
    end

    def name
      data['name']
    end

    def charts
      @charts ||= fetch.map { |data| Chart.new(client, self, data) }
    end

    def path
      "/v1/spaces/#{data['id']}/charts"
    end

    private

      def fetch
        JSON.parse(client.get(path).body)
      end
  end
end
