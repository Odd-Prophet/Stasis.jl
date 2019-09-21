module Stasis

using Mustache, Weave
export build

function build(options)
  build_pages(options["pages_directory"])
end

function build_pages(directory)
  for file in walkdir(directory)
    println(file)
  end
end

end