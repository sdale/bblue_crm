namespace :utilities do
  
  namespace :db do
    
    desc "Backup, compress and store production db"
    task :backup do
      now = Time.now
      system "mysqldump -u root -p bblue_crm_production > tmp/bblue_crm_production.sql"
      system "tar cvzf /data/z_drive_backup/recent_activities_log/bblue_crm_production_#{now.strftime('%Y%m%d')}.tar.gz tmp/bblue_crm_production.sql"
      system "rm tmp/bblue_crm_production.sql"
      puts "Backup complete for #{now}\n"
    end
    
  end

end