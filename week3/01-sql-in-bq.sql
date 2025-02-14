-- Create external table referring to GCS path
CREATE OR REPLACE EXTERNAL TABLE `neat-episode-446707-f5.de_zoomcamp.external_yellow_tripdata`
OPTIONS (
  format='CSV',
  uris = ['gs://ignas-kestra-gcp-bucket/yellow_tripdata_2019-*.csv', 'gs://ignas-kestra-gcp-bucket/yellow_tripdata_2020-*.csv']
);

-- Check yellow trip data
SELECT * FROM neat-episode-446707-f5.de_zoomcamp.external_yellow_tripdata LIMIT 10;

-- Create a non-partinioned table from external table
CREATE OR REPLACE TABLE neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_non_partitioned AS
SELECT * FROM neat-episode-446707-f5.de_zoomcamp.external_yellow_tripdata;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_partitioned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM neat-episode-446707-f5.de_zoomcamp.external_yellow_tripdata;

-- Impact of partition
-- Scanning 486.93MB of data
SELECT DISTINCT (VendorID)
FROM neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_non_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2020-06-01' AND '2020-06-30';

-- Scanning 8MB
SELECT DISTINCT (VendorID)
FROM neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2020-06-01' AND '2020-06-30';

-- Let's look into partitions
SELECT table_name, partition_id, total_rows
FROM `neat-episode-446707-f5.de_zoomcamp.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM neat-episode-446707-f5.de_zoomcamp.yellow_tripdata;

-- Query scans 369.93MB
SELECT COUNT(*) as trips
from neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
AND VendorID = 1;


-- Query scans 301.75MB
SELECT COUNT(*) as trips
from neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_partitioned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
AND VendorID = 1;
