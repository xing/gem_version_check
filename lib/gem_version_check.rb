require "bundler"

require "gem_version_check/cli"
require "gem_version_check/version"
require "gem_version_check/project"
require "gem_version_check/dependency"
require "gem_version_check/checks"
require "gem_version_check/configuration"
require "gem_version_check/formatter/json"
require "gem_version_check/formatter/pretty_print"

module GemVersionCheck
  extend self

  class GemfileLockNotFoundError < StandardError; end
  
  def configuration
    @@configuration ||= Configuration.new
  end

  def configuration=(settings)
    @@configuration = Configuration.new(settings)
  end
end