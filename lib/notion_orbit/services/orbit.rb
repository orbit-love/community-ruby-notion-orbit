require 'uri'
require 'net/http'
require 'openssl'

module NotionOrbit
  module Services
    class Orbit
      def initialize(workspace_slug:)
        @workspace_slug = workspace_slug
      end

      def member_slug(email:) 
        url = URI("https://app.orbit.love/api/v1/#{@workspace_slug}/members/find?source=email&email=#{email}")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["Accept"] = 'application/json'
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Bearer #{ENV['ORBIT_API_KEY']}"

        response = http.request(request)
        json = JSON.parse(response.read_body)
        json['data']['attributes']['slug']
      end

      def send_note(member_slug:, content:)
        url = URI("https://app.orbit.love/api/v1/#{@workspace_slug}/members/#{member_slug}/notes")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Accept"] = 'application/json'
        request["Content-Type"] = 'application/json'
        request["Authorization"] = "Bearer #{ENV['ORBIT_API_KEY']}"
        request["Content-Type"] = "application/json"
        request.body = "{\"body\":\"#{content}\"}"

        response = http.request(request)
      end
    end
  end
end