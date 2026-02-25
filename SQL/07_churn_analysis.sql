-- =====================================================
-- STEP 7: Customer Churn Risk Analysis (Revenue-Based)
-- =====================================================


-- =====================================================
-- QUERY 1: Revenue-Based Churn Segmentation
-- Calculates revenue drop from H1 to H2 and classifies risk
-- =====================================================

WITH revenue_by_period AS (
    SELECT
        customer_id,
        CASE 
            WHEN MONTH(transaction_date) <= 6 THEN 'H1'
            ELSE 'H2'
        END AS period,
        SUM(sales_amount) AS total_revenue
    FROM fact_sales
    GROUP BY customer_id, period
),

pivot_revenue AS (
    SELECT
        customer_id,
        MAX(CASE WHEN period = 'H1' THEN total_revenue END) AS H1_revenue,
        MAX(CASE WHEN period = 'H2' THEN total_revenue END) AS H2_revenue
    FROM revenue_by_period
    GROUP BY customer_id
)

SELECT
    customer_id,
    H1_revenue,
    H2_revenue,
    (H2_revenue - H1_revenue) AS revenue_difference,
    ROUND(
        (H2_revenue - H1_revenue) / NULLIF(H1_revenue, 0) * 100,
        2
    ) AS revenue_drop_pct,
    CASE
        WHEN (H2_revenue - H1_revenue) / NULLIF(H1_revenue,0) <= -0.25 THEN 'HIGH_RISK'
        WHEN (H2_revenue - H1_revenue) / NULLIF(H1_revenue,0) BETWEEN -0.25 AND -0.10 THEN 'MEDIUM_RISK'
        ELSE 'LOW_RISK'
    END AS churn_risk_segment
FROM pivot_revenue;



-- =====================================================
-- QUERY 2: Revenue at Risk (High-Risk Customers Only)
-- Quantifies financial exposure due to churn
-- =====================================================

WITH churn_analysis AS (
    SELECT
        customer_id,
        MAX(CASE WHEN MONTH(transaction_date) <= 6 THEN sales_amount END) AS H1_revenue,
        MAX(CASE WHEN MONTH(transaction_date) > 6 THEN sales_amount END) AS H2_revenue
    FROM fact_sales
    GROUP BY customer_id
)

SELECT
    SUM(H2_revenue) AS revenue_at_risk
FROM churn_analysis
WHERE (H2_revenue - H1_revenue) / NULLIF(H1_revenue,0) <= -0.25;



-- =====================================================
-- QUERY 3: Churn Risk Distribution Summary
-- Provides customer distribution by risk segment
-- =====================================================

WITH churn_segmentation AS (
    SELECT
        customer_id,
        ROUND(
            (SUM(CASE WHEN MONTH(transaction_date) > 6 THEN sales_amount END) -
             SUM(CASE WHEN MONTH(transaction_date) <= 6 THEN sales_amount END)
            )
            /
            NULLIF(SUM(CASE WHEN MONTH(transaction_date) <= 6 THEN sales_amount END),0)
            * 100,
        2) AS revenue_drop_pct
    FROM fact_sales
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN revenue_drop_pct <= -25 THEN 'HIGH_RISK'
        WHEN revenue_drop_pct BETWEEN -25 AND -10 THEN 'MEDIUM_RISK'
        ELSE 'LOW_RISK'
    END AS churn_risk_segment,
    COUNT(*) AS customer_count
FROM churn_segmentation
GROUP BY churn_risk_segment;
