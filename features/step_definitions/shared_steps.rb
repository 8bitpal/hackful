Given /^I am on the startpage$/ do
  visit "/"
end

Given /^I am a new authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  @user = FactoryGirl.create(:user, email: email, password: password, password_confirmation: password)

  visit '/users/sign_in'
  fill_in "user_email", :with=>email
  fill_in "user_password", :with=>password
  click_button "Sign in"
end

Given /^I am not authenticated$/ do
  visit('/users/sign_out') 
end

Given /^I am on the page for a submitted post$/ do
  post = @user.posts.create(FactoryGirl.build(:post).attributes)
  visit "/posts/#{post.id}"
end


Given /^the user has deleted his account$/ do
  User.delete_all
end

When /^I click "([^"]*)"$/ do |link|
  click_link link
end

When /^I click the button "([^"]*)"$/ do |button|
    click_button button
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end
