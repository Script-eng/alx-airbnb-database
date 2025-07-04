-- =============================================
-- Database Indexes for Performance Optimization
--
-- This script creates indexes on high-usage columns to speed up
-- JOIN, WHERE, and ORDER BY operations. These indexes are crucial
-- for maintaining performance as the database grows.
-- =============================================


-- ---------------------------------------------
-- Indexes for the 'Properties' Table
-- ---------------------------------------------

-- Index on the foreign key 'host_id' to accelerate JOINs with the Users table.
CREATE INDEX idx_properties_host_id ON Properties(host_id);

-- Index on 'location' to speed up common searches for properties in a specific area.
CREATE INDEX idx_properties_location ON Properties(location);

-- Index on 'price_per_night' for fast filtering and sorting by price.
CREATE INDEX idx_properties_price ON Properties(price_per_night);


-- ---------------------------------------------
-- Indexes for the 'Bookings' Table
-- ---------------------------------------------

-- Index on the foreign key 'property_id' to accelerate JOINs with the Properties table.
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);

-- Index on the foreign key 'user_id' to accelerate JOINs with the Users table.
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);

-- A composite index on dates to speed up availability checks.
CREATE INDEX idx_bookings_dates ON Bookings(start_date, end_date);

