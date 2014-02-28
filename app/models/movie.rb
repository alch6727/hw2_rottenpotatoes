class Movie < ActiveRecord::Base
	def self.all_ratings
		#Obtains all the movies using rating and pushes them on an array
		array = Array.new
		self.select("rating").uniq.each {|e1| array.push(e1.rating)}

		#Returns the sorted array
		array.sort.uniq
	end
end
