erDiagram
    User {
        UUID user_id PK
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR email UK
        VARCHAR password_hash
        VARCHAR phone_number
        ENUM role
        TIMESTAMP created_at
    }

    Property {
        UUID property_id PK
        UUID host_id FK
        VARCHAR name
        TEXT description
        VARCHAR location
        DECIMAL pricepernight
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }

    Booking {
        UUID booking_id PK
        UUID property_id FK
        UUID user_id FK
        DATE start_date
        DATE end_date
        DECIMAL total_price
        ENUM status
        TIMESTAMP created_at
    }

    Payment {
        UUID payment_id PK
        UUID booking_id FK
        DECIMAL amount
        TIMESTAMP payment_date
        ENUM payment_method
    }

    Review {
        UUID review_id PK
        UUID property_id FK
        UUID user_id FK
        INTEGER rating
        TEXT comment
        TIMESTAMP created_at
    }

    Message {
        UUID message_id PK
        UUID sender_id FK
        UUID recipient_id FK
        TEXT message_body
        TIMESTAMP sent_at
    }

    ' A User (host) has zero or more Properties '
    User ||--|{ Property : "hosts"

    ' A User (guest) makes zero or more Bookings '
    User ||--o{ Booking : "makes"

    ' A Property has zero or more Bookings '
    Property ||--o{ Booking : "is for"

    ' A Booking has zero or one Payment '
    Booking |o--|| Payment : "has"

    ' A User writes zero or more Reviews '
    User ||--o{ Review : "writes"

    ' A Property receives zero or more Reviews '
    Property ||--o{ Review : "is for"

    ' A User sends zero or more Messages '
    User ||--o{ Message : "sends"

    ' A User receives zero or more Messages '
    User ||--o{ Message : "receives"

The visual representation is found [here](Erd.png)