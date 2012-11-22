# encoding: utf-8
require 'spec_helper'

module GemVersionCheck
  describe Report do

    before do
      Project.any_instance.stubs(:report)
    end

    let (:report) do
      report = Report.new(%w(proj1, proj2))
      report.generate
      report
    end

    context "#generate" do
      it "returns array of projects" do
        report = Report.new(%w(proj1, proj2))
        report.generate.size.should == 2
      end

      it "#check_failed? returns true if at least on project failed" do
        Project.any_instance.stubs(:check_failed?).returns(true)
        report.should be_check_failed
      end

      it "#check_failed? returns false if all projects report success" do
        Project.any_instance.stubs(:check_failed?).returns(false)
        report.should_not be_check_failed
      end
    end

  end
end