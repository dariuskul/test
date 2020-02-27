#@(#) script.ddl

DROP TABLE IF EXISTS TEXTBOOK_STUDENT;
DROP TABLE IF EXISTS ADRESS;
DROP TABLE IF EXISTS STUDENT;
DROP TABLE IF EXISTS SUBJECT_PROGRAM;
DROP TABLE IF EXISTS DEGREE;
DROP TABLE IF EXISTS PROGRAM;
DROP TABLE IF EXISTS SUBJECT;
DROP TABLE IF EXISTS TEXTBOOK;
DROP TABLE IF EXISTS PROFESSOR_MANAGEMENT;
DROP TABLE IF EXISTS FACULTY;
DROP TABLE IF EXISTS UNIVERSITY;
DROP TABLE IF EXISTS PROFESSOR;
DROP TABLE IF EXISTS MANAGEMENT;
DROP TABLE IF EXISTS LIBRARY;
CREATE TABLE LIBRARY
(
	capacity integer (("10")) NOT NULL,
	no_of_books integer (10) NULL,
	location varchar (20) NOT NULL,
	id_LIBRARY integer NOT NULL,
	PRIMARY KEY(id_LIBRARY)
);

CREATE TABLE MANAGEMENT
(
	personal_code varchar (11) NOT NULL,
	name varchar (20) NOT NULL,
	middle_name varchar (20) NOT NULL,
	surname varchar (10) NOT NULL,
	date_of_birth date NOT NULL,
	gender varchar (7) NOT NULL,
	mobile_number varchar (30) NOT NULL,
	email varchar (50) NOT NULL,
	date_joined date NOT NULL,
	date_left date NULL,
	role varchar (20) NOT NULL,
	PRIMARY KEY(personal_code)
);

CREATE TABLE PROFESSOR
(
	personal_code varchar (11) NOT NULL,
	name varchar (20) NOT NULL,
	middle_name varchar (20) NULL,
	surname varchar (20) NOT NULL,
	email_adress varchar (20) NOT NULL,
	salary integer (6) NOT NULL,
	PRIMARY KEY(personal_code)
);

CREATE TABLE UNIVERSITY
(
	name varchar (50) NOT NULL,
	rector_name varchar (30) NOT NULL,
	student_count integer (20) NOT NULL,
	location varchar (10) NOT NULL,
	id_UNIVERSITY integer NOT NULL,
	PRIMARY KEY(id_UNIVERSITY)
);

CREATE TABLE FACULTY
(
	type varchar (80) NOT NULL,
	description varchar (100) NOT NULL,
	deen_name varchar (20) NOT NULL,
	id_FACULTY integer NOT NULL,
	fk_UNIVERSITYid_UNIVERSITY integer NOT NULL,
	PRIMARY KEY(id_FACULTY),
	FOREIGN KEY(fk_UNIVERSITYid_UNIVERSITY) REFERENCES UNIVERSITY (id_UNIVERSITY)
);

CREATE TABLE PROFESSOR_MANAGEMENT
(
	fk_PROFESSORpersonal_code varchar (11) NOT NULL,
	fk_MANAGEMENTpersonal_code varchar (11) NOT NULL,
	PRIMARY KEY(fk_PROFESSORpersonal_code, fk_MANAGEMENTpersonal_code),
	FOREIGN KEY(fk_PROFESSORpersonal_code) REFERENCES PROFESSOR (personal_code),
	FOREIGN KEY(fk_MANAGEMENTpersonal_code) REFERENCES MANAGEMENT (personal_code)
);

CREATE TABLE TEXTBOOK
(
	isnn varchar (30) NOT NULL,
	name varchar (20) NOT NULL,
	publish_date date NOT NULL,
	author varchar (40) NOT NULL,
	fk_LIBRARYid_LIBRARY integer NOT NULL,
	PRIMARY KEY(isnn),
	FOREIGN KEY(fk_LIBRARYid_LIBRARY) REFERENCES LIBRARY (id_LIBRARY)
);

