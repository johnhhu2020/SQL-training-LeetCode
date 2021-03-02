SELECT a.id AS customer_id, a.name, b.id AS order_id FROM customers a
LEFT JOIN orders b ON a.id = b.customer_id;


------------------------175. Combine Two Tables------------------------------


SELECT emp_id, salary AS second_highest_salary FROM employee_salary
ORDER BY salary DESC LIMIT 0,4;


------------------------177. Nth Highest Salary----------------------------
------------------------176. Second Highest Salary-------------------------


SELECT ss.id, ss.score, (SELECT COUNT(DISTINCT s.score) FROM student_scores s WHERE s.score >= ss.score) AS ranking
FROM student_scores ss ORDER BY ss.score DESC;

SELECT s.score, (SELECT COUNT(DISTINCT score) FROM student_scores WHERE score >= s.score) ranking
FROM student_scores s ORDER BY s.score DESC;


------------------------178. Rank Scores-----------------------------------*********************


SELECT * FROM log_table;

SELECT DISTINCT t1.num AS consecutive_num FROM log_table t1, log_table t2, log_table t3
WHERE t1.id = t2.id - 1 AND t2.id = t3.id - 1 AND t1.num = t2.num AND t2.num = t3.num;

SELECT * FROM customer_events;

select distinct user_id from customer_events where user_id in
(select distinct t1.user_id from customer_events t1 inner join customer_events t2
    on t1.user_id = t2.user_id and DATEDIFF(t1.occurred_at, t2.occurred_at) = 1
    group by t1.user_id, t1.occurred_at
    having count(distinct(t2.occurred_at)) = 6)
order by user_id;


------------------------180. Consecutive Numbers---------------------------*****************


SELECT * FROM email_info;

SELECT email AS duplicated_email FROM email_info
GROUP BY email HAVING COUNT(*) > 1;

SELECT a.id, a.email AS duplicated_email FROM email_info a
INNER JOIN email_info b ON a.email = b.email
WHERE a.id <> b.id;


------------------------182. Duplicate Emails-------------------------------


SELECT a.id, a.name AS never_order, b.id AS order_id FROM customer_info a
LEFT JOIN order_info b ON a.id = b.customer_id WHERE b.id IS NULL;

SELECT * FROM customer_info;

SELECT * FROM order_info;


------------------------183. Customers Who Never Order-----------------------


SELECT * FROM emp_dept;
SELECT * FROM dept_emp;

SELECT ed.id,ed.name,ed.salary,de.name AS department FROM emp_dept ed
    LEFT JOIN dept_emp de ON ed.department = de.id WHERE salary IN (
        SELECT MAX(salary) FROM emp_dept GROUP BY department);

SELECT department,MAX(salary) FROM emp_dept GROUP BY department;


------------------------184. Department Highest Salary-----------------------**************


DELETE e FROM email_info e, email_info p
WHERE e.id < p.id  AND e.email = p.email;

SELECT * FROM email_info;


------------------------196. Delete Duplicate Emails------------------------


SELECT w1.id, w1.record_date, w1.temperature FROM date_temperature w1, date_temperature w2
WHERE w1.temperature > w2.temperature AND DATEDIFF(w1.record_date, w2.record_date) = 1;


------------------------197. Rising Temperature----------------------------

SELECT * FROM game_play;

SELECT player_id, MIN(event_date) AS first_login FROM game_play
GROUP BY player_id;

select a.player_id, a.device_id,a.event_date from
(select player_id, device_id,event_date,row_number() over
    (partition by player_id order by event_date) AS rn
from game_play) a
where rn = 1;

select player_id, device_id,event_date,row_number() over
    (partition by player_id order by event_date) AS rn
from game_play;

SELECT b.player_id, b.device_id, b.event_date, b.games_played  FROM game_play b
INNER JOIN game_play a ON a.player_id = b.player_id WHERE MIN(a.event_date) = b.event_date;

SELECT b.*  FROM game_play b
INNER JOIN (SELECT player_id, MIN(event_date) AS first_date FROM game_play
        GROUP BY player_id) c ON b.player_id = c.player_id
WHERE c.first_date = b.event_date;


------------------------512. Game Play Analysis II---------------------------


SELECT * FROM game_play;

