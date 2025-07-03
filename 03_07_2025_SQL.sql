select * from customers;
select * from date;
select * from markets;
select * from products;
select * from transactions;

-- Q1. Top 5 Customers by Total Spend
-- Find customers whose total purchase (sum of quantity × unit_price) is highest.
select c.customer_code, sum(t.sales_qty * t.sales_amount) as total_price
from transactions t 
join customers c on c.customer_code = t.customer_code
group by c.customer_code
order by total_price desc
limit 5;




-- Q2. Monthly Sales Trend
-- Calculate total sales per month (YYYY-MM) for the last 100 months.
select date_format(order_date, '%y-%m') as month, sum(sales_qty*sales_amount) as total_price
from transactions
where order_date >= date_sub(curdate(), interval 100 month)
group by date_format(order_date, '%y-%m')
order by month;





-- Q3. Best-Selling Products 
-- List top 3 products by total units sold.
select product_code, sum(sales_qty*sales_amount) as total_price
from transactions
group by product_code
order by total_price desc
limit 3;




 -- Q4. Repeat Customers Analysis
-- Find customers with more than two orders and show their average order value.
select c.customer_code, count(t.order_date) as order_count, round(avg(t.sales_qty*t.sales_amount),2) as avg_order_values
from transactions t 
join customers c on c.customer_code = t.customer_code
group by c.customer_code
having count(t.order_date) > 2
order by round(avg(t.sales_qty*t.sales_amount),2) desc;








