using LightXML

function toXML(r::JTestResult)
    xroot = new_element("testcase")
    set_attribute(xroot, "id", r.expr)
    set_attribute(xroot, "name", r.expr)
    set_attribute(xroot, "time", string(elapsed_seconds(r)))
    if !r.result
        failure = new_element("failure")
        set_attribute(failure, "message", "Failure")
        set_attribute(failure, "type", "FAIL")
        set_content(failure, "test failed: $(string(r.expr))\nSource: $(r.file):$(r.line)")
        add_child(xroot, failure)
    end
    return xroot
end


function toXML(ts::JUnitTestSet)
    xroot = typeof(ts.results[1]) == JUnitTestSet ? new_element("testsuites") : new_element("testsuite")
    set_attribute(xroot, "id", ts.id)
    set_attribute(xroot, "name", ts.name)
    set_attribute(xroot, "time", ts.time.value / 1e9)

    for result in ts.results
        childnode = toXML(result)
        add_child(xroot, childnode)
    end

    set_attribute(xroot, "tests", ts.tests)
    set_attribute(xroot, "failures", ts.failures)
    return xroot
end

function write_report(ts::JUnitTestSet)
    el = toXML(ts)
    xroot = XMLDocument()
    set_root(xroot, el)
    return xroot
end
