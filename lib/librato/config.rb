require 'yaml'

module Librato
  class Config < Struct.new(:options)
    def [](key)
      data[key]
    end

    def spaces
      (options[:spaces] || data['spaces'] || []).map do |space|
        space.is_a?(Hash) ? space : { 'name' => space }
      end
    end

    def accounts
      (data['accounts'] || {}).map do |name, account|
        env(name).merge(account).tap { |account| validate(account, name) }
      end
    end

    private

      def data
        @data ||= read.tap do |data|
          data['dir'] = options[:dir] if options[:dir]
        end
      end

      def read
        File.exist?(path) ? YAML.load_file(path) : {}
      end

      def path
        options[:config] || '.librato.yml'
      end

      def env(name)
        { 'user' => var(:user, name), 'token' => var(:token, name) }
      end

      def var(account, name)
        ENV["LIBRATO_#{account.upcase}_#{name.upcase}"]
      end

      def validate(account, name)
        %w(user token).each { |key| validate_presence(account, name, key) }
      end

      def validate_presence(hash, name, key)
        hash[key] || fail("Unknown #{key} for #{name}.")
      end
  end
end
