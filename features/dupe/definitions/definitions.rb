# set this to false if you don't care to see the requests mocked 
# for each cucumber scenario.
Dupe.debug = true
Dupe.debug = false


# Define your models
# Dupe.define :example_model do |attrs|
#   attrs.example_attribute 'Example Default Value'
# end

#when using person, it bugs
Dupe.define :human do |human|
  human.first_name {Dupe.next :name}
  human.last_name 'Doe'
  human.title
  human.notes
  human.company
  human.created_at Time.now
  human.locations do 
    Dupe.create :location
  end
  human.tags do 
    Dupe.create :tag
  end
end

Dupe.define :company do |company|
  company.uniquify :name
  company.notes 
  company.created_at Time.now
  company.locations do 
    Dupe.create :location
  end
  company.tags do
    Dupe.create :tag
  end
end

Dupe.define :location do |location|
  location.uniquify :label
end

Dupe.define :tag do |tag|
  tag.name
  tag.data
end

Dupe.define :todo do |todo|
  todo.uniquify :title
  todo.description
  todo.due_date 2.months.from_now
  todo.assigned_to
  todo.assigned_by
end

Dupe.define :deal do |deal|
  deal.uniquify :title
  deal.description
  deal.deal_with
  deal.amount rand(1000).to_s
  deal.status { rand(1) == 0 ? 'lost' : '100%' }
  deal.assigned_to do
    number = rand(5)
    case number
      when 0
        "Administrator"
      when 1
        "user11@example.com"
      when 2
        "user12@example.com"
      else
        "user13@example.com"
    end
  end
end

Dupe.sequence :name do |n|
  "John #{n}"
end