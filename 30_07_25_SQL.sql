USE classicmodels;
SHOW TABLES;

-- 1. Top Customers by Payments
-- Q: Which 5 customers made the highest total payments?
select p.customerNumber, c.customerName, sum(amount) as total_payment
from payments p 
join customers c on c.customerNumber = p.customerNumber
group by p.customerNumber, c.customerName
order by total_payment desc
limit 5;


-- 2. Monthly Revenue
-- Q: What is the total revenue per month? Show year, month, and total.
select year(orderDate) as year, month(orderDate) as month, sum(quantityOrdered*priceEach) as total_revenue
from orders o
join orderdetails od on od.orderNumber = o.orderNumber
group by year(orderDate), month(orderDate)
order by year, month, total_revenue desc;


-- 3. Employee-Customer Map
-- Q: List all customers along with their sales rep’s name and office city.
select customerName, salesRepEmployeeNumber, city
from customers;


-- 4. Pending vs. Completed Orders
-- Q: How many orders are in each status (e.g., Shipped, Cancelled, etc.)?
select status, count(orderNumber) as order_count
from orders
group by status;


-- 5. Average Order Value per Customer
-- Q: For each customer, calculate their average order value (based on orderdetails).
select o.customerNumber, avg(od.quantityOrdered*od.priceEach) as avg_order_value
from orders o 
join orderdetails od on o.orderNumber = od.orderNumber
group by o.customerNumber
order by o.customerNumber;


-- 6. Rank Customers by Total Payments
-- Q: Rank all customers by their total payment within each country.
select c.country, c.customerNumber, sum(p.amount) as total_payment,
rank() over(partition by country order by sum(p.amount) desc) as payment_rank
from customers c 
join payments p on p.customerNumber = c.customerNumber
group by c.country, c.customerNumber;


-- 7. Cumulative Payments Over Time
-- Q: Compute a running total of payments over time across the entire company.
select paymentDate, amount, sum(amount) over(order by paymentDate) as running_total
from payments;


-- 8. First and Last Order per Customer
-- Q: Show first and last order date per customer using window functions.
select distinct customerNumber, 
min(orderDate) over(partition by customerNumber) as first_orderDate,
max(orderDate) over(partition by customerNumber) as last_orderDate
from orders;


-- 9. Lag Analysis: Days Between Orders per Customer
-- Q: Calculate how many days passed between each customer’s consecutive orders.
select 
  customerNumber,
  orderDate,
  lag(orderDate) over (partition by customerNumber order by orderDate) as previous_order,
  datediff(orderDate, lag(orderDate) over (partition by customerNumber order by orderDate)) as days_between_orders
from orders;


-- 10. Sales Employee Revenue Percentile
-- Q: Calculate the percentile rank of each sales employee based on the total revenue they handled.
with cte as (
select 
    e.employeeNumber,
    e.firstName,
    e.lastName,
    sum(p.amount) as total_sales
  from employees e
  join customers c on e.employeeNumber = c.salesRepEmployeeNumber
  join payments p on c.customerNumber = p.customerNumber
  group BY e.employeeNumber
)
select *, percent_rank() over(order by total_sales desc) as sales_percentile
from cte
