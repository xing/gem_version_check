# Enumerable for gem name => version hash
module GemVersionCheck
  class Checks
    include Enumerable

    def initialize(gem_names)
      @gem_names = gem_names
    end

    def each(&block)
      members.each(&block)
    end

    def members
      @members ||= begin
        puts "Fetching gemspecs for all listed gems..."
        checks = {}
        @gem_names.each do |gem_name|
          spec = Gem.latest_spec_for(gem_name)
          if spec
            puts " * #{gem_name}: #{spec.version.to_s}"
            checks[gem_name] = spec.version.to_s
          else
            puts " * #{gem_name}: not found (Maybe a typo?)"
          end
        end
        checks
      end
    end

  end
end