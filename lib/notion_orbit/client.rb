# frozen_string_literal: true

require "dotenv/load"
require "net/http"
require "json"

# Create a client to log Notion database activities in your Orbit workspace
# Credentials can either be passed in to the instance or be loaded
# from environment variables
#
# @example
#   client = NotionOrbit::Client.new
#
# @option params [String] :orbit_api_key
#   The API key for the Orbit API
#
# @option params [String] :orbit_workspace
#   The workspace ID for the Orbit workspace
#
# @option params [String] :notion_api_key
#   The API key for Notion
#
# @option params [String] :notion_workspace_slug
#  The Notion workspace slug
#
# @option params [String] :notion_database_id
#  The Notion database ID
#
# @param [Hash] params
#
# @return [NotionOrbit::Client]
#
module NotionOrbit
  class Client
    attr_accessor :orbit_api_key, :orbit_workspace, :notion_database_id, :notion_api_key, :notion_workspace_slug

    def initialize(params = {})
      @orbit_api_key = params.fetch(:orbit_api_key, ENV["ORBIT_API_KEY"])
      @orbit_workspace = params.fetch(:orbit_workspace, ENV["ORBIT_WORKSPACE_ID"])
      @notion_api_key = params.fetch(:notion_api_key, ENV["NOTION_API_KEY"])
      @notion_database_id = params.fetch(:notion_database_id, ENV["NOTION_DATABASE_ID"])
      @notion_workspace_slug = params.fetch(:notion_workspace_slug, ENV["NOTION_WORKSPACE_SLUG"])
    end

    def notes
      NotionOrbit::Notion.new(
        orbit_api_key: @orbit_api_key,
        orbit_workspace: @orbit_workspace,
        notion_api_key: @notion_api_key,
        notion_database_id: @notion_database_id,
        notion_workspace_slug: @notion_workspace_slug
      ).process_notes
    end
  end
end