#This is an extremely customized blacklist, please use BlackListBuilder for a more general approach.

class ContactListBuilder
  BatchBook::boot
  def initialize(path)          
    @path = path
    @contact_list = ContactList.new
    @white_list = []
    @tags_required = ['lead', 'customer']
    @tags_allowed = ['ucemployee']
    @supertags_required = ['ownership', 'source']
    @collection = Person.find(:all) | Company.find(:all)
  end
  
  def generate_report
    @white_list.each {|allowed_item| @contact_list.items.delete_if{|i| i.record == allowed_item}}
    File.open("#{@path}/contacts.html", "w") do |file|
      file << "<style>body,th,td{text-align:center}table{width:50%;margin-left:350px;border:2px solid}.lb{border-left:2px solid}</style><html><body>"
      User.all.each do |user|
        file << self.generate_table("Salesperson: #{user.name}", @contact_list.items.find_all{|item| item.ownership == user.email})
      end
      file << self.generate_table("Unassigned", @contact_list.items.find_all{|item| item.ownership.nil?})
      file << "</body></html>"
    end
  end
  
  def check_tags
    @collection.each do |item|
      attr = item.attributes['tags']
      tags = attr.blank? ? nil : attr.attributes['tag'].to_a.map{|tag|tag.name}
      @white_list << item unless (tags & @tags_allowed).blank? 
      result = tags & @tags_required
      if result.blank? || result == @tags_required
        contact = @contact_list.add item 
        contact.tags = true unless result.blank?
      end
    end
  end
  
  def check_supertags
    @collection.each do |item|
      attr = item.attributes['tags']
      tags = attr.blank? ? nil : attr.attributes['tag'].to_a.map{|tag|tag.name.to_s}
      result = @supertags_required & (tags || [])
      if result.blank?
        @contact_list.add item
        next
      end
      supertags = item.supertags
      unless supertags.blank?
        ownership = supertags.find{|e| e['name'] == 'ownership'}
        source = supertags.find{|e| e['name'] == 'source'}
        if ownership.nil? || source.nil?
          contact = @contact_list.add item
          contact.ownership = ownership['fields']['owner'] unless ownership.nil?
          contact.source = ownership['fields']['source'] unless source.nil?
        end
      else
        @contact_list.add item
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
      <td class="lb"><input type="checkbox" #{item.tags? ? "checked" : ""} disabled/></td><td><input type="checkbox" #{item.tags? ? "checked" : ""} disabled/></td>
      <td class="lb"><input type="checkbox" #{item.source? ? "checked" : ""} disabled/></td><td><input type="checkbox" #{item.source? ? "checked" : ""} disabled/></td>
      </tr>
        }
    end
      string << "</table>"
      string
   end
  
end