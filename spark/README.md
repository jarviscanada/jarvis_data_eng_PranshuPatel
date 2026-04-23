# Retail Data Analytics with PySpark

## Introduction

This project focuses on implementing data analytics workflows using PySpark in different notebook environments, including Databricks, Zeppelin, and Azure Databricks. The main goal was to strengthen practical experience with distributed data processing, structured DataFrame APIs, notebook-based analytics, cloud ETL design, medallion architecture, dashboard-driven reporting, and workflow orchestration.

In the Databricks portion of the project, I worked on retail transaction analytics using a PostgreSQL retail dataset. I loaded the data into Databricks with JDBC and used PySpark DataFrames to clean, transform, and analyze the data. The work included monthly sales analysis, placed versus canceled orders, active users, new versus existing users, and RFM customer segmentation.

In the Zeppelin portion of the project, I evaluated PySpark on Zeppelin notebook using the World Development Indicators dataset stored as a Hive table. This part of the project focused on understanding how PySpark works in Zeppelin and how analytical workflows can be developed using Spark SQL and PySpark DataFrames in a notebook environment.

In the Azure Databricks portion of the project, I built an end-to-end ETL and analytics pipeline for financial fraud analysis using Azure SQL Database, Azure Data Lake Storage Gen2, PySpark, Databricks dashboards, and job orchestration. This implementation followed the medallion architecture pattern and included bronze, silver, and gold layers for fraud-focused reporting.

In another Databricks implementation, I built a stock market analytics pipeline using Alpha Vantage API, PySpark, Delta tables, Databricks dashboards, and Databricks Jobs. This project focused on extracting stock data for multiple companies, applying medallion architecture, performing trend analysis on price and volume, and automating the workflow with job orchestration.

Technologies used in this project include PySpark, Databricks, Zeppelin, PostgreSQL, JDBC, GCP Dataproc, Hive Metastore, Azure SQL Database, Azure Data Lake Storage Gen2, Azure Data Factory, Databricks Jobs, Delta tables, REST API integration, and structured DataFrame APIs.

---

## Databricks Implementation

The Databricks implementation uses a retail transaction dataset stored in PostgreSQL. The dataset includes invoice number, stock code, item description, quantity, invoice date, unit price, customer ID, and country. I connected Databricks to PostgreSQL using JDBC and loaded the retail table into a PySpark DataFrame.

After loading the data, I performed analytics and wrangling tasks including:

- schema validation and data inspection
- calculation of sales amount
- monthly placed orders versus canceled orders
- monthly sales analysis
- monthly sales growth analysis
- monthly active users
- monthly new versus existing users
- RFM calculation
- RFM segmentation and segment summary analysis

The notebook implementation can be found here:

- [Retail Data Analytics with PySpark Notebook](./spark/notebook/Retail_Data_Analytics_with_PySpark.ipynb)

In this architecture, PostgreSQL acts as the source system, Databricks provides the notebook and compute environment, and PySpark DataFrames are used for transformation and aggregation. Databricks makes it easy to process the data at scale and interactively inspect intermediate and final results.

Main Databricks architecture components:

- PostgreSQL as the source database
- JDBC for data ingestion
- Databricks notebook as the analytics workspace
- PySpark DataFrames for distributed transformation and analysis
- Databricks runtime environment

### Databricks Architecture Diagram

![Databricks Architecture](./Assests/Databricks_Architecture.jpg)

---

## Zeppelin Implementation

The Zeppelin implementation focuses on evaluating PySpark on Zeppelin notebook using the World Development Indicators dataset. The purpose of this part was not retail analytics, but to understand how PySpark can be used effectively in Zeppelin for structured analytical tasks.

As a Data Engineer, I wanted to evaluate PySpark on Zeppelin notebook and understand how it works with Hive tables and notebook-based analytics. For this work, I reused the `wdi_csv_parquet` Hive table created from the WDI dataset. The dataset contains fields such as year, country name, country code, indicator name, indicator code, and indicator value.

Using Zeppelin and PySpark, I performed DataFrame-based analysis on the WDI dataset and strengthened my understanding of Spark transformations, filtering, aggregation, joins, and notebook-driven data exploration. This implementation also helped me compare the Zeppelin workflow with the Databricks workflow and understand the strengths of both notebook platforms.

The notebook implementation can be found here:

