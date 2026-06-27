CREATE DATABASE EMS;
USE EMS;
-- Table 1: Job Department
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);
-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);
SELECT * FROM EMPLOYEE;
SELECT * FROM JOBDEPARTMENT;
SELECT * FROM LEAVES;
SELECT * FROM PAYROLL;
SELECT * FROM QUALIFICATION;
SELECT * FROM SALARYBONUS;


-- Analysis Questions 

-- 1. EMPLOYEE INSIGHTS 
-- ● How many unique employees are currently in the system? 
SELECT COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE;

-- ● Which departments have the highest number of employees? 
SELECT JD.JOBDEPT, COUNT(E.EMP_ID) AS EMPLOYEE_COUNT  
FROM EMPLOYEE E 
JOIN JOBDEPARTMENT JD
ON E.JOB_ID = JD.JOB_ID
GROUP BY JD.JOBDEPT
ORDER BY EMPLOYEE_COUNT DESC;

-- ● What is the average salary per department? 
SELECT JD.JOBDEPT, ROUND(AVG(SB.AMOUNT),2) AS AVG_SALARY  
FROM JOBDEPARTMENT JD
JOIN SALARYBONUS SB
ON JD.JOB_ID = SB.JOB_ID
GROUP BY JD.JOBDEPT;

-- ● Who are the top 5 highest-paid employees? 
SELECT E.EMP_ID, CONCAT(E.FIRSTNAME, ' ', E.LASTNAME) AS EMPLOYEE_NAME , JD.JOBDEPT, SB.AMOUNT AS SALARY 
FROM EMPLOYEE E 
JOIN JOBDEPARTMENT JD
ON E.JOB_ID = JD.JOB_ID
JOIN SALARYBONUS SB
ON JD.JOB_ID = SB.JOB_ID
ORDER BY SB.AMOUNT DESC
LIMIT 5;

-- ● What is the total salary expenditure across the company?
SELECT SUM(TOTAL_AMOUNT) TOTAL_SALARY_EXPENDITURE FROM PAYROLL;

-- 2. JOB ROLE AND DEPARTMENT ANALYSIS
-- How many different job roles exist in each department?
SELECT JOBDEPT AS DEPARTMENT, COUNT(DISTINCT NAME) AS JOB_ROLES
FROM JOBDEPARTMENT
GROUP BY JOBDEPT
ORDER BY JOB_ROLES DESC;

-- What is the average salary range per department?
SELECT JOBDEPT,
       ROUND(AVG((CAST(REPLACE(SUBSTRING_INDEX(SALARYRANGE, '-', 1), '$', '') AS UNSIGNED)
				+
				CAST(REPLACE(SUBSTRING_INDEX(SALARYRANGE, '-', -1), '$', '') AS UNSIGNED)
               ) / 2), 2) AS AVG_SALARY_RANGE
FROM JOBDEPARTMENT
GROUP BY JOBDEPT;


-- Which job roles offer the highest salary?
SELECT JD.NAME AS JOB_ROLE, MAX(SB.AMOUNT) AS HIGHEST_SALARY
FROM JOBDEPARTMENT JD
JOIN SALARYBONUS SB
ON JD.JOB_ID = SB.JOB_ID
GROUP BY JD.NAME
ORDER BY HIGHEST_SALARY DESC;

-- Which departments have the highest total salary allocation?
SELECT JD.JOBDEPT AS DEPARTMENT, SUM(SB.AMOUNT) AS HIGHEST_ALLOCATION
FROM JOBDEPARTMENT JD
JOIN SALARYBONUS SB
ON JD.JOB_ID = SB.JOB_ID
GROUP BY JD.JOBDEPT
ORDER BY HIGHEST_ALLOCATION DESC;

-- 3. QUALIFICATION AND SKILLS ANALYSIS
-- ● How many employees have at least one qualification listed? 
SELECT COUNT(DISTINCT EMP_ID) AS 'EMPLOYEES WITH QUALIFICATION' 
FROM QUALIFICATION;

