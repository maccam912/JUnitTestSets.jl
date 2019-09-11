using JUnitTestSets, Test

function get_ts()
    ts = @junittestset JUnitTestSet "JUnitTestSets.jl" begin
        @test 1 == 1
        @test 1 == 2
    end
    return ts
end

report = write_report(get_ts())

expected_result = """
<?xml version="1.0" encoding="utf-8"?>
<testsuite id="JUnitTestSets.jl" name="JUnitTestSets.jl" tests="2" failures="1">
  <testcase id="1 == 1" name="1 == 1"/>
  <testcase id="1 == 2" name="1 == 2">
    <failure message="Failure" type="FAIL">test failed: 1 == 2
Source: #= /Users/maccam912/.julia/dev/JUnitTestSets/test/runtests.jl:6 =#</failure>
  </testcase>
</testsuite>
"""

@testset "JUnitTestSets.jl testing itself" begin
    @test expected_result == string(report)
end
