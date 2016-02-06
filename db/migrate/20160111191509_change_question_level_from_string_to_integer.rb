class ChangeQuestionLevelFromStringToInteger < ActiveRecord::Migration
  def change
    change_column :questions, :level, :integer
  end
end
