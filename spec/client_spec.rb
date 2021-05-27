
# frozen_string_literal: true

require "spec_helper"

RSpec.describe NotionOrbit::Client do
  let(:subject) do
    NotionOrbit::Client.new(
      orbit_api_key: "12345",
      orbit_workspace: "test",
      notion_api_key: "a123",
      notion_database_id: "1234567",
      notion_workspace_slug: "testingslug"
    )
  end

  it "initializes with arguments passed in directly" do
    expect(subject).to be_truthy
  end

  it "initializes with credentials from environment variables" do
    allow(ENV).to receive(:[]).with("ORBIT_API_KEY").and_return("12345")
    allow(ENV).to receive(:[]).with("ORBIT_WORKSPACE").and_return("test")
    allow(ENV).to receive(:[]).with("NOTION_API_KEY").and_return("a123")
    allow(ENV).to receive(:[]).with("NOTION_DATABASE_ID").and_return("1234567")
    allow(ENV).to receive(:[]).with("NOTION_WORKSPACE_SLUG").and_return("testingslug")

    expect(NotionOrbit::Client).to be_truthy
  end
end