SELECT a.player_id,a.device_id,a.event_date,SUM(b.games_played) AS played_so_far
FROM game_play_3 a LEFT JOIN game_play_3 b ON a.player_id = b.player_id AND b.event_date <= a.event_date
GROUP BY a.player_id, a.device_id, a.event_date;

SELECT a.player_id,a.device_id,a.event_date,SUM(b.games_played) FROM game_play a, game_play b
WHERE a.player_id = b.player_id AND a.event_date >= b.event_date
GROUP BY a.player_id,a.device_id,a.event_date ORDER BY a.player_id,a.device_id,a.event_date;

SELECT a.player_id,a.device_id,a.event_date,SUM(b.games_played) AS played_so_far FROM game_play a
    LEFT JOIN game_play b ON a.player_id = b.player_id AND a.event_date >= b.event_date
GROUP BY a.player_id,a.device_id, a.event_date;

SELECT * FROM game_play_3;

SELECT a.player_id,a.device_id,a.event_date,SUM(b.games_played) FROM game_play_3 a
    LEFT JOIN game_play_3 b ON a.player_id=b.player_id AND
 a.event_date>=b.event_date GROUP BY a.player_id,a.device_id,a.event_date;


------------------------534 Game Play Analysis III---------------------------*************************


SELECT * FROM game_play_2;

SELECT COUNT(DISTINCT b.player_id)/COUNT(DISTINCT a.player_id) AS percental FROM game_play_2 a, game_play_2 b
WHERE a.player_id = b.player_id AND DATEDIFF(b.event_date,a.event_date) = 1;

SELECT COUNT(DISTINCT b.player_id)/COUNT(ROW_NUMBER() over (PARTITION BY a.player_id))
FROM game_play_2 a, game_play_2 b
WHERE a.player_id = b.player_id AND DATEDIFF(b.event_date,a.event_date) = 1;

SELECT ((SELECT COUNT(DISTINCT b.player_id) FROM game_play_2 b, game_play_2 a
WHERE a.player_id = b.player_id AND DATEDIFF(b.event_date,a.event_date) = 1)
            /(SELECT COUNT(DISTINCT a.player_id) FROM game_play_2 a)) AS fraction;

SELECT * FROM game_play;
--
SELECT ((SELECT COUNT(DISTINCT (b.player_id)) FROM game_play_2 b, game_play_2 a
    WHERE b.player_id=a.player_id AND DATEDIFF(b.event_date,a.event_date)=1) /
    (SELECT COUNT(DISTINCT (a.player_id)) FROM game_play_2 a )) AS fraction;


------------------------550 Game Play Analysis IV----------------------------****************


SELECT * FROM emp_manager;

SELECT a.id,a.name,a.department FROM emp_manager a, emp_manager b
HAVING a.id = b.manager_id AND COUNT(b.manager_id)>4;

SELECT a.name FROM emp_manager a INNER JOIN emp_manager b ON a.id=b.manager_id
HAVING COUNT(b.manager_id = a.id)>4;

SELECT a.id,a.name,a.department,b.name AS emp_name FROM emp_manager a, emp_manager b
WHERE a.id = b.manager_id AND (SELECT COUNT(b.manager_id)>4 FROM emp_manager GROUP BY b.manager_id);


------------------------570 Managers with at Least 5 Direct Reports----------********


SELECT * FROM candidate_name;
SELECT * FROM candidate_vote;

SELECT c.name FROM candidate_name c WHERE c.id = (
    SELECT COUNT(v.candidate_id) AS d FROM candidate_vote v GROUP BY v.candidate_id ORDER BY d DESC LIMIT 1
    ); AND c.id = cc; IN (
    SELECT c.id FROM candidate_name c);
        COUNT(DISTINCT v.candidate_id)=2);
    WHERE COUNT(DISTINCT v.candidate_id) = MAX(COUNT(DISTINCT v.candidate_id));

SELECT name FROM candidate_name
WHERE id IN (SELECT t.candidate_id FROM (SELECT candidate_id FROM candidate_vote
		GROUP BY candidate_id ORDER BY COUNT(*) DESC LIMIT 0,1) AS t );


------------------------574 Winning Candidate--------------------------------**************


SELECT * FROM employee_salary;

