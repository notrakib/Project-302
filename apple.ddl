drop table book cascade constraints;
drop table contributor cascade constraints;
drop table course cascade constraints;
drop table department cascade constraints;
drop table faculty cascade constraints;
drop table rating cascade constraints;
drop table reader cascade constraints;
drop table sample_question cascade constraints;
drop table topic cascade constraints;
drop table student cascade constraints;
drop table all_files cascade constraints;


CREATE TABLE all_files (
    file_name            VARCHAR2(30) NOT NULL,
    files                BLOB NOT NULL,
    file_type            VARCHAR2(20) NOT NULL,
    file_time            VARCHAR2(20),
    file_characterset    VARCHAR2(20),
    topic_topic          VARCHAR2(50) NOT NULL,
    faculty_faculty_id   NUMBER NOT NULL
);

ALTER TABLE all_files ADD CONSTRAINT all_files_pk PRIMARY KEY ( file_name );

CREATE TABLE book (
    book_name      VARCHAR2(50) NOT NULL,
    edition        NUMBER,
    writter_name   VARCHAR2(30),
    topic_topic    VARCHAR2(50) NOT NULL
);

ALTER TABLE book ADD CONSTRAINT book_pk PRIMARY KEY ( book_name );

CREATE TABLE contributor (
    faculty_faculty_id   NUMBER NOT NULL,
    course_course_code   VARCHAR2(20) NOT NULL
);

ALTER TABLE contributor ADD CONSTRAINT contributor_pk PRIMARY KEY ( faculty_faculty_id,
                                                                    course_course_code );

CREATE TABLE course (
    course_code            VARCHAR2(20) NOT NULL,
    course_title           VARCHAR2(30) NOT NULL,
    credit                 NUMBER NOT NULL,
    department_dept_name   VARCHAR2(30) NOT NULL
);

ALTER TABLE course ADD CONSTRAINT course_pk PRIMARY KEY ( course_code );

CREATE TABLE department (
    dept_name      VARCHAR2(30) NOT NULL,
    total_credit   NUMBER,
    chairperson    VARCHAR2(30)
);

ALTER TABLE department ADD CONSTRAINT department_pk PRIMARY KEY ( dept_name );

CREATE TABLE faculty (
    faculty_id      NUMBER NOT NULL,
    faculty_name    VARCHAR2(30) NOT NULL,
    initials        VARCHAR2(20) NOT NULL,
    room_no         NUMBER,
    img             BLOB,
    img_name        VARCHAR2(20),
    img_type        VARCHAR2(20),
    img_time        VARCHAR2(20),
    img_character   VARCHAR2(20)
);

ALTER TABLE faculty ADD CONSTRAINT faculty_pk PRIMARY KEY ( faculty_id );

CREATE TABLE rating (
    rates                 NUMBER NOT NULL,
    comments              VARCHAR2(20) NOT NULL,
    student_student_id    VARCHAR2(20) NOT NULL,
    all_files_file_name   VARCHAR2(30) NOT NULL
);

ALTER TABLE rating
    ADD CONSTRAINT rating_pk PRIMARY KEY ( student_student_id,
                                           rates,
                                           comments,
                                           all_files_file_name );

CREATE TABLE reader (
    course_course_code   VARCHAR2(20) NOT NULL,
    student_student_id   VARCHAR2(20) NOT NULL,
    semester             NUMBER,
    year                 NUMBER
);

ALTER TABLE reader ADD CONSTRAINT reader_pk PRIMARY KEY ( course_course_code,
                                                          student_student_id );

CREATE TABLE sample_question (
    ques_file            BLOB,
    ques_name            VARCHAR2(30) NOT NULL,
    ques_type            VARCHAR2(20),
    ques_time            VARCHAR2(20),
    ques_character       VARCHAR2(20),
    course_course_code   VARCHAR2(20) NOT NULL
);


ALTER TABLE sample_question ADD CONSTRAINT sample_question_pk PRIMARY KEY ( ques_name );

CREATE TABLE student (
    student_id             VARCHAR2(20) NOT NULL,
    student_name           VARCHAR2(30) NOT NULL,
    department_dept_name   VARCHAR2(30) NOT NULL,
    pic                    BLOB,
    pic_name               VARCHAR2(20),
    pic_type               VARCHAR2(20),
    pic_time               VARCHAR2(20),
    pic_character          VARCHAR2(20)
);

ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY ( student_id );

CREATE TABLE topic (
    topic                VARCHAR2(50) NOT NULL,
    course_course_code   VARCHAR2(20) NOT NULL
);

ALTER TABLE topic ADD CONSTRAINT topic_pk PRIMARY KEY ( topic );

ALTER TABLE all_files
    ADD CONSTRAINT all_files_faculty_fk FOREIGN KEY ( faculty_faculty_id )
        REFERENCES faculty ( faculty_id );

ALTER TABLE all_files
    ADD CONSTRAINT all_files_topic_fk FOREIGN KEY ( topic_topic )
        REFERENCES topic ( topic );

ALTER TABLE book
    ADD CONSTRAINT book_topic_fk FOREIGN KEY ( topic_topic )
        REFERENCES topic ( topic );

ALTER TABLE contributor
    ADD CONSTRAINT contributor_course_fk FOREIGN KEY ( course_course_code )
        REFERENCES course ( course_code );

ALTER TABLE contributor
    ADD CONSTRAINT contributor_faculty_fk FOREIGN KEY ( faculty_faculty_id )
        REFERENCES faculty ( faculty_id );

ALTER TABLE course
    ADD CONSTRAINT course_department_fk FOREIGN KEY ( department_dept_name )
        REFERENCES department ( dept_name );

ALTER TABLE rating
    ADD CONSTRAINT rating_all_files_fk FOREIGN KEY ( all_files_file_name )
        REFERENCES all_files ( file_name );

ALTER TABLE rating
    ADD CONSTRAINT rating_student_fk FOREIGN KEY ( student_student_id )
        REFERENCES student ( student_id );

ALTER TABLE reader
    ADD CONSTRAINT reader_course_fk FOREIGN KEY ( course_course_code )
        REFERENCES course ( course_code );

ALTER TABLE reader
    ADD CONSTRAINT reader_student_fk FOREIGN KEY ( student_student_id )
        REFERENCES student ( student_id );

ALTER TABLE sample_question
    ADD CONSTRAINT sample_question_course_fk FOREIGN KEY ( course_course_code )
        REFERENCES course ( course_code );

ALTER TABLE student
    ADD CONSTRAINT student_department_fk FOREIGN KEY ( department_dept_name )
        REFERENCES department ( dept_name );

ALTER TABLE topic
    ADD CONSTRAINT topic_course_fk FOREIGN KEY ( course_course_code )
        REFERENCES course ( course_code );