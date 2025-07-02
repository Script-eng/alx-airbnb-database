-- =============================================
-- Sample Data for AirBnB Database
-- This script populates the tables created by schema.sql
--
-- Important:
-- This script assumes the tables are empty. It uses hardcoded integer IDs for
-- primary keys, which works for a clean setup.
-- =============================================


-- ---------------------------------------------
-- Users
-- 1. Alice: A host
-- 2. Bob: A guest
-- 3. Charlie: A guest
-- 4. David: A host and a guest
-- 5. Eve: An admin
-- ---------------------------------------------
INSERT INTO Users (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
(1, 'Alice', 'Wonder', 'alice.wonder@example.com', 'hashed_password_1', '111-222-3333', 'host'),
(2, 'Bob', 'Builder', 'bob.builder@example.com', 'hashed_password_2', '222-333-4444', 'guest'),
(3, 'Charlie', 'Chocolate', 'charlie.choco@example.com', 'hashed_password_3', '333-444-5555', 'guest'),
(4, 'David', 'Copperfield', 'david.copper@example.com', 'hashed_password_4', NULL, 'host'),
(5, 'Eve', 'Admin', 'eve.admin@example.com', 'hashed_password_5', '555-666-7777', 'admin');


-- ---------------------------------------------
-- Properties
-- Property 1 & 2 owned by Alice (user_id=1)
-- Property 3 owned by David (user_id=4)
-- ---------------------------------------------
INSERT INTO Properties (property_id, host_id, name, description, location, price_per_night) VALUES
(1, 1, 'Cozy Downtown Cottage', 'A beautiful, quiet cottage right in the heart of the city. Perfect for a weekend getaway.', 'City Center, Metropolis', 120.00),
(2, 1, 'Modern Sunny Loft', 'A bright and spacious loft with stunning city views. Includes a full kitchen and workspace.', 'Uptown, Metropolis', 250.50),
(3, 4, 'Rustic Lakeside Cabin', 'Escape the city and relax in this peaceful cabin by the lake. Great for fishing and hiking.', 'Whispering Pines, Countryside', 95.75);


-- ---------------------------------------------
-- Bookings
-- Booking 1: Bob books Alice's Cottage (Confirmed)
-- Booking 2: Charlie books Alice's Loft (Confirmed)
-- Booking 3: David books Alice's Cottage for a future date (Pending)
-- Booking 4: Bob books David's Cabin but cancels it (Canceled)
-- ---------------------------------------------
INSERT INTO Bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
(1, 1, 2, '2024-05-10', '2024-05-13', 360.00, 'confirmed'),   -- 3 nights @ 120.00
(2, 2, 3, '2024-06-01', '2024-06-06', 1252.50, 'confirmed'),  -- 5 nights @ 250.50
(3, 1, 4, '2024-08-20', '2024-08-22', 240.00, 'pending'),      -- 2 nights @ 120.00
(4, 3, 2, '2024-07-15', '2024-07-20', 478.75, 'canceled');     -- 5 nights @ 95.75


-- ---------------------------------------------
-- Payments
-- Payments only exist for confirmed bookings.
-- Payment 1 for Booking 1
-- Payment 2 for Booking 2
-- ---------------------------------------------
INSERT INTO Payments (payment_id, booking_id, amount, payment_method) VALUES
(1, 1, 360.00, 'credit_card'),
(2, 2, 1252.50, 'paypal');


-- ---------------------------------------------
-- Reviews
-- Reviews are left for completed, confirmed bookings.
-- Review 1: Bob reviews Alice's Cottage
-- Review 2: Charlie reviews Alice's Loft
-- ---------------------------------------------
INSERT INTO Reviews (review_id, property_id, user_id, rating, comment) VALUES
(1, 1, 2, 5, 'Absolutely loved this place! It was clean, quiet, and Alice was a fantastic host. Highly recommend!'),
(2, 2, 3, 4, 'The loft was beautiful and the view was amazing. Minor issue with the Wi-Fi but it was resolved quickly.');


-- ---------------------------------------------
-- Messages
-- A short conversation between Bob (guest) and Alice (host) about his booking.
-- ---------------------------------------------
INSERT INTO Messages (message_id, sender_id, recipient_id, message_body) VALUES
(1, 2, 1, 'Hi Alice, just confirming my booking for next month. I was wondering if the cottage has a coffee maker? Thanks, Bob'),
(2, 1, 2, 'Hi Bob! Yes, absolutely. The kitchen is fully equipped with a coffee maker, filters, and some local coffee for you to enjoy. Looking forward to hosting you!');

