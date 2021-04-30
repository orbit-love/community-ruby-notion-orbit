module NotionOrbit
  module NotionObjects
    module BlockTypes
      class ToDo < Block
        def to_markdown
          "[#{@raw_block[@type].checked ? 'x' : ' '}] " + super + "\n"
        end
      end
    end
  end
end