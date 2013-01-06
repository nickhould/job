class Feed < ActiveRecord::Base
  attr_accessible :name, :url
  has_many :job_feeds

end
