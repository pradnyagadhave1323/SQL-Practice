-- WINDOW FUNCTION	
-- Add row number to employees
SELECT name, salary,
ROW_NUMBER() OVER(ORDER by salary ) AS rw
FROM Employee;


-- Rank employees by salary
SELECT name, salary,
RANK() OVER(ORDER by salary DESC ) AS r
FROM Employee;

-- Dense rank employees by salary
SELECT name, salary,
DENSE_RANK() OVER(ORDER by salary DESC ) AS dr
FROM Employee;

-- Row number per department
SELECT name,departmentID, salary,
ROW_NUMBER() OVER(PARTITION BY departmentID ORDER by salary ) AS rw
FROM Employee;

-- Rank employees within each department
SELECT name,departmentID, salary,
RANK() OVER(PARTITION BY departmentID ORDER by salary ) AS r
FROM Employee;

-- Top salary per department
SELECT * FROM(
	SELECT name,departmentID, salary,
	RANK() OVER(PARTITION BY departmentID ORDER by salary DESC) AS r
	FROM Employee
) t
WHERE r = 1;

-- Second highest salary per department
SELECT * FROM(
	SELECT name,departmentID, salary,
	DENSE_RANK() OVER(PARTITION BY departmentID ORDER by salary ) AS r
	FROM Employee
) t
WHERE r = 2;

-- Top 2 salaries per department
SELECT * FROM(
	SELECT name,departmentID, salary,
	DENSE_RANK() OVER(PARTITION BY departmentID ORDER by salary ) AS r
	FROM Employee
) t
WHERE r <= 2;

-- Lowest salary per department
SELECT * FROM(
	SELECT name,departmentID, salary,
	RANK() OVER(PARTITION BY departmentID ORDER by salary ) AS r
	FROM Employee
) t
WHERE r = 1;

-- Highest salary per department
SELECT * FROM (
    SELECT name, departmentID, salary,
    RANK() OVER (PARTITION BY departmentID ORDER BY salary DESC) AS rnk
    FROM employee
) t WHERE rnk = 1;

-- Difference between employee salary and department average
SELECT name, departmentID, salary,
AVG(salary) OVER (PARTITION BY department) AS dept_avg,
salary - AVG(salary) OVER (PARTITION BY department) AS diff_from_avg
FROM employee;

-- Show previous employee salary (LAG)
SELECT name, salary,
LAG(salary) OVER (ORDER BY salary) AS prev_salary
FROM employee;

-- Show next employee salary (LEAD)
SELECT name, salary,
LEAD(salary) OVER (ORDER BY salary) AS next_salary
FROM employee;

-- Running total salary
SELECT name, salary,
SUM(salary) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM employee;

-- Running average salary
SELECT name, salary,
AVG(salary) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM employee;

-- 3rd highest salary per department
SELECT * FROM (
    SELECT name, departmentID, salary,
    DENSE_RANK() OVER (PARTITION BY departmentID ORDER BY salary DESC) AS rnk
    FROM employee
) t WHERE rnk = 3;

-- Employees whose salary above department average
SELECT name, departmentID, salary, dept_avg FROM (
    SELECT name, departmentID, salary,
    AVG(salary) OVER (PARTITION BY departmentID) AS dept_avg
    FROM employee
) t WHERE salary > dept_avg;


-- CTE
-- Create a CTE that shows employees with salary > 50000
WITH high_earners AS (
    SELECT * FROM employee WHERE salary > 50000
)
SELECT * FROM high_earners;

-- Use CTE to calculate average salary
WITH avg_salary AS (
    SELECT AVG(salary) AS avg_sal FROM employee
)
SELECT * FROM avg_salary;

-- Show employees earning above average salary using CTE
WITH avg_salary AS (
    SELECT AVG(salary) AS avg_sal FROM employee
)
SELECT * FROM employee
WHERE salary > (SELECT avg_sal FROM avg_salary);

-- Show employees earning below average salary
WITH avg_salary AS (
    SELECT AVG(salary) AS avg_sal FROM employee
)
SELECT * FROM employee
WHERE salary < (SELECT avg_sal FROM avg_salary);

-- Total salary per department using CTE
WITH dept_salary AS (
    SELECT departmentID, SUM(salary) AS total_salary
    FROM employee
    GROUP BY departmentID
)
SELECT * FROM dept_salary;

-- Employees with highest salary per department using CTE
WITH dept_max AS (
    SELECT departmentID, MAX(salary) AS max_salary
    FROM employee
    GROUP BY departmentID
)
SELECT e.name, e.departmentID, e.salary
FROM employee e
INNER JOIN dept_max d
ON e.departmentID = d.departmentID AND e.salary = d.max_salary;

-- Employees with second highest salary per department
WITH dept_ranks AS (
    SELECT name, departmentID, salary,
    DENSE_RANK() OVER (PARTITION BY departmentID ORDER BY salary DESC) AS rnk
    FROM employee
)
SELECT * FROM dept_ranks WHERE rnk = 2;

-- Top 2 salaries per department
WITH dept_ranks AS (
    SELECT name, departmentID, salary,
    DENSE_RANK() OVER (PARTITION BY departmentID ORDER BY salary DESC) AS rnk
    FROM employee
)
SELECT * FROM dept_ranks WHERE rnk <= 2;

-- Departments with average salary > 50000
WITH dept_avg AS (
    SELECT departmentID, AVG(salary) AS avg_salary
    FROM employee
    GROUP BY departmentID
)
SELECT * FROM dept_avg WHERE avg_salary > 50000;

-- Employees earning above department average
WITH dept_avg AS (
    SELECT departmentID, AVG(salary) AS avg_salary
    FROM employee
    GROUP BY departmentID
)
SELECT e.name, e.departmentID, e.salary, d.avg_salary
FROM employee e
INNER JOIN dept_avg d ON e.departmentID = d.departmentID
WHERE e.salary > d.avg_salary;

-- Departments with highest total salary
WITH dept_total AS (
    SELECT TOP 1 departmentID, SUM(salary) AS total_salary
    FROM employee
    GROUP BY departmentID
)
SELECT * FROM dept_total
ORDER BY total_salary DESC

-- Employees with top salary in each department
WITH dept_ranks AS (
    SELECT name, departmentID, salary,
    RANK() OVER (PARTITION BY departmentID ORDER BY salary DESC) AS rnk
    FROM employee
)
SELECT * FROM dept_ranks WHERE rnk = 1;

-- 3rd highest salary in company
WITH salary_ranks AS (
    SELECT name, salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employee
)
SELECT * FROM salary_ranks WHERE rnk = 3;

-- Top 3 salaries per department
WITH dept_ranks AS (
    SELECT name, departmentID, salary,
    DENSE_RANK() OVER (PARTITION BY departmentID ORDER BY salary DESC) AS rnk
    FROM employee
)
SELECT * FROM dept_ranks WHERE rnk <= 3;

-- Employee with highest salary overall
WITH max_salary AS (
    SELECT MAX(salary) AS max_sal FROM employee
)
SELECT * FROM employee
WHERE salary = (SELECT max_sal FROM max_salary);