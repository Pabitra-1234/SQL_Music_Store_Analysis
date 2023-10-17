--- Q1: Who is the senior most employee based on job title? */

select * from employee
order by levels desc
limit 1

--- Q2: Which countries have the most Invoices? 
select * from invoice

select billing_country, count(*) as total_count
from invoice
group by billing_country
order by total_count desc

---Q3: What are top 3 values of total invoice?
select * from invoice

select total from invoice
order by total desc
limit 3

--- Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city 
---we made the most money. 
---Write a query that returns one city that has the highest sum of invoice totals. 
---Return both the city name & sum of all invoice totals

select * from customer
select * from invoice

SELECT billing_city,SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1;

---Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
---Write a query that returns the person who has spent the most money.

select * from customer
select * from invoice


SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/* method-1 */

select distinct c.email,c.first_name,c.last_name,g.name
from customer as c
 inner join invoice as i on  i.customer_id = c.customer_id
 inner join invoice_line as al on  al.invoice_id = i.invoice_id
 inner join track as t on  t.track_id = al.track_id
 inner join genre as g on  g.genre_id =t.genre_id
where g.name like 'Rock'
order by email asc

 /* Q2: Let's invite the artists who have written the most rock music in our dataset. 
 Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select * from artist
select * from track
select * from genre

select distinct a.name,count(t.name)as total_track_count
from track as t
inner join album
on album.album_id = t.album_id
inner join artist as a
on a.artist_id = album.artist_id
inner join genre as g
on g.genre_id = t.genre_id
where g.name = 'Rock'
group by 1
order by 2 desc
limit 10

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select * from track

select name,milliseconds
from track
where milliseconds> (select avg(milliseconds) from track)
order by milliseconds desc


/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent */

with best_selling_artist as (
	
select a.artist_id AS artist_id ,a.name as artist_name,sum(il.unit_price * il.quantity) 
as total_sales
from invoice_line il
inner join track as t on t.track_id = il.track_id
inner join album as album on album.album_id = t.album_id
inner join artist as a on a.artist_id = album.artist_id	
group by 1
order by 3 desc
 limit 1 )

select c.customer_id,c.first_name,c.last_name, bsa.artist_name as artist_name,
	sum(il.unit_price * il.quantity) as ammount_spent
from customer as c
inner join invoice as i on i.customer_id = c.customer_id
inner join invoice_line as il on il.invoice_id = i.invoice_id
inner join track as t on t.track_id = il.track_id
inner join album as album on album.album_id = t.album_id
inner join best_selling_artist as bsa on bsa.artist_id = album.artist_id
group by 1,2,3,4
order by 5 desc
	
/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */


with popular_genre as (
	
select c.country, g.name, count(il.quantity) as purchases,
row_number() over(PARTITION BY c.country ORDER BY COUNT(il.quantity)desc) as rownumber
from customer as c
inner join invoice as i on i.customer_id = c.customer_id
inner join invoice_line as il on il.invoice_id = i.invoice_id
inner join track as t on t.track_id = il.track_id
inner join genre as g on g.genre_id = t.genre_id
group by 1,2
order by 2 asc,1 desc)
select * from popular_genre where rownumber =1
order by purchases desc


/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

select * from customer
select * from invoice

with cte as (

select c.first_name,c.last_name,billing_country,sum(i.total) as total_spent,
	row_number() over (partition by billing_country order by sum(i.total) desc) as rownumber
	from customer as c
	inner join invoice as i
	on i.customer_id = c.customer_id
	group by 1,2,3
	order by 4 desc)

select * from cte
where rownumber<=1  






















