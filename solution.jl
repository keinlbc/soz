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

    sum += penalty(n)*2^horizon

    #println(append!(append!(i1,i2), i3), d, sum)
    println(sum)

    return sum

    # exit()

end

function initpop(n::Int)
    return shuffle!(rng, peopleindexes)[n]
end

function penalty(vector::AbstractVector)

    for i in 2:size(vector)-1 #to make sure we don't go out of boundaries
        threeConsecutiveDays = vcat(vector[i-1], vector[i], vector[i+1])

        for j in 1:9 # 3 days, each day has 3 shifts
           if (count(occurences -> occurences == threeConsecutiveDays[j], threeConsecutiveDays) >= 3) true end
        end
    end

    return false
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
    ɛ = 2,                                # Elitism
    iterations = 50,
    tolIter = 20,
    populationSize = 50,
    interim = true);



print(best[1:7])
print(invbestfit)
#print(generations)
#print(history)
#print(tolerance)

println("\nпърва - втора - нощна")
for i in best[1:horizon]

    println(people[i[1]], " - " ,people[i[2]], " - ", people[i[3]])
end