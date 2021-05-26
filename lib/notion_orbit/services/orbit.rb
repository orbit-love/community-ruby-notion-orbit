require 'uri'
require 'net/http'
require 'openssl'

module NotionOrbit
  module Services
    class Orbit
      def initialize(orbit_workspace:, orbit_api_key:)
        @orbit_workspace = orbit_workspace
        @orbit_api_key = orbit_api_key
      end

      def member_slug(email:) 
        url = URI("https://app.orbit.love/api/v1/#{@orbit_workspace}/members/find?source=email&email=#{email}")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["Accept"] = 'application/json'
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Bearer #{@orbit_api_key}"

        response = http.request(request)
        json = JSON.parse(response.read_body)

        return json["data"]["attributes"]["slug"] if json["data"]

        create_orbit_member(email)
      end

      def create_orbit_member(email)
        url = URI("https://app.orbit.love/api/v1/#{@orbit_workspace}/members")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Accept"] = 'application/json'
        request["Content-Type"] = 'application/json'
        request["Authorization"] = "Bearer #{@orbit_api_key}"
        request["Content-Type"] = "application/json"
        request["User-Agent"] = "community-ruby-notion-orbit/#{NotionOrbit::VERSION}",
        request.body = "{\"member\":{\"email\":\"#{email}\"},\"identity\":{\"source\":\"notion\",\"email\":\"#{email}\"}}"

        response = http.request(request)

        json = JSON.parse(response.read_body)

        return json["data"]["id"] if json["data"]

        nil
      end

      def send_note(api_key:, member_slug:, content:)
        url = URI("https://app.orbit.love/api/v1/#{@orbit_workspace}/members/#{member_slug}/notes")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Accept"] = 'application/json'
        request["Content-Type"] = 'application/json'
        request["Authorization"] = "Bearer #{api_key}"
        request["Content-Type"] = "application/json"
        request["User-Agent"] = "community-ruby-notion-orbit/#{NotionOrbit::VERSION}",
        request.body = "{\"body\":\"#{content}\"}"

        response = http.request(request)
      end
    end
  end
end