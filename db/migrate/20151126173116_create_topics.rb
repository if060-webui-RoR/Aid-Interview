class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title, null: false, limit: 255

      t.timestamps null: false
    end
  end
end
