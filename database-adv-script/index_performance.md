# Indexing for Performance

This document outlines the strategy for creating database indexes to improve query performance and provides a demonstration of their impact using the `EXPLAIN ANALYZE` command.

## 1. Identification of High-Usage Columns

Indexes are most effective on columns that are frequently used in `JOIN` conditions, `WHERE` clauses, and `ORDER BY` clauses. Based on the likely usage patterns of our AirBnB application, the following columns are key candidates for indexing:

### Property Table
-   `host_id`: Essential for `JOIN` operations to find properties owned by a specific user.
-   `location`: A very common search criterion in `WHERE` clauses (e.g., `WHERE location = '...'`).
-   `price_per_night`: Frequently used in `WHERE` clauses for price-range filtering and in `ORDER BY` for sorting.

### Booking Table
-   `property_id`: Essential for `JOIN` operations to find all bookings for a specific property.
-   `user_id`: Essential for `JOIN` operations to find all bookings made by a specific user.
-   `start_date` & `end_date`: Critical for `WHERE` clauses that check for property availability within a given date range. A composite index on both columns is highly effective.

The `CREATE INDEX` commands for these columns are located in the `database_index.sql` file.

## 2. Measuring Performance with `EXPLAIN ANALYZE`

To demonstrate the impact of an index, we can use the `EXPLAIN ANALYZE` command (in PostgreSQL) or a similar command in other database systems. This command shows the database's *execution plan*—the steps it will take to run a query—and the actual time it took.

Let's analyze a common query: finding a property by its location.

**Query:** `SELECT * FROM Properties WHERE location = 'City Center, Metropolis';`
