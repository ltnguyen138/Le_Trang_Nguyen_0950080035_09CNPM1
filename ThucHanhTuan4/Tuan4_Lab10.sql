go
USE QLBanHang
go

go
----Cau 1a---------
INSERT INTO NhanVien (manv, tennv,  gioitinh, diachi, sodt, email, phong)
VALUES ('NV06', 'Nguyen Van A', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', N'Kế toán')
----Thực hiện full back up
BACKUP DATABASE [QLBanHang] TO DISK = 'D:\QLBH.bak' WITH INIT
go

go
----Cau 1b---------
INSERT INTO NhanVien (manv, tennv,  gioitinh, diachi, sodt, email, phong)
VALUES ('NV07', 'Nguyen Van B', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', N'Kế toán')
----Thực hiện different backup
BACKUP DATABASE [QLBanHang] TO DISK = 'D:\QLBHdifferentbackup.bak' WITH INIT
go

go
----Cau 1c---------
INSERT INTO NhanVien (manv, tennv,  gioitinh, diachi, sodt, email, phong)
VALUES ('NV15', 'Nguyen Van C', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', N'Kế toán')
----Thực hiện BACKUP LOG
BACKUP LOG [QLBanHang] TO DISK = 'D:\QLBH.trn' WITH  FORMAT;
go

go
----Cau 1d---------
INSERT INTO NhanVien (manv, tennv,  gioitinh, diachi, sodt, email, phong)
VALUES ('NV16', 'Nguyen Van C', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', N'Kế toán')
----Thực hiện BACKUP LOG
BACKUP LOG [QLBanHang] TO DISK = 'D:\QLBH.trn' WITH  NOINIT;
go

go
----Cau 2---------
RESTORE DATABASE QLBanHang
FROM DISK = 'D:\QLBH.bak'
WITH STANDBY = 'D:\QLBH_undoFile.undo';
go