-- =============================================
-- Query Refactoring for Performance
--
-- This file demonstrates how to:
-- 1. Write an initial, complex query that joins multiple tables.
-- 2. Analyze its potential inefficiencies using EXPLAIN.
-- 3. Refactor the query for better performance and clarity.
-- =============================================


-- --------------------------------------------------------------------
-- 1. Initial "Kitchen Sink" Query
-- --------------------------------------------------------------------
-- Objective: Retrieve ALL bookings along with user details, property details, and payment details.
--
-- This is a common type of query used for generating a comprehensive report.
-- It attempts to pull all related information together in one go.

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


-- --------------------------------------------------------------------
-- 2. Performance Analysis of the Initial Query
-- --------------------------------------------------------------------
--
-- To analyze the query’s performance, we use the EXPLAIN command.
-- This command shows the database's execution plan without actually running the query.
-- Using EXPLAIN ANALYZE would both show the plan and run it to get actual timings.
--
-- Example of how to run the analysis (syntax may vary by RDBMS):
-- EXPLAIN SELECT * FROM Bookings b JOIN Users u ON b.user_id = u.user_id ...;
--
-- Key Inefficiencies Identified from the EXPLAIN plan:
--
-- a) Inefficient LEFT JOIN: The plan would show a costly LEFT JOIN on the `Payments`
--    table, which processes all bookings (pending, canceled, etc.) even if they
--    will ultimately have NULL payment details.
--
-- b) Large, Unfiltered Intermediate Result Sets: The plan would reveal that the
--    database joins three large tables (`Bookings`, `Users`, `Properties`) before
--    any filtering, creating a potentially massive intermediate result set.
--
-- --------------------------------------------------------------------


-- --------------------------------------------------------------------
-- 3. Refactored, High-Performance Query
-- --------------------------------------------------------------------
-- Objective: Retrieve details ONLY for confirmed, paid bookings for properties
-- costing more than $100 per night.
--
-- This more specific business requirement allows for a significantly more
-- efficient query.
--
-- Key Improvements:
--
-- a) Replaced LEFT JOIN with INNER JOIN: This immediately filters the dataset
--    down to only bookings that have a corresponding payment record.
--
-- b) Added a specific, multi-condition WHERE clause: Filtering with `WHERE` and `AND`
--    allows the query planner to use indexes and discard irrelevant rows
--    from multiple tables early in the execution plan.

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
-- The specific WHERE clause with AND allows for early, aggressive filtering.
WHERE
    b.status = 'confirmed'
    AND p.price_per_night > 100.00
ORDER BY
    b.start_date;