require "rubygems"

module GemVersionCheck
  class Dependency

    attr_reader :name, :expected_version, :version

    def initialize(name, expected_version = nil, options = {})
      @name = name
      @expected_version = expected_version
      @options = options
    end

    def check(lock_file)
      @version = lock_file.version_for(@name)
      @used = !!@version
      return unless used?

      @result = expected_version == @version
      # puts "#{@result} = #{expected_version} == #{@version}"
    end

    def valid?
      !!@result
    end

    def used?
      @used
    end

    def gem_not_found?
      expected_version.nil?
    end

    def expected_version
      @expected_version ||= latest_version
    end

    def latest_version
      @latest_version ||= begin
        spec = retrieve_spec
        spec ? spec.version.to_s : nil
      end
    end

    private

    def ignore_major_version_change?
      @options[:ignore_major_version_change]
    end

    def major_version
      @version.split('.')[0]
    end

    def retrieve_spec
      if GemVersionCheck.configuration.sources
        Gem.sources = Gem::SourceList.from(GemVersionCheck.configuration.sources.split(','))
      end

      if ignore_major_version_change?
        retrieve_latest_major_version_spec
      else
        retrieve_latest_spec
      end
    end

    def retrieve_latest_major_version_spec
      dependency   = Gem::Dependency.new(name, "~>#{major_version}")
      dependency.prerelease = 1 # allow dependency to be a prerelease
      fetcher      = Gem::SpecFetcher.fetcher
      spec_tuples, = fetcher.spec_for_dependency(dependency)
      spec, = spec_tuples.last
      spec
    end

    def retrieve_latest_spec
      Gem.latest_spec_for(@name)
    end

  end
end
