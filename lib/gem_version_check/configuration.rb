module GemVersionCheck
  class Configuration
    attr_reader :github_host, :show_progress_bar

    def initialize(settings = {})
      @github_host = settings[:github_host]     || "github.com"
      @show_progress_bar = settings[:show_progress_bar] || false
    end
  end
end