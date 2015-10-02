require 'faraday'
require 'json'

module Librato
  class Client < Struct.new(:user, :token)
    HOST = 'https://metrics-api.librato.com'

    [:get, :put, :post, :delete].each do |method|
      define_method(method) { |*args| request(method, *args) }
    end

    private

      def request(method, path, data = nil)
        # puts "#{method.to_s.upcase} #{path}"
        args = [method, path]
        args << JSON.dump(data) if data
        response = client.send(*args) { |r| r.headers['Content-Type'] = 'application/json' }
        fail "#{response.status} #{response.body}" if response.status >= 299
        response
      end

      def client
        Faraday.new(HOST) do |c|
          c.basic_auth(user, token)
          c.use Faraday::Adapter::NetHttp
        end
      end
  end
end
