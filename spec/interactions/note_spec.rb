# frozen_string_literal: true

require "spec_helper"

RSpec.describe NotionOrbit::Interactions::Note do
    let(:subject) do
        NotionOrbit::Interactions::Note.new(
            orbit_workspace: "1234",
            orbit_api_key: "12345",
            notion_api_key: "a123",
            note: {
                email: "test@test.com",
                member_slug: "testing-person",
                page_id: "12",
                content: "This is content!"
            }
        )
    end

    describe "#call" do
        context "when the type is a note" do
            it "returns a Note object" do
                stub_request(:post, "https://app.orbit.love/api/v1/1234/members/testing-person/notes").
                with(
                  body: "{\"body\":\"This is content!\"}",
                  headers: {
                    'Accept'=>'application/json',
                    'Authorization'=>'Bearer 12345',
                    'Content-Type'=>'application/json',
                    'Host'=>'app.orbit.love',
                    'User-Agent'=>"community-ruby-notion-orbit/#{NotionOrbit::VERSION}"
                  }).
                to_return(status: 200, body: "", headers: {})

                stub_request(:patch, "https://api.notion.com/v1/pages/12").
                with(
                  body: "{\"id\":\"12\",\"properties\":{\"Orbit Note URL\":\"https://app.orbit.love/1234/members/testing-person?type=notes\",\"Orbit Status\":[{\"text\":{\"content\":\"OK\"}}]}}",
                  headers: {
                    'Accept'=>'application/json; charset=utf-8',
                    'Authorization'=>'Bearer a123',
                    'Content-Type'=>'application/json'
                  }).
                to_return(status: 200, body: "", headers: {})

                expect(subject.class).to eq(NotionOrbit::Interactions::Note)
            end
        end
    end
end