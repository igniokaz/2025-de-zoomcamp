-- Load 2024-01-06 Yellow Taxi Data from GCS parquett files

-- Step 1: create extrenal table
CREATE OR REPLACE EXTERNAL TABLE `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024_ext
OPTIONS (
  format = 'PARQUET',
  uris = [
    'gs://ignas-kestra-gcp-bucket/yellow_tripdata_2024-01.parquet',
    'gs://ignas-kestra-gcp-bucket/yellow_tripdata_2024-02.parquet',
    'gs://ignas-kestra-gcp-bucket/yellow_tripdata_2024-03.parquet',
    'gs://ignas-kestra-gcp-bucket/yellow_tripdata_2024-04.parquet',
    'gs://ignas-kestra-gcp-bucket/yellow_tripdata_2024-05.parquet',
    'gs://ignas-kestra-gcp-bucket/yellow_tripdata_2024-06.parquet'
  ]
);

-- Step 2: create BQ merged table
CREATE OR REPLACE TABLE `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024 AS
SELECT * FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024_ext;


-- Question 1
SELECT COUNT(*) FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024_ext;


-- Question 2
--- Count Distinct PULocationIDs from GCS
SELECT COUNT(DISTINCT PULocationID) from `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024_ext;

--- Count Distinct PULocationIDs from BQ
SELECT COUNT(DISTINCT PULocationID) from `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024;


-- Question 3
--- Retrieve PULocationID from BQ
SELECT PULocationID from `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024;

--- Retrieve PULocationID and DOLocationID from BQ
SELECT PULocationID, DOLocationID from `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024;


-- Question 4
SELECT COUNT(*) from `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024 WHERE fare_amount=0;


-- Question 5
CREATE OR REPLACE TABLE `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024_ext;


-- Question 6
--- Query non partitioned non clustered table
SELECT DISTINCT VendorID FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024
WHERE tpep_dropoff_datetime between '2024-03-01' and '2024-03-15';

--- Query partitioned clustered table
SELECT DISTINCT VendorID FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024_partitioned_clustered
WHERE tpep_dropoff_datetime between '2024-03-01' and '2024-03-15';


-- Question 9
--- Query counts zero bytes as number of rows already available in metadata
SELECT COUNT(*) FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_data_2024;

