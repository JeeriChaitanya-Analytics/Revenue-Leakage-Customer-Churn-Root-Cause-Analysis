-- =====================================================
-- STEP 3: Data Profiling & Quality Assessment
-- Identifies nulls, duplicates, inconsistencies
-- =====================================================

-- 1. Total Record Count
SELECT COUNT(*) AS total_records
FROM retail_raw;

-- 2. Null Value Check
SELECT
    COUNT_IF(transaction_id IS NULL) AS null_transaction_id,
    COUNT_IF(transaction_date IS NULL) AS null_transaction_date,
    COUNT_IF(region IS NULL) AS null_region,
    COUNT_IF(product IS NULL) AS null_product,
    COUNT_IF(customer_id IS NULL) AS null_customer_id,
    COUNT_IF(sales_amount IS NULL) AS null_sales,
    COUNT_IF(cost_amount IS NULL) AS null_cost,
    COUNT_IF(profit_reported IS NULL) AS null_profit,
    COUNT_IF(discount_percentage IS NULL) AS null_discount,
    COUNT_IF(payment_method IS NULL) AS null_payment
FROM retail_raw;

-- 3. Duplicate Transaction Check
SELECT transaction_id, COUNT(*)
FROM retail_raw
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- 4. Profit Mismatch Check
SELECT *
FROM retail_raw
WHERE profit_reported != (sales_amount - cost_amount);

-- 5. Negative Value Check
SELECT *
FROM retail_raw
WHERE sales_amount < 0 OR cost_amount < 0;
