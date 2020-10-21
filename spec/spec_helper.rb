require 'gem_version_check'
require 'mocha/api'

def lock_file_content(filename)
  IO.read(File.expand_path("../stubs/#{filename}", __FILE__))
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:expect, :should]
  end
  config.mock_framework = :mocha
  config.before do
    GemVersionCheck.configuration = { github_host: 'github.com', token: 'testtoken' }
  end
end
