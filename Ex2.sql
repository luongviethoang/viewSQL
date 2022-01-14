-- Phần4: Bài tập về nhà- lab9-View
if exists (select * from sys.databases where name = 'Lab9_BTVN')
	drop database Lab9_BTVN
create database Lab9_BTVN
use Lab9_BTVN
go
-- Tạo bảng Class lưu thông tin lớp học
create table Class (
	ClassCode varchar(10) primary key,		-- Mã lớp
	HeadTeacher varchar(30),				-- Giáo Viên CN
	Room varchar(30),						-- Phòng học
	TimeSlot char,							-- Giờ học
	CloseDate datetime						-- Ngày kết thúc khoá học
)
-- Tạo bảng Student lưu thông tin SV
create table Student (
	RollNo varchar(10) primary key,									-- Mã SV
	ClassCode varchar(10) foreign key references Class(ClassCode),	-- Mã Lớp 
	FullName varchar(30),											-- Tên SV
	Male bit,														-- Giới tính (Nam = 1; Nữ = 0)
	BirthDate datetime,												-- Ngày sinh
	Address varchar(30),											-- Địa chỉ
	Provice char(2),												-- Thành Phố
	Email varchar(30)												-- Email
)
-- Tạo bảng Subject lưu thông tin môn học
create table Subject (
	SubjectCode varchar(10) primary key,	-- Mã môn học
	SubjectName varchar(40),				-- Tên môn học
	WMark bit,								-- Có thi lý thuyết hay không (Có = 1; Không = 0)
	PMark bit,								-- Có thi thực hành hay không (Có = 1; Không = 0)
	WTest_per int,							-- Thang điểm tối đa của bài thi lý thuyết
	PTest_per int							-- Thang điểm tối đa của bài thi thực hành
)
-- Tạo bảng Mark lưu thông tin điểm thi của SV
create table Mark (
	RollNo varchar(10) foreign key references Student(RollNo),				-- Mã SV
	SubjectCode varchar(10) foreign key references Subject(SubjectCode),	-- Mã môn học
	WMark float,															-- Điểm thi Lý Thuyết
	PMark float,															-- Điểm thi Thực Hành
	Mark float																-- Điểm trung bình
)
-- Chèn dữ liệu vào các bảng
insert into Class (ClassCode, HeadTeacher, Room, TimeSlot, CloseDate)
	values
		('T2109M', 'luong Viet Hoang', 'LM81', 'G', '20220315 12:00:00'),
		('T2108M', 'luong Viet Hoang 2', 'LM80', 'I', '20220215 12:00:00'),
		('T2107M', 'luong Viet Hoang 3', 'LM79', 'L', '20220115 12:00:00'),
		('T2106M', 'luong Viet Hoang 4', 'LM78', 'M', '20220115 12:00:00'),
		('T2105M', 'luong Viet Hoang 5', 'LM77', 'G', '20211215 12:00:00')
insert into Student (RollNo, ClassCode, FullName, Male, BirthDate, Address, Provice, Email)
	values
		('DQTH2101M', 'T2109M', 'Hoang Hoa Tham', 1, '19990711 08:30:00', 'Nho Quan, Ninh Binh', 'NB', 'qa1@gmail.com'),
		('DQTH2102M', 'T2108M', 'Hoang Hoa Tham 2', 0, '19990811 08:30:00', 'Gia Vien, Ninh Binh', 'HN', 'qa2@gmail.com'),
		('DQTH2103M', 'T2107M', 'Hoang Hoa Tham 3', 1, '19990911 08:30:00', 'Yen Khanh, Ninh Binh', 'BN', 'qa3@gmail.com'),
		('DQTH2104M', 'T2106M', 'Hoang Hoa Tham 4', 0, '19991011 08:30:00', 'Yen Mo, Ninh Binh', 'HP', 'qa4@gmail.com'),
		('DQTH2105M', 'T2105M', 'Hoang Hoa Tham 5', 1, '19991111 08:30:00', 'Hoa Lu, Ninh Binh', 'ND', 'qa5@gmail.com')
insert into Subject (SubjectCode, SubjectName, WMark, PMark, WTest_per, PTest_per)
	values
		('AJS', 'AngularJS', 1, 1, 20, 15),
		('AJS2', 'AngularJS 2', 0, 1, Null, 15),
		('AJS3', 'AngularJS 3', 1, 0, 20, Null),
		('AJS4', 'AngularJS 4', 1, 1, 20, 15),
		('AJS5', 'AngularJS 5', 1, 1, 20, 15)
insert into Mark (RollNo, SubjectCode, WMark, PMark, Mark)
	values
		('DQTH2101M', 'AJS', 18.0, 12.0, 15.0),
		('DQTH2101M', 'AJS2', Null, 13.0, 13.0),
		('DQTH2102M', 'AJS2', Null, 12.0, 12.0),
		('DQTH2103M', 'AJS3', 18.0, Null, 18.0),
		('DQTH2104M', 'AJS4', 16.0, 14.0, 15.0),
		('DQTH2105M', 'AJS5', 10.0, 15.0, 12.5)
-- Tạo một khung nhìn chứa danh sách các sinh viên đã có ít nhất 2 bài thi (2 môn học khác nhau).
create view TwoTest as
select Student.FullName, count(Mark.SubjectCode) as TookExam from Student
join Mark
on Mark.RollNo = Student.RollNo
group by FullName
having count(Mark.SubjectCode) >= 2
-- Tạo một khung nhìn chứa danh sách tất cả các sinh viên đã bị trượt ít nhất là một môn.(Điểm TB trên 12 mới tính là đỗ)
create view FalledExam as
select Student.FullName from Student
join Mark
on Mark.RollNo = Student.RollNo
where Mark.Mark <= 12
group by FullName
having Count(Mark.SubjectCode) >= 1
-- Tạo một khung nhìn chứa danh sách các sinh viên đang học ở TimeSlot G.
create view TimeSlot_G as
select Student.FullName from Student
join Class
on Class.ClassCode = Student.ClassCode
where Class.TimeSlot = 'G'
-- Tạo một khung nhìn chứa danh sách các giáo viên có ít nhất 1 học sinh thi trượt ở bất cứ môn nào.
create view Teacher_Falled as
select Class.HeadTeacher from Class
join Student
on Student.ClassCode = Class.ClassCode
join Mark
on Mark.RollNo = Student.RollNo
where Mark <= 12
group by Class.HeadTeacher
having count (Mark.RollNo) >= 1
-- Tạo một khung nhìn chứa danh sách các sinh viên thi trượt môn AJS2 của từng lớp.
-- Khung nhìn này phải chứa các cột: Tên sinh viên, Tên lớp, Tên Giáo viên, Điểm thi môn AJS2.
create view List_STD_Falled as
select Student.FullName, Class.ClassCode, Class.HeadTeacher, Subject.SubjectName, Mark.WMark, Mark.PMark, Mark.Mark from Class
join Student
on Student.ClassCode = Class.ClassCode
join Mark 
on Mark.RollNo = Student.RollNo
join Subject
on Subject.SubjectCode = Mark.SubjectCode
where Mark.Mark <= 12 and Subject.SubjectCode = 'AJS2'