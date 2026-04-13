USE SCHEMA freight_analytics.gold;

CREATE TABLE delay_analysis AS
SELECT
  carrier_name,
  delay_category,
  carrier_controllable,
  COUNT(*)                            AS occurrence_count,
  ROUND(AVG(days_delayed), 1)         AS avg_days_delayed,
  ROUND(AVG(freight_cost_usd), 2)     AS avg_cost_when_delayed,
  RANK() OVER (
    PARTITION BY carrier_name
    ORDER BY COUNT(*) DESC
  )                                   AS delay_rank_for_carrier
FROM freight_analytics.silver.clean_shipments
WHERE delivery_status = 'Late'
GROUP BY carrier_name, delay_category, carrier_controllable
ORDER BY carrier_name, occurrence_count DESC;
