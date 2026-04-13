USE SCHEMA freight_analytics.silver;

CREATE TABLE clean_shipments AS
SELECT
  s.shipment_id,
  c.carrier_id,
  c.carrier_name,
  c.carrier_type,
  c.hq_state              AS carrier_hq_state,
  o.city_name             AS origin_city,
  o.state_code            AS origin_state,
  o.region                AS origin_region,
  d.city_name             AS dest_city,
  d.state_code            AS dest_state,
  d.region                AS dest_region,
  dc.delay_category,
  dc.delay_description,
  dc.carrier_controllable,
  s.scheduled_delivery_date,
  s.actual_delivery_date,
  s.freight_cost_usd,
  DATEDIFF('day',
    s.scheduled_delivery_date,
    s.actual_delivery_date)            AS days_delayed,
  CASE
    WHEN s.actual_delivery_date <= s.scheduled_delivery_date
    THEN 'On Time' ELSE 'Late'
  END                                  AS delivery_status,
  CONCAT(o.city_name, ' to ', d.city_name) AS lane
FROM freight_analytics.bronze.shipments   s
JOIN freight_analytics.bronze.carriers    c  ON s.carrier_id        = c.carrier_id
JOIN freight_analytics.bronze.cities      o  ON s.origin_city_id    = o.city_id
JOIN freight_analytics.bronze.cities      d  ON s.dest_city_id      = d.city_id
JOIN freight_analytics.bronze.delay_codes dc ON s.delay_reason_code = dc.delay_code
WHERE s.shipment_id      IS NOT NULL
  AND s.freight_cost_usd  > 0;
