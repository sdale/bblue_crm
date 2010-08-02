#This is an extremely customized blacklist, please use BlackListBuilder for a more general approach.

class ContactListBuilder
  BatchBook::boot
  def initialize(path)          
    @path = path
    @contact_list = ContactList.new
    @white_list = []
    @tags_required = ['lead', 'customer' ]
    @tags_allowed = ['ucemployee']
    @supertags_required = ['ownership', 'source']
    @collection = Person.all(:disable_caching => true) | Company.all(:disable_caching => true)
  end
  
  def generate_report
    @white_list.each {|allowed_item| @contact_list.items.delete_if{|i| i.record == allowed_item}}
    @contact_list.assign_tags
    File.open("#{@path}/contacts.html", "w") do |file|
      file << "<style>body,th,td{text-align:center}table{width:50%;margin-left:350px;border:2px solid}.lb{border-left:2px solid}</style><html><body>"
      User.all.each do |user|
        file << self.generate_table("Salesperson: #{user.name}", @contact_list.items.find_all{|item| item.ownership == user.email})
      end
      file << self.generate_table("Unassigned", @contact_list.items.find_all{|item| item.ownership.blank?})
      file << "</body></html>"
    end
  end
  
  def check_tags
    @collection.each do |item|
      puts "\nStarting TAG check on #{item.name}..."
      attr = item.attributes['tags']
      tags = attr.blank? ? [] : attr.attributes['tag'].to_a.map{|tag|tag.name}
      @white_list << item unless (tags & @tags_allowed).blank? 
      result = tags & @tags_required
      if result.blank? || result == @tags_required || result == @tags_required.reverse
        contact = @contact_list.add item
        puts "...#{item.name} failed TAGS check."
      else
        puts "...#{item.name} passed the TAGS check!"
      end
    end
  end
  
  def check_supertags
    @collection.each do |item|
      puts "\nStarting SUPERTAG check on #{item.name}..."
      attr = item.attributes['tags']
      tags = attr.blank? ? [] : attr.attributes['tag'].to_a.map{|tag|tag.name.to_s}
      result = @supertags_required & tags
      if result.blank?
        puts "#{item.name} doesn't have a single SUPERTAG!"
        puts "...#{item.name} failed the SUPERTAGS check."
        @contact_list.add item
        next
      end
      supertags = item.supertags
      ownership = supertags.find{|e| e['name'] == 'ownership'}
      source = supertags.find{|e| e['name'] == 'source'}
      if ownership.blank? || ownership['fields'].blank? || source.blank? || source['fields'].blank? 
        contact = @contact_list.add item
      else
        contact = @contact_list.find item
      end
      unless contact.nil?
        unless ownership.blank?
          contact.ownership = ownership['fields']['owner'] 
          puts "Assining ownership to: #{contact.ownership || 'unassigned'}"
        end
        unless source.blank?
          contact.source = source['fields']['source'] 
          puts "Assining source to: #{contact.source || 'unassigned'}"
        end
        contact.has_source = true unless source.nil?
      end
    end
  end
  
  def generate_table(title, collection)
    string = %Q{
      #{title}
      <table>
    <tr><th>Record</th><th>L</th><th>C</th><th>S</th><th>SV</th></tr>
    }
    collection.each do |item|
      string << %Q{
     <tr>
      <td><a href='https://#{BatchBook.account}.batchbook.com/contacts/show/#{item.record.id}'>#{item.record.name}</a></td>
      <td class="lb"><input type="checkbox" #{item.lead? ? "checked" : ""} disabled/></td><td><input type="checkbox" #{item.customer? ? "checked" : ""} disabled/></td>
      <td class="lb"><input type="checkbox" #{item.has_source? ? "checked" : ""} disabled/></td><td><input type="checkbox" #{item.source? ? "checked" : ""} disabled/></td>
      </tr>
        }
    end
      string << "</table>"
      string
   end
  
end