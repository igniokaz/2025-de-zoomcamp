## Question 1

docker ps

docker network ls

docker images

docker build -t python3128:001 .

docker exec -it python3128:001

--> which pip
--> pip --version

## Question 2

PgAdmin should connect to host=db and port=5432

################
## Question 3 ##
################

## Prepare docker network and database
cd /home/ignas/data-engineering-zoomcamp/01-docker-terraform/2_docker_sql

docker-compose up

pgcli -h localhost -p 5432 -u root -d ny_taxi
--> \dt
--> select count(*) from yellow_taxi_data


## Connect PgAdmin to VM-Docker-Postgres
http://localhost:8080/browser/

host=pgdatabase
port = 5432
user=root
password=root


## Download datasets
cd /home/ignas/data-engineering-zoomcamp/01-docker-terraform/2_docker_sql

wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
which gzip
gzip -d https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
wc -l green_tripdata_2019.csv ## check row count


## launch jupyter notebook on port 8888:80
jupyter notebook

## SQL queries

# Q3
SELECT count(*) FROM public.green_taxi_data where trip_distance <=1

SELECT count(*) FROM public.green_taxi_data where trip_distance >1 and trip_distance <=3

SELECT count(*) FROM public.green_taxi_data where trip_distance >3 and trip_distance <=7

SELECT count(*) FROM public.green_taxi_data where trip_distance >7 and trip_distance <=10

SELECT count(*) FROM public.green_taxi_data where trip_distance >10


# Q4
select * from public.green_taxi_data where trip_distance > 0 order by trip_distance desc limit 1


## Q5

select * from (
        select "PULocationID", z."Zone", sum(total_amount)
        from public.green_taxi_data
        left outer join
            public.zones z on green_taxi_data."PULocationID" = z."LocationID"
        where lpep_pickup_datetime::date = '2019-10-18'
        group by "PULocationID", "Zone"
        order by sum(total_amount) desc
) t
where sum > 13000

## Q6

select
    z2."Zone"
from public.green_taxi_data gtd
    left outer join
        public.zones z1 on gtd."PULocationID" = z1."LocationID"
    left outer join
        public.zones z2 on gtd."DOLocationID" = z2."LocationID"
where z1."Zone" = 'East Harlem North'
order by tip_amount desc
limit 1;
