-- =============================================
-- SQL Analysis Queries (Corrected)
-- This file contains examples using aggregation and window functions.
-- =============================================


-- --------------------------------------------------------------------
-- 1. Aggregation with GROUP BY
-- --------------------------------------------------------------------
-- Objective: Find the total number of bookings made by each user.
--
-- Explanation:
-- This query uses a LEFT JOIN to ensure all users are included, even those
-- with zero bookings. It then groups the results by each user.
-- The COUNT(b.booking_id) function counts the number of non-null booking IDs
-- for each user group. For users with no bookings, this count will be 0.
-- This provides a summary of booking activity for every user in the system.
-- --------------------------------------------------------------------

SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM
    Users u
LEFT JOIN
    Bookings b ON u.user_id = b.user_id
GROUP BY
    u.user_id, u.first_name, u.last_name
ORDER BY
    total_bookings DESC, u.last_name;


-- --------------------------------------------------------------------
-- 2. Window Functions (ROW_NUMBER and RANK)
-- --------------------------------------------------------------------
-- Objective: Rank properties based on the total number of bookings they have received.
--
-- Explanation:
-- This query first uses a Common Table Expression (CTE) named 'PropertyBookingCounts'
-- to calculate the number of bookings for each property.
--
-- The main query then applies three different window functions to show their behavior:
-- - ROW_NUMBER(): Assigns a unique, sequential number to each row (e.g., 1, 2, 3).
-- - RANK(): Assigns a rank based on the value. If two properties have the same
--           booking_count, they get the same rank, and the next rank is skipped
--           (e.g., 1, 2, 2, 4).
-- - DENSE_RANK(): Similar to RANK(), but does not skip ranks after a tie
--                 (e.g., 1, 2, 2, 3).
--
-- The 'OVER (ORDER BY booking_count DESC)' clause defines the window for the functions.
-- --------------------------------------------------------------------

WITH PropertyBookingCounts AS (
    SELECT
        p.property_id,
        p.name,
        p.location,
        COUNT(b.booking_id) AS booking_count
    FROM
        Properties p
    LEFT JOIN
        Bookings b ON p.property_id = b.property_id
    GROUP BY
        p.property_id, p.name, p.location
)
SELECT
    name,
    location,
    booking_count,
    ROW_NUMBER() OVER (ORDER BY booking_count DESC) AS row_num,
    RANK() OVER (ORDER BY booking_count DESC) AS property_rank,
    DENSE_RANK() OVER (ORDER BY booking_count DESC) AS property_dense_rank
FROM
    PropertyBookingCounts
ORDER BY
    property_rank;