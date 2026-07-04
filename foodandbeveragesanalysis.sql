/*
DISCLAIMER:  
This analysis is for practice and educational purposes only.  
It does not represent or reflect any real company or organization.  
The dataset is used solely for learning SQL.  
*/


USE foodandbeveragesanalysis;

CREATE TABLE product
(
	ID INT NOT NULL,
	ProductName VARCHAR(50) NOT NULL,
	ProductGroup VARCHAR(50) NOT NULL,
	ProductCategory VARCHAR(50) NOT NULL,
	Unit_Price DECIMAL(8,2) NOT NULL,
    PRIMARY KEY(ID)
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/billy/Desktop/DataSets/foodandbeveragesdataset/DSA Food and Beverage Dataset 2022-2023.xlsx - Product.csv'
INTO TABLE  product	
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE salesdata 
(
    id INT NOT NULL,
    OrderDate DATE NOT NULL,
    OrderNumber INT NOT NULL,
    ProductKey INT NOT NULL,
    SalespersonKey INT NOT NULL,
    Salesperson VARCHAR(50) NOT NULL,
    Supervisor VARCHAR(50) NOT NULL,
    Manager VARCHAR(50) NOT NULL,
    `Channel` VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(8,2) NOT NULL,
    PRIMARY KEY(id)
);


LOAD DATA LOCAL INFILE 'C:/Users/billy/Desktop/DataSets/foodandbeveragesdataset/DSA Food and Beverage Dataset 2022-2023.csv'
INTO TABLE  salesdata	
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- 1 What is the total revenue across all sales?
-- 2 What is the total quantity sold by product?
-- 3 What are the top 5 best-selling products by revenue?
-- 4 Which product category contributes the most to revenue?
-- 5 What is the monthly sales trend over 2022–2023?
-- 6 Which salesperson generated the highest revenue?
-- 7 What is the average order value per salesperson?
-- 8 Which supervisor’s team generated the most revenue?
-- 9 Who are the top 3 managers by total sales under them?
-- 10 What is the average unit price by product group?
-- 11 Which products are low-performing (low sales + low revenue)?
-- 12 What is the revenue split by sales channel (Channel)?
-- 13 Which product categories are most popular in each sales channel?
-- 14 What is the peak sales month in each year?
-- 15 Compare weekday vs weekend sales — where is revenue higher?
-- 16 What is the year-over-year growth in revenue between 2022 and 2023?
-- 17 Find the top-selling product in each product category.
-- 18 Which product has the highest average transaction value
-- 19 Calculate total profit contribution by product group (assuming UnitPrice ≈ sales price).
-- 20 Rank store channels by revenue contribution.
-- 21 What is the highest single transaction value (Quantity × UnitPrice)?
-- 22 Which product had the largest price variation (max - min UnitPrice)?
-- 23 What percentage of total revenue comes from the top 10% of products?
-- 24 Find the cumulative revenue growth month-over-month.
-- 25 Show the top 5 days with the highest sales revenue.
-- 26 Which product category has the highest average unit price?
-- 27 What is the best-selling product in each product group?
-- 28 Find the product that is consistently sold every month (never missed a month).
-- 29 Which products were sold in 2022 but not in 2023?
-- 30 Identify products that have declining sales trend year-over-year.
-- 31 Which salesperson has the highest average order size?
-- 32 Rank supervisors by the performance of their teams (total sales).
-- 33 Which manager oversees the highest revenue-generating products?
-- 34 Find salespeople who sold more than the average revenue of all salespeople.
-- 35 Calculate the contribution percentage of each salesperson to their supervisor’s total sales.
-- 36 Which quarter of the year generates the most revenue?
-- 37 Find the busiest day of the week for sales (e.g., Monday, Tuesday).
-- 38 What percentage of sales comes from December (holiday season)?
-- 39 Compare first half (Jan–Jun) vs second half (Jul–Dec) of the year.
-- 40  Find the growth rate of sales for each month compared to the previous month.
-- 41 Create a ranking of products by revenue contribution (RANK window function).


-- 1 What is the total revenue across all sales?
SELECT
	SUM(quantity * UnitPrice) AS total_sales
FROM salesdata;

-- 2 What is the total quantity sold by product?
SELECT 
	p.id,
    p.productName,
    SUM(Quantity) AS total_quantity
FROM salesdata sd
JOIN product p
	ON sd.productkey = p.id
GROUP BY 
	p.productName,
    p.id
ORDER BY total_quantity DESC;

-- 3 What are the top 5 best-selling products by revenue?
SELECT 
	p.id,
    p.productName,
    SUM(Quantity * unitPrice) AS total_revenue
FROM salesdata sd
JOIN product p
	ON sd.productkey = p.id
GROUP BY 
	p.id,
    p.productName
ORDER BY total_revenue DESC
LIMIT 5;

-- 4 Which product category contributes the most to revenue?
SELECT 
    p.productCategory,
    SUM(Quantity * unitPrice) AS total_revenue
FROM salesdata sd
JOIN product p
	ON sd.productkey = p.id
GROUP BY 
	p.productCategory;

-- 5 What is the monthly sales trend over 2022–2023?
SELECT
	YEAR(OrderDate) AS year,
    MONTH(orderdate) AS monthNum,
    MONTHNAME(orderdate) AS monthname,
    SUM(Quantity * unitPrice) AS total_revenue
FROM salesdata
GROUP BY
	YEAR(OrderDate),
    MONTH(orderdate),
    MONTHNAME(orderdate)
ORDER BY
	YEAR(OrderDate),
    MONTH(orderdate);

-- 6 Which salesperson generated the highest revenue?
SELECT
	Salesperson,
    SUM(quantity * unitPrice) AS total_revenue
FROM salesdata
GROUP BY salesperson
ORDER BY total_revenue DESC;

-- 7 What is the average order value per salesperson?
SELECT
	Salesperson,
    AVG(quantity) AS avg_quantity
FROM salesdata
GROUP BY salesperson
ORDER BY avg_quantity DESC;

-- 8 Which supervisor’s team generated the most revenue?
SELECT 
	supervisor,
    SUM(quantity * UnitPrice) AS total_revenue
FROM salesdata
GROUP BY supervisor
ORDER BY total_revenue DESC;

-- 9 Who are the top 3 managers by total sales under them?
SELECT 
    Manager,
    SUM(Quantity * UnitPrice) AS total_sales
FROM salesdata
GROUP BY Manager
ORDER BY total_sales DESC
LIMIT 3;

-- 10 What is the average unit price by product group?
SELECT 
	sd.productkey,
    productname,
    AVG(unit_price) AS avg_unitprice
FROM salesdata sd
JOIN product p
	ON sd.productkey = p.ID
GROUP BY 
	sd.productkey,
    productname;
    
-- 11 Which products are low-performing (low sales + low revenue)?
SELECT 
	sd.productkey,
    productname,
   SUM(unitprice * quantity) AS total_sales
FROM salesdata sd
JOIN product p
	ON sd.productkey = p.ID
GROUP BY 
	sd.productkey,
    productname
ORDER BY total_sales ASC
LIMIT 1;

-- 12 What is the revenue split by sales channel (Channel)?
SELECT
	channel,
    SUM(unitprice * quantity) AS total_sales
FROM salesdata
GROUP BY channel;

-- 13 Which product categories are most popular in each sales channel?

-- 14 What is the peak sales month in each year?
SELECT
	YEAR(orderdate) AS yearDate,
	MONTH(orderdate) AS monthnum,
    MONTHNAME(orderdate) AS month_name,
    SUM(unitprice * quantity) AS total_Sales
FROM salesdata
GROUP BY 
	YEAR(orderdate),
	MONTH(orderdate),
    MONTHNAME(orderdate);

-- 15 Compare weekday vs weekend sales — where is revenue higher?
SELECT 
    CASE 
        WHEN DAYOFWEEK(orderdate) IN (1,7) THEN 'Weekend' 
        ELSE 'Weekday'
    END AS day_type,
    SUM(unitprice * quantity) AS total_revenue
FROM salesdata
GROUP BY day_type
ORDER BY total_revenue DESC;

-- 16 What is the year-over-year growth in revenue between 2022 and 2023?
WITH yearly_revenue AS (
    SELECT 
        YEAR(orderdate) AS year,
        SUM(quantity * unitprice) AS total_revenue
    FROM salesdata
    WHERE YEAR(orderdate)IN (2022, 2023)
    GROUP BY YEAR(orderdate)
)
SELECT 
    MAX(CASE WHEN year = 2022 THEN total_revenue END) AS revenue_2022,
    MAX(CASE WHEN year = 2023 THEN total_revenue END) AS revenue_2023,
    ROUND(
        (
            (MAX(CASE WHEN year = 2023 THEN total_revenue END) - 
             MAX(CASE WHEN year = 2022 THEN total_revenue END))
            / MAX(CASE WHEN year = 2022 THEN total_revenue END)
        ) * 100, 2
    ) AS yoy_growth_percent
FROM yearly_revenue;


-- 17 Find the top-selling product in each product category.
WITH product_sales AS (
    SELECT 
        p.ProductCategory,
        p.ProductName,
        SUM(s.Quantity * s.UnitPrice) AS total_revenue
    FROM salesdata s
    JOIN product p 
        ON s.ProductKey = p.ID
    GROUP BY
		p.ProductCategory,
        p.ProductName
),
ranked_products AS (
    SELECT 
        ProductCategory,
        ProductName,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY ProductCategory
            ORDER BY total_revenue DESC
        ) AS rn
    FROM product_sales
)
SELECT 
    ProductCategory,
    ProductName AS top_product,
    total_revenue
