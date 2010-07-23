class BlackList
  
  BatchBook::boot
 
  TAGS_REQUIRED = {:contacts => ['lead', 'customer'], 
                   :deals => ['dealinfo']
                   }
  TAGS_ALLOWED = {:contacts => ['ucemployee'], 
                  :deals => []
                  }
  SUPERTAGS_REQUIRED = {:contacts => ['ownership', 'source'], 
                        :deals => []
                        }
                        
  attr_reader :type, :invalid
  
  def initialize(type, path)
    @type = type           
    @path = path
    @invalid = []
    @collection = case @type
      when :contacts
        Person.find(:all) | Company.find(:all)
      when :deals
        Deal.find(:all)
      when :todos
        Todo.find(:all)
      when :communications
        Communication.find(:all)
      else
        []
    end
  end
  
  def generate_report
    @invalid.uniq!
    File.open("#{@path}/#{@type.to_s}.html", "w") do |file|
      file << "<html><body style='text-align:center'><h1>Report on Integrity Check for #{@type.to_s.titleize}</h1>"
      file << "<h2>Created at #{Time.now}</h2>"
      file << "<h3>Total number of records: #{@collection.size}</h3>"
      file << "<h3>Total number of failing records: #{@invalid.size}</h3>"
      @invalid.each do |invalid_item|
        file << "<a href='https://#{BatchBook.account}.batchbook.com/#{@type.to_s}/show/#{invalid_item.id}'>#{invalid_item.name}</a><br/><br/>"
      end
      file << "</body></html>"
    end
  end
  
  def check_tags
    @collection.each do |item|
      attr = item.attributes['tags']
      tags = attr.blank? ? nil : attr.attributes.delete("tag").to_a.map{|tag|tag.name}
      next unless (tags & TAGS_ALLOWED[@type]).blank?
      @invalid << item if (tags & TAGS_REQUIRED[@type]).blank?
    end
  end
  
  def check_supertags
    @collection.each do |item|
      supertags = item.supertags
      unless supertags.nil?
        SUPERTAGS_REQUIRED[@type].each do |supertag|
          temp = supertags.find{|e| e['name'] == supertag}
          if temp.blank? || temp['fields'].blank?
            @invalid << item
            break
          end
        end
      end 
    end
  end
  
  def check_todos
    todos = Todo.find(:all) || []
    @collection.each do |item|
      @invalid << item unless todos.find{|todo| todo.title == item.title}
    end
  end
end