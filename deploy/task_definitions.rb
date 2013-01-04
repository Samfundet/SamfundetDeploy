env :GEM_PATH => gem_paths[:gem_path],
    :GEM_HOME => gem_paths[:gem_home],
    :PATH => "#{ENV['PATH']}:#{gem_paths[:gem_bin]}"

task_group :pull do
  description "Pull recent changes from Git remote"

  task "Pull recent changes from repository" do
    invoke_command "git pull"
  end
end

task_group :install_gems do
  description "Install gems using Bundler"

  task "Installing new gems" do
    invoke_command "bundle install --path vendor/"
  end
end

task_group :compile_assets do
  description "Compile all assets"

  task "Compiling assets" do
    invoke_command "bundle exec rake assets:precompile"
  end
end

task_group :migrate_database do
  description "Migrate the database"

  task "Migrating the database" do
    invoke_command "bundle exec rake db:migrate RAILS_ENV=production"
  end
end

task_group :update_everything do
  description "All of the above"

  invoke_group :pull
  invoke_group :install_gems
  invoke_group :compile_assets
  invoke_group :migrate_database
end
