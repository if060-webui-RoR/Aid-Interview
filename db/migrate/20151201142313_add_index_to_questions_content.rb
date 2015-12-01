class AddIndexToQuestionsContent < ActiveRecord::Migration
  def change
    add_index :questions, :content, unique: true
  end
end
