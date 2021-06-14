module NotionOrbit
  module Services
    class Notion
      attr_reader :client, :notion_api_key

      def initialize(params = {})
        @client = ::Notion::Client.new(token: params[:notion_api_key])
      end

      def notes(database_id:)
        pages = @client.database_query(id: database_id).results

        # only process pages that opt-in to sending the note to Orbit 
        pages = pages.filter { |page| page.properties['Send to Orbit'].checkbox }

        pages = pages.filter { |page| page.properties['Orbit Status'].rich_text[0] == nil }
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
        blocks = NotionOrbit::NotionObjects::Blocks.new(raw_blocks, @client.token)
        content = blocks.to_markdown
        content += "\\n\\n"
        content += "[Open in Notion](#{page_url(page[:id], page[:properties]["Name"]["title"][0]["text"]["content"])})"
      end

      def page_url(page_id, page_title)
        page_title&.strip.gsub!(" ", "-")
        page_id&.gsub!("-", "")

        "https://notion.so/#{ENV['NOTION_WORKSPACE_SLUG']}/#{page_title}-#{page_id}"
      end
    end
  end
end