- [Spark Dataframe - WDI Data Analytics Notebook](./spark/notebook/Spark_Dataframe_WDI_Data_Analytics.ipynb)

In this architecture, the WDI dataset is stored as a Hive table and queried through Zeppelin using PySpark. Zeppelin acts as the interactive notebook interface, while PySpark provides the structured API used for analysis. This setup demonstrates how Spark-based analytics can be performed in Zeppelin using notebook-driven workflows.

Main Zeppelin architecture components:

- GCP Dataproc cluster
- Zeppelin notebook for interactive analytics
- Hive table for structured data access
- PySpark DataFrames for transformation and querying

### Zeppelin Architecture Diagram

![Zeppelin Architecture](./Assests/Zeppelin_Architecture.jpg)

---

## Financial Fraud Analytics ETL Pipeline on Azure Databricks

This project focuses on building an end-to-end ETL and analytics pipeline for financial fraud analysis using Azure services and Databricks. The dataset includes transaction data, card details, user information, merchant category codes, and fraud labels. The main goal of this implementation was to gain practical experience in cloud-based data engineering, multi-source ingestion, medallion architecture, dashboard development, and workflow orchestration.

The ingestion layer was designed using multiple Azure services. `transactions_data.csv` and `cards_data.csv` were first loaded into Azure SQL Database and then ingested into Databricks using JDBC. `users_data.csv`, `mcc_codes.json`, and `train_fraud_labels.json` were uploaded to Azure Data Lake Storage Gen2 and read into Databricks from cloud storage.

After ingestion, the project was structured using the medallion architecture:

### Bronze Layer

The bronze layer stores raw ingested data with minimal transformation. It acts as the landing zone for all source entities.

Bronze tables created in this project:

- `bronze.transactions_bronze`
- `bronze.cards_bronze`
- `bronze.users_bronze`
- `bronze.mcc_codes_bronze`
- `bronze.fraud_labels_bronze`

### Silver Layer

The silver layer focuses on cleaning, structuring, and enriching the bronze data. In this stage, I standardized schema, converted data types, reshaped reference data, and enhanced transactions with fraud and merchant category information.

Silver tables created in this project:

- `silver.cards_silver`
- `silver.users_silver`
- `silver.transactions_silver`

Key transformations included:

- cleaning card and user attributes
- converting income and debt columns into numeric values
- converting MCC reference data into a lookup format
- joining fraud labels with transaction data
- enriching transactions with merchant category descriptions
- creating analytical features such as transaction date, day of week, hour of day, time of day, week start, year-month, and high-value transaction flags

### Gold Layer

The gold layer was created for business analytics and dashboard reporting. These tables were designed to answer fraud-focused analytical questions and act as the curated source for dashboard visualizations.

Gold tables created in this project:

- `gold.fraud_by_day_of_week`
- `gold.fraud_rate_daily`
- `gold.top_users_by_fraud_count`
- `gold.user_spike_vs_weekly_avg`
- `gold.fraud_rate_by_mcc`
- `gold.high_fraud_merchants`
- `gold.fraud_by_time_of_day`
- `gold.avg_amount_fraud_vs_nonfraud`
- `gold.fraud_amount_by_mcc`
- `gold.daily_fraud_losses`
- `gold.unique_fraud_users_weekly`
- `gold.monthly_fraud_spikes`
- `gold.user_behavior_before_after_fraud`
- `gold.high_value_vs_low_value_fraud`

These gold outputs were used to answer questions such as:

- which days of the week show the most fraudulent transactions
- how fraud rate changes over time
- which users have the highest number of flagged transactions
- which merchant categories and merchants show elevated fraud activity
- how fraud varies across time of day
- whether fraud is more common in high-value purchases
- how user behavior changes before and after a fraudulent event

### Dashboard and Job Orchestration

A Databricks dashboard was built using the gold tables as the analytical source layer. The dashboard includes fraud-focused visuals such as fraud by day of week, fraud rate trends, top users by fraud count, fraud by merchant category, fraud by time of day, daily fraud losses, monthly fraud spikes, and high-value versus low-value fraud analysis. Filter widgets were also added to improve interactivity.

To operationalize the workflow, a Databricks job pipeline was created with task dependencies in the following order:

- Bronze Notebook
- Silver Notebook
- Gold Notebook
- Dashboard Refresh

