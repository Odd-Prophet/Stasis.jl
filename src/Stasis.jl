module Stasis
export build, copy, parse_markdown, parse_toml, serve, walk

include("../../Affinity.jl/src/Affinity.jl")
using .Affinity
using HTTP, Markdown, TOML

function build(input, output; params...)
  context = Dict()

  for (k, v) in params
    context["$k"] = v
  end

  write(output, Affinity.compile(read(input, String), params=context))
end

function copy(input, output)
  cp(input, output, force=true)
end

function parse_markdown(file)
  data = split(read(file, String), "+++", limit=2, keepempty=false)
  return Markdown.html(Markdown.parse(data[2]))
end

function parse_toml(file)
  data = split(read(file, String), "+++", limit=2, keepempty=false)
  return TOML.parse(data[1])
end

function serve(dir)
  cd(dir)

  HTTP.serve() do request::HTTP.Request
    @show request
    @show request.method
    @show HTTP.header(request, "Content-Type")
    @show HTTP.payload(request)
    try
      file = request.target == "/" ? "index.html" : request.target[2:end]
      return HTTP.Response(read(file))
    catch e
      return HTTP.Response(404, read("404.html"))
    end
  end
end

function walk(directory)
  data = []

  for (root, dirs, files) in walkdir(directory)
    for file in files
      push!(data, joinpath(root, file))
    end
  end

  return data
end

end