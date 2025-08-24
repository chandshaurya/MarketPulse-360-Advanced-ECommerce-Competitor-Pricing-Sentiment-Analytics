          #### Project -- MarketPulse 360  Advanced ECommerce Competitor, Pricing & Sentiment Analytics


create database marketpulse360;
use marketpulse360;

-- Table Creation

CREATE TABLE customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Gender VARCHAR(10),
    City VARCHAR(255),
    State VARCHAR(255),
    Email VARCHAR(255),
    RegistrationDate DATE,
    LoyaltyTier VARCHAR(50)
);




CREATE TABLE product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    Category VARCHAR(255),
    Brand VARCHAR(50),
    BasePrice DECIMAL(10, 2),
    LaunchDate DATE
);



CREATE TABLE sales (
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    CustomerID INT,
    Date DATE,
    UnitsSold INT,
    Returns INT,
    Discount DECIMAL(3, 2),
    OurPrice DECIMAL(10, 2),
    CompetitorPrice DECIMAL(10, 2),
    Revenue DECIMAL(10, 2),
    AcquisitionChannel VARCHAR(255),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);


CREATE TABLE reviews (
    ProductID INT,
    CustomerID INT,
    ReviewDate DATE,
    Rating INT,
    ReviewText TEXT,
    SentimentScore DECIMAL(5, 4),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);


# Analysis

### Sales & Revenue KPIs

-- Total revenue, total units sold, and overall return rate.

select 
	Sum(Revenue) as Total_Revenue , 
    Sum(UnitsSold) as Total_units , 
    (Sum(Returns)*100)/Sum(UnitsSold) as Return_rate
from sales;

-- Monthly Revenue Trends

Select 
	monthname(Date) as Months , 
    Sum(Revenue)
From sales
group by monthname(Date);

-- Monthly units sold trend

Select 
	monthname(Date) as Months , 
    Sum(UnitsSold)
From sales
group by monthname(Date);

-- Top 10 revenue days.

Select 
	Date , 
    Sum(Revenue) as Revenues
From sales
group by Date
Order By 
	Revenues desc
Limit 10;

-- Average order value 

select 
	avg(Revenue/UnitsSold) as Avg_order_value
from sales;

-- Total Values of discounts given

WITH categorized_sales AS (
  SELECT 
    CASE 
      WHEN Discount < 0.05 THEN '0-5%'
      WHEN Discount BETWEEN 0.05 AND 0.10 THEN '5-10%'
      WHEN Discount BETWEEN 0.10 AND 0.15 THEN '10-15%'
      WHEN Discount BETWEEN 0.15 AND 0.20 THEN '15-20%'
      ELSE '>20%'
    END AS Discounts,
    Revenue
  FROM sales
)
SELECT Discounts, SUM(Revenue) AS Revenue
FROM categorized_sales
GROUP BY Discounts
order by Discounts desc
;

-- Revenue by acquisition channel

select 
	AcquisitionChannel, 
    sum(Revenue)
From sales
group by AcquisitionChannel;





### Customer & Demographic Analysis

-- Unique customers with purchases

Select 
	count(Distinct CustomerID) as Customers
from sales
where ProductID>0;

-- Customer count by state

Select 
	State, 
    count(CustomerID) as Customers
From customers
group by State
Order by count(CustomerID);

-- Top 10 cities by customer count

Select 
	City , 
    count(CustomerID) as Customers
From customers
group by City
Order by 
	count(CustomerID) Desc
Limit 10;

-- New customers per month

Select 
	monthname(RegistrationDate) as Month , 
    count(CustomerID) as Customers
From customers
group by Month;

-- Revenue & average spend by gender

Select 
	Gender, 
    Sum(Revenue) as Revenue , 
    Avg(Revenue) as average_spend
From customers as c
join sales as s 
on c.CustomerID = s.CustomerID
group by Gender;

-- Revenue share by loyalty tier

select 
	LoyaltyTier , 
    sum(Revenue) as Revenue
