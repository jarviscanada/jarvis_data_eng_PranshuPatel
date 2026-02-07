# Retail Data Analytics & Customer Segmentation (LGS)

## Introduction

This project was built for **LGS**, a retail organization that wants to better understand its customers, sales trends, and purchasing behavior using historical transaction data.  
The main business goal is to transform raw retail data into meaningful insights that support **data-driven decision making**, especially in marketing and customer retention.

Using transactional data, this project analyzes:
- Monthly sales trends and growth
- Order placement vs cancellation behavior
- Monthly active users
- New vs existing customers
- Customer value using **RFM (Recency, Frequency, Monetary) analysis**

LGS can use these analytics results to:
- Identify high-value customers and loyal customers
- Detect inactive or at-risk customers early
- Design targeted marketing campaigns (discounts, loyalty rewards, re-engagement emails)
- Improve revenue forecasting and customer lifetime value

### My Work & Technologies Used
- **Jupyter Notebook** for interactive data analysis
- **Python** for data processing and analytics
- **Pandas & NumPy** for data wrangling
- **Matplotlib & Squarify** for data visualization
- **PostgreSQL** as the data warehouse
- **Docker** to containerize PostgreSQL and Jupyter
- **SQL** for querying and aggregation

---

## Implementation

This project was implemented as an **end-to-end data analytics pipeline**, starting from raw retail data ingestion and ending with actionable business insights.

The workflow begins by loading retail transaction data into a **Jupyter Notebook environment**, where data cleaning, transformation, and feature engineering are performed using Python. Cleaned data is then analyzed to extract sales metrics, customer behavior trends, and user activity patterns.

To support scalable analytics, **PostgreSQL** is used as the data warehouse, running inside a Docker container. Jupyter and PostgreSQL containers communicate with each other through Docker networking, enabling seamless data access and querying.

Advanced analytics such as **RFM segmentation** are applied to classify customers into meaningful business segments. These results are visualized using charts and treemaps, making insights easy to interpret.  
Finally, the processed analytics are designed to be consumed by the **LGS web application**, allowing business users to view dashboards and make informed decisions.

---

### Project Architecture

The project follows a **containerized data analytics architecture** using Docker.

- Raw retail CSV files are loaded into **JupyterLab**
- Data cleaning, transformation, and analytics are performed using Python
- Processed data and analytics queries interact with **PostgreSQL**
- The **LGS Web App** consumes analytics results to display dashboards and reports
- PostgreSQL data is persisted using Docker volumes

### Architecture Diagram

The diagram below illustrates the full project architecture, including the LGS web app and data flow:

![Project Architecture](./assets/architecture_diagram.png)

---

## Data Analytics and Wrangling

### Notebook
All analytics, visualizations, and customer segmentation logic are implemented in the Jupyter notebook below:

?? **[Retail Data Analytics Notebook](./retail_data_analytics_wrangling.ipynb)**

### How This Data Helps LGS Increase Revenue

The analytics produced in this project can directly support revenue growth by:

- **RFM Segmentation**
  - Identifies *Champions*, *Loyal Customers*, *At Risk*, and *Hibernating* users
  - Enables personalized marketing instead of generic promotions

- **Targeted Campaigns**
  - Offer loyalty rewards to Champions
  - Re-engage Hibernating users with discounts
  - Upsell to Potential Loyalists

- **Sales Trend Analysis**
  - Detect seasonal patterns and sales drops
  - Improve inventory planning and promotions

- **Customer Retention**
  - Reduce churn by identifying declining purchase frequency early
  - Focus retention efforts on high-value segments

---

## Improvements

If more time were available, the following improvements could be implemented:

1. **Automation & Scheduling**
   - Automate data ingestion and analytics using Airflow or scheduled pipelines

2. **Advanced Visualization**
   - Integrate Power BI or Tableau dashboards for real-time reporting

3. **Predictive Analytics**
   - Add machine learning models to predict customer churn and future sales


