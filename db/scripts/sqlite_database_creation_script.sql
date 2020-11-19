PRAGMA ENCODING = "UTF-8";
PRAGMA foreign_keys = ON;
-- -----------------------------------------------------
-- Table `customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `customers` (
    `id` INTEGER NOT NULL,
    `company` VARCHAR(50) NULL DEFAULT NULL,
    `last_name` VARCHAR(50) NULL DEFAULT NULL,
    `first_name` VARCHAR(50) NULL DEFAULT NULL,
    `email_address` VARCHAR(50) NULL DEFAULT NULL,
    `job_title` VARCHAR(50) NULL DEFAULT NULL,
    `business_phone` VARCHAR(25) NULL DEFAULT NULL,
    `home_phone` VARCHAR(25) NULL DEFAULT NULL,
    `mobile_phone` VARCHAR(25) NULL DEFAULT NULL,
    `fax_number` VARCHAR(25) NULL DEFAULT NULL,
    `address` LONGTEXT NULL DEFAULT NULL,
    `city` VARCHAR(50) NULL DEFAULT NULL,
    `state_province` VARCHAR(50) NULL DEFAULT NULL,
    `zip_postal_code` VARCHAR(15) NULL DEFAULT NULL,
    `country_region` VARCHAR(50) NULL DEFAULT NULL,
    `web_page` LONGTEXT NULL DEFAULT NULL,
    `notes` LONGTEXT NULL DEFAULT NULL,
    `attachments` LONGBLOB NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `employees` (
    `id` INTEGER NOT NULL,
    `company` VARCHAR(50) NULL DEFAULT NULL,
    `last_name` VARCHAR(50) NULL DEFAULT NULL,
    `first_name` VARCHAR(50) NULL DEFAULT NULL,
    `email_address` VARCHAR(50) NULL DEFAULT NULL,
    `job_title` VARCHAR(50) NULL DEFAULT NULL,
    `business_phone` VARCHAR(25) NULL DEFAULT NULL,
    `home_phone` VARCHAR(25) NULL DEFAULT NULL,
    `mobile_phone` VARCHAR(25) NULL DEFAULT NULL,
    `fax_number` VARCHAR(25) NULL DEFAULT NULL,
    `address` LONGTEXT NULL DEFAULT NULL,
    `city` VARCHAR(50) NULL DEFAULT NULL,
    `state_province` VARCHAR(50) NULL DEFAULT NULL,
    `zip_postal_code` VARCHAR(15) NULL DEFAULT NULL,
    `country_region` VARCHAR(50) NULL DEFAULT NULL,
    `web_page` LONGTEXT NULL DEFAULT NULL,
    `notes` LONGTEXT NULL DEFAULT NULL,
    `attachments` LONGBLOB NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `privileges`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `privileges` (
    `id` INTEGER NOT NULL,
    `privilege_name` VARCHAR(50) NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `employee_privileges`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `employee_privileges` (
    `employee_id` INT(11) NOT NULL,
    `privilege_id` INT(11) NOT NULL,
    PRIMARY KEY (`employee_id`, `privilege_id`),
    FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`privilege_id`) REFERENCES `privileges` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `inventory_transaction_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventory_transaction_types` (
    `id` TINYINT(4) NOT NULL,
    `type_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `shippers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shippers` (
    `id` INTEGER NOT NULL,
    `company` VARCHAR(50) NULL DEFAULT NULL,
    `last_name` VARCHAR(50) NULL DEFAULT NULL,
    `first_name` VARCHAR(50) NULL DEFAULT NULL,
    `email_address` VARCHAR(50) NULL DEFAULT NULL,
    `job_title` VARCHAR(50) NULL DEFAULT NULL,
    `business_phone` VARCHAR(25) NULL DEFAULT NULL,
    `home_phone` VARCHAR(25) NULL DEFAULT NULL,
    `mobile_phone` VARCHAR(25) NULL DEFAULT NULL,
    `fax_number` VARCHAR(25) NULL DEFAULT NULL,
    `address` LONGTEXT NULL DEFAULT NULL,
    `city` VARCHAR(50) NULL DEFAULT NULL,
    `state_province` VARCHAR(50) NULL DEFAULT NULL,
    `zip_postal_code` VARCHAR(15) NULL DEFAULT NULL,
    `country_region` VARCHAR(50) NULL DEFAULT NULL,
    `web_page` LONGTEXT NULL DEFAULT NULL,
    `notes` LONGTEXT NULL DEFAULT NULL,
    `attachments` LONGBLOB NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `orders_tax_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `orders_tax_status` (
    `id` TINYINT(4) NOT NULL,
    `tax_status_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `orders_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `orders_status` (
    `id` TINYINT(4) NOT NULL,
    `status_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `orders` (
    `id` INTEGER NOT NULL,
    `employee_id` INT(11) NULL DEFAULT NULL,
    `customer_id` INT(11) NULL DEFAULT NULL,
    `order_date` DATETIME NULL DEFAULT NULL,
    `shipped_date` DATETIME NULL DEFAULT NULL,
    `shipper_id` INT(11) NULL DEFAULT NULL,
    `ship_name` VARCHAR(50) NULL DEFAULT NULL,
    `ship_address` LONGTEXT NULL DEFAULT NULL,
    `ship_city` VARCHAR(50) NULL DEFAULT NULL,
    `ship_state_province` VARCHAR(50) NULL DEFAULT NULL,
    `ship_zip_postal_code` VARCHAR(50) NULL DEFAULT NULL,
    `ship_country_region` VARCHAR(50) NULL DEFAULT NULL,
    `shipping_fee` DECIMAL(19, 4) NULL DEFAULT '0.0000',
    `taxes` DECIMAL(19, 4) NULL DEFAULT '0.0000',
    `payment_type` VARCHAR(50) NULL DEFAULT NULL,
    `paid_date` DATETIME NULL DEFAULT NULL,
    `notes` LONGTEXT NULL DEFAULT NULL,
    `tax_rate` DOUBLE NULL DEFAULT '0',
    `tax_status_id` TINYINT(4) NULL DEFAULT NULL,
    `status_id` TINYINT(4) NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`shipper_id`) REFERENCES `shippers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`tax_status_id`) REFERENCES `orders_tax_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`status_id`) REFERENCES `orders_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `products` (
    `supplier_ids` LONGTEXT NULL DEFAULT NULL,
    `id` INTEGER NOT NULL,
    `product_code` VARCHAR(25) NULL DEFAULT NULL,
    `product_name` VARCHAR(50) NULL DEFAULT NULL,
    `description` LONGTEXT NULL DEFAULT NULL,
    `standard_cost` DECIMAL(19, 4) NULL DEFAULT '0.0000',
    `list_price` DECIMAL(19, 4) NOT NULL DEFAULT '0.0000',
    `reorder_level` INT(11) NULL DEFAULT NULL,
    `target_level` INT(11) NULL DEFAULT NULL,
    `quantity_per_unit` VARCHAR(50) NULL DEFAULT NULL,
    `discontinued` TINYINT(1) NOT NULL DEFAULT '0',
    `minimum_reorder_quantity` INT(11) NULL DEFAULT NULL,
    `category` VARCHAR(50) NULL DEFAULT NULL,
    `attachments` LONGBLOB NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `purchase_order_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchase_order_status` (
    `id` INT(11) NOT NULL,
    `status` VARCHAR(50) NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `suppliers` (
    `id` INTEGER NOT NULL,
    `company` VARCHAR(50) NULL DEFAULT NULL,
    `last_name` VARCHAR(50) NULL DEFAULT NULL,
    `first_name` VARCHAR(50) NULL DEFAULT NULL,
    `email_address` VARCHAR(50) NULL DEFAULT NULL,
    `job_title` VARCHAR(50) NULL DEFAULT NULL,
    `business_phone` VARCHAR(25) NULL DEFAULT NULL,
    `home_phone` VARCHAR(25) NULL DEFAULT NULL,
    `mobile_phone` VARCHAR(25) NULL DEFAULT NULL,
    `fax_number` VARCHAR(25) NULL DEFAULT NULL,
    `address` LONGTEXT NULL DEFAULT NULL,
    `city` VARCHAR(50) NULL DEFAULT NULL,
    `state_province` VARCHAR(50) NULL DEFAULT NULL,
    `zip_postal_code` VARCHAR(15) NULL DEFAULT NULL,
    `country_region` VARCHAR(50) NULL DEFAULT NULL,
    `web_page` LONGTEXT NULL DEFAULT NULL,
    `notes` LONGTEXT NULL DEFAULT NULL,
    `attachments` LONGBLOB NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `purchase_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchase_orders` (
    `id` INTEGER NOT NULL,
    `supplier_id` INT(11) NULL DEFAULT NULL,
    `created_by` INT(11) NULL DEFAULT NULL,
    `submitted_date` DATETIME NULL DEFAULT NULL,
    `creation_date` DATETIME NULL DEFAULT NULL,
    `status_id` INT(11) NULL DEFAULT '0',
    `expected_date` DATETIME NULL DEFAULT NULL,
    `shipping_fee` DECIMAL(19, 4) NOT NULL DEFAULT '0.0000',
    `taxes` DECIMAL(19, 4) NOT NULL DEFAULT '0.0000',
    `payment_date` DATETIME NULL DEFAULT NULL,
    `payment_amount` DECIMAL(19, 4) NULL DEFAULT '0.0000',
    `payment_method` VARCHAR(50) NULL DEFAULT NULL,
    `notes` LONGTEXT NULL DEFAULT NULL,
    `approved_by` INT(11) NULL DEFAULT NULL,
    `approved_date` DATETIME NULL DEFAULT NULL,
    `submitted_by` INT(11) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`status_id`) REFERENCES `purchase_order_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `inventory_transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventory_transactions` (
    `id` INTEGER NOT NULL,
    `transaction_type` TINYINT(4) NOT NULL,
    `transaction_created_date` DATETIME NULL DEFAULT NULL,
    `transaction_modified_date` DATETIME NULL DEFAULT NULL,
    `product_id` INT(11) NOT NULL,
    `quantity` INT(11) NOT NULL,
    `purchase_order_id` INT(11) NULL DEFAULT NULL,
    `customer_order_id` INT(11) NULL DEFAULT NULL,
    `comments` VARCHAR(255) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`customer_order_id`) REFERENCES `orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`transaction_type`) REFERENCES `inventory_transaction_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `invoices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `invoices` (
    `id` INTEGER NOT NULL,
    `order_id` INT(11) NULL DEFAULT NULL,
    `invoice_date` DATETIME NULL DEFAULT NULL,
    `due_date` DATETIME NULL DEFAULT NULL,
    `tax` DECIMAL(19, 4) NULL DEFAULT '0.0000',
    `shipping` DECIMAL(19, 4) NULL DEFAULT '0.0000',
    `amount_due` DECIMAL(19, 4) NULL DEFAULT '0.0000',
    PRIMARY KEY (`id`),
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `order_details_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `order_details_status` (
    `id` INT(11) NOT NULL,
    `status_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `order_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `order_details` (
    `id` INTEGER NOT NULL,
    `order_id` INT(11) NOT NULL,
    `product_id` INT(11) NULL DEFAULT NULL,
    `quantity` DECIMAL(18, 4) NOT NULL DEFAULT '0.0000',
    `unit_price` DECIMAL(19, 4) NULL DEFAULT '0.0000',
    `discount` DOUBLE NOT NULL DEFAULT '0',
    `status_id` INT(11) NULL DEFAULT NULL,
    `date_allocated` DATETIME NULL DEFAULT NULL,
    `purchase_order_id` INT(11) NULL DEFAULT NULL,
    `inventory_id` INT(11) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`status_id`) REFERENCES `order_details_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `purchase_order_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchase_order_details` (
    `id` INTEGER NOT NULL,
    `purchase_order_id` INT(11) NOT NULL,
    `product_id` INT(11) NULL DEFAULT NULL,
    `quantity` DECIMAL(18, 4) NOT NULL,
    `unit_cost` DECIMAL(19, 4) NOT NULL,
    `date_received` DATETIME NULL DEFAULT NULL,
    `posted_to_inventory` TINYINT(1) NOT NULL DEFAULT '0',
    `inventory_id` INT(11) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`inventory_id`) REFERENCES `inventory_transactions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `sales_reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sales_reports` (
    `group_by` VARCHAR(50) NOT NULL,
    `display` VARCHAR(50) NULL DEFAULT NULL,
    `title` VARCHAR(50) NULL DEFAULT NULL,
    `filter_row_source` LONGTEXT NULL DEFAULT NULL,
    `default` TINYINT(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`group_by`)
);
-- -----------------------------------------------------
-- Table `strings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `strings` (
    `string_id` INTEGER NOT NULL,
    `string_data` VARCHAR(255) NULL DEFAULT NULL,
    PRIMARY KEY (`string_id`)
);