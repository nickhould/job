class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :url
      t.string :business
      t.datetime :published_at

      t.timestamps
    end
  end
end
