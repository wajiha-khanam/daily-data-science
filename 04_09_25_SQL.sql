create database sample1;
use sample1;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing');


CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(dept_id)
);

INSERT INTO employees (emp_id, name, department_id, salary, hire_date) VALUES
(101, 'Alice', 1, 50000, '2015-03-01'),
(102, 'Bob', 2, 60000, '2018-07-15'),
(103, 'Charlie', 2, 70000, '2012-11-23'),
(104, 'David', 3, 65000, '2019-01-10'),
(105, 'Eva', 3, 80000, '2014-05-17'),
(106, 'Frank', 4, 55000, '2020-02-21'),
(107, 'Grace', 2, 60000, '2016-09-09'),
(108, 'Hannah', NULL, 45000, '2017-06-13'),
(109, 'Ian', 1, 50000, '2013-04-29'),
(110, 'Julia', 4, 72000, '2021-12-01');

select * from departments;
select * from employees;

-- Q1. Filtering & Aggregation
-- Find the highest salary in each department and return the department along with that salary.
select d.dept_id, d.dept_name, max(e.salary) as highest_salary
from employees e 
join departments d on e.department_id = d.dept_id
group by d.dept_id, d.dept_name;


-- Q2. Window Functions
-- For each employee, display their salary along with the average salary of their department.
with cte as (
select d.dept_id, d.dept_name, avg(e.salary) as avg_salary
from employees e 
join departments d on e.department_id = d.dept_id
group by d.dept_id, d.dept_name
)
select e.emp_id, e.name, e.salary, ct.dept_name, ct.avg_salary
from employees e 
join cte ct on e.department_id = ct.dept_id;


-- Q3. Ranking
-- Write a query to assign a rank to employees in each department based on salary (highest = rank 1).
select d.dept_id, d.dept_name, e.emp_id, e.name, e.salary,
dense_rank() over(partition by d.dept_id order by e.salary desc) as salary_rank
from employees e 
join departments d on e.department_id = d.dept_id;


-- Q4. Date Functions
-- Find employees who have completed at least 5 years in the company.
with cte as (
select emp_id, name, timestampdiff(year, hire_date, curdate()) as duration
from employees
)
select emp_id, name
from cte	
where duration >= 5;


-- Q5. Self Join
-- Find all employees who have the same salary as someone else in the company.
select e1.name, e1.emp_id, e1.salary
from employees e1
join employees e2 on e1.salary = e2.salary and e1.emp_id <> e2.emp_id
order by e1.salary;


-- Q6. Subquery
-- List employees whose salary is greater than the overall average salary.
select emp_id, name, salary
from employees
where salary > (select avg(salary) as avg_salary from employees);


-- Q7. Joins
-- Return the department name along with the number of employees working in each department.
select d.dept_id, d.dept_name, count(e.emp_id) as emp_count
from employees e 
join departments d on e.department_id = d.dept_id
group by d.dept_id, d.dept_name;


-- Q8. HAVING Clause
-- Find departments where the average salary > 60,000.
select d.dept_id, d.dept_name
from employees e 
join departments d on e.department_id = d.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary) > 60000;


-- Q9. Find the top 3 highest-paid employees in the company.
select emp_id, name, salary
from employees
order by salary desc
limit 3;


-- Q10. Tricky Set Operation
-- Get a list of employees who are not assigned to any department (assume some dept_id might be NULL in employees).
select emp_id, name
from employees e 
left join departments d on e.department_id = d.dept_id
where d.dept_id is null;





