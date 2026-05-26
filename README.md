# SQL Data Analysis — Customer & Product Reporting

Exploratory and advanced SQL analytics project using SQL Server Management Studio.
Covers the full analytical workflow from data profiling and classification through
to structured customer and product reports.

---

## Analytical Techniques

| Technique | File |
|-----------|------|
| Time-series trend analysis | `change_over_time.sql` |
| Cumulative running totals | `cumulative_analysis.sql` |
| Customer and product segmentation | `data_segmentation.sql` |
| Part-to-whole contribution analysis | `part_to_whole.sql` |
| Performance vs. benchmark | `performance_analysis.sql` |

Exploratory analysis covers dimension and measure profiling, date range analysis,
magnitude rankings, and database structure exploration.

Final reports compile all analytical layers into structured deliverables:
- `customer_report.sql` — customer behaviour, segmentation, and sales contribution
- `product_report.sql` — product performance, category trends, and ranking analysis

---

## How to Run

**Prerequisites**: SQL Server, SQL Server Management Studio (SSMS)

**Option 1 — restore from backup:**
1. Restore `resources/DataWarehouseAnalytics.bak` in SSMS
2. Open and run any script in `exploratory_analysis/` or `advanced_data_analytics_project/`

**Option 2 — import from flat files:**
1. Create a new database in SSMS
2. Import `dim_customers.csv`, `dim_products.csv`, and `fact_sales.csv`
   from `resources/flat-files/`
3. Run scripts in order: exploratory analysis → foundational analytics → reports

---

## Key SQL Techniques

- Window functions — `ROW_NUMBER`, `RANK`, `LAG`/`LEAD`, running totals
- Time-series aggregations and year-over-year comparisons
- Customer and product segmentation with CASE logic
- Part-to-whole analysis using subqueries
- Performance benchmarking against period averages
- CTEs for multi-step analytical logic

---

## Tech Stack

- **Language**: SQL
- **Environment**: SQL Server Management Studio (SSMS)
- **Source data**: ~5MB across customer, product, and sales flat files

---

## License

MIT — free to use with attribution.
