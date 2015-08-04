### Institutions with rooms
Institution.create(id: 0, short_name: "select", full_name: "-- select institution --")

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

[1..16].each { |i|
  inst = Institution.create(short_name:   "Inst#{i}",
                            full_name:    "Inst#{i} Debating Society",
                            show_members: (i%2 == 0))
  [1..30].each { |j|
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
u = User.new(fname: "Walter", lname: "White"m
             email: "ww@example.com",
             password: "tabhub", password_confirmation: "tabhub",
             institution_id: 1, # Duke
             status: GlobalConstants::PRIVILEGES[:site_admin])
u.skip_confirmation!
u.save!

[1..200].each { |i|
  u = User.new(fname: "Fname#{i}", lname: "Lname#{i}",
               email: "user#{i}@example.com",
               password: "tabhub", password_confirmation: "tabhub",
               institution_id: ((i%20) + 1),
               status: GlobalConstants::PRIVILEGES[:general])
  u.skip_confirmation!
  u.save!
}

### Conflicts




### Motion genres




### Tournaments with motions, rounds



### Blog posts
