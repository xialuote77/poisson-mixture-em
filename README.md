# Poisson Mixture Models with EM

## 中文概览

### Poisson 混合模型与 EM 算法

针对类别信息缺失的计数数据，建立三成分 Poisson 混合模型，推导并用 R 实现 EM 算法，再扩展为同时利用未标注和已标注观测的联合模型。

- **个人工作**：独立完成似然函数推导、E 步与 M 步更新、R 代码实现，以及初始化比较和收敛分析。
- **模型设置**：基础模型使用 300 个未标注观测；联合模型另加入 100 个已标注观测，比较已知类别信息如何参与参数估计。
- **验证结果**：R 代码已重跑。两组初始化下，基础模型均在 12 次迭代收敛，联合模型分别在 8 次和 9 次迭代收敛；对数似然均非递减，另用 NumPy 完成数值核对。

本项目源于统计课程，使用教学数据展示潜变量建模、极大似然估计和算法实现。潜在成分的实际含义仍需结合数据背景解释。

## English documentation

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
