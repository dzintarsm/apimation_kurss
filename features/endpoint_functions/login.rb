require 'rest-client'
require 'test-unit'

def login_positive

  login_payload = {  :login => @test_user.email,
                     :password => @test_user.password }.to_json

  response = RestClient::Request.execute(method: :post,
                                         url: "https://apimation.com/login",
                                         headers: { 'Content-Type' => 'application/json' },
                                         cookies: {},
                                         payload: login_payload)

  #check if 200 OK ir received
  assert_equal(200, response.code, "shis ir FAIL message! Response : #{response}")

  response_hash = JSON.parse(response)

  assert_equal(@test_user.email, response_hash['email'], 'Email is incorrect!')

  #assert_not_equal(nil, response_hash['user_id'], 'user ID is empty!')

  assert_equal(@test_user.email, response_hash['login'], 'Login is incorrect!')

  @test_user.set_session_cookie(response.cookies)

  @test_user.set_user_id( response_hash['user_id'])

  puts @test_user.user_id
  puts @test_user.session_cookie
end

def check_personal_info

  response = RestClient::Request.execute(method: :get,
                                         url: "https://apimation.com/user",
                                         cookies: @test_user.session_cookie)
  #first check response code, if fails no point to continue further with further checks
  assert_equal(200, response.code, "NOT logged in?!?")

  response_hash = JSON.parse(response)
  puts response.body
  assert_equal('qadzilv@yopmail.com', response_hash['email'], 'VAJJJ')
  assert_equal('2fb58aa0-d694-11e7-8bcd-5d3e2d5d7554', response_hash['user_id'], 'Login is incorrect!')
  #assert_notEqual(nil, response_hash['sid'], 'KASTANU')
end

def login_wrong_password
  login_payload = {  :login => @test_user.email,
                     :password => 'nepareiza parole' }.to_json

  #tiek izmantots api_helpera definetais metod
  response = post("https://apimation.com/login",
                  headers: { 'Content-Type' => 'application/json' },
                  cookies: {},
                  payload: login_payload)

  assert_equal(400, response.code, "Login tomer succeeded or Wrong error code : #{response}")

  response_hash = JSON.parse(response)

  assert_equal('002', response_hash['error-code'], 'Error-code is incorrect!')

  assert_equal('Username or password is not correct', response_hash['error-msg'], 'Error-msg is incorrect!')

  @test_user.set_session_cookie(response.cookies)
end

def check_user_not_logged
  response = get("https://apimation.com/user",
                 headers: {},
                 cookies: @test_user.session_cookie)
  assert_equal(400, response.code, "This wrong")

  response_hash = JSON.parse(response)

  assert_equal('001', response_hash['error-code'], 'Error-code in response is not correct')

end