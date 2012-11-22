module GemVersionCheck
  class Report

    def initialize(project_names, options = {})
      @project_names = project_names
      @options       = options
      @only          = options[:only] || []
    end

    def generate
      @check_failed = false
      @project_names.inject([]) do |result, project_name|
        project = Project.new(project_name, @only)
        project.report
        @check_failed = true if project.check_failed?
        result << project
      end
    end

    def check_failed?
      @check_failed
    end

  end
end