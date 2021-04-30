module NotionOrbit
  module NotionObjects
    class Block
      class << self
        def new_from_raw_block(raw_block, indentation: 0)
          klass = case raw_block.type
          when 'bulleted_list_item'
            NotionOrbit::NotionObjects::BlockTypes::BulletedListItem
          when 'heading_1'
            NotionOrbit::NotionObjects::BlockTypes::Heading1
          when 'heading_2'
            NotionOrbit::NotionObjects::BlockTypes::Heading2
          when 'heading_3'
            NotionOrbit::NotionObjects::BlockTypes::Heading3
          when 'numbered_list_item'
            NotionOrbit::NotionObjects::BlockTypes::NumberedListItem
          when 'paragraph'
            NotionOrbit::NotionObjects::BlockTypes::Paragraph
          when 'to_do'
            NotionOrbit::NotionObjects::BlockTypes::ToDo
          else
            NotionOrbit::NotionObjects::BlockTypes::Unsupported
          end
          klass.new(raw_block, indentation)
        end
      end

      def initialize(raw_block, indentation)
        @raw_block = raw_block
        @id = raw_block.id
        @type = raw_block.type
        @has_children = raw_block.has_children
        @indentation = indentation
      end

      def to_markdown
        markdown = @raw_block[@type].text.map do |rich_text|
          NotionOrbit::NotionObjects::RichText.new(rich_text).to_markdown
        end.join

        if @has_children
          raw_children = notion_service.client.block_children(id: @id).results
          children_indentation = indent_children? ? @indentation + 2 : @indentation
          children_blocks = Blocks.new(raw_children, indentation: children_indentation)
          markdown += "\n\n" + children_blocks.to_markdown
        end

        markdown
      end

      def indent_children?
        false
      end

      def notion_service
        @notion_service ||= NotionOrbit::Services::Notion.new
      end
    end
  end
end