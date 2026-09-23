# 📊 Day 16 — Profit Analysis by Category: Who Earns, and *Why*

- 45-Day Data Analytics Internship · Level 1 · Day 16
- Tool: Microsoft Excel (SUMIFS / COUNTIF / INDEX-MATCH + a column chart) 
- Dataset: Sample Superstore — 9,994 order lines · 21 columns
- Objective: *compare total profit across product categories* — then go past the headline and explain **why** each category earns what it earns

---

## 🎯 Task & Scope

Build a category-level profit analysis (total profit, margin, order lines, average profit per
line), surface the top / lowest performers, break it down to sub-category, chart it, and write a
narrative. The day then went three layers deeper via follow-up questions:

1. Is **Technology** broadly profitable, or propped up by a few products?
2. Does a category earn more because it sells **more orders**, or because each order is **more profitable**?
3. What is the **average profit per order line** by category — and what does it decompose into?

**Deliverables produced:**
- Category profit table + 3 performer cards + column chart ✅
- 17-row sub-category breakdown ✅ (with a reconciliation fix — see ⚠️)
- Narrative paragraph ✅ (corrected version below; the on-sheet draft was stale)
- Three analytical deep-dives with formula proofs ✅

---

## 🗂 Workbook Structure (`Day-16_Profit_Analysis.xlsx`)

| Tab | Role |
|---|---|
| `Data` | Raw Superstore → Excel Table **`Superstore`**, frozen header, untouched |
| `Profit Summary` | Category table (rows 4–8), performer cards, sub-category table (rows 11–27), column chart, narrative box |

Layout assumed by the formulas below — category table: `A`=Category, `B`=Sales, `C`=Profit,
`D`=Margin %, `E`=Order Lines, `F`=Avg Profit/Line; data rows **5–7**, totals row **8**.
Extension columns: `G`=Profit-at-avg-rate, `H`=Rate effect, `I`=Verdict, `J`=Avg Sales/Line.

---

## 🧮 Deliverable 1 — Category Profit Table + Cards + Chart

| Category | Total Sales | Total Profit | Margin % | Order Lines | Avg Profit / Line |
|:---|--:|--:|--:|--:|--:|
| Furniture | $742,000 | $18,451 | 2.5% | 2,121 | **$8.70** |
| Office Supplies | $719,047 | $122,491 | 17.0% | 6,026 | **$20.33** |
| Technology | $836,154 | $145,455 | 17.4% | 1,847 | **$78.75** |
| **TOTAL** | **$2,297,201** | **$286,397** | **12.5%** | **9,994** | **$28.66** |

**Formulas (row 5, fill down):**
```excel
B5  =SUMIFS(Superstore[Sales],  Superstore[Category],$A5)
C5  =SUMIFS(Superstore[Profit], Superstore[Category],$A5)
D5  =C5/B5
E5  =COUNTIF(Superstore[Category],$A5)
F5  =C5/E5
B8  =SUM(B5:B7)   ...   D8 =C8/B8   F8 =C8/E8      (control row)
```

**Performer cards (INDEX/MATCH over the table):**
```excel
Top category by profit      =INDEX($A$5:$A$7,MATCH(MAX($C$5:$C$7),$C$5:$C$7,0))   → Technology
Highest profit margin       =INDEX($A$5:$A$7,MATCH(MAX($D$5:$D$7),$D$5:$D$7,0))   → Technology
Lowest profit margin        =INDEX($A$5:$A$7,MATCH(MIN($D$5:$D$7),$D$5:$D$7,0))   → Furniture
```

**Chart:** clustered **column** chart, *Total Profit by Product Category*, data labels on,
y-axis titled `Total Profit ($)`, x-axis `Product Category` (3 bars — well inside the ≤5-slice
chart-type discipline from Day 7).

> 💡 The chart's whole point is the asymmetry it makes obvious: **Technology has the fewest
> order lines yet the tallest profit bar.** Volume and profit are not the same story.

---

## 📉 Deliverable 2 — Sub-Category Breakdown (17 rows)

