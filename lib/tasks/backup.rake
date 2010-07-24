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
  path = File.join( root_path, now.year.to_s, now.month.to_s, now.day.to_s )
  system("mkdir -p #{path}")
  system("mkdir -p #{path}/supertags")
  %w{ people companies deals todos communications super_tags}.each do |temp|
    download_command = "wget https://#{BatchBook.account}.batchbook.com/service/#{temp}.xml?limit=1000000 --no-check-certificate --user=#{BatchBook.token} --password="
    move_command = "mv #{Rails.root}/#{temp}.xml?limit=1000000 #{path}/#{temp}.xml"
    download_and_move(download_command, move_command)
  end
  contacts = Person.find(:all) | Company.find(:all)
  contacts.each do |contact|
    type = contact.type.pluralize
    id = contact.attributes['id']
    unless contact.supertags.blank?
      download_command = "wget https://#{BatchBook.account}.batchbook.com/service/#{type}/#{id}/super_tags.xml?limit=1000000 --no-check-certificate --user=#{BatchBook.token} --password="
      move_command = "mv #{Rails.root}/super_tags.xml?limit=1000000 #{path}/supertags/#{id}.xml"
      download_and_move(download_command, move_command)
    end
  end
  system("zip tmp/BB_CRM_backup_#{now.strftime("%m%d%y")} -r #{path}")
  system("rm -r #{root_path}")
end