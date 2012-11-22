require "uri"
require "net/http"
require "net/https"

module GemVersionCheck
  class Project

    def self.generate_report(project_name, spec_names = nil)
      project = Project.new(project_name, spec_names)
      project.report
      project
    end

    def initialize(project, spec_names = nil)
      @project = project
      @spec_names = spec_names
    end

    def name
      @project
    end

    def report
      @report ||= generate_report
    end

    def generate_report
      @check_failed = false
      result = []
      with_progress_bar(spec_names) do |spec_name|
        dependency = Dependency.new(spec_name)
        dependency.check(lock_file)
        result << dependency

        @check_failed = true unless dependency.valid?
      end
      result
    end

    def check_failed?
      @check_failed
    end

    def lock_file
      @lock_file ||= begin
        content = LockfileFetcher.new(@project).content
        Lockfile.new(content)
      end
    end

    private

    def with_progress_bar(elements)
      pb = ProgressBar.new("Fetch specs", lock_file.total) if display_status?
      elements.each do |el|
        yield el
        pb.inc if display_status?
      end
      pb.clear if display_status?
    end

    def display_status?
      GemVersionCheck.configuration.show_progress
    end

    def spec_names
      Array(@spec_names).any? ? @spec_names : all_spec_names
    end

    def all_spec_names
      lock_file.spec_names
    end

  end
end