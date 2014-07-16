class Array
  # replace val with nil, return val and old index
  def xdelete(val)
  	i = self.index(val)
  	self[i] = nil
  	[val, i]
  end
  # return length of array without nils
  def xlength
  	self.compact.length
  end
  # leftover is [val, index], insert val at index into array
  def xinsert(a)
  	self[a[1]] = a[0]
  end
end


# will pass in User.all
def filterUsers(all_users, day) 
	filtered_users = []
	all_users.each do |user|
		if (user.openings.inject(false) {|result, opening| result || (opening.weekday == day)})
			filtered_users << user
		end
	end
	
	filtered_users
end

def createPairs(users, day)
	possible_matches = []
	for i in (0...(users.length - 1))
		for j in ((i + 1)...users.length)
			possible_matches.concat(getPossibles(users[i], users[j], day))
		end
	end
	return possible_matches
end

def getPossibles(u1, u2, day)
	possibles = []
	u1.openings.where(weekday: day).each do |o1|
		u2.openings.where(weekday: day).each do |o2|
			if openingEq?(o1, o2)
				possibles << [u1, u2, o1]
				break
			end
		end
	end

	return possibles
end

# input
	# remaining possible matches
	# local branch matches
	# maximum matches so far
	# best possible number of matches
def backTrack (possibles, matches, maxMatches, bestN)
	# base case
	if possibles.xlength == 0
		return matches
	end

	possibles.each_with_index do |possible, i|
		if !possible
			next
		end

		# add possible match to the match array
		burp = possibles.xdelete(possible)
		matches << burp[0]
		deletedPossibles = [burp]

		# delete all possible matches that have users in common with iterated possible
		# ignore possibilities before current index
		possibles.each_with_index do |p, j|
			if (j<=i) || (p && (p.include?(possible[0]) || p.include?(possible[1])))
				deletedPossibles << possibles.xdelete(p)
			end
		end

		matchesRevert = matches.dup

		# if worth going down branch
		if (possibles.xlength + matches.length) > maxMatches.length
			# recurse
			matches = backTrack(possibles, matches, maxMatches, bestN)
			# if new best solution
			(maxMatches = matches.dup) if matches.length > maxMatches.length
			# if every possible match is made
			return maxMatches.dup if maxMatches.length == bestN

			matches = matchesRevert
		end


		#putting deleted elements back into possibles array
		matches.pop
		deletedPossibles.each do |d|
			possibles.xinsert(d)
		end
	end

	return maxMatches.dup
end

def openingEq?(o1, o2)
	(o1.minuteTime == o2.minuteTime) &&
    (o1.place == o2.place) &&
    (o1.weekday == o2.weekday)
end

def test
	puts '....'

	possibles = createPairs( filterUsers(User.all, 1), 1)
	# puts possibles
	puts possibles.length
	
	puts '...............'
	
	[possibles.length, backTrack(possibles, [], [], possibles.length), 'hi']
end



def printMatches(matches, string)
	puts string
	puts "+++++++++++++++++"
	matches.each do |match|
		if (match != nil)
			printSingleMatch(match)
		end
	end
	nil
end

def printSingleMatch(match)
	if match
		puts match[0].id
		puts match[1].id
		puts "Opening id: " + match[2].id.to_s
		puts '===================='
	end
end
