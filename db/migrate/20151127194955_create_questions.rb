class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content,   null: false, limit: 255
      t.string :answer,                 limit: 255
      t.integer :topic_id, null: false

      t.timestamps null: false
    end
  end
end
