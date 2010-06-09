desc 'Backup CRM data'
task :backup => :environment do
  token = 'qhlCOlJYht'
  BatchBook.account, BatchBook.token, BatchBook.per_page  = 'uc', token, 1000000
  root_path = "#{Rails.root}/tmp/backup"
  now = Time.now
  path = File.join( root_path, now.year.to_s, now.month.to_s, now.day.to_s )
  system("mkdir -p #{path}")
  system("mkdir -p #{path}/supertags")
  ['people', 'companies', 'deals', 'tasks', 'communications', 'super_tags'].each do |temp|
      system("wget https://uc.batchbook.com/service/#{temp}.xml?limit=1000000 --user=#{token} --password=a")
      system("mv #{Rails.root}/#{temp}.xml?limit=1000000 #{path}/#{temp}.xml")
  end
  contacts = BatchBook::Person.find(:all) | BatchBook::Company.find(:all)
  contacts.each do |contact|
    type = contact.type.pluralize
    id = contact.attributes['id']
    unless contact.supertags.blank?
      system("wget https://uc.batchbook.com/service/#{type}/#{id}/super_tags.xml?limit=1000000 --user=#{token} --password=a")
      system("mv #{Rails.root}/super_tags.xml?limit=1000000 #{path}/supertags/#{id}.xml")
    end
  end
  system("zip tmp/BB_CRM_backup_#{now.strftime("%m%d%y")} -r #{path}")
  system("rm -r #{root_path}")
end