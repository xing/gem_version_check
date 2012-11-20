require "uri"
require "net/http"

module GemVersionCheck
  class Project
    attr_reader :repository, :report

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

    def gemfile_lock_url
      "https://#{GemVersionCheck.configuration.github_host}/#{@project}/raw/master/Gemfile.lock"
    end

    def download_gemfile_lock(repository)
      uri = URI.parse(repository)
      puts "Retrieving #{repository}..."
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request).body
    end
  end
end