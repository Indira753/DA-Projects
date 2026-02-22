SELECT * FROM customers;
SELECT * FROM Orders;
-- 1.	List all customers
SELECT * FROM customers;

-- 2.	List all orders
SELECT * FROM orders;

-- 3.	Find customers from New York
SELECT * FROM customers WHERE city='New York';

-- 4.	Count customers per city
SELECT city,count(customer_id) AS count_cust FROM customers GROUP BY city;

-- 5.	Total revenue generated
SELECT sum(amount) AS Tot_rev FROM orders;

-- 6.	Average order value
SELECT AVG(amount) AS Avg_rev FROM orders;

-- 7.	Total spending per customer
SELECT 
      customer_id,
      sum(amount) AS Tot_amnt 
      FROM orders 
      GROUP BY customer_id;

-- 8.	Customers with no orders
SELECT
	 c.customer_id,
	 c.customer_name,
     o.customer_id,
     o.order_id FROM customers c 
     LEFT JOIN orders o
     ON c.customer_id=o.customer_id 
     WHERE o.customer_id IS NULL;

-- 9.	Orders made in October
SELECT * 
       FROM orders 
       WHERE MONTH(order_date)='10';

-- 10.	Highest order amount
SELECT 
	MAX(amount) AS Max_amnt 
	FROM orders ;

-- 11.	Customers who spent more than 200 total 
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS tot_spent 
    FROM customers c 
LEFT JOIN orders o 
	ON c.customer_id=o.customer_id 
    GROUP BY c.customer_id,c.customer_name 
    HAVING SUM(o.amount)>200;

-- 12.	Number of orders per customer
SELECT 
     c.customer_id,
     c.customer_name,
     count(o.order_id) AS orders_count
     FROM customers c 
LEFT JOIN orders o 
     ON c.customer_id=o.customer_id 
     GROUP BY c.customer_id,c.customer_name;

-- 13.	Orders over $150
SELECT order_id ,amount FROM orders WHERE amount > 150;

-- 14.	First 5 customers by signup date
SELECT 
     customer_id,
     customer_name,
     signup_date 
     FROM customers 
     ORDER BY signup_date LIMIT 5;

--  15.	Last order of each customer
WITH OrderRank AS (
    SELECT customer_id,order_id,amount,
	ROW_NUMBER() 
    OVER (PARTITION BY customer_id ORDER BY order_id) AS rn
    FROM Orders
    )
SELECT * FROM OrderRank WHERE rn = 2;

-- 16.	Join customer + order details
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    c.signup_date,
    o.order_id,
    o.customer_id,
    o.order_date,
    o.amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;
    
-- 17.	Total revenue per city
SELECT 
     c.city,SUM(o.amount) AS total_revenue FROM Customers c
INNER JOIN Orders o 
     ON c.customer_id = o.customer_id GROUP BY c.city;

-- 18.	Customers who joined after July
SELECT 
     customer_id,
     customer_name,
     city,
     signup_date 
     FROM customers
     WHERE MONTH(signup_date)>7;

-- 19.	Monthly order revenue
SELECT 
     MONTH(order_date) AS month_num,
     SUM(amount) 
     FROM orders GROUP BY month_num ; 

-- 20.	Find duplicate city names
SELECT 
     city,
     count(*) AS Dup_city_names
     FROM customers
     GROUP BY city
	 HAVING count(*)>1;

-- 21.	Top 5 highest spending customers
SELECT 
     c.customer_id,
     c.customer_name,
     SUM(o.amount) AS total_spent 
     FROM customers c
     INNER JOIN orders o 
     ON c.customer_id=o.customer_id
     GROUP BY c.customer_id,c.customer_name
     ORDER BY total_spent DESC LIMIT 5;

-- 22.	Orders sorted by amount (descending)
SELECT 
     c.customer_id,
     c.customer_name,
     o.order_id,
     o.amount 
     FROM customers c 
     INNER JOIN orders o 
     ON c.customer_id=o.customer_id 
     ORDER BY o.amount DESC;

-- 23.	Customers and their total number of orders (0 included)
SELECT 
	c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS tot_orders
    FROM customers c 
    LEFT JOIN orders o 
    ON c.customer_id=o.customer_id 
    GROUP BY c.customer_id,c.customer_name;

-- 24.	Rank customers by spending (window function)
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_spent,
    DENSE_RANK() OVER (
        ORDER BY SUM(o.amount) DESC
    ) AS spend_rank
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, 
    c.customer_name
ORDER BY total_spent DESC;



-- 25.	Running total of order amounts (window function)
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.amount,
    SUM(o.amount) OVER(
        ORDER BY o.order_date
    ) AS running_total
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;

