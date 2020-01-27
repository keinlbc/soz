include("Evolutionary/src/Evolutionary.jl")
using Combinatorics
using Random



people = ["Пешо","Гошо","Иван","Мария","Петруния","Гергинка"]


rng = MersenneTwister(1234)
a = shuffle(rng, Vector(1:10))



peopleindexes = collect(permutations(1:length(people), 6))
mass    = [1, 5, 3, 7, 2, 10, 5]
utility = [1, 3, 5, 2, 5,  8, 3]

function fitness(n::AbstractVector)

	#print(n)

	sum = 0
    i1 = [x[1] for x in n[1:7]]
    i2 = [x[2] for x in n[1:7]]
    i3 = [x[3] for x in n[1:7]]

    d=Dict([(i,count(x->x==i,append!(i1,i2))) for i in (1:7)])

    for (k,v) in d
    	sum += 2^v
    end
    print(append!(i2, i3), d, sum)
   # println(sum)

    return sum
    
    # exit()

end

function initpop(n::Int)
	return shuffle!(rng, peopleindexes)[n]
end


sampler(peapolIndexes) = peopleindexes




best, invbestfit, generations, tolerance, history = Evolutionary.ga(
    x -> fitness(x),                    # Function to MINIMISE
    7,                        # Length of chromosome
    initPopulation = peopleindexes,
    selection = Evolutionary.roulette,                   # Options: sus
    mutation = Evolutionary.inversion,                   # Options:
    crossover = Evolutionary.singlepoint,                # Options:
    mutationRate = 0.2,
    crossoverRate = 0.5,
    ɛ = 0.1,                                # Elitism
    iterations = 250,
    tolIter = 20,
    populationSize = 50,
    interim = true);



print(best[1:7])
print(invbestfit)
#print(generations)
#print(history)
#print(tolerance)

println("\nпърва - втора - нощна")
for i in best[1:7]

	println(people[i[1]], " - " ,people[i[2]], " - ", people[i[3]])
end