from customers as c
Join sales as s
on c.CustomerID = s.CustomerID
group by LoyaltyTier;

-- Top 10 spenders

select 
	Name , 
    sum(Revenue) as Revenue
from customers as c
Join sales as s
on c.CustomerID = s.CustomerID
group by Name 
Order by 
	sum(Revenue) Desc
Limit 10;

-- Most effective acquisition channel for new customers

Select 
	AcquisitionChannel, 
    count( Distinct c.CustomerID) as customers
from customers as c
Join sales as s
on c.CustomerID = s.CustomerID
group by AcquisitionChannel
order by 
	count(c.CustomerID) Desc;

-- Cohort retention: Percentage of customers returning in later months after first purchase.

WITH purchase_counts AS (
    SELECT 
        CustomerID,
        DATE_FORMAT(Date, '%Y-%m-01') AS MonthStart,
        COUNT(*) AS PurchaseCount
    FROM sales
    GROUP BY CustomerID, DATE_FORMAT(Date, '%Y-%m-01')
)
SELECT 
    MonthStart,
    SUM(CASE WHEN PurchaseCount = 1 THEN 1 ELSE 0 END) AS UniqueBuyers,
    SUM(CASE WHEN PurchaseCount > 1 THEN 1 ELSE 0 END) AS RepeatBuyers,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(CASE WHEN PurchaseCount > 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 2) AS RepeatPurchaseRatio
FROM purchase_counts
GROUP BY MonthStart
ORDER BY MonthStart;



### Product & Brand Performance

-- Top 10 products by units sold.

Select 
	ProductName, 
    Sum(UnitsSold) as Total_unit_sold
from product as p
join sales as s
on p.ProductID = s.ProductID
group by ProductName
order by Sum(UnitsSold) desc
limit 10;

-- Top 10 products by revenue

Select 
	ProductName, 
    Sum(Revenue) as Revenue
from product as p
join sales as s
on p.ProductID = s.ProductID
group by ProductName
order by Sum(Revenue) desc
limit 10;

-- Revenue by category

Select 
	Category, 
    Sum(Revenue) as Revenue
from product as p
join sales as s
on p.ProductID = s.ProductID
group by Category;

-- Revenue by brand.

Select 
	Brand, 
    Sum(Revenue) as Revenue
from product as p
join sales as s
on p.ProductID = s.ProductID
group by Brand;

-- Average base price per category

Select 
	Category, 
    Sum(BasePrice) as Avg_baseprice
from product 
group by Category;

-- Top 5 products with highest return rate.

Select 
	ProductName, 
    (Sum(Returns)*100)/Sum(UnitsSold) as Return_rate
from product as p
join sales as s
on p.ProductID = s.ProductID
group by ProductName
Order by (Sum(Returns)*100)/Sum(UnitsSold) Desc
Limit 5;

-- Products launched per year.

Select 
	Monthname(LaunchDate) as Months , 
    Count(ProductID) as Product_launched
from product
group by Monthname(LaunchDate);

-- Average discount by brand.

Select 
	Brand , 
    Avg(Discount)
from product as p
join sales as s
on p.ProductID = s.ProductID
group by Brand;

-- Stock-out proxy: Days where product sales = 0 but previous days had sales.

WITH daily_sales AS (
    SELECT 
        ProductID,
        DATE(Date) AS SaleDate,
        SUM(UnitsSold) AS TotalUnits
    FROM sales
    GROUP BY ProductID, DATE(Date)
),

sales_with_lag AS (
    SELECT 
        ds.ProductID,
        ds.SaleDate,
        ds.TotalUnits,
        LAG(ds.TotalUnits) OVER (PARTITION BY ds.ProductID ORDER BY ds.SaleDate) AS PrevDayUnits
    FROM daily_sales ds
)

SELECT 
    ProductID,
    SaleDate,
    PrevDayUnits,
    TotalUnits,
Case
        WHEN PrevDayUnits > 0 AND (TotalUnits IS NULL OR TotalUnits = 0) 
        THEN 1 ELSE 0 
