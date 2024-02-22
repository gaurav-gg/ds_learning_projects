SET SQL_SAFE_UPDATES = 0;


-- Module: Database Design and Introduction to SQL
-- Session: Database Creation in MySQL Workbench
-- DDL Statements

-- 1. Create a table shipping_mode_dimen having columns with their respective data types as the following:
--    (i) Ship_Mode VARCHAR(25)
--    (ii) Vehicle_Company VARCHAR(25)
--    (iii) Toll_Required BOOLEAN

-- 2. Make 'Ship_Mode' as the primary key in the above table.


-- -----------------------------------------------------------------------------------------------------------------
-- DML Statements

-- 1. Insert two rows in the table created above having the row-wise values:
--    (i)'DELIVERY TRUCK', 'Ashok Leyland', false
--    (ii)'REGULAR AIR', 'Air India', false

-- 2. The above entry has an error as land vehicles do require tolls to be paid. Update the ‘Toll_Required’ attribute
-- to ‘Yes’.

-- 3. Delete the entry for Air India.


-- -----------------------------------------------------------------------------------------------------------------
-- Adding and Deleting Columns

-- 1. Add another column named 'Vehicle_Number' and its data type to the created table. 

-- 2. Update its value to 'MH-05-R1234'.

-- 3. Delete the created column.


-- -----------------------------------------------------------------------------------------------------------------
-- Changing Column Names and Data Types

-- 1. Change the column name ‘Toll_Required’ to ‘Toll_Amount’. Also, change its data type to integer.

-- 2. The company decides that this additional table won’t be useful for data analysis. Remove it from the database.


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Querying in SQL
-- Basic SQL Queries

-- 1. Print the entire data of all the customers.
select * from cust_dimen;
-- 2. List the names of all the customers.
select Customer_Name from cust_dimen;
-- 3. Print the name of all customers along with their city and state.
select Customer_Name, City, State from cust_dimen;
-- 4. Print the total number of customers.
select count(*) as Total_Customers
from cust_dimen;

-- 5. How many customers are from West Bengal?
select count(*) as Total_Cust_from_WB from cust_dimen where State='West Bengal';
-- 6. Print the names of all customers who belong to West Bengal.
select Customer_Name from cust_dimen where State='West Bengal';

-- -----------------------------------------------------------------------------------------------------------------
-- Operators

-- 1. Print the names of all customers who are either corporate or belong to Mumbai.
select Customer_Name from cust_dimen where City='Mumbai' or Customer_Segment='CORPORATE';
-- 2. Print the names of all corporate customers from Mumbai.
select Customer_Name from cust_dimen where City='Mumbai' and Customer_Segment='CORPORATE';
-- 3. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.
select * from cust_dimen where State in ('Tamil Nade','Karnataka','Telangana','Kerala');
-- 4. Print the details of all non-small-business customers.
select * from cust_dimen where Customer_Segment != 'Small Business';
-- 5. List the order ids of all those orders which caused losses.
select Ord_id, Profit from market_fact_full where profit<0;
-- 6. List the orders with '_5' in their order ids and shipping costs between 10 and 15.
select * from market_fact_full where Ord_id like '%_5%' and shipping_cost between 10 and 15;

-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate Functions

-- 1. Find the total number of sales made.
select count(sales) as No_of_Sales from market_fact_full;
-- 2. What are the total numbers of customers from each city?
select count(Customer_Name) as City_Wise_Customers, City
from cust_dimen
group by City;
-- 3. Find the number of orders which have been sold at a loss.
select count(Order_Quantity) as Total_Orders, profit from market_fact_full where PROFIT <0;
-- 4. Find the total number of customers from Bihar in each segment.
select count(cust_id) customers, Customer_Segment, State from cust_dimen where State='Bihar' group by Customer_Segment;
-- 5. Find the customers who incurred a shipping cost of more than 50.
select Cust_id from market_fact_full where Shipping_Cost>50;
select Customer_Name from cust_dimen where cust_id='Cust_839';

-- -----------------------------------------------------------------------------------------------------------------
-- Ordering

-- 1. List the customer names in alphabetical order.
select distinct Customer_Name from cust_dimen order by Customer_Name;
-- 2. Print the three most ordered products.
select sum(Order_Quantity) Orders,Prod_id from market_fact_full group by Prod_id order by Orders desc limit 3;
-- 3. Print the three least ordered products.
select sum(Order_Quantity) Orders,Prod_id from market_fact_full group by Prod_id order by Orders limit 3;
-- 4. Find the sales made by the five most profitable products.

-- 5. Arrange the order ids in the order of their recency.

