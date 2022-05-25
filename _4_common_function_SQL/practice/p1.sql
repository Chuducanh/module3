Use QuanLySinhVien;

-- Tính số lượng sinh viên của mỗi tỉnh thành --
SELECT Address, COUNT(StudentID) AS 'Số lượng học sinh'
FROM Student
GROUP BY Address;

-- Tính điểm trung bình của các môn học của mỗi học viên --
SELECT Student.StudentID, Student.StudentName, AVG(Mark) as 'Avarage Point'
FROM Student JOIN Mark ON Student.StudentID = Mark.StudentID
GROUP BY Student.StudentID;

-- Hiển thị những bạn học viên co điểm trung bình các môn học lớn hơn 15 --
SELECT Student.StudentID, Student.StudentName, AVG(Mark) as 'Avarage Point'
FROM Student JOIN Mark ON Student.StudentID = Mark.StudentID
GROUP BY Student.StudentID
HAVING AVG(Mark) > 15;

-- Hiển thị thông tin các học viên có điểm trung bình lớn nhất --
SELECT Student.StudentID, Student.StudentName, AVG(Mark)
FROM Student JOIN Mark ON Student.StudentID = Mark.StudentID
GROUP BY Student.StudentID
HAVING AVG(Mark) >= ALL (SELECT AVG(Mark) FROM Mark GROUP BY Mark.StudentId);
  