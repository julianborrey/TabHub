### Institutions with rooms
Institution.create(id: 0, short_name: "select",
                   full_name: "-- select institution --", show_members: false)
Institution.create(short_name:   "Duke Debate",
                   full_name:    "Duke University Debating Society",
                   show_members: true)
Institution.create(short_name:   "UNSW",
                   full_name:    "University of New South Wales DebSoc",
                   show_members: true)
Institution.create(short_name:   "USU",
                   full_name:    "University of Sydney Union",
                   show_members: false)
Institution.create(short_name:   "Boğaziçi",
                   full_name:    "Boğaziçi University Debating Society",
                   show_members: false)

# first 6 rooms to Duke (for Tournament 1)
# not incorporating any place_id rooms yet
(1..6).each { |i|
  Room.create(name: "room#ij}@Duke", location: "a place",
              remarks: "Near the library.",
              institution_id: 1, place_id: nil)
}


(5..16).each { |i|
  inst = Institution.create(short_name:   "Inst#{i}",
                            full_name:    "Inst#{i} Debating Society",
                            show_members: (i%2 == 0))
  (6..36).each { |j|
    # make some rooms in a place and most on campus
    if j%5 == 0 # every sixth
      id_inst = nil
      id_place = i
    else
      id_inst = inst.id
      id_place = nil
    end

    Room.create(name: "room#{j}@Inst#{i}", location: "a place",
                remarks: "Near the library.",
                institution_id: id_inst, place_id: id_place)
  }
}

### Users
# this is user 1
u = User.new(fname: "Walter", lname: "White",
             email: "ww@example.com",
             password: "tabhub", password_confirmation: "tabhub",
             institution_id: 1, # Duke
             status: GlobalConstants::PRIVILEGES[:site_admin])
u.skip_confirmation!
u.save!
(1..200).each { |i|
  u = User.new(fname: "Fname#{i}", lname: "Lname#{i}",
               email: "user#{i}@example.com",
               password: "tabhub", password_confirmation: "tabhub",
               institution_id: ((i%20) + 1),
               status: GlobalConstants::PRIVILEGES[:general])
  u.skip_confirmation!
  u.save!
}

### Conflicts
(1..20).each { |i|
  user_id = 8 * i;
  inst_id = i
  Conflict.new(user_id: user_id, inst_id: inst_id).save!
}

### Tournaments with motions, rounds
Tounament.new(name: "Blue Devil Open", institution_id: 1,
              location: "Duke Chapel, Durham NC",
              start_time: DateTime.now,
              end_time: DateTime.now + 1.year,
              remarks: "Turn up!", user_id: 1).save!
(1..2).each{ |i|
  Tounament.new(name: "Tournament #{i}", institution_id: (i+1),
                location: "City #{i}, State #{i}",
                start_time: DateTime.now + i.months,
                end_time: DateTime.now + (i+2).months,
                remarks: "Remark #{i}", user_id: (i+1)).save!
}


### Motions + MotionGenres
Motion.new(wording: "THW go vegetarian.",
           user_id: 1, tournament_id: 1, round_id: 1).save!
MotionGenre.new(motion_id: 1, genre_id: 1).save!
Motion.new(wording: "THW would let the inmates run the asylum.",
           user_id: 1, tournament_id: 1, round_id: 2).save!
MotionGenre.new(motion_id: 2, genre_id: 2).save!
Motion.new(wording: "TH supports Bitcoin.",
           user_id: 1, tournament_id: 1, round_id: 3).save!
MotionGenre.new(motion_id: 2, genre_id: 3).save!
Motion.new(wording: "TH sail the seas.",
           user_id: 1, tournament_id: 1, round_id: 4).save!
MotionGenre.new(motion_id: 4, genre_id: 4).save!
Motion.new(wording: "THBT tabbing software is too old.",
           user_id: 1, tournament_id: 1, round_id: 5).save!
MotionGenre.new(motion_id: 5, genre_id: 5).save!

(1..40).each { |i|
  # we will have 2 other tournaments (id 2 and 3)
  round_id += i%2 # ensures we bump every second round
  Motion.new(wording: "THBT ... motion #{i} wording.",
             user_id: 1, tournament_id: (i%2 + 1),
             round_id: round_id).save!
}

