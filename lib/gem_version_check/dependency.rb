module GemVersionCheck
  class Dependency

    attr_reader :name, :expected_version, :version

    def initialize(name, expected_version)
      @name = name
      @expected_version = expected_version
    end

    def check(lock_file)
      @version = spec_version(@name, lock_file)
      @used = !!@version
      return unless used?
      
      @result = @expected_version == @version
    end

    def valid?
      !!@result
    end

    def used?
      @used
    end

    private

    def spec_version(name, lock_file)
      spec = find_spec(name, lock_file)
      spec ? spec.version.to_s : nil
    end

    def find_spec(name, lock_file)
      lock_file.specs.find { |spec| spec.name == name }
    end
  end
end