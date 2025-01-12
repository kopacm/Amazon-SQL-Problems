-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/cyy7PG
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE `products` (
    `product_id` int  NOT NULL ,
    `product_name` varchar(100)  NOT NULL ,
    `price` float  NOT NULL ,
    `cogs` float  NOT NULL ,
    `category_id` int  NOT NULL ,
    PRIMARY KEY (
        `product_id`
    )
);

CREATE TABLE `category` (
    `category_id` int  NOT NULL ,
    `category_name` varchar(50)  NOT NULL ,
    PRIMARY KEY (
        `category_id`
    )
);

CREATE TABLE `customers` (
    `customer_id` int   ,
    `first_name` varchar(20)   ,
    `last_name` varchar(20)   ,
    `state` varchar(20)   ,
    PRIMARY KEY (
        `customer_id`
    )
);

CREATE TABLE `inventory` (
    `inventory_id` int  NOT NULL ,
    `product_id` int  NOT NULL ,
    `stock` int  NOT NULL ,
    `warehouse_id` int  NOT NULL ,
    `last_stock_date` date  ,
    PRIMARY KEY (
        `inventory_id`
    )
);

CREATE TABLE `order_items` (
    `order_item_id` int  NOT NULL ,
    `order_id` int  NOT NULL ,
    `product_id` int  NOT NULL ,
    `quantity` int  NOT NULL ,
    `price_per_unit` decimal(6,2)  NOT NULL ,
    PRIMARY KEY (
        `order_item_id`
    )
);

CREATE TABLE `orders` (
    `order_id` int PRIMARY KEY NOT NULL ,
    `order_date` date  NOT NULL ,
    `customer_id` int  NOT NULL ,
    `seller_id` int  NOT NULL ,
    `order_status` varchar(20)  NOT NULL 
);

CREATE TABLE `payments` (
    `payment_id` int  NOT NULL ,
    `order_id` int  NOT NULL ,
    `payment_date` date  NOT NULL ,
    `payment_status` varchar(50)  NOT NULL ,
    PRIMARY KEY (
        `payment_id`
    )
);

CREATE TABLE `sellers` (
    `seller_id` int  NOT NULL ,
    `seller_name` varchar(50)  NOT NULL ,
    `origin` varchar(20)  NOT NULL ,
    PRIMARY KEY (
        `seller_id`
    )
);

CREATE TABLE `shipping` (
    `shipping_id` int  NOT NULL ,
    `order_id` int  NOT NULL ,
    `shipping_date` date  NOT NULL ,
    `return_date` date,
    `shipping_providers` varchar(30) ,
    `delivery_status` varchar(20)  NOT NULL ,
    PRIMARY KEY (
        `shipping_id`
    )
);

ALTER TABLE `products` ADD CONSTRAINT `fk_products_category_id` FOREIGN KEY(`category_id`)
REFERENCES `category` (`category_id`);

ALTER TABLE `inventory` ADD CONSTRAINT `fk_inventory_product_id` FOREIGN KEY(`product_id`)
REFERENCES `products` (`product_id`);

ALTER TABLE `order_items` ADD CONSTRAINT `fk_order_items_order_id` FOREIGN KEY(`order_id`)
REFERENCES `orders` (`order_id`);

ALTER TABLE `order_items` ADD CONSTRAINT `fk_order_items_product_id` FOREIGN KEY(`product_id`)
REFERENCES `products` (`product_id`);

ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_customer_id` FOREIGN KEY(`customer_id`)
REFERENCES `customers` (`customer_id`);

ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_seller_id` FOREIGN KEY(`seller_id`)
REFERENCES `sellers` (`seller_id`);

ALTER TABLE `payments` ADD CONSTRAINT `fk_payments_order_id` FOREIGN KEY(`order_id`)
REFERENCES `orders` (`order_id`);

ALTER TABLE `shipping` ADD CONSTRAINT `fk_shipping_order_id` FOREIGN KEY(`order_id`)
REFERENCES `orders` (`order_id`);



