namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    makeUsers
  end
end


def makeUsers
  admin = User.create!(fname: "Admin",

                       email: "admin@yale.edu",
                       # password: "foobar",
                       # password_confirmation: "foobar",
                       admin: true)
  20.times do |n|
    fname = Faker::Name.first_name
    lname = Faker::Name.last_name
    email = fname + "." + lname + "@yale.edu"
    user = User.create!(fname: fname,
                        lname: lname,
                        email: email)
    #give user x unique openings
    for i in 1..3
      o = makeOpening
      if !containsOpening?(user.openings, o)
        # puts o
        # puts "---"
        user.openings << o
        user.save
      else
        # puts o
        # puts "==="
      end
    end
  end
end

def makeOpening
  lunch_times = [690, 720, 750, 780]
  dining_halls = ['bk', 'br', 'cc', 'dc', 'es', 'je', 'mc', 'pc', 'sy', 'sc', 'td', 'tc']
  # days_of_week = (1..5).to_a
  days_of_week = (1..1).to_a

  opening = Opening.create(minuteTime: lunch_times.sample,
                           place: dining_halls.sample,
                           weekday: days_of_week.sample)
  return opening
end

def containsOpening?(oAll, oNew)
  oAll.each do |o|
    if (o.minuteTime == oNew.minuteTime) &&
        (o.place == oNew.place) &&
        (o.weekday == oNew.weekday)
        return true
    end
  end
  return false
end