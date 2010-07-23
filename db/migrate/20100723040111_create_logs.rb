class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :name, :null => false
      t.string :description
      t.datetime :date, :null => false
      t.string :user_name
      t.integer :user_id
      t.string :record_type
      t.integer :record_id
      t.string :secret
    end
  end

  def self.down
    drop_table :logs
  end
end
