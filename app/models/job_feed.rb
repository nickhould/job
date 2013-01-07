class JobFeed < ActiveRecord::Base
  extend JobBuilders

  attr_accessible :feed_id, :guid, :job_id, :published_at, :url
  validates_presence_of :feed_id, :guid, :job_id, :published_at, :url
  
  before_save do |job_feed| 
    job_feed.guid = UnicodeUtils.downcase(guid)
    job_feed.url  = UnicodeUtils.downcase(url)
  end

  validates :guid, uniqueness: { case_sensitive: false }

  belongs_to :job
  belongs_to :feed
  
  def self.create_from_feed(job)
    unless exists? :guid => job.guid.to_s
      create(builder(job))
    end    
  end
end
