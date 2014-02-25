module GemVersionCheck
  class Configuration
    attr_reader :github_host, :show_progress_bar, :ignore_major_version_change

    def initialize(settings = {})
      @github_host = settings[:github_host]     || "github.com"
      @show_progress_bar = settings[:show_progress_bar] || false
      @ignore_major_version_change = settings[:ignore_major_version_change] || false
    end
  end
end