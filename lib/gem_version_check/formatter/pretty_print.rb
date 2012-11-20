# -*- coding: UTF-8 -*-
module GemVersionCheck
  module Formatter
    class PrettyPrint
      def initialize(report_result)
        @report_result = Array(report_result)
      end

      def format
        result = ""
        @report_result.each do |project|
          dep = ""
          project.report.each do |dependency|
            dep << " * #{dependency.name}: "
            if dependency.used?
              if dependency.valid?
                dep << "#{green}#{dependency.expected_version} ✓"
              else 
                dep << "#{dependency.expected_version} != #{red}#{dependency.version}"
              end
              dep << black + "\n"
            else
              dep << "not used\n"
            end
          end
          result << "Project: #{project.check_failed? ? red : green}#{project.name}#{black}" + "\n" + dep
        end
        result
      end

      def black
        "\033[30m"
      end

      def green
        "\033[32m"
      end

      def red
        "\033[31m"
      end

    end
  end
end