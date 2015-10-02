module Librato
  class Cli
    class Pull < Command
      def run
        clear_charts
        write_charts
      end

      private

        def clear_charts
          store.clear
        end

        def write_charts
          space.charts.each do |chart|
            store.write(chart.data)
          end
        end
    end
  end
end
