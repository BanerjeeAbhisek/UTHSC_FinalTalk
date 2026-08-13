required <- c("r.jive", "JuliaConnectoR")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {
  stop(
    "Install the missing R package(s) first: install.packages(c(",
    paste(sprintf('"%s"', missing), collapse = ", "), "))"
  )
}

suppressPackageStartupMessages(library(r.jive))
suppressPackageStartupMessages(library(JuliaConnectoR))

# Data contains Expression, Methylation, and miRNA matrices with aligned tumors.
data("BRCA_data", package = "r.jive")
blocks <- Data
X1 <- blocks[["Expression"]]
X2 <- blocks[["Methylation"]]
X3 <- blocks[["miRNA"]]

stopifnot(
  identical(dim(X1), c(645L, 348L)),
  identical(dim(X2), c(574L, 348L)),
  identical(dim(X3), c(423L, 348L))
)

joint_rank <- 2L
individual_ranks <- c(27L, 26L, 25L)
repetitions <- as.integer(Sys.getenv("JIVE_REPS", "3"))

time_repeated <- function(label, fit_function, repetitions) {
  times <- numeric(repetitions)
  for (i in seq_len(repetitions)) {
    times[[i]] <- system.time(invisible(fit_function()))[["elapsed"]]
    message(label, " fit ", i, ": ", round(times[[i]], 3), " s")
  }
  times
}

# 1. R -> Julia: BigRiverEssence called through JuliaConnectoR.
# Start Julia and compile before timing. Matrix conversion at each function call
# remains inside the practical bridge timing.
# Keep the Julia definition in one R string so it is also safe when sourced
# from an interactive R session.
invisible(juliaEval("using BigRiverEssence; brca_jive(X1::Matrix{Float64}, X2::Matrix{Float64}, X3::Matrix{Float64}) = BigRiverEssence.jive(Matrix{Float64}[X1, X2, X3], 2, Int[27, 26, 25])"))
Julia <- juliaImport("Main")

fit_connector <- function() Julia$brca_jive(X1, X2, X3)

message("Warming up JuliaConnectoR and BigRiverEssence ...")
invisible(fit_connector())
message("Benchmarking the warmed R-to-Julia call ...")
times_connector <- time_repeated(
  "JuliaConnectoR", fit_connector, repetitions
)

# Close Julia explicitly before starting the native R benchmark. A top-level
# on.exit(stopJulia()) can close the connection too early when using source().
stopJulia()

# 2. Native R: r.jive. No permutation test is included in the timed call.
fit_r <- function() {
  r.jive::jive(
    blocks,
    method = "given",
    rankJ = joint_rank,
    rankA = individual_ranks,
    showProgress = FALSE
  )
}

message("Benchmarking native r.jive ...")
times_r <- time_repeated("r.jive", fit_r, repetitions)

median_connector <- median(times_connector)
median_r <- median(times_r)

cat("\nR and connector summary\n")
cat("  dimensions: 645x348, 574x348, 423x348\n")
cat("  ranks: joint = 2, individual = 27, 26, 25\n")
cat("  r.jive median: ", round(median_r, 3), " s\n", sep = "")
cat("  JuliaConnectoR median: ", round(median_connector, 3), " s\n", sep = "")
cat("  connector speed-up: ",
    round(median_r / median_connector, 2), "x\n", sep = "")