SELECT a.emp_id, a.name, a.supervisor, a.salary FROM employee_salary a
RIGHT JOIN (SELECT emp_id, bonus FROM employee_bonus) b ON b.emp_id = a.emp_id
WHERE b.bonus >= 1000;

SELECT a.*, b.bonus FROM employee_salary a LEFT JOIN employee_bonus b ON b.emp_id = a.emp_id
WHERE bonus <= 1000 OR bonus IS NULL;


------------------------577. Employee Bonus----------------------------------


SELECT * FROM question_answer_2;

SELECT question_id FROM question_answer WHERE question_id = (
SELECT COUNT(question_id) AS vv FROM question_answer GROUP BY question_id ORDER BY vv DESC  LIMIT 1);

SELECT question_id FROM question_answer_2 WHERE action = 'answer';

SELECT question_id FROM question_answer_2 WHERE action = 'answer' AND question_id = (
    SELECT COUNT(f.question_id) AS v FROM question_answer_2 f GROUP BY f.question_id ORDER BY v DESC LIMIT 1);

SELECT question_id FROM question_answer_2 WHERE action = 'answer' GROUP BY question_id
ORDER BY COUNT(question_id) DESC LIMIT 2;


------------------------578 Get Highest Answer Rate Question-----------------**************


SELECT * FROM dept_student;
SELECT * FROM student_dept;

SELECT DISTINCT ds.dept_name, COUNT(DISTINCT sd.student_id) AS stu_num FROM dept_student ds
    LEFT JOIN student_dept sd on ds.dept_id = sd.dept_id GROUP BY ds.dept_name;

SELECT DISTINCT ds.dept_name, COUNT(DISTINCT sd.student_id) AS vv
FROM dept_student ds,student_dept sd WHERE ds.dept_id=sd.dept_id GROUP BY ds.dept_name;

SELECT D.dept_name, COUNT(S.student_id) AS student_number
FROM dept_student AS D LEFT JOIN student_dept AS S ON D.dept_id = S.dept_id
GROUP BY D.dept_name ORDER BY student_number DESC, D.dept_name;


------------------------580 Count Student Number in Departments-------------********


SELECT * FROM customer_referee
WHERE refree_id <> 2;

SELECT * FROM customer_referee;


------------------------584. Find Customer Referee----------------------------


SELECT * FROM 2016_investment;

SELECT SUM(TIV_2016) AS ff FROM 2016_investment
WHERE; (SELECT COUNT(TIV_2015)>1 FROM 2016_investment);
AND ;(SELECT COUNT(LAN)>1 FROM 2016_investment);
  AND; (SELECT COUNT(LON)=1 FROM 2016_investment);

SELECT SUM(TIV_2016) AS tt FROM `2016_investment` WHERE TIV_2015 IN (
    SELECT TIV_2015 FROM `2016_investment` GROUP BY TIV_2015 HAVING COUNT(TIV_2015)>1);---------------

SELECT SUM(TIV_2016) AS TIV_2016 FROM 2016_investment WHERE
TIV_2015 IN (SELECT TIV_2015 FROM 2016_investment GROUP BY TIV_2015 HAVING COUNT(*) > 1) AND
(LAN, LON) IN (SELECT LAN, LON FROM 2016_investment GROUP BY LAN, LON HAVING COUNT(*) = 1);

SELECT SUM(TIV_2016) AS TIV_2016 FROM 2016_investment
WHERE TIV_2015 IN (SELECT TIV_2015 FROM 2016_investment GROUP BY TIV_2015 HAVING COUNT(*) > 1) AND
CONCAT(LAN, LON) IN (SELECT CONCAT(LAN, LON) FROM 2016_investment GROUP BY LAN,LON HAVING COUNT(*) = 1);

SELECT SUM(TIV_2016) AS tt FROM `2016_investment`;


------------------------585 Investments in 2016-------------------------------***************


SELECT * FROM customer_order;

SELECT customer_number FROM customer_order
GROUP BY customer_number ORDER BY COUNT(*) DESC LIMIT 1;

SELECT customer_number, COUNT(*) AS cnt FROM customer_order
GROUP BY customer_number ORDER BY cnt DESC;

SELECT a.customer_number,a.order_date,a.shipped_date,a.status FROM customer_order a
LEFT JOIN (SELECT customer_number, COUNT(*) AS cnt FROM customer_order GROUP BY customer_number) b
    ON a.customer_number = b.customer_number GROUP BY customer_number;

