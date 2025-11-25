# Case Study 3 Telecom Full

```text
III. CASE STUDY 3

Telecom Call Center Data Analysis :

Table 3: Schema Details-

SOLUTION-

CREATE DATABASE Telecom_CallCenter_case3;
Use Telecom_CallCenter_case3;



--- Agents Table
CREATE TABLE Agents (
agent_id INT PRIMARY KEY, agent_name VARCHAR(100), 
team VARCHAR(50),
hire_date DATE
);

--- Customers Table
CREATE TABLE Customers ( 
customer_id INT PRIMARY KEY, phone_number 
VARCHAR(15), region VARCHAR(50),
plan_type VARCHAR(50)
);

--- Calls Table
CREATE TABLE Calls (
call_id INT PRIMARY KEY, customer_id INT,
agent_id INT, call_duration_seconds INT, resolution_status VARCHAR(20), 
call_timestamp DATETIME,
FOREIGN KEY(customer_id) REFERENCES Customers(customer_id),
FOREIGN KEY (agent_id) REFERENCES Agents(agent_id)
);

//insering values into tables

INSERT INTO Agents VALUES 
(1, 'Ravi Kumar', 'Team A', '2025-02-01'),
(2, 'Priya Singh', 'Team B', '2024-06-15'),
(3, 'Amit Patel', 'Team A', '2023-11-20'),
(4, 'Neha Sharma', 'Team C', '2025-08-10'),
(5, 'Bistu Paul', 'Team B', '2024-12-05');

INSERT INTO Customers VALUES
(101, '9876543210', 'North', 'Postpaid'),
(102, '8765432109', 'South', 'Prepaid'),
(103, '7654321098', 'East', 'Postpaid'),
(104, '6543210987', 'West', 'Prepaid'),
(105, '5432109876', 'North', 'Postpaid'),
(106, '4321098765', 'South', 'Prepaid');

INSERT INTO Calls VALUES
(1001, 101, 1, 340, 'Resolved', '2025-11-10 10:23:00'),
(1002, 102, 2, 210, 'Unresolved', '2025-11-10 14:15:00'),
(1003, 103, 3, 480, 'Resolved', '2025-11-09 09:30:00'),
(1004, 104, 2, 130, 'Resolved', '2025-11-09 11:45:00'),
(1005, 105, 1, 550, 'Unresolved', '2025-11-08 13:20:00'),
(1006, 106, 4, 290, 'Resolved', '2025-11-10 16:00:00'),
(1007, 101, 5, 200, 'Resolved', '2025-10-15 12:40:00'),
(1008, 103, 3, 620, 'Resolved', '2025-08-01 15:10:00'),
(1009, 104, 2, 370, 'Unresolved', '2025-07-05 10:00:00'),
(1010, 106, 1, 150, 'Resolved', '2025-11-11 17:00:00');




Q-1 Agent Performance: Calculate the average call_duration_seconds and count of calls for each agent_name. Order by average duration descending.

SELECT
    a.agent_name,
    COUNT(c.call_id) AS total_calls,
    ROUND(AVG(c.call_duration_seconds), 2) AS avg_call_duration
FROM Agents a
JOIN Calls c 
    ON a.agent_id = c.agent_id
GROUP BY a.agent_name
ORDER BY avg_call_duration DESC;



Q-2 Team Efficiency: Find the team that has the highest overall call resolu on rate (percentage of calls with resolution_status = 'Resolved').

SELECT 
    a.team,
    COUNT(c.call_id) AS total_calls,
    SUM(CASE WHEN c.resolution_status = 'Resolved' THEN 1 ELSE 0 END) AS resolved_calls,
    ROUND(
        (SUM(CASE WHEN c.resolution_status = 'Resolved' THEN 1 ELSE 0 END) / COUNT(c.call_id)) * 100,
        2
    ) AS resolution_rate
FROM Agents a
JOIN Calls c 
    ON a.agent_id = c.agent_id
GROUP BY a.team
ORDER BY resolution_rate DESC
LIMIT 1;



Q-3 Call Volume by Region: Determine the total number of calls made by customers in each region.

SELECT 
    cu.region,
    COUNT(c.call_id) AS total_calls
FROM Customers cu
JOIN Calls c 
    ON cu.customer_id = c.customer_id
GROUP BY cu.region
ORDER BY total_calls DESC;


Q-4 Longest Call: List the customer_id, agent_name, and call_duration_seconds of the single  longest call ever recorded.

SELECT 
    c.customer_id, 
    a.agent_name, 
    c.call_duration_seconds
FROM Calls c
JOIN Agents a 
    ON c.agent_id = a.agent_id
ORDER BY c.call_duration_seconds DESC
LIMIT 1;


Q-5 New Agent Productivity: Find the total number of calls handled by agents who were hired in the last 6 months.

SELECT 
    COUNT(c.call_id) AS total_calls_by_new_agents
FROM Calls c
JOIN Agents a 
    ON c.agent_id = a.agent_id
WHERE a.hire_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);



Q-6 Peak Day of the Week: Identify the day of the week (e.g., 'Monday', 'Tuesday') that records the maximum number of calls. (Requires a date function).

SELECT 
    DAYNAME(call_timestamp) AS day_of_week, 
    COUNT(*) AS total_calls
FROM Calls
GROUP BY day_of_week
ORDER BY total_calls DESC
LIMIT 1;

Q-7 Unresolved Calls by Plan: List the plan_types and the count of calls for each where the resolution_status is 'Unresolved'.

SELECT 
    cu.plan_type,
    COUNT(*) AS unresolved_calls
FROM Calls c
JOIN Customers cu 
    ON c.customer_id = cu.customer_id
WHERE c.resolution_status = 'Unresolved'
GROUP BY cu.plan_type
ORDER BY unresolved_calls DESC;



Q-8 Sequetial Calls: Find customer_ids who have made more than 5 calls on the same day.

SELECT 
    customer_id,
    DATE(call_timestamp) AS call_date,
    COUNT(*) AS calls_per_day
FROM Calls
GROUP BY customer_id, call_date
HAVING calls_per_day > 5;



Q-9 Agent Average Time-to-Resolution: Calculate the average call_duration_seconds for each agent_name, but only including calls where the resolution_status was 'Resolved'.

SELECT 
    a.agent_name,
    ROUND(AVG(c.call_duration_seconds), 2) AS avg_resolved_duration
FROM Calls c
JOIN Agents a 
    ON c.agent_id = a.agent_id
WHERE c.resolution_status = 'Resolved'
GROUP BY a.agent_name
ORDER BY avg_resolved_duration DESC;


Q-10 Customer Call Frequency: Identify the customer_id and phone_number of customers who have not made a call in the past 90 days.

SELECT 
    cu.customer_id, 
    cu.phone_number
FROM Customers cu
WHERE cu.customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM Calls
    WHERE call_timestamp >= DATE_SUB(NOW(), INTERVAL 90 DAY)
);
```