-- 6. Arrange all consumers from Coimbatore in alphabetical order.


-- -----------------------------------------------------------------------------------------------------------------
-- String and date-time functions

-- 1. Print the customer names in proper case.
select Customer_Name, concat(substring(Customer_Name,1,1),lower(substring(substring_index(customer_name,' ',1),2)),
' ',substring(substring_index(customer_name,' ',-1),1,1),lower(substring(substring_index(customer_name,' ',-1),2)))
from cust_dimen;
-- 2. Print the product names in the following format: Category_Subcategory.
select concat(Product_Category,'_',Product_sub_category) as Product_Name from prod_dimen;
-- 3. In which month were the most orders shipped?
select count(Ship_id) as Ship_Count, month(Ship_Date) as Ship_Month
from shipping_dimen
group by Ship_Month
order by Ship_Count desc;
-- 4. Which month and year combination saw the most number of critical orders?
select count(Ord_id) as Orders, month(Order_Date) as Order_Month,
year(Order_Date) as Order_Year
from orders_dimen
where Order_Priority='Critical'
group by Order_Month, Order_Year
order by Orders desc;
-- 5. Find the most commonly used mode of shipment in 2011.
select Ship_Mode, year(Ship_Date) as Ship_Year, count(Ship_Mode) as Count
from shipping_dimen
where year(Ship_Date)=2011
group by ship_mode
order by Count desc;

-- -----------------------------------------------------------------------------------------------------------------
-- Regular Expressions

-- 1. Find the names of all customers having the substring 'car'.
select Customer_Name from cust_dimen where Customer_Name like '%CAR%';
select Customer_Name from cust_dimen where Customer_Name regexp 'car';
-- 2. Print customer names starting with A, B, C or D and ending with 'er'.
select Customer_Name from cust_dimen where Customer_Name regexp '^[abcd].*er$';

-- -----------------------------------------------------------------------------------------------------------------
-- Nested Queries

-- 1. Print the order number of the most valuable order by sales.
select Ord_id, Sales, round(Sales) as Rounded_Sales
from market_fact_full
where Sales = (
	select max(Sales)
    from market_fact_full
);
-- 2. Return the product categories and subcategories of all the products which don’t have details about the product
-- base margin.
select product_category, product_sub_category, prod_id from prod_dimen where prod_id in (select prod_id from market_fact_full where Product_Base_Margin is null);
select prod_id from market_fact_full where Product_Base_Margin is null;
-- 3. Print the name of the most frequent customer.
select Customer_Name, cust_id from cust_dimen where cust_id = (select cust_id from market_fact_full group by cust_id order by count(cust_id) desc limit 1 );
-- 4. Print the three most common products.
select Product_Category, Product_Sub_Category, Prod_id from prod_dimen where prod_id = (select prod_id from market_fact_full group by prod_id order by count(prod_id) desc limit 1 );

-- -----------------------------------------------------------------------------------------------------------------
-- CTEs

-- 1. Find the 5 products which resulted in the least losses. Which product had the highest product base
-- margin among these?
select prod_id, profit, product_base_margin
from market_fact_full
where profit<0
order by profit desc
limit 5;

with least_losses as (
	select prod_id, profit, product_base_margin
	from market_fact_full
	where profit<0
	order by profit desc
	limit 5
) select * from least_losses where Product_Base_Margin = (select max(Product_Base_Margin) from least_losses);
-- 2. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?
select Ord_id, Order_date, Order_Priority
from orders_dimen
where Order_Priority = 'low' and month(Order_Date)=4;

with low_priority_orders as (
select Ord_id, Order_date, Order_Priority
from orders_dimen
where Order_Priority = 'low' and month(Order_Date)=4
) select count(Ord_id) as Order_Count
from low_priority_orders where day(Order_Date) between 1 and 15;

-- -----------------------------------------------------------------------------------------------------------------
-- Views

-- 1. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.
create view order_info
as select Ord_id, Sales, Order_Quantity, Profit, Shipping_Cost from market_fact_full;

select Ord_id, Profit from order_info where Profit>1000;
-- 2. Which year generated the highest profit?
create view market_facts_and_orders
as select * from market_fact_full
	inner join orders_dimen
	using (Ord_id);
    
select sum(Profit) as Year_Wise_Profit, year(Order_Date) as Order_Year
from market_facts_and_orders
group by Order_Year
order by Year_Wise_Profit desc
limit 1;

-- -----------------------------------------------------------------------------------------------------------------
-- Session: Joins and Set Operations
-- Inner Join

