class AddQuestionsTitleBodyNullConstraint < ActiveRecord::Migration[6.0]
  def change
  	change_column_null :questions, :body, false
  	change_column_null :questions, :title, false
  end
end