### Teams + Adjudicators
teams = []
adjs  = []
(2..21).each { |i|
  # for each institution we need to get those coming
  inst_id = (i%20 + 2) # not including Duke
  tourn_1_ppl = {}
  tourn_1_ppl[inst_id.to_sym] = User.where(instiution_id: inst_id).to_a # should be 10 ppl
  
  ### Allocation
  Allocation.new(tournament_id: 1, institution_id: inst_id,
                 num_teams: 2, num_adjs: 2, live: false).save!

  mem_1 = tourn_1_ppl[inst_id.to_sym].first
  mem_2 = tourn_1_ppl[inst_id.to_sym].second
  t = Team.new(name: "Team #{i}", institution_id: inst_id,
               tournament_id: 1, member_1: mem_1.id,
               member_2: mem_2.id, total_speaks: 100+(i*10), 
               points: (i%15 + 1))
  t.save!
  teams.push(t)
  TournamentAttendee.new(tournament_id: 1,
                         user_id: mem_1.id,
                         role: GlobalConstants::TOURNAMENT_ROLES[:debater]).save!
  TournamentAttendee.new(tournament_id: 1,
                         user_id: mem_2.id,
                         role: GlobalConstants::TOURNAMENT_ROLES[:debater]).save!

  # each team brought 1 adj
  adj = tourn_1_ppl[inst_id.to_sym].third
  adjs.push(adj)
  TournamentAttendee.new(tournament_id: 1,
                         user_id: adj.id,
                         role: GlobalConstants::TOURNAMENT_ROLES[:adjudicator]).save!

  # first 6 institution bring a second team and second adj
  if i < 6
    mem_1 = tourn_1_ppl[inst_id.to_sym].fourth
    mem_2 = tourn_1_ppl[inst_id.to_sym].fifth
    t = Team.new(name: "Team #{i}", institution_id: inst_id,
                 tournament_id: 1, member_1: mem_1.id,
                 member_2: mem_2.id, total_speaks: 100+(i*10), 
                 points: (i%15 + 1))
    t.save!
    teams.push(t)
    TournamentAttendee.new(tournament_id: 1,
                           user_id: mem_1.id,
                           role: GlobalConstants::TOURNAMENT_ROLES[:debater]).save!
    TournamentAttendee.new(tournament_id: 1,
                           user_id: mem_2.id,
                           role: GlobalConstants::TOURNAMENT_ROLES[:debater]).save!

    # each team brought 1 adj
    adj = tourn_1_ppl[inst_id.to_sym][6] # there is no sixth
    adjs.push(adj)
    TournamentAttendee.new(tournament_id: 1,
                           user_id: adj.id,
                           role: GlobalConstants::TOURNAMENT_ROLES[:adjudicator]).save!
  end
}

### Rounds
# for tournamnet 1
(1..5).each { |i|
  Round.new(tournament_id: 1, round_num: i,
            motion_id: i, start_time: "start time",
            end_prep_time: "end prep time",
            status: 0).save!
}

### RoomDraws
# for now, only RoomDraws for tournament 1 since it's happening now
# assume we are in round 3 out of 5, we have 26 teams
# let's make final 2 teams swing teams - need 6 rooms
# we therefore need 6 * 3 = 18 RoomDraw
# NO SWING TEAMS YET
# the last 6 room draws have now place, round has not occured yet
(0..2).each { |round_num|
  adj_ctr = 1
  
  (0..5).each { |room_num|
    og = teams[team_ctr+0]
    oo = teams[team_ctr+1]
    cg = teams[team_ctr+2]
    co = teams[team_ctr+3]
    round_teams = [og, oo, cg, co]
    team_ctr += 4

    if round_num == 3
      first_place  = nil
      second_place = nil
      third_place  = nil
      fourth_Place = nil
    else
      first_place  = og
      second_place = oo
      third_place  = cg
      fourth_pace  = co
    end
    
    # no status implementation yet...
    rd = RoomDraw.new(tournament_id: 1, round_id: round_num,
                      room_id: (room_num + 1),
                      OG:    og,          OO:     oo, 
                      CG:    cg,          CO:     co,
                      first: first_place, second: second_place,
                      third: third_place, fourth: fourth_place,
                      statue: 0).save!
    
    if round_num != 3 # for round 1 and 2 we have scores
      (0..3).each { |i|
        Score.new(tournament_id: 1, round_id: round_num,
                  user_id: round_teams[i].member_1, speaks: 75, points: 3-i).save!
        Score.new(tournament_id: 1, round_id: round_num,
                  user_id: round_teams[i].member_2, speaks: 75, points: 3-i).save!
      }
    end

    ### Adjudicators
    # only for round 1..3
    (1..4).each { |i|
      Adjudicator.new(tournament_id: 1, room_draw_id: rd.id,
                      user_id: adjs[adj_ctr].id, chair: ((i%4) == 0)).save!
      adj_ctr += 1
    }
  }
}

### Tournament Settings
# only for tournament 1 for now
TournamentSetting.new(format: 1, registration: 1, motion: 2, tab: 1,
                      attendees: 1, teams: 1, privacy: 1).save!

### Blog posts