FROM ranked_products
WHERE rn = 1
ORDER BY total_revenue DESC;


-- 18 Which product has the highest average transaction value
SELECT 
    p.ProductName,
    p.ProductCategory,
    ROUND(AVG(s.Quantity * s.UnitPrice), 2) AS avg_transaction_value
FROM salesdata s
JOIN product p 
    ON s.ProductKey = p.ID
GROUP BY p.ProductName, p.ProductCategory
ORDER BY avg_transaction_value DESC
LIMIT 1;

-- 19 Rank store channels by revenue contribution.
SELECT 
    Channel,
    SUM(Quantity * UnitPrice) AS total_revenue,
    ROUND(
        100 * SUM(Quantity * UnitPrice) / SUM(SUM(Quantity * UnitPrice)) OVER (),  2) AS revenue_pct,
    RANK() OVER (ORDER BY SUM(Quantity * UnitPrice) DESC) AS channel_rank
FROM salesdata 
GROUP BY Channel
ORDER BY total_revenue DESC;

-- 21 What is the highest single transaction value (Quantity × UnitPrice)?
SELECT
	id,
    orderdate,
    ordernumber,
	SUM(quantity * unitprice) AS total_sale
FROM salesdata
GROUP BY
	id,
    orderdate,
    ordernumber
