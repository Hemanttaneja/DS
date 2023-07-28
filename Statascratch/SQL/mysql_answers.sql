-- Q - Most profitable companies
-- https://platform.stratascratch.com/coding/10354-most-profitable-companies?code_type=3
select company
, sum(profits) as profit
from forbes_global_2010_2014
group by 1
order by 2 desc
limit 3;

-- Q - Activity Rank
-- https://platform.stratascratch.com/coding/10351-activity-rank?code_type=3
select from_user
, count(distinct id) as total_emails
, ROW_NUMBER() over(order by count(distinct id) desc, from_user asc)
from google_gmail_emails
group by 1;

-- Q - Apple Product Count
-- https://platform.stratascratch.com/coding/10141-apple-product-counts?code_type=3
select language
, COUNT( DISTINCT CASE WHEN
    device in ('macbook pro', 'iphone 5s', 'ipad air')
    THEN pu.user_id ELSE NULL END) as n_apple_users
, count(distinct pu.user_id) as n_total_users
from playbook_users as pu
inner join playbook_events as uud
using(user_id)
group by 1
order by 3 desc;

-- Q - Election Results
-- https://platform.stratascratch.com/coding/2099-election-results?code_type=3
with vote_cnt as (select voter
, 1/count(distinct candidate) as total_votes_contri
from voting_results
where candidate is not null
group by 1)

select candidate
from
(select candidate
, dense_rank() over(order by sum(round(total_votes_contri,3)) desc, candidate) as dns_rnk
from voting_results
left join vote_cnt using (voter)
where candidate is not null
group by 1) x
where dns_rnk = 1

-- Q - Find students with median writin score
-- https://platform.stratascratch.com/coding/9610-find-students-with-a-median-writing-score/discussion?code_type=3

WITH cte1 as(select student_id
, sat_writing
, rank() over(order by sat_writing asc) as rnk
from sat_scores)

, cte2 as (
select
student_id
, floor(count(*)/2) as median_value
from cte1
)

select cte1.student_id from 
cte1 inner join
cte2 on cte1.rnk = cte2.median_value

-- Q - workers with the highest salaries
-- https://platform.stratascratch.com/coding/10353-workers-with-the-highest-salaries?code_type=3

select
distinct worker_title
from
(select worker_id 
, worker_title
, dense_rank() over(order by salary desc) as dns_rnk
from worker
inner join title
on worker.worker_id = title.worker_ref_id) x
where dns_rnk = 1

-- Q - Salaries differences
-- https://platform.stratascratch.com/coding/10308-salaries-differences/discussion?code_type=3
select 
abs(max(case when department = 'marketing'
then salary else 0 end) - 
max(case when department = 'engineering'
then salary else 0 end)) as salary_difference
from db_employee
join db_dept 
on db_employee.department_id = db_dept.id;

-- Q - Monthly percentage difference
-- https://platform.stratascratch.com/coding/10319-monthly-percentage-difference/discussion?code_type=3
select DATE_FORMAT(created_at,'%Y-%m') AS ym
, round(((sum(value) - lag(sum(value),1) over())/lag(sum(value),1) over())*100,2) as revenue_diff_pct
from sf_transactions
group by 1
order by 1





