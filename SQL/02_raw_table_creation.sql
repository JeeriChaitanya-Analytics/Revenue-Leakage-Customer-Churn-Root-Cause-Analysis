-- =====================================================
-- STEP 2: Raw Table Creation
-- Stores original transactional data without modification
-- =====================================================

CREATE OR REPLACE TABLE retail_raw (

    transaction_id        STRING,
    transaction_date      STRING,
    region                STRING,
    product               STRING,
    customer_id           INTEGER,
    sales_amount          NUMBER(18,2),
    cost_amount           NUMBER(18,2),
    profit_reported       NUMBER(18,2),
    discount_percentage   INTEGER,
    payment_method        STRING

);

-- Validate row count
SELECT COUNT(*) FROM retail_raw;
