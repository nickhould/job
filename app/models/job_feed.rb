class JobFeed < ActiveRecord::Base
  attr_accessible :feed_id, :guid, :job_id, :published_at, :url
  validates_presence_of :feed_id, :guid, :job_id, :published_at, :url
  
  before_save do |job_feed| 
    job_feed.guid = UnicodeUtils.downcase(guid)
    job_feed.url  = UnicodeUtils.downcase(url)
  end

  validates :guid, uniqueness: true

  belongs_to :job
  belongs_to :feed
  
  def self.create_from_feed(job)
    unless exists? :guid => job.guid.to_s
      create(job)
    end    
  end
end


# find or create the job
# create an JobFeed unless it exists
  