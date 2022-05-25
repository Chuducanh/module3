USE QuanLySinhVien;

-- Hiển thị môn học có Credit cao nhất --
SELECT SubID, SubName, Max(Credit) as 'Max Credit', Status
From Subject;

-- Hiển thị môn học có điểm thi cao nhất -- 
Select Subject.SubID, Subject.SubName, Subject.Credit, Subject.Status, Max(Mark) as 'Highest Point'
From Subject join Mark on Subject.SubID = Mark.SubID;

-- Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự giảm dần --
Select Student.StudentID, StudentName, Address, Phone, Status, AVG(Mark) as 'Điểm trung bình môn'
From Student Join Mark on Student.StudentID = Mark.StudentID
Group By Student.StudentID
Order By AVG(Mark) desc;