-- Q1: List all customers from the USA along with their state and email
select CustomerID, FirstName, LastName, State, Email
from customer
where Country = 'USA';


-- Q2: Show the top 5 tracks by unit price
select TrackId, Name, UnitPrice
from track
order by UnitPrice desc
limit 5;


-- Q3: Count how many tracks there are for each genre
select g.Name, count(t.TrackId) as tracks_count
from track t 
join genre g on g.GenreId = t.GenreId
group by g.Name
order by tracks_count desc;


-- Q4: List all invoices from 2023, ordered by invoice date descending
select InvoiceId, CustomerId, InvoiceDate, Total
from invoice
where Year(InvoiceDate) = 2023
order by InvoiceDate desc;


-- Q5: Find the average unit price of tracks for each album
select a.AlbumId, a.Title, avg(t.UnitPrice) as avg_unitprice
from track t 
join album a on a.AlbumId = t.AlbumId
group by a.AlbumId, a.Title;


-- Q6: Show each track’s unit price and the difference from the average unit price
select TrackId, Name, UnitPrice, avg(UnitPrice) over() - UnitPrice as Diff_avg_unitprice
from track;


-- Q7: Rank customers by their total amount spent (by country)
select c.CustomerId, FirstName, LastName, c.Country,
sum(i.Total) as total_spent,
rank() over(partition by c.Country order by sum(i.Total) desc) as cust_rank
from customer c 
join invoice i on i.CustomerId = c.CustomerId
group by c.CustomerId, FirstName, LastName, c.Country;


-- Q8: Cumulative total amount for each customer up to that invoice date
select CustomerId, InvoiceId, InvoiceDate, Total,
sum(Total) over(partition by CustomerId order by InvoiceDate) as Cum_total
from invoice;


-- Q9: Top 3 most expensive tracks per genre
with cte as (
select GenreId, TrackId, Name, UnitPrice,
row_number() over (partition by GenreID order by UnitPrice desc) as RowNum
from track
)
select GenreId, TrackId, Name, UnitPrice
from cte 
where RowNum <= 3;


-- Q10: Each track with the maximum unit price in its genre
with cte as (
select TrackId, Name, GenreId, UnitPrice,
           max(UnitPrice) over (partition by GenreId) as MaxPriceInGenre
    from Track
    )
    select TrackId, Name, GenreId, UnitPrice
    from cte 
    where UnitPrice = MaxPriceInGenre;

