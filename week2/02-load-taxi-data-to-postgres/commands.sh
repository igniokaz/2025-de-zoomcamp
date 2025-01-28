curl -X POST https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/02-workflow-orchestration/postgres/docker-compose.yml

docker-compose up -d



##  backfill execution at localhost:8080

## kestra file will not execute normally, need to go triggers/backfill executions then
--> select data 2019-01-01 to 2019-12-31
--> advance configuration, execution labels = backfill, value = ture


## check in DB if files are there

