# Case Study 2 University Full

```text
II. CASE STUDY 2

University Student & Course Management :

Table 2: Schema Details -

SOLUTION-

CREATE DATABASE university_student__course_management_case2;
USE university_student__course_management_case2;


-- Student Table 
CREATE TABLE students ( 
student_id INT PRIMARY KEY, 
first_name VARCHAR(50), 
last_name VARCHAR(50), 
major VARCHAR(50), 
gpa DECIMAL(4,2) -- allows 10.00 
); 
-- Courses Table 
CREATE TABLE courses ( 
course_id INT PRIMARY KEY, 
course_name VARCHAR(100), 
department VARCHAR(50), 
credit_hours INT, 
max_capacity INT 
); 
-- Professors Table 
CREATE TABLE professors ( 
prof_id INT PRIMARY KEY, 
prof_name VARCHAR(100), 
department VARCHAR(50) 
); 
-- Enrollments Table 
CREATE TABLE enrollments ( 
enrollment_id INT PRIMARY KEY, 
student_id INT, 
course_id INT, 
enrollment_date DATE, 
grade VARCHAR(2), 
FOREIGN KEY (student_id) REFERENCES students(student_id), 
FOREIGN KEY (course_id) REFERENCES courses(course_id) 
); 
-- Teaching Table 
CREATE TABLE teaching ( 
prof_id INT, 
course_id INT, 
PRIMARY KEY (prof_id, course_id), 
FOREIGN KEY (prof_id) REFERENCES professors(prof_id), 
FOREIGN KEY (course_id) REFERENCES courses(course_id) 
); 

// inserting values in tables
INSERT INTO students VALUES
(1, 'Aarav', 'Sharma', 'Computer Science', 3.8),
(2, 'Riya', 'Patel', 'Physics', 2.9),
(3, 'Kabir', 'Das', 'History', 1.9),
(4, 'Ananya', 'Roy', 'Physics', 3.5),
(5, 'Vihaan', 'Sen', 'Computer Science', 2.2),
(6, 'Bistu', 'Paul', 'Computer Science', 4.0);

INSERT INTO courses VALUES
(101, 'Advanced Data Structures', 'Computer Science', 4, 3),
(102, 'Quantum Mechanics', 'Physics', 3, 2),
(103, 'World History', 'History', 3, 2),
(104, 'Database Systems', 'Computer Science', 4, 4),
(105, 'Thermodynamics', 'Physics', 3, 2);

INSERT INTO professors VALUES 
(11, 'Dr. Das', 'Computer Science'), (12, 'Dr. Iyer', 'Physics'),
(13, 'Dr. Ghosh', 'History'), (14, 'Dr. Bose', 'Physics');

INSERT INTO teaching VALUES
(11, 101), (11, 104), (12, 102), (14, 105), (13, 103);

INSERT INTO enrollments VALUES 
(1, 1, 101, '2025-01-15', 'A'), (2, 2, 102, '2025-01-18', 'B'), 
(3, 3, 103, '2025-02-10', 'B'), (4, 1, 104, '2025-03-01', 'B'),
(5, 2, 105, '2025-03-03', 'A'), (6, 4, 102, '2025-03-05', 'A'),
(7, 4, 105, '2025-03-07', 'C'), (8, 5, 101, '2025-03-10', 'F'),
(9, 5, 104, '2025-03-12', 'D'), (10, 6, 103, '2025-03-15', 'B');




Q-1 Over-Capacity Check: Idenfy the course_names that are currently over capacity (where total enrollments > max_capacity).
SELECT
    c.course_id,
    c.course_name,
    c.max_capacity,
    COUNT(e.enrollment_id) AS total_enrolled
FROM Courses c
JOIN Enrollments e 
    ON c.course_id = e.course_id
GROUP BY 
    c.course_id, 
    c.course_name, 
    c.max_capacity
HAVING total_enrolled > c.max_capacity;



Q-2 Top Professor Load: Find the prof_name of the professor(s) who teach the highest number of unique courses.

SELECT 
    p.prof_name,
    COUNT(DISTINCT t.course_id) AS total_courses
FROM Professors p
JOIN Teaching t 
    ON p.prof_id = t.prof_id
GROUP BY 
    p.prof_id, 
    p.prof_name
HAVING total_courses = (
    SELECT MAX(course_count)
    FROM (
        SELECT COUNT(DISTINCT course_id) AS course_count
        FROM Teaching
        GROUP BY prof_id
    ) AS subquery
);


Q-3 Low Enrollment: List all course_names from the 'History' department that have zero enrollments.

SELECT
    c.course_name
FROM Courses c
LEFT JOIN Enrollments e
    ON c.course_id = e.course_id
WHERE c.department = 'History'
  AND e.enrollment_id IS NULL;



Q-4 Major GPA Leader: Find the highest gpa for students in each major and list the major and that max gpa.

SELECT
    major,
    MAX(gpa) AS highest_gpa
FROM Students
GROUP BY major;


Q-5 Student Course Count: List the first_name, last_name, and the total number of courses each student is enrolled in. Only show students enrolled in 3 or more courses.

SELECT
    s.first_name,
    s.last_name,
    COUNT(e.course_id) AS total_courses
FROM Students s
JOIN Enrollments e
    ON s.student_id = e.student_id
GROUP BY 
    s.student_id,
    s.first_name,
    s.last_name
HAVING total_courses >= 3;



Q-6 Grade Replacement: Update all 'F' grades in the Enrollments table to 'NC' (No Credit) for students with a gpa less than 2.0.

UPDATE Enrollments e 
JOIN Students s
    ON e.student_id = s.student_id
SET e.grade = 'NC'
WHERE e.grade = 'F' 
  AND s.gpa < 2.0;



Q-7 Department Enrollment: Calculate the total number of unique students enrolled in courses offered by the 'Physics' department.

SELECT
COUNT(DISTINCT e.student_id) AS total_students FROM Enrollments e
JOIN Courses c
ON e.course_id = c.course_id WHERE c.department = 'Physics';



Q-8 Credit Hour Requirement: Find the student_id and last_name of students who have completed more than 15 total credit_hours (based on courses they have a grade other than NULL).

SELECT
s.student_id, s.last_name,
SUM(c.credit_hours) AS total_credits FROM Students s
JOIN Enrollments e
ON s.student_id = e.student_id JOIN Courses c
ON e.course_id = c.course_id WHERE e.grade IS NOT NULL
GROUP BY s.student_id, s.last_name 
HAVING total_credits > 15;



Q-9 Full-Time Students: Idenfy students who are enrolled in courses taught by at least two different professors.

SELECT
s.student_id, s.first_name, s.last_name,
COUNT(DISTINCT t.prof_id) AS total_professors FROM Students s
JOIN Enrollments e
ON s.student_id = e.student_id JOIN Teaching t
ON e.course_id = t.course_id
GROUP BY s.student_id, s.first_name, s.last_name HAVING total_professors >= 2;


Q-10 Grade Distribuon by Course: For the course named 'Advanced Data Structures', calculate the count of students who received each leer grade ('A', 'B', 'C', etc.).

SELECT
e.grade,
COUNT(*) AS student_count FROM Enrollments e
JOIN Courses c
ON e.course_id = c.course_id
WHERE c.course_name = 'Advanced Data Structures' GROUP BY e.grade;
```
