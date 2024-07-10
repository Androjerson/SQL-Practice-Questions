--Repeat Purchases on Multiple Days [Stitch Fix SQL Interview Question]

--We have been given purchases table which contains purchases made by different user on different days.
--We have to output number of users who made purchase of same product on two or more days

CREATE TABLE purchases (
    user_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    purchase_date TIMESTAMP
);


INSERT INTO purchases (user_id, product_id, quantity, purchase_date) VALUES (536, 3223, 6, TO_TIMESTAMP('01/11/2022 12:33:44', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO purchases (user_id, product_id, quantity, purchase_date) VALUES (827, 3585, 35, TO_TIMESTAMP('02/20/2022 14:05:26', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO purchases (user_id, product_id, quantity, purchase_date) VALUES (536, 3223, 5, TO_TIMESTAMP('03/02/2022 09:33:28', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO purchases (user_id, product_id, quantity, purchase_date) VALUES (536, 1435, 10, TO_TIMESTAMP('03/02/2022 08:40:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO purchases (user_id, product_id, quantity, purchase_date) VALUES (827, 2452, 45, TO_TIMESTAMP('04/09/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

SELECT * FROM purchases;

--Approach 1:

--Fetching the distint user as same user could have bought the muliple products on different dates  
SELECT COUNT(DISTINCT user_id) FROM 
--Subquery gets the users that bought the same product on multiple days 
(SELECT user_id,product_id FROM purchases
GROUP BY user_id,product_id 
HAVING COUNT(DISTINCT TRUNC(purchase_date))>1);

--Approach 2:
--Co-related Subquery
SELECT COUNT(DISTINCT user_id) FROM purchases a WHERE exists
(SELECT 1 FROM purchases b
WHERE a.user_id=b.user_id 
GROUP BY user_id,product_id 
HAVING COUNT(DISTINCT TRUNC(purchase_date))>1);
