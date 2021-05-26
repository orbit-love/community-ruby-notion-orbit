#!/usr/bin/env ruby
# frozen_string_literal: true

require "notion_orbit"
require "thor"

module NotionOrbit
  module Scripts
    class CheckNotes < Thor
      desc "render", "check for new Notion notes and push them to Orbit"
      def render
        client = NotionOrbit::Client.new
        client.notes
      end
    end
  end
end