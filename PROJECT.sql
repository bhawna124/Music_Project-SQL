/*	Question Set 1 - Easy */

/* Q1: Who is the senior most employee based on job title? */
    SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1

/* Q2: Which countries have the most Invoices? */

select billing_country , count(invoice_id)from invoice
group by 1
order by 2 desc

/* Q3: What are top 3 values of total invoice? */

select total as total_invoice from invoice
order by 1 desc
limit 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city, sum(total) as invoice_totals from invoice
group by 1 
order by 2 desc
limit 1

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT c.customer_id,  c.first_name, c.last_name, SUM(total) AS total_spending
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;




/*	Question Set 2 - Moderate */


--Q1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.Return your list ordered alphabetically by email starting with A *\

select distinct c.email, c.first_name, c.last_name , g.name from customer c
inner join invoice i on c.customer_id=i.customer_id
inner join invoice_line il on i.invoice_id=il.invoice_id
inner join track t on t.track_id=il.track_id
inner join genre g on t.genre_id=g.genre_id
where g.name='Rock'
order by 1 



 --Q2. Let's invite the artists who have written the most rock music in our dataset. 
 --Write a query that returns the Artist name and total track count of the top 10 rock bands
select a.name as artist_name , count(t.track_id) as track_count from artist a 
inner join album al on a.artist_id= al.artist_id
inner join track t on al.album_id=t.album_id
inner join genre g on t.genre_id=g.genre_id
where g.name='Rock'
group by 1
order by 2 desc
limit 10


 --Q3 Return all the track names that have a song length longer than the average song length. 
 --Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
 
select name as track_name, milliseconds as song_length 
from track
where milliseconds>(SELECT AVG(milliseconds) FROM track)
group by 1,2
order by 2 desc



/*	Question Set 3 - Advance  */

--Q1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

with table1 as (SELECT  c.customer_id, c.first_name, c.last_name, a.name, sum(il.unit_price * il.quantity) AS total_spending,
rank()over(partition by a.name order by sum (il.unit_price*il.quantity)) as rank1
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
inner join invoice_line il on i.invoice_id=il.invoice_id
inner join track t on t.track_id=il.track_id
inner join album al on al.album_id= t.album_id
inner join artist a on a.artist_id= al.artist_id
group by 1,2,3,4
order by 5 )
select * from table1 where rank1=1;


--Q2. We want to find out the most popular music Genre for each country.
--We determine the most popular genre as the genre with the highest amount of purchases.Write a query that returns each country along with the top Genre.
--For countries where the maximum number of purchases is shared return all Genres

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	Rank() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo = 1

 /* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with table1 as (SELECT c.customer_id,  c.first_name, c.last_name, c.country, SUM(total) AS total_spending,
rank()over(partition by c.country order by sum(total) desc) as max_rank
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
group by 1,2,3,4)
select * from table1 where max_rank=1;










