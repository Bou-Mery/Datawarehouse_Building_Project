# 🏗️ Modern Data Warehouse: Sales & CRM Integration

## 📘 Overview

This project demonstrates the design and development of a **modern data warehouse** using the **Medallion Architecture** (Bronze → Silver → Gold layers) with **SQL Server**.  
It integrates and models data from ERP and CRM systems to provide a clean, query-optimized structure based on dimensional modeling.

---

## 🧠 What This Project Covers

✅ **Data Architecture**: Implementation of a layered data warehouse architecture using industry standards.  
✅ **ETL Pipelines**: Load and transformation of source data using SQL (no external ETL tools).  
✅ **Data Modeling**: Development of fact and dimension tables in a **Star Schema** format.  
✅ **Data Integration**: Merging multiple data sources into a consistent and unified model.  
✅ **Data Quality**: Validation and cleaning of data to ensure integrity and consistency.

---

## 🎯 Skills Demonstrated

This project is an excellent showcase for:

- 🗃️ SQL Development  
- 🏗️ Data Architecture & Modeling  
- 🔄 ETL Pipeline Design  
- 🛠️ Data Engineering  
- 🧱 Dimensional Modeling  
- 📈 Analytical Query Optimization

---

## 🗂️ Repository Structure

| Folder/File | Description |
|-------------|-------------|
| `bronze/`   | Raw data tables from CRM & ERP (.csv ingested) |
| `silver/`   | Cleaned and standardized tables |
| `gold/`     | Final business-ready views with star schema |
| `scripts/`  | SQL scripts used for ETL, DDL, and transformations |
| `docs/` | Data architecture and model diagrams |
| `README.md` | Documentation (you are here!) |

---

## ⚙️ Specifications

- **Data Sources**: ERP and CRM files provided in `.csv` format  
- **Storage**: Microsoft SQL Server (local or cloud)  
- **Scope**: Only current data is modeled (no historization/versioning)  
- **Data Quality**: Address inconsistencies, nulls, and schema mismatches  
- **Model**: Star Schema with `fact_sales`, `dim_customers`, and `dim_products`  
- **Documentation**: Clear and structured to support analysts and stakeholders

---

## 🏛️ Architecture

### 🔸 Medallion Architecture

![DW Architecture](./dw_architecture.drawio.png)

### 🔌 Integration Model (CRM + ERP)

![Integration Model](./IntegrationModel.drawio.png)

### 🌟 Star Schema (Sales Data Mart)

![Star Schema](./starSchema.drawio.png)


### 🔄 Data Flow: End-to-End ETL Process

![Data Flow - Medallion Architecture](./dw_architecture.drawio.png)

 

---

## 🚧 Development Steps

1. ✅ Import ERP and CRM CSV files into SQL Server (Bronze Layer)
2. ✅ Clean, standardize, and normalize data (Silver Layer)
3. ✅ Build dimensional views for consumption (Gold Layer)
4. ✅ Join and enrich data across sources (CRM + ERP)
5. ✅ Validate relationships and apply data quality rules
6. ✅ Document schema and transformation logic

---

## 🔗 Project Planning

🗂️ [📋 Click here to open the Notion Project Plan](https://www.notion.so/Data-Warehouse-Project-2227f509c30f80cc9e49ce84dc568204?source=copy_link)

Includes:
- ✅ Task List by Layer (Bronze, Silver, Gold)
- 📆 Progress
- 📁 Dataset overview
- 📌 Notes & deliverables

---

## 📦 Tech Stack

- **Database**: SQL Server  
- **Languages**: T-SQL (DDL, DML, ETL logic)  
- **Architecture**: Medallion  
- **Modeling**: Star Schema  
- **Design Tools**: Draw.io for diagrams, Notion for planning

---

## 🛡️ License

This project is licensed under the **MIT License**.  
You are free to use, modify, and share this work with proper attribution.

---

## 🙋‍♀️ Author

**Meryem BOUKHRAIS**  
_Data Engineering & Analytics Enthusiast_  
[LinkedIn](https://www.linkedin.com/in/boukhrais-meryem-053501252/) | [GitHub](https://github.com/Bou-Mery) |

---

