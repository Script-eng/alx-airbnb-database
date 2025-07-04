-- =============================================
-- SQL Join Query Examples
-- =============================================

-- --------------------------------------------------------------------
-- 1. INNER JOIN: Retrieve all bookings and the respective users who made them.
-- --------------------------------------------------------------------
SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name,
    u.email
FROM
    Bookings b
INNER JOIN
    Users u ON b.user_id = u.user_id
ORDER BY
    b.start_date;


-- --------------------------------------------------------------------
-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews.
-- --------------------------------------------------------------------
SELECT
    p.property_id,
    p.name AS property_name,
    r.rating,
    r.comment,
    u.first_name AS reviewer_first_name
FROM
    Properties p
LEFT JOIN
    Reviews r ON p.property_id = r.property_id
LEFT JOIN
    Users u ON r.user_id = u.user_id
ORDER BY
    p.property_id;


-- --------------------------------------------------------------------
-- 3. FULL OUTER JOIN: Retrieve all users and all bookings.
-- Note: FULL OUTER JOIN is not supported by MySQL. In MySQL, you would
-- achieve this by combining a LEFT JOIN and a RIGHT JOIN with UNION.
-- --------------------------------------------------------------------
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.status
FROM
    Users u
FULL OUTER JOIN
    Bookings b ON u.user_id = b.user_id
ORDER BY
    u.user_id, b.booking_id;