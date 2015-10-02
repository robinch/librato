require 'librato/chart'

module Librato
  class Cli
    class Push < Command
      def run
        remove_charts
        push_charts
      end

      private

      def remove_charts
        space.charts.each do |chart|
          puts "Removing existing chart #{chart.name.inspect} on #{account}"
          Chart.new(client, space, chart.data).delete
        end
      end

      def push_charts
        store.read.each do |data|
          puts "Pushing chart #{data['name'].inspect} to #{account}."
          Chart.new(client, space, data).push
        end
      end
    end
  end
end
