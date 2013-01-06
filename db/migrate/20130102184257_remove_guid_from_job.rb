class RemoveGuidFromJob < ActiveRecord::Migration
  def up
    remove_column :jobs, :guid
  end

  def down
    add_column :jobs, :guid, :string
  end
end
