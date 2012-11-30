# Seed the Feeds

Feed.destroy_all
feeds = [{name: "Infopresse Jobs",
					url: "https://www3.infopresse.com/jobs/rss/"},

				 {name: "Espresso Jobs",
				 	url: "http://feeds.feedburner.com/espressojobs"},

				 {name: "Isarta",
				 	url: "http://emplois.isarta.com/jobs/rss/emplois.shtml"}]

Feed.create feeds
puts "#{Feed.count} feed(s) created."