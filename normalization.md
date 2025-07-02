
# Database Normalization Analysis (3NF)

*   **First Normal Form (1NF):** The table has a primary key, and all columns contain atomic (indivisible) values. There are no repeating groups of columns.
*   **Second Normal Form (2NF):** The table is in 1NF, and all non-key attributes are fully dependent on the *entire* primary key. (This rule is primarily relevant for tables with composite primary keys).
*   **Third Normal Form (3NF):** The table is in 2NF, and there are no *transitive dependencies*. A transitive dependency exists when a non-key attribute depends on another non-key attribute, rather than directly on the primary key. (e.g., `PK -> Attribute A -> Attribute B`).

## Table-by-Table Analysis

---

### 1. User Table

*   **Attributes:** `user_id (PK)`, `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `created_at`.
*   **1NF Check:** All columns hold atomic values. `first_name` and `last_name` are appropriately separated. `role` is a single value from an ENUM. The table is in 1NF.
*   **3NF Check:** All non-key attributes (`first_name`, `email`, `role`, etc.) are directly dependent only on the primary key (`user_id`). For example, `first_name` is determined by `user_id`, not by `email` or `role`. There are no transitive dependencies.
*   **Conclusion:** **The `User` table is in 3NF.**

---

### 2. Property Table

*   **Attributes:** `property_id (PK)`, `host_id (FK)`, `name`, `description`, `location`, `pricepernight`, `created_at`, `updated_at`.
*   **1NF Check:** All columns hold atomic values. The table is in 1NF.
*   **3NF Check:** All non-key attributes (`name`, `description`, `location`, `pricepernight`) are directly dependent on the `property_id`. The `host_id` is a foreign key describing the "owner" of the property. There are no non-key attributes that depend on other non-key attributes.
    *   *Note on `location`*: While `location` is a single `VARCHAR` here, a more complex system might break it into `street`, `city`, `zip_code`, `country`. In that case, one could argue that `city` depends on `zip_code`, which would be a transitive dependency. However, as designed, the single `location` field does not violate 3NF.
*   **Conclusion:** **The `Property` table is in 3NF.**

---

### 3. Booking Table

*   **Attributes:** `booking_id (PK)`, `property_id (FK)`, `user_id (FK)`, `start_date`, `end_date`, `total_price`, `status`, `created_at`.
*   **1NF Check:** All columns hold atomic values. The table is in 1NF.
*   **3NF Check:** The attributes `property_id`, `user_id`, `start_date`, `end_date`, and `status` are all directly determined by the `booking_id`.
*   **Point of Discussion: `total_price`**
    *   The `total_price` is a **calculated value**. It is derived from the number of nights (`end_date` - `start_date`) and the `pricepernight` from the related `Property` table.
    *   **Is this a 3NF violation?** Not in the classic sense. A strict interpretation of 3NF aims to eliminate all redundancy. Storing a calculated value is a form of redundancy. The "purest" 3NF design would be to **not store `total_price`** and instead calculate it on-the-fly whenever it's needed in an application or query.
    *   **Why is it here?** This is a deliberate and very common performance optimization known as **denormalization**. Calculating the price every time would require a `JOIN` to the `Property` table and a date calculation. Storing it makes retrieving booking information much faster and simpler.
    *   **The Trade-off:** The risk is data inconsistency. If the `pricepernight` changes for a property *after* a booking is made, or if the booking dates are updated, the application logic **must** ensure the `total_price` is also updated.
*   **Conclusion:** **The `Booking` table is in 3NF.** The inclusion of `total_price` is a conscious denormalization choice for performance, not a design flaw.

---

### 4. Payment, Review, and Message Tables

These three tables follow the same pattern.

*   **Payment Table:** `amount`, `payment_date`, and `payment_method` depend only on `payment_id`.
*   **Review Table:** `rating` and `comment` depend only on `review_id`.
*   **Message Table:** `message_body` and `sent_at` depend only on `message_id`.

For all three tables:
*   **1NF Check:** All columns are atomic. They are in 1NF.
*   **3NF Check:** All non-key attributes depend directly and solely on the table's primary key. There are no transitive dependencies.
*   **Conclusion:** **The `Payment`, `Review`, and `Message` tables are all in 3NF.**
