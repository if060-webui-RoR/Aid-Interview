class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|

      t.text :content

      t.text.content null: false
    end
  end
end
