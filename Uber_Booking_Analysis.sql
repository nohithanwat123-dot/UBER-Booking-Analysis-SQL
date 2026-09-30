create database Uber_booking;
use uber_booking;
select count(*) from raw_dataset;
select *from raw_dataset;
CREATE TABLE customers AS
SELECT DISTINCT
    customer_id,
    customer_name,
    customer_gender,
    customer_age,
    email,
    city
FROM raw_dataset;
select *from customers;
select count(*) from customers;
CREATE TABLE drivers AS
SELECT DISTINCT
    driver_id,
    driver_name,
    driver_gender,
    driver_age,
    vehicle_type,
    driver_rating
FROM raw_dataset;
select *from Drivers;
CREATE TABLE rides AS
SELECT
    ride_id,
    customer_id,
    driver_id,
    pickup_location,
    drop_location,
    fare_amount,
    payment,
    ride_status,
    booking_date
FROM raw_dataset;
select *from rides;
select count(*) from rides;


-- Total revenue generate
SELECT SUM(fare_amount) AS total_revenue
FROM rides;

-- This SQL query calculates the total revenue by summing the fare amount column using Aggregation Function SUM()




-- Completed vs cancel ride 
SELECT ride_status, COUNT(*) AS total
FROM rides
GROUP BY ride_status;  

-- This Query “Counts the number of rides for each ride status by grouping the data on ride_status.”

-- Rides per city
SELECT c.city, COUNT(r.ride_id) AS total_rides
FROM rides r
JOIN customers c
ON r.customer_id = c.customer_id
GROUP BY c.city;

-- This query shows the total number of rides booked in each city by joining the rides and customers tables and grouping the data by city.


-- Most Used Payment Method
SELECT payment, COUNT(*) AS usage_count
FROM rides
GROUP BY payment
ORDER BY usage_count DESC;

-- This query shows which payment method (cash, card, or UPI) is used the most by customers by counting total rides for each payment type


-- Rides With High-Rated Drivers Only
SELECT 
    r.ride_id,
    d.driver_name,
    d.driver_rating
FROM rides r
JOIN drivers d
ON r.driver_id = d.driver_id
WHERE d.driver_rating > 4.5;

-- This query filters rides handled by drivers with ratings above 4.5 using JOIN and WHERE conditions to analyze top driver performance.


-- Ride Details With Customer & Driver Names (Multi-table JOIN)
SELECT 
    r.ride_id,
    c.customer_name,
    d.driver_name,
    r.pickup_location,
    r.drop_location,
    r.fare_amount
FROM rides r
JOIN customers c ON r.customer_id = c.customer_id
JOIN drivers d ON r.driver_id = d.driver_id;

-- Explanation : This is a 3-table join that shows a full booking record including customer  → driver → ride details.


-- Total Revenue Earned by Each Driver
SELECT 
    d.driver_name,
    SUM(r.fare_amount) AS total_revenue
FROM drivers d
JOIN rides r
ON d.driver_id = r.driver_id
GROUP BY d.driver_name
ORDER BY total_revenue DESC;

-- Explanation : JOIN + SUM() shows how much money each driver earned from all rides.


-- City-wise Ride Count (JOIN + GROUP BY)
SELECT 
    c.city,
    COUNT(r.ride_id) AS total_rides
FROM rides r
JOIN customers c
ON r.customer_id = c.customer_id
GROUP BY c.city;

-- Explanation : This tells you which city has the most Uber rides


-- Rank Drivers Based on Total Rides 
SELECT 
    driver_id,
    COUNT(ride_id) AS total_rides,
    RANK() OVER (ORDER BY COUNT(ride_id) DESC) AS driver_rank
FROM rides
GROUP BY driver_id;

-- Explanation : RANK() assigns ranking based on number of rides completed, highest to lowest.


-- Dense Rank for Customers Based on Total Spending 
SELECT 
    customer_id,
    SUM(fare_amount) AS total_spent,
    DENSE_RANK() OVER (ORDER BY SUM(fare_amount) DESC) AS spending_rank
FROM rides
GROUP BY customer_id;

-- Explanation : Dense _rank () ranks customers without skipping numbers.


-- Row Number for Each Ride of a Customer
SELECT 
    customer_id,
    ride_id,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY booking_date) AS ride_number
FROM rides;

-- Explanation : This assigns row number to rides based on fare amount from highest to lowest.



-- Rank Rides Based on Fare (Highest Fare First)
SELECT 
    ride_id,
    fare_amount,
    ROW_NUMBER() OVER (ORDER BY fare_amount DESC) AS fare_rank
FROM rides;

-- Explanation : This assigns row number to rides based on fare amount from highest to lowest.

show databases;
