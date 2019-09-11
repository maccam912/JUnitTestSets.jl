module JUnitTestSets

using Test, LightXML

mutable struct JUnitTestSet <: Test.AbstractTestSet
    id::String
    name::String
    tests::Int
    failures::Int
    time::Float64
    results::Vector{Union{JUnitTestSet, Test.Result}}
    JUnitTestSet(desc="JUnit Test Set") = new("1", desc, 0, 0, 0, [])
end
Test.record(ts::Testsuite, child) = push!(ts.results, child)

function Test.finish(ts::Testsuite)
    if Test.get_testset_depth() > 0
        Test.record(Test.get_testset(), ts)
    end
    ts
end

end # module
