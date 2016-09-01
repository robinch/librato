module Librato
  class Template < Struct.new(:string, :vars)
    def generate
      self.string = string.gsub('%', '%%')
      vars.inject(string) do |string, (name, value)|
        string.gsub(value, "%{#{name}}")
      end
    end

    def render
      string % vars.symbolize_keys
    end
  end
end
