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
   PRIVILEGES_STR = PRIVILEGES.invert().freeze(); #swaps all key-value pairs     

   #the roles that people may act in a society, 
   #these previliages will allow for registration ...
   SOCIETY_ROLES = {member: 0, president: 1, externals: 2}.freeze();
   SOCIETY_ROLES_STR = SOCIETY_ROLES.invert().freeze();

   #during a trounament these constants help keep track of who has what powers
   #and what information they should be prompted with
   TOURNAMENT_ROLES = {debater: 0, adjudicator: 1, tab_room: 2, ca: 3, dca: 4}.freeze();
   TOURNAMENT_ROLES_STR = TOURNAMENT_ROLES.invert().freeze();
   
   #these keep track of tournaments activity
   TOURNAMENT_STATUS = {past: -1, present: 0, future: 1}.freeze();
   TOURNAMENT_STATUS_STR = TOURNAMENT_STATUS.invert().freeze();
   
   #used for the tournament settings
   SETTINGS_TITLES     = {registration: "Registration", motion: "Motion", tab: "Tab",
                          privacy:      "Tournament Privacy", attendees: "Attendees List",
                          teams:        "Teams List"}.freeze();
   SETTINGS_VALUES     = {registration: {"Manual" => 1, "Open to authorized institutions" => 2,
                                         "Open to selected institutions" => 3, "Completely open" => 4},
                          motion:       {"Mass release" => 1, "Single release" => 2},
                          tab:          {"Constatnly visible" => 1, "Release on command" => 2},
                          privacy:      {"Open" => 1, "Visible to account holders" => 2, 
                                         "Visible to participants" => 3},
                          attendees:    {"Open" => 1, "Visible to account holders" => 2, 
                                         "Visible to participants" => 3, "Closed" => 4},
                          teams:        {"Open" => 1, "Visible to account holders" => 2, 
                                         "Visible to participants" => 3, "Closed" => 4},
                         }.freeze();
   
   #generalize this more later
   SETTINGS_VALUES_STR = {};
   SETTINGS_VALUES_STR[:registration] = SETTINGS_VALUES[:registration].invert();
   SETTINGS_VALUES_STR[:motion]       = SETTINGS_VALUES[:motion].invert();
   SETTINGS_VALUES_STR[:tab]          = SETTINGS_VALUES[:tab].invert();
   SETTINGS_VALUES_STR[:privacy]      = SETTINGS_VALUES[:privacy].invert();
   SETTINGS_VALUES_STR[:attendees]    = SETTINGS_VALUES[:attendees].invert();
   SETTINGS_VALUES_STR[:teams]        = SETTINGS_VALUES[:teams].invert();
   SETTINGS_VALUES_STR.freeze();
end
