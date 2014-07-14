def createPairs(users, day)
	possible_matches = []
	for i in (0...users - 1)
		for j in ((i + 1)...users.length)
			if (common_times = (user[i].openings.where(day: day) & user[j].openings.where(day: day)) != []) 
				possible_matches.push([users[i], users[j]], match(user[i], user[j]), common_times)
			end
		end
	end
	return possible_matches
end
