require "net/https"
require "cgi"

module Google

  class ClientLogin

    attr_reader :token, :email

    def initialize(email, password, options = {})
      @email           = email
      @options         = options
      http             = Net::HTTP.new("www.google.com", 443)
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request          = Net::HTTP::Post.new("/accounts/ClientLogin")
      request.set_form_data({
        "accountType" => @options[:type]    ||= "HOSTED_OR_GOOGLE",
        "service"     => @options[:service] ||= "cp",
        "Email"       => email,
        "Passwd"      => password
      })

      response = http.start { |conn| conn.request(request) }
      @token   = response.body.match(/Auth=(.*)/)[1] if response.code == "200"
    end

    def logged_in?
      @token ? true : false
    end

    # XML profile for the logged in user
    # http://code.google.com/apis/apps/profiles/developers_guide_protocol.html
    def profile
      if logged_in? && @options[:service] == "cp"
        user, domain = @email.split("@")
        http         = Net::HTTP.new("www.google.com")
        response     = http.get(
          "/m8/feeds/profiles/domain/#{domain}/full/#{user}",
          "GData-Version" => "3.0",
          "Authorization" => "GoogleLogin auth=#{@token}"
        )
        response.body if response.code == "200"
      end
    end
  end
end