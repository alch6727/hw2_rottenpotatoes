class Movie < ActiveRecord::Base
	def self.all_ratings
		array = Array.new
		self.select("rating").uniq.each {|e1| array.push(e1.rating)}
		array.sort.uniq
	end
end
