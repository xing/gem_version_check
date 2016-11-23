# encoding: utf-8
require 'spec_helper'

module GemVersionCheck
  describe LockfileFetcher do
    let(:url) { "https://github.com/toadkicker/teststrap/raw/master/Gemfile.lock" }
    let(:redirect_url) { "https://raw.github.com/toadkicker/teststrap/master/Gemfile.lock" }

    context "#repository" do
      it "returns a url as is" do
        fetcher = LockfileFetcher.new(url)
        fetcher.repository.should == url
      end

      it "returns a resolved url if gh project name given" do
        fetcher = LockfileFetcher.new("toadkicker/teststrap")
        fetcher.repository.should == redirect_url
      end
    end

    context "#lock_file" do
      it "downloads lock file content and returns lock_file" do
        fetcher = LockfileFetcher.new(redirect_url)
        fetcher.expects(:request).returns(lock_file_content("rails_app_example.lock"))
        Bundler::LockfileParser.new(fetcher.content).specs.size.should > 0
      end

      it "raises GemfileLockNotFoundError if not found" do
        fetcher = LockfileFetcher.new(redirect_url)
        fetcher.expects(:request).returns(nil)
        expect { fetcher.content }.to raise_error(LockfileFetcher::NotFoundError)
      end
    end

    describe "#content" do
      let(:fetcher) { LockfileFetcher.new(project) }

      context "when initialized with a URL" do
        let(:project) { "https://raw.github.com/fdietz/team_dashboard/raw/master/Gemfile.lock" }

        it "downloads content from url" do
          fetcher.expects(:request).returns("")
          fetcher.content
        end
      end

      context "when initialized with a filename" do
        context "when file exists" do
          let(:project) { "Gemfile.lock" }

          it "reads content from file" do
            File.expects(:read).with(project)
            fetcher.content
          end
        end

        context "when file does not exist" do
          let(:project) { "Dummy.lock" }

          it "raises NotFoundError" do
            fetcher.expects(:request).returns(nil)
            expect { fetcher.content }.to raise_error(LockfileFetcher::NotFoundError)
          end
        end
      end
    end
  end
end


