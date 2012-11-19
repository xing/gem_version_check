# -*- coding: UTF-8 -*-
module GemVersionCheck
  class Report

    attr_reader :result

    def initialize(projects = nil)
      @projects = projects
    end

    def generate
      @result = []
      projects.each do |p|
        project = GemVersionCheck::Project.new(p["name"], p["repository"])
        project.report
        @result << project
      end
    end

    private

    def projects
      @projects ||= ActiveSupport::JSON.decode(IO.read(projects_file))["projects"]
    end

    def projects_file
      File.expand_path("../../../projects.json", __FILE__)
    end

  end

  class JSONReport
    def initialize(report)
      @report = report
    end

    def to_json
      result = []
      @report.result.each do |project|
        project_hash = project_hash(project)
        project.report.each do |dependency|
          project_hash[:dependencies] << dependency_hash(dependency)
        end
        result << project_hash
      end
      result.to_json
    end

    private

    def project_hash(project)
      project_hash = {
        :name => project.name,
        :dependencies => []
      }
    end

    def dependency_hash(dependency)
      dep_hash = {
        :name => dependency.name,
        :expected_version => dependency.expected_version,
        :version => dependency.version,
        :used => dependency.used?,
        :valid => dependency.valid?
      }
    end
  end

  class PrettyPrintReport
    def initialize(report)
      @report = report
    end

    def to_s
      result = ""
      @report.result.each do |project|
        dep = ""
        found_invalid = false
        project.report.each do |dependency|
          dep << " * #{dependency.name}: "
          if dependency.used?
            if dependency.valid?
              dep << "#{green}#{dependency.expected_version} ✓"
            else 
              found_invalid = true
              dep << "#{dependency.expected_version} != #{red}#{dependency.version}"
            end
            dep << black + "\n"
          else
            dep << "not used\n"
          end
        end
        result << "Project: #{found_invalid ? red : green}#{project.name}#{black}" + "\n" + dep
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