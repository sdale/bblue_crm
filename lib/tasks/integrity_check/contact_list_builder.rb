#This is an extremely customized blacklist, please use BlackListBuilder for a more general approach.

class ContactListBuilder
  BatchBook::boot
  def initialize(path)          
    @path = path
    @white_list = []
    @tags_required = ['lead', 'customer' ]
    @tags_allowed = ['ucemployee']
    @supertags_required = ['ownership', 'source']
    @contact_list = ContactList.new(@tags_required)
    @collection = Person.all(:disable_caching => true) | Company.all(:disable_caching => true)
  end
  
  def generate_report
    @white_list.each {|allowed_item| @contact_list.items.delete_if{|i| i.record == allowed_item}}
    @contact_list.assign_values
    File.open("#{@path}/contacts.html", "w") do |file|
      file << self.css 
      file << "<html><body>"
      User.all.each do |user|
        file << self.generate_table("<div class='who'>#{user.name}</div>", @contact_list.items.find_all{|item| item.ownership == user.email})
      end
      file << self.generate_table("<div class='who'>Unassigned</div>", @contact_list.items.find_all{|item| item.ownership.blank?})
      file << "</body></html>"
    end
  end
  
  def check_tags
    @collection.each do |item|
      puts "\nStarting TAG check on #{item.name}..."
      attr = item.attributes['tags']
      tags = attr.blank? ? [] : attr.map{|a| a.attributes['name'] if a.attributes['supertag'] == 'false'}
      @white_list << item unless (tags & @tags_allowed).blank? 
      result = tags & @tags_required
      if result.blank? || result == @tags_required || result == @tags_required.reverse
        @contact_list.add item
        puts "...#{item.name} failed TAGS check."
      else
        puts "...#{item.name} passed the TAGS check!"
      end
    end
  end
  
  def check_supertags(hide_sources = false)
    @collection.each do |item|
      puts "\nStarting SUPERTAG check on #{item.name}..."
      attr = item.attributes['tags']
      supertags = attr.find_all{|a| a.attributes['supertag'] == 'true'}
      ownership = supertags.find{|e| e.name == 'ownership'}
      source    = supertags.find{|e| e.name == 'source'}
      if ownership.blank? || ownership.fields.blank? || ((source.blank? || source.fields.blank?) && !hide_sources) 
        @contact_list.add item, supertags
        puts "...#{item.name} failed the SUPERTAGS check."
      else
        contact = @contact_list.find item
        contact.supertags = supertags unless contact.nil?
        puts "...#{item.name} passed the SUPERTAGS check!"
      end
    end
  end
  
  def generate_table(title, collection)
    string = %Q{
      #{title}
      <table cellspacing="0" cellpadding="0">
        <tr>
        <th>L</th>
        <th>C</th>
        <th>S</th>
        <th>SV</th>
          <th>Company<br>
              Individual</th>
        </tr>
    }
    collection.each do |item|
      string << %Q{
     <tr>
      <td class="lb"><input type="checkbox" #{item.lead? ? "checked" : ""} /></td><td><input type="checkbox" #{item.customer? ? "checked" : ""} /></td>
      <td class="lb"><input type="checkbox" #{item.has_source? ? "checked" : ""} /></td><td><input type="checkbox" #{item.source? ? "checked" : ""} /></td>
      <td>
        <a href='https://#{BatchBook.account}.batchbook.com/contacts/show/#{item.record.id}' target="_blank">#{item.record.name}</a>
      </td>
    </tr>
        }
    end
      string << "</table>"
      string
  end
  
  def css
    css = "<style>"
    css << %Q@ 
      body        { font-family: verdana, helvetica, sans-serif; }
      a           { text-decoration:none; font-size:12px;} 
      a:hover     { background: #e4e4e4; padding:10px 0 10px 0; font-size:12px; text-decoration:underline;}
      table       { width:500px; border:2px solid #e7eeff; margin:0 0 50px 0}
      table td    { padding:2px 10px 2px 10px;  }
      table th    { padding:10px 10px 10px 10px; text-align:left; color:#838383; background: #e7eeff; margin:0;}
      .lb         { border-left:2px solid #e7eeff; }
      .who        { margin: 10px 20px 0 0; text-align:right; font-weight:bold; color:gray; float:left;width:200px;}
      @
    css << "</style>"
    css  
  end
  
end