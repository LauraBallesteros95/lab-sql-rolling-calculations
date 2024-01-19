-- LAB MySQL Rolling Calculations
-- Get number of monthly active customers.
select year(payment_date) as year,
       month(payment_date) as month,
       count(distinct customer_id) as active_customers
from payment
group by year(payment_date), month(payment_date)
order by year(payment_date), month(payment_date);
-- Active users in the previous month.
select count(distinct customer_id) as active_users
from payment
where year(payment_date) = year(current_date - interval 1 month)
and month(payment_date) = month(current_date - interval 1 month);
-- Percentage change in the number of active customers.
SELECT 
    (current_month.active_customers - previous_month.active_customers) / previous_month.active_customers * 100 AS percentage_change
FROM 
    (SELECT 
        COUNT(DISTINCT customer_id) AS active_customers 
    FROM 
        payment 
    WHERE 
        YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) AND 
        MONTH(payment_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)) AS previous_month,
    (SELECT 
        COUNT(DISTINCT customer_id) AS active_customers 
    FROM 
        payment 
    WHERE 
        YEAR(payment_date) = YEAR(CURRENT_DATE) AND 
        MONTH(payment_date) = MONTH(CURRENT_DATE)) AS current_month;
-- Retained customers every month.
SELECT 
    COUNT(DISTINCT current_month.customer_id) AS retained_customers
FROM 
    payment AS current_month
JOIN 
    payment AS next_month ON current_month.customer_id = next_month.customer_id
WHERE 
    YEAR(current_month.payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) AND
    MONTH(current_month.payment_date) = MONTH(current_date - interval 1 month) AND
    YEAR(next_month.payment_date) = YEAR(CURRENT_DATE) AND
    MONTH(next_month.payment_date) = MONTH(CURRENT_DATE);