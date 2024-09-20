--a.Đưa ra tuổi trung bình của các học viên
select avg(cast(age as float)) as TuoiTB
from Student

--b.Tính xem mỗi học viên đã thi được bao nhiêu ngày rồi
select StudentTest.RN, StudentTest.TestID, Student.Name, Test.Name, StudentTest.Date, DATEDIFF(DAY, StudentTest.Date, GETDATE()) as SoNgayDaThi
from StudentTest join Student on StudentTest.RN = Student.RN
				join Test on StudentTest.TestID = Test.TestID

--c.Lấy ra những sinh viên không phải thi lại
select Student.Name
from StudentTest join Student on StudentTest.RN = Student.RN
where Mark >= 5
group by Student.Name

--lấy ra các sinh viên khong thi lại mon nào cả
select distinct Student.Name
from StudentTest join Student on StudentTest.RN = Student.RN
where Student.RN not in (select distinct RN
						from StudentTest
						where Mark < 5
						)

--d.Đưa ra điểm của học viên dưới dạng 4 chữ số, 2 chữ số sau dấu phảy(chưa đc)
select StudentTest.RN, StudentTest.TestID, Student.Name, Test.Name, cast(Mark as decimal(4,2)) as Diem
from StudentTest join Student on StudentTest.RN = Student.RN
				join Test on StudentTest.TestID = Test.TestID

--e.Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó,
--điểm thi và ngày thi giống như hình sau:
select Student.Name, Test.Name, Mark, Date
from StudentTest join Student on StudentTest.RN = Student.RN
				join Test on StudentTest.TestID = Test.TestID

--f.Hiển thị danh sách các bạn học viên chưa thi môn nào như hình sau:
select RN, Name, Age
from Student
where Student.RN not in (select RN
						from StudentTest
						) 
--g.Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. Danh sách
--phải sắp xếp theo thứ tự điểm trung bình giảm dần(nếu không sắp xếp thì chỉ được ½ số
--điểm) như sau:
select Student.RN, Student.Name, AVG(Mark) as Average
from StudentTest join Student on StudentTest.RN = Student.RN
group by Student.RN, Student.Name
order by avg(Mark) desc

--h.Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
select top(1) with ties Name, AVG(Mark) as Average
from StudentTest join Student on StudentTest.RN = Student.RN
group by Name
order by avg(Mark) desc

--c2
select Name, AVG(Mark) as Average
from StudentTest join Student on StudentTest.RN = Student.RN
group by Name
having avg(StudentTest.Mark) >= all (select AVG(Mark) as Average
									from StudentTest join Student on StudentTest.RN = Student.RN
									group by Name
									)



--i.Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học như sau:(chua xong)
select Name, max(Mark)
from StudentTest join Test on StudentTest.TestID = Test.TestID
group by Test.TestID, Name
order by Name asc

--j.Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên
--chưa thi môn nào thì phần tên môn học để Null như sau:
select Student.Name, Test.Name
from Student left join StudentTest on StudentTest.RN = Student.RN
			left join Test on StudentTest.TestID = Test.TestID


--k.Hiển thị danh sách sinh viên và số môn mà họ bị thi lại. Nếu học viên nào không bị thi lại
--môn nào thì cột số môn ghi là 0.(vẫn ch ổn)
select Student.Name, 
case	
	when count(Mark) = 0 then 0
	else count(Mark)
end as soMonThiLai
from StudentTest join Student on StudentTest.RN = Student.RN
				 join Test on StudentTest.TestID = Test.TestID
where Mark < 5
group by student.Name

--c2:
select Student.RN, Name, count(Mark) as soMonThiLai
from Student inner join StudentTest on Student.RN = StudentTest.RN
where Mark < 5
group by Student.RN, Name
union
select distinct Student.RN,Student.Name, 0
from StudentTest inner join Student on StudentTest.RN = Student.RN
where Student.RN not in (select distinct RN
						from StudentTest
						where Mark < 5
						)
 
--l.Hãy viết câu lệnh dùng đểm thêm mới 1 học viên.
insert into Student(RN, Name, Age)
values (5, N'Ho Anh Vu', 23);

--m. Hãy xóa học viên vừa mới thêm vào.
delete from Student
where RN = 5

--n. Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update Student
set Age = Age + 1

/*o. Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student. Hãy cập nhật(Update)
trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, trường hợp
còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student lên như sau:*/
alter table Student
add Status Varchar(10)
update Student
set Status = (case
			when Age < 30 then 'Young'
			else 'Old'
			end
			)
