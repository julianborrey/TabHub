class TournamentSetting < ActiveRecord::Base
   belongs_to(:tournament);

   #returns a hash of the settings
   def to_paired_array
      #little JSON trick to get a hash of our object
      hash = JSON.parse(Tournament.find(8).tournament_setting.to_json, {symbolize_names: true});
      
      #remove the values we don't want (remenants of database)
      hash.reject! { |key, val| key == :id };
      hash.reject! { |key, val| key == :tournament_id };
      hash.reject! { |key, val| key == :created_at };
      hash.reject! { |key, val| key == :updated_at };
      hash.reject! { |key, val| key == :format }; ##this is temp
      
      #make array and return
      arr  = hash.map { |key,val| [key, val] };
      return arr;
   end
end
