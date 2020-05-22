module Stasis
export build, copy, parse, parse_markdown, parse_toml, serve, walk, watch

using Affinity  #, Organic
using FileWatching, Glob, HTTP, Markdown, TOML

# Build HTML page from affinity template
function build(; template, output, params...)
  context = Dict()

  # Add context variables to global context
  for (k, v) in params
    context["$k"] = v
  end

  # Inject partials
  src = replace(read(template, String), r"partial((.*))" => (m) -> begin
    filename = chop(replace(m, r"partial" => ""), head=2, tail=2)
    return read(filename, String)
  end)

  # Compile and write
  html = Affinity.compile(src, params=context)
  mkpath(match(r"^(.+)/([^/]+)$", output)[1])
  write(output, "<!DOCTYPE html>" * html)
end

# Copy static files
function copy(; input, output)
  cp(input, output, force=true)
end

# Parse content and meta from org file
function parse(file::AbstractString)
  meta, content = Organic.parse(file)

  return meta, content
end

# function parse_markdown(file)
#   data = Markdown.parse(split(read(file, String), "+++", limit=2, keepempty=false)[2])

#   for block in data.content
#     if typeof(block) == Markdown.LaTeX
#       block.formula = "\$" * block.formula * "\$"
#     end
#   end

#   return Markdown.html(data)
# end

# function parse_toml(file)
#   data = split(read(file, String), "+++", limit=2, keepempty=false)
#   return TOML.parse(data[1])
# end

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

function walk(dir)
  data = []

  for (root, dirs, files) in walkdir(dir)
    for file in files
      push!(data, joinpath(root, file))
    end
  end

  return data
end

function watch(fn, dir)
  @sync begin
    for folder in glob(joinpath(dir, "*"))
      @async begin
        while true
          event = watch_folder(folder)
          
          if event[2].changed
            fn()
          end
        end
      end
    end
  end
end

end
