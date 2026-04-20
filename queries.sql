-- 1. Count total patients
SELECT COUNT(*) FROM patients;

-- 2. How many male vs female patients
select  gender,count(gender) from patients group by gender;

-- 3. Find top 5 oldest patients
select * from patients order by date_of_birth asc limit 5;

-- 4. How many doctors per specialization?
select specialization,count(*) from doctors group by specialization;

-- 5. Number of appointments by status
select status,count(*) from appointments group by status;

-- 6. List all appointments with: patient name,doctor name,date
select p.first_name,d.first_name,a.appointment_date from patients p join appointments a on p.patient_id=a.patient_id join doctors d on a.doctor_id=d.doctor_id;

-- 7. Find total number of appointments per doctor
select d.first_name,count(a.appointment_id) as apntmnt from doctors d join appointments a on d.doctor_id=a.doctor_id group by d.first_name;

-- Which doctor has the most appointments?
select d.first_name,count(a.appointment_id)  as count from doctors d join appointments a on d.doctor_id=a.doctor_id 
group by d.first_name order by count desc limit 1;

-- 8. Find total revenue generated (from billing)
select sum(amount) as revenue from billing where payment_status='paid';

-- 9. Find total revenue per patient
select patient_id, sum(amount) as revenue from billing where payment_status='paid' group by patient_id ;

-- 10. Find most common treatment type
select treatment_type,count(*) as ct from treatments group by treatment_type order by ct desc limit 1;

-- 11. Average treatment cost per type
select treatment_type,avg(cost) from treatments group by treatment_type;

-- 12. Find patients who had more than 3 appointments
select patient_id,count(appointment_id) as apt from appointments group by patient_id having apt >3;

-- 13. Find monthly number of appointments
select  monthname(appointment_date) as months,count(appointment_id) as apntmnt from 
appointments group by months ;

-- 14. Find the doctor who generated the highest revenue
select d.first_name,sum(t.cost) as revenue from doctors d join appointments a 
on d.doctor_id=a.doctor_id join treatments t on a.appointment_id=t.appointment_id group by d.first_name order by revenue desc limit 1;

-- 15. Rank doctors based on number of appointments
select d.first_name,count(a.appointment_id) as count_appntmnt,rank() 
over(order by count(a.appointment_id) desc) as rnk from doctors d join appointments a on d.doctor_id=a.doctor_id group by d.doctor_id,d.first_name;

-- 16. Find top 3 highest paying patients
select patient_id, sum(amount) as revenue from billing where payment_status='paid' group by patient_id order by revenue desc limit 3;

-- 17. Find patients who never had any appointments
select p.patient_id,p.first_name,p.last_name from patients p left join appointments a on p.patient_id=a.patient_id where a.appointment_id is NULL ;

-- Find average gap between appointments for each patient
select patient_id,avg(gap_days) AS gapdays from (
    select patient_id,datediff(appointment_date,lag(appointment_date) over (partition by patient_id order by appointment_date)) as gap_days from appointments) t
group by patient_id;

-- 18. Find busiest day of the week for hospital
select dayname(appointment_date) as days ,count(appointment_id)as cnt from appointments group by days order by cnt desc limit 1;

-- 19. Find patients who visited more than once in the same month
select  p.patient_id,p.first_name,monthname(a.appointment_date) as months,count(appointment_id) as apntmnt from patients p join 
appointments a on p.patient_id=a.patient_id  group by p.patient_id,months having apntmnt>1 ;

-- 20. Find doctors who handled above-average number of appointments
select doctor_id,count(appointment_id)  as count from  appointments 
group by doctor_id having count(count) >(select avg(app) as avrg from (select doctor_id,count(*)
 as app from appointments group by doctor_id)  t ) ;

-- 21. Find monthly revenue trend
select monthname(bill_date)as months,sum(amount) from billing group by months;

-- 22. Find treatments where cost is greater than average cost
select treatment_id,treatment_date,cost from treatments where cost >(select avg(cost) from treatments);

-- 23. Total money spent by each patient + rank them
select patient_id ,sum(amount) as spend,rank() over(order by sum(amount)  desc) as rnk from billing group by patient_id;

