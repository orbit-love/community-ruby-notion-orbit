module NotionOrbit
  module NotionObjects
    module BlockTypes
      class NumberedListItem < Block
        def to_markdown
          '1. ' + super
        end

        def indent_children?
          true
        end
      end
    end
  end
end