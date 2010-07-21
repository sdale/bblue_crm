class Comment < Base

  def communication
    Communication.find(self.prefix_options[:communication_id])
  end

  def communication=(communication)
    self.prefix_options[:communication_id] = communication.id
  end
  
  def company
    Company.find(self.prefix_options[:company_id])
  end
  
  def company=(company)
    self.prefix_options[:company_id] = company.id
  end
  
  def deal
    Deal.find(self.prefix_options[:deal_id])
  end
  
  def deal=(deal)
    self.prefix_options[:deal_id] = deal.id
  end
      
  def list
    List.find(self.prefix_options[:list_id])
  end

  def list=(list)
    self.prefix_options[:list_id] = list.id
  end
  
  def person
    Person.find(self.prefix_options[:person_id])
  end

  def person=(person)
    self.prefix_options[:person_id] = person.id
  end

  def todo
    Todo.find(self.prefix_options[:todo_id])
  end

  def todo=(todo)
    self.prefix_options[:todo_id] = todo.id
  end
  
end