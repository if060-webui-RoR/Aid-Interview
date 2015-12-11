class CreateQuestionsTemplates < ActiveRecord::Migration
  def change
    create_table :questions_templates do |t|
      t.references :template, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
