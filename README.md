# Data Cleaning Project in MySQL

This project is a data cleaning exercise in MySQL, where the main focus is on transforming raw data into a cleaner, more standardized version by addressing issues like duplicates, null or blank values, unnecessary rows and columns, and standardizing the data format.

The tutorial I followed is available on YouTube by Alex the Analyst, and it covers the following data cleaning tasks:
- Removing Duplicates
- Standardizing Data
- Handling Null/Blank Values
- Removing Unnecessary Columns and Rows

You can watch the tutorial here: [Data Cleaning in MySQL | Full Project](https://www.youtube.com/watch?v=4UltKCnnnTA)

## Table of Contents
1. [Project Overview](#project-overview)
2. [Code Walkthrough](#code-walkthrough)
   - [Step 1: Remove Duplicates](#step-1-remove-duplicates)
   - [Step 2: Standardize the Data](#step-2-standardize-the-data)
   - [Step 3: Handling Null/Blank Values](#step-3-handling-nullblank-values)
   - [Step 4: Remove Unnecessary Rows and Columns](#step-4-remove-unnecessary-rows-and-columns)
3. [How to Run the Project](#how-to-run-the-project)
4. [Contributing](#contributing)

## Project Overview
In this project, we work with a dataset related to layoffs, performing the following data cleaning operations:
1. **Removing Duplicates:** Identifying and eliminating duplicate records.
2. **Standardizing Data:** Ensuring consistent formatting and categorization.
3. **Handling Null/Blank Values:** Addressing missing or blank data.
4. **Removing Unnecessary Columns/Rows:** Cleaning the dataset by removing irrelevant or empty rows and columns.

### Steps Covered in the Tutorial
1. **Remove Duplicates** – We identify duplicate records based on multiple fields like company name, location, industry, and others.
2. **Standardize the Data** – Standardize certain columns (e.g., trimming spaces, normalizing country names, converting dates to standard formats).
3. **Handling Null/Blank Values** – We clean up records with null or blank values in essential fields.
4. **Remove Unnecessary Rows and Columns** – Remove rows and columns that contain irrelevant or incomplete data.

---

## Code Walkthrough

### Step 1: Remove Duplicates
In this step, we create a staging table, `layoffs_staging`, and copy all data into it. We then use a `ROW_NUMBER()` function to identify duplicates based on relevant columns. Duplicates are then removed using a `DELETE` statement.

-- Create a staging table for data manipulation
CREATE TABLE layoffs_staging LIKE layoffs;

-- Copy data into the staging table
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Identify duplicate records using ROW_NUMBER() function
WITH duplicate_CTE AS (
  SELECT *, ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
  ) AS row_num
  FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- Remove duplicates
DELETE FROM layoffs_staging WHERE row_num > 1;
