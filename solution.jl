include("Evolutionary/src/Evolutionary.jl")
using Combinatorics
using Random

horizon = 7

people = ["Пешо", "Гошо", "Иван", "Мария", "Петруния", "Гергинка"]


rng = MersenneTwister(1234)




peopleindexes = collect(permutations(1:length(people), 3))


function fitness(n::AbstractVector)

    sum = 0
    i1 = [x[1] for x in n[1:horizon]]
    i2 = [x[2] for x in n[1:horizon]]
    i3 = [x[3] for x in n[1:horizon]]

    d = Dict([(i,count(x->x == i,vcat(i1,i2, i3))) for i in (1:6)]) # count occurances

    for (k,v) in d
        sum += 2^v
    end

    sum += penalty(n)*(2^horizon)

   
    #println(append!(append!(i1,i2), i3), d, sum)
  #  println(sum)

    return sum

    # exit()

end

function initpop(n::Int)
    return shuffle!(rng, peopleindexes)[n]
end

function penalty(state::AbstractVector)

for i in 2:length(state)-1 #to make sure we don't go out of boundaries
	threeConsecutiveDays = vcat(state[i-1], state[i], state[i+1])

	# 3 days, each day has 3 shifts
	counter = Dict([(j,count(occurences -> occurences == j, threeConsecutiveDays)) for j in (1:horizon)])

			for (k,v) in counter

				if v >= 3 return 1
			end
		end
	end

	return 0
end


best, invbestfit, generations, tolerance, history = Evolutionary.ga(
    x -> fitness(x),                    # Function to MINIMISE
    horizon,                        # Length of chromosome
    initPopulation = peopleindexes,
    selection = Evolutionary.roulette,                   # Options: sus
    mutation = Evolutionary.inversion,                   # Options:
    crossover = Evolutionary.singlepoint,                # Options:
    mutationRate = 0.2,
    crossoverRate = 0.5,
 #   ɛ = 2,                                # Elitism
    iterations = 250,
    tolIter = 20,
    populationSize = 50,
    interim = true);



println(best)
println(invbestfit)
#print(generations)
#print(history)
#print(tolerance)

println("\nпърва - втора - нощна")
for i in best[1:horizon]

    println(people[i[1]], " - " ,people[i[2]], " - ", people[i[3]])
end