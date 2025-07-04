# SQL Join Query Examples

This repository contains the `queries.sql` file, which demonstrates various types of SQL joins using the AirBnB database schema.

## About the Queries

The script includes examples for the following common joins:

*   **`INNER JOIN`**: Shows bookings that are matched with the users who created them.
*   **`LEFT JOIN`**: Lists all properties and includes their review data if any exists. Properties without reviews are still included in the result.
*   **`FULL OUTER JOIN`**: Provides a comprehensive list of all users and all bookings, showing which users have no bookings.

These queries are designed to be run against the database after it has been created with `schema.sql` and populated with `seed.sql`.