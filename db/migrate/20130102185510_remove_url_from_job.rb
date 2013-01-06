class RemoveUrlFromJob < ActiveRecord::Migration
  def up
    remove_column :jobs, :url
  end

  def down
    add_column :jobs, :url, :string
  end
end
