module NotionOrbit
  module NotionObjects
    module BlockTypes
      class Heading3 < Block
        def to_markdown
          "### " + super
        end
      end
    end
  end
end