This made the full workflow reproducible and easier to refresh in a structured sequence.

### Azure ETL Architecture Diagram

![ETL Architecture](./Assests/ETL.png)

---

## Stock Market Analytics Pipeline on Databricks

## Stock Market Analytics Pipeline on Databricks

This project demonstrates an end-to-end stock market analytics pipeline built on Databricks using the Alpha Vantage API, PySpark, Delta tables, Delta Live Tables / Lakeflow Declarative Pipelines, Databricks dashboards, and workflow orchestration. The goal of this project was to gain hands-on experience with API-based ingestion, incremental data loading, medallion architecture, financial time-series transformation, data quality validation, trend analysis, and pipeline automation in Databricks.

The pipeline was built for four companies:

- Apple (`AAPL`)
- Microsoft (`MSFT`)
- Google (`GOOGL`)
- Tesla (`TSLA`)

The source data was extracted from the Alpha Vantage API using three endpoints:

- `TIME_SERIES_DAILY` for historical daily stock prices and volume
- `GLOBAL_QUOTE` for latest market quote snapshots
- `OVERVIEW` for company-level metadata

To keep the API key secure, it was stored in Databricks Secrets and accessed inside the ingestion notebook during runtime. Since Alpha Vantage is a rate-limited external API, the solution was intentionally divided into two stages:

1. a raw ingestion notebook that lands API data into Delta landing tables
2. a DLT / Lakeflow pipeline that processes the landed data through bronze, silver, and gold layers

This separation made the workflow easier to control, more reliable, and better aligned with real-world medallion architecture design.

### Raw Ingestion / Landing Layer

A separate ingestion notebook was created to call the Alpha Vantage API for all four symbols and land the source data into raw Delta tables in append mode.

Landing tables created in this project:

- `bronze_src.daily_stock_incoming`
- `bronze_src.quotes_incoming`
- `bronze_src.company_info_incoming`

This landing layer acts as the raw source layer for the pipeline and preserves source history over time.

The ingestion notebook follows three different loading patterns:

- **Daily stock history** is loaded incrementally, meaning only new trading dates are appended for each symbol.
- **Quote snapshots** are appended on every run so that the latest market quote is captured as a time-based snapshot.
- **Company overview data** is also appended as snapshots on every run to preserve the latest metadata returned by the API.

This design allows the raw layer to act as a durable ingestion checkpoint before downstream transformations begin.

### Bronze Layer

The bronze layer was implemented in a dedicated pipeline file and acts as the first pipeline-managed layer. It reads the landing tables as streaming inputs and makes the raw ingested data available for downstream transformation.

Bronze tables created in this project:

- `bronze_daily_stock`
- `bronze_quotes`
- `bronze_company_info`

This layer keeps the raw landed structure intact while enabling incremental processing inside the pipeline. Since the landing tables are append-only, the bronze layer picks up only newly ingested records instead of re-ingesting the entire dataset from the API.

### Silver Layer

The silver layer was implemented in a separate transformation file and focuses on standardizing, validating, and cleaning the bronze data before it is used for analytics.

Silver tables created in this project:

- `silver_daily_stock`
- `silver_quotes`
- `silver_company_info`

The silver layer is designed as an incremental append history layer. As new records arrive in bronze, silver processes only those new records and appends the transformed output to the existing clean dataset.

#### `silver_daily_stock`

This table contains cleaned and validated historical daily stock data. Key transformations include:

- explicit type casting for analytical fields
- null validation on required columns
- business rule validation such as:
  - `high_price >= low_price`
  - `open_price >= low_price`
  - `open_price <= high_price`
  - `close_price >= low_price`
  - `close_price <= high_price`
  - `volume >= 0`

This creates a reliable historical stock dataset that can be directly used for downstream analysis.

#### `silver_quotes`

This table stores cleaned quote snapshots captured from the `GLOBAL_QUOTE` endpoint. Each pipeline run appends a fresh quote snapshot for each stock symbol, allowing the project to retain historical quote-level observations over time.

#### `silver_company_info`

This table stores cleaned company overview snapshots from the `OVERVIEW` endpoint. It keeps a historical record of company metadata returned by the API across pipeline runs.

Overall, the silver layer acts as the trusted business-ready layer of the project, where raw API output is converted into structured and validated datasets.