-- 25. Find doctors who had zero appointments
select doctor_id ,count(appointment_id) as cnt from appointments group by doctor_id having cnt=0  ;

-- 26. Patients with above-average appointments
select patient_id,count(appointment_id) as total from appointments group by patient_id having total>
( select avg(cnt) from(select patient_id,count(appointment_id) as cnt from appointments group by patient_id) as t);

-- 27. Treatments with cost above average
select * from treatments where cost >(select avg(cost) from treatments);

-- 28. Patients spending more than average total billing
select patient_id,sum(amount) as total from appointments group by doctor_id having total<
( select avg(cnt) from(select doctor_id,count(appointment_id) as cnt from appointments group by doctor_id) as t);

-- 30. max appointments done by any doctor
select doctor_id,max(cnt) as max_ap from  
(select doctor_id,count(appointment_id)as cnt  from  appointments group by doctor_id) as t group by doctor_id  ;

-- 31. Doctors with above-average appointments
select doctor_id,count(appointment_id) as total from appointments group by doctor_id having total>
( select avg(cnt) from(select doctor_id,count(appointment_id) as cnt from appointments group by doctor_id) as t);

-- 32. Patients with highest spending
select patient_id,sum(amount) as max_amnt from billing group by patient_id having max_amnt=(select max(total) from
(select sum(amount) as total from billing group by patient_id) as t);

-- 33. Appointments where cost > avg cost for that doctor
select a.appointment_id,t.cost,a.doctor_id from appointments a join treatments t on a.appointment_id=t.appointment_id 
where t.cost>(select avg(t2.cost) from appointments a2 join 
treatments t2 on a2.appointment_id=t2.appointment_id where a2.doctor_id=a.doctor_id);

-- 34. Patients with more appointments than patient 'P101'
select patient_id ,count(appointment_id) as cnt from appointments group by patient_id having cnt >
(select count(*) from appointments where patient_id='P001');

-- 35. Find doctors who generated more revenue than average doctor
select a.doctor_id,sum(b.amount) as revenue from appointments a join billing b
on a.patient_id=b.patient_id  group by a.doctor_id having revenue >
(select avg(revenue) as bill from (select a.doctor_id,sum(b.amount) as revenue from appointments a join billing b
on a.patient_id=b.patient_id group by a.doctor_id )t);

-- 36. Find appointment days where total appointments are above average daily appointments
select appointment_date,count(appointment_id) as cnt from appointments group by appointment_date having cnt >
(select avg(new) from (select appointment_date,count(appointment_id) as new
from appointments group by appointment_date)t);

-- 34. Find doctors who handled more patients than any single doctor in a specific branch
select d.doctor_id,count(distinct a.patient_id) as cnt from doctors d join appointments a 
on d.doctor_id=a.doctor_id
 group by d.doctor_id having cnt>=
(select max(c) from (select d.doctor_id,count(distinct a.patient_id) as c from doctors d join 
appointments a on d.doctor_id=a.doctor_id 
where specialization='Pediatrics'
group by d.doctor_id)t) ;

 -- 35. Which doctor performs which treatment most
select doctor_id, treatment_type, cnt from (select a.doctor_id,t.treatment_type,count(*) as cnt,
rank() over(partition by a.doctor_id order by count(*) desc) as rnk
from appointments a join treatments t on a.appointment_id = t.appointment_id
group by a.doctor_id, t.treatment_type) x where rnk = 1;

-- 36. Find which hour of the day has most appointments
select hour(appointment_time) as hr,count(*) as total from appointments
group by hr order by total desc limit 1;

-- 37. Find patients who visited on consecutive days
select patient_id, appointment_date from (select patient_id,appointment_date,
lag(appointment_date) over(partition by patient_id order by appointment_date) as prev_date from appointments) t
where datediff(appointment_date, prev_date) = 1;

-- 38. percentage of paid vs unpaid bills
select payment_status,round(count(*) * 100.0 / (select count(*) from billing), 2) as percentage
from billing group by payment_status;

-- 39. create a view for doctor performance (appointments count)
create view doctor_performance as select doctor_id, count(*) as total_appointments
from appointments group by doctor_id;

-- 40. create index on patient_id in appointments
create index idx_patient_id on appointments(patient_id);
