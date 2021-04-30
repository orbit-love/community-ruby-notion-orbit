module NotionOrbit
  class Client
    attr_accessor :database_id

    def process(params = {})
      @database_id = params.fetch(:database_id, ENV["NOTION_DATABASE_ID"])
      @workspace_slug = params.fetch(:workspace_slug, ENV["ORBIT_WORKSPACE_SLUG"])

      notion_service = NotionOrbit::Services::Notion.new
      orbit_service = NotionOrbit::Services::Orbit.new(workspace_slug: @workspace_slug)
      
      notes = notion_service.notes(database_id: @database_id)

      notes.each do |note|
        member_email = note[:properties][:email]
        member_slug = orbit_service.member_slug(email: member_email)

        content = note[:content]

        orbit_service.send_note(member_slug: member_slug, content: content)

        notion_service.mark_note_as_synced(note[:properties][:page_id], orbit_note_url(member_slug))
      end
    end

    private

    def orbit_note_url(member_slug)
      "https://app.orbit.love/#{ENV['ORBIT_WORKSPACE_SLUG']}/members/#{member_slug}?type=notes"
    end
  end
end