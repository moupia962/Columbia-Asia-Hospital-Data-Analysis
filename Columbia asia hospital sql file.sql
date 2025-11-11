SELECT 
 `Doctor Name`,
    COUNT(DISTINCT patient_id) AS patient_count,
    SUM(`Total Bill`) AS total_revenue
 FROM columbia_hospital.`doctor_patients_data`
 GROUP BY 
    `Doctor Name`
ORDER BY 
    total_revenue DESC, 
    patient_count ASC
    limit 5 ;
    
    
with abc as(
select department_referral as department,mid(date,04,02) as month,avg(patient_waittime) as avg_waittime from columbia_hospital.`hospital er (1)` group by 1,2 )
,bcd as(
select *,lag(avg_waittime,1)over(partition by department order by month asc) as prev_waittime,
lag(avg_waittime,2)over(partition by department order by month asc) as prev_prev_waittime from abc)
,cde as(
select *,case when
avg_waittime>prev_waittime and prev_waittime>prev_prev_waittime then "yes" else "no"
end as decision from bcd)
select * from cde where decision="yes"



with doctor_patients as(
select `doctor id`,sum(case when patient_gender='m' then 1 else 0 end)/sum(case when patient_gender='f' then 1 else 0 end) as ratio from
columbia_hospital.`doctor_patients_data` a join columbia_hospital.`hospital er (1)` b on a.patient_id=b.patient_id
group by 1)

select *,dense_rank()over(order by ratio desc) as `rank` from doctor_patients;



select `Doctor Name` ,
round(avg(case when patient_sat_score="" then 4.99 else patient_sat_score end),2) as avg_score from columbia_hospital.`hospital er (1)`
a join columbia_hospital.`doctor_patients_data` b on a.patient_id=b.patient_id group by 1 
order by avg(case when patient_sat_score="" then 4.99 else patient_sat_score end) desc;

select `Doctor Name`,group_concat(patient_race) as diverse_race from columbia_hospital.`hospital er (1)`
a join columbia_hospital.`doctor_patients_data` b on a.patient_id=b.patient_id
group by 1 having count(distinct patient_race)>1


select `Doctor Name`,count(distinct patient_race) as races_count from columbia_hospital.`hospital er (1)`
a join columbia_hospital.`doctor_patients_data` b on a.patient_id=b.patient_id
group by 1 having count(distinct patient_race)>1  order by count(distinct patient_race) desc;



select a.department_referral as department,sum(case when patient_gender="m" then `Total Bill` else 0 end)/sum(case when patient_gender="f" then `total bill` else 0 end)
as ratio_of_total_bills from columbia_hospital.`hospital er (1)`
a join columbia_hospital.`doctor_patients_data` b on a.patient_id=b.patient_id
group by a.department_referral;


SET SQL_SAFE_UPDATES = 0;

UPDATE columbia_hospital.`hospital er (1)`
SET patient_sat_score = LEAST(patient_sat_score + 2, 10)
WHERE department_referral = "General Practice" 
  AND patient_waittime > 30;

SET SQL_SAFE_UPDATES = 1;


SELECT `Doctor ID` ,`Doctor Name` , COUNT(DISTINCT department_referral) as dept_count
FROM columbia_hospital.`doctor_patients_data`
GROUP BY 1,2;






