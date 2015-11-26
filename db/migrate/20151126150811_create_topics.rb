class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.string :questions

      t.timestamps null: false
    end
  end
end