SELECT  customers.customerid, customers.name, COUNT(orders.orderid) AS Orderscount FROM customers
INNER JOIN orders ON customers.customerid = orders.customerid
GROUP BY customers.customerid, customers.name ORDER BY Orderscount DESC LIMIT 1;


------------------------586. Customer Placing the Largest Number of Orders-------------------*****


SELECT class, count(*) AS cnt FROM student_class GROUP BY class;

SELECT * FROM  student_class;


------------------------596. Classes More Than 5 Students------------------------------------


SELECT (SELECT COUNT(DISTINCT requester_id, accepter_id) FROM request_accepted )
/(SELECT COUNT(DISTINCT sender_id, send_to_id) FROM request_friend) AS request_rate;

SELECT (SELECT COUNT(DISTINCT requester_id, accepter_id) FROM request_accepted)
           /(SELECT COUNT(DISTINCT sender_id, send_to_id) FROM request_friend) AS accept_rate;

SELECT IFNULL(ROUND((SELECT COUNT(DISTINCT requester_id, accepter_id) FROM request_accepted)
    /(SELECT COUNT(DISTINCT sender_id, send_to_id) FROM request_friend), 2), 0) AS accept_rate;


------------------------597. Friend Requests I: Overall Acceptance Rate----------------------


SELECT * FROM request_accepted;

SELECT t.id, COUNT(t.id) AS number_of_friends FROM
(SELECT requester_id AS id FROM request_accepted
UNION ALL
SELECT accepter_id AS id FROM request_accepted) t GROUP BY t.id ;

SELECT t.id, COUNT(t.id) AS num_of_friends FROM
(SELECT requester_id AS id FROM request_accepted
 UNION ALL
 SELECT accepter_id AS id FROM request_accepted) t
GROUP BY t.id  ORDER BY num_of_friends DESC;


------------------------602 Friend Requests 2: Who Has the Most Friends----------------------**********


SELECT * FROM cinema_seat_id;

SELECT DISTINCT a.seat_id FROM cinema_seat_id a, cinema_seat_id b
WHERE a.free = 1 AND b.free = 1 AND
      (b.seat_id = a.seat_id + 1 OR b.seat_id = a.seat_id -1) ORDER BY a.seat_id;

SELECT a.seat_id, a.free FROM cinema_seat_id a, cinema_seat_id b
WHERE a.free = 1 AND b.free = 1 AND (a.seat_id + 1 = b.seat_id OR a.seat_id - 1 = b.seat_id)
ORDER BY seat_id;


------------------------603. Consecutive Available Seats-------------------------------------


SELECT * FROM sales_salesperson;
SELECT * FROM sales_company;
SELECT * FROM sales_orders;

SELECT name FROM sales_salesperson WHERE sales_id NOT IN
(SELECT sc.sales_id FROM sales_orders sc LEFT JOIN sales_company so
    ON sc.company_id = so.company_id WHERE so.name = 'Red' );

SELECT sp.name FROM sales_salesperson sp WHERE sp.sales_id NOT IN
(SELECT sc.company_id FROM sales_company sc LEFT JOIN sales_orders so ON
    so.company_id = sc.company_id WHERE sc.name = 'RED');

SELECT s.name FROM sales_salesperson s
WHERE sales_id NOT IN (SELECT o.sales_id FROM sales_orders o LEFT JOIN sales_company c
    ON o.company_id = c.company_id    WHERE c.name = 'RED');


------------------------607. Sales Person----------------------------------------------------


SELECT * FROM tree_node;

SELECT id,(CASE WHEN p_id IS null THEN 'Root'
    WHEN id IN (SELECT P_id FROM tree_node_2 WHERE P_id IS NOT NULL) THEN 'Inner'
    ELSE 'Leaf' END) AS Type FROM tree_node_2;

SELECT id, (CASE WHEN p_id IS NULL THEN 'Root'
    WHEN id IN (SELECT DISTINCT p_id FROM tree_node_2) THEN 'Inner'
    ELSE 'Leaf' END) AS Tpye FROM tree_node_2 ORDER BY id;

