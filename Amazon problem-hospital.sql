--Amazon problem:https://www.youtube.com/watch?v=oGYinDMDfnA&list=PLBTZqjSKn0IfuIqbMIqzS-waofsPHMS0E
Q)NO OF EMPLOYEES INSIDE THE HOSPITAL

create table hospital( 
emp_id int,
action varchar(10),
time timestamp);

insert into hospital values (1, 'in', TO_TIMESTAMP('2019-12-22 09:00:00','YYYY-MM-DD HH:MI:SS'));

insert into hospital values ('1', 'out',TO_TIMESTAMP( '2019-12-22 09:15:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('2', 'in', TO_TIMESTAMP('2019-12-22 09:00:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('2', 'out',TO_TIMESTAMP( '2019-12-22 09:15:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('2', 'in', TO_TIMESTAMP('2019-12-22 09:30:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('3', 'out',TO_TIMESTAMP( '2019-12-22 09:00:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('3', 'in', TO_TIMESTAMP('2019-12-22 09:15:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('3', 'out',TO_TIMESTAMP( '2019-12-22 09:30:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('3', 'in', TO_TIMESTAMP('2019-12-22 09:45:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('4', 'in', TO_TIMESTAMP('2019-12-22 09:45:00','YYYY-MM-DD HH:MI:SS'));
insert into hospital values ('5', 'out',TO_TIMESTAMP( '2019-12-22 09:40:00','YYYY-MM-DD HH:MI:SS'));

SELECT * FROM hospital;

WITH cte AS
(SELECT emp_id,
max(CASE WHEN action='in' THEN time END) AS in_time,
max(CASE WHEN action='out' THEN time END)AS out_time 
FROM hospital h
GROUP BY emp_id)
SELECT * FROM CTE WHERE in_time>out_time
OR out_time IS NULL;   --To also filter out Employees who checked in but hasnt checkout once

--BY HAVING CLASS

SELECT emp_id,
max(CASE WHEN action='in' THEN time END) AS in_time,
max(CASE WHEN action='out' THEN time END)AS out_time 
FROM hospital h
GROUP BY emp_id 
HAVING max(CASE WHEN action='in' THEN time END) > max(CASE WHEN action='out' THEN time END)
OR max(CASE WHEN action='out' THEN time END) IS NULL;

--APPROACH 2: JOINS
WITH in_time AS
(SELECT emp_id,
MAX(time) AS latest_in_time
FROM hospital
WHERE action='in'
GROUP  BY emp_id), --comma is important when doing 2 CTEs
out_time AS 
(SELECT emp_id,
MAX(time) AS latest_out_time
FROM hospital
WHERE action='out'
GROUP  BY emp_id)
SELECT * from in_time it LEFT JOIN out_time ot ON it.emp_id=ot.emp_id WHERE it.latest_in_time>ot.latest_out_time OR ot.latest_out_time IS NULL;

1	22-12-19 9:00:00.000000000 AM	1	22-12-19 9:15:00.000000000 AM
2	22-12-19 9:30:00.000000000 AM	2	22-12-19 9:15:00.000000000 AM
3	22-12-19 9:45:00.000000000 AM	3	22-12-19 9:30:00.000000000 AM
4	22-12-19 9:45:00.000000000 AM		

--APPROACH 3:Comparing latest action time with the latest "in" time 
WITH latest_time AS 
(SELECT emp_id,
MAX(time) latest_time FROM hospital 
GROUP BY emp_id),
latest_in_time AS
(SELECT emp_id,
MAX(time) latest_in_time FROM hospital 
WHERE action='in'
GROUP BY emp_id)
SELECT * FROM latest_time lt JOIN latest_in_time lit USING (emp_id) WHERE lt.latest_time=lit.latest_in_time;

--APPROACH 4:with CTE

WITH CTE AS(
SELECT h.*,ROW_NUMBER() OVER (partition by emp_id ORDER BY time DESC) rown
FROM hospital h)
SELECT * FROM CTE WHERE rown=1 AND action='in';