-- ● Which positions require the most qualifications?
SELECT Position, COUNT(*) AS Qualification_Count
FROM Qualification
GROUP BY Position
ORDER BY Qualification_Count DESC;

-- ● Which employees have the highest number of qualifications?
SELECT e.emp_ID,
       CONCAT(e.firstname,' ',e.lastname) AS Employee_Name,
       COUNT(q.QualID) AS Qualification_Count
FROM Employee e
JOIN Qualification q
ON e.emp_ID = q.Emp_ID
GROUP BY e.emp_ID
ORDER BY Qualification_Count DESC;

-- 4. LEAVE AND ABSENCE PATTERNS
-- Which year had the most employees taking leaves?
SELECT YEAR(date) AS LeaveYear,
       COUNT(DISTINCT emp_ID) AS Employees_On_Leave
FROM Leaves
GROUP BY YEAR(date)
ORDER BY Employees_On_Leave DESC;

-- What is the average number of leave days taken by its employees per department?
SELECT jd.jobdept AS Department, AVG(LeaveCount) AS AvgLeaveDays
FROM (
      SELECT e.emp_ID, e.Job_ID, COUNT(l.leave_ID) AS LeaveCount
      FROM Employee e
	  LEFT JOIN Leaves l
      ON e.emp_ID = l.emp_ID
      GROUP BY e.emp_ID, e.Job_ID
     ) t
JOIN JobDepartment jd
ON t.Job_ID = jd.Job_ID
GROUP BY jd.jobdept;

-- Which employees have taken the most leaves?
SELECT e.emp_ID,
       CONCAT(e.firstname,' ',e.lastname) AS EmployeeName,
       COUNT(l.leave_ID) AS LeaveCount
FROM Employee e
JOIN Leaves l
ON e.emp_ID = l.emp_ID
GROUP BY e.emp_ID
ORDER BY LeaveCount DESC;

-- What is the total number of leave days taken company-wide?
SELECT COUNT(*) AS Total_Leave_Days
FROM Leaves;

-- How do leave days correlate with payroll amounts?
SELECT e.emp_ID,
       CONCAT(e.firstname,' ',e.lastname) AS EmployeeName,
       COUNT(l.leave_ID) AS LeaveDays,
       AVG(p.total_amount) AS AvgPayroll
FROM Employee e
LEFT JOIN Leaves l
ON e.emp_ID = l.emp_ID
LEFT JOIN Payroll p
ON e.emp_ID = p.emp_ID
GROUP BY e.emp_ID, EmployeeName;

-- 5. PAYROLL AND COMPENSATION ANALYSIS
-- What is the total monthly payroll processed?
SELECT YEAR(DATE) AS Year, MONTH(DATE) AS Month, SUM(TOTAL_AMOUNT) AS MONTHLY_PAYROLL
FROM PAYROLL
GROUP BY Year, Month
ORDER BY Year, Month;

-- What is the average bonus given per department?
SELECT JD.JOBDEPT AS DEPARTMENT, ROUND(AVG(SB.BONUS), 2) AS AVERAGE_BONUS
FROM JOBDEPARTMENT JD
JOIN SALARYBONUS SB
ON JD.JOB_ID = SB.JOB_ID
GROUP BY JD.JOBDEPT;

-- Which department receives the highest total bonuses?
SELECT JD.JOBDEPT AS DEPARTMENT, SUM(SB.BONUS) AS TOTAL_BONUS
FROM JOBDEPARTMENT JD
JOIN SALARYBONUS SB
ON JD.JOB_ID = SB.JOB_ID
GROUP BY JD.JOBDEPT
ORDER BY TOTAL_BONUS DESC
LIMIT 1;

-- What is the average value of total_amount after considering leave deductions?
SELECT ROUND(AVG(TOTAL_AMOUNT), 2) AS AVG_NET_PAYROLL
FROM PAYROLL;



