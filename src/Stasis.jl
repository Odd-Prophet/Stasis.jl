module Stasis
export build

using Mustache, Weave

function build(options)
  rm(options["build_dir"], force=true, recursive=true)
  mkdir(options["build_dir"])

  for (root, dirs, files) in walkdir(options["source_dir"])
    if root == "src/pages"
      build_pages(map(f -> joinpath(root, f), files), options)
    elseif root == "src/content"
      build_content(map(f -> joinpath(root, f), files), options)
    end
  end
end

function build_content(files, options)
  for file in files
    weave(
      file,
      template="src/templates/default.html",
      out_path=joinpath(options["build_dir"], basename(file)[1:end-4], "index.html")
    )
  end
end

function build_pages(files, options)
  for file in files
    println(file)
  end
end

end