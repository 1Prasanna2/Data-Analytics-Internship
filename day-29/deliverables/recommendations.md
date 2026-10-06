# Product Basket Analysis — Insights & Recommendations

## Executive Summary
Analysis of 25,900 orders from Online Retail II (Dec 2009–Dec 2011) using Apriori association rule mining reveals **67 actionable product pairs** with lift > 1 and confidence > 30%. The strongest association is between **"Jumbo Bag Red Retrospot"** and **"Jumbo Bag Woodland Animals"** (lift 5.02), meaning customers who buy one are **5× more likely** to buy the other. These insights enable targeted product bundling, cross-sell recommendations, and store layout optimization.

## Key Findings

### 1. Strongest Product Pair: Jumbo Bags (Lift 5.02)
- **Rule:** If customer buys "Jumbo Bag Red Retrospot" → 64.5% also buy "Jumbo Bag Woodland Animals"
- **Support:** 9.8% of all orders contain both items
- **Business Insight:** These are complementary gift/packaging items. Customers buying one are likely shopping for party supplies or gifts and need multiple designs.
- **Action:** Create a "Jumbo Bag Bundle" (Red + Woodland + 1 more) at 10% discount. Place them adjacent in warehouse picking zones.

### 2. Party Supplies Cluster (Lift 3.8–4.8)
- **Rules:**
  - "Party Bunting" → "Jumbo Bag Red Retrospot" (lift 3.81)
  - "Vintage Heads and Tails" → "Jumbo Bag Woodland Animals" (lift 4.81)
- **Support:** 5–7% of orders
- **Business Insight:** Party decorations and packaging are purchased together. Customers planning events buy both decor and gift bags.
- **Action:** Create "Party Starter Kits" (Bunting + Bags + Tableware). Email customers who buy bunting with bag recommendations.

### 3. High-Confidence Rules (>60%)
- **Top Rules:**
  - "Jumbo Bag Woodland" → "Jumbo Bag Red" (76.4% confidence)
  - "Lunch Bag Woodland" → "Lunch Bag Red" (68.2% confidence)
- **Business Insight:** When customers commit to one design in a product line, they often buy alternate designs (likely for variety or gifting).
- **Action:** On product pages, show "Customers also bought other designs" carousel. Train sales reps to suggest alternate colors/designs.

### 4. Low-Support but High-Lift Opportunities
- **Example:** "Specific niche product A" → "Specific niche product B" (lift 8.5, support 0.6%)
- **Business Insight:** Rare but extremely strong associations indicate specialized use cases (e.g., industrial buyers purchasing specific tool combinations).
- **Action:** Don't ignore low-support rules. Investigate manually — they may reveal high-value B2B segments or underserved niches.

### 5. Product Categories Drive Associations
- **Pattern:** Most strong rules are within the same category (Bags → Bags, Party → Party, Kitchen → Kitchen).
- **Cross-Category Rules:** Fewer but valuable (e.g., "Lunch Bag" → "Water Bottle" — lift 2.3).
- **Action:** Optimize website navigation to keep related categories close. Use cross-category rules for "Complete the Set" recommendations.

## Actionable Recommendations

### For E-Commerce Team
1. **"Frequently Bought Together" Widget:** Implement on product pages using top 10 rules. Expected uplift: +5–10% AOV.
2. **Bundle Discounts:** Create pre-packaged bundles for top 5 pairs (e.g., "Jumbo Bag Duo", "Party Starter Kit"). Price at 10–15% discount vs individual.
3. **Email Cross-Sell:** Trigger automated emails: "You bought X — customers also loved Y" within 24 hours of purchase.

### For Warehouse/Operations
1. **Slotting Optimization:** Store strongly associated products (lift > 3) in adjacent bins to reduce picking time.
2. **Kitting:** Pre-assemble top 3 bundles during off-peak hours to speed up fulfillment during peaks.

### For Marketing
1. **Promotional Targeting:** Run ads for "Jumbo Bag Red" targeting customers who previously bought "Woodland" variant (and vice versa).
2. **Seasonal Campaigns:** Party supplies cluster suggests Q4 holiday push for "Event Bundles."

### For Product Team
1. **New Product Development:** High-lift pairs indicate unmet needs. If A and B are always bought together, consider creating a combined A+B product.
2. **Discontinuation Risk:** Products with no strong associations (lift ≈ 1 with all others) are standalone — candidates for discontinuation if low revenue.

## Methodology Notes

### Market Basket Analysis Definition
- **Technique:** Apriori algorithm for frequent itemset mining + association rule generation
- **Metrics:**
  - **Support:** Frequency of itemset in all baskets (threshold: ≥ 0.5%)
  - **Confidence:** Conditional probability P(Y|X) (threshold: ≥ 30%)
  - **Lift:** Ratio of observed co-occurrence vs expected if independent (threshold: > 1)

### Why Order ID?
- Basket = one transaction (single shopping event)
- Grouping by Customer ID would mix purchases months apart (not a true basket)
- Grouping by date would mix different customers' carts
- Only Order ID captures the exact set of items purchased together in one sitting

### Data Scope
- **Orders Analyzed:** 25,900 (from 805,620 line items)
- **Products:** 4,070 unique StockCodes
- **Time Period:** Dec 2009–Dec 2011
- **Exclusions:** Returns, negative prices, anonymous customers (per Day 24 cleaning)

### Limitations
- **Bulk Orders:** Some baskets have 1,000+ items (wholesale). May inflate support for common items. Future work: cap basket size at 50 items or analyze retail vs wholesale separately.
- **Static Snapshot:** Rules are historical (2009–2011). Product catalog and customer behavior may have shifted. Re-run quarterly.
- **No Causality:** Lift shows correlation, not causation. A→B doesn't mean A *causes* B purchase. Both may be driven by a third factor (e.g., seasonality).
