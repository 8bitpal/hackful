require 'test_helper'

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  fixtures :all

  def process(method, path, parameters = nil, rack_env = nil)
    rack_env ||= {}
    if path =~ %r{://}
      location = URI.parse(path)
      https! URI::HTTPS === location if location.scheme
      host! location.host if location.host
      path = location.query ? "#{location.path}?#{location.query}" : location.path
    end

    unless ActionController::Base < ActionController::Testing
      ActionController::Base.class_eval do
        include ActionController::Testing
      end
    end

    hostname, port = host.split(':')

    env = {
      :method => method,
      :params => parameters,

      "SERVER_NAME"     => hostname,
      "SERVER_PORT"     => port || (https? ? "443" : "80"),
      "HTTPS"           => https? ? "on" : "off",
      "rack.url_scheme" => https? ? "https" : "http",

      "REQUEST_URI"    => path,
      "HTTP_HOST"      => host,
      "REMOTE_ADDR"    => remote_addr,
      "CONTENT_TYPE"   => "application/x-www-form-urlencoded",
      "HTTP_ACCEPT"    => accept
    }

    _mock_session ||= Rack::MockSession.new(@app, host)
    session = Rack::Test::Session.new(_mock_session)

    env.merge!(rack_env)

    # NOTE: rack-test v0.5 doesn't build a default uri correctly
    # Make sure requested path is always a full uri
    uri = URI.parse('/')
    uri.scheme ||= env['rack.url_scheme']
    uri.host   ||= env['SERVER_NAME']
    uri.port   ||= env['SERVER_PORT'].try(:to_i)
    uri += path

    session.request(uri.to_s, env)

    @request_count += 1
    @request  = ActionDispatch::Request.new(session.last_request.env)
    response = _mock_session.last_response
    @response = ActionDispatch::TestResponse.new(response.status, response.headers, response.body)
    @html_document = nil

    @controller = session.last_request.env['action_controller.instance']

    return response.status
  end

  def setup
    @post = posts(:first)
    @user = users(:david)
    @user.reset_authentication_token!
  end

  def teardown
    @post = nil
  end

  # test "show a post" do
  #   get "/api/v1/post/#{@post.id}", :format => :json
  #   post_json = JSON.parse(response.body)

  #   assert post_json["id"].eql? @post.id
  #   assert post_json["title"].eql? @post.title
  #   assert post_json["link"].eql? @post.link
  #   assert post_json["text"].eql? @post.text
  #   assert post_json["up_votes"].eql? @post.up_votes
  #   assert post_json["created_at"].to_time == @post.created_at
  #   assert post_json["updated_at"].to_time == @post.updated_at
  # end

  # test "vote a post" do
  #   put "/api/v1/post/#{@post.id}/vote", 
  #     :format => :json, 
  #     :auth_token => @user.authentication_token

  #   assert_response :success
  #   assert Post.find(@post.id).up_votes == 1
  # end

  test "create a post" do
    new_post = {
      :link => "http://example.com/", 
      :title => "New Post", 
      :text => "New awesome post"
    }
    token = "#{@user.authentication_token.to_s}"
    request_body = {}
    #post("/api/v1/post", {"test_token" => token}, nil) 
    
    puts "create: #{request.body.to_json}"
    puts "create: #{response.body.to_json}"
    
    assert_response :success

    created_post = Post.find_by_link("http://example.com/")
    assert !created_post.nil?
    assert_equal created_post.title, new_post[:title]
    assert_equal created_post.link, new_post[:link]
    assert_equal created_post.text, new_post[:text]
    assert_equal created_post.user.id, @user.id
    assert_equal created_post.up_votes, 1
  end

  # test "update a post" do
  #   put "/api/v1/post/#{@post.id}", :format => :json, :post => {:link => "heins"}, :auth_token => @user.authentication_token
    
  #   puts "update: #{request.body.to_json}"
  #   puts request.url.to_json
  #   puts response.body.to_json

  #   assert_response :success
  # end

end