SELECT id, IF(ISNULL(p_id),'Root',IF(id IN (SELECT p_id FROM tree_node),'Inner','Leaf')) AS Type
FROM tree_node ORDER BY id;

SELECT id, IF(P_id IS NULL,'root', IF(id IN (SELECT P_id FROM tree_node_2),'inner','leaf')) AS Type
FROM tree_node_2;


------------------------608 Tree Node--------------------------------------------------------**********


SELECT * FROM triangle_problem;

SELECT x, y, z, IF (x+y>z AND x+z>y AND y+z>x, 'Yes', 'No') AS triangle FROM triangle_problem;

SELECT x,y,z, CASE WHEN x + y > z AND y + z > x AND z + x > y THEN 'yes'
ELSE 'no' END AS 'triangle'  FROM triangle_problem;


------------------------610 Triangle Judgement-----------------------------------------------


SELECT * FROM short_distance_2;

SELECT SQRT((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y)) AS shortest_distance
FROM short_distance_2 a, short_distance_2 b;

SELECT SQRT((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y)) AS shortest_distance
FROM short_distance_2 a, short_distance_2 b HAVING shortest_distance>0 ORDER BY shortest_distance LIMIT 1;


------------------------612 Shortest Distance in a Plane-------------------------------------***


--We can cross join point table with itself to generate all possible pairs of points.
Then calculate distaneces and select minimum value--

SELECT MIN(a.x - b.x) AS shortest FROM short_distance a, short_distance b WHERE a.x > b.x;


------------------------613. Shortest Distance in a Line-------------------------------------


SELECT * FROM second_follower;

SELECT IF(follower IN (SELECT followee FROM second_follower),follower) AS second_follower
FROM second_follower;???????

SELECT followee,COUNT(follower) AS foll FROM second_follower WHERE followee IN
(SELECT follower FROM second_follower) GROUP BY followee;-------------------------------------

SELECT follower,(SELECT COUNT(follower) FROM second_follower GROUP BY followee) AS foll
FROM second_follower WHERE follower IN (SELECT followee FROM second_follower) GROUP BY follower;


------------------------614 Second Degree Follower-------------------------------------------********


SELECT * FROM biggest_num;

SELECT MAX(num) FROM ( SELECT num FROM biggest_num GROUP BY num  ) AS b;

SELECT MAX(num) FROM ( SELECT num FROM biggest_num GROUP BY num HAVING count(*) =1 ) AS b;


------------------------619. Biggest Single Number-------------------------------------------


SELECT * FROM boring_movies;

SELECT * FROM boring_movies WHERE MOD(id,2) = 1 AND description <> 'boring';


------------------------620. Not Boring Movies-----------------------------------------------


SELECT * FROM change_seats;

SELECT b.id, IF(a.id-b.id=1,b.student,a.student) AS new_stu FROM change_seats a,change_seats b;

SELECT IF(MOD(b.id,2)=0,b.id-1,IF(MOD(b.id,2)=1,b.id+1,IF(MOD(COUNT(id),2)=1,b.id),b.id+1)) AS id_2,b.student FROM change_seats b;

SELECT IF((SELECT COUNT(id) FROM change_seats)=id,id,IF(MOD(id,2)=0,id-1,IF(MOD(id,2)=1,id+1,id))) AS id_3,student FROM change_seats;-----

SELECT IF(MOD(id,2)=1,id+1,IF(MOD(id,2)=0,id-1,id+1)) AS id_2,student FROM change_seats;

SELECT IF(cnt % 2 = 1 AND id = cnt, id, IF(id % 2 = 1, id + 1, id - 1)) AS id, student FROM change_seats,
(SELECT COUNT(*) AS cnt FROM change_seats) AS t ORDER BY id;

SELECT (CASE WHEN id % 2 = 1 AND id != C THEN id+1
             WHEN id % 2 = 1 AND id  = C THEN id
             ELSE id-1 END) AS id,student
FROM change_seats,(SELECT COUNT(1) AS C FROM change_seats) AS T ORDER BY id;


------------------------626. Exchange Seats--------------------------------------------------************


SELECT * FROM salary_swap;

UPDATE salary_swap SET sex = ( CASE WHEN sex = 'f' THEN 'm' WHEN sex = 'm' THEN 'f' END );

UPDATE salary_swap SET sex = IF(sex = 'm', 'f', 'm') ;


