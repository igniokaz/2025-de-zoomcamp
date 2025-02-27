{{ config(materialized="table") }}

with trips_data as (select * from {{ ref("fact_trips") }})
select
    service_type,
    revenue_year_quarter,
    sum(total_amount) as revenue_monthly_total_amount
from trips_data
group by 1, 2
