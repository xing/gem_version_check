module GemVersionCheck
  class Dependency

    attr_reader :name, :expected_version, :version

    def initialize(name, expected_version)
      @name = name
      @expected_version = expected_version
    end

    def check(lock_file)
      spec = lock_file.specs.find { |spec| spec.name == @name }
      @used = !!spec
      return unless used?
      
      @version = spec.version.to_s
      @result = @expected_version == @version
    end

    def valid?
      !!@result
    end

    def used?
      @used
    end

  end
end