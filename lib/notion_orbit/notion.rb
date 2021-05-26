# frozen_string_literal: true

module NotionOrbit
    class Notion
        def initialize(params = {})
            @orbit_api_key = params.fetch(:orbit_api_key)
            @orbit_workspace = params.fetch(:orbit_workspace)
            @notion_api_key = params.fetch(:notion_api_key)
            @notion_database_id = params.fetch(:notion_database_id)
            @notion_workspace_slug = params.fetch(:notion_workspace_slug)
        end

        def process_notes      
            notion_service = NotionOrbit::Services::Notion.new
            orbit_service = NotionOrbit::Services::Orbit.new(orbit_workspace: @orbit_workspace)
            
            notes = notion_service.notes(database_id: @notion_database_id)
      
            notes.each do |note|
                next if note[:properties][:email].nil? || note[:properties][:email] == ""

                member_slug = orbit_service.member_slug(email: note[:properties][:email])
                next if member_slug.nil? || member_slug == ""

                NotionOrbit::Orbit.call(
                    type: "note",
                    data: {
                        note: {
                            email: note[:properties][:email],
                            member_slug: member_slug,
                            page_id: note[:properties][:page_id],
                            content: note[:content]
                        }
                    }
                )
            end      
        end
    end
end