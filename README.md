**📌 Project Overview**

This project presents an end-to-end analytics solution designed to identify revenue leakage, profit inconsistencies, duplicate transaction exposure, and customer churn risk.

The objective was to simulate an enterprise-grade financial analytics workflow using SQL (Snowflake) and Power BI, applying structured data modeling and executive dashboard reporting.

**🎯 Business Problem**

**Organizations often experience hidden financial losses due to:**

Duplicate transactions inflating revenue

Incorrect profit reporting

Margin erosion due to discount patterns

Revenue contraction from churn-prone customers

This project investigates these risk areas using structured data engineering and BI analysis techniques.

**🏗️ Data Architecture**

**The solution follows a layered warehouse design:**

1️⃣ Raw Layer

Loaded 20,000 transactional records

Preserved original data integrity

2️⃣ Staging Layer

Data profiling (null analysis, duplicates, negative values)

Profit recalculation validation

Date standardization

Cleaning strategy implementation

3️⃣ Star Schema Model

FACT_SALES table

DIM_DATE

DIM_PRODUCT

DIM_REGION

DIM_CUSTOMER

Surrogate key relationships

Optimized for BI performance

**🔍 Revenue Leakage Analysis**

**Key Findings:**

9.95% transactions contained profit mismatches

₹82.30K total profit misstatement

₹100.84M duplicate revenue exposure

Regional leakage concentration identified

Margin sensitivity linked to discount levels

**📉 Customer Churn Risk Analysis**

**Churn segmentation based on behavioral indicators:**

2 High-Risk Customers identified

₹1.64M Revenue at Risk

-2.02% Revenue Drop (H1 vs H2)

₹5.09M Revenue contraction impact

**📊 Dashboard Features (Power BI)**

Executive KPI cards

Revenue trend comparison (H1 vs H2)

Leakage by region

Profit margin vs discount analysis

Customer risk distribution

Revenue impact by churn segment

High-risk customer drill-down table

**🛠️ Tools & Technologies**

Snowflake (Cloud Data Warehouse)

SQL (Data Engineering & Profiling)

Power BI (DAX & Dashboard Design)

Star Schema Data Modeling

**📈 Business Impact**

This analysis demonstrates how organizations can:

Detect hidden financial leakage

Strengthen revenue integrity controls

Improve profit validation mechanisms

Identify churn-driven revenue contraction

Support executive decision-making with data-backed insights

**📷 Dashboard Preview**

<img width="1332" height="753" alt="Screenshot 2026-02-25 211735" src="https://github.com/user-attachments/assets/aead3895-1133-4969-a1e5-c694476f29a0" />

<img width="1310" height="737" alt="Screenshot 2026-02-25 203806" src="https://github.com/user-attachments/assets/75a3358c-d11b-4742-abb7-4feecfabe9f7" />

