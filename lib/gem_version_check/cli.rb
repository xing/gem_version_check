module GemVersionCheck
  module Cli
    extend self

    def run(params)
      result = nil
      if (params.size >= 2)
        generate_report(params)
      else 
        puts "Missing params: gem_version_check my-gh-name/my-project gem1 gem2 gem3"
        exit(1)
      end
    end

    def generate_report(params)
      result = GemVersionCheck::Project.generate_report(params.shift, params)
      puts GemVersionCheck::Formatter::PrettyPrint.new(result).format
      result.check_failed? ? exit(1) : exit(0)
    rescue GemVersionCheck::GemfileLockNotFoundError => e
      puts "Can't find Gemfile.lock for #{e}"
      exit(1)
    end

  end
end