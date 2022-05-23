use QuanLySinhVien;

select *
from student
where StudentName like 'h%';

select *
from class
where month(StartDate) = 12;

select *
from subject
where Credit between 3 and 5;

update Student
set ClassID = 2
where StudentName = 'Hung'; 

select s.StudentName, sub.SubName, m.mark 
from Student s
join Mark m on s.StudentID = m.StudentID
join Subject sub on m.SubID = sub.SubID
order by m.mark desc, s.StudentName;