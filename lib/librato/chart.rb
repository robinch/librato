module Librato
  class Chart < Struct.new(:client, :space, :data)
    def id
      data['id'] ||= find_id
    end

    def name
      data['name']
    end

    def push
      client.post(space.path, data)
    end

    def delete
      client.delete(path)
    end

    private

      def path
        "/v1/spaces/#{space.id}/charts/#{id}"
      end

      def find_id
        chart = space.charts.detect { |chart| chart.name == name }
        chart || fail("Can't find chart")
        chart.id
      end
  end
end
