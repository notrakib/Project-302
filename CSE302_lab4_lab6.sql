select * from instructor;

select * from student;

--Oracle Functions
--Display name of instructors in all uppercase letters

select UPPER('alice') from dual;

select name as INSTRUCTOR_NAME from instructor where lower(name) LIKE '%w%';

--concat operator ||
--Display instructor name and dept_name of those who earns more than 50000.
--Make sure to display the data in one single column

select name || '(' || dept_name || ')' as INSTRUCTOR_INFO
from instructor
where salary > 50000;

--concat function
--the function can handle only two parameters

select concat(concat('Rezwanul',' Huq'),'(DMRH)') from dual;

--Number Functions
--Find instuctor name, current salary and a projection of salaries if given 7.55% raise.

select name, salary, round(salary*1.0755,0) as projected_salary
from instructor;

select dept_name,ceil(avg(salary)) as AVG_SALARY, median(salary) as MEDIAN_SALARY 
from instructor 
group by dept_name;

select name, salary
from instructor
where dept_name='Comp. Sci.';

SELECT EXTRACT(YEAR FROM DATE '2020-11-24') from dual;

SELECT TO_CHAR(sysdate, 'dd/MON/yy')from dual;

SELECT TO_DATE('2015/05/15 8:30:25', 'YYYY/MM/DD HH:MI:SS')
FROM dual;


create table Person(
    personId number primary key,
    personName varchar2(20),
    personDob date
);

insert into Person values (1,'Alice','01-Nov-1998');
insert into Person values (2,'Bob','11-July-2000');
insert into Person values (3,'Charlie','02-Feb-1998');
insert into Person values (4,'Danny','28-Feb-1999');

select * from Person;
SELECT EXTRACT(YEAR FROM DATE '2020-11-24') from dual;

--1. How old is Alice (in years)? sysdate returns the current date
select extract(year from sysdate) - extract (year from personDob) as age
from person 
where personName = 'Alice';

select personName, extract(year from sysdate) - extract (year from personDob) || ' years' as age
from person;

--2. What is the age difference between Alice and Bob (in days)?
select abs((select personDob from person where personName = 'Alice') 
            - (select personDob from person where personName = 'Bob')) as difference 
from dual;

select abs(v1-v2) as difference
from (select personDob as v1 from person where personName = 'Alice') t1, 
      (select personDob as v2 from person where personName = 'Bob') t2;

--3. How many of them were born in 1998?

select count(*)
from person
where extract(year from personDob) = 1998;

-- Views and Authorization
create view Faculty as
    select id, name, dept_name
    from instructor;

select * from user_views;

select * from Faculty;

desc instructor

-- updateable view
-- Faculty is an updateable view

insert into Faculty values ('00000','DMRH','Comp. Sci.');
select * from instructor;

create view CSEFaculty as
    select id, name, dept_name 
    from faculty
    where dept_name = 'Comp. Sci.';
    
select * from CSEFaculty;

insert into CSEFaculty values ('77777','TBA-1','Biology');

create view student_info as
    select id, name, dept_name, building
    from student natural join department;

select * from student_info;

insert into student_info values ('00001','Alice','History','Painter');


-- Authorization

GRANT select on Faculty to alice with grant option;

select * from user_tab_privs;
    
REVOKE select on Faculty from alice;

GRANT select on Faculty to bob;

REVOKE SELECT ON FACULTY FROM ALICE;





