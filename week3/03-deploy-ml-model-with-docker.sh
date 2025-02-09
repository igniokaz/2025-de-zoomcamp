## open virtual ssh terminal
gcloud auth login --do auth

# export model from BigQuery into Google Cloud Storage

# create in UI a Cloud Storage bucket called ignas_taxi_ml_model --> in the same region, eu_west2

bq --project_id neat-episode-446707-f5 extract -m de_zoomcamp.tip_model gs://ignas_taxi_ml_model/tip_model

mkdir /tmp/model

# copy from GS into VM Storage, where kestra is also running inside a docker container
gsutil cp -r gs://ignas_taxi_ml_model/tip_model /tmp/model

mkdir -p serving_dir/tip_model/1
cp -r /tmp/model/tip_model/* serving_dir/tip_model/1
sudo docker pull tensorflow/serving

sudo docker run -p 8501:8501 --mount type=bind,source=pwd/serving_dir/tip_model,target=/models/tip_model -e MODEL_NAME=tip_model -t tensorflow/serving &

## whitelist port 85-1 on GCP firewall

gcloud compute firewall-rules create allow-tensorflow-serving \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:8501 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=tensorflow-serving

gcloud compute instances add-tags kestra-production \
    --tags=tensorflow-serving

gcloud compute firewall-rules list

## local machine:
curl -X GET http://35.189.97.103:8501/v1/models/tip_model

## get response

## Create a GET request in postman
http://35.189.97.103:8501/v1/models/tip_model

## Create a POST equest in postman
http://35.189.97.103:8501/v1/models/tip_model:predict

body/raw/
{"instances":[{"passenger_count":1, "trip_distance":22.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"1", "fare_amount":20.4, "tolls_amount":0.0}]}

#get response:
{
    "predictions": [[2.6098882664279834]
    ]
}


##via terminal:
curl -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' -X POST http://35.189.97.103:8501/v1/models/tip_model:predict



