-- =====================================================
-- STEP 6: Revenue Leakage Analysis
-- Quantifies profit mismatches & duplicate exposure
-- =====================================================

-- 1. Profit Mismatch %
SELECT
    COUNT_IF(profit_validation_flag = 'MISMATCH') * 100.0
    / COUNT(*) AS mismatch_percentage
FROM fact_sales;

-- 2. Total Leakage Amount
SELECT
    SUM(calculated_profit - profit_reported) AS total_leakage
FROM fact_sales;

-- 3. Duplicate Revenue Exposure
SELECT
    SUM(sales_amount) AS duplicate_revenue
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_date) AS rn
    FROM fact_sales
)
WHERE rn > 1;
