class Company < ActiveRecord::BaseWithoutTable
    column :name, :string
    column :last_name, :string
    column :notes, :text
    column :created_at, :datetime
    column :updated_at, :datetime

    has_many :locations

    validates_presence_of :name
end
