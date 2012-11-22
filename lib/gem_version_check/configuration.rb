module GemVersionCheck
  class Configuration
    attr_reader :github_host, :show_progress

    def initialize(settings = {})
      @github_host = settings[:github_host]     || "github.com"
      @show_progress = settings[:show_progress] || false
    end
  end
end