# BRCA JIVE benchmark

These scripts reproduce the timing comparison shown in the presentation. All
three routes use the same BRCA multi-omics matrices and fixed ranks: joint rank
2 and individual ranks 27, 26, and 25. Data loading, Julia startup, and Julia's
first-call compilation are outside the timed regions.

## Dependencies

In R:

```r
install.packages(c("r.jive", "JuliaConnectoR"))
```

In Julia:

```julia
using Pkg
Pkg.add("BigRiverEssence")
```

## Run

From this directory:

```bash
julia --startup-file=no benchmark_jive_julia.jl
Rscript benchmark_jive_r_and_connector.R
```

The slide used five warmed native-Julia fits and three fits for each R route.
For a quick one-run check, use:

```bash
JIVE_REPS=1 julia --startup-file=no benchmark_jive_julia.jl
JIVE_REPS=1 Rscript benchmark_jive_r_and_connector.R
```

Exact times vary with the computer, BLAS library, package versions, and current
system load. Compare medians produced in the same session and on the same
machine.