Sorted by profit; `B`=SUMIFS profit, `C`=SUMIFS sales, `D`=B/C, filled from row 12 down.

| Sub-Category | Total Profit | Total Sales | Margin % |
|:---|--:|--:|--:|
| Copiers | $55,618 | $149,528 | 37.2% |
| Phones | $44,516 | $330,007 | 13.5% |
| Accessories | $41,937 | $167,380 | 25.1% |
| Paper | $34,054 | $78,479 | 43.4% |
| Binders | $30,222 | $203,413 | 14.9% |
| Chairs | $26,590 | $328,449 | 8.1% |
| Storage | $21,279 | $223,844 | 9.5% |
| Appliances | $18,138 | $107,532 | 16.9% |
| Furnishings | $13,059 | $91,705 | 14.2% |
| Envelopes | $6,964 | $16,476 | 42.3% |
| Art | $6,528 | $27,119 | 24.1% |
| Labels | $5,546 | $12,486 | 44.4% |
| Machines | $3,385 | $189,239 | 1.8% |
| Fasteners | $950 | $3,024 | 31.4% |
| **Tables** ⚠️ | **−$17,727** | **$206,966** | **−8.6%** |
| Supplies | −$1,189 | $46,674 | −2.5% |
| Bookcases | −$3,473 | $114,880 | −3.0%|
| **Σ (must = control)** | **$286,397** | **$2,297,201** | — |

