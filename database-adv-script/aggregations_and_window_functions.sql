-- =============================================
-- SQL Analysis Queries
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
-- 2. Window Function (RANK)
-- --------------------------------------------------------------------
-- Objective: Rank properties based on the total number of bookings they have received.
--
-- Explanation:
-- This query first uses a Common Table Expression (CTE) named 'PropertyBookingCounts'
-- to calculate the number of bookings for each property. A LEFT JOIN is used
-- to include properties with zero bookings.
--
-- The main query then selects from this CTE and applies the RANK() window function.
-- RANK() assigns a rank to each property based on its 'booking_count'.
-- The 'OVER (ORDER BY booking_count DESC)' clause specifies that the ranking should be
-- in descending order of booking counts. Properties with the same number of bookings
-- will receive the same rank.
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
    RANK() OVER (ORDER BY booking_count DESC) AS property_rank
FROM
    PropertyBookingCounts
ORDER BY
    property_rank;