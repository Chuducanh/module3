create database my_database1;
drop database my_database1;

create schema student_management;

use student_management;

create table Student (
	id int,
    name varchar(45),
    age int,
    country varchar(45)
);

create table Class(
	id int,
    name varchar(45)
);

create table Teacher(
	id int,
    name varchar(45),
    age int,
    country varchar(45)
);
