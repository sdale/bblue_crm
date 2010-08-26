# BatchBook API query limit
LIMIT = 300

# Method that executes the download and moves the downloaded file somewhere. 
# Case the file is an 'empty' XML, it gets deleted.
# Case the download is unsuccessful, it tries again 2 more times.
def download_and_move(download_command, move_command, file_name = nil, counter=1)
  return if counter >= 3
  if system(download_command) && system(move_command)
    if file_name && IO.readlines(file_name).size < 5 
      File.delete(file_name)
      false
    else
      true
    end
  else
    sleep 1
    download_and_move(download_command, move_command, file_name, counter+1)
  end 
end

desc 'Backup CRM data'
task :backup => :environment do
  BatchBook::boot
  root_path = "tmp/backup"
  system("mkdir -p #{root_path}")
  
  # Paginates each resource collection according to the LIMIT to make sure all XML files are downloaded.
  %w{ people companies deals todos communications}.each do |temp|
    offset = 0
    system("mkdir -p #{root_path}/#{temp}")
    while true do
      params = "#{temp}.xml?limit=#{LIMIT}'&'offset=#{offset}"
      file_name = "#{root_path}/#{temp}/#{offset}-#{offset+LIMIT}.xml"
      download_command = "wget https://#{BatchBook.account}.batchbook.com/service/#{params} --no-check-certificate --user=#{BatchBook.token} --password="
      move_command = "mv #{Rails.root}/#{params} #{file_name}"
      break unless download_and_move(download_command, move_command, file_name)
      offset += LIMIT
    end
  end
  
  # Since this is a small file, it stays out of the pagination
  system("mkdir -p #{root_path}/super_tags")
  download_command = "wget https://#{BatchBook.account}.batchbook.com/service/super_tags.xml?limit=#{LIMIT} --no-check-certificate --user=#{BatchBook.token} --password="
  move_command = "mv #{Rails.root}/super_tags.xml?limit=#{LIMIT} #{root_path}/super_tags/super_tags.xml"
  download_and_move(download_command, move_command)   
  
  # Gets all contacts and downloads their specific supertag values
  contacts = Person.all(:disable_caching => true) | Company.all(:disable_caching => true)
  contacts.each do |contact|
    type = contact.type.pluralize
    id = contact.attributes['id']
    unless contact.supertags.blank?
      params = "super_tags.xml?limit=#{LIMIT}"
      download_command = "wget https://#{BatchBook.account}.batchbook.com/service/#{type}/#{id}/#{params} --no-check-certificate --user=#{BatchBook.token} --password="
      move_command = "mv #{Rails.root}/#{params} #{root_path}/super_tags/#{id}.xml"
      download_and_move(download_command, move_command)
    end
  end
  
  # Zips everything into a single file and moves it to some path provided at the console.
  zip_path = "tmp/BB_CRM_backup_#{Time.now.strftime("%m%d%y")}"
  system("zip #{zip_path} -r #{root_path}")
  system("rm -r #{root_path}")
  if ENV['path']
    unless system("mv #{zip_path}.zip #{ENV['path']}")
      puts "Unable to move #{zip_path}.zip to #{ENV['path']}. Please check system permissions and make sure the target path exists."
    end
  end
end