------------------------627. Swap Salary-----------------------------------------------------


SELECT * FROM customer_product;

SELECT customer_id FROM customer_product WHERE product_id IN (
    SELECT product_id FROM customer_product GROUP BY product_id);

SELECT customer_id FROM customer_product GROUP BY customer_id HAVING COUNT(DISTINCT product_id) = (
    SELECT COUNT(DISTINCT product_id) FROM customer_product);------------------

SELECT customer_id FROM customer_product GROUP BY customer_id
HAVING COUNT(DISTINCT product_id) = (SELECT COUNT(DISTINCT product_id) FROM customer_product);


------------------------1045 Customers Who Bought All Products-------------------------------**********


SELECT * FROM actor_director;

SELECT a.actor_id,a.director_id FROM actor_director a GROUP BY a.actor_id, a.director_id
HAVING COUNT(*) >=3;


------------------------1050 Actors and Directors Who Cooperated At Least Three Times--------


SELECT pp.product_name, ps.* FROM product_product pp RIGHT JOIN product_sales ps ON
    pp.product_id = ps.product_id;


------------------------1068 Product Sales Analysis I----------------------------------------


SELECT product_id,SUM(quantity) AS qual FROM product_sales GROUP BY product_id;


------------------------1069 Product Sales Analysis II---------------------------------------


SELECT * FROM product_sales;
SELECT * FROM product_product;

SELECT DISTINCT product_id,year AS first_year,quantity,price FROM product_sales_2
WHERE year IN (SELECT MIN(year) FROM product_sales_2 GROUP BY product_id);-------------

SELECT product_id,year AS first_year,quantity,price FROM product_sales_2
WHERE year IN (SELECT MIN(b.year) FROM product_sales_2 b); AND b.product_id=product_id;

SELECT product_id,year AS first_year,quantity,price FROM product_sales_2
WHERE (product_id,year) IN (SELECT product_id,MIN(year) FROM product_sales_2 GROUP BY product_id);-----


------------------------1070 Product Sales Analysis III--------------------------------------***********


SELECT pp.project_id, AVG(experience_years) AS avg_exp FROM project_project pp
LEFT JOIN project_employee pe ON pe.employee_id = pp.employee_id GROUP BY pp.project_id;


------------------------1075 Project Employees I----------------------------------


SELECT * FROM project_project;

SELECT pp.project_id, COUNT(employee_id) AS emp_num FROM project_project pp
GROUP BY project_id;

SELECT pp.project_id, COUNT(employee_id) AS emp_num FROM project_project pp
GROUP BY project_id ORDER BY emp_num DESC LIMIT 1;

SELECT project_id FROM project_project GROUP BY project_id HAVING COUNT(employee_id) =
(SELECT COUNT(employee_id) AS emp FROM project_project GROUP BY project_id ORDER BY emp DESC LIMIT 1);


------------------------1076 Project Employees II--------------------------------**************


SELECT * FROM project_project;
SELECT * FROM project_employee;

SELECT p.project_id,p.employee_id,e.experience_years FROM project_project p LEFT JOIN project_employee_2 e
    ON p.employee_id=e.employee_id WHERE (p.project_id,e.experience_years) IN (
    SELECT e.employee_id,MAX(e.experience_years) FROM project_employee_2 e GROUP BY e.employee_id);-----------xxxxx---
GROUP BY p.project_id,e.employee_id;

SELECT p.project_id,p.employee_id,e.experience_years FROM project_project p LEFT JOIN project_employee_2 e
    ON p.employee_id=e.employee_id WHERE (p.project_id,e.experience_years) IN (
    SELECT p.project_id,MAX(e.experience_years) FROM project_project p,project_employee_2 e GROUP BY p.project_id);-------------


------------------------1077 Project Employees III-------------------------------**********************


SELECT * FROM sales_sales;

SELECT seller_id, price FROM sales_sales GROUP BY seller_id, price;

SELECT seller_id FROM sales_sales GROUP BY seller_id HAVING SUM(price)= (
SELECT SUM(price) AS total_price FROM sales_sales GROUP BY seller_id ORDER BY total_price DESC LIMIT 1);

SELECT seller_id, SUM(price) AS total_price FROM sales_sales GROUP BY seller_id ORDER BY total_price DESC;