-- 1. Print the product categories and subcategories along with the profits made for each order.
select Ord_id, product_category, product_sub_category, profit
from prod_dimen p inner join market_fact_full m 
on p.prod_id=m.prod_id;
-- 2. Find the shipment date, mode and profit made for every single order.
select Ord_id, profit, ship_mode
from market_fact_full m inner join shipping_dimen s
on m.Ship_id=s.Ship_id;

-- 3. Print the shipment mode, profit made and product category for each product.
select s.Ship_mode, m.profit, p.product_category, p.prod_id
from market_fact_full m inner join prod_dimen p
on p.prod_id=m.prod_id
inner join shipping_dimen s
on s.ship_id=m.ship_id;
-- 4. Which customer ordered the most number of products?
select sum(Order_quantity) number_of_orders, m.cust_id, customer_name
from cust_dimen c
inner join market_fact_full m
on c.cust_id=m.cust_id
group by cust_id
order by number_of_orders desc;
-- 5. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?
select p.product_category, sum(m.profit), c.city
from market_fact_full m inner join prod_dimen p
using(prod_id)
inner join cust_dimen c using(cust_id)
where c.city in ('Delhi','Patna') and p.Product_Category='OFFICE SUPPLIES'
group by c.city, p.Product_Category;
-- 6. Print the name of the customer with the maximum number of orders.

-- 7. Print the three most common products.


-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table.

-- Execute the below queries before solving the next question.
create table manu (
	Manu_Id int primary key,
	Manu_Name varchar(30),
	Manu_City varchar(30)
);

insert into manu values
(1, 'Navneet', 'Ahemdabad'),
(2, 'Wipro', 'Hyderabad'),
(3, 'Furlanco', 'Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_Dimen
set Manu_Id = 2
where Product_Category = 'technology';

select * from manu;
-- 2. Display the products sold by all the manufacturers using both inner and outer joins.
select m.manu_name, p.prod_id
from manu m inner join prod_dimen p on m.manu_id=p.manu_id;
-- 3. Display the number of products sold by each manufacturer.
select m.manu_name, count(p.prod_id)
from manu m inner join prod_dimen p on m.manu_id=p.manu_id;
-- 4. Create a view to display the customer names, segments, sales, product categories and
-- subcategories of all orders. Use it to print the names and segments of those customers who ordered more than 20
-- pens and art supplies products.
create view order_details as
select Customer_Name, Customer_Segment, Sales, Order_Quantity, Product_Category, Product_Sub_Category
from market_fact_full m
inner join cust_dimen c using(cust_id)
inner join prod_dimen p using(prod_id);

select * from order_details
where order_quantity > 20 and product_sub_Category ='Pens & Art Supplies'
group by Customer_Name;

-- -----------------------------------------------------------------------------------------------------------------
-- Union, Union all, Intersect and Minus

-- 1. Combine the order numbers for orders and order ids for all shipments in a single column.

-- 2. Return non-duplicate order numbers from the orders and shipping tables in a single column.

-- 3. Find the shipment details of products with no information on the product base margin.

-- 4. What are the two most and the two least profitable products?
(select prod_id, sum(Profit)
from market_fact_full
group by prod_id
order by sum(profit) desc
limit 2)
union
(select prod_id, sum(Profit)
from market_fact_full
group by prod_id
order by sum(profit)
limit 2);

-- -----------------------------------------------------------------------------------------------------------------
-- Module: Advanced SQL
-- Session: Window Functions	
-- Window Functions in Detail

-- 1. Rank the orders made by Aaron Smayling in the decreasing order of the resulting sales.

-- 2. For the above customer, rank the orders in the increasing order of the discounts provided. Also display the
-- dense ranks.

-- 3. Rank the customers in the decreasing order of the number of orders placed.

-- 4. Create a ranking of the number of orders for each mode of shipment based on the months in which they were
-- shipped. 


-- -----------------------------------------------------------------------------------------------------------------
-- Named Windows

-- 1. Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron Smayling. Also
-- display the row number for each order.


-- -----------------------------------------------------------------------------------------------------------------
-- Frames

-- 1. Calculate the month-wise moving average shipping costs of all orders shipped in the year 2011.


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Programming Constructs in Stored Functions and Procedures
-- IF Statements

-- 1. Classify an order as 'Profitable' or 'Not Profitable'.


-- -----------------------------------------------------------------------------------------------------------------
-- CASE Statements

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- 2. Classify the customers on the following criteria (TODO)
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Functions

-- 1. Create and use a stored function to classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Procedures

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- The market facts with ids '1234', '5678' and '90' belong to which categories of profits?