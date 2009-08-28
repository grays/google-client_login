require "net/https"
require "cgi"

module Google

  class ClientLogin

    attr_reader :token

    def initialize(email, password, options = {})
      http             = Net::HTTP.new("www.google.com", 443)
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request          = Net::HTTP::Post.new("/accounts/ClientLogin")
      request.set_form_data({
        "accountType" => options[:type]    || "HOSTED_OR_GOOGLE",
        "service"     => options[:service] || "cp",
        "Email"       => email,
        "Passwd"      => password
      })

      response = http.start { |conn| conn.request(request) }
      @token   = response.body.match(/Auth=(.*)/)[1] if response.code == "200"
    end

    def logged_in?
      @token ? true : false
    end

  end
end