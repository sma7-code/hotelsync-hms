CREATE TABLE users (
                       id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       user_id        VARCHAR(20)  NOT NULL UNIQUE,
                       name           VARCHAR(100) NOT NULL,
                       email          VARCHAR(100) NOT NULL UNIQUE,
                       phone          VARCHAR(15),
                       password       VARCHAR(255) NOT NULL,
                       role           ENUM('ADMIN','RECEPTIONIST','MANAGER','WAITER','CHEF','ACCOUNTANT') NOT NULL,
                       is_first_login BOOLEAN      NOT NULL DEFAULT TRUE,
                       is_active      BOOLEAN      NOT NULL DEFAULT TRUE,
                       created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE room_categories (
                                 id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                 name        VARCHAR(50)    NOT NULL UNIQUE,
                                 base_rate   DECIMAL(10,2)  NOT NULL,
                                 description TEXT,
                                 is_active   BOOLEAN        NOT NULL DEFAULT TRUE
);

CREATE TABLE rooms (
                       id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       room_number VARCHAR(10)  NOT NULL UNIQUE,
                       floor       INT          NOT NULL,
                       category_id BIGINT UNSIGNED NOT NULL,
                       status      ENUM('AVAILABLE','BOOKED','OCCUPIED','CHECKOUT','MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',
                       FOREIGN KEY (category_id) REFERENCES room_categories(id)
);

CREATE TABLE bookings (
                          id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                          booking_reference VARCHAR(20) NOT NULL UNIQUE,
                          room_id           BIGINT UNSIGNED NOT NULL,
                          check_in_date     DATE        NOT NULL,
                          check_out_date    DATE        NOT NULL,
                          number_of_guests  INT         NOT NULL,
                          booking_type      ENUM('WALK_IN','PRE_BOOKED') NOT NULL,
                          status            ENUM('CONFIRMED','CHECKED_IN','CHECKED_OUT','CANCELLED') NOT NULL DEFAULT 'CONFIRMED',
                          created_by        BIGINT UNSIGNED NOT NULL,
                          created_at        TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (room_id)    REFERENCES rooms(id),
                          FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE guests (
                        id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                        booking_id   BIGINT UNSIGNED NOT NULL,
                        name         VARCHAR(100) NOT NULL,
                        phone        VARCHAR(15),
                        address      TEXT,
                        id_type      ENUM('AADHAR','PASSPORT','DRIVING_LICENSE','VOTER_ID'),
                        id_number    VARCHAR(50),
                        id_photo_url VARCHAR(500),
                        is_primary   BOOLEAN NOT NULL DEFAULT FALSE,
                        FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

CREATE TABLE room_bills (
                            id                   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                            bill_reference       VARCHAR(20)   NOT NULL UNIQUE,
                            booking_id           BIGINT UNSIGNED NOT NULL,
                            room_id              BIGINT UNSIGNED NOT NULL,
                            check_in_date        DATE          NOT NULL,
                            check_out_date       DATE          NOT NULL,
                            total_nights         INT           NOT NULL,
                            rate_per_night       DECIMAL(10,2) NOT NULL,
                            total_amount         DECIMAL(10,2) NOT NULL,
                            payment_method       ENUM('CASH','CARD','UPI') NOT NULL,
                            razorpay_payment_id  VARCHAR(100),
                            generated_by         BIGINT UNSIGNED NOT NULL,
                            generated_at         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (booking_id)   REFERENCES bookings(id),
                            FOREIGN KEY (room_id)      REFERENCES rooms(id),
                            FOREIGN KEY (generated_by) REFERENCES users(id)
);

CREATE TABLE restaurant_tables (
                                   id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                   table_number VARCHAR(10) NOT NULL UNIQUE,
                                   capacity     INT         NOT NULL,
                                   status       ENUM('FREE','OCCUPIED') NOT NULL DEFAULT 'FREE',
                                   qr_code_url  VARCHAR(500)
);

CREATE TABLE menu_categories (
                                 id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                 name          VARCHAR(50) NOT NULL UNIQUE,
                                 display_order INT         NOT NULL,
                                 is_active     BOOLEAN     NOT NULL DEFAULT TRUE
);

CREATE TABLE menu_items (
                            id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                            category_id  BIGINT UNSIGNED NOT NULL,
                            name         VARCHAR(100)  NOT NULL,
                            price        DECIMAL(10,2) NOT NULL,
                            description  TEXT,
                            photo_url    VARCHAR(500),
                            is_available BOOLEAN NOT NULL DEFAULT TRUE,
                            FOREIGN KEY (category_id) REFERENCES menu_categories(id)
);

CREATE TABLE orders (
                        id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                        table_id   BIGINT UNSIGNED NOT NULL,
                        status     ENUM('PLACED','PREPARING','READY','BILLED') NOT NULL DEFAULT 'PLACED',
                        placed_by  BIGINT UNSIGNED NOT NULL,
                        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        FOREIGN KEY (table_id)  REFERENCES restaurant_tables(id),
                        FOREIGN KEY (placed_by) REFERENCES users(id)
);

CREATE TABLE order_items (
                             id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                             order_id     BIGINT UNSIGNED NOT NULL,
                             menu_item_id BIGINT UNSIGNED NOT NULL,
                             quantity     INT           NOT NULL,
                             unit_price   DECIMAL(10,2) NOT NULL,
                             FOREIGN KEY (order_id)     REFERENCES orders(id),
                             FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

CREATE TABLE restaurant_bills (
                                  id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                  bill_reference      VARCHAR(20)   NOT NULL UNIQUE,
                                  table_id            BIGINT UNSIGNED NOT NULL,
                                  session_start       TIMESTAMP     NOT NULL,
                                  total_amount        DECIMAL(10,2) NOT NULL,
                                  payment_method      ENUM('CASH','CARD','UPI') NOT NULL,
                                  razorpay_payment_id VARCHAR(100),
                                  generated_by        BIGINT UNSIGNED NOT NULL,
                                  generated_at        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  FOREIGN KEY (table_id)     REFERENCES restaurant_tables(id),
                                  FOREIGN KEY (generated_by) REFERENCES users(id)
);