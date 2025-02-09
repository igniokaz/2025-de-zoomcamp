-- Select the columns interesting to you
SELECT passenger_count, trip_distance, PULocationID, DOLocationID, payment_type, fare_amount, tolls_amount, tip_amount
FROM neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_partitioned WHERE fare_amount !=0;

-- Create a ML table with appropriate type
CREATE OR REPLACE TABLE neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_ml (
    passenger_count INTEGER,
    trip_distance FLOAT64,
    PULocationID STRING,
    DOLocationID STRING,
    payment_type STRING,
    fare_amount FLOAT64,
    tolls_amount FLOAT64,
    tip_amount FLOAT64
) AS (
    SELECT passenger_count, trip_distance, cast(PULocationID as STRING), CAST(DOLocationID as STRING),
    CAST(payment_type AS STRING), fare_amount, tolls_amount, tip_amount
    FROM neat-episode-446707-f5.de_zoomcamp.yellow_tripdata_partitioned WHERE fare_amount !=0
);

-- Create model with default setting
CREATE OR REPLACE MODEL `neat-episode-446707-f5`.de_zoomcamp.tip_model
OPTIONS
  (model_type='linear_reg',
  input_label_cols=['tip_amount'],
  DATA_SPLIT_METHOD='AUTO_SPLIT') AS
SELECT *
FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_tripdata_ml
WHERE tip_amount is not null;

-- Check features
SELECT * FROM ml.feature_info(MODEL `neat-episode-446707-f5`.de_zoomcamp.tip_model)

-- Evaluate the model
SELECT *
FROM ml.evaluate(MODEL `neat-episode-446707-f5`.de_zoomcamp.tip_model,
    (SELECT *
    FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_tripdata_ml
    WHERE tip_amount IS NOT NULL
));

-- Predict with model
SELECT * FROM
  ML.PREDICT(MODEL `neat-episode-446707-f5`.de_zoomcamp.tip_model,
  (SELECT *
    FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_tripdata_ml
    WHERE tip_amount IS NOT NULL
));

-- Predict and explain
SELECT * FROM
  ML.EXPLAIN_PREDICT(MODEL `neat-episode-446707-f5`.de_zoomcamp.tip_model,
  (SELECT *
    FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_tripdata_ml
    WHERE tip_amount IS NOT NULL
), STRUCT(3 as top_k_features));

-- Hyper Param Tuning
CREATE OR REPLACE MODEL `neat-episode-446707-f5`.de_zoomcamp.tip_hyperparam_model
OPTIONS
  (model_type='linear_reg',
  input_label_cols=['tip_amount'],
  DATA_SPLIT_METHOD='AUTO_SPLIT',
  num_trials=5,
  max_parallel_trials=2,
  l1_reg=hparam_range(0,20),
  l2_reg=hparam_candidates([0,0.1,1,10])) AS
  SELECT *
  FROM `neat-episode-446707-f5`.de_zoomcamp.yellow_tripdata_ml
  WHERE tip_amount IS NOT NULL;

