Given /^I am on the startpage$/ do
  visit "/"
end

Given /^I am a new authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  FactoryGirl.create(:user, email: email, password: password, password_confirmation: password)

  visit '/users/sign_in'
  fill_in "user_email", :with=>email
  fill_in "user_password", :with=>password
  click_button "Sign in"
end

Given /^I am not authenticated$/ do
  visit('/users/sign_out') 
end

When /^I click "([^"]*)"$/ do |link|
  click_link link
end

When /^I fill in new user details$/ do
  within(".body") do
    fill_in 'User Name', with: 'pbjorklund'
    fill_in 'Email', with: 'p.bjorklund@gmail.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password confirmation', :with => 'password'
  end
  click_button "Sign up"
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

When /^I fill in my user details$/ do
  within(".body") do
    fill_in 'User Name', with: 'pbjorklund'
    fill_in 'Email', with: 'p.bjorklund@gmail.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password confirmation', :with => 'password'
  end
  click_button "Sign up"
end
