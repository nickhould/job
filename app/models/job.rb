# encoding: utf-8

class Job < ActiveRecord::Base
  extend FeedAdapters

  attr_accessible :business, :published_at, :title
  has_many :job_feeds

  before_save do |job| 
    job.business = UnicodeUtils.downcase(business)
    job.title = UnicodeUtils.downcase(title)
  end

  validates_presence_of :business, :published_at, :title

  def self.update_from_feeds
  	Feed.all.each do |feed|
    	rss_feed = Feedzirra::Feed.fetch_and_parse(feed.url)
    	create_jobs_from_feed(rss_feed.entries, feed)
    end
  end
  
  def self.create_jobs_from_feed(entries, feed)
    entries.each do |entry|
      job_entry = feed_adapter(entry, feed)
      job = find_job_or_create(job_entry)
      job.job_feeds.create_from_feed(job_entry) unless job
    end
  end

  def self.find_job_or_create(job_entry)
    find_by_title_and_business(job_entry[:title], job_entry[:business]) || create(JobBuilder.build_job(job))
  end
end



