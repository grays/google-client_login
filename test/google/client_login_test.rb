require 'test_helper'

class Google::ClientLoginTest < Test::Unit::TestCase

  def client_login
    Google::ClientLogin.new("user@example.com", "secret")
  end

  context "sucessful login" do

    setup do
      @http_mock = mock('Net::HTTPResponse')
      @http_mock.stubs(
        :code         => "200",
        :message      => "OK",
        :content_type => "text/plain",
        :body         => [
          "SID=DQAAAGgA...7Zg8CTN",
          "LSID=DQAAAGsA...lk8BBbG",
          "Auth=DQAAAGgA...dk3fA5N"
        ].join("\n")
      ) 

      Net::HTTP.any_instance.stubs(:request).returns(@http_mock)
    end

    should "be logged in" do
      assert client_login.logged_in?
    end

    should "have an authentication token" do
      assert_equal "DQAAAGgA...dk3fA5N", client_login.token
    end

  end

  context "failed login" do

    setup do
      @http_mock = mock('Net::HTTPResponse')
      @http_mock.stubs(
        :code         => "403",
        :message      => "Access Forbidden",
        :content_type => "text/plain",
        :body         => [
          "Url=http://www.google.com/login/captcha",
          "Error=CaptchaRequired",
          "CaptchaToken=DQAAAGgA...dkI1LK9",
          "CaptchaUrl=Captcha?ctoken=HiteT4b0....eiI7lUSN"
        ].join("\n")
      ) 

      Net::HTTP.stubs(:post_form).returns(@http_mock)
    end

    should "not be logged in" do
      assert !client_login.logged_in?
    end

    should "not have an authentication token" do
      assert_nil nil, client_login.token
    end

  end

end
