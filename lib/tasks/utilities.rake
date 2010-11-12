namespace :utilities do
  
  namespace :db do
    
    desc "Backup, compress and store production db"
    task :backup do
      now = Time.now
      run "cd /"
      run "cd /data/bblue_crm/current"
      run "mysqldump -u root -p bblue_crm_production > /data/bblue_crm/current/tmp/bblue_crm_production.sql"
      run "cd /data/bblue_crm/current/tmp"
      run "tar czf /data/z_drive_backup/recent_activities_log/bblue_crm_production_#{now.strftime('%Y%m%d')}.tar.gz bblue_crm_production.sql"
      run "rm bblue_crm_production.sql"
      run "cd /data/bblue_crm/current"
      puts "Backup complete on #{now}\n"
    end
    
  end

end
