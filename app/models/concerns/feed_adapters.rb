module FeedAdapters
  # Contains adapters for the different job feeds. 

  def feed_adapter(entry, feed)  
  new_job_from_espresso(entry, feed) if feed.name == "Espresso Jobs"
  new_job_from_infopresse(entry, feed) if feed.name == "Infopresse Jobs"
  new_job_from_isarta(entry, feed) if feed.name == "Isarta"
  end

  def new_job_from_espresso(entry, feed)
    if entry.author != "Espresso-Jobs"
      job = { title:        entry.title,
              business:     entry.author,
              url:          entry.id,
              published_at: entry.published,
              guid:         entry.id,
              feed_id:      feed.id }
    end
  end
  def new_job_from_infopresse(entry, feed)
    summary = Nokogiri::HTML(entry.summary)
    business_name = summary.css('a').first.text
    job = { title:        entry.title,
            url:          entry.url,
            published_at: entry.published,
            guid:         entry.id,
            feed_id:      feed.id,
            business:     business_name}
  end

  def new_job_from_isarta(entry, feed)
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