-- =============================================
-- Table Partitioning Implementation
-- Database Dialect: PostgreSQL
--
-- Objective: Partition the 'Bookings' table by 'start_date' to improve
-- performance of date-range queries on very large datasets.
-- =============================================

-- Note: This script assumes we are migrating from an existing 'Bookings' table.
-- The process involves creating a new partitioned table, migrating data,
-- and then replacing the old table. This should be done with care in a
-- production environment, ideally within a transaction.


-- ---------------------------------------------
-- Step 1: Create a new partitioned 'parent' table.
-- It has the same structure as the original 'Bookings' table, but with the
-- PARTITION BY clause added. This table itself will not store any data.
-- ---------------------------------------------
CREATE TABLE Bookings_Partitioned (
    booking_id INT,
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    -- Add back constraints if needed, but primary key must include the partition key
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);


-- ---------------------------------------------
-- Step 2: Create the individual partitions (child tables).
-- Each partition stores a specific range of data. The database will
-- automatically route rows to the correct partition.
--
-- We'll create partitions for 2023, 2024, and 2025 as an example.
-- ---------------------------------------------

-- Partition for bookings starting in 2023
CREATE TABLE bookings_y2023 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for bookings starting in 2024
CREATE TABLE bookings_y2024 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for bookings starting in 2025
CREATE TABLE bookings_y2025 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- It's also good practice to have a default partition for values that don't fit.
-- CREATE TABLE bookings_default PARTITION OF Bookings_Partitioned DEFAULT;


-- ---------------------------------------------
-- Step 3: Migrate data from the old table to the new partitioned table.
-- The database will automatically place the data into the correct partition.
-- ---------------------------------------------
INSERT INTO Bookings_Partitioned (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
SELECT booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at FROM Bookings;


-- ---------------------------------------------
-- Step 4: Create indexes on the new partitioned table.
-- Creating an index on the parent table will automatically create it on all partitions.
-- ---------------------------------------------
CREATE INDEX idx_partitioned_bookings_property_id ON Bookings_Partitioned(property_id);
CREATE INDEX idx_partitioned_bookings_user_id ON Bookings_Partitioned(user_id);


-- ---------------------------------------------
-- Step 5: Replace the old table with the new one.
-- This should be done within a single transaction to minimize downtime.
-- ---------------------------------------------
-- BEGIN;
-- DROP TABLE Bookings;
-- ALTER TABLE Bookings_Partitioned RENAME TO Bookings;
-- COMMIT;