ORDER BY total_sale DESC
LIMIT 1;

-- 22 Which product had the largest price variation (max - min UnitPrice)?
SELECT 
    p.ProductName,
    p.ProductCategory,
    MAX(s.UnitPrice) AS max_price,
    MIN(s.UnitPrice) AS min_price,
    (MAX(s.UnitPrice) - MIN(s.UnitPrice)) AS price_variation
FROM salesdata s
JOIN product p 
    ON s.ProductKey = p.ID
GROUP BY p.ProductName, p.ProductCategory
ORDER BY price_variation DESC
LIMIT 1;
   
-- 23 What percentage of total revenue comes from the top 10% of products?
WITH product_revenue AS (
    SELECT 
        p.ID,
        p.ProductName,
        SUM(sd.Quantity * sd.UnitPrice) AS total_revenue
    FROM salesdata sd
    JOIN product p 
        ON sd.ProductKey = p.ID
    GROUP BY p.ID, p.ProductName),
ranked_products AS (
    SELECT 
        pr.*,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS rn,
        COUNT(*) OVER () AS total_products
    FROM product_revenue pr),
top_products AS (
    SELECT *
    FROM ranked_products
    WHERE rn <= total_products * 0.1 )
SELECT 
    ROUND(100 * SUM(total_revenue) / (SELECT SUM(total_revenue) FROM product_revenue), 2) AS percentage_RevTop10PctProducts
