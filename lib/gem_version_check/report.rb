module GemVersionCheck
  class Report

    attr_reader :result

    def generate(project)
      project = Project.new(project, checks)
      project.report
      project
    end

    private

    def checks
      @@checks ||= Checks.new();
    end

  end

  

end