# Poisson Mixture Models with EM

Recover latent classes in reef fish counts using an expectation-maximisation algorithm implemented in **base R**. This individual project demonstrates likelihood derivation, posterior responsibilities, constrained parameter updates and convergence diagnostics.

## Model and evidence

The first model fits three Poisson components to 300 unlabelled counts. The second incorporates 100 labelled class-2 observations through a shared rate parameter. Both models are run from two initialisations and checked for nondecreasing incomplete log-likelihood.

| Original reported result | Unlabelled model | Combined model |
| --- | ---: | ---: |
| Final log-likelihood | -1136.962 | -1429.048 |
| Iterations, two starts | 12 / 12 | 8 / 9 |

The two likelihoods concern different datasets and are not directly comparable model-selection scores. The extracted original R code was executed successfully with R 4.5.2. Both starts had nondecreasing likelihoods and reproduced the reported final likelihoods and iteration counts. An independent NumPy calculation also agreed within 0.001. Generated convergence plots are in [em-diagnostics.pdf](em-diagnostics.pdf). Quarto HTML rendering was not executed.

## Run

From the repository root with R installed: `Rscript run_analysis.R`. This writes convergence plots to `em-diagnostics.pdf`. To render the derivation and code, install Quarto and knitr, then run `quarto render analysis.qmd`.

## Contents

- `analysis.qmd`: student-authored mathematical solution and live R code.
- `run_analysis.R`: extracted analysis code.
- `data/`: supplied educational count observations; not an independently collected field survey.
- `docs/CONTRIBUTIONS.md`: authorship.

## Limitations and provenance

Three components are assumed; latent components should not automatically be identified with real management regimes. Two initialisations do not establish a global optimum. The original implementation computes probabilities directly and is not hardened against extreme-value underflow or empty components. Dataset redistribution terms have not been independently established; review them before publishing the bundled educational data.

Originally MAST30027 Assignment 3, University of Melbourne. Names and student identifiers in assessment templates are removed; no new software licence is assigned.
