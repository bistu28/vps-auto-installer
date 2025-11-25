# Case Study 1 Ecommerce Full

```text
I. CASE STUDY 1
E-commerce Sales Performance Analysis :
Table 1: Schema Details -

SOLUTION-
CREATE DATABASE Ecommerce_sales_case1;
USE Ecommerce_sales_case1;


-- Products Table
CREATE TABLE Products 
( product_id INT PRIMARY KEY, product_name VARCHAR(100), category VARCHAR(100), price DECIMAL(10,2), stock_quantity INT );

-- Customers Table
CREATE TABLE Customers ( customer_id INT PRIMARY KEY, first_name VARCHAR(50), last_name VARCHAR(50),
email VARCHAR(100), city VARCHAR(100),
join_date DATE
);

-- Orders Table
CREATE TABLE Orders (
order_id INT PRIMARY KEY, customer_id INT,
order_date DATE, shipping_cost DECIMAL(10,2), total_amount DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order_Items Table
	CREATE TABLE Order_Items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price DECIMAL,
    FOREIGN KEY(order_id) REFERENCES Orders(order_id),
    FOREIGN KEY(product_id) REFERENCES Products(product_id));

// Inserting values in tables

INSERT INTO Products VALUES 
(1, "Nike Air Max", "Running", 149.99, 50),
(2, "Adidas Ultraboost", "Sports", 179.99, 70),
(3, "Puma Running Pro", "Running", 129.99, 40),
(4, "Reebok Classic", "Casual", 89.99, 60),
(5, "Bata Power", "Walking", 49.99, 100),
(6, "Woodland Trekker", "Hiking", 104.99, 30),
(7, "Skechers GoWalk", "Walking", 119.99, 45),
(8, "Red Chief Leather", "Climbing", 99.99, 80);

INSERT INTO Customers VALUES 
(1, "Bistu", "Paul", "paul@gmail.com", "Silchar", "2023-05-10"),
(2, "Amit", "Sharma", "amit.sharma@example.com", "Delhi", "2022-11-20"),
(3, "Priya", "Nair", "priya.nair@example.com", "Kochi", "2024-02-15"),
(4, "Rohit", "Verma", "rohit.verma@example.com", "Goa", "2023-12-01"),
(5, "Dev", "Patel", "dev@example.com", "Surat", "2021-07-07"),
(6, "Balwinder", "Singh", "bal24@example.com", "Assam", "2024-10-10"),
(7, "Garima", "Das", "garima@example.com", "Kolkata", "2020-03-03"),
(8, "Harsh", "Mehta", "harsh@example.com", "Ahmedabad", "2024-12-01"),
(9, "Isha", "Reddy", "reddy@example.com", "Hyderabad", "2023-08-08"),
(10, "Jay", "Singh", "jay.singh@example.com", "Jaipur", "2022-06-06");
INSERT INTO Orders VALUES 
(1, 1, "2024-11-05", 5.00, 54.98), (2, 2, "2025-03-10", 7.00, 120.00),
(3, 1, "2025-03-20", 5.00, 30.00), (4, 3, "2025-04-15", 6.00, 75.00), 
(5, 5, "2023-12-12", 5.00, 18.50), (6, 7, "2025-01-25", 4.00, 60.00),
(7, 9, "2025-03-05", 3.00, 23.00), (8, 10, "2024-06-20", 5.00, 150.00),
(9, 4, "2022-12-30", 6.00, 45.00), (10, 2, "2025-02-18", 5.00, 200.00),
(11, 5, "2025-06-10", 5.00, 40.00), (12, 1, "2025-07-01", 5.00, 90.00),
(13, 6, "2025-03-12", 4.00, 9.00), (14, 8, "2025-03-12", 6.00, 54.00);

INSERT INTO Order_Items VALUES 
(1, 1, 2, 2, 24.99), (2, 2, 4, 1, 75.00), (3, 2, 6, 3, 3.00), (4, 3, 1, 1, 19.99), (5, 4, 4, 1, 75.00), (6, 5, 5, 2, 8.50), (7, 6, 7, 1, 55.00), (8, 7, 3, 1, 15.00), (9, 8, 2, 5, 29.99), (10, 9, 1, 2, 19.99), (11, 10, 8, 1, 45.00), (12, 11, 6, 2, 3.00), (13, 12, 2, 3, 29.99), (14, 13, 6, 3, 3.00), (15, 14, 1, 2, 19.99);


Q-1 High-Value Customers: Find the customer_id, first_name, and last_name of the top 10 customers who have spent the highest cumulave total_amount.

SELECT c.customer_id, 
c.first_name, 
       c.last_name, 
       SUM(o.total_amount) AS lifetime_spend
FROM Customers c
INNER JOIN Orders o 
        ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_spend DESC
LIMIT 10;



Q-2 	Category Performance: Calculate the total revenue and total quanty sold for each category. Order the results by revenue descending.

SELECT p.category,
       SUM(oi.quantity * oi.unit_price) AS total_revenue,
       SUM(oi.quantity) AS total_quantity_sold
FROM Products p
INNER JOIN Order_Items oi 
        ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;



Q-3	Customer Churn/Lapse: Idenfy the customer_id and last_name of customers who joined before 2024-01-01 but have not placed any orders in the current year (2025).

SELECT c.customer_id, 
       c.last_name
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id 
      AND YEAR(o.order_date) = '2025'
WHERE c.join_date < '2024-01-01' 
  AND o.order_id IS NULL;

Q-4 Stock Analysis: List all product_names that have a stock_quanty less than 50 and have been sold at least once.

SELECT DISTINCT p.product_name
FROM Products p
INNER JOIN Order_Items oi 
        ON p.product_id = oi.product_id
WHERE p.stock_quantity < 50;



Q-5 Average Order Value (AOV): Calculate the Average Order Value (AOV) for all orders placed in the month of 'March 2025'.

SELECT AVG(total_amount) AS AOV_MARCH_2025
FROM Orders
WHERE DATE_FORMAT(order_date, '%Y-%m') = '2025-03';



Q-6 	City Sales Comparison: Determine the city that has the highest average order size (based on the total number of items in an order).

SELECT 
    c.city,
    AVG(oi.total_items) AS avg_order_size
FROM Customers c
JOIN Orders o 
    ON c.customer_id = o.customer_id
JOIN (
    SELECT order_id, SUM(quantity) AS total_items
    FROM Order_Items
    GROUP BY order_id
) oi
    ON o.order_id = oi.order_id
GROUP BY c.city
ORDER BY avg_order_size DESC
LIMIT 1;



Q-7 Price Difference: Find the product_name and the difference between its standard price in the Products table and the average unit_price it was sold for across all Order_Items.

SELECT p.product_name,
       p.price AS standard_price,
       AVG(oi.unit_price) AS avg_sold_price,
       (p.price - AVG(oi.unit_price)) AS price_diff
FROM Products p
LEFT JOIN Order_Items oi 
       ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY price_diff DESC;



Q-8	First Order Date: For each customer, list their customer_id, and the order_date of their very first order. (Hint: Use a window function like ROW_NUMBER() or a subquery with MIN).

SELECT customer_id, 
       MIN(order_date) AS first_order_date
FROM Orders
GROUP BY customer_id;



Q-9 Product Bundle Identification: Find pairs of product_names that have been purchased together (in the same order_id) at least 100 times.

SELECT p1.product_name AS product_a, 
       p2.product_name AS product_b, 
       COUNT(*) AS times_bought_together
FROM Order_Items oi1
INNER JOIN Order_Items oi2 
        ON oi1.order_id = oi2.order_id 
       AND oi1.product_id < oi2.product_id
INNER JOIN Products p1 
        ON oi1.product_id = p1.product_id
INNER JOIN Products p2 
        ON oi2.product_id = p2.product_id
GROUP BY oi1.product_id, oi2.product_id
HAVING COUNT(*) >= 100
ORDER BY times_bought_together DESC;


Q-10 Revenue Growth: Calculate the total monthly revenue and the percentage change in revenue compared to the previous month for the last six months of data.

SELECT 
    c.city,
    AVG(x.total_items) AS avg_order_size
FROM Customers c
JOIN (
    SELECT 
        o.order_id,
        o.customer_id,
        (SELECT SUM(oi.quantity)
         FROM Order_Items oi
         WHERE oi.order_id = o.order_id) AS total_items
    FROM (SELECT * FROM Orders) o
) x
ON c.customer_id = x.customer_id
GROUP BY c.city
ORDER BY avg_order_size DESC
LIMIT 1;
```
