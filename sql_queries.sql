use customer_behavior;
SHOW TABLES;

SELECT * FROM customer; #view full data 
DESCRIBE customer; #check structure
SELECT COUNT(*) FROM customer; #total customers

#Average purchase amount
SELECT AVG(purchase_amount) FROM customer;

#Customers by age group
SELECT age_group, COUNT(*) 
FROM customer
GROUP BY age_group;

#Total sales by category
SELECT category, SUM(purchase_amount) AS total_sales
FROM customer
GROUP BY category;

#Top 10 spenders
SELECT customer_id, purchase_amount
FROM customer
ORDER BY purchase_amount DESC
LIMIT 10;

#Subscription vs non-subscription
SELECT subscription_status, COUNT(*)
FROM customer
GROUP BY subscription_status;

#Most used payment methods
SELECT payment_method, COUNT(*) 
FROM customer
GROUP BY payment_method
ORDER BY COUNT(*) DESC;

#Check missing values
SELECT COUNT(*) 
FROM customer
WHERE age IS NULL;

#Check min, max, avg
SELECT 
MIN(purchase_amount), 
MAX(purchase_amount), 
AVG(purchase_amount)
FROM customer;

#Check unique values
SELECT DISTINCT category FROM customer;

#Q1. Total revenue by Male vs Female

SELECT gender,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY gender;

#Q2. Customers who used discount and spent more than average

SELECT *
FROM customer
WHERE discount_applied = 'Yes'
AND purchase_amount >
    (SELECT AVG(purchase_amount) FROM customer);

#Q3. Top 5 products with highest average rating

SELECT item_purchased,
       AVG(review_rating) AS avg_rating
FROM customer
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;

#Q4. Compare avg purchase between Standard vs Express shipping

SELECT shipping_type,
       AVG(purchase_amount) AS avg_purchase
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

#Q5. Do subscribers spend more?

SELECT subscription_status,
       AVG(purchase_amount) AS avg_spend,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY subscription_status;

#Q6. Top 5 products with highest % of discounted purchases

SELECT item_purchased,
       (SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*)) AS discount_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;

#Q7. Segment customers: New, Returning, Loyal

SELECT 
CASE
    WHEN previous_purchases <= 2 THEN 'New'
    WHEN previous_purchases BETWEEN 3 AND 10 THEN 'Returning'
    ELSE 'Loyal'
END AS customer_segment,
COUNT(*) AS total_customers
FROM customer
GROUP BY customer_segment;

#Q8. Top 3 products per category (MOST IMPORTANT SQL)

SELECT category, item_purchased, total_sales
FROM (
    SELECT category,
           item_purchased,
           COUNT(*) AS total_sales,
           RANK() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS rnk
    FROM customer
    GROUP BY category, item_purchased
) ranked
WHERE rnk <= 3;

#Q9. Are repeat buyers likely to subscribe?

SELECT subscription_status,
       COUNT(*) AS total_customers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

#Q10. Revenue contribution by age group

SELECT age_group,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group;

