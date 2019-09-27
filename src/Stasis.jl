module Stasis
export build, copy, serve

include("../../Affinity.jl/src/Affinity.jl")
using .Affinity
using HTTP

function build(input, output, params...)
  html = Affinity.compile(read(input, String), params...)
  write(output, html)
end

function copy(input, output)
  write(output, read(input, String))
end

function serve(dir)
  cd(dir)

  HTTP.serve() do request::HTTP.Request
    @show request
    @show request.method
    @show HTTP.header(request, "Content-Type")
    @show HTTP.payload(request)
    try
      file = request.target == "/" ? "index.html" : request.target[2:]
      return HTTP.Response(read(file))
    catch e
      return HTTP.Response(404, "Error: $e")
    end
  end

end

end