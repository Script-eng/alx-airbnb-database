-- =============================================
-- Generic SQL Schema for AirBnB Database
-- This script uses standard SQL and should be compatible with most RDBMS
-- (e.g., MySQL, PostgreSQL, SQL Server, SQLite) with minor adjustments.
-- Notes on potential adjustments are provided in comments.
-- =============================================


-- ---------------------------------------------
-- Table: Users
-- Stores user account information.
-- ---------------------------------------------

CREATE TABLE Users (
    user_id INT PRIMARY KEY, -- For MySQL: INT PRIMARY KEY AUTO_INCREMENT. For SQL Server: INT PRIMARY KEY IDENTITY(1,1). For SQLite: INTEGER PRIMARY KEY AUTOINCREMENT.
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50),
    role VARCHAR(20) NOT NULL CHECK (role IN ('guest', 'host', 'admin')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ---------------------------------------------
-- Table: Properties
-- Contains details about each rental property.
-- ---------------------------------------------

CREATE TABLE Properties (
    property_id INT PRIMARY KEY, -- See auto-increment note for Users table.
    host_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP, -- This should be managed by the application layer.

    FOREIGN KEY (host_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


-- ---------------------------------------------
-- Table: Bookings
-- Represents a reservation made by a guest.
-- ---------------------------------------------

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY, -- See auto-increment note for Users table.
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'canceled')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT check_dates CHECK (end_date > start_date)
);


-- ---------------------------------------------
-- Table: Payments
-- Records the financial transaction for a booking.
-- ---------------------------------------------

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY, -- See auto-increment note for Users table.
    booking_id INT NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('credit_card', 'paypal', 'stripe')),

    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE
);


-- ---------------------------------------------
-- Table: Reviews
-- Allows users to leave ratings and comments.
-- ---------------------------------------------

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY, -- See auto-increment note for Users table.
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT check_rating CHECK (rating >= 1 AND rating <= 5),
    -- A user can only review a specific property once.
    CONSTRAINT unique_user_property_review UNIQUE (user_id, property_id)
);


-- ---------------------------------------------
-- Table: Messages
-- Facilitates direct communication between users.
-- ---------------------------------------------

CREATE TABLE Messages (
    message_id INT PRIMARY KEY, -- See auto-increment note for Users table.
    sender_id INT NOT NULL,
    recipient_id INT NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (sender_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT check_sender_recipient CHECK (sender_id <> recipient_id)
);


-- =============================================
-- Indexes for Performance
-- Creating indexes on foreign keys and frequently searched columns is crucial for performance.
-- The syntax `CREATE INDEX index_name ON table_name(column_name);` is standard.
-- =============================================

-- Indexes for Properties table
CREATE INDEX idx_properties_host_id ON Properties(host_id);
CREATE INDEX idx_properties_location ON Properties(location);
CREATE INDEX idx_properties_price ON Properties(price_per_night);

-- Indexes for Bookings table
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX idx_bookings_dates ON Bookings(start_date, end_date);

-- Indexes for Reviews table
CREATE INDEX idx_reviews_property_id ON Reviews(property_id);
-- An index for (user_id, property_id) is created automatically by the UNIQUE constraint.

-- Indexes for Messages table
CREATE INDEX idx_messages_sender_id ON Messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON Messages(recipient_id);

-- End of Schema Definition