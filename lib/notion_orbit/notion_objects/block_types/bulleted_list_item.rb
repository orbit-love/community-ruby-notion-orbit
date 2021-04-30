module NotionOrbit
  module NotionObjects
    module BlockTypes
      class BulletedListItem < Block
        def to_markdown
          '- ' + super
        end

        def indent_children?
          true
        end
      end
    end
  end
end