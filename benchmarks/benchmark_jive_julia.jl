using BigRiverEssence
using BenchmarkTools
using DelimitedFiles

# The same BRCA matrices distributed with r.jive and used in the slide.
datadir = joinpath(pkgdir(BigRiverEssence), "reference_Data", "brcadata")
blocks = Matrix{Float64}[
    readdlm(joinpath(datadir, "expression.csv"), ',', Float64),
    readdlm(joinpath(datadir, "methylation.csv"), ',', Float64),
    readdlm(joinpath(datadir, "mirna.csv"), ',', Float64),
]

@assert size.(blocks) == [(645, 348), (574, 348), (423, 348)]

# Published BRCA example ranks. Holding these fixed benchmarks fitting only,
# rather than the separate permutation-based rank-selection procedure.
joint_rank = 2
individual_ranks = [27, 26, 25]
repetitions = parse(Int, get(ENV, "JIVE_REPS", "5"))

println("\nNative Julia benchmark")
println("  dimensions: ", size.(blocks))
println("  ranks: joint = $joint_rank, individual = $individual_ranks")
println("  @btime warms up first, then reports the minimum time and allocations:")

@btime BigRiverEssence.jive(
    $blocks, $joint_rank, $individual_ranks
) samples = repetitions evals = 1
