source 'http://rubygems.org'
source 'http://gemcutter.org'

gem 'rails', '3.1.3'

gem 'sqlite3'
gem 'json'

group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'cucumber-rails', require: false
  gem "factory_girl_rails"
  gem 'capybara'
  gem "capybara-webkit"
  gem 'fakeweb'
  gem "launchy"
  gem 'database_cleaner', :group => :test
  gem 'faker'
  gem 'pry'
  gem 'rest-client'

  if RUBY_PLATFORM.downcase.include?("darwin")
    gem "guard"
    gem "guard-rspec"
    gem "guard-cucumber"
    gem "guard-bundler"
    gem "guard-spork"
    gem 'spork'
    gem 'rb-fsevent'
    gem 'growl' # also install growlnotify from the Extras/growlnotify/growlnotify.pkg in Growl disk image
  end
end

gem 'execjs'
gem 'therubyracer'
gem 'devise'
gem 'nested_form', :git => 'git://github.com/fxposter/nested_form.git'
gem 'jquery-rails'
gem 'cancan'
gem 'make_voteable'
gem 'mysql2'
gem 'rails_autolink'
gem 'rdiscount'
gem 'delayed_job'
gem 'delayed_job_active_record'