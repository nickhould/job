class RemoveFeedIdFromJob < ActiveRecord::Migration
  def up
    remove_column :jobs, :feed_id
  end

  def down
    add_column :jobs, :feed_id, :integer
  end
end
