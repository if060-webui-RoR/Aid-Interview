class CreateQuestionstemplates < ActiveRecord::Migration
  def change
    create_table :questionstemplates do |t|
      t.references :template, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
