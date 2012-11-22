module GemVersionCheck
  class Lockfile

    def initialize(content)
      @content = content
    end

    def spec_names
      lock_file.specs.map { |spec| spec.name }
    end

    def version_for(name)
      spec = lock_file.specs.find { |spec| spec.name == name }
      spec ? spec.version.to_s : nil
    end

    def total
      lock_file.specs.size
    end

    private

    def lock_file
      @lock_file ||= Bundler::LockfileParser.new(@content)
    end

  end
end