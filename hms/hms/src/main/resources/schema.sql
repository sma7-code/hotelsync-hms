CREATE TABLE `users` (
                         `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                         `user_id`        VARCHAR(20)     NOT NULL,
                         `name`           VARCHAR(100)    NOT NULL,
                         `email`          VARCHAR(100)    NOT NULL,
                         `phone`          VARCHAR(15)     NULL,
                         `password`       VARCHAR(255)    NOT NULL,
                         `role`           ENUM('ADMIN', 'RECEPTIONIST', 'MANAGER', 'WAITER', 'CHEF', 'ACCOUNTANT') NOT NULL,
                         `is_first_login` BOOLEAN         NOT NULL DEFAULT TRUE,
                         `is_active`      BOOLEAN         NOT NULL DEFAULT TRUE,
                         `created_at`     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE `users` ADD UNIQUE `users_user_id_unique` (`user_id`);
ALTER TABLE `users` ADD UNIQUE `users_email_unique` (`email`);


CREATE TABLE `room_categories` (
                                   `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                   `name`        VARCHAR(50)     NOT NULL,
                                   `base_rate`   DECIMAL(10, 2)  NOT NULL,
                                   `description` TEXT            NULL,
                                   `is_active`   BOOLEAN         NOT NULL DEFAULT TRUE
);
ALTER TABLE `room_categories` ADD UNIQUE `room_categories_name_unique` (`name`);


CREATE TABLE `rooms` (
                         `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                         `room_number` VARCHAR(10)     NOT NULL,
                         `floor`       INT             NOT NULL,
                         `category_id` BIGINT UNSIGNED NOT NULL,
                         `status`      ENUM('AVAILABLE', 'BOOKED', 'OCCUPIED', 'CHECKOUT', 'MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE'
);
ALTER TABLE `rooms` ADD UNIQUE `rooms_room_number_unique` (`room_number`);
ALTER TABLE `rooms` ADD CONSTRAINT `rooms_category_id_foreign`
    FOREIGN KEY (`category_id`) REFERENCES `room_categories` (`id`);


CREATE TABLE `bookings` (
                            `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                            `booking_reference` VARCHAR(20)     NOT NULL,
                            `room_id`           BIGINT UNSIGNED NOT NULL,
                            `check_in_date`     DATE            NOT NULL,
                            `check_out_date`    DATE            NOT NULL,
                            `number_of_guests`  INT             NOT NULL,
                            `booking_type`      ENUM('WALK_IN', 'PRE_BOOKED') NOT NULL,
                            `status`            ENUM('CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED') NOT NULL DEFAULT 'CONFIRMED',
                            `created_by`        BIGINT UNSIGNED NOT NULL,
                            `created_at`        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE `bookings` ADD UNIQUE `bookings_booking_reference_unique` (`booking_reference`);
ALTER TABLE `bookings` ADD CONSTRAINT `bookings_room_id_foreign`
    FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);
ALTER TABLE `bookings` ADD CONSTRAINT `bookings_created_by_foreign`
    FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);


CREATE TABLE `guests` (
                          `id`           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                          `booking_id`   BIGINT UNSIGNED NOT NULL,
                          `name`         VARCHAR(100)    NOT NULL,
                          `phone`        VARCHAR(15)     NULL,
                          `address`      TEXT            NULL,
                          `id_type`      ENUM('AADHAR', 'PASSPORT', 'DRIVING_LICENSE', 'VOTER_ID') NULL,
                          `id_number`    VARCHAR(50)     NULL,
                          `id_photo_url` VARCHAR(500)    NULL,
                          `is_primary`   BOOLEAN         NOT NULL DEFAULT FALSE
);
ALTER TABLE `guests` ADD CONSTRAINT `guests_booking_id_foreign`
    FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`);


CREATE TABLE `room_bills` (
                              `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                              `bill_reference`      VARCHAR(20)     NOT NULL,
                              `booking_id`          BIGINT UNSIGNED NOT NULL,
                              `room_id`             BIGINT UNSIGNED NOT NULL,
                              `check_in_date`       DATE            NOT NULL,
                              `check_out_date`      DATE            NOT NULL,
                              `total_nights`        INT             NOT NULL,
                              `rate_per_night`      DECIMAL(10, 2)  NOT NULL,
                              `total_amount`        DECIMAL(10, 2)  NOT NULL,
                              `payment_method`      ENUM('CASH', 'CARD', 'UPI') NOT NULL,
                              `razorpay_payment_id` VARCHAR(100)    NULL,
                              `generated_by`        BIGINT UNSIGNED NOT NULL,
                              `generated_at`        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE `room_bills` ADD UNIQUE `room_bills_bill_reference_unique` (`bill_reference`);
