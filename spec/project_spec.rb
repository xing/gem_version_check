# encoding: utf-8
require 'spec_helper'

module GemVersionCheck
  describe Project do
    let(:url) { "https://github.com/toadkicker/teststrap/raw/master/Gemfile.lock" }
    let(:redirect_url) { "https://raw.github.com/toadkicker/teststrap/master/Gemfile.lock" }

    let(:lock_file) { Bundler::LockfileParser.new(lock_file_content("rails_app_example.lock")) }
    let(:project) {
      project = Project.new("toadkicker/teststrap", %w(actionpack not_existing))
      project.stubs(:lock_file).returns(lock_file)
      project
    }

    context "#report" do
      it "returns array of all dependencies" do
        project.report.size.should == 2
        project.report.first.name.should == "actionpack"
        project.report.last.name.should == "not_existing"
      end
    end

    context "#check_failed?" do
      it "returns true if at least one dependency is not up to date or non existing" do
        project.check_failed? == true
      end
    end

    context "#repository" do
      it "returns a url as is" do
        project = Project.new(url, [])
        project.repository.should == url
      end

      it "returns a resolved url if gh project name given" do
        project = Project.new("toadkicker/teststrap", [])
        project.repository.should == redirect_url
      end
    end

    context "#lock_file" do
      it "downloads lock file content and returns lock_file" do
        project = Project.new(redirect_url, [])
        project.expects(:request).returns(lock_file_content("Gemfile.lock"))
        project.lock_file.specs.size.should > 0
      end

      it "raises GemfileLockNotFoundError if not found" do
        project1 = Project.new(redirect_url, [])
        project1.expects(:request).returns(nil)
        expect { project1.lock_file }.to raise_error(GemfileLockNotFoundError)
      end
    end

  end
end