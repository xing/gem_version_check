# Enumerable for gem name => version hash
module GemVersionCheck
  class Checks
    include Enumerable

    def initialize(gem_names = nil)
      @gem_names = gem_names || configured_checks
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
            puts "Couldn't find gem #{gem_name} in any source. Maybe a typo or gem can't be found on gems.xing.com?"
          end
        end
        checks
      end
    end

    private

    def configured_checks
      ActiveSupport::JSON.decode(IO.read(checks_file))
    end

    def checks_file
      File.expand_path("../../../checks.json", __FILE__)
    end

  end
end