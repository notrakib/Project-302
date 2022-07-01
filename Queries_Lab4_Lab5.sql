--A. IN / NOT IN
--A.1. Find courses offered in Fall 2009 and in Spring 2010
select distinct A.course_id 
from section A
where semester = 'Fall' and year = 2009 and
	  course_id IN (
		select course_id
		from section B
		where semester = 'Spring' and year = 2010
	);
	
--A.2. Find courses offered in Fall 2009 but not in Spring 2010
select distinct course_id 
from section 
where semester = 'Fall' and year = 2009 and
	  course_id not IN (
		select course_id
		from section 
		where semester = 'Spring' and year = 2010
	);
	
--A.3. Find the total number of (distinct) students who have 
--taken course sections taught by the instructor with ID 10101

select count(distinct id)
from takes
where (course_id, sec_id, semester, year) IN
	(select course_id, sec_id, semester, year 
	from teaches
	where id = '10101');
	
--A.4. Find list of student id and names from 'Physics' 
--and 'Comp. Sci.' departments.
select id, name, dept_name
from student 
where dept_name IN ('Physics','Comp. Sci.');

--A.5. Find list of student id and names who are not from 
-- 'Physics' and 'Comp. Sci.' departments.
select id, name, dept_name
from student 
where dept_name NOT IN ('Physics','Comp. Sci.');

--B. SOME / ALL
--B.1. Find names of instructors with salary greater than 
--that of some (at least one) instructor in the Biology department.
select id 
from instructor
where salary some>(select salary from instructor
				   where dept_name='Biology');
				   
--B.2. Find the names of all instructors whose salary is 
--greater than the salary of all instructors in the Biology department.
select id 
from instructor
where salary all>(select salary from instructor
				   where dept_name='Biology');
				   
--B.3. Find the names of instructors who get the 
--highest salary.
select id 
from instructor
where salary all>=(select salary from instructor);

--B.4. Find the names of instructors who get the 
--lowest salary.
select name, salary
from instructor
where salary <= ALL (select salary from instructor);

--C. EXISTS/NOT EXISTS
-- INTERSECT == IN == EXISTS == (=SOME)
-- MINUS == NOT IN == NOT EXISTS == (!=ALL)

--C.1. Find all courses taught in both the Fall 2009 semester 
-- and in the Spring 2010 semester
select distinct A.course_id 
from section A
where semester = 'Fall' and year = 2009 and
	EXISTS (
		select *
		from section B
		where semester = 'Spring' and year = 2010 and
			  A.course_id = B.course_id
	);
--C.2. Find all courses taught in Fall 2009 semester 
-- but not in the Spring 2010 semester
select distinct a.course_id 
from section a
where semester='Fall' and year=2009 and
		not EXISTS(
		select b.course_id
		from section b
		where semester='Spring' and year=2010 and
			  A.course_id=B.course_id
		); 

--C.3. Find all students who have taken all courses offered 
-- in the Biology department.
select distinct S.ID, S.name
from student S
where not exists (select course_id
                  from course
                  where dept_name = ’Biology’
                  MINUS
                  select T.course_id
                  from takes T
                  where S.ID = T.ID);

--C.4. Find all instructors who have taught all courses 
-- offered in the History department.
select distinct I.ID, I.name
from instructor I
where not exists (select course_id
                  from course
                  where dept_name = 'History'
                  MINUS
                  select T.course_id
                  from teaches T
                  where I.ID = T.ID);

--C.5. Find all instructors who taught courses in 
-- every 'Spring' semester.
select i.id, i.name
from instructor i
where NOT EXISTS (
	select distinct semester, year 
	from section 
	where semester = 'Spring'
	MINUS
	select distinct semester, year
	from teaches t
	where semester = 'Spring' and
	t.id = i.id);
	
--D. Subqueries in the FROM clause
--D.1. Find all departments with the maximum budget.
select dept-name
from (select dept_name, max(budget)
	  from department
	  group by dept_name);
	  
--D.2. Find the average instructors’ salaries of those departments where the average salary is greater than $42,000.
select t1.avg_salary
from (select avg(salary) as avg_salary
	  from instructor
	  group by dept_name)
where t1.avg_salary>42000;

--D.3. Find all departments where the total salary is greater than the average of the total salary at all departments.
select dept_name
from department d,  (select avg(salary) as average from instructor)t1,
					(select dept_name, sum(salary) as total from instructor
					 group by dept_name)t2
where d.dept_name=t2.dept_name and 
t2.total>t1.average;

--D.4. Find the courses (id and title) which offered 
-- in more than one semester.
select c.course_id, title
from course c, (select course_id, count(*) as total_num_offers
				from (select distinct course_id, semester, year
						from section)temp1
				group by course_id)temp2
where c.course_id = temp2.course_id
		and total_num_offers > 1;	
		
--E. Complex Queries using WITH clause
--E.1. Find all departments with the maximum budget.
with t1(dept_name, max_budget) as
       (select dept_name, max(budget)
	    from department
	    group by dept_name)
select dept-name
from t1;

--E.2. Find the average instructors’ salaries of those departments where the average salary is greater than $42,000.
with t1(avg_salary) as
	   (select avg(salary)
	    from instructor
	    group by dept_name)
select t1.avg_salary
from t1
where t1.avg_salary>42000;

--E.3. Find all departments where the total salary is greater than the average of the total salary at all departments.
with t1(average) as
	   (select avg(salary) from instructor),
	 t2(total) as
	   (select dept_name, sum(salary) from instructor
		group by dept_name)
select dept_name
from t1, t2, department d
where d.dept_name=t2.dept_name and 
t2.total>t1.average;

--E.4. Find the courses (id and title) which offered 
--in more than one semester.

WITH temp1 (course_id, semester, year) as
	(select distinct course_id, semester, year
	from section),
	temp2 (course_id, total_num_offers) as
	(select course_id, count(*)
	from temp1
	group by course_id)
select c.course_id, title
from course c, temp2
where c.course_id = temp2.course_id
		and total_num_offers > 1;

--F. Subqueries in the SELECT clause (Scalar Subquery)
--F.1. Find number of instructors for each department.
-- Include the departments with no instructor.
select dept_name, (select count(*)
					from instructor i
					where i.dept_name = d.dept_name) 
					     as num_instructor 
from department d;
 
select dept_name, count(id) as num_instructor
from department natural left join instructor
group by dept_name;

--F.2. Find number of courses offered by each department. 
-- Include the departments with no offered courses.


--G. Insert, Update and Delete Statement and NULL checking
--G.1. Find all instructors where salary value is null.
select *
from instructor
where salary = NULL;
-- these operators >, <, >=, <=, =,!= when used to check NULL
-- it returns always FALSE

select *
from instructor
where salary IS NULL;

select *
from instructor
where salary IS NOT NULL;

select *
from instructor
where NOT (salary IS NULL);

--G.2. suppose, you want to keep a back up of instructor and student.
-- how can you copy the content of one table into another?

create table data_backup (
	id varchar2(5),
	name varchar2(20),
	dept_name varchar2(20),
	type char(1)
);

insert into data_backup
	select id, name, dept_name, 'I'
	from instructor;
	
insert into data_backup
	select id, name, dept_name, 'S'
	from student;

--G.3. Increase salaries of instructors whose salary is over $100,000 by 3%, 
--and all others receive a 5% raise.

update instructor 
set salary = salary*1.05
where salary <= 100000;

update instructor
set salary = salary*1.03
where salary > 100000;

--G.4. Delete all tuples in the instructor relation for those instructors associated with a department located in the Watson building.

