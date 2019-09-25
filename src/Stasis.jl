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

  HTTP.listen("127.0.0.1", 8081) do req
    HTTP.setheader(req, "Content-Type" => "text/html")
    write(req, "target uri: $(req.message.target)<BR>")
    write(req, "request body:<BR><PRE>")
    write(req, read(req))
    write(req, "</PRE>")
    return
  end
end

end