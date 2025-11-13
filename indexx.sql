CREATE DATABASE INDEXING;

USE INDEXING;
SHOW TABLES;
  
  -- 1.FIND THE TOTAL REVENUE GENERATED 
  SELECT 
    SUM(Sales) AS Total_Revenue
FROM 
    SUPERSTORE;
    
    -- 2. FIND THE SEGMENT WISE DISTRIBUTION OF THE SALES
    SELECT 
    Segment,
    SUM(Sales) AS Total_Sales
FROM 
    SUPERSTORE
GROUP BY 
    Segment
ORDER BY 
    Total_Sales DESC;

-- 3. FIND THE TOP 3 MOST PROFITABLE PRODUCT
SELECT 
    'Product NAME',
    SUM(Profit) AS Total_Profit
FROM 
    SUPERSTORE
GROUP BY 
   'Product NAME'
ORDER BY 
    Total_Profit DESC
LIMIT 3;

-- 4. HOW MANY ORDERS ARE PLACED AFTER JANUARY 2016
SELECT 
    COUNT(DISTINCT 'Order ID') AS Orders_After_Jan_2016
FROM 
   SUPERSTORE
WHERE 
    'Order Date' > '2016-01-31';

-- 5. HOW MANY STATES FROM MEXICO ARE UNDER THE ROOF OF BUSNIESS
SELECT 
    COUNT(DISTINCT State) AS Total_States
FROM 
    SUPERSTORE
WHERE 
    Country = 'AUSTRIA';

-- 6. WHICH PRODUCT AND SUBCATEGORIES ARE MOST AND LEAST PROFITABLE

(SELECT 
    `Product Name`, `Sub-Category`,
    SUM(Profit) AS Total_Profit
FROM 
    SUPERSTORE
GROUP BY 
    `Product Name`, `Sub-Category`
ORDER BY 
    Total_Profit DESC
LIMIT 1)
union all
(
SELECT 
    `Product Name`, `Sub-Category`,
    SUM(Profit) AS Total_Profit
FROM 
    SUPERSTORE
GROUP BY 
    `Product Name`, `Sub-Category`
ORDER BY 
    Total_Profit ASC
LIMIT 1);


-- 7. WHICH CUSTOMER SEGMENT CONTRIBUTE THE MOST TO THE TOTAL REVENUE
SELECT 
    Segment,
    SUM(Sales) AS Total_Revenue
FROM 
    SUPERSTORE
GROUP BY 
    Segment
ORDER BY 
    Total_Revenue DESC
LIMIT 1;

-- 8. What is the year-over-year growth in sales and Profit?
SELECT 
    YEAR('Order Date') as year ,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(
        (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY YEAR('Order Date'))) 
         * 1000, 2
    ) AS Sales_Growth_Percent,
    ROUND(
        (SUM(Profit) - LAG(SUM(Profit)) OVER (ORDER BY YEAR('Order Date'))) 
        / NULLIF(LAG(SUM(Profit)) OVER (ORDER BY YEAR('Order Date')), 2) * 1000, 2
    ) AS Profit_Growth_Percent
FROM superstore
GROUP BY YEAR('Order Date')
ORDER BY Year('Order Date');

   -- 9. Which countries and cities are driving the highest sales?
SELECT 
    Country,
    City,
    SUM(Sales) AS Total_Sales
FROM 
    superstore
GROUP BY 
    Country, City
ORDER BY 
    Total_Sales DESC;
    
-- 10. What is the average delivery time from order to ship date across regions?
SELECT 
    Region,
    ROUND(AVG(DATEDIFF('Ship Date', 'Order Date')), 2) AS Avg_Day
FROM 
    SUPERSTORE
GROUP BY 
    Region
ORDER BY 
    Avg_Day ASC;
    
-- 11. what is the profit distribution across order priority?
SELECT 
    `Order Priority`,
    SUM(Profit) AS Total_Profit,
    ROUND(AVG(Profit), 2) AS Avg_Profit,
    ROUND(SUM(Profit) * 100.0 / (SELECT SUM(Profit) FROM SUPERSTORE), 2) AS Percentage
FROM 
    SUPERSTORE
GROUP BY 
   `Order Priority`
ORDER BY 
    Total_Profit DESC;
    
    -- 12. Suggest data-driven recommendations for improving profit and reducing losses.
    SELECT 
    `Category`,
    `Sub-Category`,
    `Product Name`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Discount) AS Avg_Discount
FROM superstore
GROUP BY `Category`,
    `Sub-Category`,
    `Product Name`
HAVING SUM(Profit) < 5 OR SUM(Profit) < 5.05 * SUM(Sales)
ORDER BY Total_Profit ASC;


