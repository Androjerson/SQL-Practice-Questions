/* 
Find the room types: Identify the room types that users search for the most.
Output: Display each room type alongside the number of searches for it.
Filter for room types: If there are multiple room types in the filter, treat each unique room type as a separate row.
Sort the result: Arrange the room types based on the number of searches in descending order 
*/

create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
delete from airbnb_searches;
insert into airbnb_searches values(1,TO_DATE('2022-01-01','YYYY-MM-DD'),'entire home,private room');
insert into airbnb_searches values(2,TO_DATE('2022-01-02','YYYY-MM-DD'),'entire home,shared room');
insert into airbnb_searches values(3,TO_DATE('2022-01-02','YYYY-MM-DD'),'private room,shared room');
insert into airbnb_searches values(4,TO_DATE('2022-01-03','YYYY-MM-DD'),'private room');

SELECT * FROM airbnb_searches;

SELECT t1.room_type,t1.total FROM (WITH CTE as (
SELECT a.*,
--Fetching the occurences of room type in filter
CASE WHEN filter_room_types LIKE '%entire home%' THEN 1 ELSE 0 END as entire_home,  
CASE WHEN filter_room_types LIKE '%private room%' THEN 1 ELSE 0 END as private_room,
CASE WHEN filter_room_types LIKE '%shared room%' THEN 1 ELSE 0 END as shared_room
FROM airbnb_searches a)
--No group by needed here as we are not selecting any column other than sum column
SELECT 'private room' AS room_type,SUM(private_room) AS total FROM CTE UNION  
SELECT 'entire home' AS room_type,SUM(entire_home) AS total FROM CTE UNION
SELECT 'shared room' AS room_type,SUM(shared_room) AS total FROM CTE)t1 
--Ordering based on the total 
ORDER BY t1.total DESC;