------------------------1082. Sales Analysis I-----------------------------------


SELECT * FROM sales_sales;

SELECT ss.buyer_id FROM sales_sales ss LEFT JOIN sales_product sp ON sp.product_id = ss.product_id
WHERE sp.product_name = 'S8' AND sp.product_id <> 'iPhone';

SELECT ss.buyer_id FROM sales_sales ss WHERE ss.product_id = '1' AND ss.product_id <> 3;


------------------------1083 Sales Analysis II-----------------------------------


SELECT;


------------------------1084 Sales Analysis III-----------------------------------


SELECT * FROM book_book;
SELECT * FROM book_order;

SELECT b.book_id,b.name,SUM(o.quantity) FROM book_book b LEFT JOIN book_order o ON o.book_id=b.book_id
WHERE IF(o.dispatch_date IS NULL ,0,DATEDIFF('2019-06-23',o.dispatch_date))<365
AND DATEDIFF('2019-06-23',b.available_from)>30  GROUP BY b.book_id,b.name
HAVING SUM(IF(o.quantity IS NULL,0,o.quantity))<10;--------------------------

SELECT b.book_id,b.name FROM book_book b WHERE DATEDIFF('2019-06-23',b.available_from)>30
AND b.book_id NOT IN (SELECT o.book_id FROM book_order o
WHERE IF(o.dispatch_date IS NULL,0,DATEDIFF('2019-06-23',o.dispatch_date))>365
GROUP BY o.book_id HAVING SUM(IF(o.quantity IS NULL,0,quantity))>10);--------------------

SELECT b.book_id,b.name,o.quantity AS quantity FROM book_book b,book_order o
WHERE DATEDIFF('2019-06-23',b.available_from)>30
AND DATEDIFF('2019-06-23',o.dispatch_date)<365;
GROUP BY b.book_id,b.name; HAVING SUM(IF(o.quantity IS NULL,0,o.quantity))<10;-------xxxxx---------

SELECT b.book_id,b.name,SUM(o.quantity) AS quantity FROM book_book b LEFT JOIN book_order o ON b.book_id=o.book_id
WHERE DATEDIFF('2019-06-23',b.available_from)>30
AND IF(o.dispatch_date IS NULL,0,DATEDIFF('2019-06-23',o.dispatch_date))<365
GROUP BY b.book_id, b.name HAVING SUM(IF(o.quantity IS NULL,0,o.quantity))<10;------------------------------------------


------------------------1098 Unpopular Books--------------------------------------*****************


SELECT * FROM user_count;

SELECT user_id,MIN(activity_date) AS 'login_date' FROM user_count WHERE DATEDIFF('2019-06-30',activity_date)<90
AND activity='login' GROUP BY user_id HAVING login_date=MIN(activity_date);------------------xxxxxxx

SELECT user_id,MIN(activity_date) AS 'login_date' FROM user_count
WHERE DATEDIFF('2019-06-30',activity_date)<90 AND activity='login' GROUP BY user_id; AND activity_date IN (
SELECT user_id,MIN(activity_date) FROM user_count GROUP BY user_id WHERE activity='login'
    ) GROUP BY user_id HAVING DATEDIFF('2019-06-30',activity_date)<90;

SELECT user_id,MIN(activity_date) AS activity_date FROM user_count WHERE activity='login'
     GROUP BY user_id HAVING DATEDIFF('2019-06-30',activity_date)<90;----------------------vvvv?????------

SELECT user_id,MIN(activity_date) AS 'login_date' FROM user_count WHERE DATEDIFF('2019-06-30',activity_date)<90
GROUP BY user_id HAVING login_date=MIN(activity_date);-----------------THINK----------

SELECT user_id,login_date FROM
    (SELECT b.user_id,MIN(b.activity_date) AS login_date FROM user_count b WHERE b.activity='login'
    GROUP BY b.user_id) v WHERE DATEDIFF('2019-06-30',login_date)<90;

SELECT login_date,COUNT(user_id) AS 'user_count' FROM
    (SELECT b.user_id,MIN(b.activity_date) AS login_date FROM user_count b WHERE b.activity='login'
    GROUP BY b.user_id) v WHERE DATEDIFF('2019-06-30',login_date)<90 GROUP BY login_date;