END AS StockoutFlag
FROM sales_with_lag
WHERE PrevDayUnits > 0 AND (TotalUnits IS NULL OR TotalUnits = 0)
ORDER BY ProductID, SaleDate;

### Sentiment & Review Analysis

-- Rating distribution

Select 
	Rating , 
    count(CustomerID) as Count
from reviews
group by Rating
order by Rating;

-- Top 10 highest-rated products

Select 
	ProductName, 
    count(Rating) as Most_reviewed_product
from reviews as r
join product as p
on r.ProductID = p.ProductID
group by ProductName
order by count(Rating) Desc
limit 10;

-- Top 10 lowest-rated products

Select 
	ProductName, 
    count(Rating) as lowest_reviewed_product
from reviews as r
join product as p
on r.ProductID = p.ProductID
group by ProductName
order by count(Rating) asc
limit 10;

-- Top 10 Highest Rating Product

Select 
	ProductName, 
    Rating
from reviews as r
join product as p
on r.ProductID = p.ProductID
group by ProductName, Rating
order by Rating desc
limit 10;

-- Average rating by category.

Select 
	Category, 
    Round(Avg(Rating),2) as Rating
from reviews as r
join product as p
on r.ProductID = p.ProductID
group by Category;

-- Average sentiment score by brand.

Select 
	Brand, 
    Round(Avg(SentimentScore),2) as Sentiment_Score
from reviews as r
join product as p
on r.ProductID = p.ProductID
group by Brand;

-- Reviews submitted per month.

select 
	monthname(ReviewDate) , 
    count(*) as Review_counts
from reviews
group by monthname(ReviewDate)
order by monthname(ReviewDate) ;

-- Rating decay: How ratings change over product lifecycle.

SELECT 
    p.ProductID,
    p.ProductName,
    TIMESTAMPDIFF(DAY, p.LaunchDate, r.ReviewDate) AS DaysSinceLaunch,
    ROUND(AVG(r.Rating), 2) AS AvgRating,
    COUNT(*) AS ReviewCount
FROM reviews r
JOIN product p 
    ON r.ProductID = p.ProductID
WHERE r.ReviewDate >= p.LaunchDate
GROUP BY p.ProductID, p.ProductName, DaysSinceLaunch
ORDER BY p.ProductID, DaysSinceLaunch;


### Advanced & Integrated Insights

-- top 10 revenue products: avg rating & return rate.

select 
	ProductName, 
    Sum(Revenue) as Revenue , 
    Avg(Rating) as Rating, 
    (Sum(Returns)*100)/Sum(UnitsSold) as Return_rate
from product as p
join sales as s
join reviews as r
on p.ProductID = s.ProductID and s.ProductID = r.ProductID
group by ProductName
order by Sum(Revenue) desc
limit 10;

-- Top 3 categories purchased by “Gold” tier customers.

select 
	Category , 
    sum(UnitsSold) as High_Purchase
from product as p
join sales as s 
join customers as c
on p.ProductID = s.ProductID and s.CustomerID = c.CustomerID
where LoyaltyTier = "Gold"
group by Category
order by sum(UnitsSold) desc
limit 3;

-- Avg rating & return rate by acquisition channel.

select 
	AcquisitionChannel , 
    Avg(Rating) as Rating , 
    (Sum(Returns)*100)/Sum(UnitsSold) as Return_rate
from sales as s
join reviews as r
on  s.ProductID = r.ProductID
group by AcquisitionChannel;

-- Best-selling category in a specific state 

SELECT 
    c.State,
    p.Category,
    SUM(s.UnitsSold) AS TotalUnits,
    SUM(s.Revenue) AS TotalRevenue
FROM sales s
JOIN customers c 
    ON s.CustomerID = c.CustomerID
JOIN products p 
    ON s.ProductID = p.ProductID
WHERE c.State = 'Rajasthan'
GROUP BY c.State, p.Category
ORDER BY TotalUnits DESC
LIMIT 1;



-- Top 5 customers by spend and their avg review rating.

