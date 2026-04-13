-- Create database, schemas, and warehouse
CREATE DATABASE freight_analytics;

CREATE SCHEMA freight_analytics.bronze;
CREATE SCHEMA freight_analytics.silver;
CREATE SCHEMA freight_analytics.gold;

CREATE WAREHOUSE freight_wh
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND   = 60
  AUTO_RESUME    = TRUE;
