create table Olympics (
	Code int, Name varchar, Gender varchar, Age int,
	NOC varchar, Country varchar, Discipline varchar,
	Sport varchar, Event varchar, Rank varchar, Medal varchar);
	
select * from Olympics;

-- Players receive the most medals
Select name, country, count(medal) total_medal
from Olympics where medal <> 'NA'
group by 1,2 order by total_medal desc;

-- Total number of plays within age gaps
Select Gender, min(age) Min_age, max(age) Max_age,
round(avg(age)) Avg_age,
sum(case when Age < 26 Then 1 end) "Age<26",
sum(case when Age >= 26 and Age <= 66 Then 1 end) "26>Age<66"
from Olympics group by Gender;

-- The maximum number players attend sport of each nation
with a1 as (select country, sport, count(sport) total_attendees from Olympics
		group by 1,2 order by total_attendees desc),
	 a2 as (select *, rank() over(partition by country order by total_attendees desc)
		from a1)
Select country, sport, total_attendees 
from a2 where rank <=1 order by total_attendees desc;

-- Nations receive different medals
Select country,
coalesce (bronze, 0) as bronze,
coalesce (gold, 0) as gold,
coalesce (silver, 0) silver,
(bronze+gold+silver) total_medal
from crosstab ('Select country, medal, count(medal) total
				from olympics where medal <> ''NA'' 
				group by 1,2 order by 1,2',
			  'values (''Bronze''), (''Gold''), (''Silver'')')
as pivot_result(country varchar, Bronze bigint, Gold bigint, Silver bigint)
order by bronze desc, gold desc, silver desc;





