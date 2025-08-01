SELECT * FROM coffee_sales;

-- Total Sales
SELECT ROUND(SUM( unit_price * transaction_qty)) AS Total_Sales
FROM coffee_sales
WHERE MONTH(transaction_date)= 5;  -- may month

SELECT 
	MONTH(transaction_date) as month,          -- no of month
	ROUND(SUM( unit_price * transaction_qty)) AS Total_Sales,           -- total sales
	(SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty),1)    -- month sales difference 
	OVER (ORDER BY MONTH(transaction_date))) / LAG (SUM(unit_price * transaction_qty),1)      -- division by previous month sales
	OVER(ORDER BY MONTH(transaction_date)) * 100 as mom_increase_percent           -- percentage
FROM coffee_sales
WHERE MONTH(transaction_date) IN (4,5)    -- for month of April(PM) and May(CM) 
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- Total Orders
SELECT COUNT(transaction_id) Total_Orders
FROM coffee_sales
WHERE MONTH(transaction_date) = 5;

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- Total Qty Sold
SELECT SUM(transaction_qty) as Total_Qty_Sold
FROM coffee_sales
WHERE MONTH(transaction_date) = 5;
    
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS Total_Qty_Sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


-- Calender(Total Sales, Orders, Qty Sold)
SELECT 
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1), 'K') Total_Sales,
    CONCAT(ROUND(SUM(transaction_qty)/1000,1), 'K') Total_Qty_Sold,
    CONCAT(ROUND(COUNT(transaction_id)/1000,1), 'K') Total_Orders
FROM coffee_sales
WHERE transaction_date = '2023-05-18';   -- for 18 May 2023


-- Sales on Weekdays and Weekends
-- Weekend - Sat and Sun
-- Weekday - Mon to Fri
-- Sun = 1 and so on 


SELECT
	CASE WHEN dayofweek(transaction_date) IN (1,7) THEN 'Weekend'
	ELSE 'Weekday'
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1), 'K') Total_Sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 2
GROUP BY 
	CASE WHEN dayofweek(transaction_date) IN (1,7) THEN 'Weekend'
	ELSE 'Weekday'
    END;

SELECT * FROM coffee_sales;


-- Sales by Store Location

SELECT store_location,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2), 'K') Total_Sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
GROUP BY store_location
ORDER BY SUM(unit_price * transaction_qty) desc;


-- Sales Trend Over Period

SELECT 
	CONCAT(ROUND(AVG(Total_Sales)/1000,1), 'K') Avg_Sales
FROM (
	SELECT 
    SUM(unit_price * transaction_qty) Total_Sales
    FROM coffee_sales
    WHERE MONTH(transaction_date) = 5
    GROUP BY transaction_date
    ) Internal_Query;


-- Daily Sales For Particular Month

SELECT 
	DAY(transaction_date) Day_of_Month,
    ROUND(SUM(unit_price * transaction_qty)) Total_Sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
GROUP BY transaction_date
ORDER BY transaction_date;


-- COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESS THAN “BELOW AVERAGE”

SELECT 
	day_of_month,
	CASE 
		WHEN total_sales > avg_sales THEN 'Above Average'
		WHEN total_sales < avg_sales THEN 'Below Average'
		ELSE 'Average'
	END AS sales_status,
	total_sales
FROM (
	SELECT 
		DAY(transaction_date) day_of_month,
        ROUND(SUM(unit_price * transaction_qty)) total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER() avg_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
GROUP BY DAY(transaction_date)
) sales_data
ORDER BY day_of_month;


-- Sales by Product Category
SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) total_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) desc;

-- Top 10 Products by Sales
SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) total_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) desc
LIMIT 10;

SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) total_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5 AND product_category = 'Coffee'
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) desc
LIMIT 10;


-- Sales by Days and Hours

SELECT 
	SUM(unit_price * transaction_qty) total_sales,
    SUM(transaction_qty) total_qty_sold,
    COUNT(*)
FROM coffee_sales
WHERE MONTH(transaction_date) = 5   -- May
AND dayofweek(transaction_date) = 1 -- Sun
AND HOUR(transaction_time) = 14;    -- Hour no 14


SELECT 
	HOUR(transaction_time) hour_of_day,
    SUM(unit_price * transaction_qty) total_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
GROUP BY HOUR(transaction_time)
ORDER BY HOUR(transaction_time);


SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
		WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;








