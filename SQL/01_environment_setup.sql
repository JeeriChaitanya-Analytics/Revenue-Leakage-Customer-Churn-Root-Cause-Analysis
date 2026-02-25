=====================================================
STEP 1: Environment Setup
Creates warehouse, database, and schema
=====================================================

CREATE OR REPLACE WAREHOUSE retail_wh
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;

USE WAREHOUSE retail_wh;

CREATE OR REPLACE DATABASE retail_analytics;

USE DATABASE retail_analytics;

CREATE OR REPLACE SCHEMA raw_layer;

USE SCHEMA raw_layer;