### Gold Layer

The gold layer was implemented in a separate transformation file and was designed for analytical reporting and dashboard consumption.

Gold tables created in this project:

- `gold_stock_history`
- `gold_price_trend`
- `gold_volume_trend`

#### `gold_stock_history`

This table serves as the curated historical stock dataset built from `silver_daily_stock`. It contains the cleaned daily stock records for all four companies and acts as the analytical base for downstream reporting and trend calculations.

#### `gold_price_trend`

This table performs stock price trend analysis using window functions partitioned by `symbol` and ordered by `trading_date`. It includes:

- close price from 7 prior trading rows
- close price from 30 prior trading rows
- close price from 90 prior trading rows
- 7-row absolute price change
- 30-row absolute price change
- 90-row absolute price change
- 7-row percentage price change
- 30-row percentage price change
- 90-row percentage price change

These lag-based calculations help analyze short-term, medium-term, and longer-term price movement patterns for each company.

#### `gold_volume_trend`

This table performs trading volume trend analysis using the same symbol-based window logic. It includes:

- volume from 7 prior trading rows
- volume from 30 prior trading rows
- volume from 90 prior trading rows
- 7-row absolute volume change
- 30-row absolute volume change
- 90-row absolute volume change

These outputs help track how market activity changes over time for each stock.

### Pipeline Structure

To keep the implementation modular and easier to maintain, the pipeline was separated into three transformation files:

- `bronze_stock_dlt.py`
- `silver_stock_dlt.py`
- `gold_stock_dlt.py`

This structure makes the medallion layers easier to understand, debug, and present, while still allowing them to run as part of the same Databricks pipeline.

### Data Flow Summary

The project follows this overall flow:

- Alpha Vantage API
- Raw ingestion notebook
- Delta landing tables in `bronze_src`
- Bronze streaming pipeline tables
- Silver cleaned incremental history tables
- Gold analytical tables
- Databricks dashboard

This design separates ingestion from transformation, improves reliability, and makes it easier to re-run or troubleshoot each stage independently.

### Dashboard and Workflow Orchestration

A Databricks dashboard was built using the gold tables as the reporting layer. The dashboard includes visuals such as:

- close price trend over time
- trading volume trend over time
- 7-row, 30-row, and 90-row price change comparison
- 7-row, 30-row, and 90-row percentage price change comparison
- 7-row, 30-row, and 90-row volume change comparison

This made it possible to analyze both company-level trends and cross-company comparisons from the curated gold outputs.

To operationalize the project, a Databricks workflow was created with task dependencies in the following order:

- Raw Ingestion Notebook
- DLT / Lakeflow Pipeline Update
- Dashboard Refresh

This orchestration allows the project to run in a controlled sequence on a schedule. First, the ingestion notebook lands new API data into Delta landing tables. Then the pipeline processes the landed data through bronze, silver, and gold layers. Finally, the dashboard refreshes to reflect the latest analytical output.

### Stock Market Pipeline Architecture Diagram

![DLT Architecture](./Assests/DLT.png)

---

## Future Improvement

There are several ways this project can be improved in the future:

1. Add stronger automated data quality checks across bronze, silver, and gold layers, including schema validation, null checks, duplicate detection, and threshold-based anomaly rules for financial and transactional datasets.

2. Replace any remaining hardcoded configuration values with fully parameterized notebooks and environment-aware configuration so the same pipelines can run more easily across development, testing, and production environments.

3. Expand the stock market analytics project by adding company overview data, latest quote data, and additional market indicators such as moving averages, rolling volatility, and comparative performance benchmarks.

4. Extend the fraud analytics pipeline with more advanced fraud features and machine learning-ready feature engineering for downstream predictive modeling.

5. Add more interactive business dashboards and drill-down views for retail analytics, fraud analytics, and stock market analytics use cases.

6. Improve orchestration further with production-style scheduling, monitoring, retry logic, failure handling, and alerting for Databricks workflows.

7. Enhance security further by standardizing secret management, role-based access, and secure connectivity patterns across API, database, and cloud storage integrations.

8. Expand the comparison between Databricks and Zeppelin with a more formal evaluation of usability, scalability, maintainability, and performance.

9. Improve the stock pipeline further by reducing repeated API loads through incremental logic or controlled ingestion strategies while preserving historical data quality.
