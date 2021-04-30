module NotionOrbit
  module NotionObjects
    module BlockTypes
      class Paragraph < Block
        def to_markdown
          super + "\n"
        end

        def indent_children?
          false
        end
      end
    end
  end
end