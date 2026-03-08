USE pizza_sales;
GO
SELECT * FROM pizza_sales;

-- 1. Total Revenue
CREATE OR ALTER VIEW dbo.v_total_revenue AS
SELECT SUM(total_price) AS total_revenue
FROM dbo.pizza_sales;
GO

-- 2. Average Order Value
CREATE OR ALTER VIEW dbo.v_average_order_value AS
SELECT SUM(total_price) * 1.0 / COUNT(DISTINCT order_id) AS Average_order_value
FROM dbo.pizza_sales;
GO

-- 3. Total Pizza Sold
CREATE OR ALTER VIEW dbo.v_total_pizza_sold AS
SELECT SUM(quantity) AS total_pizza_sold
FROM dbo.pizza_sales;
GO

-- 4. Total Orders
CREATE OR ALTER VIEW dbo.v_total_orders AS
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM dbo.pizza_sales;
GO

-- 5. Average Pizza per Order
CREATE OR ALTER VIEW dbo.v_avg_pizza_per_order AS
SELECT CAST(SUM(quantity) * 1.0 / COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS Avg_Pizzas_Per_Order
FROM dbo.pizza_sales;
GO

-- 6. Daily Trend for Total Orders
CREATE OR ALTER VIEW dbo.v_daily_trend_for_total_orders AS
SELECT DATENAME(WEEKDAY, order_date) AS order_day,
       COUNT(DISTINCT order_id) AS total_orders
FROM dbo.pizza_sales
GROUP BY DATENAME(WEEKDAY, order_date);
GO

-- 7. Monthly Trend for Orders
CREATE OR ALTER VIEW dbo.v_monthly_trend_for_orders AS
SELECT DATENAME(MONTH, order_date) AS Month_name,
       COUNT(DISTINCT order_id) AS total_orders
FROM dbo.pizza_sales
GROUP BY DATENAME(MONTH, order_date);
GO

-- 8. % of Sales by Pizza Category
CREATE OR ALTER VIEW dbo.v_pct_sales_by_pizza_category AS
SELECT pizza_category,
       ROUND(SUM(total_price), 2) AS total_revenue,
       ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM dbo.pizza_sales), 2) AS pct
FROM dbo.pizza_sales
GROUP BY pizza_category;
GO

-- 9. % of Sales by Pizza Size
CREATE OR ALTER VIEW dbo.v_pct_sales_by_pizza_size AS
SELECT pizza_size,
       ROUND(SUM(total_price), 2) AS total_revenue,
       ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM dbo.pizza_sales), 2) AS pct
FROM dbo.pizza_sales
GROUP BY pizza_size;
GO

-- 10. Total Pizzas Sold by Category
CREATE OR ALTER VIEW dbo.v_total_pizzas_sold_by_category AS
SELECT pizza_category,
       SUM(quantity) AS total_quantity_sold
FROM dbo.pizza_sales
GROUP BY pizza_category;
GO

-- 11. Top 5 Pizzas by Revenue
CREATE OR ALTER VIEW dbo.v_top_5_pizzas_by_revenue AS
SELECT TOP 5 pizza_name,
       ROUND(SUM(total_price), 2) AS total_revenue
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC;
GO

-- 12. Bottom 5 Pizzas by Revenue
CREATE OR ALTER VIEW dbo.v_bottom_5_pizzas_by_revenue AS
SELECT TOP 5 pizza_name,
       ROUND(SUM(total_price), 2) AS total_revenue
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue ASC;
GO

-- 13. Top 5 Pizzas by Quantity
CREATE OR ALTER VIEW dbo.v_top_5_pizzas_by_quantity AS
SELECT TOP 5 pizza_name,
       SUM(quantity) AS total_pizza_sold
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_pizza_sold DESC;
GO

-- 14. Bottom 5 Pizzas by Quantity
CREATE OR ALTER VIEW dbo.v_bottom_5_pizzas_by_quantity AS
SELECT TOP 5 pizza_name,
       SUM(quantity) AS total_pizza_sold
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_pizza_sold ASC;
GO

-- 15. Top 5 Pizzas by Total Orders
CREATE OR ALTER VIEW dbo.v_top_5_pizzas_by_total_orders AS
SELECT TOP 5 pizza_name,
       COUNT(DISTINCT order_id) AS total_orders
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC;
GO

-- 16. Bottom 5 Pizzas by Total Orders
CREATE OR ALTER VIEW dbo.v_bottom_5_pizzas_by_total_orders AS
SELECT TOP 5 pizza_name,
       COUNT(DISTINCT order_id) AS total_orders
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC;
GO
