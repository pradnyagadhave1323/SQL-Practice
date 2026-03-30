CREATE database subqueryDB;
USE subqueryDB;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT,
    city VARCHAR(50)
);

INSERT INTO departments VALUES
(1, 'HR', 'Pune'),
(2, 'IT', 'Mumbai'),
(3, 'Finance', 'Delhi'),
(4, 'Marketing', 'Pune');

INSERT INTO employees VALUES
(101, 'Amit', 1, 50000, 'Pune'),
(102, 'Neha', 2, 60000, 'Mumbai'),
(103, 'Rahul', 2, 55000, 'Pune'),
(104, 'Sneha', 3, 70000, 'Delhi'),
(105, 'Kiran', 4, 45000, 'Mumbai'),
(106, 'Priya', 1, 52000, 'Pune'),
(107, 'Vikas', 3, 48000, 'Delhi'),
(108, 'Anjali', NULL, 40000, 'Pune');

-- Employees earning more than average salary
SELECT emp_name, salary
FROM employees 
WHERE salary > (
    SELECT AVG(salary) from employees
);

-- Find employees working in departments located in Pune
SELECT emp_name
FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments WHERE location = 'Pune'
);

-- Find employees who earn more than 'Amit'
SELECT emp_name, salary
FROM employees
WHERE salary > (
    SELECT salary FROM employees WHERE emp_name = 'Amit'
);

-- Find employees who belong to same department as 'Neha'
SELECT emp_name
FROM employees
WHERE dept_id = (
    SELECT dept_id FROM employees WHERE emp_name = 'Neha'
);

-- Find departments that have employees
SELECT dept_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE d.dept_id = e.dept_id
);

-- Find employees who do NOT belong to any department
SELECT emp_name
FROM employees
WHERE dept_id is NULL;

-- Find employees earning less than ALL employees in IT department
SELECT emp_name, salary
FROM employees
WHERE salary < ALL (
    SELECT salary
    FROM employees
    WHERE dept_id = (
        SELECT dept_id FROM departments WHERE dept_name = 'IT'
    )
);

-- Find highest salary employee using subquery
SELECT emp_name, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary) FROM employees
);

-- Find employees earning more than their department average
SELECT emp_name
FROM employees e1
WHERE salary > (
    SELECT AVG(salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id
);

-- Find departments with NO employees
SELECT dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.dept_id = d.dept_id
);
