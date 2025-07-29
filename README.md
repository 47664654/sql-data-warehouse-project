# 📊 Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project**! 🚀
This project showcases the full lifecycle of a data warehouse solution—starting from raw data ingestion to business-ready analytics—designed to demonstrate expertise in data engineering, modeling, and analysis.

---

## 🧱 Data Architecture: Medallion Model

The architecture follows the modern **Medallion Architecture** pattern, dividing the pipeline into three layers:

![Data Architecture](https://github.com/47664654/sql-data-warehouse-project/blob/main/docs/data_architecture.png)

1. **🔸 Bronze Layer**: Raw data ingested as-is from CSV files (ERP & CRM systems) into SQL Server.
2. **⚪ Silver Layer**: Cleansed and standardized data, enriched for integration across domains.
3. **⭐ Gold Layer**: Curated, business-ready data modeled in a star schema for analytics and reporting.

---

## 🗂️ Project Overview

This project covers the entire process of building a scalable analytics platform:

* **📐 Data Architecture Design**: Structuring the warehouse using Bronze, Silver, and Gold layers.
* **⚙️ ETL Pipeline Development**: Extracting, transforming, and loading data using T-SQL scripts.
* **🏛️ Data Modeling**: Designing a dimensional model with fact and dimension tables.
* **📈 Analytical Insights**: Writing SQL queries to deliver insights into customer behavior, product performance, and sales trends.

This project is ideal for professionals aspiring to roles like:

* Data Analyst
* Data Engineer
* Business Intelligence Developer
* ETL Developer
* SQL Developer

---

## 🧰 Tools & Resources

* **SQL Server Express** – Local database engine for development
* **SQL Server Management Studio (SSMS)** – GUI for writing SQL scripts
* **CSV Datasets** – ERP & CRM data for sales, customers, and products
* **Draw\.io** – Data architecture and modeling diagrams
* **Notion** – Task tracking and project documentation

---

## 📦 Project Requirements

### 🏗️ Data Engineering Phase

**Goal**: Build a structured, maintainable data warehouse for downstream analytics.

**Specifications**:

* Source: Two systems (ERP and CRM), delivered as CSV files
* Database: SQL Server (local)
* ETL Logic: Separate layers for raw, cleansed, and business data
* Modeling: Star schema (fact + dimension tables)
* Scope: Latest data only, no historization
* Validation: Quality checks for uniqueness, integrity, and schema compliance

### 📊 Analytics & Reporting Phase

**Goal**: Perform exploratory analysis and derive business insights using SQL.

**Focus Areas**:

* Customer segmentation & churn behavior
* Product performance across time
* Regional & temporal sales trends

For a complete breakdown, see [docs/requirements.md](https://github.com/47664654/sql-data-warehouse-project/tree/main/docs).

---

## 📁 Repository Structure

```
data-warehouse-project/
│
├── datasets/                           # Raw CSV files from ERP and CRM
│
├── docs/                               # Documentation, models, and architecture
│   ├── data_architecture.drawio
│   ├── data_flow.drawio
│   ├── data_models.drawio
│   ├── naming-conventions.md
│   ├── data_catalog.md
│
├── scripts/                            # T-SQL scripts by layer
│   ├── bronze/                         # Data ingestion scripts
│   ├── silver/                         # Cleaning, deduplication, and integration
│   ├── gold/                           # Star schema creation and analytical logic
│
├── tests/                              # SQL quality checks and data validations
│
├── README.md                           # Project overview and usage instructions
├── LICENSE                             # Project license (MIT by default)
├── .gitignore                          # Files to exclude from version control
└── requirements.txt                    # Optional: tools, extensions, or dependencies
```

---

## ✅ Data Quality and Testing

To ensure accuracy and reliability, the project includes quality checks such as:

* Surrogate key uniqueness in dimensions
* Referential integrity between fact and dimensions
* Detection of missing or inconsistent records

See `tests/` folder for details.

---

## 🧑‍💻 About the Developer

Hi! I’m **Amine Bouraoui**, an aspiring Data Analyst and Engineer.
This project is part of my professional portfolio to demonstrate skills in data architecture, SQL development, and analytical problem-solving.

Let’s connect on LinkedIn: [linkedin](https://www.linkedin.com/in/amine-bouraoui-4b103631b/)
Or check out more of my work on GitHub: [github](https://github.com/47664654)

---

## 📄 License

This project is licensed under the [MIT License](https://github.com/47664654/sql-data-warehouse-project/blob/main/LICENSE). You are free to use, modify, and share it with proper attribution.

---

Would you like me to export this into a ready-to-paste `README.md` format with Markdown formatting and links added where needed?
