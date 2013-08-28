# Site for Online Debating Tabbing #
This README is a mess for now. Will move this cluster to 
wiki pages soon.

### Features ###
* Try to remove all inputting time.
   * Many jobs will be split because admins will have the 
     ability to make others admin and so the job will speed up.
   * Force entry of users onto themselves by having them make 
     an account and sign up. The tournament admin will just 
     have to approve the inputs with single clicks (if they 
     have required that there is approval).
   * Now that each debater has an account the society president 
     can open a contingent and people can sign up for that. The 
     president then submits the contingent to the tournament 
     admin.
   * The input of rooms must be manually inputted by admins but 
     only the first time will it be so bad. Rooms will forever 
     be saved and associated with an institution and so they can 
     reimport those rooms to save time.

* User profile contains:
   * Go through paper
   * Past teams

### Entities ###
* Room:
   * Name
   * Location on map for directing
   * Comments/Remarks

* Topic:
   * wording
   * user\_id
   * round\_num
   * tournament\_id
 
* User:
   * name
   * email
   * password\_digest
   * remember\_token
   * institiution\_id
   * status
   * num\_tournaments

* Tournament (these will be searchable):
   * name
   * location
   * institution
   * start\_date\_time
   * end\_date\_time
   * remarks (text) (suggest that they input the conveners, CA, etc.)

* Tournament\_Admin:
   * tournament\_id
   * user\_id
   * creator (boolean)

* Teams:
   * institution\_id
   * tournament\_id
   * member\_1
   * member\_2
   * member\_3
   * total\_speaks
   * points

* Round:
   * tourament\_id (index)
   * round\_num
   * room\_id
   * OG
   * OO
   * CG
   * CO
   * first
   * second
   * third
   * fourth

* Judges
   * round\_id
   * user\_id
   * chair (boolean)

* Tournament\_attendees
   * user\_id
   * role

### Status Codes ###
* 0 - ultimate admin
* 1 - externals coordinator (can submit a contingent)
* 2 - president (is there any need? approve that ppl are in a contingent, 
      approve who can be externals coordinator, pass down authority)
* 3 - normal debater

### Role Codes ###
* 0 - convener
* 1 - CA
* 2 - DCA
* 3 - tab room
* 4 - MC
* 5 - admin/support
* 6 - debater
* 7 - adjudicator
