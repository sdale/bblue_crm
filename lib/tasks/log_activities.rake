desc 'Parses a recent activity RSS feed and logs it in the database'
task :log_activities => :environment do
  require 'open-uri'
  require 'openssl'
  
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  page = 1
  while true
    rss = SimpleRSS.parse open(ENV['feed_url']+"?page=#{page}")
    page+=1
    unless rss.items.blank?
      rss.items.each do |item|
        id = item[:id].gsub(/.*\//,'')
        content = item.content.match(/&gt;.*&lt;/).to_s.gsub(/&gt;|&lt;/, '')
        unless Log.find_by_entry_id(id)
          Log.create! :entry_id => id, :published => item[:published], :title => item[:title], :content => content, :updated => item[:updated], :author => item[:author]
          puts "Entry #{id} has been logged."
        else
          puts "Entry #{id} is already logged. Exiting..."
          exit
        end
      end
    else
      break
    end
  end
end