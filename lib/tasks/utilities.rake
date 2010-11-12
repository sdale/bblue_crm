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
  
  namespace :misc do
  
    desc "Run different versions of Integrity check"
    task :backup_integrity_reports do
      now = Time.now
      
      puts "Running integrity check with sources"
      system "cd /"
      system "cd /data/bblue_crm/current"
      system "rake integrity_check hide_sources=0 path=/data/z_drive_integrity_check --trace RAILS_ENV=production"
      system "mv /data/z_drive_integrity_check/BB_CRM_integrity_check_#{now.strftime('%m%d%y')}.zip /data/z_drive_integrity_check/BB_CRM_integrity_check_source_#{now.strftime('%m%d%y')}.zip"
      system "unzip -d /data/z_drive_sales_crm /data/z_drive_integrity_check/BB_CRM_integrity_check_source_#{now.strftime('%m%d%y')}.zip"
      system "cd /data/z_drive_sales_crm/tmp/integrity_check"
      system "mv contacts.html /data/z_drive_sales_crm/integrity_report_source_#{now.strftime('%m%d%y')}.html"
      system "rm -r /data/z_drive_sales_crm/tmp/"

      puts "Running integrity check without sources"
      system "cd /"
      system "cd /data/bblue_crm/current"
      system "rake integrity_check hide_sources=1 path=/data/z_drive_integrity_check --trace RAILS_ENV=production"
      system "mv /data/z_drive_integrity_check/BB_CRM_integrity_check_#{now.strftime('%m%d%y')}.zip /data/z_drive_integrity_check/BB_CRM_integrity_check_no_source_#{now.strftime('%m%d%y')}.zip"
      system "unzip -d /data/z_drive_sales_crm /data/z_drive_integrity_check/BB_CRM_integrity_check_no_source_#{now.strftime('%m%d%y')}.zip"
      system "cd /data/z_drive_sales_crm/tmp/integrity_check"
      system "mv contacts.html /data/z_drive_sales_crm/integrity_report_no_source_#{now.strftime('%m%d%y')}.html"
      system "rm -r /data/z_drive_sales_crm/tmp/"
    end
  
  end

end
