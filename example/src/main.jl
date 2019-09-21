include("src/Stasis.jl")

using .Stasis

options = Dict(
  "pages_directory" => "example/src/pages"
)

Stasis.build(options)