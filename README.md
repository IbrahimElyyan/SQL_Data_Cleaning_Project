# SQL Data Cleaning Project

This project demonstrates a data cleaning workflow in MySQL, following a tutorial by Alex the Analyst on YouTube. The goal of this project is to clean and prepare a dataset for analysis by removing duplicates, standardizing data, handling null or blank values, and removing unnecessary rows and columns.

## Tutorial Reference
[Data Cleaning in MySQL | Full Project](https://www.youtube.com/watch?v=4UltKCnnnTA)

### Key Steps
1. **Removing Duplicates**
2. **Standardizing Data**
3. **Handling Null/Blank Values**
4. **Removing Unnecessary Columns/Rows**

## Workflow Summary

### Step 1: Remove Duplicates
- Identified duplicates using `ROW_NUMBER()` with `PARTITION BY` on relevant columns.
- Verified duplicates by querying for rows with duplicate counts.
- Deleted duplicate rows while retaining unique records.

### Step 2: Standardize Data
- Trimmed leading/trailing spaces from text columns.
- Standardized values (e.g., unifying variations of "Crypto" and "United States").
- Converted `date` column from text to `DATE` format using `STR_TO_DATE()` and altered the column type.

### Step 3: Handle Null/Blank Values
- Identified rows with null or blank values in key columns.
- Used `JOIN` queries to fill missing `industry` values based on the same company.
- Updated empty values in `industry` to `NULL` for consistency.

### Step 4: Remove Unnecessary Rows and Columns
- Removed rows where both `total_laid_off` and `percentage_laid_off` were null.
- Dropped the `row_num` column used during duplicate identification.

## SQL Code
The full SQL script used in this project is included below:

```sql
-- Data Cleaning Project

SELECT *
FROM layoffs;

-- Step 1: Remove Duplicates
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT layoffs_staging SELECT * FROM layoffs;

WITH duplicate_CTE AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, 
           percentage_laid_off, date, stage, country, funds_raised_millions
         ) AS row_num
  FROM layoffs_staging
)
SELECT * FROM duplicate_CTE WHERE row_num > 1;

DELETE FROM layoffs_staging2 WHERE row_num > 1;

-- Step 2: Standardizing Data
UPDATE layoffs_staging2 SET company = TRIM(company);
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';
UPDATE layoffs_staging2 SET country = 'United States' WHERE country LIKE 'United States%';
UPDATE layoffs_staging2 SET date = STR_TO_DATE(date, '%m/%d/%Y');
ALTER TABLE layoffs_staging2 MODIFY COLUMN date DATE;

-- Step 3: Handle Null/Blank Values
UPDATE layoffs_staging2 SET industry = NULL WHERE industry = '';
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '') AND (t2.industry IS NOT NULL);

-- Step 4: Remove Unnecessary Rows and Columns
DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;
```

## Tools Used
- **Database**: MySQL
- **Concepts**: CTEs, Window Functions, String Manipulation, Date Conversion

## How to Use
1. Clone this repository.
2. Import the dataset into your MySQL environment.
3. Run the SQL script step by step to replicate the data cleaning process.

## Credits
- Tutorial by [Alex the Analyst](https://www.youtube.com/@AlextheAnalyst).
