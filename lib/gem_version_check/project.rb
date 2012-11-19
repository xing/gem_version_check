require "uri"
require "net/http"

module GemVersionCheck
  class Project
    attr_reader :name, :repository

    def initialize(name, repository)
      @name = name
      @repository = repository
    end

    def report
      @report ||= generate_report
    end

    def lock_file
      @lock_file ||= Bundler::LockfileParser.new(download_gemfile_lock)
    end

    def generate_report
      result = []
      checks.each do |key, value|
        dependency = Dependency.new(key, value)
        dependency.check(lock_file)
        result << dependency
      end
      result
    end

    private

    def checks
      @checks ||= ActiveSupport::JSON.decode(IO.read(checks_file))
    end

    def checks_file
      File.expand_path("../../../checks.json", __FILE__)
    end

    def gemfile_lock_url
      "https://source.xing.com/#{@repository}/raw/master/Gemfile.lock"
    end

    def download_gemfile_lock
      uri = URI.parse(gemfile_lock_url)
      puts "Retrieving #{gemfile_lock_url}..."
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request).body
    rescue Http::HTTPClientError, Http::HTTPServerError => e
      raise GemfileError.new("Error retrieving Gemfile.lock from #{uri}")
    end
  end
end