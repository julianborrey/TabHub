# global_constants.rb
# 04/09/2013
# by Julian Borrey
# 
# Constants used in the models.

module GlobalConstants
   
   ### Note: users may have more than one status. ###
   
   #################################################################################
   #############   Make sure these two are 1-1 revesable ###########################
   #the privilidges code                                                         
   PRIVILEGES     = {general: 0, site_admin: 1}.freeze();                        
   PRIVILEGES_STR = PRIVILIGES.invert().freeze(); #swaps all key-value pairs     

   #the roles that people may act in a society, 
   #these previliages will allow for registration ...
   SOCIETY_ROLES = {member: 0, president: 1, externals: 2}.freeze();
   SOCIETY_ROLES_STR = SOCIETY_ROLES.invert().freeze();

   #during a trounament these constants help keep track of who has what powers
   #and what information they should be prompted with
   TOURNAMENT_ROLES = {debater: 0, adjudicator: 1, tab_room: 2, ca: 3, dca: 4}.freeze();
   TOURNAMENT_ROLES_STR = TOURNAMENT_ROLES.invert().freeze();
   
end
