# Sample Data (Seeding)

This document describes the `seed.sql` script, which is used to populate the AirBnB database with a set of realistic, interconnected sample data.

## Overview of Sample Data

The seed script creates a small but comprehensive dataset that simulates real-world interactions within the platform. The data includes:

-   **5 Users**: A mix of hosts, guests, and an administrator.
-   **3 Properties**: Owned by two different hosts.
-   **4 Bookings**: Demonstrating `confirmed`, `pending`, and `canceled` statuses.
-   **2 Payments**: Correctly linked only to the `confirmed` bookings.
-   **2 Reviews**: Left by guests for properties they stayed at.
-   **1 Message Exchange**: A two-message conversation between a guest and a host.

This interconnected data allows for meaningful testing of `JOIN` queries, constraints, and application logic.

## How to Use

### Prerequisites

You **must** have already created the database schema by running the `schema.sql` script. The tables should exist but be empty.

### Execution Instructions

1.  Connect to your database using your preferred SQL client.
2.  Run the `seed.sql` script. If you are using a command-line client like `psql` (for PostgreSQL) or `mysql`, you can execute the file directly.

    **Example for PostgreSQL:**
    ```bash
    psql -U your_username -d airbnb_db -f seed.sql
    ```

    **Example for MySQL:**
    ```bash
    mysql -u your_username -p your_database_name < seed.sql
    ```

    Replace `your_username` and `your_database_name` with your actual credentials.

### Important Note on Primary Keys

The `seed.sql` script uses hardcoded integer primary keys (e.g., `user_id = 1`, `property_id = 2`). This approach is simple and effective for creating a predictable dataset for development and testing.

This works because it assumes the script is run on a freshly created, empty database where these IDs are available. It would fail if you tried to run it on a database that already contains data, as it could lead to primary key conflicts.