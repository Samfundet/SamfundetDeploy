env :GEM_PATH => gem_paths[:gem_path],
    :GEM_HOME => gem_paths[:gem_home],
    :PATH => "#{ENV['PATH']}:#{gem_paths[:gem_bin]}"

task_group :git_status, :hidden => true do
  task "Ensuring empty git status" do
    empty_git_status = <<-MSG.gsub(/^\s+/, '')
      # On branch master
      nothing to commit (working directory clean)
    MSG

    raise "Repository is not clean." unless `git status` == empty_git_status
  end
end

task_group :pull do
  description "Pull recent changes from Git remote"

  task "Pull recent changes from repository" do
    command "git pull"
  end
end

task_group :install_gems do
  description "Install gems using Bundler"

  task "Installing new gems" do
    command "bundle install --path vendor/"
  end
end

task_group :compile_assets do
  description "Compile all assets"

  task "Compiling assets" do
    command "bundle exec rake assets:precompile"
  end
end

task_group :migrate_database do
  description "Migrate the database"

  task "Migrating the database" do
    command "bundle exec rake db:migrate RAILS_ENV=production"
  end
end

task_group :update_everything do
  description "All of the above"

  invoke_group :git_status
  invoke_group :pull
  invoke_group :install_gems
  invoke_group :compile_assets
  invoke_group :migrate_database
end
