desc "Checks the integrity of all BatchBlue data and outputs a file with all the data that doesn't match"
task :integrity_check => :environment do
  BatchBook.account, BatchBook.token, BatchBook.per_page = ENV['account'], ENV['token'], 100000
  root_path = "#{Rails.root}/tmp/integrity_check"
  system("mkdir -p #{root_path}")
  
  COLLECTIONS = {:contacts => BatchBook::Person.find(:all) | BatchBook::Company.find(:all),
                 :deals => BatchBook::Deal.find(:all)}
  TAGS_REQUIRED = {:contacts => ['lead', 'customer'], :deals => ['dealinfo']}
  TAGS_ALLOWED = {:contacts => ['ucemployee'], :deals => []}
  SUPERTAGS_REQUIRED = {:contacts => ['ownership', 'source'], :deals => []}
  
  [:deals, :contacts].each do |type|
    all = COLLECTIONS[type]
    invalid = []
    all.each do |item|
      attr = item.attributes['tags']
      tags = attr.blank? ? nil : attr.attributes.delete("tag").to_a.map{|tag|tag.name}
      next unless (tags & TAGS_ALLOWED[type]).blank?
      if (tags & TAGS_REQUIRED[type]).blank?
        invalid << item
        next
      end
      unless type.to_s == 'deals' #will remove this when deals starts supporting supertags
        supertags = item.supertags
        unless supertags.nil?
          SUPERTAGS_REQUIRED[type].each do |supertag|
            temp = supertags.find{|e| e['name'] == supertag}
            unless temp.blank?
              if temp['fields'].blank?
                invalid << item
                break
              end
            end
          end
        end 
      end 
    end
    File.open("#{root_path}/#{type.to_s}.html", "w") do |file|
      file << "<html><body style='text-align:center'><h1>Report on Integrity Check for #{type.to_s.titleize}</h1>"
      file << "<h2>Created at #{Time.now}</h2>"
      file << "<h3>Total number of records: #{all.size}</h3>"
      file << "<h3>Total number of failing records: #{invalid.size}</h3>"
      invalid.each do |invalid_item|
        file << "<a href='https://#{ENV['account']}.batchbook.com/#{type.to_s}/show/#{invalid_item.id}'>#{invalid_item.name}</a><br/><br/>"
      end
      file << "</body></html>"
    end
  end
end