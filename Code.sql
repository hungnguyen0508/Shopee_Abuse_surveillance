
----- customers and sellers collaborate: 
with combination as
(select *, concat(shop_owner_uid,uid) as combination from dbo.transaction_data
where gmv<=1000) 
select shop_owner_uid, combination,count(combination) as number from combination group by shop_owner_uid,combination 
order by number DESC; 

-- close purchasing interval 

with gap as (select uid, 
       order_id,
	   txn_time, 
	   row_number() over (partition by uid order by txn_time) as ranking,
	   lag(txn_time,1) over (partition by uid order by txn_time) as before
from dbo.transaction_data),
gap0 as 
(select uid,order_id,datediff("s",before,txn_time) as gap 
from gap
where before is not null) 
select uid, count(uid) as number_orders_at_same_time 
from gap0
where gap<=60
group by uid
order by count(uid) desc; 