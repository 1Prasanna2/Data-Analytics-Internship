# Day 21 — A/B Test Exploratory Analysis

## Project Overview

This project performs an exploratory **A/B test analysis using Python** to compare the conversion performance of a **control group** against a **treatment group**.

The analysis focuses on:

- Conversion rate comparison
- Absolute conversion-rate difference
- Relative lift
- Hypothesis testing
- Statistical significance
- Confidence intervals and uncertainty
- Effect size
- Practical interpretation of the experiment results

The goal is to move beyond simply identifying which group has the higher conversion rate and determine whether the observed difference is statistically convincing and large enough to be meaningful in a business context.

---

## Objective

The objective of this analysis is to answer:

> **Does the treatment variant perform differently from the control variant in terms of conversion rate?**

The analysis also quantifies **how large the difference is** and **how certain the estimate is**.

---

## Dataset

**Dataset:** `AB Testing Data.csv`

The dataset contains **294,478 observations** and **12 columns**:

- `user_id`
- `timestamp`
- `group`
- `landing_page`
- `converted`
- `age`
- `gender`
- `location`
- `session_duration`
- `pages_visited`
- `device_type`
- `purchase_amount`

### Dataset validation

- Total observations: **294,478**
- Unique users: **294,478**
- Duplicate rows: **0**
- Missing values: **0**
- Experiment groups: `control`, `treatment`
- Conversion values: `0`, `1`

The experiment groups are:

| Group | Users |
|---|---:|
| Control | 146,926 |
| Treatment | 147,552 |

The treatment/control split is closely balanced in sample size.

---

## Python Tools and Libraries

The analysis was implemented primarily with Python using:

### pandas
Used for:
- Loading the CSV dataset
- Data inspection
- Filtering control/treatment groups
- Aggregation and metric calculation
- Data-quality checks

### NumPy
Used for:
- Numerical calculations
- Effect-size calculations

### SciPy
Used for:
- Statistical cross-checking
- Chi-square analysis
- Normal-distribution calculations where required

### statsmodels
Used for:
- Two-proportion z-test
- Confidence intervals for proportions
- Confidence interval for the difference between two proportions

### Matplotlib
Used for:
- Visualizing control vs treatment conversion rates

---

## Analysis Workflow

```text
Load Dataset
      ↓
Inspect Structure
      ↓
Validate Data Quality
      ↓
Identify Control & Treatment
      ↓
Calculate Conversions
      ↓
Calculate Conversion Rates
      ↓
Calculate Absolute Difference
      ↓
Calculate Relative Lift
      ↓
State Hypotheses
      ↓
Two-Proportion Statistical Test
      ↓
Confidence Intervals
      ↓
Effect Size
      ↓
Statistical Significance
      ↓
Practical Interpretation
      ↓
Final Recommendation
```

---

## 1. Data Understanding

The dataset was first inspected to understand its structure, variables, data types, group labels and conversion values.

The experiment contains two groups:

- **Control**
- **Treatment**

The conversion variable is binary:

- `0` = did not convert
- `1` = converted

The dataset contains one unique `user_id` per observation, with no duplicate user IDs.

---

## 2. Conversion Metrics

### Control Group

- Sample size: **146,926**
- Conversions: **17,444**
- Non-conversions: **129,482**
- Conversion rate: **11.8726%**

### Treatment Group

- Sample size: **147,552**
- Conversions: **26,484**
- Non-conversions: **121,068**
- Conversion rate: **17.9489%**

### Comparison

| Metric | Control | Treatment |
|---|---:|---:|
| Users | 146,926 | 147,552 |
| Conversions | 17,444 | 26,484 |
| Non-Conversions | 129,482 | 121,068 |
| Conversion Rate | **11.87%** | **17.95%** |

---

## 3. Absolute Conversion-Rate Difference

The absolute difference is:

\[
Treatment\ Rate - Control\ Rate
\]

\[
17.9489\% - 11.8726\% = 6.0763\%
\]

Therefore:

> **Absolute improvement = 6.08 percentage points**

This represents the direct difference in conversion rates between the two variants.

---

## 4. Relative Lift

Relative lift is calculated as:

\[
\frac{Treatment\ Rate - Control\ Rate}{Control\ Rate}
\]

Result:

> **Relative lift = 51.18%**

The treatment conversion rate is therefore approximately **51.18% higher relative to the control conversion rate**.

---

## 5. Hypothesis Testing

### Null Hypothesis (H₀)

There is no difference in conversion rates between the control and treatment groups.

\[
H_0:p_T=p_C
\]

### Alternative Hypothesis (H₁)

There is a difference in conversion rates between the control and treatment groups.

\[
H_1:p_T\neq p_C
\]

A **two-proportion z-test** was selected because the analysis compares two independent groups using a binary conversion outcome.

---

## 6. Statistical Test Result

### Two-Proportion Z-Test

- Z-statistic: **46.2773**
- P-value: **approximately 1.57 × 10⁻⁴⁶⁷**
- Significance level: **0.05**

The p-value is far below 0.05.

### Interpretation

> The observed difference in conversion rates provides very strong statistical evidence against the null hypothesis.

The treatment and control groups therefore show a statistically significant difference in conversion performance.

