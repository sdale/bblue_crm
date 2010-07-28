desc "Checks the integrity of all BatchBook data and outputs a file with all the data that doesn't match"
task :integrity_check => :environment do
  dirname = File.join(File.dirname( __FILE__ ), 'integrity_check')
  Dir.entries( dirname ).each do |f|
    if f =~ /\.rb$/
      require( File.join(dirname, f) )
    end
  end
  root_path = ENV['path'] || "#{Rails.root}/tmp/integrity_check"
  system("mkdir -p #{root_path}")

  deals = BlackListBuilder.new :deals, root_path
  contacts = BlackListBuilder.new :contacts, root_path
  
  puts "Checking tags..."
  
  contacts.check_tags
  
  puts "Finished checking tags..."
  
  puts "Checking supertags..."
  
  contacts.check_supertags
  
  puts "Finished checking supertags..."
  
  puts "Checking to-tos..."
  
  deals.check_todos
    
  puts "Finished checking to-dos."
  
  puts "Generating report..."
  [deals, contacts].each{|var| var.generate_report }
  
  system("zip tmp/BB_CRM_integrity_check_#{Time.now.strftime("%m%d%y")} -r #{ENV['path'] || root_path}")
  system("rm -r #{root_path}")
end