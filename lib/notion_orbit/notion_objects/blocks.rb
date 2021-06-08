module NotionOrbit
  module NotionObjects
    class Blocks
      include Enumerable

      attr_accessor :blocks

      def initialize(raw_blocks, notion_api_key, indentation: 0)
        @blocks = raw_blocks.map{ |raw_block| Block.new_from_raw_block(raw_block, notion_api_key, indentation: indentation) }
        @notion_api_key = notion_api_key
        @indentation = indentation
      end

      def to_markdown
        @blocks.map { |block| " " * @indentation + block.to_markdown }.join("\n").rstrip.gsub("\n","\\n")
      end
    end
  end
end