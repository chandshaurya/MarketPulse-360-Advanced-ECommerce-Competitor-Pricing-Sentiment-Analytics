# MarketPulse-360-Advanced-ECommerce-Competitor-Pricing-Sentiment-Analytics

# Project Objective

Design and deliver a complete, production-ready analytics system for a retail e-commerce business—covering data cleaning, exploratory data analysis (EDA), SQL business questions, and an executive-grade Power BI dashboard—so stakeholders can track growth, pricing power, marketing effectiveness, product/brand performance, and customer sentiment in one place.

# What’s in this project 

**Power BI dashboard (4 pages):** Executive Overview, Product & Brand Analysis, Marketing & Channel Effectiveness, Customer Sentiment & Returns. Each page and visual listed below mirrors the artifacts I produced. 
 
**SQL analysis** answering 43 business questions (enumerated below). 

**Python data preparation + EDA (Jupyter report)**, including cleaning, type fixes, outlier checks (IQR), descriptive stats, and discovery insights.


# Data sources

Four flat files power the model:
**customers.csv** — demographics, registration date, loyalty tier. 

**products.csv** — product master with category, brand, base price, launch date. 

**sales.csv** — daily transactions with units, returns, discount, our vs competitor price, channel. 

**reviews.csv** — product ratings, review dates, and a precomputed sentiment score.



# Process Workflow
1️⃣** Data Generation** (Python – Faker)

Created synthetic yet realistic datasets for customers, products, sales, and reviews.

Ensured unique IDs, valid dates, correct ranges for pricing, discounts, and ratings.

2️⃣ **Data Cleaning** (Python – Pandas)

Handled Missing Values: Replaced "0", blanks, and NULLs with appropriate placeholders.

**Type Normalization:** Converted all date fields (RegistrationDate, LaunchDate, Date, ReviewDate) to datetime.

**Schema Verification:** Checked column presence and datatypes.

**Outlier Detection (IQR):** Flagged anomalies in Revenue, OurPrice, CompetitorPrice, and UnitsSold. (~0.2–0.3% rows flagged).

**Saved Cleaned Datasets:** Exported into a separate folder for SQL & Power BI.

3️⃣ **Exploratory Data Analysis** (EDA)

**Descriptive Statistics:** Revenue, discounts, units, ratings, sentiment scores.

**Trend Analysis:** Revenue growth across months, customer acquisition trends.

**Outlier & Anomaly Detection:** Stock-out proxy days (sales=0 after prior demand).

**Launch Analysis:** Products introduced per year and their early reviews.

4️⃣ **SQL Analysis**

Built 43 queries across KPIs, customer analytics, product insights, sentiment, and integrated metrics.

Themes: Revenue KPIs, Demographics, Retention, Brand performance, Channel ROI, Sentiment decay, Loyalty insights.

5️⃣ **Power BI Dashboard** (5 Pages)

**Executive Overview:** KPIs (Revenue, Units, Discounts, Rating), Revenue Trend, Top 10 Products.

**Customer Deep Dive:** Geographical Map , Revenue Trends

**Product & Brand Analysis:** Units vs Revenue, Price vs Sales, Return Rate, Top Brands.

**Marketing & Channel Effectiveness:** Acquisition trends, Revenue per Channel, Customer growth.

**Customer Sentiment & Returns:** Rating distribution, Reviews per month, Sentiment by Brand, Rating decay vs lifecycle.


# Data cleaning  

**Consistent NA handling on load**
Treated "0", 0, and blank strings as missing where appropriate when reading all CSVs to prevent “fake zeros” in demographics and text fields. 
 
**Type normalization (dates)**
Coerced all date fields to datetime: RegistrationDate (customers), LaunchDate (products), Date (sales), and ReviewDate (reviews). This fixed mixed string/date issues and enabled time-series work. 
 
**Schema & missingness inspection**
Verified column presence/types and scanned null patterns across all tables before transformations. 
 
**Outlier detection (IQR)**
Profiled outliers for key numeric fields (e.g., Revenue, UnitsSold, OurPrice, CompetitorPrice) using an IQR fence. Example: OurPrice had ~0.24% flagged rows, CompetitorPrice ~0.23%. These were reviewed (flagged) rather than auto-dropped to preserve signal. 

**Persistence of cleaned outputs**
Wrote the cleaned tables back to a dedicated “Cleaned CSV” folder for modeling and BI. 


###  Exploratory Data Analysis (Python)

A Jupyter Notebook was used for a deeper statistical exploration of the data:

**Descriptives & Distributions:** Analyzed price, discounts, units, ratings, and sentiment to understand central tendency and spread.

**Time Trends:** Investigated trends for revenue, units sold, new customers, and review volume.

