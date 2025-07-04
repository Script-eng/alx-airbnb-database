# Query Optimization Report

## 1. Overview

This report details the analysis and refactoring of a complex query designed to retrieve booking information from the database. The initial query, while functional, was identified as being inefficient and likely to cause performance degradation as the database tables grow.

The refactoring process focused on transforming the query from a broad, all-encompassing "kitchen sink" request into a specific, focused query that aligns better with common business needs and allows the database engine to operate much more efficiently.

## 2. Initial Query Analysis

The original goal was to retrieve a comprehensive report of all bookings, including details about the user, property, and any associated payments.

### The Inefficient Query
```sql
SELECT
    b.booking_id,
    b.status,
    b.start_date,
    u.first_name,
    u.email,
    p.name AS property_name,
    p.location,
    pay.payment_method,
    pay.amount AS payment_amount,
    pay.payment_date
FROM
    Bookings b
JOIN
    Users u ON b.user_id = u.user_id
JOIN
    Properties p ON b.property_id = p.property_id
LEFT JOIN
    Payments pay ON b.booking_id = pay.booking_id
ORDER BY
    b.start_date;



    An analysis using the database's EXPLAIN tool reveals several key inefficiencies:

Inefficient LEFT JOIN: This forces the database to first join Bookings, Users, and Properties and then, for every single row of that result, perform a lookup in the Payments table. This is costly because it includes all pending and canceled bookings.
Large Intermediate Result Set: The database must construct a large intermediate table in memory containing the combined data from the initial JOINs before the final LEFT JOIN is even considered.
Lack of Early Filtering: The query has no WHERE clause, meaning the database cannot reduce the number of rows it needs to work on early in the execution plan.



SELECT
    b.booking_id,
    b.status,
    b.start_date,
    u.first_name,
    u.email,
    p.name AS property_name,
    p.location,
    pay.payment_method,
    pay.amount AS payment_amount,
    pay.payment_date
FROM
    Bookings b
INNER JOIN
    Payments pay ON b.booking_id = pay.booking_id
INNER JOIN
    Users u ON b.user_id = u.user_id
INNER JOIN
    Properties p ON b.property_id = p.property_id
WHERE
    b.status = 'confirmed'
    AND p.price_per_night > 100.00
ORDER BY
    b.start_date;



    Key Optimizations
LEFT JOIN Replaced with INNER JOIN: By using INNER JOIN with the Payments table, we instruct the database to only consider bookings that have a matching payment, immediately reducing the working data set.
Specific WHERE and AND Clauses Added: The multi-condition filter (WHERE b.status = 'confirmed' AND p.price_per_night > 100.00) is extremely powerful. It allows the database to use indexes on status and price_per_night to discard a huge number of irrelevant rows at the very beginning of the process, before any expensive joins are performed.