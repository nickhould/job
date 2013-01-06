module JobBuilders
  def builder(job)
    formatted_job = {}
    supported_keys.each do |supported_key|
      job.each {|key, value| formatted_job[key] = value if supported_key == key }
    end
    formatted_job
  end

  def supported_keys
    [:title, :business, :published_at, :guid, :feed_id, :url] if self.to_s == "JobFeed"
    [:title, :business, :published_at] if self.to_s == "Job" 
  end
end