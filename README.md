# Nashville Housing Data Cleaning (SQL Server / T-SQL)

An end-to-end data cleaning and transformation project using Microsoft SQL Server (T-SQL) on raw housing sales data from Nashville, Tennessee.

The primary objective was to take an uncurated, dirty transactional dataset and transform it into a reliable, consistent, and analysis-ready format for Business Intelligence and machine learning pipelines.

---

## 🛠️ Data Cleaning Techniques Applied

* **Standardizing Date Formats:** Converted unstandardized timestamps (`datetime`) into clean SQL `Date` formats using `CONVERT()`.
* **Imputing Missing Values (Self-Joins):** Populated missing property addresses (`NULL`) by performing a `LEFT JOIN` on the table itself matching identical `ParcelID` records, leveraging `ISNULL()`.
* **String Parsing & Atomicity:**
  * Extracted street address and city from composite fields using `SUBSTRING()`, `CHARINDEX()`, and `LEN()`.
  * Parsed tripartite owner address fields into Street, City, and State using `PARSENAME()` and `REPLACE()`.
* **Categorical Standardization:** Standardized disparate binary classifications (`Y`, `N`, `Yes`, `No`) into uniform `Yes`/`No` values using `CASE` expressions.
* **Deduplication:** Identified and eliminated duplicate transaction rows using a Common Table Expression (CTE) and the `ROW_NUMBER()` window function partitioned by unique business attributes (`ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, `LegalReference`).
* **Column Pruning & Governance:** Dropped unneeded raw composite columns (`ALTER TABLE ... DROP COLUMN`) to streamline the final data model.

---

## ⚠️ Production Note & Best Practice

In an enterprise production environment, executing destructive DDL operations such as `ALTER TABLE ... DROP COLUMN` or direct `DELETE` statements on raw tables is strictly avoided to preserve source data lineage.

In this repository, these operations are demonstrated for educational and data preparation purposes. In a professional production pipeline, the industry standard is to:
1. Preserve the immutable raw data layer (Raw / Staging).
2. Apply transformations downstream into clean analytical tables or expose curated schemas via **SQL Views (`CREATE VIEW`)**.

---

## 📂 Repository Contents

* `NashvilleHousingDataCleaning.sql`: Documented SQL script containing all cleaning and transformation queries.
* `README.md`: Project documentation and workflow breakdown.
