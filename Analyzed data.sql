/*Task 1:
Write an SQL query to find the top 3 genres with the highest number of tracks.*/
SELECT g."Name", COUNT(*)
FROM "Genre" g
JOIN "Track"t
USING("GenreId")
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 3;


/*Task 2:
Write an SQL query to retrieve the names of all customers 
who have made more than one purchase.*/
SELECT full_name
FROM 
(SELECT CONCAT("FirstName",' ', "LastName") AS full_name,
    COUNT (*) AS purchase_count
FROM "Customer" c
JOIN "Invoice" i
USING ("CustomerId")
GROUP BY 1) t1
WHERE purchase_count > 1;


/*Task 3:
Write an SQL query to find the top 5 artists with the
 highest average track length (in milliseconds).*/
 
SELECT ar."Name" AS artist_name, 
    AVG(t."Milliseconds") AS milliseconds_played
FROM "Artist" AS ar
JOIN "Album" AS al
USING("ArtistId")
JOIN "Track" AS t
USING ("AlbumId")
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;


/*Task 4:
Write an SQL query to find the customer who spent the most in each country.
Include the country name and the total amount spent for each customer.*/


SELECT full_name,
    country_name,
    total_spent
FROM 
(SELECT CONCAT("FirstName",' ', "LastName") AS full_name,
    "Country" AS country_name,
    SUM(i."Total") AS total_spent,
     ROW_NUMBER() OVER (PARTITION BY "Country" ORDER BY SUM(i."Total") DESC)
FROM "Customer" c
JOIN "Invoice" i
USING ("CustomerId")
GROUP BY 1, 2) t1
WHERE ROW_NUMBER = 1




/*Task 5:
Write an SQL query to find the top 3 most purchased genres in each country. 
Include the country name, genre name, and the number of purchases for each genre.*/

SELECT genre, 
    country_name,
    total_purchase
FROM 
(SELECT g."Name" AS genre,
c."Country" as country_name,
SUM(i."Total") as total_purchase,
ROW_NUMBER() OVER(PARTITION BY c."Country" ORDER BY SUM(i."Total") DESC)
FROM "Customer" c
JOIN "Invoice" i
ON c."CustomerId" = i."CustomerId"
JOIN "InvoiceLine" il
ON i."InvoiceId" = il."InvoiceId"
JOIN "Track" t 
ON il."TrackId" = t."TrackId"
JOIN "Genre" g 
ON t."GenreId" = g."GenreId"
GROUP BY 1, 2) t1
WHERE ROW_NUMBER < 4



/*Task 6:
Write an SQL query to find the customer who made the highest 
single purchase (total amount) and the details of that purchase.*/

WITH t1 AS
(SELECT CONCAT("FirstName",' ', "LastName") AS full_name,
    i."Total" AS purchase_amount
FROM "Customer" c
JOIN "Invoice" i
USING ("CustomerId")
ORDER BY 2 DESC
LIMIT 1)


SELECT *
FROM "Customer" c
JOIN "Invoice" i
USING ("CustomerId")
WHERE i."Total" = (SELECT purchase_amount FROM t1)


/*Task 7:
Write an SQL query to find the artists who have tracks in the
"Rock" genre but not in the "Pop" genre. Include the artist's
name and the number of tracks in the "Rock" genre.*/


SELECT DISTINCT a."Name" AS artist_name,
    COUNT(*) AS count_of_tracks
FROM "Artist" a
JOIN"Album" al 
ON a."ArtistId" = al."ArtistId"
JOIN "Track" t 
ON al."AlbumId" = t."AlbumId"
JOIN "Genre" g 
ON t."GenreId" = g."GenreId"
WHERE g."Name" <> 'Pop'
AND g."Name" = 'Rock'
GROUP BY 1


/* Task 8: 
Write an SQL query to find the most popular genre for each country. 
The most popular genre is the one with the highest number of tracks purchased. 
List the country name and the genre name. */

SELECT genre_name,
    country_name
FROM 
(SELECT
    g."Name" AS genre_name,
    c."Country" AS country_name,
    COUNT (i."Total") AS total_purchase_number,
    ROW_NUMBER () OVER (PARTITION BY c."Country" ORDER BY COUNT (i."Total") DESC)
FROM "Invoice" i
JOIN "InvoiceLine" il 
USING ("InvoiceId")
JOIN "Track" t 
USING ("TrackId")
JOIN "Genre" g 
USING ("GenreId")
JOIN "Customer" c 
USING ("CustomerId")
GROUP BY 1, 2) t1
WHERE ROW_NUMBER = 1

/*TASK 9:
Write an SQL query to find the customers who have made purchases in all genres
available in the database. Include the customer's first and last name.*/

SELECT CONCAT("FirstName",' ', "LastName") AS full_name,
     COUNT (DISTINCT g."Name") AS genre_count
FROM "Invoice" i
JOIN "InvoiceLine" il 
USING ("InvoiceId")
JOIN "Track" t 
USING ("TrackId")
JOIN "Genre" g 
USING ("GenreId")
JOIN "Customer" c 
USING ("CustomerId")
GROUP BY 1
HAVING COUNT (DISTINCT g."Name") = 
(SELECT COUNT (DISTINCT "Name") FROM "Genre")


/*TASK 10:
Write an SQL query to find the customer who purchased most  from the genre that 
has the most  number of tracks. Include the customer's first and last name and purchased qty.*/

WITH t1 AS 
(SELECT g."Name" AS genre_name,
       COUNT(*) AS track_count
FROM "Genre" g 
JOIN "Track" t 
USING ("GenreId")
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1)

SELECT CONCAT("FirstName",' ', "LastName") AS full_name,
    COUNT(*) AS purchase_qty
FROM "Invoice" i
JOIN "InvoiceLine" il 
USING ("InvoiceId")
JOIN "Track" t 
USING ("TrackId")
JOIN "Genre" g 
USING ("GenreId")
JOIN "Customer" c 
USING ("CustomerId")
WHERE g."Name" = 
(SELECT genre_name FROM t1)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1



