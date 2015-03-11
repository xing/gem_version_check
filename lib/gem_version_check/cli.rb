require "optparse"

module GemVersionCheck
  module Cli
    extend self

    def run(params)
      project_names, options = parse(params)
      if project_names.size > 0
        generate_report(project_names, options)
      else
        puts "Missing params: gem_version_check my-gh-name/my-project gem1 gem2 gem3"
        exit(1)
      end
    end

    private

    def parse(params)
      options = {}
      option_parser = nil
      project_names = OptionParser.new do |opts|
        opts.banner = "Usage: gem_version_check project [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("--only gem1,gem2,gem3", Array, "List of ruby gems") do |list|
          options[:only] = list
        end

        opts.on("--host github.com", String, "Github host name") do |host|
          options[:host] = host
        end

        opts.on("--sources my.gems.org,rubygems.org", String, "Sources to check for new gems versions") do |sources|
          options[:sources] = sources
        end

        opts.on("--disable-progress-bar", "Disable progress bar") do |disable_progress_bar|
          options[:disable_progress_bar] = disable_progress_bar
        end

        opts.on("--ignore-major-version-change", "Ignore changes of the major version") do |ignore_major_version_change|
          options[:ignore_major_version_change] = ignore_major_version_change
        end

        opts.on("--allow-prerelease-dependencies", "Allow dependencies to be prereleases") do |allow_prerelease_dependencies|
          options[:allow_prerelease_dependencies] = allow_prerelease_dependencies
        end

        opts.on("--output-format FORMAT", %w(json pretty), "Output format") do |output_format|
          options[:output_format] = output_format
        end

        opts.on_tail("--version", "Show version") do
          puts GemVersionCheck::VERSION
          exit
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        option_parser = opts
      end.parse!(params)

      GemVersionCheck.configuration = {
        :github_host                   => options[:host],
        :sources                       => options[:sources],
        :show_progress_bar             => !options[:disable_progress_bar],
        :ignore_major_version_change   => options[:ignore_major_version_change],
        :allow_prerelease_dependencies => options[:allow_prerelease_dependencies]
      }

      [Array(project_names), options]
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument, OptionParser::MissingArgument => e
      puts "#{e}\n"
      puts option_parser
      exit(1)
    end

    def generate_report(project_names, options)
      report = Report.new(project_names, options)

      case options[:output_format]
      when "json"
        puts Formatter::JSON.new(report.generate).format
      else
        puts Formatter::PrettyPrint.new(report.generate).format
      end

      report.check_failed? ? exit(1) : exit(0)
    rescue LockfileFetcher::NotFoundError => e
      puts "Can't find Gemfile.lock for #{e}"
      exit(1)
    end

  end
end
