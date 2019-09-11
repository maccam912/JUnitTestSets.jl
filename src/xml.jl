using LightXML

function toXML(r::Test.Pass)
    xroot = new_element("testcase")
    set_attribute(xroot, "id", r.data)
    set_attribute(xroot, "name", r.data)
    return xroot
end

function toXML(r::Test.Fail)
    xroot = new_element("testcase")
    set_attribute(xroot, "id", r.data)
    set_attribute(xroot, "name", r.data)
    failure = new_element("failure")
    set_attribute(failure, "message", "Failure")
    set_attribute(failure, "type", "FAIL")
    set_content(failure, "test failed: $(string(r.data))\nSource: $(r.source)")
    add_child(xroot, failure)
    return xroot
end

function toXML(ts::JUnitTestSet)
    xroot = typeof(ts.results[1]) == JUnitTestSet ? new_element("testsuites") : new_element("testsuite")
    set_attribute(xroot, "id", ts.id)
    set_attribute(xroot, "name", ts.name)

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
