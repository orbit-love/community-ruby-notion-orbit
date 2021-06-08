module NotionOrbit
  module Services
    class Notion
      attr_reader :client, :token

      def initialize(params = {})
        @client = ::Notion::Client.new(token: params.fetch(:notion_api_key, ENV["NOTION_API_KEY"]))
      end

      def notes(database_id:)
        pages = @client.database_query(id: database_id).results
        
        # only process pages that opt-in to sending the note to Orbit 
        pages = pages.filter { |page| page.properties['Send to Orbit'].checkbox }
        puts pages

        notes = []
        pages.each do |page|
          notes << {
            properties: page_properties(page),
            content: page_content(page)
          }
        end
        notes
      end

      def mark_note_as_synced(page_id, orbit_note_url)
        properties = {
          'Orbit Note URL': orbit_note_url,
          'Orbit Status': [{ text: { content: "OK" }}]
        }
        @client.update_page(id: page_id, properties: properties)
      end

      private

      def page_properties(page)
        {
          email: page[:properties]['Member Email'].email,
          page_id: page[:id]
        }
      end

      def page_content(page)
        raw_blocks = @client.block_children(id: page.id).results
        blocks = NotionOrbit::NotionObjects::Blocks.new(raw_blocks)
        content = blocks.to_markdown
        content += "\\n\\n"
        content += "[Open in Notion](#{page_url(page[:id])})"
      end

      def page_url(page_id)
        "https://notion.so/#{ENV['NOTION_WORKSPACE_SLUG']}/#{page_id}}"
      end
    end
  end
end