> ⚠️ **The reconciliation catch (the day's most valuable moment).** The workbook's visible
> sub-category list was missing **Tables** (the row was cut off below the scroll). Summing the
> column as-shown gave **$304,124** profit / **$2,090,235** sales — *disagreeing* with the
> $286,397 / $2,297,201 control totals by exactly **−$17,727 / −$206,966**, which is precisely
> one missing sub-category. Back-solving recovered **Tables at −$17,727 on $206,966 (−8.6%)**,
> and the column then reconciled to the penny. Two consequences nobody would have noticed
> without the control-total check:
> 1. **Tables — not Bookcases or Supplies — is the single largest loss sub-category** (−$17,727,
>    ~5× Bookcases' −$3,473), and also the worst by margin (−8.6%). The truncated table had
>    silently implied Bookcases was the culprit.
> 2. Tables is the *same* problem child flagged on Day 11 (203 loss lines) and Day 15 — now
>    quantified in dollars.
>
> **Rule adopted:** *always* sum a breakdown column against its control total before believing
> the list is complete. A truncated breakdown looks perfectly tidy.

---

## 🔬 Deep-Dive A — Is Technology Broadly Profitable, or One Hero Product?

**Verdict: broadly profitable at the sub-category level — but the *depth* rests on a few
families, and one family (Machines) is a profit ghost.** Isolating Technology's four members:

| Tech Sub-Category | Profit | % of Tech Profit | Sales | % of Tech Sales | Margin |
|:---|--:|--:|--:|--:|--:|
| Copiers | $55,618 | 38.2% | $149,528 | 17.9% | 37.2% |
| Phones | $44,516 | 30.6% | $330,007 | 39.5% | 13.5% |
| Accessories | $41,937 | 28.8% | $167,380 | 20.0% | 25.1% |
| **Machines** | **$3,385** | **2.3%** | **$189,239** | **22.6%** | **1.8%** |
| **Technology** | **$145,455** | 100% | **$836,154** | 100% | 17.4% |

- **Not a single-product fluke:** all four sub-categories net positive; the top two profit
  engines (Copiers + Accessories) deliver **67% of category profit on only 38% of sales** — a
  diversified margin base.
- **Machines is the drag:** 22.6% of revenue → 2.3% of profit. Delete Machines and Technology's
  margin jumps from 17.4% to **~22%** ($142,070 on $646,915). That is the action item.
- **At product level** a minority of discounted Phones and certain Machines sell at a loss
  (filter `Category=Technology, Profit<0`), but their combined negative never tips any
  sub-category negative — which is *why* "profitable overall" and "every product profitable"
  are different claims. (Per Day 9: a positive mean hides a negative tail.)

---

## 🔬 Deep-Dive B — Volume vs Rate: Do Categories Earn from Orders or from Margin?

Decompose profit as **Profit = Order Lines × Avg Profit per Line**, benchmarked to the company
average of **$28.66/line** (precisely $28.657):

| Category | Lines | Actual Profit | Profit @ Avg Rate (`E×$28.657`) | **Rate Effect** (`C−G`) | Reading |
|:---|--:|--:|--:|--:|:---|
| Furniture | 2,121 | $18,451 | $60,781 | **−$42,330** | Each line far below avg profitability |
| Office Supplies | 6,026 | $122,491 | $172,687 | **−$50,196** | Earns on volume, but weak per line |
| Technology | 1,847 | $145,455 | $52,929 | **+$92,526** | Earns *disproportionately* per line |
| **Total** | 9,994 | $286,397 | $286,397 | **$0** | Effects balance ✓ |

Share-of-profit vs share-of-volume (the executive view):

| Category | % of Lines | % of Profit | Gap | Driver |
|:---|--:|--:|--:|:---|
| Furniture | 21.2% | 6.4% | **−14.8 pts** | Under-monetizes its volume |
| Office Supplies | 60.3% | 42.8% | **−17.5 pts** | **Volume-driven** |
| Technology | 18.5% | 50.8% | **+32.3 pts** | **Profitability-driven** |

**Answer to the question:** it is category-specific — *Technology earns more because each order
line is dramatically more profitable (not because it sells more lines); Office Supplies earns
through sheer volume despite thin per-line profit; Furniture is weak on both, especially rate.*

```excel
G5 =E5*$F$8            (F8 = company avg profit/line = C8/E8)
H5 =C5-G5              (rate effect; +ve = beats avg per line)
I5 =IF(H5>0,"Profitability-driven","Volume/Rate drag")
J5 =B5/E5              (avg sales per line — see Deep-Dive C)
```

---

## 🔬 Deep-Dive C — Average Profit per Order Line, and What It Splits Into

The `F` column *is* this metric: **Furniture $8.70 · Office Supplies $20.33 · Technology $78.75**
vs company **$28.66** → Technology earns **~9.05×** Furniture and **~3.87×** Office Supplies per
line. But a per-line average is not magic — it factorises:

> **Avg Profit / Line = Profit Margin × Avg Sales / Line**

| Category | Margin | Avg Sales / Line | = Avg Profit / Line | The real story |
|:---|--:|--:|--:|:---|
| Furniture | 2.5% | $349.83 | $8.70 | Decent line size, **broken conversion** |
| Office Supplies | 17.0% | $119.32 | $20.33 | Healthy margin, **tiny baskets** |
| Technology | 17.4% | $452.71 | $78.75 | **Strong on both axes** |

Read across the rows and the strategy flips out: Office Supplies and Technology share almost the
*same* margin (~17%) yet differ ~4× in per-line profit — the gap is pure basket size ($119 vs
$453). Furniture has *bigger* baskets than Office Supplies but earns half as much per line,
because its 2.5% margin is the problem, not its volume. So the fix differs per category:
**Furniture → discount/margin discipline; Office Supplies → bundle to grow line size;
Technology → protect the model.**

```excel
Identity check (row 5):  =IF(ABS(F5-D5*J5)<=0.05,"✅","❌")   (tolerance for rounded margins)
Tech ÷ Furniture:         =($C$7/$E$7)/($C$5/$E$5)   → 9.05×
Tech ÷ Off-Supplies:      =($C$7/$E$7)/($C$6/$E$6)   → 3.87×
```

> ⚠️ These are **net** averages. Inside every positive category sit losing sub-categories
> (Tables −$17,727, Bookcases −$3,473, Supplies −$1,189), so "$8.70/line" means *the wins and
> losses of 2,121 lines net to that* — never "a typical Furniture line makes $8.70." Pair each
> average with its loss-line share or median before quoting it as typical (Day 9 rule).

---

## ⚠️ Pre-Submit Fixes (do these before sharing)

1. **Stale narrative box.** The on-sheet paragraph quotes *Furniture ≈ $28,639 / 3.8%* and
   *Technology ≈ $145,267*, but the live table (and the sub-category sum) say **$18,451 / 2.5%**
   and **$145,455**. Only Office Supplies ($122,491) matched. Regenerate the two wrong figures
   from the table — a reviewer spotting a text-vs-table mismatch undercuts an otherwise clean
   analysis.
2. **Add the missing `Tables` row** to the sub-category table (and re-sort); without it the
   column fails the control-total check and wrongly crowns Bookcases the worst sub-category.
3. **Rounding tolerance.** Identity / reconciliation checks use `ABS(...)<=0.05` (or `<0.01`
   for money), not `=`, because displayed margins are rounded to 1 dp.

**Corrected narrative (drop-in replacement for the box):**
> Technology generates the most profit ($145,455) from the *fewest* order lines (1,847), because
> each line is ~9× more profitable than Furniture's — a profitability-driven category. Office
> Supplies is the opposite: 6,026 lines (60% of all volume) yield $122,491, a volume-driven
> profile with thin per-line profit. Furniture earns least ($18,451) not for lack of basket size
> but for a broken 2.5% margin. Beneath the totals, the sub-category view shows the profit is
> concentrated in high-margin niches (Copiers 37.2%, Labels 44.4%, Paper 43.4%, Envelopes 42.3%)
> while **Tables (−$17,727), Bookcases (−$3,473) and Supplies (−$1,189)** bleed cash — and within
> Technology, **Machines** soaks up 23% of revenue for 2% of profit. High sales volume alone does
> not guarantee profit; per-line economics decide the winner.

---

## 💡 Headline Findings
- **Technology = profitability-driven** (+$92,526 rate effect); **Office Supplies = volume-driven**
  (−$50,196); **Furniture = margin-constrained** (−$42,330).
- **Per-line profit = margin × line size**, and the two failing categories fail on *different*
  axes (Furniture on margin, Office Supplies on basket size).
- **Tables is the true biggest loser** (−$17,727), discovered only via the control-total check.
- **Machines is Technology's profit ghost** — strip it and the category margin rises ~5 pts.
- The count-leader (Office Supplies, 6,026 lines) ≠ the profit-leader (Technology, $145,455).

## 📚 Lessons Learned
- A category can top total profit on the *fewest* transactions — always read profit alongside
  line count, never in isolation.
- **Decompose before concluding:** `Profit = Lines × Profit/Line`, and `Profit/Line = Margin ×
  Sales/Line`. The factors tell you *which lever* to pull.
- **Control totals are non-negotiable** for any breakdown — they caught a truncated table that
  would have mis-named the worst sub-category.
- "Profitable overall" ≠ "every product profitable"; net averages hide negative tails.
- Narrative text must be regenerated from the live table, not edited by hand (the stale-box bug).
- Rounded inputs need tolerance-based checks (`ABS(…)<=ε`), not exact equality.

---

## 📁 Folder Contents
```
day-16-profit-analysis/
├── README.md
├── Day-16_Profit_Analysis.xlsx          # Data tab + Profit Summary 
├── data/Sample - Superstore.csv         # input (9,994 order lines)
├── assets/                              
└── docs/Day-16-Internship_Report.pdf
```

## 🔁 How to Reproduce
1. Data Tab -> Insert Text/CSV → Load File → Name Table as `Superstore` → freeze row 1.
2. Build the category table with the SUMIFS/COUNTIF formulas above; add the `G/H/I/J`
   decomposition columns; fill the three INDEX/MATCH cards.
3. Build the 17-row sub-category table; **run `=SUM()` on profit & sales and assert equality
   with the control row** (this is how `Tables` gets recovered).
4. Insert the clustered column chart; paste the *corrected* narrative.
5. Optional: `python profit_analysis.py` to confirm every figure independently.

## 🔗 Series
[Day 15 – Product Counts](../day-15-product-counts/) · 
**Day 16 – Profit Analysis** ·
LinkedIn post: [link](https://lnkd.in/p/dgBuzu_8)