The extremely small p-value may appear as `0.0` in some Python outputs because of floating-point display limits. This does **not** mean the probability is literally zero.

---

## 7. Confidence Intervals

### Control Conversion Rate

**11.71% – 12.04%**

Point estimate:

**11.87%**

### Treatment Conversion Rate

**17.75% – 18.15%**

Point estimate:

**17.95%**

### Difference in Conversion Rates

**5.82 – 6.33 percentage points**

Point estimate:

**6.08 percentage points**

The confidence interval for the treatment-control difference remains entirely above zero, supporting the observed positive difference.

---

## 8. Effect Size

Two business-friendly effect measures were used.

### Absolute Effect

**+6.08 percentage points**

### Relative Lift

**+51.18%**

An additional standardized measure was calculated:

### Cohen's h

**0.1714**

The absolute difference and relative lift are the primary effect measures because they are easier to interpret in a practical A/B testing context.

---

## 9. Statistical vs Practical Significance

### Statistical significance

The statistical test provides extremely strong evidence that the treatment and control conversion rates differ.

### Practical significance

The treatment produced:

- **+6.08 percentage-point improvement**
- **+51.18% relative lift**

This is a substantial observed effect.

However, practical significance ultimately depends on business context, such as implementation cost, expected incremental conversions/revenue and the organization's predefined threshold for an acceptable improvement.

Therefore, the analysis supports a strong statistical conclusion while the final business decision should also consider economic impact.

---

## 10. Key Findings

### Finding 1 — Higher treatment conversion rate

The treatment group achieved a **17.95% conversion rate**, compared with **11.87%** for the control group.

### Finding 2 — Large absolute improvement

The treatment increased conversion by **6.08 percentage points**.

### Finding 3 — Strong relative lift

The observed relative lift was **51.18%** compared with the control group.

### Finding 4 — Strong statistical evidence

The two-proportion z-test produced a statistic of **46.2773** with a p-value of approximately **1.57 × 10⁻⁴⁶⁷**, providing extremely strong evidence of a difference between the variants.

### Finding 5 — Uncertainty remains tightly bounded

The 95% confidence interval for the treatment-control difference is approximately **5.82 to 6.33 percentage points**, indicating a consistently positive estimated effect.

---

## 11. Python Implementation

Core metric calculation:

```python
import pandas as pd

df = pd.read_csv("AB Testing Data.csv")

control = df[df["group"] == "control"]
treatment = df[df["group"] == "treatment"]

n_control = len(control)
n_treatment = len(treatment)

x_control = control["converted"].sum()
x_treatment = treatment["converted"].sum()

control_rate = x_control / n_control
treatment_rate = x_treatment / n_treatment

absolute_difference = treatment_rate - control_rate
relative_lift = absolute_difference / control_rate
```

Two-proportion z-test:

```python
from statsmodels.stats.proportion import proportions_ztest

z_stat, p_value = proportions_ztest(
    [x_treatment, x_control],
    [n_treatment, n_control],
    alternative="two-sided"
)

print("Z-statistic:", z_stat)
print("P-value:", p_value)
```

Confidence intervals:

```python
from statsmodels.stats.proportion import (
    proportion_confint,
    confint_proportions_2indep
)

control_ci = proportion_confint(
    x_control,
    n_control,
    alpha=0.05,
    method="wilson"
)

treatment_ci = proportion_confint(
    x_treatment,
    n_treatment,
    alpha=0.05,
    method="wilson"
)

difference_ci = confint_proportions_2indep(
    x_treatment,
    n_treatment,
    x_control,
    n_control,
    compare="diff",
    method="newcomb",
    alpha=0.05
)
```

---

## 12. Conclusion

The A/B test shows a substantial improvement in observed conversion performance for the treatment variant.

The control group converted at **11.87%**, while the treatment group converted at **17.95%**. This corresponds to an absolute improvement of **6.08 percentage points** and a relative lift of **51.18%**.

The statistical evidence is extremely strong, with a **z-statistic of 46.2773** and a p-value of approximately **1.57 × 10⁻⁴⁶⁷**. The 95% confidence interval for the difference ranges from approximately **5.82 to 6.33 percentage points**.

Based on the statistical evidence and observed effect size, the treatment demonstrates strong evidence of improved conversion performance. A final production decision should additionally consider implementation costs, expected business impact and an agreed practical-effect threshold.

---

## 13. Project Deliverables

- Python-based A/B test analysis
- Control vs treatment comparison
- Conversion-rate analysis
- Absolute difference
- Relative lift
- Two-proportion z-test
- Confidence intervals
- Effect-size analysis
- Statistical significance interpretation
- Practical significance discussion
- Final data-supported conclusion

---

## 14. Key Result Summary

| Result | Value |
|---|---:|
| Control Conversion Rate | **11.87%** |
| Treatment Conversion Rate | **17.95%** |
| Absolute Difference | **+6.08 pp** |
| Relative Lift | **+51.18%** |
| Z-statistic | **46.2773** |
| P-value | **≈ 1.57 × 10⁻⁴⁶⁷** |
| 95% CI for Difference | **5.82 to 6.33 pp** |
| Cohen's h | **0.1714** |

LINKEDIN: [link](https://lnkd.in/p/dTst_nMt)