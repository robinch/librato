module Librato
  class Template < Struct.new(:string, :vars)
    def generate
      vars.inject(string) do |string, (name, value)|
        string.gsub(value, "%{#{name}}")
      end
    end

    def render
      string % vars.symbolize_keys
    end
  end
end
