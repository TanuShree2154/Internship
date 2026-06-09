CREATE DATABASE DataBank;
USE DataBank;


 
select * from regions;
select * from customer_nodes;
select * from customer_transactions;

-- A. Customer Nodes Exploration

-- 1. How many unique nodes are there on the Data Bank system?
select count(distinct node_id) as unique_nodes from customer_nodes;

-- 2. What is the number of nodes per region?
select region_id , count( node_id) as node_pre_region from customer_nodes group by region_id;

-- 3. How many customers are allocated to each region?
select region_id, count(distinct customer_id) from customer_nodes group by region_id ;

-- 4.How many days on average are customers reallocated to a different node?
select c1.customer_id, avg(datediff(day ,  c1.start_date , c2.start_date )) as avg_days
 from customer_nodes c1 inner join customer_nodes c2 on c1.customer_id= c2.customer_id
 where c2.start_date= (select min(c3.start_date) from customer_nodes c3 
	where c3.customer_id = c1.customer_id and c3.start_date>c1.start_date ) and
    c1.node_id <> c2.node_id
 group by c1.customer_id;
 

 -- 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
SELECT DISTINCT
       region_id,
       PERCENTILE_CONT(0.5)
           WITHIN GROUP (ORDER BY days_diff)
           OVER (PARTITION BY region_id) AS median_days,
       PERCENTILE_CONT(0.8)
           WITHIN GROUP (ORDER BY days_diff)
           OVER (PARTITION BY region_id) AS p80_days,
       PERCENTILE_CONT(0.95)
           WITHIN GROUP (ORDER BY days_diff)
           OVER (PARTITION BY region_id) AS p95_days
FROM (
    SELECT
        c1.region_id,
        DATEDIFF(day, c1.start_date, c2.start_date) AS days_diff
    FROM customer_nodes c1
    JOIN customer_nodes c2
      ON c1.customer_id = c2.customer_id
    WHERE c2.start_date = (
        SELECT MIN(c3.start_date)
        FROM customer_nodes c3
        WHERE c3.customer_id = c1.customer_id
          AND c3.start_date > c1.start_date
    )
      AND c1.node_id <> c2.node_id
) t;

 -- B. Customer Transactions
-- 1.What is the unique count and total amount for each transaction type?
select txn_type ,count( txn_type) as count , sum(txn_amount)  from customer_transactions group by txn_type;

-- 2.What is the average total historical deposit counts and amounts for all customers?
SELECT 
    AVG(deposit_count) AS avg_deposit_count,
    AVG(deposit_amount) AS avg_deposit_amount
FROM (
    SELECT 
        customer_id,
        COUNT(*) AS deposit_count,
        SUM(txn_amount) AS deposit_amount
    FROM customer_transactions
    WHERE txn_type = 'deposit'
    GROUP BY customer_id
) t;


-- 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 
--   1 withdrawal in a single month?
select month , count(customer_id)
 from (
 select customer_id , format(txn_date , 'yyyy-MM') as month
 from customer_transactions 
  GROUP BY customer_id, FORMAT(txn_date, 'yyyy-MM')
  having
  sum(case when txn_type = 'deposit' then 1 else 0 end)>1
  AND (
            SUM(CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) >= 1
            OR
            SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) >= 1
        )
 )t
group by month order by month ;


-- 4.What is the closing balance for each customer at the end of the month?
select customer_id, EOMONTH(txn_date) as month_end , sum(txn_amount) as closing_balance from 
customer_transactions 
 group by customer_id, EOMONTH(txn_date) ;


 -- 5.What is the percentage of customers who increase their closing balance by more than 5%?
 SELECT a.customer_id , a.month as curr_month , a.closing_balance as curr_balance ,
 b.closing_balance as next_curr_balance , 
  CASE 
        WHEN b.closing_balance IS NOT NULL 
             AND a.closing_balance <> 0
             AND ((b.closing_balance - a.closing_balance) * 100.0 / a.closing_balance) > 5
        THEN 'YES'
        ELSE 'NO'
    END AS is_5_percent_increase
 FROM (
 select customer_id , EOMONTH(txn_date) as month, 
 sum(
 case 
    when txn_type ='deposit' then txn_amount
    else -txn_amount
 end
 ) as closing_balance
 from customer_transactions 
 group by customer_id , EOMONTH(txn_date)) a
 inner join 
 (select customer_id , EOMONTH(txn_date) as month, 
 sum(
 case 
    when txn_type ='deposit' then txn_amount
    else -txn_amount
 end
 ) as closing_balance
 from customer_transactions 
 group by customer_id , EOMONTH(txn_date)) b 
 on a.customer_id = b.customer_id
 AND b.month = EOMONTH(DATEADD(MONTH, 1, a.month));

