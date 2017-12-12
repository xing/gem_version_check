# encoding: utf-8
require 'spec_helper'

module GemVersionCheck
  describe Configuration do
    after do
    end

    it "returns github.com as default github_host" do
      GemVersionCheck.configuration.github_host.should == "github.com"
    end

    it "returns specified value if set" do
      GemVersionCheck.configuration = { :github_host => "test", token: 'teeest' }
      GemVersionCheck.configuration.github_host.should == "test"
      GemVersionCheck.configuration.token.should == 'teeest'
    end
  end
end
