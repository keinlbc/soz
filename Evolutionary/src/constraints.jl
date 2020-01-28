function consecutiveConstraint(state::AbstractVector)

	for i in 2:length(state)-1		# to make sure we don't go out of boundaries
		threeConsecutiveDays = vcat(state[i-1], state[i], state[i+1])

		counter = Dict([(j,count(occurences -> occurences == j, threeConsecutiveDays)) for j in (1:horizon)])

		for (k,v) in counter
			if v >= 3
				return 1
			end
		end
	end

	return 0
end

function samePeopleTwoDaysConstraint(state::AbstractVector)

	for i in 2:length(state)		# to make sure we don't go out of boundaries
		if state[i-1] == state[i]		# if the same 3 people are working 2 days in a row
			return 1
		end
	end

	return 0
end

function cantWorkTogetherConstraint(state::AbstractVector)
   	pesho = 1
    gosho = 2

    for i in 1:length(state)
    	day = state[i]

        if ((day[1] == pesho && day[2] == gosho) || (day[1] == pesho && day[3] == gosho) || (day[2] == pesho && day[3] == gosho) ||
    		(day[2] == pesho && day[1] == gosho) || (day[3] == pesho && day[2] == gosho) || (day[3] == pesho && day[1] == gosho))
			return 1
		end
    end

	return 0
end
