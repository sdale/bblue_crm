#This task does not work. It has not been tested yet and the database does not currently support it.
#I will code this as soon as the 404 error that BatchBlue returns when accessing the Activities class is fixed
desc 'Logs recent activities into the database'
task :log_activities_new => :environment do
  
  page = 1
  while true
    recent = Activities.recent(page)
    page+=1
    unless recent.blank?
      recent.each do |item|
        unless Log.find(:first, :conditions => {:name => item.name, :date => item.date})
          Log.create! :name => item.name, 
                      :description => item.description, 
                      :record_type => item.record_type,
                      :record_id => item.record_id,
                      :user_name => item.user_name,
                      :user_id => item.user_id,
                      :date => item.date
          puts "Entry '#{item.name}' has been logged."
        else
          puts "Entry '#{item.name}' is already logged. Exiting..."
          exit
        end
      end
    else
      break
    end
  end
end