create database sql_project;
create table retail_t(transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(35),
quantiy int,
price_per_unit float,
cogs float,
total_sale float);

SELECT 
    COUNT(*) 
FROM retail_t;

-- data cleaning
select * FROM retail_t
WHERE 
    transactions_id IS NULL 
	OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



select * from retail_t where 
transactions_id is not null;
--q1
select * from retail_t where sale_date ='2022-11-05';

--q2
select * from retail_t where category ='Clothing' and 
to_char(sale_date,'yyyy-mm')='2022-11'
and 
quantiy >=4

--q3
select category ,sum(total_sale) as net_sale,
count(*) as total_orders
from retail_t
group by 1

--q4
select round(avg(age),2) as avg_age
from retail_t where category ='Beauty'

--q5

select * from retail_t
where total_sale > 1000
--q6
select category,gender,count(*) as total_trans
from retail_t
group by category,gender
order by 1,2;
--q7
select year ,month,avg_sale 
from


(select 
   extract(year from sale_date) as year,
   extract (month from sale_date) as month,
   avg(total_sale) as avg_sale,
   rank() over(partition by extract (year from sale_date) order by avg(total_sale) desc)as rank
   from retail_t
   group by 1,2
   ) as t1
   where rank =1

 --q8
 select customer_id,sum(total_sale) as total_sales
 from retail_t
 group by 1
 order by 2 desc
 limit 5;
 --q9
 select category,count(distinct customer_id) as unique_customers
 from retail_t
 group by category;
 --q10
with q10
as
 
 (select * ,
 case 
 when extract(hour from sale_time) <12 then 'morning'
 when extract (hour from sale_time) between 12 and 17 then 'afternoon'
 else 'evening'
 end as shift from retail_t)
 select shift ,count(*) as total_orders
 from q10 
 group by shift