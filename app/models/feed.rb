class Feed < ActiveRecord::Base
  attr_accessible :name, :url
  has_many :jobs

  def self.update_all_jobs
  	self.each do |feed|
    	current_feed = Feedzirra::Feed.fetch_and_parse(feed.url)
    	add_entries(current_feed.entries)
    end
  end

  def entries(arr)
  	"#{arr}"
  end

end
