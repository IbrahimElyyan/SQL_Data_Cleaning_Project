-- Data Cleaning Project

SELECT *
FROM layoffs;

-- Step 1: Remove Duplicates
-- Step 2: Standardize the Data
-- Step 3: Handeling Null Values or Blank Values
-- Step 4: Remove Unecessary Rows and Columns

CREATE TABLE layoffs_staging
LIKE layoffs;

-- This will show an empty table, need to insert the data
SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Step 1: Remove Duplicates
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country,
funds_raised_millions) AS row_num
FROM layoffs_staging;

-- identifying possible duplicates 
WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country,
funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num>1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country,
funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num>1;

DELETE 
FROM layoffs_staging2
WHERE row_num>1;

SELECT * 
FROM layoffs_staging2;

-- Standardizing data

-- There is blank space in the beginning of company column
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE  layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb';

SELECT t1.company, t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
WHERE (t1.industry IS NULL or t1.industry = '') 
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL or t1.industry = '') 
AND (t2.industry IS NOT NULL or t2.industry != '');

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- Step 4: Remove Unecessary Rows and Columns
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;