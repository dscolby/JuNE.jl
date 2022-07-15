using Test
using JuNE.StemmingRules 

expected1 = ["ol", "it", "chris"]
expected2 = ["caress", "tie", "cri", "gas", "gap"]
expected3 = ("iful", "y", "")

@testset "SnowballRules.jl" begin
    @test broadcast(StemmingRules._getR1, 
        ("beautiful", "beauty", "beau")) == expected3
end

@testset "SnowballRules.jl" begin

    # Rule 0: removing contractions at the end of a word
    @test broadcast(StemmingRules._rule0, 
        ["ol'", "it's", "chris's'"]) == expected1

    # Rule 1: see the algorithm
    @test [StemmingRules._rule1("caresses"), 
        StemmingRules._rule1("ties"), 
        StemmingRules._rule1("cries"), 
        StemmingRules._rule1("gas"), 
        StemmingRules._rule1("gaps")] == expected2
end 