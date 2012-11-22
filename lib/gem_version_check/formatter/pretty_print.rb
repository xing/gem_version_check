# -*- coding: UTF-8 -*-
module GemVersionCheck
  module Formatter
    class PrettyPrint

      def initialize(report_result)
        @report_result = Array(report_result)
      end

      def format
        @report_result.inject("") do |result, project|
          result << "#{project_title(project)}\n#{format_project(project)}"
        end
      end

      private

      def format_project(project)
        project.report.inject("") do |result, dependency|
          result << dependency_listitem(dependency) do |dep|
            dep.used? ? format_dependency(dependency) : "not used"
          end
        end
      end

      def project_title(project)
        "Project: #{project.check_failed? ? red : green}#{project.name}#{black}" 
      end

      def dependency_listitem(dep)
        " #{dep.name}: #{ yield dep }\n"
      end

      def format_dependency(dep)
        if dep.gem_not_found?
          "not found"
        elsif dep.valid?
          valid_dependency(dep)
        else
          invalid_dependency(dep)
        end
      end

      def valid_dependency(dep)
        "#{green}#{dep.expected_version} ✓#{black}"
      end

      def invalid_dependency(dep)
        "#{dep.expected_version} != #{red}#{dep.version}#{black}"
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