USE SCHEMA freight_analytics.gold;

CREATE TABLE monthly_trends AS
SELECT
  DATE_TRUNC('month', scheduled_delivery_date) AS shipment_month,
  origin_region,
  COUNT(*)                                      AS total_shipments,
  ROUND(AVG(days_delayed), 1)                   AS avg_delay_days,
  ROUND(SUM(CASE WHEN delivery_status = 'On Time'
            THEN 1 ELSE 0 END) * 100.0
            / COUNT(*), 1)                      AS on_time_pct,
  ROUND(SUM(freight_cost_usd), 2)               AS total_freight_cost,
  ROUND(AVG(freight_cost_usd), 2)               AS avg_freight_cost
FROM freight_analytics.silver.clean_shipments
GROUP BY DATE_TRUNC('month', scheduled_delivery_date), origin_region
ORDER BY shipment_month, origin_region;
