-- =============================================
-- Query Refactoring for Performance
--
-- This file demonstrates how to:
-- 1. Write an initial, complex query that joins multiple tables.
-- 2. Analyze its potential inefficiencies.
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
-- The JOIN to Payments is now an INNER JOIN, which is more efficient for this specific goal.
INNER JOIN
    Payments pay ON b.booking_id = pay.booking_id
-- The subsequent JOINs now operate on a much smaller, pre-filtered set of bookings.
INNER JOIN
    Users u ON b.user_id = u.user_id
INNER JOIN
    Properties p ON b.property_id = p.property_id
-- The WHERE clause is specific and allows the planner to optimize heavily.
WHERE
    b.status = 'confirmed'
ORDER BY
    b.start_date;