# encoding: utf-8
require 'spec_helper'

module GemVersionCheck
  describe Project do
    let(:url) { "https://github.com/toadkicker/teststrap/raw/master/Gemfile.lock" }
    let(:redirect_url) { "https://raw.github.com/toadkicker/teststrap/master/Gemfile.lock" }
    let(:lock_file) { Lockfile.new(lock_file_content("rails_app_example.lock")) }
    let(:options) { {} }
    let(:project) do
      Dependency.any_instance.stubs(:latest_version).returns("1.0")
      project = Project.new("toadkicker/teststrap", options)
      project.stubs(:lock_file).returns(lock_file)
      project
    end

    context "#report" do
      context "with whitelisted gems" do
        let(:options) { { only: %w(actionpack not_existing) } }

        it "returns array of given dependencies" do
          project.report.size.should == 2
          project.report.first.name.should == "actionpack"
          project.report.last.name.should == "not_existing"
        end
      end

      context "with blacklisted gems" do
        let(:options) { { except: %w(actionpack not_existing) } }

        it "returns array of all dependencies except the given ones" do
          project.report.size.should == 46
          project.report.map(&:name).should_not include("actionpack")
        end
      end

      context "without black- or whitelisting" do
        it "returns array of all dependencies" do
          project.report.size.should == 47
        end
      end
    end

    shared_examples "check_failed" do
      it "returns true if at least one dependency is not up to date or non existing" do
        project.check_failed? == true
      end
    end

    context "#check_failed?" do
      context "with whitelisted gems" do
        let(:options) { { only: "actionpack" } }
        include_examples "check_failed"
      end

      context "with blacklisted gems" do
        let(:options) { { except: "actionpack" } }
        include_examples "check_failed"
      end

      context "without black- or whitelisting" do
        include_examples "check_failed"
      end
    end
  end
end
