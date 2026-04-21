# 🏥 Healthcare SQL Analysis
<p align="center">
  <img src="https://images.openai.com/static-rsc-4/EWep00gspYi67Ka-AYn4OyZi8OpbI5OzLIvI-JTkJTFM6h3DUwNWREizsxf4okmV_Z_rIl50S9A5lhFlxmx5FnqGHlTk0p9WlwMDlTFHSOaxnV3VhqhvNztGFeX3cQco-TTTLCXv-WXrH9kDq83FjOdV-t_IroTzmhujabVTiwNfAAGxGtiWVTsdeA_G0fBR?purpose=fullsize" alt="project banner" width="1000"/>
</p>

<p>
   <img src="https://img.shields.io/badge/SQL-MySQL-blue?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Project-Healthcare-green?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge"/>
   <a href="https://www.linkedin.com/in/reshma-m-2605082ab">
    <img src="https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge"/>
  </a>
</p>

---

## 📌 Overview

This project analyzes healthcare data including patients, doctors, appointments, and billing using SQL to derive meaningful insights.

---

## Database Schema

```sql
create table patients (
    patient_id varchar(10),
    first_name varchar(50),
    last_name varchar(50),
    gender varchar(10),
    date_of_birth date
);
```
* These tables connect patients, doctors, and appointments.

---

## 📊 Basic Analysis

### Total Patients

```sql
select count(*) as total_patients from patients;
```
*  total number of patients: 50.

---
## 💰 Revenue Analysis

### Total Revenue

```sql
select sum(amount) as total_revenue
from billing
where payment_status = 'paid';
```
*  total revenue from paid bills: 173424.90.

---

## 👨‍⚕️ Doctor Analysis

### view for doctor performance (appointments count)

```sql
create view doctor_performance as select doctor_id, count(*) as total_appointments
from appointments group by doctor_id;
```
* creates views of the performance of doctors as a new table we can access wit easily.

---

## 📅 Appointment Trends

### Busiest Day

```sql
select dayname(appointment_date) as day, count(*) as total
from appointments
group by day
order by total desc
limit 1;
```
* Shows peak hospital activity on Wednesday	with 37 appointments.

---

## ⚡ Advanced SQL (Window Functions)

### Rank Doctors

```sql
select d.first_name,
count(a.appointment_id) as total,
rank() over(order by count(a.appointment_id) desc) as rank_position
from doctors d
join appointments a on d.doctor_id = a.doctor_id
group by d.first_name;
```
* Ranks doctors based on workload here Sarah ranks 1st with 46 counts of appointments.

---

### Consecutive Visits

```sql
select patient_id, appointment_date
from (
    select patient_id, appointment_date,
    lag(appointment_date) over(partition by patient_id order by appointment_date) as prev_date
    from appointments
) t
where datediff(appointment_date, prev_date) = 1;
```
* Detects patient number P005 visited on 2023-01-13.

---

## 📂 Project Files

* schema.sql → table creation
* queries.sql → all queries

---

## 🎯 Conclusion

This project demonstrates practical SQL skills applied to real-world healthcare data analysis.
