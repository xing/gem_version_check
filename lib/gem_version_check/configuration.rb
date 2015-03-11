module GemVersionCheck
  class Configuration
    attr_reader :github_host, :sources, :show_progress_bar, :ignore_major_version_change, :allow_prerelease_dependencies

    def initialize(settings = {})
      @github_host = settings[:github_host]     || "github.com"
      @sources = settings[:sources]
      @show_progress_bar = settings[:show_progress_bar] || false
      @ignore_major_version_change = settings[:ignore_major_version_change] || false
      @allow_prerelease_dependencies = settings[:allow_prerelease_dependencies] || false
    end
  end
end
