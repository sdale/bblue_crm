namespace :utilities do
  
  namespace :db do
    
    desc "Backup, compress and store production db"
    task :backup do
      now = Time.now
      system "cd /"
      system "cd /data/bblue_crm/current"
      system "mysqldump -u root -h localhost bblue_crm_production > /data/bblue_crm/current/tmp/bblue_crm_production.sql"
      system "tar czf /data/z_drive_backup/recent_activities_log/bblue_crm_production_#{now.strftime('%Y%m%d')}.tar.gz /data/bblue_crm/current/tmp/bblue_crm_production.sql"
      system "rm /data/bblue_crm/current/tmp/bblue_crm_production.sql"
      puts "Backup complete on #{now}\n"
    end
    
  end

end
