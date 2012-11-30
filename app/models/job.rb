# encoding: utf-8

class Job < ActiveRecord::Base
  attr_accessible :business, :published_at, :title, :url, :guid, :feed_id
  belongs_to :feed

  def self.update_from_feeds
  	Feed.all.each do |feed|
    	rss_feed = Feedzirra::Feed.fetch_and_parse(feed.url)
    	add_entries(rss_feed.entries, feed)
    end
  end
  
  
  private

  def self.feed_adapter(entry, feed)  	
  	if feed.name == "Espresso Jobs"
			job = { title:        entry.title,
							business:     entry.author,
          	 	url:          entry.id,
          	  published_at: entry.published,
              guid:    		  entry.id,
              feed_id:      feed.id }
      return job

    elsif feed.name == "Infopresse Jobs"
    	job = new_job_from_infopresse(entry, feed)  
    elsif feed.name == "Isarta"
      job = new_job_from_isarta(entry, feed)  
  	end	
  end

  def self.add_entries(entries, feed)
    entries.each do |entry|
      unless exists? :guid => entry.id
        create!(feed_adapter(entry, feed))
      end
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



