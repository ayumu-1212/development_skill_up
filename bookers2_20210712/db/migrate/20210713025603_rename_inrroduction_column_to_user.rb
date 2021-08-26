class RenameInrroductionColumnToUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :inrroduction, :introduction
  end
end
