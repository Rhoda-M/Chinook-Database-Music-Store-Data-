SELECT *
FROM album;

SELECT *
FROM artist;

SELECT *
FROM customer;

SELECT *
FROM employee;

SELECT *
FROM genre;

SELECT *
FROM invoice;

SELECT *
FROM invoiceline;

SELECT *
FROM playlist;

SELECT *
FROM playlisttrack;

SELECT *
FROM track;
-- -- Aggregate Functions 
SELECT COUNT(CustomerId) AS NumberOfCustomers, Country
FROM customer
WHERE Country IS NOT NULL
GROUP BY Country
HAVING COUNT(CustomerId) > 5
ORDER BY NumberOfCustomers DESC;

SELECT SUM(EmployeeId) AS SumOfEmployees
FROM employee;

SELECT InvoiceId, BillingCity, MAX(Total)
FROM invoice
GROUP BY InvoiceId
LIMIT 10;

-- -- Joins
SELECT FirstName, LastName, InvoiceId
FROM customer
INNER JOIN invoice ON customer.CustomerID = invoice.CustomerId
WHERE InvoiceId < 100
ORDER BY InvoiceId ASC;

SELECT AlbumID, Name, Title
FROM album
LEFT JOIN artist ON album.ArtistId = artist.ArtistId
ORDER BY AlbumId ASC;

SELECT p.PlaylistId, Name, TrackId
FROM playlisttrack AS pt
RIGHT JOIN playlist AS  p
 ON pt.PlaylistId = p.PlaylistId
WHERE p.PlaylistId IS NOT NULL 
AND TrackId IS NOT NULL 
ORDER BY p.PlaylistId ASC;

-- -- Subquery -- -- Customers who have spent more than the average invoice total 
SELECT CustomerId, FirstName, LastName
FROM Customer
WHERE CustomerId IN
(
    SELECT CustomerId
    FROM Invoice
    WHERE Total > (SELECT AVG(Total) FROM Invoice)
    );
-- -- Window Functions
SELECT EmployeeId, FirstName, LastName, Title, 
      RANK() OVER(PARTITION BY Title ORDER BY EmployeeId ASC) AS emp_rank
FROM employee;

SELECT EmployeeId, FirstName, LastName, Title, 
      DENSE_RANK() OVER(PARTITION BY Title ORDER BY EmployeeId ASC) AS emp_dense_rank
FROM employee;

SELECT EmployeeId, FirstName, LastName, Title,
      ROW_NUMBER() OVER(PARTITION BY Title ORDER BY EmployeeId ASC) AS emp_row_no
FROM employee;

-- -- Top 15 tracks by total revenue generated
SELECT t.TrackId, t.Name, SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM Track AS t
JOIN Invoiceline AS il
ON t.TrackId = il.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY TotalRevenue DESC
LIMIT 15;

-- -- Top Customers By Total Spending
SELECT c.CustomerId, FirstName, LastName, SUM(i.Total) AS TotalSpent
FROM customer AS c
JOIN invoice AS i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 10;

-- -- Monthly Revenue Trends
SELECT * 
FROM invoice; 
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
    SUM(Total) AS MonthlyRevenue
FROM Invoice
GROUP BY Month
ORDER BY Month;

-- -- Yearly Revenue Trends
SELECT
    YEAR(InvoiceDate) AS Year,
    SUM(Total) AS TotalRevenue
FROM Invoice
GROUP BY Year
ORDER BY Year;

-- --Number Of Purchases Per Customer
SELECT
    c.CustomerId,
    CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,
    COUNT(i.InvoiceId) AS NumberOfPurchases
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, CustomerName
ORDER BY NumberOfPurchases DESC;

-- --Most Purchased Genres
SELECT
    g.Name AS Genre,
    COUNT(il.InvoiceLineId) AS TimesPurchased
FROM Genre g
JOIN Track t
ON g.GenreId = t.GenreId
JOIN InvoiceLine il
ON t.TrackId = il.TrackId
GROUP BY g.GenreId, g.Name
ORDER BY TimesPurchased DESC;







