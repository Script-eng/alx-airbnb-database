-- =============================================
-- SQL Subquery Examples
-- This file contains examples of both non-correlated and correlated subqueries.
-- =============================================



SELECT
    property_id,
    name,
    location,
    price_per_night
FROM
    Properties
WHERE
    property_id IN (
        SELECT
            property_id
        FROM
            Reviews
        GROUP BY
            property_id
        HAVING
            AVG(rating) > 4.0
    );


-- --------------------------------------------------------------------
-- 2. Correlated Subquery
-- --------------------------------------------------------------------
-- -- Retrieve users who have made more than one booking.
-- This subquery counts the number of bookings for each user and filters those with more than one
-- --------------------------------------------------------------------

SELECT
    user_id,
    first_name,
    last_name,
    email
FROM
    Users u
WHERE
    (SELECT
        COUNT(*)
    FROM
        Bookings b
    WHERE
            b.user_id = u.user_id
    ) > 1;