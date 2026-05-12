CREATE TABLE orders (
    order_id INT,
    user_id INT,
    restaurant_id INT,
    courier_id INT,
    order_time TIMESTAMP,
    delivery_time TIMESTAMP,
    price DECIMAL(10,2)
);

CREATE TABLE couriers (
    courier_id INT,
    name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE restaurants (
    restaurant_id INT,
    name VARCHAR(100),
    cuisine_type VARCHAR(50)
);
