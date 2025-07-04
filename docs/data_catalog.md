# 📂 Data Catalog – Gold Layer

## 🟡 Overview

The **Gold Layer** represents the business-level view of data, optimized for **analytics** and **reporting**.  
It includes **dimension tables** and **fact tables** designed to support decision-making and business intelligence use cases.

---

## 🧑‍💼 1. `gold.dim_customers`  
**Purpose**: Stores detailed customer information enriched with demographic and geographic context.

| Column Name      | Data Type     | Description                                                                 |
|------------------|---------------|-----------------------------------------------------------------------------|
| `customer_key`   | INT           | Surrogate key uniquely identifying each customer in the dimension.         |
| `customer_id`    | INT           | Unique internal identifier for each customer.                              |
| `customer_number`| NVARCHAR(50)  | Alphanumeric customer code used for tracking and reference.                |
| `first_name`     | NVARCHAR(50)  | Customer's first name.                                                     |
| `last_name`      | NVARCHAR(50)  | Customer's last name or family name.                                       |
| `country`        | NVARCHAR(50)  | Country of residence (e.g., 'Germany').                                  |
| `marital_status` | NVARCHAR(50)  | Marital status (e.g., 'Married', 'Single').                                |
| `gender`         | NVARCHAR(50)  | Gender of the customer (e.g., 'Male', 'Female', 'n/a').                    |
| `birthdate`      | DATE          | Date of birth in `YYYY-MM-DD` format (e.g., 1971-10-06).                   |
| `create_date`    | DATE          | Date the customer record was created in the system.                        |

---

## 📦 2. `gold.dim_products`  
**Purpose**: Provides descriptive information about products and their classifications.

| Column Name           | Data Type     | Description                                                                 |
|------------------------|---------------|-----------------------------------------------------------------------------|
| `product_key`          | INT           | Surrogate key uniquely identifying each product in the dimension.          |
| `product_id`           | INT           | Internal product identifier.                                                |
| `product_number`       | NVARCHAR(50)  | Structured alphanumeric code for categorization or inventory.              |
| `product_name`         | NVARCHAR(50)  | Descriptive product name (e.g., includes type, color, size).               |
| `category_id`          | NVARCHAR(50)  | Unique ID for the product's high-level category.                           |
| `category`             | NVARCHAR(50)  | Broad classification (e.g., Bikes, Components).                            |
| `subcategory`          | NVARCHAR(50)  | More detailed classification within the category.                          |
| `maintenance_required` | NVARCHAR(50)  | Indicates if maintenance is required (e.g., 'Yes', 'No'). ⚙️              |
| `cost`                 | INT           | Product cost in monetary units.                                             |
| `product_line`         | NVARCHAR(50)  | Product line or series (e.g., Road, Mountain).                             |
| `start_date`           | DATE          | Availability start date for the product.                                   |

---

## 📈 3. `gold.fact_sales`  
**Purpose**: Captures sales transactions to support performance analysis and reporting.

| Column Name     | Data Type     | Description                                                                 |
|------------------|---------------|-----------------------------------------------------------------------------|
| `order_number`   | NVARCHAR(50)  | Unique alphanumeric ID of the sales order (e.g., 'SO54496').               |
| `product_key`    | INT           | Foreign key linking to the product in `dim_products`.                      |
| `customer_key`   | INT           | Foreign key linking to the customer in `dim_customers`.                    |
| `order_date`     | DATE          | Date the order was placed. 🛒                                              |
| `shipping_date`  | DATE          | Date the order was shipped. 🚚                                             |
| `due_date`       | DATE          | Payment due date for the order.                                            |
| `sales_amount`   | INT           | Total value of the sale (e.g., 25). 💰                                     |
| `quantity`       | INT           | Number of product units ordered.                                           |
| `price`          | INT           | Unit price of the product.                                                 |

---

