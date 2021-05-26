# frozen_string_literal: true

require "json"

module NotionOrbit
    module Interactions
        class Note
            def initialize(note:, orbit_api_key:, orbit_workspace:)
                @note = note
                @orbit_workspace = orbit_workspace
                @orbit_api_key = orbit_api_key

                after_initialize!
            end

            def after_initialize!
                orbit_service = NotionOrbit::Services::Orbit.new(orbit_workspace: @orbit_workspace)
                notion_service = NotionOrbit::Services::Notion.new

                orbit_service.send_note(
                    member_slug: @note[:member_slug],
                    api_key: @orbit_api_key,
                    content: @note[:content]
                )

                notion_service.mark_note_as_synced(@note[:page_id], orbit_note_url(@note[:member_slug]))
            end

            private

            def orbit_note_url(member_slug)
                "https://app.orbit.love/#{ENV['ORBIT_WORKSPACE_ID']}/members/#{member_slug}?type=notes"
            end
        end
    end
end