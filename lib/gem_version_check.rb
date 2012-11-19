require "active_support"
require "bundler"

require "gem_version_check/version"
require "gem_version_check/project"
require "gem_version_check/dependency"
require "gem_version_check/report"

module GemVersionCheck
  extend self

  class GemfileError < StandardError; end
end