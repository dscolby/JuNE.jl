using Test
using JuNE.StemmingRules 

# Test finding the R1 and R2 regions of words
@testset "SnowballRules.jl" begin

    # R1 region
    @test broadcast(StemmingRules.__getR1, 
        ("beautiful", "beauty", "beau")) == ("iful", "y", "")

    # R2 region
    @test broadcast(StemmingRules.__getR2, 
        ("beautiful", "beauty", "beau")) == ("ul", "", "")
end

# Test the preprocessing step
@testset "SnowballRules.jl" begin #TODO: Figure out how to import STOPWORDS
    @test broadcast(StemmingRules.__prestep, 
        ("he", "sergey")) == ("he", "sergeY")
end

# Test the first part of special cases for words that start with gener, commun, and arsen
@testset "SnowballRules.jl" begin
    # This function is only run for its side effects
    @test broadcast(StemmingRules.__special_cases, 
        ("generate", "communal", "arsenal")) == ("generate", "communal", "arsenal")
end

# Test to make sure the stemmer gets rid of 's', 's, and ' suffixes
@testset "SnowballRules.jl" begin
    @test broadcast(StemmingRules.__step0, 
        ("darren's'", "darren's", "darren'")) == ("darren", "darren", "darren")
end