require "json"

module GemVersionCheck
  module Formatter

    class JSON
      def initialize(report_result)
        @report_result = Array(report_result)
      end

      def format
        result = []
        @report_result.each do |project|
          project_hash = project_hash(project)
          project.report.each do |dependency|
            project_hash[:dependencies] << dependency_hash(dependency)
          end
          result << project_hash
        end
        ::JSON.pretty_generate(result)
      end

      private

      def project_hash(project)
        project_hash = {
          :name => project.name,
          :check_failed => project.check_failed?,
          :dependencies => []
        }
      end

      def dependency_hash(dependency)
        dep_hash = {
          :name => dependency.name,
          :expected_version => dependency.expected_version,
          :version => dependency.version,
          :valid => dependency.valid?,
          :used => dependency.used?
        }
      end
    end
  end
end