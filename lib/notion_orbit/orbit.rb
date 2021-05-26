# frozen_string_literal: true

module NotionOrbit
    class Orbit
        def self.call(type:, data:, orbit_workspace:, orbit_api_key:)
            if type == "note"
                NotionOrbit::Interactions::Note.new(
                    note: data[:note],
                    orbit_workspace: orbit_workspace,
                    orbit_api_key: orbit_api_key
                )
            end
        end
    end
end