class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :null => false
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :salt, :null => false
      t.string :password_hash, :null => false
      t.timestamps
    end

    add_index :users, [:login], :unique => true
  end

  def self.down
    drop_table :users
  end
end