ALTER TABLE `room_bills` ADD CONSTRAINT `room_bills_booking_id_foreign`
    FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`);
ALTER TABLE `room_bills` ADD CONSTRAINT `room_bills_room_id_foreign`
    FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);
ALTER TABLE `room_bills` ADD CONSTRAINT `room_bills_generated_by_foreign`
    FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`);


CREATE TABLE `restaurant_tables` (
                                     `id`           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                     `table_number` VARCHAR(10)     NOT NULL,
                                     `capacity`     INT             NOT NULL,
                                     `status`       ENUM('FREE', 'OCCUPIED') NOT NULL DEFAULT 'FREE',
                                     `qr_code_url`  VARCHAR(500)    NULL
);
ALTER TABLE `restaurant_tables` ADD UNIQUE `restaurant_tables_table_number_unique` (`table_number`);


CREATE TABLE `menu_categories` (
                                   `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                   `name`          VARCHAR(50)     NOT NULL,
                                   `display_order` INT             NOT NULL,
                                   `is_active`     BOOLEAN         NOT NULL DEFAULT TRUE
);
ALTER TABLE `menu_categories` ADD UNIQUE `menu_categories_name_unique` (`name`);


CREATE TABLE `menu_items` (
                              `id`           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                              `category_id`  BIGINT UNSIGNED NOT NULL,
                              `name`         VARCHAR(100)    NOT NULL,
                              `price`        DECIMAL(10, 2)  NOT NULL,
                              `description`  TEXT            NULL,
                              `photo_url`    VARCHAR(500)    NULL,
                              `is_available` BOOLEAN         NOT NULL DEFAULT TRUE
);
ALTER TABLE `menu_items` ADD CONSTRAINT `menu_items_category_id_foreign`
    FOREIGN KEY (`category_id`) REFERENCES `menu_categories` (`id`);


CREATE TABLE `orders` (
                          `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                          `table_id`   BIGINT UNSIGNED NOT NULL,
                          `status`     ENUM('PLACED', 'PREPARING', 'READY', 'BILLED') NOT NULL DEFAULT 'PLACED',
                          `placed_by`  BIGINT UNSIGNED NOT NULL,
                          `created_at` TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          `updated_at` TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE `orders` ADD CONSTRAINT `orders_table_id_foreign`
    FOREIGN KEY (`table_id`) REFERENCES `restaurant_tables` (`id`);
ALTER TABLE `orders` ADD CONSTRAINT `orders_placed_by_foreign`
    FOREIGN KEY (`placed_by`) REFERENCES `users` (`id`);


CREATE TABLE `order_items` (
                               `id`           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                               `order_id`     BIGINT UNSIGNED NOT NULL,
                               `menu_item_id` BIGINT UNSIGNED NOT NULL,
                               `quantity`     INT             NOT NULL,
                               `unit_price`   DECIMAL(10, 2)  NOT NULL
);
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_order_id_foreign`
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_menu_item_id_foreign`
    FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);


CREATE TABLE `restaurant_bills` (
                                    `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                    `bill_reference`      VARCHAR(20)     NOT NULL,
                                    `table_id`            BIGINT UNSIGNED NOT NULL,
                                    `session_start`       TIMESTAMP       NOT NULL,
                                    `total_amount`        DECIMAL(10, 2)  NOT NULL,
                                    `payment_method`      ENUM('CASH', 'CARD', 'UPI') NOT NULL,
                                    `razorpay_payment_id` VARCHAR(100)    NULL,
                                    `generated_by`        BIGINT UNSIGNED NOT NULL,
                                    `generated_at`        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE `restaurant_bills` ADD UNIQUE `restaurant_bills_bill_reference_unique` (`bill_reference`);
ALTER TABLE `restaurant_bills` ADD CONSTRAINT `restaurant_bills_table_id_foreign`
    FOREIGN KEY (`table_id`) REFERENCES `restaurant_tables` (`id`);
ALTER TABLE `restaurant_bills` ADD CONSTRAINT `restaurant_bills_generated_by_foreign`
    FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`);