FROM top_products;

-- 24 Find the cumulative revenue growth month-over-month.
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(OrderDate, '%Y-%m') AS month,
        SUM(Quantity * UnitPrice) AS revenue
    FROM salesdata
    GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
    ORDER BY month
),
revenue_withGrowth AS (
    SELECT 
        month,
        revenue,
        SUM(revenue) OVER (ORDER BY month) AS cumulative_revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly_revenue
)
SELECT 
    month,
    revenue,
    cumulative_revenue,
    ROUND(
        ((revenue - prev_revenue) / prev_revenue) * 100, 2
    ) AS mom_growthPercentage
FROM revenue_withGrowth;

-- 25 Show the top 5 days with the highest sales revenue.
SELECT 
    OrderDate,
    SUM(Quantity * UnitPrice) AS total_revenue
FROM salesdata
GROUP BY OrderDate
ORDER BY total_revenue DESC
LIMIT 5;

-- 26 Which product category has the highest average unit price?
SELECT 
    p.ProductCategory,
    ROUND(AVG(sd.UnitPrice), 2) AS avg_unitPrice
FROM salesdata sd
JOIN product p 
    ON sd.ProductKey = p.ID
GROUP BY p.ProductCategory
ORDER BY avg_unitPrice DESC
LIMIT 1;

-- 27 What is the best-selling product in each product group?
WITH product_sales AS (
    SELECT 
        p.ProductGroup,
        p.ProductName,
        SUM(sd.Quantity * sd.UnitPrice) AS total_revenue
    FROM salesdata sd
    JOIN product p 
        ON sd.ProductKey = p.ID
    GROUP BY p.ProductGroup, p.ProductName
),
ranked_products AS (
    SELECT 
        ProductGroup,
        ProductName,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY ProductGroup
            ORDER BY total_revenue DESC
        ) AS ranked
    FROM product_sales
)
SELECT 
    ProductGroup,
    ProductName AS best_sellingProduct,
    total_revenue
FROM ranked_products
WHERE ranked = 1
ORDER BY total_revenue DESC;

-- 28 Find the product that is consistently sold every month (never missed a month).
WITH total_months AS (
    SELECT COUNT(DISTINCT DATE_FORMAT(OrderDate, '%Y-%m')) AS month_count
    FROM salesdata),
product_months AS (
    SELECT 
        p.ProductName,
        COUNT(DISTINCT DATE_FORMAT(sd.OrderDate, '%Y-%m')) AS months_sold
    FROM salesdata sd
    JOIN product p 
        ON sd.ProductKey = p.ID
    GROUP BY p.ProductName)
SELECT 
    pm.ProductName
FROM product_months pm
JOIN total_months tm 
    ON pm.months_sold = tm.month_count;

-- 29 Which products were sold in 2022 but not in 2023?
WITH products_2022 AS (
    SELECT 
		DISTINCT p.ID,
		p.ProductName
    FROM salesdata sd
    JOIN product p
		ON sd.ProductKey = p.ID
    WHERE YEAR(sd.OrderDate) = 2022),
