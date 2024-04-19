--  Data Cleaning
use customer_behaviors;
-- check duplicate value
select user_id,
       item_id,
       time_stamp
from userbehavior
group by 1, 2, 3
having count(*) >1;

-- delete duplicate value
alter table userbehavior
    add column id int primary key auto_increment;

set SQL_SAFE_UPDATES= 0;

delete from userbehavior
where id in
      (select id from
          (select
               id,
               user_id,
               item_id,
               time_stamp,
               row_number() over(partition by user_id, item_id, time_stamp) as duplicates
           from userbehavior) t
       where duplicates > 1);

-- check if there is missing value
select * from userbehavior
where user_id is null
   or item_id is null
   or category_id is null
   or behavior_type is null
   or time_stamp is null;

-- timestamp conversion
select hour(from_unixtime(time_stamp+0)),
       count(*)
from userbehavior
group by 1
order by 1;

set timezone = "+08:00";
select hour(from_unixtime(time_stamp+0)),
       count(*)
from userbehavior
group by 1
order by 1;

select date_format(from_unixtime(time_stamp), '%Y-%m-%d'),
       count(*)
from userbehavior
group by 1
order by 1;

alter table userbehavior
    add dates varchar(255);
update userbehavior
set dates = from_unixtime(time_stamp, '%Y-%m-%d');

alter table userbehavior
    add column hours varchar(255);
update userbehavior
set hours = hour(from_unixtime(time_stamp+0));

alter table userbehavior
    add column date_time varchar(255);
update userbehavior
set date_time = from_unixtime(time_stamp);

select dates, count(*) from userbehavior
group by 1
order by 1;

-- number of distinct user
select count(distinct user_id) from userbehavior;

drop view if exists behavior;
create view behavior as
with base as
         (
             select
                 user_id,
                 date_time,
                 dates,
                 hours,
                 behavior_type
             from userbehavior
         )
select
    user_id,
    date_time,
    dates,
    hours,
    case when behavior_type = 'pv' then 1 else 0 end as 'pv',
    case when behavior_type = 'fav' then 1 else 0 end as 'fav',
    case when behavior_type = 'cart' then 1 else 0 end as 'cart',
    case when behavior_type = 'buy' then 1 else 0 end as 'buy'
from base;

select
    sum(pv) as awareness,
    sum(fav) + sum(cart) as interest,
    sum(buy) as purchase
from behavior;

drop view if exists purchase;
create view purchase as
select user_id,
       date_time,
       buy,
       rank() over (partition by user_id order by date_time) as buy_rank
from behavior
where buy = 1
order by user_id,date_time;


select sum(buy) as repeat_purchase from purchase
where buy_num > 1;

-- conversion rate at different time_slot

select hours,
       sum(pv) as a,
       sum(fav+cart) as i,
       round((sum(fav+cart)/sum(pv))*100,2) as a_i_conversion
from behavior
group by 1
order by 4 desc;

drop view if exists num_by_category;
create view num_by_category as
select
    category_id
     , sum(case when behavior_type = 'pv' then 1 else 0 end) as pv_num
     , sum(case when behavior_type = 'fav' or behavior_type = 'cart' then 1 else 0 end) as interest_num
     , round((sum(case when behavior_type = 'fav' or behavior_type = 'cart' then 1 else 0 end)/sum(case when behavior_type = 'pv' then 1 else 0 end))*100, 2) as a_i_conversion
from userbehavior
group by 1
order by 2 desc;

select * from num_by_category;
select count(distinct item_id) from userbehavior;


-- check top 200 viewd item inner join top 500 (200)liked item ,only 63(15) item
select count(*) from
    (select item_id,
            count(*) as pv_num
     from userbehavior
     where behavior_type = 'pv'
     group by 1
     order by 2 desc
     limit 500) m
        inner join
    (select item_id,
            count(*) as like_num
     from userbehavior
     where behavior_type = 'fav' or behavior_type ='cart'
     group by 1
     order by 2 desc
     limit 500) n
    on m.item_id = n.item_id;

-- average re-purchase time
-- average re-purchase day_interval for all
with user_day_interval as
         (
             select
                 a.user_id
                  , a.date_time as a_time
                  ,a.buy_rank as a_rank
                  ,b.date_time as b_time
                  ,b.buy_rank as b_rank
                  ,datediff(b.date_time, a.date_time) as day_interval
             from purchase a
                      left join purchase b
                                on a.user_id = b.user_id and a.buy_rank = b.buy_rank -1
         )
