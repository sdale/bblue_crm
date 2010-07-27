desc "Checks the integrity of all BatchBook data and outputs a file with all the data that doesn't match"
task :integrity_check => :environment do
  require "#{Rails.root}/lib/tasks/black_list.rb"
  root_path = "#{Rails.root}/tmp/integrity_check"
  system("mkdir -p #{root_path}")

  deals = BlackList.new :deals, root_path
  contacts = BlackList.new :contacts, root_path
  
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
  
end