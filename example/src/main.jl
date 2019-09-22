include("src/Stasis.jl")

using .Stasis

options = Dict(
  "source_directory" => "example/src"
)

Stasis.build(options)