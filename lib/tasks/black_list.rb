class BlackList
  
  BatchBook::boot
 
  TAGS_REQUIRED = {:contacts => ['lead', 'customer'], 
                   :deals => []
                   }
  TAGS_ALLOWED = {:contacts => ['ucemployee'], 
                  :deals => []
                  }
  SUPERTAGS_REQUIRED = {:contacts => ['ownership', 'source'], 
                        :deals => ['dealinfo']
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
      file << %Q{
      <style>body,td{text-align:center}table{width:50%;margin-left:350px}</style>
      <html><body><h1>Report on Integrity Check for #{@type.to_s.titleize}</h1>
      <h2>Created at #{Time.now}</h2>
      <h3>Total number of records: #{@collection.size}</h3>
      <h3>Total number of failing records: #{@invalid.size}</h3>
      <h4>Required tags: #{TAGS_REQUIRED[@type].join(',')}</h4>
      <h4>Required supertags: #{SUPERTAGS_REQUIRED[@type].join(',')}</h4>
      <table border=1>
      <tr>
        <th>Record</th>
        <th>Invalidation Reason</th>
      </tr>
      }
      @invalid.each do |invalid_item|
        file << %Q{
        <tr>
          <td><a href='https://#{BatchBook.account}.batchbook.com/#{@type.to_s}/show/#{invalid_item.id}'>#{invalid_item.name}</a></td>
          <td>#{invalid_item.reason}</td>
        </tr>
        }
      end
      file << "</table></body></html>"
    end
  end
  
  def check_tags
    @collection.each do |item|
      attr = item.attributes['tags']
      tags = attr.blank? ? nil : attr.attributes.delete("tag").to_a.map{|tag|tag.name}
      next unless (tags & TAGS_ALLOWED[@type]).blank?
      @invalid << item if (tags & TAGS_REQUIRED[@type]).blank?
      add_reason(item, "Does not have all its required tags.")
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
            add_reason(item, "Does not have all its required supertags.")
            break
          end
        end
      end 
    end
  end
  
  def check_todos
    todos = Todo.find(:all) || []
    @collection.each do |item|
      unless todos.find{|todo| todo.title == item.title}
        @invalid << item 
        add_reason(item, 'Does not have a corresponding To-Do')
      end
    end
  end
  
  private
  
  def add_reason(item, reason)
    item.instance_eval %Q{
      def reason
        '#{reason}'
      end
    }
  end
end