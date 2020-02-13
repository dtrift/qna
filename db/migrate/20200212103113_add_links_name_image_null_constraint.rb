class AddLinksNameImageNullConstraint < ActiveRecord::Migration[6.0]
  def change
    change_column_null :links, :name, false
    change_column_null :links, :url, false
  end
end
