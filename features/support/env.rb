Before() do
  puts "Before hook. This will work before every test case!"
  @test_user = User.new( 'qadzilv@yopmail.com', 'parole123')
end