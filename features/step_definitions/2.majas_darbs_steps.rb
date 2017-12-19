require 'rest-client'
require 'test-unit'

When(/^I create a new project$/) do
    login_positive #first login to generate a cookie
    @test_user.session_cookie.to_json

    project_name = (0...10).map { (65 + rand(26)).chr }.join #generate random project name

    project_payload = {
        :name => project_name,
        :type => "basic"}.to_json
    response = RestClient::Request.execute(method: :post,
                                           url: "https://apimation.com/projects",
                                           headers: { 'Content-Type' => 'application/json' },
                                           cookies: @test_user.session_cookie,
                                           payload: project_payload)

    #check if 200 OK ir received
    assert_equal(200, response.code, "Failed to create project! Response : #{response}")

    response_hash = JSON.parse(response)

    assert_equal(project_name, response_hash['name'], 'Project name error!')

    #not working in my environment - undefined method
    #assert_not_equal(nil, response_hash['id'], 'project ID is empty!')

  #not working, hoping to update later
=begin    response = get('http://apimation.com/projects',
                   headers: {},
                   cookies: @test_user.session_cookie)

    assert_equal(200, response.code, "Failed to retrieve projects?!?")


    response_hash = JSON.parse(response)
    project_id = response_hash[0]['id']

    #project_id = response_hash.detect {|id| id == project_name} #retrieve ID from array

    active_response = RestClient::Request.execute(method: :put,
                                                url: "https://apimation.com/projects/active/" << project_id,
                                                headers: {},
                                                cookies: @test_user.session_cookie)

    assert_equal(204, active_response.code, "Failed to update active project!")
=end
end

Then (/^I am able to create new environments$/) do
  login_positive
  @test_user.session_cookie.to_json
  env1_payload = {:name => "DEV"}.to_json
  env2_payload = {:name => "PROD"}.to_json

  response1 = RestClient::Request.execute(method: :post,
                                         url: "https://apimation.com/environments",
                                         headers: { 'Content-Type' => 'application/json' },
                                         cookies: @test_user.session_cookie,
                                         payload: env1_payload)

  response2 = RestClient::Request.execute(method: :post,
                                          url: "https://apimation.com/environments",
                                          headers: { 'Content-Type' => 'application/json' },
                                          cookies: @test_user.session_cookie,
                                          payload: env2_payload)


  #first check response code, if fails no point to continue with further checks
  assert_equal(200, response1.code, "Failed to create env?!?")
  assert_equal(200, response2.code, "Failed to create env!?")

  response1_hash = JSON.parse(response1)
  response2_hash = JSON.parse(response2)

  assert_equal("DEV", response1_hash['name'], 'Env error')
  assert_equal("PROD", response2_hash['name'], 'Env error')

      #not working in my environment - undefined method
      #assert_not_equal(nil, response1_hash['id'], 'env is empty!')

end

Then (/^I am able to add global variables$/) do
 login_positive
 @test_user.session_cookie.to_json

 response = get('http://apimation.com/environments',
                headers: {},
                cookies: @test_user.session_cookie)

 assert_equal(200, response.code, "Failed to retrieve env?!?")

 response_hash = JSON.parse(response)
 assert_equal("DEV", response_hash[0]['name'], 'Env error')
 assert_equal("PROD", response_hash[1]['name'], 'Env error')

 env1_id = response_hash[0]['id'] #retrieve ID from array
 env2_id = response_hash[1]['id']

 env1_payload = {:global_vars => [{"key":"$globals1", "value":"vertiba1"},{"key":"$globals2", "value":"vertiba2"}]}.to_json
 env2_payload = {:global_vars => [{"key":"$globals1", "value":"vertiba1"},{"key":"$globals2", "value":"vertiba2"}]}.to_json

 env1_response = RestClient::Request.execute(method: :put,
                                             url: "https://apimation.com/environments/" << env1_id,
                                             headers: { 'Content-Type' => 'application/json' },
                                             cookies: @test_user.session_cookie,
                                             payload: env1_payload)

 env2_response = RestClient::Request.execute(method: :put,
                                             url: "https://apimation.com/environments/" << env2_id,
                                             headers: { 'Content-Type' => 'application/json' },
                                             cookies: @test_user.session_cookie,
                                             payload: env2_payload)

 assert_equal(204, env1_response.code, "Failed to update DEV with global variables?!?")
 assert_equal(204, env2_response.code, "Failed to update PROD with global variables?!?")
end

Then (/^I am able to delete environments$/) do
   login_positive
   @test_user.session_cookie.to_json
   response = RestClient::Request.execute(method: :get,
                                          url: "https://apimation.com/environments",
                                          cookies: @test_user.session_cookie)

   assert_equal(200, response.code, "NOT logged in?!?")

   response_hash = JSON.parse(response)

   assert_equal("DEV", response_hash[0]['name'], 'Incorrect env names')
   assert_equal("PROD", response_hash[1]['name'], 'Incorrect env names')

   env1_id = response_hash[0]['id'] #retrieve ID from array
   env2_id = response_hash[1]['id']

   env1_response = RestClient::Request.execute(method: :delete,
                                               url: "https://apimation.com/environments/" << env1_id,
                                               headers: { 'Content-Type' => 'application/json' },
                                               cookies: @test_user.session_cookie)

   env2_response = RestClient::Request.execute(method: :delete,
                                               url: "https://apimation.com/environments/" << env2_id,
                                               headers: { 'Content-Type' => 'application/json' },
                                               cookies: @test_user.session_cookie)

   assert_equal(204, env1_response.code, "Failed to update DEV with global variables?!?")
   assert_equal(204, env2_response.code, "Failed to update PROD with global variables?!?")
end