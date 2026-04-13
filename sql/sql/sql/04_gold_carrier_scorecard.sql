USE SCHEMA freight_analytics.gold;

CREATE TABLE carrier_scorecard AS
SELECT
  carrier_name,
  carrier_type,
  carrier_hq_state,
  COUNT(*)                                             AS total_shipments,
  ROUND(AVG(days_delayed), 1)                          AS avg_days_delayed,
  ROUND(SUM(CASE WHEN delivery_status = 'On Time'
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS on_time_pct,
  ROUND(SUM(CASE WHEN carrier_controllable = TRUE
                  AND delivery_status = 'Late'
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS controllable_delay_pct,
  ROUND(AVG(freight_cost_usd), 2)                      AS avg_cost_usd,
  ROUND(SUM(freight_cost_usd), 2)                      AS total_revenue_usd
FROM freight_analytics.silver.clean_shipments
GROUP BY carrier_name, carrier_type, carrier_hq_state
ORDER BY on_time_pct DESC;
