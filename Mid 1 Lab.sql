--LAB 01: 13 Oct 2020

--creating student table

CREATE TABLE student_s2 (
    student_id NUMBER,
    student_name VARCHAR2(20),
    student_gender CHAR(1),
    student_age NUMBER,
	primary key (student_id)
);

--drop a table from database
drop table student_s2;

--describing a table
desc student_s2;

--insert rows into a table
INSERT INTO student_s2 VALUES (101,'Alice','F',22);
INSERT INTO student_s2 VALUES (102,'Bob','M',24);
INSERT INTO student_s2 VALUES (103,'Jane','F',25);
INSERT INTO student_s2 VALUES (104,'John','M',21);

--retrieving data from a table
SELECT *
FROM student_s2;


--SELECT: contains the list of attributes
--FROM: contains the table name
--WHERE: contains the condition

--display student name only
select student_name
FROM student_s2;

--display student name and age
select student_name, student_age
from student_s2;

--find student name and age who are female
select student_name, student_age
from student_s2
where student_gender = 'F';

SELECT ......
FROM ........
WHERE condition1 AND condition2;

--find student id, name and gender who are
--male and age is more than 21.

SELECT student_id, student_name, student_gender
FROM student_s2
WHERE student_gender = 'M' AND student_age > 21;

--find students who are older than 30
select *
from student_s2
where student_age > 30;

--saving the data 
commit;

-- LAB 02: 20 October 2020

-- how to create new user?
-- first, you have to log in to system account
-- then write following statement to create a user
create user c##cse302sec2f20 identified by cse302;

-- grant privileges to the new user
GRANT RESOURCE, CONNECT, CREATE SESSION, CREATE TABLE,
CREATE VIEW, CREATE ANY TRIGGER, CREATE ANY PROCEDURE, CREATE
SEQUENCE, CREATE SYNONYM, UNLIMITED TABLESPACE TO c##cse302sec2f20;

-- Data Definition Language (DDL)

--create a table Book that contains the following attributes and constraints.
--ISBN (string) primary key
--title (string) NOT NULL
--price (number) it has to be greater than 0
--pubYear (number)

create table book(
	ISBN varchar2(10),
	title varchar2(10) NOT NULL,
	price number,
	pubYear number,
	constraint book_pk primary key (ISBN),
	constraint book_chk_price check (price > 0)
);
--create a table purchase that contains the following attributes and constraints.
--purchaseId (number) primary key
--customerName (string) NOT NULL
--ISBN (string) foreign key
--quantity (number) it has to be greater than 0
create table purchase(
	purchaseId number,
	customerName varchar2(10) NOT NULL,
	ISBN varchar2(10),
	quantity number,
	constraint purchase_pk primary key (purchaseId),
	constraint purchase_fk foreign key (ISBN) references book,
	constraint purchase_chk_quantity check (quantity > 0)
);


create table department(
	dept_name varchar2(10),
	building varchar2(10),
	budget number,
	constraint department_pk primary key(dept_name),
	constraint department_chk_budget check (budget >= 0)
);

create table course(
	course_id varchar2(10),
	title varchar2(10),
	dept_name varchar2(10),
	credits number,
	constraint course_pk primary key(course_id),
	constraint course_fk foreign key (dept_name) references department,
	constraint course_chk_credits check (credits >= 1)
);

-- altering a table

-- adding a new attribute
alter table department add dept_head varchar2(10) NOT NULL;

-- dropping an existing attribute
alter table department drop column dept_head;

-- changing data type of a column
alter table department modify building number;
-- if the column has values, then datatype cannot be changed.
-- then drop first and add the attribute with new data type.

-- rename column
alter table department rename column building to building_number;

-- rename table
alter table department rename to dept;
alter table dept rename to department;


-- dropping constraint
alter table department drop constraint department_chk_budget;

-- adding constraint
alter table department add constraint department_chk_budget check (budget > 5000);


-- Data Manipulation Language (DML)

insert into department values ('LAW', NULL, NULL, 'DEF');
insert into department (dept_name, building_number, dept_head) values ('BA', 2, 'PQR');


-- updating existing values
update department
set budget = 10000
where dept_name = 'CSE';

-- update the building number and budget of LAW department with the followings.
-- building number = 1
-- budget = 12000

-- multiple-values update in a single statement
update department
set building_number = 1, budget = 12000
where dept_name = 'LAW';

delete from department
where dept_name = 'BA';

insert into course values ('CSE302','Database','CSE',4.5);
insert into course values ('CSE365','AI','CSE',4);
insert into course values ('EEE101','Circuit','EEE',4);
insert into course values ('LAW201','TAX Law','LAW',3);

-- Joining two or more tables

A = {a,b,c}
B = {1,2}
A X B = {(a,1),(a,2),(b,1),(b,2),(c,1),(c,2)}

