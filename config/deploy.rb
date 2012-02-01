require "bundler/capistrano"

set :application, "hackful"
set :domain,      "hackful.com"
set :repository,  "git://github.com/8bitpal/hackful.git"
set :use_sudo,    false
#set :deploy_to,   "/u/apps/#{application}"
set :scm,         "git"

role :app, "hackful.com"
role :web, "hackful.com"
role :db,  "hackful.com", :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
