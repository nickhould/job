class AddFeedIdToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :feed_id, :integer
  end
end