products_2023 AS (
    SELECT 
		DISTINCT p.ID,
		p.ProductName
    FROM salesdata sd
    JOIN product p 
		ON sd.ProductKey = p.ID
    WHERE YEAR(sd.OrderDate) = 2023)
SELECT 
    p22.ID,
    p22.ProductName
FROM products_2022 p22
LEFT JOIN products_2023 p23 
    ON p22.ID = p23.ID
WHERE p23.ID IS NULL;

-- 30 Identify products that have declining sales trend year-over-year.
WITH yearly_revenue AS (
    SELECT 
        p.ID,
        p.ProductName,
        YEAR(s.OrderDate) AS sales_year,
        SUM(s.Quantity * s.UnitPrice) AS revenue
    FROM salesdata s
    JOIN product p ON s.ProductKey = p.ID
    GROUP BY p.ID, p.ProductName, YEAR(s.OrderDate)),
pivoted AS (
    SELECT 
        ID,
        ProductName,
        MAX(CASE WHEN sales_year = 2022 THEN revenue END) AS revenue_2022,
        MAX(CASE WHEN sales_year = 2023 THEN revenue END) AS revenue_2023
    FROM yearly_revenue
    GROUP BY ID, ProductName)
SELECT 
    ProductName,
    revenue_2022,
    revenue_2023,
    ROUND(((revenue_2023 - revenue_2022) / revenue_2022) * 100, 2) AS yoy_growthPercentage
FROM pivoted
WHERE revenue_2023 < revenue_2022
ORDER BY yoy_growthPercentage ASC;

-- 31 Which salesperson has the highest average order size?
WITH order_totals AS (
    SELECT 
        sd.Salesperson,
        sd.OrderNumber,
        SUM(sd.Quantity * sd.UnitPrice) AS order_value
    FROM salesdata sd
    GROUP BY
		sd.Salesperson,
		sd.OrderNumber)
SELECT 
    Salesperson,
    ROUND(AVG(order_value), 2) AS avg_orderSize
FROM order_totals
GROUP BY Salesperson
ORDER BY avg_orderSize DESC
LIMIT 1;

-- 32 Rank supervisors by the performance of their teams (total sales).
SELECT 
    Supervisor,
    SUM(Quantity * UnitPrice) AS total_sales,
    RANK() OVER (ORDER BY SUM(Quantity * UnitPrice) DESC) AS supervisor_rank
FROM salesdata
GROUP BY Supervisor
ORDER BY total_sales DESC;

-- 33 Which manager oversees the highest revenue-generating products?
WITH product_revenue AS (
    SELECT 
        p.ID,
        p.ProductName,
        sd.Manager,
        SUM(sd.Quantity * sd.UnitPrice) AS total_revenue
    FROM salesdata sd
    JOIN product p 
		ON sd.ProductKey = p.ID
    GROUP BY
		p.ID,
        p.ProductName,
        sd.Manager),
ranked_products AS (
    SELECT 
        ProductName,
        Manager,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS product_rank
    FROM product_revenue)
SELECT 
    Manager,
    ProductName,
    total_revenue
FROM ranked_products
WHERE product_rank = 1;


-- 34 Find salespeople who sold more than the average revenue of all salespeople.
WITH salesperson_revenue AS (
    SELECT 
        Salesperson,
        SUM(Quantity * UnitPrice) AS total_revenue
    FROM salesdata
    GROUP BY Salesperson),
avg_revenue AS (
    SELECT AVG(total_revenue) AS avg_salesPersonRevenue
    FROM salesperson_revenue)
SELECT 
    sr.Salesperson,
    sr.total_revenue
FROM salesperson_revenue sr
CROSS JOIN avg_revenue ar
WHERE sr.total_revenue > ar.avg_salesPersonRevenue
ORDER BY sr.total_revenue DESC;

