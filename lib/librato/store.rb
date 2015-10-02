require 'fileutils'
require 'json'
require 'core_ext/hash'
require 'librato/template'

module Librato
  class Store < Struct.new(:space, :options)
    def clear
      puts "Clearing existing chart data in #{dir}."
      FileUtils.rm_r(dir) if File.directory?(dir)
    end

    def write(chart)
      FileUtils.mkdir_p(dir)
      json = JSON.pretty_generate(chart.deep_except('id'))
      tmpl = Template.new(json, vars).generate
      path = path(chart['name'])
      puts "Storing chart data to #{path}."
      File.open(path, 'w+') { |f| f.write(tmpl) }
    end

    def read
      puts "Reading chart data from #{dir}."
      Dir["#{dir}/*.json"].sort.map do |path|
        tmpl = File.read(path)
        json = Template.new(tmpl, vars).render
        JSON.parse(json)
      end
    end

    private

      def path(name)
        name = name.gsub(/[\W]+/, ' ').downcase.strip.gsub(' ', '_')
        num  = order.index(name) || 0
        path = "#{dir}/#{num.to_s.rjust(2, '0')}_chart_#{name}.json"
      end

      def order
        space.config['order'] || []
      end

      def vars
        options[:vars] || {}
      end

      def dir
        [options[:dir] || './var/librato', dir_name(space.name)].join('/')
      end

      def dir_name(string)
        string.gsub(/[\W]/, ' ').strip.gsub('  ', ' ').gsub(' ', '_').downcase
      end
  end
end
