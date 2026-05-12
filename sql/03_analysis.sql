-- 1. Среднее время доставки (в минутах)
SELECT 
    AVG(EXTRACT(EPOCH FROM (delivery_time - order_time)) / 60) AS avg_delivery_minutes
FROM orders;

-- 2. Топ ресторанов по количеству заказов
SELECT 
    restaurant_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY restaurant_id
ORDER BY total_orders DESC;

-- 3. Топ курьеров
SELECT 
    courier_id,
    COUNT(*) AS deliveries
FROM orders
GROUP BY courier_id
ORDER BY deliveries DESC;

-- 4. Выручка по дням
SELECT 
    DATE(order_time) AS day,
    SUM(price) AS revenue
FROM orders
GROUP BY day
ORDER BY day;

-- 5. Быстрые и медленные доставки
SELECT 
    CASE 
        WHEN EXTRACT(EPOCH FROM (delivery_time - order_time)) < 1800 
        THEN 'fast'
        ELSE 'slow'
    END AS delivery_type,
    COUNT(*) AS total
FROM orders
GROUP BY delivery_type;

-- 6. Кто достаавил заказ
SELECT 
    o.order_id,
    o.order_time,
    o.price,
    c.name AS courier_name,
    c.city
FROM orders o
JOIN couriers c
    ON o.courier_id = c.courier_id;

--7. Какой ресторан
SELECT 
    o.order_id,
    r.name AS restaurant_name,
    r.cuisine_type,
    o.price
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id;

--7. Полная аналитика
SELECT 
    o.order_id,
    c.name AS courier,
    r.name AS restaurant,
    o.price
FROM orders o
JOIN couriers c ON o.courier_id = c.courier_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id;

--8.Среднее время доставки
WITH delivery_times AS (
    SELECT 
        order_id,
        EXTRACT(EPOCH FROM (delivery_time - order_time)) / 60 AS delivery_minutes
    FROM orders
)
SELECT 
    AVG(delivery_minutes) AS avg_delivery_time
FROM delivery_times;

--9.Топ курьеров через CTE
WITH courier_stats AS (
    SELECT 
        courier_id,
        COUNT(*) AS deliveries
    FROM orders
    GROUP BY courier_id
)
SELECT *
FROM courier_stats
ORDER BY deliveries DESC;

--10.Топ ресторанов по выручке
WITH revenue AS (
    SELECT 
        r.restaurant_id,
        r.name,
        SUM(o.price) AS total_revenue
    FROM orders o
    JOIN restaurants r 
        ON o.restaurant_id = r.restaurant_id
    GROUP BY r.restaurant_id, r.name
)

SELECT *
FROM revenue
WHERE total_revenue = (
    SELECT MAX(total_revenue)
    FROM revenue
);

--11.Ресторан с максимальной выручкой по каждому дню
WITH daily_revenue AS (
    SELECT 
        DATE(order_time) AS day,
        restaurant_id,
        SUM(price) AS revenue
    FROM orders
    GROUP BY DATE(order_time), restaurant_id
)

SELECT dr.*
FROM daily_revenue dr
JOIN (
    SELECT 
        day,
        MAX(revenue) AS max_revenue
    FROM daily_revenue
    GROUP BY day
) m
ON dr.day = m.day AND dr.revenue = m.max_revenue;

--12.Рестораны с количеством заказов выше среднего
WITH restaurant_orders AS (
    SELECT 
        restaurant_id,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY restaurant_id
)

SELECT *
FROM restaurant_orders
WHERE total_orders > (
    SELECT AVG(total_orders)
    FROM restaurant_orders
);
