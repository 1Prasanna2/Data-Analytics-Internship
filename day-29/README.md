# Product Basket Analysis

## Overview

Product Basket Analysis was performed to understand which products are purchased together within the same customer order. The analysis uses transaction-level retail data and treats each valid invoice as a product basket.

The main purpose of this task was to identify product combinations and association patterns that can support business decisions such as cross-selling, product bundling, recommendation strategies, and store or website placement.

The analysis was performed in Python using transactional basket data and association-rule techniques.

## How the Analysis Was Done

### 1. Basket creation

The transaction data was grouped by invoice so that each invoice represented one basket containing the products purchased in that order.

The analysis created **36,975 baskets**, with an average of **21.1 products per basket**. Basket size ranged from **1 product to 542 products**.

This transformation is important because association analysis works on the relationship between products within the same purchase rather than on individual transaction rows.

### 2. Basket encoding

The baskets were converted into a binary product matrix in which each row represents an order and each product becomes a column.

The resulting matrix contained:

- **36,975 orders**
- **4,631 products**
- **768,925 non-zero product entries**
- Approximately **99.6% zeros**
- Approximately **0.45% of the matrix cells were non-zero**

The high sparsity is expected in basket analysis because an individual order contains only a small subset of all available products.

### 3. Frequent itemset discovery

The Apriori algorithm was used to identify products and product combinations that occur frequently across baskets.

A minimum support threshold of **1%** was used for the initial frequent-itemset analysis.

This produced **860 frequent itemsets** with support of at least 0.01.

The purpose of this stage was to reduce the analysis to combinations that occur often enough to be meaningful before generating association rules.

### 4. Association-rule generation

Association rules were generated from the frequent itemsets using a minimum confidence threshold of **30%**.

This produced **513 association rules** with confidence of at least 0.30.

The resulting rules were then reviewed using support, confidence, and lift so that associations could be evaluated from multiple perspectives.

The filtering stage retained **513 actionable rules** after excluding:

- Self-pairs
- Very low-support rules below 0.5%
- Rules with lift less than or equal to 1

### 5. Product-name mapping

Product stock codes were mapped back to product descriptions so that the final results could be interpreted in business terms rather than only through product identifiers.

This made the association rules easier to communicate and suitable for reporting and decision-making.

### 6. Association strength analysis

The main metrics used were:

**Support** – the proportion of baskets containing the product combination.

**Confidence** – the probability of purchasing the consequent product when the antecedent product or combination is purchased.

**Lift** – how much more frequently the consequent is purchased with the antecedent compared with the expected frequency if the products were independent.

A lift greater than 1 indicates a positive association.

## Results

Several strong product relationships were identified.

For example:

- **Edwardian Parasol Natural → Edwardian Parasol Black** had approximately **1.13% support**, **48.55% confidence**, and **42.84 lift**.
- **Edwardian Parasol Black → Edwardian Parasol Natural** had approximately **1.13% support**, **53.17% confidence**, and **46.92 lift**.
- **Edwardian Parasol Red → Edwardian Parasol Black** had approximately **1.04% support**, **62.06% confidence**, and **59.45 lift**.
- **Jumbo Bag Woodland Animals → Jumbo Bag Red White Spotty** had approximately **1.35% support**, **54.43% confidence**, and **40.41 lift**.
- **Jumbo Bag Owls → Jumbo Storage Bag Suki** had approximately **1.09% support**, **43.70% confidence**, and **40.19 lift**.

These values show that some product pairs have a much stronger purchasing relationship than would be expected from the individual product frequencies alone.

## Business Uses

Product Basket Analysis can support several practical business decisions.

### Cross-Selling

Products that frequently occur together can be recommended to customers during checkout or product browsing.

For example, when a customer purchases one product from a strong association, the related product can be presented as a complementary recommendation.

### Product Bundling

Strong associations can be used to design product bundles or promotional packages.

Products that repeatedly appear together can be grouped into convenient offers that encourage customers to purchase multiple products in one transaction.

### Store and Website Placement

Products with strong relationships can be placed closer together in physical stores or displayed together in an online shopping interface.

This can reduce the effort required for customers to find complementary products.

### Recommendation Systems

Association rules can provide a simple business rule layer for recommendation systems.

For example, a rule of the form:

**If a customer buys Product A → recommend Product B**

can be implemented as a product recommendation.

### Promotion Design

Association patterns can help identify products that could be promoted together rather than independently.

This can support targeted promotions and cross-selling campaigns.

### Inventory and Merchandising

Frequently associated products can be considered together when planning merchandising and stock availability, particularly when an increase in demand for one product is likely to be accompanied by demand for another.

## How the Results Should Be Interpreted

Support, confidence, and lift should be considered together.

A rule with very high lift but extremely low support may represent a strong relationship that occurs in very few orders. Such a rule may be interesting but may not have enough transaction volume to support a large-scale business decision.

A rule with high support and useful confidence may be more practical for broad merchandising or recommendation use.

Therefore, the analysis does not rely on lift alone. The final rules were reviewed using multiple measures and filtered to remove weak or non-actionable associations.

## Key Outcome

The analysis successfully transformed **36,975 customer orders** into a basket representation covering **4,631 products** and identified **860 frequent itemsets** using a 1% support threshold.

Association-rule generation produced **513 rules** with at least 30% confidence. After additional filtering for support and positive lift, **513 actionable rules** remained for interpretation.

The strongest observed relationships included product pairs with lift values above **40**, showing that some products were purchased together far more often than would be expected by chance.

## Business Decision Support

The analysis can help a business decide:

- Which products should be recommended together
- Which products could be bundled
- Which combinations are suitable for cross-selling
- Which products may benefit from joint promotions
- Which products should be displayed near each other
- Which product relationships are strong enough to investigate further

The main value of Product Basket Analysis is therefore not simply identifying frequently purchased products, but understanding **relationships between products within the same customer purchase** and turning those relationships into practical merchandising, recommendation, and cross-selling opportunities.

## Conclusion

Product Basket Analysis provides a data-driven way to understand customer purchasing combinations.

By converting invoices into baskets, encoding product presence, discovering frequent itemsets, and evaluating association rules using support, confidence, and lift, the analysis identifies product relationships that can be used to support better recommendations, bundling, promotions, merchandising, and cross-selling decisions.

The results should be treated as **association patterns rather than proof of causation**. A strong association means products are frequently purchased together; it does not by itself prove that purchasing one product causes customers to purchase the other.


LINKEDIN: [link](https://lnkd.in/p/dPE5bRPx)