create database hotel_db;
use hotel_db;

select * 
from hotel_bookings;


-- 1. Cancellation Rate
-- 🔹 Find total bookings and number of cancelled bookings. What is the cancellation rate?
select round((select count(*) as canceled_bookings
from hotel_bookings
where is_canceled = 1)*100.0/count(*),2) as cancellation_rate
from hotel_bookings;


-- 2. Avg Lead Time by Segment
-- 🔹 Find the average lead_time grouped by market_segment.
select market_segment, avg(lead_time) as avg_lead_time
from hotel_bookings
group by market_segment;


-- 3. Monthly Cancellations
-- 🔹 List the number of cancellations for each month and hotel. Sort by highest cancellations.
select arrival_date_month, hotel, count(is_canceled) as cancel_count
from hotel_bookings
group by arrival_date_month, hotel;


-- 4. Top Room by Price
-- 🔹 Which reserved_room_type has the highest average adr?
select reserved_room_type, avg(adr) as avg_adr
from hotel_bookings
group by reserved_room_type
order by avg_adr desc
limit 1;


-- 5. Top Countries by ADR
-- 🔹 List the top 3 countries with the highest average adr (consider only bookings with adr > 0).
select country, avg(adr) as avg_adr
from hotel_bookings
where adr > 0
group by country
order by avg_adr desc
limit 3;


-- 6. Deposit Type Check
-- 🔸 Count how many bookings had a deposit_type other than 'No Deposit'.
select count(*) as depo_count
from hotel_bookings 
where deposit_type != "No Deposit";


-- 7. Family Bookings
-- 🔸 Find the number of bookings with more than 2 adults and at least 1 child or baby.
select count(*) as fam_count
from hotel_bookings
where adults > 2 and (children >= 1 or babies >= 1);


-- 8. Market vs Channel
-- 🔸 Show top 5 combinations of market_segment and distribution_channel by booking count.
select market_segment, distribution_channel, count(*) as combo_count
from hotel_bookings
group by market_segment, distribution_channel
order by combo_count desc
limit 5;


-- 9. Special Requests by Cancellation
-- 🔸 Compare the average number of total_of_special_requests for cancelled vs. non-cancelled bookings.
select avg(case when is_canceled = 1 then total_of_special_requests end) as special_req_canceled,
avg(case when is_canceled = 0 then total_of_special_requests end) as special_req_not_canceled
from hotel_bookings;


-- 10. Room Mismatch
-- 🔸 Find number and percentage of bookings where the assigned room type is different from the reserved room type.
select count(*) as total_bookings,
count( case when assigned_room_type != reserved_room_type then 1 end) as mismatched_bookings,
 round(count( case when assigned_room_type != reserved_room_type then 1 end)*1.0 / count(*),4) as mismatch_percent
from hotel_bookings;






