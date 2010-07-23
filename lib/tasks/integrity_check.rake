desc "Checks the integrity of all BatchBlue data and outputs a file with all the data that doesn't match"
task :integrity_check => :environment do
  require "#{Rails.root}/lib/tasks/black_list.rb"
  root_path = "#{Rails.root}/tmp/integrity_check"
  system("mkdir -p #{root_path}")

  deals = BlackList.new :deals, root_path
  contacts = BlackList.new :contacts, root_path
  
  [deals, contacts].each{|var| var.check_tags }
  
  contacts.check_supertags
  
  deals.check_todos
  [deals, contacts].each{|var| var.generate_report }
  
end