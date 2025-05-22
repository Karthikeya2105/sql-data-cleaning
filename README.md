# 🧹 Data Cleaning Project – Employee Records (SQL)

## 🧠 Project Description
This project demonstrates a comprehensive data cleaning process using SQL. The dataset simulates messy employee records with issues like inconsistent formatting, duplicate records, invalid emails, out-of-range ages, and unstandardized date formats. The objective was to clean, standardize, and prepare the data for further analysis or reporting.

---

## 📁 Dataset Overview

The data contains the following fields:
- `full_name`: Employee name (inconsistent casing and spacing)
- `email`: Email addresses (some invalid or missing)
- `age`: Employee age (nulls, outliers, and invalid entries)
- `department`: Department names (mixed casing, trailing spaces)
- `join_date`: Dates in multiple formats (e.g., `YYYY-MM-DD`, `DD/MM/YYYY`, `MM-DD-YYYY`)

---

## 🛠 Tools & Technologies Used

- SQL (MySQL)
- Regex for data validation
- Data profiling and cleaning logic
- Data normalization techniques

---

## 🔧 Key Cleaning Tasks Performed

| Task | Description |
|------|-------------|
| **Whitespace Trimming** | Removed leading/trailing spaces from `full_name`, `email`, and `department` |
| **Text Normalization** | Converted `full_name`, `email`, and `department` to lowercase |
| **Age Validation** | Replaced null, negative, or out-of-range ages with default value `30` |
| **Duplicate Removal** | Identified and deleted exact duplicate records (excluding `id`) |
| **Email Validation** | Used regex to clean invalid email formats |
| **Date Format Conversion** | Standardized `join_date` to SQL `DATE` format using `STR_TO_DATE()` |
| **Safe Update Mode Handling** | Temporarily disabled `SQL_SAFE_UPDATES` for deletion and updates |

---

## 🧪 Sample Cleaning Queries

```sql
-- Trim spaces and lowercase values
UPDATE messy_data_1
SET full_name = LOWER(TRIM(full_name)),
    email = LOWER(TRIM(email)),
    department = LOWER(TRIM(department))
WHERE id > 0;

-- Fix invalid ages
UPDATE messy_data_1
SET age = 30
WHERE age IS NULL OR age < 0 OR age > 120;

-- Remove duplicate records
DELETE FROM messy_data_1
WHERE id NOT IN (
    SELECT MIN(id)
    FROM messy_data_1
    GROUP BY full_name, email, age, department, join_date
);

-- Validate email format and clean
UPDATE messy_data_1
SET email = ''
WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

-- Standardize join_date format
UPDATE messy_data_1
SET join_date1 = CASE
    WHEN join_date LIKE '%/%/%' THEN STR_TO_DATE(join_date, '%d/%m/%y')
    WHEN join_date LIKE '%-%-%' THEN STR_TO_DATE(join_date, '%Y-%m-%d')
    ELSE NULL
END;
