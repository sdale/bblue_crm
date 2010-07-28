def download_and_move(download_command, move_command)
  counter = 0
  begin
    counter +=1
    system(download_command) 
    system(move_command)
  rescue
    sleep 1
    retry unless counter >= 3
  end 
end

desc 'Backup CRM data'
task :backup => :environment do
  BatchBook::boot
  root_path = "#{Rails.root}/tmp/backup"
  now = Time.now
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
  system("zip tmp/BB_CRM_backup_#{Time.now.strftime("%m%d%y")} -r #{ENV['path'] || root_path}")
  system("rm -r #{root_path}")
end