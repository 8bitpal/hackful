When /^I fill in new user details$/ do
  within(".body") do
    fill_in 'User Name', with: 'pbjorklund'
    fill_in 'Email', with: 'p.bjorklund@gmail.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password confirmation', :with => 'password'
  end
  click_button "Sign up"
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
