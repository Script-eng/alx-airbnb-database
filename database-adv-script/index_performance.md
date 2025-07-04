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

---

### Scenario A: Before Adding an Index on `location`

Without an index on the `location` column, the database has no choice but to perform a **Sequential Scan** (or Full Table Scan). It must read every single row in the `Properties` table and check if the `location` column matches our criteria.

**Execution Plan :**

Seq Scan on properties (cost=0.00..35.50 rows=1 width=120) (actual time=0.025..0.235 rows=1 loops=1)
Filter: ((location)::text = 'City Center, Metropolis'::text)
Rows Removed by Filter: 2
Planning Time: 0.150 ms
Execution Time: 0.275 ms



**Analysis:**
-   **`Seq Scan`**: This is the key takeaway. The database scanned the entire table.
-   **Cost / Time**: While the time is tiny on our 3-row sample table, on a table with 1 million properties, this scan would be extremely slow and resource-intensive. The cost (`..35.50`) would scale linearly with the table size.

---

### Scenario B: After Adding an Index on `location`

Now, we create the index: `CREATE INDEX idx_properties_location ON Properties(location);` and run the same query again.

**Execution Plan:**
index Scan using idx_properties_location on properties (cost=0.14..8.16 rows=1 width=120) (actual time=0.033..0.035 rows=1 loops=1)
Index Cond: ((location)::text = 'City Center, Metropolis'::text)
Planning Time: 0.250 ms
Execution Time: 0.065 ms


**Analysis:**
-   **`Index Scan`**: This is the critical improvement. Instead of scanning the whole table, the database used our new index.
-   **How it Works**: It performed a highly efficient lookup in the `idx_properties_location` index to find the exact location of the required row(s) and then fetched only those rows from the table.
-   **Cost / Time**: The execution time is significantly lower. On a large table, this difference would be dramatic—milliseconds with an index versus many seconds or minutes without one. The cost (`..8.16`) is much lower and does not scale linearly with the table size in the same way a full scan does.

### Conclusion

Indexing is not a "silver bullet" for all performance issues, but it is the most effective and fundamental tool for optimizing database query performance. By identifying and indexing high-usage columns, we ensure that the database can retrieve data efficiently, even as the volume of data grows.