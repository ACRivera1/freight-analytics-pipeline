USE DATABASE freight_analytics;
USE SCHEMA bronze;
USE WAREHOUSE freight_wh;

-- Create external stage pointing to S3
CREATE STAGE s3_freight_stage
  URL = 's3://freight-analytics-acrivera/'
  CREDENTIALS = (
    AWS_KEY_ID     = 'YOUR_KEY'
    AWS_SECRET_KEY = 'YOUR_SECRET'
  );

-- Carriers table
CREATE TABLE carriers (
  carrier_id             VARCHAR(10),
  carrier_name           VARCHAR(100),
  carrier_type           VARCHAR(50),
  hq_state               VARCHAR(2),
  contract_rate_per_mile NUMBER(5,2)
);
COPY INTO carriers
FROM @s3_freight_stage/files/carriers.csv
FILE_FORMAT = (TYPE='CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);

-- Cities table
CREATE TABLE cities (
  city_id    VARCHAR(10),
  city_name  VARCHAR(50),
  state_code VARCHAR(2),
  region     VARCHAR(20)
);
COPY INTO cities
FROM @s3_freight_stage/files/cities.csv
FILE_FORMAT = (TYPE='CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);

-- Delay codes table
CREATE TABLE delay_codes (
  delay_code           VARCHAR(5),
  delay_category       VARCHAR(30),
  delay_description    VARCHAR(100),
  carrier_controllable BOOLEAN
);
COPY INTO delay_codes
FROM @s3_freight_stage/files/delay_codes.csv
FILE_FORMAT = (TYPE='CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);

-- Fuel prices table
CREATE TABLE fuel_prices (
  record_id               VARCHAR(10),
  price_date              DATE,
  diesel_price_per_gallon NUMBER(5,3),
  region                  VARCHAR(20)
);
COPY INTO fuel_prices
FROM @s3_freight_stage/files/fuel_prices.csv
FILE_FORMAT = (TYPE='CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);

-- Shipments table
CREATE TABLE shipments (
  shipment_id             VARCHAR(10),
  carrier_id              VARCHAR(10),
  origin_city_id          VARCHAR(10),
  dest_city_id            VARCHAR(10),
  scheduled_delivery_date DATE,
  actual_delivery_date    DATE,
  freight_cost_usd        NUMBER(10,2),
  delay_reason_code       VARCHAR(5)
);
COPY INTO shipments
FROM @s3_freight_stage/files/shipments.csv
FILE_FORMAT = (TYPE='CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);
