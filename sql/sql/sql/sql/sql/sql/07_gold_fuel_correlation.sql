USE SCHEMA freight_analytics.gold;

CREATE TABLE fuel_cost_correlation AS
SELECT
  DATE_TRUNC('month', s.scheduled_delivery_date) AS shipment_month,
  s.carrier_name,
  s.origin_region,
  ROUND(AVG(f.diesel_price_per_gallon), 3)        AS avg_diesel_price,
  ROUND(AVG(s.freight_cost_usd), 2)               AS avg_freight_cost,
  COUNT(*)                                        AS shipment_count
FROM freight_analytics.silver.clean_shipments s
JOIN freight_analytics.bronze.fuel_prices f
  ON DATE_TRUNC('month', s.scheduled_delivery_date)
   = DATE_TRUNC('month', f.price_date)
 AND f.region = s.origin_region
GROUP BY
  DATE_TRUNC('month', s.scheduled_delivery_date),
  s.carrier_name,
  s.origin_region
ORDER BY shipment_month, s.carrier_name;
