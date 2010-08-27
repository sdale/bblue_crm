namespace :utilities do
  
  namespace :db do
    
    desc "Backup, compress and store production db"
    task :backup do
      now = Time.now
      run "cd /"
      run "cd /data/bblue_crm/current; mysqldump -u root -p bblue_crm_production > /data/bblue_crm/current/tmp/bblue_crm_production.sql"
      run "tar czf /data/z_drive_backup/recent_activities_log/bblue_crm_production_#{now.strftime('%Y%m%d')}.tar.gz /data/bblue_crm/current/tmp/bblue_crm_production.sql"
      run "rm /data/bblue_crm/current/tmp/bblue_crm_production.sql"
      puts "Backup complete for #{now}\n"
    end
    
  end

end