CREATE TABLE SUBJECT
(
	code varchar (20) NOT NULL,
	semester integer (3) NOT NULL,
	name varchar (20) NOT NULL,
	credits_given integer (3) NOT NULL,
	fk_PROFESSORpersonal_code NOT NULL,
	PRIMARY KEY(code),
	FOREIGN KEY(fk_PROFESSORpersonal_code) REFERENCES PROFESSOR (personal_code)
);

CREATE TABLE PROGRAM
(
	code varchar (20) NOT NULL,
	field varchar (20) NOT NULL,
	study_mode varchar (20) NOT NULL,
	language varchar (10) NOT NULL,
	tuition_fee integer (5) NULL,
	fk_FACULTYid_FACULTY integer NOT NULL,
	PRIMARY KEY(code),
	FOREIGN KEY(fk_FACULTYid_FACULTY) REFERENCES FACULTY (id_FACULTY)
);

CREATE TABLE DEGREE
(
	name varchar (20) NOT NULL,
	grade varchar (20) NOT NULL,
	gpa double precision (11) NOT NULL,
	id_DEGREE integer NOT NULL,
	fk_MANAGEMENTpersonal_code NOT NULL,
	fk_PROGRAMcode NOT NULL,
	PRIMARY KEY(id_DEGREE),
	UNIQUE(fk_PROGRAMcode),
	FOREIGN KEY(fk_MANAGEMENTpersonal_code) REFERENCES MANAGEMENT (personal_code),
	FOREIGN KEY(fk_PROGRAMcode) REFERENCES PROGRAM (code)
);

CREATE TABLE SUBJECT_PROGRAM
(
	fk_SUBJECTcode varchar (20) NOT NULL,
	fk_PROGRAMcode varchar (20) NOT NULL,
	PRIMARY KEY(fk_SUBJECTcode, fk_PROGRAMcode),
	FOREIGN KEY(fk_SUBJECTcode) REFERENCES SUBJECT (code),
	FOREIGN KEY(fk_PROGRAMcode) REFERENCES PROGRAM (code)
);

CREATE TABLE STUDENT
(
	student_id varchar (15) NOT NULL,
	name varchar (20) NOT NULL,
	surname varchar (20) NOT NULL,
	email varchar (50) NOT NULL,
	mobile_number varchar (10),
	date_started date NOT NULL,
	date_left date NULL,
	gender varchar (7) NOT NULL,
	fk_MANAGEMENTpersonal_code varchar (11) NOT NULL,
	fk_PROGRAMcode varchar (20) NOT NULL,
	PRIMARY KEY(student_id),
	FOREIGN KEY(fk_MANAGEMENTpersonal_code) REFERENCES MANAGEMENT (personal_code),
	FOREIGN KEY(fk_PROGRAMcode) REFERENCES PROGRAM (code)
);

CREATE TABLE ADRESS
(
	city varchar (20) NOT NULL,
	street varchar (15) NOT NULL,
	zip_code varchar (10) NOT NULL,
	id_ADRESS integer NOT NULL,
	fk_FACULTYid_FACULTY integer NOT NULL,
	fk_STUDENTstudent_id varchar (15) NOT NULL,
	PRIMARY KEY(id_ADRESS),
	UNIQUE(fk_FACULTYid_FACULTY),
	FOREIGN KEY(fk_FACULTYid_FACULTY) REFERENCES FACULTY (id_FACULTY),
	FOREIGN KEY(fk_STUDENTstudent_id) REFERENCES STUDENT (student_id)
);

CREATE TABLE TEXTBOOK_STUDENT
(
	fk_TEXTBOOKisnn varchar (30) NOT NULL,
	fk_STUDENTstudent_id varchar (15) NOT NULL,
	PRIMARY KEY(fk_TEXTBOOKisnn, fk_STUDENTstudent_id),
	FOREIGN KEY(fk_TEXTBOOKisnn) REFERENCES TEXTBOOK (isnn),
	FOREIGN KEY(fk_STUDENTstudent_id) REFERENCES STUDENT (student_id)
);
