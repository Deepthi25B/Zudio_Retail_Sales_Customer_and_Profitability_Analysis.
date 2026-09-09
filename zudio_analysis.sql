CREATE DATABASE Zudio_analysis;
USE Zudio_analysis;
SELECT COUNT(*) AS Total_Rows
FROM zudio_sales;
SELECT *
FROM zudio_sales
LIMIT 10;
SELECT
    SUM(`Sales revenue`) AS Total_Revenue,
    SUM(`Sales Profit`) AS Total_Profit,
    SUM(Cost) AS Total_Cost,
    SUM(Quantity) AS Total_Quantity
FROM zudio_sales;
SELECT
    Category,
    SUM(`Sales revenue`) AS Total_Revenue,
    SUM(`Sales Profit`) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM zudio_sales
GROUP BY Category
ORDER BY Total_Revenue DESC;
SELECT
    'State',
    SUM(`Sales revenue`) AS Total_Revenue,
    SUM(`Sales Profit`) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM zudio_sales
GROUP BY State
ORDER BY Total_Revenue DESC;
SELECT
    `Store Type`,
    COUNT(*) AS Total_Transactions,
    SUM(Quantity) AS Total_Quantity,
    SUM(`Sales revenue`) AS Total_Revenue,
    SUM(`Sales Profit`) AS Total_Profit,
    AVG(`Sales revenue`) AS Average_Revenue
FROM zudio_sales
GROUP BY `Store Type`
ORDER BY Total_Revenue DESC;
SELECT
    `Clothing Type`,
    SUM(Quantity) AS Total_Quantity,
    SUM(`Sales revenue`) AS Total_Revenue,
    SUM(`Sales Profit`) AS Total_Profit
FROM zudio_sales
GROUP BY `Clothing Type`
ORDER BY Total_Revenue DESC
LIMIT 2;
SELECT
    Month,
    SUM(`Sales revenue`) AS Total_Revenue,
    SUM(`Sales Profit`) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM zudio_sales
GROUP BY Month
ORDER BY Total_Revenue DESC;
--- joins
CREATE TABLE order_summary AS
SELECT
    `Order ID`,
    MIN(`Order Date`) AS Order_Date,
    MIN(`Customer ID`) AS Customer_ID,
    SUM(Quantity) AS Total_Quantity,
    SUM(`Sales revenue`) AS Order_Revenue,
    SUM(`Sales Profit`) AS Order_Profit
FROM zudio_sales
GROUP BY `Order ID`;
SHOW tables;
SELECT COUNT(*) AS Total_Orders
FROM order_summary;
SELECT
    s.`Order ID`,
    s.Category,
    s.`Clothing Type`,
    s.`Sales revenue` AS Line_Revenue,
    o.Order_Revenue,
    o.Order_Profit
FROM zudio_sales s
INNER JOIN order_summary o
    ON s.`Order ID` = o.`Order ID`
LIMIT 20;
--- customer summary
CREATE TABLE customer_summary AS
SELECT
    `Customer ID`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(`Sales revenue`) AS Total_Revenue,
    SUM(`Sales Profit`) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM zudio_sales
GROUP BY `Customer ID`;
SELECT COUNT(*) AS Total_Customers
FROM customer_summary;
---- customer and order summary
SELECT
    c.`Customer ID`,
    c.Total_Orders,
    c.Total_Revenue,
    c.Total_Profit,
    o.`Order ID`,
    o.Order_Revenue,
    o.Order_Profit
FROM customer_summary c
INNER JOIN order_summary o
    ON c.`Customer ID` = o.Customer_ID
LIMIT 20;
---- JOINS AND AGGREGATION
SELECT
    c.`Customer ID`,
    c.Total_Orders,
    SUM(o.Order_Revenue) AS Total_Order_Revenue,
    SUM(o.Order_Profit) AS Total_Order_Profit
FROM customer_summary c
INNER JOIN order_summary o
    ON c.`Customer ID` = o.Customer_ID
GROUP BY
    c.`Customer ID`,
    c.Total_Orders
ORDER BY Total_Order_Revenue DESC
LIMIT 10;
CREATE TABLE product_summary AS
SELECT
    `Product ID`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity,
    SUM(`Sales revenue`) AS Total_Revenue,
    SUM(`Sales Profit`) AS Total_Profit,
    AVG(Price) AS Average_Price
FROM zudio_sales
GROUP BY `Product ID`;
SELECT COUNT(*) AS Total_Products
FROM product_summary;
SELECT
    s.`Product ID`,
    s.Category,
    s.`Clothing Type`,
    s.Quantity,
    s.`Sales revenue`,
    p.Total_Revenue,
    p.Total_Profit
FROM zudio_sales s
INNER JOIN product_summary p
    ON s.`Product ID` = p.`Product ID`
LIMIT 20;
ALTER TABLE order_summary
ADD PRIMARY KEY (`Order ID`);
ALTER TABLE zudio_sales
ADD CONSTRAINT fk_sales_order
FOREIGN KEY (`Order ID`)
REFERENCES order_summary(`Order ID`);
ALTER TABLE customer_summary
ADD PRIMARY KEY (`Customer ID`);
ALTER TABLE order_summary
ADD CONSTRAINT fk_order_customer
FOREIGN KEY (`Customer_ID`)
REFERENCES customer_summary(`Customer ID`);
ALTER TABLE product_summary
ADD PRIMARY KEY (`Product ID`);
ALTER TABLE zudio_sales
ADD CONSTRAINT fk_sales_product
FOREIGN KEY (`Product ID`)
REFERENCES product_summary(`Product ID`);

