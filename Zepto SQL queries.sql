drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

--data exploration

--count of rows
SELECT COUNT(*) FROM ZEPTO;

SELECT * FROM ZEPTO;

--sample data
SELECT * FROM ZEPTO LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name =NULL
OR
category =NULL
OR
mrp =NULL
OR
discountPercent = NULL
OR
discountedSellingPrice = NULL
OR
weightInGms = NULL
OR
availableQuantity = NULL
OR
outOfStock = NULL
OR
quantity = NULL;

--different product categories
SELECT DISTINCT CATEGORY 
FROM ZEPTO 
ORDER BY CATEGORY;

--products in stock vs out of stock
SELECT OUTOFSTOCK ,COUNT(SKU_ID) 
FROM ZEPTO 
GROUP BY OUTOFSTOCK;

--product names present multiple times
SELECT NAME, COUNT(SKU_ID)
FROM ZEPTO
GROUP BY NAME 
HAVING COUNT(SKU_ID) >1
ORDER BY COUNT(SKU_ID) DESC;

--data cleaning
--products with price = 0
SELECT * FROM ZEPTO 
WHERE MRP=0 OR DISCOUNTEDSELLINGPRICE=0;

DELETE FROM ZEPTO WHERE MRP=0;

--convert paise to rupees
UPDATE ZEPTO SET MRP= MRP/100.0,
DISCOUNTEDSELLINGPRICE=DISCOUNTEDSELLINGPRICE/100.0 ;

SELECT mrp, discountedSellingPrice FROM zepto;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT NAME, CATEGORY ,DISCOUNTPERCENT
FROM ZEPTO 
ORDER BY DISCOUNTPERCENT DESC
LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT CATEGORY, SUM(DISCOUNTEDSELLINGPRICE*AVAILABLEQUANTITY)AS TOTAL_REVENUE 
FROM ZEPTO
GROUP BY CATEGORY
ORDER BY TOTAL_REVENUE;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT NAME, MRP, DISCOUNTPERCENT
FROM ZEPTO
WHERE MRP>500 AND DISCOUNTPERCENT<10
ORDER BY MRP DESC,DISCOUNTPERCENT DESC;

UPDATE ZEPTO SET MRP= MRP*100.0,
DISCOUNTEDSELLINGPRICE=DISCOUNTEDSELLINGPRICE*100.0 ;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT CATEGORY , ROUND(AVG(DISCOUNTPERCENT),2) AS AVG_DISCOUNT_PERCENT
FROM ZEPTO 
GROUP BY CATEGORY
ORDER BY AVG_DISCOUNT_PERCENT DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

