CREATE SCHEMA QuanLySinhVien;

USE QuanLySinhVien;

CREATE TABLE Class(
	ClassID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT
);

CREATE TABLE Student(
	StudentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassID INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID) 	
);

CREATE TABLE Subject(
	SubID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1 CHECK(credit>=1),
    Status BIT DEFAULT 1
);

CREATE TABLE Mark(
	MarkID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubID INT NOT NULL,
    StudentID INT NOT NULL,
    UNIQUE (SubID, StudentID),
    Mark FLOAT DEFAULT 0 CHECK(Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    FOREIGN KEY(SubID) REFERENCES Subject (SubID),
    FOREIGN KEY(StudentID) REFERENCES Student (StudentID)
);

use QuanLySinhVien;

insert into Class
values (1, 'A1', '2008-12-20', 1);
insert into Class
values (2, 'A2', '2008-12-22', 1);
insert into Class
values (3, 'B3', current_date, 1);

insert into Student (StudentID, StudentName, Address, Phone, Status, ClassID)
values (1, 'Hung', 'Ha Noi' , 0912113113, 1, 1);
insert into Student (StudentID, StudentName, Address, Status, ClassID)
values (2, 'Hoa', 'Hai Phong', 1, 1);
insert into Student (StudentID, StudentName, Address, Phone, Status, ClassID)
values (3, 'Manh', 'HCM' , 0123123123, 0, 2);

INSERT INTO Subject
VALUES (1, 'CF', 5, 1),
       (2, 'C', 6, 1),
       (3, 'HDJ', 5, 1),
       (4, 'RDBMS', 10, 1);
       
INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes)
VALUES (1, 1, 8, 1),
       (1, 2, 10, 2),
       (2, 1, 12, 1);
