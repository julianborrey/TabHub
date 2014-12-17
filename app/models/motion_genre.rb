class MotionGenre < ActiveRecord::Base

	#generates a hash of selectable genres for a motion
	def self.possible_genres_for_select_tag
		hash = {"all genres" => 0}; #add "all generes"
		GlobalConstants::MOTION_GENRE.each{ |key,value| 
			hash[key.to_s.titleize] = value;
		}
		return hash;
	end

end
