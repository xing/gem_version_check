require "uri"
require "net/http"

module GemVersionCheck
  class Project
    attr_reader :repository, :report

    def self.generate_report(project_name, checks = nil)
      project = Project.new(project_name, checks || Checks.new())
      project.report
      project
    end

    def initialize(project, checks)
      @project = project
      @checks = checks
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
      @checks.each do |key, value|
        dependency = Dependency.new(key, value)
        dependency.check(lock_file)
        @check_failed = true unless dependency.valid?
        result << dependency
      end
      result
    end

    def check_failed?
      @check_failed
    end

    def lock_file
      @lock_file ||= Bundler::LockfileParser.new(download_gemfile_lock(repository))
    end

    def repository
      @repository ||= begin
        if @project =~ /^http(s)?:\/\//
          @project
        else
          gemfile_lock_url
        end
      end
    end

    private

    # github.com redirects github.com/user/project/raw/master/Gemfile.lock to raw.github.com/user/project/master/Gemfile.lock
    # github enterprise does not redirect
    # TODO: change if github enterprise redirects too
    def gemfile_lock_url
      if GemVersionCheck.configuration.github_host == "github.com"
        "https://raw.#{GemVersionCheck.configuration.github_host}/#{@project}/master/Gemfile.lock"
      else
        "https://#{GemVersionCheck.configuration.github_host}/#{@project}/raw/master/Gemfile.lock"
      end
    end

    def download_gemfile_lock(repository)
      uri = URI.parse(repository)
      body = request(uri)
      raise GemfileLockNotFoundError.new(repository) if body.nil?
      body
    end

    def request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      response.code == "200" ? response.body : nil
    end
  end
end