## Freight Delay & Cost Analytics Pipeline

**Live Dashboard:** https://public.tableau.com/app/profile/angel.rivera1436/viz/Freight-Delay-Cost-Analytics/Dashboard1

## Overview
End-to-end logistics analytics pipeline analyzing freight delay patterns,
carrier performance, and fuel cost correlation across 600 shipments and
10 real LTL carriers. Built using AWS S3, Snowflake, and Tableau following
medallion architecture (Bronze / Silver / Gold).

## Tools & Technologies
- **Storage:** AWS S3 (Bronze layer)
- **Data Warehouse:** Snowflake
- **Visualization:** Tableau Public
- **Languages:** SQL

## Data Model — 5-Table Star Schema
| Table | Rows | Description |
|---|---|---|
| shipments | 600 | Main fact table — shipment records with foreign keys |
| carriers | 10 | Real LTL carriers (FedEx Freight, Old Dominion, XPO, etc.) |
| cities | 15 | Origin/destination cities with region |
| delay_codes | 7 | Delay categories with carrier_controllable flag |
| fuel_prices | 420 | Weekly diesel prices by region, 2023-2024 |

## Pipeline Architecture
```
Raw CSVs → AWS S3 (Bronze) → Snowflake Silver (cleaned + joined)
→ Snowflake Gold (aggregated) → Tableau Dashboard
```

## Key SQL Techniques
- Multi-table JOINs across 5 tables including a self-join on cities
- DATEDIFF to calculate days delayed per shipment
- DATE_TRUNC for monthly trend aggregation
- CASE WHEN for delivery status and controllable delay flags
- RANK() OVER (PARTITION BY) window function for carrier delay ranking
- Compound JOIN conditions matching on date AND region

## Dashboard Views
1. **Carrier On-Time Performance** — all 10 LTL carriers ranked by on-time %
2. **Delay Responsibility Breakdown** — controllable vs uncontrollable delays
   with average reference line
3. **Fuel Price vs Freight Cost** — scatter plot with trend line showing
   correlation between diesel prices and freight costs
4. **Monthly Delay Trend by Region** — dual-axis line chart across 4 regions

## Key Findings
- Old Dominion Freight Line ranked #1 in on-time performance at 52.4%
- Estes Express Lines and XPO had the highest total delay occurrences
- Strong positive correlation between diesel price spikes and freight costs
- Southeast region showed the highest average delay days

## Background
Built to demonstrate end-to-end data analytics skills for logistics and
supply chain analyst roles. Domain knowledge informed by 10+ years of
hands-on experience in CDL driving, owner-operator container hauling
at the Port of Savannah, and freight operations.freight-analytics-pipeline
Freight Delay &amp; Cost Analytics Pipeline
