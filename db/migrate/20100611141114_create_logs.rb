class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :entry_id, :null => false
      t.datetime :published, :null => false
      t.string :title, :null => false
      t.string :content, :null => false
      t.date :updated, :null => false
      t.string :author, :null => false
    end
    add_index(:logs, :entry_id)
  end

  def self.down
    drop_table :logs
  end
end
