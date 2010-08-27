set  :application,    "bblue_crm"
set  :repository,     "git@github.com:sdale/bblue_crm.git"
set  :scm,            :git
set  :user,           "vadmin"
set  :password,       "vadmin"
set  :keep_releases,  5
set  :rake,           '/usr/bin/rake'
set  :use_sudo,       true
set  :deploy_to,      "/data/#{application}"
role :app,            "192.168.1.88:22"

default_run_options[:pty]   = true
ssh_options[:paranoid]      = false
ssh_options[:forward_agent] = true

desc "Add config symlinks"
task :custom_symlinks do
  run "rm #{release_path}/config/crm_data_example.yml"
  run "rm #{release_path}/config/database.example.yml"
  run "ln -nfs #{shared_path}/crm_data.yml #{release_path}/config/crm_data.yml"
  run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
end

desc "Recache task"
task :recache do
  run "cd #{release_path}; rake recache --trace RAILS_ENV=production"
end

desc "Fix log"
task :fix_log do
  run "cd #{release_path}; rm log; mkdir log; echo '' > log/production.log"
end

desc "Backup, compress and store production db"
task :backup do
  run "cd #{release_path}; rake utilities:db:backup"
end

after "deploy:update_code", "custom_symlinks"
after "custom_symlinks", "fix_log"
after "fix_log", "recache"