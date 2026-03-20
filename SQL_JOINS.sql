CREATE DATABASE CompanyDB;
USE CompanyDB;

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    manager_id INT,
    salary INT,
    city VARCHAR(50)
);

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT
);

CREATE TABLE EmployeeProjects (
    emp_id INT,
    project_id INT,
    hours_worked INT
);

INSERT INTO Employees VALUES
(1,'Amit',101,NULL,70000,'Pune'),
(2,'Neha',102,1,60000,'Mumbai'),
(3,'Rahul',101,1,65000,'Delhi'),
(4,'Priya',103,2,55000,'Pune'),
(5,'Karan',104,2,50000,'Bangalore'),
(6,'Sneha',102,1,62000,'Mumbai'),
(7,'Arjun',101,3,72000,'Delhi'),
(8,'Riya',103,4,48000,'Pune');

INSERT INTO Departments VALUES
(101,'IT','Pune'),
(102,'HR','Mumbai'),
(103,'Finance','Delhi'),
(104,'Marketing','Bangalore');

INSERT INTO Projects VALUES
(201,'AI System',101),
(202,'HR Portal',102),
(203,'Finance Tracker',103),
(204,'Marketing Campaign',104),
(205,'Data Warehouse',101);

INSERT INTO EmployeeProjects VALUES
(1,201,120),
(2,202,80),
(3,205,100),
(4,203,90),
(5,204,70),
(6,202,60),
(7,201,110),
(8,203,75);

-- Display employee name and department name.
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;

-- Display employee name and department location.
SELECT e.emp_name, d.location
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;

-- Show all employees and their department names including employees without departments.
SELECT e.emp_name, d.dept_name
FROM Employees e
LEFT JOIN Departments d
ON e.dept_id = d.dept_id;

-- Show all departments and their employees.
SELECT e.emp_name,d.dept_name
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;

-- Display employee name and project name they are working on.
SELECT e.emp_name, p.project_name
FROM employees e
INNER JOIN Projects p
ON e.dept_id = p.dept_id;

-- Display employee name and hours worked on project.
SELECT e.emp_name, p.hours_worked
FROM employees e
INNER JOIN EmployeeProjects p
ON e.emp_id = p.emp_id;

-- Show project name and department name.
SELECT p.project_name, d.dept_name
FROM projects p
INNER JOIN departments d
ON p.dept_id = d.dept_id;

-- List all employees working in the IT department.
SELECT e.emp_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.dept_name = 'IT';

-- Display employees and their managers.
SELECT emp_name, manager_id
FROM employees;

-- Find employees who belong to the Finance department.
SELECT e.emp_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Finance';

-- Show all projects handled by the HR department.
SELECT p.project_name
FROM projects p
INNER JOIN departments d
ON p.dept_id = d.dept_id
WHERE d.dept_name = 'HR';

-- Display employee name and project name for employees in Pune.
SELECT e.emp_name,p.project_name
FROM projects p
INNER JOIN Employees e
ON p.dept_id = e.dept_id
WHERE e.city = 'Pune';

-- List employees who are assigned to any project.
SELECT DISTINCT e.emp_name
FROM employees e
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id;

-- Show employees who are not assigned to any project.
SELECT DISTINCT e.emp_name
FROM employees e
LEFT JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
WHERE ep.project_id is NULL;

-- Display department name and number of employees in each department.
SELECT d.dept_name,  COUNT(e.emp_name) AS emp_count
FROM employees e 
INNER JOIN departments d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- Find employees working in the same department as 'Rahul'.
SELECT e1.emp_name
FROM employees e1
INNER JOIN employees e2
ON e1.dept_id = e2.dept_id
WHERE e2.emp_name = 'Rahul'
AND e1.emp_name != 'Rahul';

-- Display department name and average salary of employees.
SELECT d.dept_name, AVG(e.salary)
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- Find departments where average salary > 60000.
SELECT d.dept_name, AVG(e.salary) AS emp_avg_sal
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 60000;

