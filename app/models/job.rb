# encoding: utf-8

class Job < ActiveRecord::Base
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
  
  private

  def self.create_jobs_from_feed(entries, feed)
    entries.each do |entry|
      job = feed_adapter(entry, feed)
      job = find_by_title_and_business(job[:title], job[:business]) || create(builder(job))
      job.job_feeds.create_from_feed(job) unless job
    end
  end

  def self.builder(job)
    formatted_job = {}
    supported_keys.each do |supported_key|
      job.each {|key, value| formatted_job[key] = value if supported_key == key }
    end
    formatted_job
  end

  def self.supported_keys
    [:title, :business, :published_at, :guid, :feed_id, :url] if self.to_s == "JobFeed"
    [:title, :business, :published_at] if self.to_s == "Job" 
  end

  def self.feed_adapter(entry, feed)	
  	new_job_from_espresso(entry, feed) if feed.name == "Espresso Jobs"
    new_job_from_infopresse(entry, feed) if feed.name == "Infopresse Jobs"
    new_job_from_isarta(entry, feed) if feed.name == "Isarta"
  end

  def self.new_job_from_espresso(entry, feed)
    if entry.author != "Espresso-Jobs"
      job = { title:        entry.title,
              business:     entry.author,
              url:          entry.id,
              published_at: entry.published,
              guid:         entry.id,
              feed_id:      feed.id }
    end
  end
  def self.new_job_from_infopresse(entry, feed)
		summary = Nokogiri::HTML(entry.summary)
  	business_name = summary.css('a').first.text
   	job = { title: 			  entry.title,
        		url:   			  entry.url,
       			published_at: entry.published,
        		guid:         entry.id,
        		feed_id:      feed.id,
        		business:     business_name}
  end

  def self.new_job_from_isarta(entry, feed)
    full_string = entry.title
    full_string =~  %r{(.*)\|(.*)\|(.*)}
    title = full_string[$1]
    business = full_string[$2]
    
    summary = entry.summary
    if summary =~ %r{le:\s*(\d{2})\/(\d{2})\/(\d{4})}
      day = summary[$1] 
      month = summary[$2]
      year = summary[$3]
      published_at =  year + "-" + month + "-" + day
    else 
      published_at = nil
    end
    job = { title:        title,
            url:          entry.url,
            published_at: published_at,
            guid:         entry.id,
            feed_id:      feed.id,
            business:     business.downcase }
  end
end



