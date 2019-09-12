__precompile__()

module JUnitTestSets

export JUnitTestSet, write_report, @junittestset

using Cassette, Test

idnum = 0

mutable struct JUnitTestSet <: Test.AbstractTestSet
    id::String
    name::String
    tests::Int
    failures::Int
    #time::Float64
    results::Vector{Union{JUnitTestSet, Test.Result}}
    JUnitTestSet(desc="JUnit Test Set") = new(desc, desc, 0, 0, [])
end
Test.record(ts::JUnitTestSet, child) = push!(ts.results, child)

tests_and_failures(r::JUnitTestSet) = (r.tests, r.failures)
tests_and_failures(r::Test.Pass) = (1, 0)
tests_and_failures(r::Test.Error) = (1, 1)
tests_and_failures(r::Test.Fail) = (1, 1)

function Test.finish(ts::JUnitTestSet)
    if Test.get_testset_depth() > 0
        Test.record(Test.get_testset(), ts)
    end
    for r in ts.results
        t,f = tests_and_failures(r)
        ts.tests += t
        ts.failures += f
    end
    ts
end

include("xml.jl")

function do_junittest(result::Test.ExecutionResult, orig_expr)
    # Taken pretty much right from https://github.com/JuliaLang/julia/blob/master/stdlib/Test/src/Test.jl#L495
    # Just changed Test.Pass
    if isa(result, Test.Returned)
        value = result.value
        testres = if isa(value, Bool)
            value ? Test.Pass(:test, orig_expr, result.data, value) :
                    Test.Fail(:test, orig_expr, result.data, value, result.source)
        else
            Test.Error(:test_nonbool, orig_expr, value, nothing, result.source * s)
        end
    else
        @assert isa(result, Test.Threw)
        testres = Test.Error(:test_error, orig_expr, result.exception, result.backtrace, result.source)
    end
    Test.record(Test.get_testset(), testres)
end

Cassette.@context JUnitCtx

Cassette.overdub(::JUnitCtx, ::typeof(Test.do_test), args...) = do_junittest(args...)

macro junittestset(args...)
    :(Cassette.overdub(JUnitCtx(metadata = Main), () -> Test.@testset($(args...))))
end

end # module