Select Name , Avg(revenue) as Revenue , Avg(Rating) as Rating
from reviews as r
join sales as s 
join customers as c
on r.ProductID = s.ProductID and s.CustomerID = c.CustomerID
Group by Name
order by Avg(revenue) Desc
limit 5;

-- Avg sentiment score difference for high discount vs low discount products.

SELECT 
    CASE 
        WHEN s.Discount >= 0.20 THEN 'High Discount (>=20%)'
        WHEN s.Discount <= 0.05 THEN 'Low Discount (<=5%)'
        ELSE 'Medium Discount'
    END AS DiscountCategory,
    ROUND(AVG(r.SentimentScore), 3) AS AvgSentimentScore,
    COUNT(r.CustomerID) AS ReviewCount
FROM sales s
JOIN reviews r 
    ON s.ProductID = r.ProductID 
   AND s.CustomerID = r.CustomerID
WHERE s.Discount IS NOT NULL
GROUP BY DiscountCategory
ORDER BY AvgSentimentScore DESC;



-- Avg days from registration to first purchase.

WITH first_purchase AS (
    SELECT 
        s.CustomerID,
        MIN(s.Date) AS FirstPurchaseDate
    FROM sales s
    GROUP BY s.CustomerID
)
SELECT 
    ROUND(AVG(DATEDIFF(fp.FirstPurchaseDate, c.RegistrationDate)), 2) AS AvgDaysToFirstPurchase
FROM first_purchase fp
JOIN customers c 
    ON fp.CustomerID = c.CustomerID
WHERE fp.FirstPurchaseDate >= c.RegistrationDate;


-- Avg spend of customers who review vs those who don’t.

WITH customer_spend AS (
    SELECT 
        CustomerID,
        SUM(Revenue) AS TotalSpend
    FROM sales
    GROUP BY CustomerID
),
review_flag AS (
    SELECT DISTINCT 
        CustomerID,
        1 AS HasReview
    FROM reviews
)
SELECT 
    COALESCE(r.HasReview, 0) AS ReviewerFlag,
    ROUND(AVG(cs.TotalSpend), 2) AS AvgSpend
FROM customer_spend cs
LEFT JOIN review_flag r 
    ON cs.CustomerID = r.CustomerID
GROUP BY ReviewerFlag;

### Insights

# High-Value Customers are Vocal: Customers who write reviews contribute a significantly higher average spend than non-reviewers, indicating that your most engaged users are also your most valuable.

# The "Consideration Gap": There is a measurable delay between a customer's registration and their first purchase, highlighting a critical window to use targeted marketing to convert sign-ups into active buyers.

# Discount Strategy Risks Brand Health: Products with high discounts (>=20%) are associated with lower average sentiment scores, suggesting that aggressive discounting may be linked to lower quality products and could damage customer trust.

# "Organic" Channel Delivers Quality over Quantity: While other channels may drive volume, the "Organic" acquisition channel consistently brings in high-value customers who have a better average rating and lower return rates.

# Gold Tier Drives Revenue: The "Gold" loyalty tier is the most significant contributor to total revenue, indicating that retention strategies focused on these high-value customers are critical for sustained growth.

# Geographic Concentration of Sales: A few key states, such as Andhra Pradesh and Bihar, are responsible for a disproportionately large share of revenue, making them priority regions for marketing and logistics.

# Brand Reputation is a Key Differentiator: "BrandX" dominates in both revenue and units sold, proving that brand strength is a more powerful driver of sales than just product category or price.

# Product Return Rates Signal Quality Issues: A small subset of products accounts for the majority of returns. These products also tend to have lower average ratings, providing a clear list for quality control investigation.

# Top Spenders Provide Actionable Feedback: Your highest-spending customers are also frequent reviewers, giving you a direct channel to understand the preferences and pain points of your most important customer segment.

# Untapped Potential in Mid-Tier Customers: The "Silver" loyalty tier represents a large customer base with significant potential. Targeted campaigns to upgrade them to "Gold" could unlock substantial revenue growth.









-- Project END










       




