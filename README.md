# 🏦 Data Warehouse & Analytics Project

Welcome to the **Data Warehouse & Analytics Project** — a complete end-to-end data pipeline built using the **Medallion Architecture (Bronze → Silver → Gold)** on **SQL Server**. This project demonstrates core competencies in data engineering, SQL development, and business analytics through real-world scenarios and workflows.

---

## 🏗️ Architecture: Medallion Model

The project follows a layered data architecture to ensure scalability, maintainability, and data quality:

| Layer | Purpose |
|------|--------|
| **Bronze** | Raw ingestion of ERP & CRM CSV data — minimal transformation |
| **Silver** | Cleaned, standardized, deduplicated, and validated data |
| **Gold** | Business-ready data modeled as a star schema with KPIs and analytics views |

Each layer is implemented using modular, reusable, and well-documented **T-SQL scripts**.

---

## 🎯 Project Objectives

### 🔧 Data Engineering
- Build a scalable data warehouse using best practices
- Implement full ETL logic using **pure SQL**
- Enforce data quality checks across all pipeline stages
- Design and implement a **star schema** with fact and dimension tables

### 📊 Data Analysis
- Perform **Exploratory Data Analysis (EDA)** directly in SQL
- Generate actionable business insights via custom reports
- Analyze customer segmentation, product trends, and sales performance

---

## ⚙️ Tools & Technologies

| Tool | Purpose |
|------|--------|
| **SQL Server Express** | Database engine for data storage and processing |
| **SQL Server Management Studio (SSMS)** | Development, debugging, and query execution |
| **CSV Files** | Simulated ERP & CRM source datasets |
| **Draw.io** | Diagrams for architecture, data flow, and ER models |
| **Notion** | Project planning, documentation, and task tracking |

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
- Unique surrogate keys in dimension tables
- Foreign key constraints and referential integrity
- Null value checks, outlier detection, and schema validation
- Deduplication of customer and product records

See `tests/integrity_checks.sql` for implementation details.

---

## 📈 Business Reporting

With the Gold Layer in place, we extract meaningful insights using SQL:

### 👥 Customer Analysis
- Total spend, recency, frequency, and average order value
- Customer segmentation: **VIP, Regular, New**
- Age group classification and behavior trends

### 📦 Product Performance
- Sales by category and subcategory
- Top-performing and underperforming SKUs
- Average pricing, product variety, and seasonal trends

🔍 **Explore the full queries in:**
- `scripts/reports/report_customers.sql`
- `scripts/reports/report_products.sql`

---

## 👨‍💻 About the Developer

Hi! I'm **Amine Bouraoui**, a passionate **Data Analyst & Engineer**.  

This project is part of my professional portfolio to showcase:
- End-to-end **data warehouse architecture**
- Real-world **business insight generation** using SQL
- Skills in **data modeling, cleansing, transformation, and reporting**

🔗 [LinkedIn Profile](https://www.linkedin.com/in/amine-bouraoui-4b103631b/))  
🐙 [GitHub Profile](https://github.com/47664654))

---

## 📄 License

This project is licensed under the **MIT License**.  
See the [LICENSE](LICENSE) file for details.

---

> 💡 *Built with SQL, precision, and a love for data.*
