# encoding: utf-8
require 'spec_helper'

module GemVersionCheck
  describe Lockfile do
    let(:lockfile) { Lockfile.new(lock_file_content("rails_app_example.lock")) }

    describe "#spec_names" do
      it "returns all spec names" do
        lockfile.spec_names.size.should == 47
        lockfile.spec_names.should include("activesupport")
      end
    end

    describe "#version_for" do
      it "returns spec for name" do
        lockfile.version_for("activesupport").should == "3.2.8"
      end

      it "returns nil if spec does not exist" do
        lockfile.version_for("non_existing_gem").should be_nil
      end
    end

    describe "#total" do
      it "returns total number of spec" do
        lockfile.total.should == 47
      end
    end
  end
end