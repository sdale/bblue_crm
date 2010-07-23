desc 'Logs recent activities into the database'
task :log_activities => :environment do
  require 'digest/sha1'
  page, logged = 1, 0
  while true
    exit if logged > 100
    recent = Activity.recent(page)
    page+=1
    unless recent.blank?
      recent.each do |item|
        secret = Digest::SHA1.hexdigest("--#{item.attributes.map{|key,val| val.to_s+"---"}}--")
        unless Log.find_by_secret(secret)
          Log.create! :name => item.name, 
                      :description => item.description, 
                      :record_type => item.record_type,
                      :record_id => item.record_id,
                      :user_name => item.user_name,
                      :user_id => item.user_id,
                      :date => item.date,
                      :secret => secret
          puts "Entry '#{item.name}' has been logged."
        else
          puts "Entry '#{item.name}' is already logged."
          logged+=1
        end
      end
    else
     break
    end
  end
end