-- 35 Calculate the contribution percentage of each salesperson to their supervisor’s total sales.
WITH salesperson_sales AS (
    SELECT 
        Supervisor,
        Salesperson,
        SUM(Quantity * UnitPrice) AS total_revenue
    FROM salesdata
    GROUP BY 
		Supervisor,
		Salesperson),
supervisor_totals AS (
    SELECT 
        Supervisor,
        SUM(total_revenue) AS supervisor_total
    FROM salesperson_sales
    GROUP BY Supervisor)
SELECT 
    ss.Supervisor,
    ss.Salesperson,
    ss.total_revenue,
    st.supervisor_total,
    ROUND(100 * ss.total_revenue / st.supervisor_total, 2) AS contribution_percentage
FROM salesperson_sales ss
JOIN supervisor_totals st 
    ON ss.Supervisor = st.Supervisor
ORDER BY
	ss.Supervisor,
    contribution_percentage DESC;

-- 36 Which quarter of the year generates the most revenue?
SELECT 
    YEAR(OrderDate) AS sales_year,
    QUARTER(OrderDate) AS sales_quarter,
    SUM(Quantity * UnitPrice) AS total_revenue
FROM salesdata
GROUP BY YEAR(OrderDate), QUARTER(OrderDate)
ORDER BY total_revenue DESC
LIMIT 1;

-- 37 Find the busiest day of the week for sales (e.g., Monday, Tuesday).
SELECT 
    DAYNAME(OrderDate) AS day_of_week,
    SUM(Quantity * UnitPrice) AS total_revenue
FROM salesdata
GROUP BY DAYOFWEEK(OrderDate), DAYNAME(OrderDate)
ORDER BY total_revenue DESC
LIMIT 1;

-- 38 What percentage of sales comes from December (holiday season)?
WITH total_revenue AS (
    SELECT SUM(Quantity * UnitPrice) AS total_sales
    FROM salesdata),
december_revenue AS (
    SELECT SUM(Quantity * UnitPrice) AS dec_sales
    FROM salesdata
    WHERE MONTH(OrderDate) = 12)
SELECT 
    dr.dec_sales,
    tr.total_sales,
    ROUND(100 * dr.dec_sales / tr.total_sales, 2) AS dec_salesPercentage
FROM december_revenue dr
CROSS JOIN total_revenue tr;

-- 39 Compare first half (Jan–Jun) vs second half (Jul–Dec) of the year.
SELECT 
    YEAR(OrderDate) AS sales_year,
    CASE 
        WHEN MONTH(OrderDate) BETWEEN 1 AND 6 THEN 'First Half (Jan-Jun)'
        ELSE 'Second Half (Jul-Dec)'
    END AS half_ofYear,
    SUM(Quantity * UnitPrice) AS total_revenue
FROM salesdata
GROUP BY
	YEAR(OrderDate),
    half_ofYear
ORDER BY
	sales_year, 
    half_ofYear;

-- 40  Find the growth rate of sales for each month compared to the previous month.
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(OrderDate, '%Y-%m') AS month,
        SUM(Quantity * UnitPrice) AS revenue
    FROM salesdata
    GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
    ORDER BY month
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) 
            / LAG(revenue) OVER (ORDER BY month)) * 100, 2) AS growth_ratePercentage
FROM monthly_revenue;


-- 41 Create a ranking of products by revenue contribution (RANK window function).
SELECT 
    p.ProductName,
    p.ProductCategory,
    SUM(s.Quantity * s.UnitPrice) AS total_revenue,
    RANK() OVER (ORDER BY SUM(s.Quantity * s.UnitPrice) DESC) AS revenue_rank
FROM salesdata s
JOIN product p 
    ON s.ProductKey = p.ID
GROUP BY
	p.ProductName,
    p.ProductCategory
ORDER BY total_revenue DESC;

/*
DISCLAIMER:  
This analysis is for practice and educational purposes only.  
It does not represent or reflect any real company or organization.  
The dataset is used solely for learning SQL.  
*/
