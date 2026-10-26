# Employee Management System | SQL & MySQL

## Project Overview

The Employee Management System is a SQL-based database project developed using MySQL to manage employee information and related records. This project focuses on database design, data retrieval, and analysis using SQL queries.

## Project Objectives

- Organize employee-related information in a relational database.
- Retrieve and analyze employee data using SQL queries.
- Understand relationships between tables using primary and foreign keys.
- Practice SQL joins, aggregate functions, grouping, and subqueries.

## Tools & Technologies

- **Database:** MySQL
- **SQL Editor:** MySQL Workbench

## Database Design

The database contains related tables for employee management, such as:

- Employees
- Departments
- Payroll
- Leaves

*Note: Update this list to match the tables actually implemented in your project.*

## SQL Concepts Demonstrated

- Database and table creation using `CREATE`
- Data manipulation using `INSERT`, `UPDATE`, and `DELETE`
- Data filtering using `WHERE`
- Sorting using `ORDER BY`
- Aggregate functions: `COUNT()`, `SUM()`, and `AVG()`
- Data grouping using `GROUP BY` and `HAVING`
- Table relationships using `JOIN`
- Nested queries using subqueries
- Database constraints, including primary keys and foreign keys

## Sample SQL Queries

### 1. Count Employees

```sql
SELECT COUNT(*) AS TotalEmployees
FROM Employees;
```

### 2. Calculate Average Salary

```sql
SELECT AVG(Salary) AS AverageSalary
FROM Employees;
```

### 3. Count Employees by Department

```sql
SELECT Department, COUNT(*) AS TotalEmployees
FROM Employees
GROUP BY Department;
```

*Make sure these queries match your actual table and column names before using them.*

## How to Run the Project

1. Install MySQL and open MySQL Workbench.
2. Connect to your MySQL server.
3. Create or select the project database.
4. Execute the SQL scripts to create the tables and insert sample data.
5. Run the queries to retrieve and analyze employee information.

## Key Learnings

- Relational database design and table relationships
- Writing SQL queries to retrieve and analyze data
- Using joins and aggregate functions
- Applying constraints to maintain data integrity

## Author

**Kopuri Poojitha**
