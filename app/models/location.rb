class Location < ActiveRecord::BaseWithoutTable
    column :label, :string
    column :email, :string
    column :phone, :string

    belongs_to :person
    belongs_to :company

end