-- department has 3 tuples/rows
-- course has 4 tuples/rows

-- department X course = 12 tuples/rows

-- using cross/cartesian product with join condition

-- JOIN CONDITION should be given when joining two or more relations
-- JOIN CONDITION: the value of the common attribute must be the same

select *
from department d, course c
where d.dept_name = c.dept_name;

-- find course title, department name, building of the courses with more than or
-- equal to 4 credits.

select title, d.dept_name, building_number
from department d, course c
where d.dept_name = c.dept_name AND credits >= 4;

-- find course id, course title and credits of those courses which have been offered 
-- by the department where the department is located in building number 1.

select course_id, title, credits
from department x, course y
where x.dept_name = y.dept_name AND building_number = 1;

select course_id, title, credits
from department NATURAL JOIN course
where building_number = 1;

-- NATURAL JOIN (alternative syntax)

-- find course title, department name, building of the courses with more than or
-- equal to 4 credits.

-- cartesian product with join condition (join condition is explicit)
select title, d.dept_name, building_number
from department d, course c
where d.dept_name = c.dept_name AND credits >= 4;

-- NATURAL JOIN operator (join condition is implicit)
select title, dept_name, building_number
from department NATURAL JOIN course 
where credits >= 4;

-- LAB 03: 27 October 2020

-- executing SQL Script

@ path\filename.sql

@ C:\SQL\banking.sql

-- junction table: a table that is mainly
created for establishing the relationship
in between two other tables.

-- multi-table queries
-- ex.1:
Find customer names who have accounts with
balance more than 700.

select customer_name
from account a, depositor d
where a.account_number = d.account_number and
balance > 700;

select customer_name
from account NATURAL JOIN depositor
where balance > 700;

--ex.2:
show all tuples from account and depositor
table where the value of the common attribute
is the same.

select *
from account a, depositor d
where a.account_number = d.account_number;

select *
from account NATURAL JOIN depositor;

--ex.3:
Find customer names who got loans of 
more than 500.

-- DISTINCT is used to remove duplicate tuples
select DISTINCT customer_name
from loan l, borrower b
where l.loan_number = b.loan_number 
and amount > 500;

select DISTINCT customer_name
from loan NATURAL JOIN borrower
where amount > 500;

--ex.4: 
Find customer names and cities who have 
accounts with balance more than 700.

select d.customer_name, customer_city
from customer c, depositor d, account a
where c.customer_name = d.customer_name and
d.account_number = a.account_number and
balance > 700;

select customer_name, customer_city
from (customer natural join depositor)
     natural join account
where balance > 700;

--ex.5:
Find account number and account balance
of those accounts which are opened in account
branch located in 'Horseneck' city.

-- cartesian product
select account_number, balance
from account a , branch b 
where a.branch_name = b.branch_name
and branch_city = 'Horseneck';

-- JOIN operator with ON keyword

select account_number, balance
from account a JOIN branch b 
     ON a.branch_name = b.branch_name
where branch_city = 'Horseneck';

-- NATURAL JOIN
select account_number, balance
from account NATURAL JOIN branch
where branch_city = 'Horseneck';

-- JOIN operator with USING keyword
select account_number, balance
from account JOIN branch using (branch_name)
where branch_city = 'Horseneck';

-- ex.6 (orber by example)
Find account number and account balance
of those accounts which are opened in account
branch located in 'Horseneck' city. Sort the 
result based on balance in descending order.

select account_number, balance
from account a , branch b 
where a.branch_name = b.branch_name
and branch_city = 'Horseneck'
order by balance desc;

-- multi-attribute sorting
select account_number, balance
from account a , branch b 
where a.branch_name = b.branch_name
and branch_city = 'Horseneck'
order by balance desc, account_number desc;

select *
from account
order by balance desc;

-- multi-attribute sorting
select * 
from account 
order by balance desc, account_number desc; 

-- arithmetic operation in select clause

-- The bank decides to waive 10% of each loan 
-- amount.
-- Prepare a report that shows each loan number,
-- current amount, waived amount and the new amount
-- after the waiver.

select loan_number as "Loan Number", 
	   amount as "Current Amount",
       amount*0.1 as "Waived Amount",
	   amount*0.9 as "New Amount"
from loan;

-- LIKE operator
-- It is used to match string patterns

-- how to create string patterns?
-- two special characters
-- wildcards

-- % (percent symbol): 
it can match to any number of characters (0..n)
-- _ (underscore sybmol)
it can match to exactly one character 

String patterns
'A%' -- string that starts with 'A'
     -- A, An, Ant, Apple, Aeroplane, At ... 
'A_' -- string that starts with 'A' and has two 
        characters
	 -- At, An 
'_Z' -- string that ends with 'Z' and has two charcters
 
'%Z' -- string that ends with 'Z'

