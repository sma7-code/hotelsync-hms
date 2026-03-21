-- HotelSync HMS Database Schema
-- Version: 1.0
-- Created: March 2026
-- All tables for Hotel Management System

USE hotelsync_db;

-- ─── USER ───

CREATE TABLE IF NOT EXISTS users (
                       id             BIGINT AUTO_INCREMENT PRIMARY KEY,
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

-- ─── ROOM CATEGORIES ───

CREATE TABLE IF NOT EXISTS room_categories (
                                 id          BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 name        VARCHAR(50)    NOT NULL UNIQUE,
                                 base_rate   DECIMAL(10,2)  NOT NULL,
                                 description TEXT,
                                 is_active   BOOLEAN        NOT NULL DEFAULT TRUE
);

-- ─── ROOM ───

CREATE TABLE IF NOT EXISTS rooms (
                       id          BIGINT AUTO_INCREMENT PRIMARY KEY,
                       room_number VARCHAR(10)  NOT NULL UNIQUE,
                       floor       INT          NOT NULL,
                       category_id BIGINT NOT NULL,
                       status      ENUM('AVAILABLE','BOOKED','OCCUPIED','CHECKOUT','MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',
                       FOREIGN KEY (category_id) REFERENCES room_categories(id)
);


-- ─── BOOKING ───

CREATE TABLE IF NOT EXISTS bookings (
                          id                BIGINT AUTO_INCREMENT PRIMARY KEY,
                          booking_reference VARCHAR(20) NOT NULL UNIQUE,
                          room_id           BIGINT NOT NULL,
                          check_in_date     DATE        NOT NULL,
                          check_out_date    DATE        NOT NULL,
                          number_of_guests  INT         NOT NULL,
                          booking_type      ENUM('WALK_IN','PRE_BOOKED') NOT NULL,
                          status            ENUM('CONFIRMED','CHECKED_IN','CHECKED_OUT','CANCELLED') NOT NULL DEFAULT 'CONFIRMED',
                          created_by        BIGINT NOT NULL,
                          created_at        TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (room_id)    REFERENCES rooms(id),
                          FOREIGN KEY (created_by) REFERENCES users(id)
);

-- ─── GUESTS ───

CREATE TABLE IF NOT EXISTS guests (
                        id           BIGINT AUTO_INCREMENT PRIMARY KEY,
                        booking_id   BIGINT NOT NULL,
                        name         VARCHAR(100) NOT NULL,
                        phone        VARCHAR(15),
                        address      TEXT,
                        id_type      ENUM('AADHAR','PASSPORT','DRIVING_LICENSE','VOTER_ID'),
                        id_number    VARCHAR(50),
                        id_photo_url VARCHAR(500),
                        is_primary   BOOLEAN NOT NULL DEFAULT FALSE,
                        FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

-- ─── ROOM BILLS ───

CREATE TABLE IF NOT EXISTS room_bills (
                            id                   BIGINT AUTO_INCREMENT PRIMARY KEY,
                            bill_reference       VARCHAR(20)   NOT NULL UNIQUE,
                            booking_id           BIGINT NOT NULL,
                            room_id              BIGINT NOT NULL,
                            check_in_date        DATE          NOT NULL,
                            check_out_date       DATE          NOT NULL,
                            total_nights         INT           NOT NULL,
                            rate_per_night       DECIMAL(10,2) NOT NULL,
                            total_amount         DECIMAL(10,2) NOT NULL,
                            payment_method       ENUM('CASH','CARD','UPI') NOT NULL,
                            razorpay_payment_id  VARCHAR(100),
                            generated_by         BIGINT NOT NULL,
                            generated_at         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (booking_id)   REFERENCES bookings(id),
                            FOREIGN KEY (room_id)      REFERENCES rooms(id),
                            FOREIGN KEY (generated_by) REFERENCES users(id)
);

-- ─── RESTAURANT TABLES ───

CREATE TABLE IF NOT EXISTS restaurant_tables (
                                   id           BIGINT AUTO_INCREMENT PRIMARY KEY,
                                   table_number VARCHAR(10) NOT NULL UNIQUE,
                                   capacity     INT         NOT NULL,
                                   status       ENUM('FREE','OCCUPIED') NOT NULL DEFAULT 'FREE',
                                   qr_code_url  VARCHAR(500)
);

-- ─── MENU CATEGORIES ───

CREATE TABLE IF NOT EXISTS menu_categories (
                                 id            BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 name          VARCHAR(50) NOT NULL UNIQUE,
                                 display_order INT         NOT NULL,
                                 is_active     BOOLEAN     NOT NULL DEFAULT TRUE
);

-- ─── MENU ITEMS ───

CREATE TABLE IF NOT EXISTS menu_items (
                            id           BIGINT AUTO_INCREMENT PRIMARY KEY,
                            category_id  BIGINT NOT NULL,
                            name         VARCHAR(100)  NOT NULL,
                            price        DECIMAL(10,2) NOT NULL,
                            description  TEXT,
                            photo_url    VARCHAR(500),
                            is_available BOOLEAN NOT NULL DEFAULT TRUE,
                            FOREIGN KEY (category_id) REFERENCES menu_categories(id)
);

-- ─── ORDERS ───

CREATE TABLE IF NOT EXISTS orders (
                        id         BIGINT AUTO_INCREMENT PRIMARY KEY,
                        table_id   BIGINT NOT NULL,
                        status     ENUM('PLACED','PREPARING','READY','BILLED') NOT NULL DEFAULT 'PLACED',
                        placed_by  BIGINT NOT NULL,
                        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        FOREIGN KEY (table_id)  REFERENCES restaurant_tables(id),
                        FOREIGN KEY (placed_by) REFERENCES users(id)
);

-- ─── ORDER ITEMS  ───

CREATE TABLE IF NOT EXISTS order_items (
                             id           BIGINT AUTO_INCREMENT PRIMARY KEY,
                             order_id     BIGINT NOT NULL,
                             menu_item_id BIGINT NOT NULL,
                             quantity     INT           NOT NULL,
                             unit_price   DECIMAL(10,2) NOT NULL,
                             FOREIGN KEY (order_id)     REFERENCES orders(id),
                             FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- ─── RESTAURANT BILLS ───

CREATE TABLE IF NOT EXISTS restaurant_bills (
                                  id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
                                  bill_reference      VARCHAR(20)   NOT NULL UNIQUE,
                                  table_id            BIGINT NOT NULL,
                                  session_start       TIMESTAMP     NOT NULL,
                                  total_amount        DECIMAL(10,2) NOT NULL,
                                  payment_method      ENUM('CASH','CARD','UPI') NOT NULL,
                                  razorpay_payment_id VARCHAR(100),
                                  generated_by        BIGINT NOT NULL,
                                  generated_at        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  FOREIGN KEY (table_id)     REFERENCES restaurant_tables(id),
                                  FOREIGN KEY (generated_by) REFERENCES users(id)
);