------------------------1107.New Users Daily Count--------------------------------*****************


SELECT * FROM student_grade_2;

SELECT student_id,MAX(grade) AS max_grade,MAX(course_id) AS course_id FROM student_grade_2
GROUP BY student_id ORDER BY student_id;-----------------------

SELECT student_id,MIN(course_id),MAX(grade) AS grade FROM student_grade_2
WHERE (student_id,grade) IN (SELECT student_id,MAX(grade) FROM student_grade_2 GROUP BY student_id
    ) GROUP BY student_id ORDER BY student_id;-----------------------------------------

SELECT student_id,course_id,grade FROM (
    SELECT *,ROW_NUMBER() over (PARTITION BY student_id ORDER BY grade DESC,course_id) AS c FROM student_grade_2
    ) y WHERE c=1;--------------------------------------------------------------------

SELECT student_id, MIN(course_id), MAX(grade) AS grade FROM student_grade_2 WHERE (student_id, grade) IN (
    SELECT student_id, MAX(grade) FROM student_grade_2 GROUP BY student_id
) GROUP BY student_id ORDER BY student_id;


------------------------1112 Highest Grade For Each Student-----------------------****************


SELECT * FROM post_report;

SELECT * FROM post_report WHERE action_date BETWEEN '2019-07-03' AND '2019-07-05';

SELECT extra AS report_reasion, COUNT(DISTINCT(post_id)) AS report_count FROM post_report
WHERE action_date BETWEEN '2019-07-03' AND '2019-07-05' GROUP BY extra;


------------------------1113 Reported Posts---------------------------------------


SELECT * FROM active_business;

SELECT a.business_id FROM active_business a WHERE a.occurences > (
    SELECT b.event_type,AVG(b.occurences) FROM active_business b GROUP BY b.event_type
    ) GROUP BY a.business_id HAVING COUNT(a.event_type)>1;

SELECT business_id,MAX(occurences) FROM active_business WHERE event_type IN
  (SELECT b.event_type,AVG(b.occurences) AS ave_occu FROM active_business b GROUP BY b.event_type)
AND occurences > ave_occu GROUP BY business_id HAVING COUNT(event_type)>1;

SELECT T.business_id FROM (SELECT E.*, A.event_avg FROM active_business E LEFT JOIN (
    SELECT event_type, AVG(occurences) AS event_avg FROM active_business GROUP BY event_type) A
    ON E.event_type = A.event_type) T WHERE T.occurences > T.event_avg
GROUP BY T.business_id HAVING COUNT(T.event_type) > 1;----------------------------??????

SELECT business_id FROM (SELECT a.business_id,a.event_type,a.occurences,b.avg_occ FROM active_business a
LEFT JOIN (SELECT event_type,AVG(occurences) AS avg_occ FROM active_business GROUP BY event_type) b
ON a.event_type = b.event_type) tmp
WHERE occurences > avg_occ GROUP BY business_id HAVING COUNT(*) > 1;----------------------------join????????


------------------------1126 Active Businesses------------------------------------***********


SELECT * FROM user_activity;

SELECT activity_date AS DAY, COUNT(DISTINCT(user_id)) active_users FROM user_activity
WHERE DATEDIFF('2019-07-25', activity_date) <= 30 GROUP BY activity_date;


------------------------1141 User Activity for the Past 30 Days I------------------


SELECT * FROM user_activity_2;

SELECT COUNT(activity_type)/COUNT(DISTINCT(user_id)) AS ave_session_per_user FROM user_activity_2
WHERE DATEDIFF('2019-07-27', activity_date) <= 30 AND activity_type IN ('scroll_down', 'send_message');


------------------------1142 User Activity for the Past 30 Days II------------------************


SELECT * FROM article_view;

SELECT author_id FROM article_view WHERE author_id = viewer_id
GROUP BY author_id;


------------------------1148 Article Views I----------------------------------------


SELECT * FROM order_delivery;

SELECT (SELECT COUNT(delivery_id) FROM order_delivery WHERE order_date = customer_prefer_delivery_date)
           /COUNT(delivery_id) AS percentage FROM order_delivery;


------------------------1173 Immediate Food Delivery I------------------------------*****


SELECT;


------------------------1179. Reformat Department Table-----------------------------
