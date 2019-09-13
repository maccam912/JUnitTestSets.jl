using Dates

struct JTestResult
    result::Bool
    file::String
    line::Int
    expr::String
    time::Dates.Nanosecond
end

elapsed_seconds(j::JTestResult)::Float64 = Float64(j.time.value) / Float64(1e9) # nanoseconds in a second

macro jtest(args...)
    f = string(__source__.file)
    l = Int(__source__.line)
    quote
        local elapsedtime = Dates.Nanosecond(time_ns())
        local val = $(esc(args...))
        elapsedtime = Dates.Nanosecond(time_ns()) - elapsedtime
        JTestResult(val, $f, $l, string($args[1]), elapsedtime)
    end
end
