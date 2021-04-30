module NotionOrbit
  module NotionObjects
    module BlockTypes
      class Unsupported < Block
        def to_markdown
          "[Block #{@type} is not supported yet]"
        end
      end
    end
  end
end