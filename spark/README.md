# Retail Data Analytics with PySpark

## Introduction

This project focuses on implementing data analytics workflows using PySpark in two different notebook environments: Databricks and Zeppelin. The main goal was to strengthen practical experience with distributed data processing, structured DataFrame APIs, and notebook-based analytics using PySpark.

In the Databricks portion of the project, I worked on retail transaction analytics using a PostgreSQL retail dataset. I loaded the data into Databricks with JDBC and used PySpark DataFrames to clean, transform, and analyze the data. The work included monthly sales analysis, placed versus canceled orders, active users, new versus existing users, and RFM customer segmentation.

In the Zeppelin portion of the project, I evaluated PySpark on Zeppelin notebook using the World Development Indicators dataset stored as a Hive table. This part of the project focused on understanding how PySpark works in Zeppelin and how analytical workflows can be developed using Spark SQL and PySpark DataFrames in a notebook environment.

Technologies used in this project include PySpark, Databricks, Zeppelin, PostgreSQL, JDBC, GCP Dataproc, Hive Metastore, and structured DataFrame APIs.

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

## Future Improvement

There are several ways this project can be improved in the future:

1. Add interactive dashboards on top of the Databricks retail analytics output so business users can monitor monthly sales, order behavior, and customer segmentation more easily.

2. Automate the retail data ingestion workflow from PostgreSQL into Databricks instead of using a manual notebook-driven load process.

3. Improve the RFM segmentation logic by working with business stakeholders to define more meaningful segment rules and actions for each customer group.

4. Extend the Zeppelin implementation with more advanced WDI analytics, including deeper country-level comparisons and trend analysis across multiple indicators.

5. Compare Databricks and Zeppelin more formally by measuring differences in usability, notebook experience, and performance for similar PySpark workloads.

6. Store transformed analytical outputs in reusable tables so they can be consumed later by dashboards, reports, or downstream data workflows.
