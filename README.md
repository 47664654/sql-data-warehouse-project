# 📊 Data Warehouse & Analytics Project

Welcome to the **Data Warehouse & Analytics Project**! 🚀  
This project demonstrates a complete end-to-end pipeline using the **Medallion Architecture** (Bronze → Silver → Gold) on **SQL Server**. It highlights core skills in **data engineering**, **SQL development**, and **data analysis** using real-world business logic.

---

## 🧱 Architecture: Medallion Model

The project is organized in three layered stages:

- 🔸 **Bronze Layer**: Raw ERP & CRM CSV ingestion  
- ⚪ **Silver Layer**: Data cleaning, standardization, deduplication  
- ⭐ **Gold Layer**: Star schema, business KPIs, and analytics-ready views  

Each layer is developed with **modular, maintainable T-SQL scripts**.

---

## 🎯 Project Objectives

### 🛠️ Data Engineering
- Build a **scalable data warehouse** using best practices
- Implement ETL logic using **pure SQL**
- Apply **data quality validation** across pipeline stages
- Create a **star schema** with fact and dimension tables

### 📊 Data Analysis
- Perform **EDA** (Exploratory Data Analysis) in SQL
- Deliver **business insights** through custom reports
- Analyze customer segmentation, product trends, and sales patterns

---

## 🧰 Tools & Technologies

| Tool                     | Purpose                                 |
|--------------------------|-----------------------------------------|
| SQL Server Express       | Database engine                         |
| SQL Server Management Studio (SSMS) | SQL development + debugging         |
| CSV Files                | Simulated ERP & CRM datasets            |
| Draw.io                  | Architecture & schema diagrams          |
| Notion                   | Planning, documentation, and tracking   |

---

## 📁 Project Structure

```plaintext
data-warehouse-project/
│
├── datasets/                           # Raw ERP & CRM CSV files
│
├── docs/                               # Project documentation
│   ├── data_architecture.drawio        # Medallion architecture
│   ├── data_flow.drawio                # ETL process diagram
│   ├── data_models.drawio              # ERD for star schema
│   ├── naming-conventions.md           # SQL naming conventions
│   ├── data_catalog.md                 # Dataset & column descriptions
│
├── scripts/                            # T-SQL logic by layer
│   ├── bronze/                         # Raw data ingestion
│   ├── silver/                         # Cleaning, joining, deduplication
│   ├── gold/                           # Facts, dimensions, KPIs
│   ├── eda/                            # SQL-based exploratory analysis
│   ├── reports/                        # Final SQL business reports
│       ├── report_customers.sql        # Customer segmentation & metrics
│       ├── report_products.sql         # Product performance analysis
│
├── tests/                              # SQL data quality checks
│   └── integrity_checks.sql
│
├── README.md                           # 📄 Project overview (this file)
├── LICENSE                             # 📜 MIT license
├── .gitignore                          # 🚫 Files to exclude from Git
└── requirements.txt                    # 🔧 Optional: tools or extensions
