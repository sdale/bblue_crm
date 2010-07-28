def download_and_move(download_command, move_command, counter=1)
  return if counter >= 3
  unless system(download_command)  && system(move_command)
    sleep 1
    download_and_move(download_command, move_command, counter+1)
  end 
end

desc 'Backup CRM data'
task :backup => :environment do
  BatchBook::boot
  root_path = "#{Rails.root}/tmp/backup"
  puts "root: #{root_path}"
  system("mkdir -p #{root_path}")
  system("mkdir -p #{root_path}/supertags")
  %w{ people companies deals todos communications super_tags}.each do |temp|
    download_command = "wget https://#{BatchBook.account}.batchbook.com/service/#{temp}.xml?limit=1000000 --no-check-certificate --user=#{BatchBook.token} --password="
    move_command = "mv #{Rails.root}/#{temp}.xml?limit=1000000 #{root_path}/#{temp}.xml"
    download_and_move(download_command, move_command)
  end
  contacts = Person.find(:all) | Company.find(:all)
  contacts.each do |contact|
    type = contact.type.pluralize
    id = contact.attributes['id']
    unless contact.supertags.blank?
      download_command = "wget https://#{BatchBook.account}.batchbook.com/service/#{type}/#{id}/super_tags.xml?limit=1000000 --no-check-certificate --user=#{BatchBook.token} --password="
      move_command = "mv #{Rails.root}/super_tags.xml?limit=1000000 #{root_path}/supertags/#{id}.xml"
      download_and_move(download_command, move_command)
    end
  end
  zip_path = "tmp/BB_CRM_backup_#{Time.now.strftime("%m%d%y")}"
  system("zip #{zip_path} -r #{root_path}")
  system("rm -r #{root_path}")
  system("mv #{zip_path}.zip #{ENV['path']}") if ENV['path']
end