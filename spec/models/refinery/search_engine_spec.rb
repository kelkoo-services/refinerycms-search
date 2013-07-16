require "spec_helper"

module Refinery
  describe SearchEngine do
    describe "#search" do
      before { Page.acts_as_indexed fields: [ :title ], if: ->(p) { !p.draft? } }

      context "when page exist" do
        # we're using page factory because search engine uses
        # page model as default model
        let!(:page) { FactoryGirl.create(:page, :title => "testy") }

        it "returns an array consisting of mathcing pages" do
          result = SearchEngine.search("testy")
          result[:results].should include(page)
        end
      end

      context "when page does not exist" do
        it "returns empty array" do
          result = SearchEngine.search("ugisozols")
          result[:results].should be_empty
        end
      end

      context "when page is draft" do
        let!(:page) { FactoryGirl.create(:page, title: "drafty", draft: true) }

        it "returns empty array" do
          result = SearchEngine.search("drafty")
          result[:results].should be_empty
        end
      end
    end
  end
end