'%Khan' -- string ends with 'Khan'
'%Khan%' -- string that has a substring 'Khan'
'Khan%' -- string starts with 'Khan'

-- Find customer names and cities whose name
-- starts with 'J'.

select customer_name, customer_city
from customer
where customer_name LIKE 'J%';

-- Find customer names whose name ends with 'n'.
select customer_name
from customer
where customer_name LIKE '%n';

-- Find customer names whose name has 's' as 
-- a substring.
select customer_name
from customer
where customer_name LIKE '%s%';

-- Find branch information which have 'o' 
-- as a substring in their branch city



-- find customer names whose name has 's' 
-- (either in lowercase or in uppercase) 
-- as a substring.
 
select customer_name
from customer
where customer_name LIKE '%s%' OR 
      customer_name LIKE '%S%';
	  
select customer_name
from customer
where lower(customer_name) LIKE '%s%';

-- find customer names whose name has 's' 
-- (either in lowercase or in uppercase) 
-- as a substring and 
-- has exactly five characters.

select customer_name
from customer
where (customer_name LIKE '%s%' OR 
      customer_name LIKE '%S%') AND
	  customer_name LIKE '_____';

select customer_name
from customer
where lower(customer_name) LIKE '%s%' AND
      LENGTH(customer_name) = 5;

-- LAB 04: 03 Nov 2020
-- Set operations

-- UNION
-- 1. Find customer name who are either depositors 
-- or borrowers
select customer_name from depositor
union
select customer_name from borrower;

-- INTERSECT
-- 2. Find customer name, street and city 
-- who are both depositors and borrowers
select customer_name, customer_street, customer_city
from customer natural join depositor
intersect
select customer_name, customer_street, customer_city
from customer natural join borrower;

-- MINUS
-- 3. Find customer name, street and city 
-- who are depositors but not borrowers
select customer_name, customer_street, customer_city
from customer natural join depositor
MINUS
select customer_name, customer_street, customer_city
from customer natural join borrower;

-- 4. Find customer name, street and city 
-- who are borrowers but not depositors
select customer_name, customer_street, customer_city
from customer natural join borrower
MINUS
select customer_name, customer_street, customer_city
from customer natural join depositor;


-- 5. Find customer name, street and city
-- who are neither borrowers nor depositors

-- solution 1
select * 
from customer
MINUS
select customer_name, customer_street, customer_city
from customer natural join depositor
MINUS
select customer_name, customer_street, customer_city
from customer natural join borrower;

-- solution 2
(select * 
from customer 
MINUS
select customer_name, customer_street, customer_city
from customer natural join depositor)
INTERSECT
(select * 
from customer 
MINUS
select customer_name, customer_street, customer_city
from customer natural join borrower);

-- aggregate functions

-- max, min, sum, avg, count, count(*)

-- 1. Find sum of balances of all accounts.

select sum(balance) as total_balance
from account;

-- 2. Find sum of balance of all accounts 
-- for each branch.

select branch_name, sum(balance) as total_balance
from account
group by branch_name;

-- 3. Find sum of balance of all accounts 
-- for each branch which has first letter 'R'.

select branch_name, sum(balance) as total_balance
from account
where branch_name LIKE 'R%'
group by branch_name;


select branch_name, sum(balance) as total_balance
from account
where branch_name LIKE 'R%'
group by branch_name
order by total_balance desc;

-- 4. Find average balance of accounts for each 
-- branch city which has the first letter 'B'. Sort 
-- the result in the descending order of avg. balance

select branch_city, avg(balance)
from branch natural join account
where branch_city LIKE 'B%'
group by branch_city
order by avg(balance) desc;

select ............. (mandatory)
from ............... (mandatory)
where ..............
group by ...........
order by ...........

-- Find sum of balance of all accounts 
-- for each branch. Display the branch_city as well.

select branch_name, branch_city, 
       sum(balance) as total_balance,
	   avg(balance) as avg_balance
from account natural join branch
group by branch_name, branch_city;

-- put all attributes in the SELECT clause without 
-- aggregate functions in the GROUP BY clause.

-- find total number of loans for each branch.

select branch_name, count(*)
from loan
group by branch_name;

-- Mid Term I - 15%
-- Full Marks - 40
-- Duration - 1 hour 20 minutes + 10 minutes for uploading
-- 2 points bonus for uploading the answer within first 80 minutes
-- 2 points for keeping your cam on
-- penalty: late submission for every 5 minutes 2 marks will be deducted


-- Syllabus
-- Part I
-- Q1. Chapter 1 (short question) - 5 points
-- Q2. Chapter 2 (short question/DDL statement/insert/update...) 10 
-- Q3. Schema Diagram - 5

-- Part II
-- Q4. Relational Algebra (everything) - 10

-- Part III
-- Q5. SQL (single-table, multi-table, set, aggregates - 10
            distinct, LIKE)
			






















