# encoding: utf-8

require "gem_version_check"
require "mocha/api"

def lock_file_content(filename)
  IO.read(File.expand_path("../stubs/#{filename}", __FILE__))
end

RSpec.configure do |config|
  config.mock_framework = :mocha
  config.before do
    GemVersionCheck.configuration = { :github_host => "github.com" }
  end
end