select avg(average_day_interval) as avg_all
from
    (select user_id,
            avg(day_interval) as average_day_interval
     from user_day_interval
     group by 1) t;

drop view if exists cohort_user;
create view cohort_user as
select date(date_time) as buy_date, user_id from purchase
where buy_rank =1
order by 1;
select * from cohort_user;


-- ------ average active days by cohort, (actually cohort analysis not so fit this case)
drop view if exists cohort_active_days;
create view cohort_active_days as
(
with first_buy as
         (select
              user_id
               , date_time as first_date
          from purchase
          where buy_rank = 1),
     last_buy as
         (select
              user_id
               , max(date_time) as last_date
          from purchase
          where buy_rank > 1
          group by 1)
select t.buy_date, avg(t.day_interval) cohort_avg
from (
         select c.*
              ,f.first_date
              ,l.last_date
              ,datediff(l.last_date, f.first_date) as day_interval
         from cohort_user c
                  left join first_buy f
                            on c.user_id = f.user_id
                  left join last_buy l
                            on f.user_id = l.user_id
         group by 1, 2,3, 4
         order by 1)t
group by 1
    );
select avg(cohort_avg) from cohort_active_days;
select * from cohort_active_days;


-- I_P conversion,
-- categorize customer into high-purchase and medium-low-purchase
drop view if exists user_feature;
create view user_feature as
select
    user_id
     ,sum(pv) as total_pv
     ,sum(fav) + sum(cart) as fav_cart
     ,sum(buy) as total_buy
     ,ifnull((sum(fav) + sum(cart))/sum(pv), 0) as fav_cart_rate
     ,sum(buy)/(sum(pv)+ sum(fav) + sum(cart)) as purchase_rate
     ,dense_rank() over(order by sum(buy)/(sum(pv)+ sum(fav) + sum(cart)) desc) as purchase_rate_rk
from behavior
group by 1;

select * from user_feature;

-- for high-purhcase customer top 20% rank
select
    avg(total_pv)
     ,avg(fav_cart)
     ,avg(total_buy)
     ,avg(fav_cart_rate)
from user_feature
where purchase_rate_rk <= 67;

-- for low-purchase customer bottom 20% rank
select
    avg(total_pv)
     ,avg(fav_cart)
     ,avg(total_buy)
     ,avg(fav_cart_rate)
from user_feature
where purchase_rate_rk > 270;


-- category concentration between the two group of customers
select count(distinct category_id) from userbehavior
where behavior_type = 'buy'
  and user_id in (select user_id from user_feature where purchase_rate_rk <= 67);

select count(distinct category_id) from userbehavior
where behavior_type = 'buy'
  and user_id in (select user_id from user_feature where purchase_rate_rk >270);


-- RFM analysis
select user_id, datediff('2021-12-03' ,max_date) as R from
    (select user_id, max(date_time) as max_date from purchase
     group by 1) t;

select
    user_id
     , sum(fav) + sum(cart) as F
     , sum(buy)  as M
from behavior
group by 1;

drop view if exists RFM;
create view RFM as
select q.user_id
     , ifnull(p.R,0) R
     , F
     , M
from
    (select user_id, datediff('2021-12-03' ,max_date) as R from
        (select user_id, max(date_time) as max_date from purchase
         group by 1) t) p
        right join
    (select
         user_id
          , sum(fav) + sum(cart) as F
          , sum(buy)  as M
     from behavior
     group by 1) q
    on p.user_id = q.user_id;
select * from RFM;
select avg(R), AVG(F), AVG(M) from RFM;

drop view if exists user_rfm;
create view user_rfm as
select user_id,
       case
           when R < 2.7422 and F > 8.3316 and M > 2.1373 then 'Key Value User'
           when R < 2.7422 and F > 8.3316 and M < 2.1373 then 'General Value User'
           when R < 2.7422 and F < 8.3316 and M > 2.1373 then 'Key Development User'
           when R < 2.7422 and F < 8.3316 and M < 2.1373 then 'General Development User'
           when R > 2.7422 and F > 8.3316 and M > 2.1373 then 'Key Re-engagement User'
           when R > 2.7422 and F > 8.3316 and M < 2.1373 then 'General Re-engagement User'
           when R > 2.7422 and F < 8.3316 and M > 2.1373 then 'Key Retention User'
           when R > 2.7422 and F < 8.3316 and M < 2.1373 then 'General Retention User'
           end as user_type
from RFM;

select user_type, count(user_id) as customer_num, concat(round((count(user_id)/983)*100, 2), '%') as ratio
from user_rfm
group by 1;
