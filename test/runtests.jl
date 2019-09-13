using JUnitTestSets, Test

function myadd(a,b)
    return a+b
end

function boolfunc(a)
    return a == 1
end

ts = @jtestset begin
    @jtest 1 == 1
    @jtest 1 == 2
    @jtest myadd(1,2) == 3
    @jtest boolfunc(1)
end

report = write_report(ts)

expected_result = """
<?xml version="1.0" encoding="utf-8"?>
<testsuite id="tests" name="Julia Tests" time="0.006513769" tests="4" failures="1">
  <testcase id="1 == 1" name="1 == 1" time="0.002504622"/>
  <testcase id="1 == 2" name="1 == 2" time="1.0295e-5">
    <failure message="Failure" type="FAIL">test failed: 1 == 2
Source: $(@__FILE__):13</failure>
  </testcase>
  <testcase id="myadd(1, 2) == 3" name="myadd(1, 2) == 3" time="0.001850544"/>
  <testcase id="boolfunc(1)" name="boolfunc(1)" time="0.002148308"/>
</testsuite>
"""

@testset "JUnitTestSets.jl testing itself" begin
    @test replace(expected_result, r"time=\"[0-9].[e\-0-9]+\""=>"time=\"0\"") == replace(string(report), r"time=\"[0-9].[e\-0-9]+\""=>"time=\"0\"")
end
