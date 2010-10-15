desc "Checks the integrity of all BatchBook data and outputs a file with all the data that doesn't match"
task :integrity_check => :environment do
  dirname = File.join(File.dirname( __FILE__ ), 'integrity_check')
  Dir.entries( dirname ).each do |f|
    if f =~ /\.rb$/
      require( File.join(dirname, f) )
    end
  end
  root_path = "tmp/integrity_check"
  system("mkdir -p #{root_path}")

  deals = BlackListBuilder.new :deals, root_path
  contacts = ContactListBuilder.new root_path
  
  puts "Checking tags..."
  
  contacts.check_tags
  
  puts "Finished checking tags..."
  
  puts "Checking supertags..."
  
  contacts.check_supertags
  
  puts "Finished checking supertags..."

  
  puts "Checking to-tos..."
  
  deals.check_todos
    
  puts "Finished checking to-dos."
  
  puts "Checking statuses..."
  
  deals.check_status
    
  puts "Finished checking statuses."
  
  puts "Generating report..."
  
  deals.generate_report
  
  contacts.generate_report
  
#  zip_path = "tmp/BB_CRM_integrity_check_#{Time.now.strftime("%m%d%y")}"
#  system("zip #{zip_path} -r #{root_path}")
#  system("rm -r #{root_path}")
#  if ENV['path']
#    unless system("mv #{zip_path}.zip #{ENV['path']}")
#      puts "Unable to move #{zip_path}.zip to #{ENV['path']}. Please check system permissions and make sure the target path exists."
#    end
#  end
   
end