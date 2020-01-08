module Stasis
export build, copy, parse_markdown, parse_toml, serve, walk

using Affinity
using HTTP, Markdown, TOML

function build(; template, output, params...)
  context = Dict()

  # Add context variables to global
  for (k, v) in params
    context["$k"] = v
  end

  # Inject partials
  src = replace(read(template, String), r"partial((.*))" => (m) -> begin
    filename = chop(replace(m, r"partial" => ""))
    return read(filename, String)
  end)

  println(src)

  html = Affinity.compile(src, params=context)
  
  mkpath(match(r"^(.+)/([^/]+)$", output)[1])

  write(output, "<!DOCTYPE html>" * html)
end

function copy(; input, output)
  cp(input, output, force=true)
end

function parse_markdown(file)
  data = Markdown.parse(split(read(file, String), "+++", limit=2, keepempty=false)[2])

  for block in data.content
    if typeof(block) == Markdown.LaTeX
      block.formula = "\$" * block.formula * "\$"
    end
  end

  return Markdown.html(data)
end

function parse_toml(file)
  data = split(read(file, String), "+++", limit=2, keepempty=false)
  return TOML.parse(data[1])
end

function serve(dir)
  cd(dir)

  HTTP.serve() do request::HTTP.Request
    @show request
    
    relative_target = request.target[2:end]

    try
      if isdir(relative_target) || isempty(relative_target)
        file = joinpath(relative_target, "index.html")
        return HTTP.Response(read(file))
      else
        return HTTP.Response(read(relative_target))
      end
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