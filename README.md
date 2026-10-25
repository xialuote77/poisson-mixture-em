# Poisson Mixture Models with EM

## 中文概览

**项目定位：统计建模 / 潜在类别识别 / 算法实现。** 针对珊瑚鳟计数数据中的缺失类别信息，推导并用 base R 自行实现三成分 Poisson 混合模型的 EM 算法，再扩展到包含已标注样本的联合模型。

- **个人贡献**：独立完成似然推导、E/M 步更新、R 实现、初始化比较和收敛分析。
- **数据与方法**：300 个未标注计数；扩展模型另加入 100 个已标注观测；两组初始化与似然单调性检查。
- **验证结果**：原 R 代码已实际重跑；未标注模型两次均在 12 次迭代收敛，联合模型分别在 8/9 次迭代收敛；另有 NumPy 数值复核。
- **能力展示**：概率统计、极大似然、潜变量模型、从公式到代码的实现与数值验证。该项目不是部署型分类系统，潜在成分也不能直接等同于真实管理类别。

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
