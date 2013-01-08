class JobBuilder
  # Enables models (Job & JobFeed) to format the Hash correctly before creation
  @job_supported_keys = [:title, :business, :published_at]
  @job_feed_supported_keys = [:title, :business, :published_at, :guid, :feed_id, :url]

  def self.build(job, supported_keys=[])
    formatted_job = {}
    supported_keys.each do |supported_key|
      job.each {|key, value| formatted_job[key] = value if supported_key == key }
    end
    formatted_job
  end

  def self.build_job(job)
    build(job, @job_supported_keys)
  end

  def self.build_job_feed(job)
    build(job, @job_feed_supported_keys)
  end
end
