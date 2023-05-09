select * from album
select * from artist
select * from customer
select * from employee
select * from genre
select * from invoice
select * from invoice_line
select * from media_type
select * from playlist
select * from playlist_track
select * from track

/* Question 1: Who is the senior most employee based on job title? */

select * from employee
order by levels desc
limit 1

/* Question 2: Which countries have the most Invoices? */

select * from invoice

select count(*) as most_invoices, billing_country from invoice
group by billing_country
order by most_invoices desc

/* Question 3: What are top 3 values of total invoices? */

select * from invoice
order by total desc
limit 3

/* Question 4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the
most money. Write a query that returns one city that has the highest sum of invoice totals. Returns both the 
city name and sum of all invoice totals. */

select * from invoice

select sum(total) as invoice_total, billing_city from invoice
group by billing_city
order by invoice_total desc

/* Question 5: Who is the best customer? The customer who has spent the most money will declared the best customer.
  Write a query thar returns the person who has spent the most money. */
  
select * from customer
select * from invoice

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

/* Question 6: Write query to return the email, first name, last name and genre of all Rock Music listeners.
Return your list ordered alphabetically by email starting with A */

select distinct email, first_name, last_name from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name = 'Rock'
)
order by email;

/* Question 7: Let's invite the artists who have written the most rock music in our dataset. Write a query that returns
the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10

/* Question 8: Return all the track names that have a song length linger than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name, milliseconds from track
where milliseconds >(
	select avg(milliseconds) as avg_trackLength from track
)
order by milliseconds desc

/* Question 9: Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent. */

with best_selling_artist as(
	select artist.artist_id as artist_id, artist.name as artist_name,
	sum(invoice_line.unit_price * invoice_line.quantity) as total_sales from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
sum(il.unit_price * il.quantity) as amount_spent from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc

 