require "uri"
require "net/http"
require "net/https"

module GemVersionCheck
  class Project

    def initialize(project, options = {})
      @project = project
      @only = options[:only] || []
      @except = options[:except] || []
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
        dependency = Dependency.new(spec_name, nil, allow_prerelease_dependencies: allow_prerelease_dependencies?, ignore_major_version_change: ignore_major_version_change?)
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

    def allow_prerelease_dependencies?
      GemVersionCheck.configuration.allow_prerelease_dependencies
    end

    def display_status?
      GemVersionCheck.configuration.show_progress_bar
    end

    def ignore_major_version_change?
      GemVersionCheck.configuration.ignore_major_version_change
    end

    def spec_names
      if @only.any?
        @only
      elsif @except.any?
        all_spec_names - @except
      else
        all_spec_names
      end
    end

    def all_spec_names
      lock_file.spec_names
    end

  end
end
