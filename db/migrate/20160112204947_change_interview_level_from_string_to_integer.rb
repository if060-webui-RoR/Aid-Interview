class ChangeInterviewLevelFromStringToInteger < ActiveRecord::Migration
  def change
    change_column :interviews, :target_level, :integer
  end
end
