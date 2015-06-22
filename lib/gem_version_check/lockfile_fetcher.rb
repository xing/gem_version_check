module GemVersionCheck
  class LockfileFetcher

    class NotFoundError < StandardError; end

    def initialize(project)
      @project = project
    end

    def content
      uri = URI.parse(repository)
      body = request(uri)
      raise NotFoundError.new(repository) if body.nil?
      body
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

    # github.com redirects github.com/user/project/raw/master/Gemfile.lock to raw.github.com/user/project/master/Gemfile.lock
    # github enterprise does not redirect
    # TODO: change if github enterprise redirects too
    def gemfile_lock_url
      if GemVersionCheck.configuration.github_host == "github.com"
        "https://raw.#{GemVersionCheck.configuration.github_host}/#{@project}/master/Gemfile.lock"
      else
        "https://#{GemVersionCheck.configuration.github_host}/raw/#{@project}/master/Gemfile.lock"
      end
    end

    def request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      if response.code == "200"
        response.body
      else
        puts "Error retrieving Gemfile.lock: #{response.inspect}"
        nil
      end
    end
  end
end
