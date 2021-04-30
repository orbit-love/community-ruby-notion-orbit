module NotionOrbit
  module NotionObjects
    class RichText
      def initialize(raw_rich_text)
        @raw_rich_text = raw_rich_text
        @type = raw_rich_text.type
        @annotations = raw_rich_text.annotations
        @text = raw_rich_text.text
      end

      def to_markdown
        return "" unless @type == 'text'
        markdown = @text.content
        markdown = apply_link(markdown) unless @text.link.nil?
        markdown = apply_annotations(markdown)
        markdown
      end

      def apply_link(content)
        @text.link.nil? ? content : "[#{content}](#{@text.link.url})"
      end

      def apply_annotations(content)
        annotation_symbols = []
        annotation_symbols << '**' if @annotations.bold
        annotation_symbols << '_' if @annotations.italic
        annotation_symbols << '`' if @annotations.code
        wrap_with(content, annotation_symbols)
      end

      def wrap_with(string, wrappers)
        "#{wrappers.join}#{string}#{wrappers.reverse.join}"
      end
    end
  end
end