require 'test_helper'
require 'rest_client'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "the truth" do
    #user = RestClient.get "/users/TestUser"
    #assert user.name.eql? "TestUser"
    assert true
  end
end
