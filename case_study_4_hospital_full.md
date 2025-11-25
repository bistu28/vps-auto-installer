# Case Study 4 Hospital Full

```text
IV. CASE STUDY 4

Hospital Patient & Appointment Scheduling :

Table 4: Schema Details-

SOLUTION-

CREATE DATABASE Hospital_management_case4;
USE Hospital_management_case4;



--- Doctors Table
CREATE TABLE Doctors ( 
doctor_id INT PRIMARY KEY, doctor_name VARCHAR(100), 
specialty VARCHAR(100), hire_date DATE
);

--- Patients Table
CREATE TABLE Patients ( 
patient_id INT PRIMARY KEY, 
patient_name VARCHAR(100),
birth_date DATE,
city VARCHAR(100)
);
--- Appointments Table
CREATE TABLE Appointments ( 
appointment_id INT PRIMARY KEY, patient_id INT,
doctor_id INT, appointment_date DATETIME, 
status VARCHAR(50),
reason VARCHAR(255),
FOREIGN KEY (patient_id) REFERENCES Patients(patient_id), 
FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

--- Treatments Table
CREATE TABLE Treatments ( 
treatment_id INT PRIMARY KEY, 
patient_id INT, doctor_id INT,
treatment_cost DECIMAL(10,2),
FOREIGN KEY (patient_id) REFERENCES Patients(patient_id), 
FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

// inserting values in tables

INSERT INTO Doctors VALUES
(1, 'Dr. Bistu Paul', 'Cardiology', '2020-05-10'),
(2, 'Dr. Rajesh Verma', 'Dermatology', '2021-02-14'),
(3, 'Dr. Sneha Das', 'Pediatrics', '2022-09-05'),
(4, 'Dr. Kunal Roy', 'Orthopedics', '2019-07-23');

INSERT INTO Patients VALUES
(1, 'Sahil Mehta', '2010-04-22', 'Kolkata'),
(2, 'Priya Sinha', '1995-09-12', 'Siliguri'),
(3, 'Ravi Das', '1988-06-15', 'Mumbai'),
(4, 'Meera Nair', '2007-02-18', 'Delhi'),
(5, 'Rohan Gupta', '1978-11-03', 'Kolkata');

INSERT INTO Appointments VALUES
(101, 1, 3, '2025-10-01 10:00:00', 'Completed', 'Routine Checkup'),
(102, 2, 1, '2025-10-05 11:00:00', 'Completed', 'Heart Checkup'),
(103, 3, 4, '2025-09-20 14:00:00', 'Missed', 'Back Pain'),
(104, 4, 3, '2025-10-08 09:30:00', 'Completed', 'Annual Checkup'),
(105, 5, 2, '2025-10-12 13:00:00', 'Cancelled', 'Skin Issue');
INSERT INTO Treatments VALUES 
(201, 2, 1, 5000.00),
(202, 3, 4, 2000.00),
(203, 5, 2, 3000.00),
(204, 1, 3, 1500.00);



Q-1 Doctor Specialization Load: Count the total number of 'Completed' appointments for 
each specialty.

SELECT 
    d.specialty, 
    COUNT(a.appointment_id) AS completed_appointments
FROM Appointments a
JOIN Doctors d 
    ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed'
GROUP BY d.specialty;



Q-2 High-Cost Patients: Find the patient_name and the total cumulative treatment_cost for the top 5 patients with the highest costs.

SELECT 
    p.patient_name, 
    SUM(t.treatment_cost) AS total_cost
FROM Treatments t
JOIN Patients p 
    ON t.patient_id = p.patient_id
GROUP BY p.patient_name
ORDER BY total_cost DESC LIMIT 5;


Q-3 Patient Age Group: Calculate the average number of appointments for patients who are under 18 years old. (Requires calculating age from birth_date).

SELECT 
    AVG(appointment_count) AS avg_appointments_under_18 
FROM (
    SELECT 
        p.patient_id, 
        COUNT(a.appointment_id) AS appointment_count
    FROM Patients p 
    JOIN Appointments a 
        ON p.patient_id = a.patient_id
    WHERE TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) < 18
    GROUP BY p.patient_id
) AS subquery;



Q-4 Doctor Appointment Gap: List the doctor_name and the maximum number of consecutive days they went without an appointment in the last year. (This is a complex gap analysis problem).

SELECT 
    doctor_name, MAX(gap_days) AS max_consecutive_gap 
FROM (
    SELECT 
        d.doctor_name,
        DATEDIFF( LEAD(a.appointment_date) 
                OVER (PARTITION BY a.doctor_id ORDER BY a.appointment_date),
            a.appointment_date
        ) AS gap_days
    FROM Appointments a
    JOIN Doctors d 
        ON a.doctor_id = d.doctor_id
    WHERE YEAR(a.appointment_date) = YEAR(CURDATE())) AS gap
GROUP BY doctor_name;



Q-5 Appointment Cancellation Rate: Calculate the percentage of appointments that have a status of 'Missed' or 'Cancelled' for the current month.

SELECT 
    (SUM(CASE 
            WHEN status IN ('Missed', 'Cancelled') 
            THEN 1 ELSE 0 
         END) / COUNT(*)) * 100 AS cancellation_rate
FROM Appointments
WHERE MONTH(appointment_date) = MONTH(CURDATE())
  AND YEAR(appointment_date) = YEAR(CURDATE());



Q-6 Doctor's First Appointment: Find the doctor_name and the date of their very first 
appointment (earliest appointment_date) recorded after their hire_date.

SELECT 
    d.doctor_name, MIN(a.appointment_date) AS first_appointment
FROM Appointments a
JOIN Doctors d 
    ON a.doctor_id = d.doctor_id
WHERE a.appointment_date > d.hire_date
GROUP BY d.doctor_name;



Q-7 Treatment-Awaiting Patients: Identify patient_names who have had a 'Completed' appointment with the reason 'Annual Checkup' but have no corresponding entry in the Treatments table.

SELECT DISTINCT 
    p.patient_name
FROM Appointments a
JOIN Patients p 
    ON a.patient_id = p.patient_id
WHERE a.status = 'Completed'
  AND a.reason = 'Annual Checkup'
  AND p.patient_id NOT IN (
        SELECT patient_id 
        FROM Treatments
     );



Q-8 City Patient Count: Find all city names that have more than 100 registered patients.

SELECT 
    city, COUNT(*) AS patient_count
FROM Patients
GROUP BY city
HAVING COUNT(*) > 100;

Q-9 Sequential Misses: List the patient_names who have two or more consecutive appointments marked with the status 'Missed'.

SELECT DISTINCT 
    p.patient_name
FROM (
    SELECT 
        a.patient_id,
        LAG(status) OVER (
            PARTITION BY a.patient_id 
            ORDER BY a.appointment_date
        ) AS prev_status,
        a.status
    FROM Appointments a
) AS sub
JOIN Patients p 
    ON p.patient_id = sub.patient_id
WHERE sub.status = 'Missed' 
  AND sub.prev_status = 'Missed';




Q-10 Revenue by Doctor: Calculate the total treatment_cost generated through treatments performed by each doctor_name.

SELECT 
    d.doctor_name, 
    SUM(t.treatment_cost) AS total_revenue
FROM Treatments t
JOIN Doctors d 
    ON t.doctor_id = d.doctor_id
GROUP BY d.doctor_name;






- - - - - - - - - - - - - - - - - - - - - - - - -
```
