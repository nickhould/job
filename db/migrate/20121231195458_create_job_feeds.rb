class CreateJobFeeds < ActiveRecord::Migration
  def change
    create_table :job_feeds do |t|
      t.integer :job_id
      t.integer :feed_id
      t.string :url
      t.string :guid
      t.datetime :published_at

      t.timestamps
    end
  end
end
