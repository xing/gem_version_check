# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks
Bundler::GemHelper.class_eval do
  remove_method :rubygem_push
  def rubygem_push(path)
    sh("curl -s -S -F file=@#{path} http://gems.xing.com/upload")
    Bundler.ui.confirm "Pushed #{name} #{version} to gems.xing.com"
  end
end
Rake::Task['release'].comment.to_s.sub!('Rubygems', "gems.xing.com")

require 'rake'

task :report do
  require "gem_version_check"
  report = GemVersionCheck::Report.new
  if ENV["PROJECT"]
    result = report.generate(ENV["PROJECT"])
    puts GemVersionCheck::Formatter::PrettyPrint.new(result)
    result.check_failed? ? exit(1) : exit(0)
  else
    result = report.generate_all
    puts GemVersionCheck::Formatter::PrettyPrint.new(result)
    exit(0)
  end
end

task :default => :report