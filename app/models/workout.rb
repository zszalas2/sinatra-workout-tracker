class Workout < ActiveRecord::Base
	belongs_to :user
	has_many :exercises

	#def slug
		
    	#self.name.parameterize
  	#end

	#def self.find_by_slug(slug)
		#Workout.all.find do |workout|
			#workout.slug == slug
		#end
	#end
end