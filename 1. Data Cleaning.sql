create database coffee_shop_sales;
Describe coffee_sales;

SELECT * FROM coffee_sales;

UPDATE coffee_sales 
SET  transaction_date =str_to_date(transaction_date, '%d-%m-%Y');
ALTER TABLE coffee_sales
MODIFY COLUMN transaction_date DATE;

UPDATE coffee_sales 
SET  transaction_time =str_to_date(transaction_time, '%H:%i:%s');
ALTER TABLE coffee_sales
MODIFY COLUMN transaction_time TIME;

ALTER TABLE coffee_sales
CHANGE COLUMN ï»¿transaction_id transaction_id INT;