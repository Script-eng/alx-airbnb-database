# AirBnB Database Schema

This repository contains a generic SQL script (`schema.sql`) to create the database schema for a simplified AirBnB-like application. The schema is designed to be portable and easily adaptable across different relational database management systems (RDBMS).

## Schema Overview

The schema is normalized and designed to maintain data integrity. It consists of six core tables:

-   **Users**: Stores user account information, including their role (guest, host, admin).
-   **Properties**: Contains details about each rental property, linked to a host (`Users`).
-   **Bookings**: Represents a reservation made by a guest (`Users`) for a specific `Property`.
-   **Payments**: Records the financial transaction for a `Booking`.
-   **Reviews**: Allows users to leave ratings and comments for properties.
-   **Messages**: Facilitates direct communication between users.

## Design Philosophy

-   **Portability**: The SQL script avoids vendor-specific features in favor of standard SQL-92 constructs. This ensures it can serve as a solid baseline for systems like MySQL, PostgreSQL, SQL Server, Oracle, and SQLite.
-   **Data Integrity**:
    -   `FOREIGN KEY` constraints are used to maintain referential integrity. `ON DELETE CASCADE` is specified to handle the deletion of parent records gracefully.
    -   `CHECK` constraints enforce business rules (e.g., valid roles, booking statuses, and rating values).
    -   `UNIQUE` constraints prevent duplicate data where necessary (e.g., unique user emails, one review per user per property).
-   **Primary Keys**: The schema uses `INTEGER` primary keys. It is expected that the database administrator will configure these as auto-incrementing fields according to the syntax of their chosen RDBMS.
-   **Application-Managed Timestamps**: The `updated_at` column in the `Properties` table is intentionally left without a database-level automatic update trigger. This is to maximize portability, as triggers have vendor-specific syntax. It is expected that the application layer will be responsible for setting this value upon a record update.

## How to Use

### 1. Adaptation for Your Database

Before running the script, you may need to make minor adjustments, particularly for the **auto-incrementing primary keys**.

Open `schema.sql` and for each `PRIMARY KEY` column, replace the generic `INT PRIMARY KEY` with your system's specific syntax.

-   **For MySQL**:
    ```sql
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    ```
-   **For SQL Server**:
    ```sql
    user_id INT PRIMARY KEY IDENTITY(1,1),
    ```
-   **For PostgreSQL**:
    ```sql
    -- For versions 10+
    user_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    -- For older versions
    -- user_id SERIAL PRIMARY KEY,
    ```
-   **For SQLite**:
    ```sql
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ```

### 2. Execution

1.  **Create a Database**: Using your RDBMS's tools, create a new database (e.g., `airbnb_db`).
2.  **Connect to the Database**: Connect to your new database using a command-line client or a GUI tool.
3.  **Run the Script**: Execute the contents of the modified `schema.sql` file. This will create all the tables, constraints, and indexes.