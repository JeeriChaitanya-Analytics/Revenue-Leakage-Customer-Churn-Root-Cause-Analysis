=====================================================
-- STEP 5: Star Schema Design
-- Creates dimension and fact tables
-- =====================================================

create or replace schema analytics_layer;

----Dim_date 

CREATE OR REPLACE TABLE analytics_layer.DIM_DATE (
    
    date_sk              INTEGER PRIMARY KEY,  -- Surrogate Key (YYYYMMDD format)
    full_date            DATE,
    
    year                 INTEGER,
    quarter              INTEGER,
    month                INTEGER,
    month_name           STRING,
    year_month           STRING,              -- e.g., 2024-01
    
    week_of_year         INTEGER,
    day_of_month         INTEGER,
    day_of_week          INTEGER,
    day_name             STRING,
    
    is_weekend           STRING,              -- Y / N
    
    created_timestamp    TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
    
)
COMMENT = 'Enterprise Date Dimension for Revenue & Churn Analysis';

Insert into analytics_layer.dim_date
select 
     to_number(to_char(dateadd(day,seq4(),'2024-01-01'),'YYYYMMDD')) as date_sk,
     dateadd(day,seq4(),'2024-01-01') as full_date,
     year(dateadd(day,seq4(),'2024-01-01')) as Year,
     quarter(dateadd(day,seq4(),'2024-01-01')) as Quarter,
     month(dateadd(day,seq4(),'2024-01-01')) as Month,
     monthname(dateadd(day,seq4(),'2024-01-01')) as Month_name,
     to_char(dateadd(day,seq4(),'2024-01-01'),'YYYY-MM') as Year_month,
     weekofyear(dateadd(day,seq4(),'2024-01-01')) as week_of_year,
     day(dateadd(day,seq4(),'2024-01-01')) as Day_of_month,
     dayofweek(dateadd(day,seq4(),'2024-01-01')) as day_of_week,
     dayname(dateadd(day,seq4(),'2024-01-01')) as day_name,
     case
         when dayofweek(dateadd(day,seq4(),'2024-01-01')) in (6,7)
         then 'Y'
         else 'N'
    end as Is_weekend,
    current_timestamp()
    from table(generator(rowcount => 366));

---Dim_Product

create or replace table analytics_layer.dim_product
(product_sk integer primary key,
product varchar(15),
created_timestamp timestamp default current_timestamp()
)
Comment = "Product Dim Table";


insert into analytics_layer.dim_product(product_sk,product)
select 
row_number() over (order by product) as product_sk,
product
from
(select distinct product from staging_layer.stg_retail)
order by product;

---Dim_Region

create or replace table analytics_layer.dim_region
(Region_sk integer primary key,
region varchar(20),
created_timestamp timestamp default current_timestamp()
)
comment = "Region Dim table";

insert into analytics_layer.dim_region(region_sk, region)
select 
row_number() over (order by region) as region_sk,
region
from
(select distinct region from staging_layer.stg_retail)
order by region;

-------Dim Customer-----------------------

CREATE OR REPLACE TABLE analytics_layer.DIM_CUSTOMER (

    customer_sk            INTEGER PRIMARY KEY,
    customer_id            INTEGER,

    first_purchase_date    DATE,
    last_purchase_date     DATE,
    total_transactions     INTEGER,
    customer_lifetime_days INTEGER,

    created_timestamp      TIMESTAMP DEFAULT CURRENT_TIMESTAMP()

)
COMMENT = 'Customer Dimension for Revenue Leakage & Churn Analysis';

insert into analytics_layer.dim_customer
(customer_sk, customer_id, first_purchase_date,last_purchase_date,total_transactions,customer_lifetime_days)
select 
row_number() over (order by customer_id) as customer_sk,
customer_id,
min(transaction_date) as first_purchase_date,
max(transaction_date) as last_purchase_date,
count(*) as total_transactions,
datediff(day,min(transaction_date),max(transaction_date)) as customer_lifetime_days
from 
staging_layer.stg_retail
group by customer_id
order by customer_id;

--------------------------------------Fact Sales-------------------------------------------------------------

CREATE OR REPLACE TABLE analytics_layer.FACT_SALES (

    sales_sk                INTEGER AUTOINCREMENT PRIMARY KEY,

    date_sk                 INTEGER,
    customer_sk             INTEGER,
    product_sk              INTEGER,
    region_sk               INTEGER,

    transaction_id          STRING,

    sales_amount            NUMBER(12,2),
    cost_amount             NUMBER(12,2),
    calculated_profit       NUMBER(12,2),
    Profit_Reported         NUMBER(12,2),
    discount_percentage     NUMBER(5,2),

    profit_validation_flag  STRING,
    duplicate_flag          STRING,

    created_timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP()

)
COMMENT = 'Fact table storing transactional revenue data for leakage & churn analysis';

insert into analytics_layer.fact_sales 
   (date_sk,
    customer_sk,
    product_sk,
    region_sk,
    transaction_id,
    sales_amount,
    cost_amount,
    calculated_profit,
    Profit_Reported,
    discount_percentage,
    profit_validation_flag,
    duplicate_flag)       
select
d.date_sk, c.customer_sk,p.product_sk,r.region_sk,s. transaction_id,
    s.sales_amount,
    s.cost_amount,
    s.calculated_profit,
    s.Profit_Reported,
    s.discount_percentage,
    s.profit_validation_flag,
    case when s.duplicate_count > 1 then 'Duplicate'
    else 'Unique'
    end as duplicate_flag
 from staging_layer.stg_retail as s
 left join analytics_layer.dim_date as d
 on s.transaction_date = d.full_date
 left join analytics_layer.dim_customer as c
 on s.customer_id = c.customer_id
 left join analytics_layer.dim_product as p
 on s.product = p.product
 left join analytics_layer.dim_region as r
 on s.region = r.region;

-- Validate fact count
SELECT COUNT(*) FROM fact_sales;
