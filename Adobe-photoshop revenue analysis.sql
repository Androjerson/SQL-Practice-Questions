--Adobe: Photoshop Revenue Analysis

--For every customer that bought Photoshop, return a list of the customers, and the total spent on all the products except for Photoshop products.
--Sort your answer by customer ids in ascending order.

-- Create the table
CREATE TABLE adobe_transactions (
    customer_id NUMBER,
    product VARCHAR2(255),
    revenue INT
);

-- Insert data using INSERT ALL
INSERT ALL
    INTO adobe_transactions (customer_id, product, revenue) VALUES (123, 'Photoshop', 50)
    INTO adobe_transactions (customer_id, product, revenue) VALUES (123, 'Premier Pro', 100)
    INTO adobe_transactions (customer_id, product, revenue) VALUES (123, 'After Effects', 50)
    INTO adobe_transactions (customer_id, product, revenue) VALUES (234, 'Illustrator', 200)
    INTO adobe_transactions (customer_id, product, revenue) VALUES (234, 'Premier Pro', 100)
SELECT * FROM dual; --SELECT is part of INSERT ALL

SELECT * FROM adobe_transactions;

SELECT customer_id,SUM(revenue) FROM adobe_transactions 
WHERE customer_id IN (
SELECT customer_id FROM adobe_transactions WHERE product='Photoshop')
AND product !='Photoshop' GROUP BY customer_id ORDER BY customer_id;
