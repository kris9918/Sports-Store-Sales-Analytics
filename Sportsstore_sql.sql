-- 1.KPIs for Total Revenue, Profit, number of orders,profit of margin

select 
		SUM(revenue) as total_revenue,
		sum(profit) as total_profit,
		count(*) as total_order,
		SUM(profit)/SUM(revenue)*100.0 as profit_margin
from orders

-- 2. 1.KPIs for Total Revenue, Profit, number of orders,profit of margin for each sports

select 
		sport,
		round(SUM(revenue),2) as total_revenue,
		round(sum(profit),2) as total_profit,
		count(*) as total_order,
		SUM(profit)/SUM(revenue)*100.0 as profit_margin
from orders
group by sport
order by profit_margin desc

-- 3. customer ratings

select 
		(select count(*) from orders where rating is not null) as number_of_reviews
	,	round(avg(rating),2) as average_rating
from 
	orders

-- 4. number of people for each rating and its revenue, profit, profit margin

select 
		rating
	,	SUM(revenue) as total_revenue
	,	SUM(profit) as total_profit
	,	SUM(profit)/SUM(revenue) * 100.0 as profit_margin
from 
	orders
where 
	rating is not null
group by 
	rating
order by 
	rating desc

-- 5. state revenue, profit and profit margin

select
		c.state
	,	ROW_NUMBER() over(order by sum(o.revenue) desc) as revenue_rank
	,	SUM(o.revenue) as total_revenue
	,	ROW_NUMBER() over(order by sum(o.profit) desc) as profit_rank
	,	SUM(o.profit) as total_profit
	,	ROW_NUMBER() over(order by SUM(o.profit)/SUM(o.revenue) desc) as profit_margin_rank
	,	SUM(o.profit)/SUM(o.revenue) * 100.0 as profit_margin
from 
	orders o
join
	customers c 
on 
	o.customer_id = c.customer_id
group by 
	c.State
order by
	total_profit desc

-- 6.monthy profit
with monthly_profit as(
		select
				month(date) as month
			,	sum(profit) as total_profit
		from 
			orders
		group by 
			month(date)
			)
select
		month
	,	total_profit
	,	lag(total_profit) over (order by month) as previous_month_profit
	,	total_profit - lag(total_profit) over (order by month) as profit_diff
from
	monthly_profit
order by
	month
