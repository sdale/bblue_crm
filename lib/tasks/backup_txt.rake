desc 'Backup CRM data'
task :backup_txt => :environment do
  BatchBook.account, BatchBook.token, BatchBook.per_page  = 'uc', 'qhlCOlJYht', 1000000
  contacts_file = 'tmp/contacts.txt'
  CONTACT_ATTRIBUTES = ['id', 'name','first_name', 'last_name', 'title', 'company', 'notes', 'created_at', 'updated_at']
  LOCATIONS = ['label', 'primary', 'email', 'website', 'phone', 'cell', 'fax', 'street_1', 'street_2', 'city', 'state', 'postal_code', 'country']
  File.open(contacts_file, 'w') do |file|
    file << "type\t" + CONTACT_ATTRIBUTES.join("\t") + "\t locations{#{LOCATIONS.join(",")}}\t tags{name}\n"
    contacts = BatchBook::Person.find(:all) | BatchBook::Company.find(:all)
    contacts.sort! { |x, y| x.attributes['id'] <=> y.attributes['id']  }
    contacts.each do |contact|
      file << contact.type + "\t"
      locations, tags = contact.locations, contact.tags
      CONTACT_ATTRIBUTES.each {|attr| file << contact.attributes[attr].to_s + "\t"}
      file << locations.map do |location|
        string = "{"
        LOCATIONS.each do |header|
          string << location[header].to_s
          string << ',' unless LOCATIONS.last == header
        end
        string << "}"
      end.join(',')
      file << "\t" + tags.map{|tag| "{#{tag.name}}"}.join(',') + "\n"
    end
  end
end