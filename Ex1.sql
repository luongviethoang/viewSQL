
if exists (select * from sys.databases where name ='Lab9_BTTL')
	drop database Lab9_BTTL
create database Lab9_BTTL
use Lab9_BTTL
go

create table Customer (
	CustomerID int primary key identity(1,1),
	CustomerName varchar(50),
	Address varchar(100),
	Phone varchar(12)
)

create table Book (
	BookCode int primary key,
	Category varchar(50),
	Author varchar(50),
	Publisher varchar(50),
	Title varchar(100),
	Price int,
	InStore int
)

create table BookSold (
	BookSoldID int primary key,
	CustomerID int foreign key references Customer(CustomerID),
	BookCode int foreign key references Book(BookCode),
	Date datetime,
	Price int,
	Amount int
)
--yêu cầu 1
insert into Customer(CustomerName, Address, Phone)
	values
		('hoang', 'Ha Long', '0318300761'),
		('khanh', 'Thai Thuy, Thai Binh', '0979908276'),
		('Hung', 'Thai Nguyen', '0361646866'),
		('Thuy', 'Luc Nam, Bac Giang', '0321456789'),
		('Quang Anh', 'Ha Noi', '0987123456')
insert into Book (BookCode, Category, Author, Publisher, Title, Price, InStore)
	values
		(1, 'thuy thu mat trang', 'ko bt', 'Me Truyen Chu', 'Tien Nghich', 50, 20),
		(2, 'karuito', 'kurse', 'Ngon Tinh HD', 'Mai Mai La Bao Xa', 30, 50),
		(3, 'thay cung dai chien', 'Tieu Ngu', 'Truyen Convert', 'Phan Thien Chi No', 40, 40),
		(4, 'hoang hao tham', 'luong viet hoang', 'Tri Thuc', 'Tri Tue Do Thai', 50, 50),
		(5, 'sach ngu van', 'Do Viet Hung', 'Giao Duc Viet Nam', 'Tieng Viet 1', 20, 100)
insert into BookSold (BookSoldID, CustomerID, BookCode, Date, Price, Amount)
	values
		(1, 1, 1, '20211205 22:32:12', 50, 1),
		(2, 1, 3, '20220105 22:32:13', 40, 2),
		(3, 2, 2, '20220106 22:32:14', 30, 10),
		(4, 2, 4, '20220106 22:32:15', 50, 2),
		(5, 3, 2, '20220107 22:32:15', 30, 5),
		(6, 3, 5, '20220107 22:32:16', 20, 10),
		(7, 4, 1, '20220108 22:32:16', 50, 2),
		(8, 4, 3, '20220108 22:32:17', 40, 5),
		(9, 5, 4, '20220109 22:32:17', 50, 2),
		(10, 5, 5, '20220109 22:32:18', 20, 15)
-- Yêu cầu 2
create view Book_List as
select Book.BookCode, Title, Book.Price, Amount from BookSold
join Book
on BookSold.BookCode = Book.BookCode
-- Yêu cầu 3
create view CustomerDetail as
select BookSold.CustomerID, Customer.CustomerName, Customer.Address, Book.Title, Amount from BookSold
join Book
on BookSold.BookCode = Book.BookCode
join Customer
on Customer.CustomerID = BookSold.CustomerID
-- Yêu cầu 4, điều kiện hơi ảo ma nên em phải xem lại.
create view Customer_LastMonth as
select BookSold.CustomerID, Customer.CustomerName, Customer.Address, Book.Title from BookSold
join Book
on BookSold.BookCode = Book.BookCode
join Customer
on Customer.CustomerID = BookSold.CustomerID
where DATEDIFF(MONTH, BookSold.Date,GETDATE()) = 1
-- Yêu cầu 5
create view Bill as
select BookSold.CustomerID, Customer.CustomerName, sum(BookSold.Price * BookSold.Amount) as TotalPay from BookSold
join Customer
on Customer.CustomerID = BookSold.CustomerID
group by BookSold.CustomerID, Customer.CustomerName