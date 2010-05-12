class Person < ActiveRecord::BaseWithoutTable
    column :first_name, :string
    column :last_name, :string
    column :title, :string
    column :company, :string
    column :notes, :text
    column :created_at, :datetime
    column :updated_at, :datetime

    has_many :locations

    validates_presence_of :first_name, :last_name
end