**Outlier Analysis:** Explored extreme revenue and price points identified during the cleaning phase.

**Product Lifecycle Analysis:** Analyzed product launch cadence to align rating and return behaviors with product lifecycle timing.


##  Power BI Dashboard Preview

The final output is a 5-page interactive dashboard designed for executive-level analysis.



| Dashboard Page                    | Key Focus                                        |
| --------------------------------- | ------------------------------------------------ |
| **1. Executive Overview** | High-level KPIs, financial health, and regional performance. |
| **2. Customer Deep Dive** | Acquistion Revenue , City wise Revenue . |
| **3. Product & Brand Analysis** | Product performance, brand strength, and pricing strategy. |
| **4. Marketing & Channel Effectiveness** | Effectiveness of different customer acquisition channels.  |
| **5. Customer Sentiment & Returns** | Customer satisfaction, product quality, and feedback analysis. |

---

### 3. SQL Analysis Portfolio (43 Business Questions)

A comprehensive set of 43 distinct SQL queries was developed to perform a deep-dive analysis, grouped by theme:

#### Sales & Revenue KPIs
1.  Total revenue, units sold, and return rate.
2.  Monthly revenue trend.
3.  Monthly units sold trend.
4.  Top 10 revenue days.
5.  Average order value (AOV).
6.  Total discounts given (with bucketed breakdown).
7.  Revenue by acquisition channel.
8.  Revenue by product category.
9.  Revenue by brand.
10. Top 10 products by revenue.
11. Top 10 products by units sold.

#### Customer & Demographic Analysis
12. Unique customers (lifetime).
13. New customers per month.
14. Repeat-purchase ratio by month.
15. Revenue and average spend by gender.
16. Revenue share by loyalty tier.
17. Top 10 customers by lifetime spend.
18. Customer count by state.
19. Top 10 cities by customer count.
20. Best-selling category in Rajasthan.

#### Product & Launch Performance
21. Products launched per year.
22. Average base price by category.
23. Average discount by brand.
24. Stock-out proxy days (0 sales after prior sales).
25. Top 5 products with highest return rate.
26. Return rate by category.

#### Channel & Acquisition
27. Most effective acquisition channel for new customers.
28. Average discount by acquisition channel.
29. Revenue share by acquisition channel.
30. Top products sold via Paid channel.
31. Top products sold via Social Media.

#### Sentiment & Reviews
32. Rating distribution across products.
33. Top 10 highest-rated products.
34. Top 10 lowest-rated products.
35. Average rating by category.
36. Average sentiment score by brand.
37. Reviews submitted per month.
38. Rating decay vs days since launch.

#### Integrated / Advanced
39. Top 10 revenue products with their avg rating & return rate.
40. Top 3 categories purchased by Gold-tier customers.
41. Average rating & return rate by acquisition channel.
42. Average days from registration to first purchase.
43. Average spend of customers who review vs those who don’t.

---

##  Key Business Insights

The analysis surfaced several high-impact, actionable insights:

-   **Revenue & Market Growth:** Annual revenue crossed **₹30B** with consistent Q3–Q4 spikes, suggesting festive demand drives peak sales. While all loyalty tiers are important, **Gold-tier customers spend more per transaction**.
-   **Geographic Opportunities:** **Andhra Pradesh, Bihar, and Rajasthan** are top revenue states, indicating strong customer adoption in Tier-2 and Tier-3 regions. Urban hubs like Patna and Jaipur are prime locations for targeted regional campaigns.
-   **Product & Brand Performance:** **Beauty & Electronics** dominate in both units sold and revenue. **Brand Gamma** is a clear leader in both sales and customer ratings. Products with high return rates consistently overlap with low ratings, confirming quality issues.
-   **Customer & Loyalty Insights:** An average customer tenure of **18 months** highlights healthy retention. New customer acquisition peaked via **Email Marketing** in 2024–25, and the top 10 spenders contribute disproportionately to revenue, making them a priority for VIP programs.
-   **Pricing & Discounts:** Our prices are generally lower than competitors, especially in Books & Beauty, giving us a pricing edge. In Electronics, competitor prices are more attractive, creating an opportunity to optimize margins.
-   **Marketing & Channels:** The **Organic** channel is best for consistent units sold, while **Email Marketing** is strong for new acquisitions. **Paid ads** are associated with high returns, making it a less profitable channel.
-   **Sentiment & Customer Feedback:** **65% positive sentiment** shows general satisfaction. Negative reviews are concentrated in specific brands, providing early alerts for quality control. Rating decay analysis shows that ratings tend to drop 6–12 months after a product launch, highlighting the need for active product lifecycle management.