-- Display employee name and total hours worked across all projects.
SELECT e.emp_name, SUM(ep.hours_worked) AS total_hours
FROM employees e
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
GROUP BY e.emp_name;

-- Find project with maximum number of employees.
SELECT TOP 1 p.project_name, COUNT(ep.emp_id) AS total_employees
FROM projects p
INNER JOIN EmployeeProjects ep
ON p.project_id = ep.project_id
GROUP BY p.project_name
ORDER BY total_employees DESC

-- Find departments that have no employees.
SELECT d.dept_name
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;

-- Find employees who work on more than one project.
SELECT e.emp_name, COUNT(ep.project_id) AS total_projects
FROM employees e
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
GROUP BY e.emp_name
HAVING COUNT(ep.project_id) > 1;

-- Find projects with no employees assigned.
SELECT p.project_name
FROM projects p
LEFT JOIN EmployeeProjects ep
ON p.project_id = ep.project_id
WHERE ep.emp_id IS NULL;

-- Find departments with more than 2 employees.
SELECT d.dept_name, COUNT(e.emp_id) AS emp_count
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) > 2;

-- Display employee name, department name, and project name.
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
INNER JOIN projects p
ON ep.project_id = p.project_id;

-- Find employees working in departments located in Mumbai.
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.location = 'Mumbai';

-- Find projects handled by departments located in Pune.
SELECT p.project_name, d.dept_name
FROM projects p
INNER JOIN departments d
ON p.dept_id = d.dept_id
WHERE d.location = 'Pune';

-- Find employees working on the 'AI System' project.
SELECT e.emp_name
FROM employees e
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
INNER JOIN projects p
ON ep.project_id = p.project_id
WHERE p.project_name = 'AI System';

-- Find departments with total salary greater than 150000.
SELECT d.dept_name, SUM(e.salary) AS total_sal
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING SUM(e.salary) > 150000;

-- Display employee name and number of projects they are working on.
SELECT e.emp_name, COUNT(ep.project_id) AS total_projects
FROM employees e
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
GROUP BY e.emp_name;

-- Find employees who work on projects from their own department.
SELECT DISTINCT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
INNER JOIN projects p
ON ep.project_id = p.project_id
WHERE e.dept_id = p.dept_id;

-- Display employees working in the same city as their department location.
SELECT e.emp_name, e.city, d.location
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.city = d.location;

-- Find employees whose department location is different from their city.
SELECT e.emp_name, e.city, d.location
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.city != d.location;

-- Find departments that have employees working on projects.
SELECT DISTINCT d.dept_name
FROM departments d
INNER JOIN employees e
ON d.dept_id = e.dept_id
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id;

-- Find the department with the highest total salary.
SELECT TOP 1 d.dept_name, SUM(e.salary) AS hig_total_sal
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY SUM(e.salary) DESC

-- Find the employee who works on the maximum number of projects.
SELECT TOP 1 e.emp_name, COUNT(ep.project_id) AS total_projects
FROM employees e
INNER JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
GROUP BY e.emp_name
ORDER BY total_projects DESC

-- Find employees working on projects from multiple departments.
SELECT e.emp_name, COUNT(DISTINCT p.dept_id) AS dept_count
FROM employees e
INNER JOIN EmployeeProjects ep ON e.emp_id = ep.emp_id
INNER JOIN projects p ON ep.project_id = p.project_id
GROUP BY e.emp_name
HAVING COUNT(DISTINCT p.dept_id) > 1;

-- Find departments whose employees work on more than 3 projects combined.
SELECT d.dept_name, COUNT(ep.project_id) AS total_projects
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
INNER JOIN EmployeeProjects ep ON e.emp_id = ep.emp_id
GROUP BY d.dept_name
HAVING COUNT(ep.project_id) > 3;
