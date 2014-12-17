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

   URLs = {blog: "http://newtabware.blogspot.com/", github: "http://github.com/julianborrey/TabHub"}.freeze();

   #to show on the tournament control panel page
   COLOR = {yes: "#33cc33", no: "red"}.freeze();

   #tripple of values for functional parsing and display of logistics results
   LOGISTICS_RESULT = {yes: [true,  GlobalConstants::COLOR[:yes], "Yes"],
   						  no:  [false, GlobalConstants::COLOR[:no],   "No"]}.freeze();
   
   #the roles that people may act in a society, 
   #these previliages will allow for registration ...
   SOCIETY_ROLES = {member: 0, president: 1, externals: 2}.freeze();
   SOCIETY_ROLES_STR = SOCIETY_ROLES.invert().freeze();
   
   #during a trounament these constants help keep track of who has what powers
   #and what information they should be prompted with
   #not that these actually have an order (importance)
   TOURNAMENT_ROLES = {adjudicator: 1, tab_room: 2, ca: 4, dca: 3, debater: 5}.freeze();
   TOURNAMENT_ROLES_STR = TOURNAMENT_ROLES.invert().freeze();
   
   #these keep track of tournaments activity
   TOURNAMENT_STATUS = {past: -1, present: 0, future: 1}.freeze();
   TOURNAMENT_STATUS_STR = TOURNAMENT_STATUS.invert().freeze();

   #keeps track of open/closed registration and current round
   TOURNAMENT_PHASE = {closed: -1, open_rego: 0}

   #used to the status of a round
   ROUND_STATUS = {hidden: -1, draw_released: 0, round_started: 1}.freeze();

   #room draw status of a round
   ROOM_DRAW_STATUS = {not_finished: -1, finished: 1}.freeze();
	   
   #tournament reigons
   TOURNAMENT_REGIONS = {"International" => 1, "Australasia" => 2, "Asia" => 3, "Africa" => 4, 
                         "Middle East" => 5, "Europe" => 6, "North America" => 7, 
                         "South America" => 8}.freeze();
   TOURNAMENT_REGIONS_STR = TOURNAMENT_REGIONS.invert().freeze();
   
   #tournament formats
   FORMAT = {bp:  {num_speakers_per_team: 2, num_teams_per_room: 4}, 
             v3v: {num_speakers_per_team: 3, num_teams_per_room: 2}}.freeze();
   
   #used for the tournament settings
   SETTINGS_TITLES     = {registration: "Registration", motion: "Motion", tab: "Tab",
                          privacy:      "Tournament Privacy", attendees: "Attendees List",
                          teams:        "Teams List"}.freeze();
   SETTINGS_VALUES     = {registration: {"Manual" => 1, "Quota for selected institutions" => 2,
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
   
   #description of setting
   SETTINGS_INFO = {registration: "Registration can be done in many ways with TabHub. 
                                  <b>Manual</b> registration means that only authorized people 
                                  (the tab room) can register teams. 
                                  <b>Quota for selected institutions</b> means that institutions 
                                  you select will be able to submit teams and adjudicators 
                                  for the positions you allocate them. <b>Open to selected institutions
                                  </b> means that anyone from institutions selected by you can enrol.
                                  <b>Completely open</b> registration will allow anyone to 
                                  sign up for this tournament. Allowing options other than 
                                  manual registration will significantly reduce your administrative 
                                  work by removing the need to input into the system. 
                                  (You will always have the ability to check, remove, add and modify the teams.)",
                    
                    motion:       "Motions can be release in two ways. <b>Mass release</b> 
                                  makes the motion public to the tournament when you start the 
                                  given round. This allows people to see the motions on their 
                                  phones, tablets, etc. all at the same time. <b>Single release</b> is 
                                  the traditional method of putting the motion on a big screen 
                                  for all to see.",
                    
                    tab:          "A <b>Constatly visibile</b> tab can be viewed by all participants 
                                  throughout the tournament as it progresses. Alternatively, you 
                                  can opt to only have the tab released when you choose.",
                    
                    privacy:      "<b>Open</b> privacy means that anyone can see the tournament's existence, information, 
                                  motions (as they are released) and draw. Selecting <b>Visible to account holders</b> 
                                  will make the tournament visible to anyone who is logged into TabHub. The most private 
                                  setting is to make the tournament <b>Visible only to participants</b> which means only 
                                  registered users can view tournament.
                                  (You can always change this setting later.)",
                    
                    attendees:    "<b>Open</b> will allow anyone to view the list of attendees.
                                  You can instead make the list available to anyone logged into TabHub 
                                  (<b>Visible to account holders</b>) or to people who are attending the 
                                  tournament (<b>Visible to participants</b>). <b>Closed</b> will make 
                                  the attendees list unavailable.",
                    
                    teams:        "<b>Open</b> will allow anyone to view the list of teams.
                                  You can instead make the list available to anyone logged into TabHub 
                                  (<b>Visible to account holders</b>) or to people who are attending the 
                                  tournament (<b>Visible to participants</b>). <b>Closed</b> will make 
                                  the teams list unavailable."}.freeze();

end
