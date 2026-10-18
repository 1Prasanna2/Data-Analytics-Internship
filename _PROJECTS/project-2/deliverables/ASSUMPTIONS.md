
## Day 1
- OWID_* aggregates excluded: 34,124 of 429,435 rows (-> 395,311 real-country rows)
- Countries (iso_code): BRA, DEU, GBR, IND, ISR, USA, ZAF
- ROLL=7, MIN_PERIODS=3; rolling from new_* / *_per_million (totals never differenced)
- Provisional tail TAIL=14d dropped; cut date 2024-07-29 (raw max was 2024-08-14)
- Reindexed to continuous daily calendar so shift()/roll() are day-aligned (not row-aligned)
- Comparisons normalized to per-million / per-100 (brief hint #2)
