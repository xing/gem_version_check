# encoding: utf-8
require 'spec_helper'

module GemVersionCheck
  describe Project do
    let(:url) { "https://github.com/toadkicker/teststrap/raw/master/Gemfile.lock" }
    let(:redirect_url) { "https://raw.github.com/toadkicker/teststrap/master/Gemfile.lock" }
    let(:lock_file) { Lockfile.new(lock_file_content("rails_app_example.lock")) }
    let(:project) do
      Dependency.any_instance.stubs(:latest_version).returns("1.0")
      project = Project.new("toadkicker/teststrap", %w(actionpack not_existing))
      project.stubs(:lock_file).returns(lock_file)
      project
    end

    context "#report" do
      it "returns array of given dependencies" do
        project.report.size.should == 2
        project.report.first.name.should == "actionpack"
        project.report.last.name.should == "not_existing"
      end

      it "returns array of all dependencies" do
        Dependency.any_instance.stubs(:latest_version).returns("1.0")
        project = Project.new("toadkicker/teststrap")
        project.stubs(:lock_file).returns(lock_file)

        project.report.size.should == 47
      end
    end

    context "#check_failed?" do
      it "returns true if at least one dependency is not up to date or non existing" do
        project.check_failed? == true
      end
    end

  end
end