create database window_function;
use window_function;

CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT,
    join_date DATE
);
INSERT INTO employees VALUES
(1, 'Amit', 101, 50000, '2023-01-01'),
(2, 'Neha', 101, 60000, '2023-02-01'),
(3, 'Raj', 102, 70000, '2023-01-15'),
(4, 'Simran', 102, 70000, '2023-03-01'),
(5, 'Karan', 103, 40000, '2023-02-10'),
(6, 'Pooja', 103, 45000, '2023-02-15'),
(7, 'Vikas', 101, 80000, '2023-04-01'),
(8, 'Anjali', 102, 90000, '2023-05-01');

CREATE TABLE sales (
    sale_id INT,
    sale_date DATE,
    amount INT
);
INSERT INTO sales VALUES
(1, '2023-01-01', 100),
(2, '2023-01-02', 200),
(3, '2023-01-03', 150),
(4, '2023-01-04', 300),
(5, '2023-01-05', 250);

-- Rank employees without skipping ranks.
SELECT *, 
DENSE_RANK() OVER (
        ORDER BY salary DESC
       ) AS rn
FROM employees;

-- Show each employee with total department salary.
SELECT *,
SUM(salary) OVER (
        PARTITION BY dept_id
      ) as rn
FROM employees;

-- Show employee count per department for each row.
SELECT *,
COUNT(emp_id) OVER (
      PARTITION BY dept_id
) as rn
FROM employees;

-- Calculate cumulative sales by date.
SELECT *, 
SUM(amount) OVER (
    ORDER BY sale_date
) AS running_total
FROM sales;

-- Show previous salary of each employee.
SELECT emp_name, dept_id, salary,  
LAG(salary) OVER (
    PARTITION BY dept_id
    ORDER BY salary DESC
) AS prev_salary
FROM employees;

-- Show next salary of each employee.
SELECT *, 
LEAD(salary) OVER (
    ORDER BY salary
) AS prev_salary
FROM employees;

-- Show difference between current and previous salary.
SELECT *,
salary - LAG(salary) OVER (
    ORDER BY salary
) AS diff
FROM employees;

-- Show first salary in each department.
SELECT *,
FIRST_VALUE(salary) OVER (
    PARTITION BY dept_id 
    ORDER BY salary
) AS first_sal
FROM employees;

-- Show last salary in department.
SELECT *,
LAST_VALUE(salary) OVER (
    PARTITION BY dept_id 
    ORDER BY salary 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS last_sal
FROM employees;

-- Find top 3 highest-paid employees in each department.
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY dept_id 
        ORDER BY salary DESC
    ) rn
    FROM employees
) t
WHERE rn <= 3;

-- Delete duplicate records keeping latest entry.
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY salary 
        ORDER BY join_date DESC
    ) rn
    FROM employees
)
DELETE FROM cte WHERE rn > 1;

-- Find 2nd or 3rd highest salary.
SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (
        ORDER BY salary DESC
    ) rnk
    FROM employees
) t
WHERE rnk = 2;

-- Split employees into 4 groups based on salary.
SELECT *, NTILE(4) OVER (
    ORDER BY salary
) AS quartile
FROM employees;

-- Calculate 3-day moving average of sales.
SELECT *,
AVG(amount) OVER (
    ORDER BY sale_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS moving_avg
FROM sales;

-- Count rows cumulatively within each category.
SELECT *,
COUNT(*) OVER (
    PARTITION BY dept_id 
    ORDER BY salary
) AS running_count
FROM employees;

-- Identify duplicate rows.
SELECT *,
COUNT(*) OVER (
    PARTITION BY salary
) AS dup_count
FROM employees;

-- Find continuous date ranges
SELECT *,
DATEADD(DAY, -ROW_NUMBER() OVER (
    ORDER BY sale_date), sale_date
) grp
FROM sales;

-- Return only highest salary employee per department.
SELECT *
FROM (
    SELECT *, RANK() OVER (
        PARTITION BY dept_id 
        ORDER BY salary DESC
    ) rnk
    FROM employees
) t
WHERE rnk = 1;

-- Find 2nd highest salary in each department.
SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (
        PARTITION BY dept_id 
        ORDER BY salary DESC
    ) rnk
    FROM employees
) t
WHERE rnk = 2;

-- Find rows where value is higher than previous.
SELECT *
FROM (
    SELECT *, LAG(amount) OVER (
        ORDER BY sale_date
    ) prev_amt
    FROM sales
) t
WHERE amount > prev_amt;

-- Show all employees along with a row number based on salary (highest to lowest).
SELECT *, 
ROW_NUMBER() OVER(
    ORDER BY salary DESC
) as rn 
FROM employees;

-- Show row number of employees within each department based on salary (highest first).
SELECT emp_name, dept_id, salary,
ROW_NUMBER() OVER(
    PARTITION BY dept_id 
    ORDER BY salary DESC
) AS rn
FROM employees;

-- Show employee salary rank using RANK() instead of ROW_NUMBER.
SELECT emp_name, dept_id, salary, 
RANK() OVER(
    ORDER BY salary DESC
) AS sal_rank 
FROM employees;

-- Show:name department salary department average salary (using window function)
SELECT 
    emp_name,
    dept_id,
    salary,
    AVG(salary) OVER (
        PARTITION BY dept_id
    ) AS dept_avg_sal
FROM employees;

-- Show employees who earn more than their department average salary.(Using CTE)
WITH DepartmentAVGSalary AS(
    SELECT
        emp_name,
        dept_id,
        salary,
        AVG(Salary) OVER(
            PARTITION BY dept_id
    ) AS AVG_dept_sal
    FROM employees
)
SELECT AVG_dept_sal
FROM DepartmentAVGSalary
WHERE salary > AVG_dept_sal;

-- Write SQL query to get 2nd highest salary per department.(Using CTE)
WITH rank_emp AS(
    SELECT
        emp_name,
        dept_id,
        salary,
        DENSE_RANK() OVER(
            PARTITION BY dept_id 
            ORDER BY SALARY DESC
        ) AS emp_rank
        FROM employees
)
SELECT emp_rank
FROM rank_emp
WHERE emp_rank = 2;

-- Calculate running total of salary within each department ordered by salary.
SELECT emp_name, salary,
SUM(salary) OVER(
                PARTITION BY dept_id 
                ORDER BY salary DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS running_total
FROM employees;

-- Find employees whose salary is higher than the previous employee salary in the same department
WITH PrevEmpSal AS (
    SELECT 
        emp_name,
        dept_id,
        salary,
        LAG(salary) OVER(
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS prev_salary
    FROM employees
)
SELECT 
    emp_name,
    dept_id,
    salary,
    prev_salary
FROM PrevEmpSal 
WHERE salary > prev_salary;

-- difference between next salary and current salary
SELECT 
    emp_name,
    dept_id,
    salary,
    LEAD(salary) OVER (
        PARTITION BY dept_id 
        ORDER BY salary ASC
    ) AS next_salary,
    LEAD(salary) OVER (
        PARTITION BY dept_id 
        ORDER BY salary ASC
    ) - salary AS salary_diff
FROM employees;


