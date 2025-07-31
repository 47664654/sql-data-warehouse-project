# 🏦 Data Warehouse & Analytics Project

Welcome to the **Data Warehouse & Analytics Project** — a complete end-to-end data pipeline built using the **Medallion Architecture (Bronze → Silver → Gold)** on **SQL Server**. This project demonstrates core competencies in data engineering, SQL development, and business analytics through real-world scenarios and workflows.

---

## 🏗️ Architecture: Medallion Model

The project follows a layered data architecture to ensure scalability, maintainability, and data quality:

| Layer      | Purpose                                                                    |
| ---------- | -------------------------------------------------------------------------- |
| **Bronze** | Raw ingestion of ERP & CRM CSV data — minimal transformation               |
| **Silver** | Cleaned, standardized, deduplicated, and validated data                    |
| **Gold**   | Business-ready data modeled as a star schema with KPIs and analytics views |

Each layer is implemented using modular, reusable, and well-documented **T-SQL scripts**.

---

## 🎯 Project Objectives

### 🔧 Data Engineering

* Build a scalable data warehouse using best practices
* Implement full ETL logic using **pure SQL**
* Enforce data quality checks across all pipeline stages
* Design and implement a **star schema** with fact and dimension tables

### 📊 Data Analysis

* Perform **Exploratory Data Analysis (EDA)** directly in SQL
* Generate actionable business insights via custom reports
* Analyze customer segmentation, product trends, and sales performance

---

## ⚙️ Tools & Technologies

| Tool                                    | Purpose                                             |
| --------------------------------------- | --------------------------------------------------- |
| **SQL Server Express**                  | Database engine for data storage and processing     |
| **SQL Server Management Studio (SSMS)** | Development, debugging, and query execution         |
| **CSV Files**                           | Simulated ERP & CRM source datasets                 |
| **Draw\.io**                            | Diagrams for architecture, data flow, and ER models |
| **Notion**                              | Project planning, documentation, and task tracking  |

---

## 📁 Project Structure

```
data-warehouse-project/
├── datasets/                     # Raw ERP & CRM CSV files
├── docs/                         # Documentation & diagrams
│   ├── data_architecture.drawio  # Medallion architecture diagram
│   ├── data_flow.drawio          # ETL process flow
│   ├── data_models.drawio        # Star schema ERD
│   ├── naming-conventions.md     # SQL naming standards
│   └── data_catalog.md           # Dataset and column descriptions
├── scripts/                      # T-SQL scripts by layer
│   ├── bronze/                   # Raw data ingestion
│   ├── silver/                   # Data cleaning, joining, deduplication
│   ├── gold/                     # Fact & dimension tables, KPIs
│   ├── eda/                      # SQL-based exploratory analysis
│   └── reports/                  # Final business reports
│       ├── report_customers.sql  # Customer segmentation & metrics
│       └── report_products.sql   # Product performance analysis
├── tests/                        # Data quality validation
│   └── integrity_checks.sql      # SQL checks for consistency & integrity
├── README.md                     # This file
├── LICENSE                       # MIT License
├── .gitignore                    # Git exclusions
└── requirements.txt              # Optional: tooling or extensions
```

---

## ✅ Data Quality Checks

To ensure reliability and accuracy, the pipeline includes SQL-based validation rules:

* Unique surrogate keys in dimension tables
* Foreign key constraints and referential integrity
* Null value checks, outlier detection, and schema validation
* Deduplication of customer and product records

See `tests/integrity_checks.sql` for implementation details.

---

## 📊 Exploratory Data Analysis (EDA) & Business Reporting

**Objective:** Deliver business-ready insights through SQL queries and analytics-ready reporting views in the Gold Layer.

Using the structured data warehouse, we perform **SQL-based ETL and EDA** to generate meaningful KPIs, customer and product segmentation, and performance trends — all directly from the database.

---

### 👥 Customer Analytics

* Total orders, total sales, and total quantity purchased per customer
* Customer lifespan and recency of last purchase
* Key KPIs:

  * **Average Order Value (AOV)**
  * **Monthly Spend**
* **Customer Segmentation:**

  * VIP, Regular, New customers
  * Age group classification (e.g., 18–25, 26–35, etc.)

📄 **Reporting View:** `gold.report_customers`
👉 *A unified view for customer behavior analysis and marketing targeting.*

---

### 📦 Product Analytics

* Total sales, total quantity sold, and number of orders per product
* Recency of sales and product lifecycle analysis
* Key KPIs:

  * **Average Selling Price (ASP)**
  * **Monthly Revenue per Product/Category**
* **Product Segmentation:**

  * High-Performer, Mid-Range, Low-Performer (based on sales volume & frequency)

📄 **Reporting View:** `gold.report_products`
👉 *Enables inventory planning, pricing strategy, and category management.*

---

### 📈 Additional Insights (Planned)

These features are in the roadmap for future enhancements:

* **Regional sales trends** (by customer location)
* **Monthly & quarterly KPI dashboards**
* **Customer churn & retention modeling**
* **Time-based analysis** using `dim_dates` for trend reporting (e.g., YoY growth, seasonality)

---

🔍 **Explore the full reporting logic in:**

* `scripts/reports/report_customers.sql`
* `scripts/reports/report_products.sql`

These SQL views are optimized for direct consumption by BI tools or stakeholders, enabling seamless integration into dashboards and executive reporting.

---

## 👨‍💻 About the Developer

Hi! I'm **Amine Bouraoui**, a passionate **Data Analyst & Engineer**.

This project is part of my professional portfolio to showcase:

* End-to-end **data warehouse architecture**
* Real-world **business insight generation** using SQL
* Skills in **data modeling, cleansing, transformation, and reporting**

🔗 [LinkedIn Profile](https://www.linkedin.com/in/amine-bouraoui-4b103631b/))
🐙 [GitHub Profile](https://github.com/47664654))

---

## 📄 License

This project is licensed under the **MIT License**.
See the [LICENSE](LICENSE) file for details.

---
