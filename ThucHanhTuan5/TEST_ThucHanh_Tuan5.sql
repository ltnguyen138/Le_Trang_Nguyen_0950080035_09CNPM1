CREATE DATABASE QLKho
go
USE QLKho
go

CREATE TABLE Ton (
  MaVT INT PRIMARY KEY,
  TenVT VARCHAR(50),
  SoLuongT INT
);
CREATE TABLE Nhap (
  SoHDN INT PRIMARY KEY,
  MaVT INT,
  SoLuongN INT,
  DonGiaN FLOAT,
  NgayN DATE,
  FOREIGN KEY (MaVT) REFERENCES Ton(MaVT)
);

CREATE TABLE Xuat (
  SoHDX INT PRIMARY KEY,
  MaVT INT,
  SoLuongX INT,
  DonGiaX FLOAT,
  NgayX DATE,
  FOREIGN KEY (MaVT) REFERENCES Ton(MaVT)
);

go

INSERT INTO Ton (MaVT, TenVT, SoLuongT) VALUES
(1, 'Vật tư A', 150),
(2, 'Vật tư B', 200),
(3, 'Vật tư C', 300),
(4, 'Vật tư D', 150);
INSERT INTO Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN) VALUES
(1, 1, 100, 1000, '2023-04-21'),
(2, 2, 50, 500, '2023-04-21'),
(3, 3, 200, 1050, '2023-04-20');

INSERT INTO Xuat (SoHDX, MaVT, SoLuongX, DonGiaX, NgayX) VALUES
(1, 1, 50, 50, '2023-04-21'),
(2, 2, 20, 100, '2023-04-21'),
(3, 3, 100, 150, '2023-04-20');


go
--Cau 2---
CREATE FUNCTION ThongKeTienBan(@MaVT int, @NgayX DATE)
RETURNS TABLE
AS
RETURN (
SELECT x.MaVT, t.TenVT, SUM(SoLuongX * DonGiaX) AS TienBan
FROM Xuat x
INNER JOIN Ton t ON x.MaVT=t.MaVT
WHERE x.MaVT = @MaVT AND x.NgayX = @NgayX
GROUP BY x.MaVT,t.TenVT, NgayX
)
go
SELECT * FROM ThongKeTienBan(1,'2023-04-21')
go
--Cau 3--
CREATE FUNCTION TKTienNhap(@MaVT int, @NgayN DATE)
RETURNS TABLE
AS
RETURN (
SELECT MaVT, SUM(SoLuongN * DonGiaN) AS TienNhap
FROM Nhap
WHERE MaVT = @MaVT AND NgayN = @NgayN
GROUP BY MaVT, NgayN
)
go
SELECT * FROM TKTienNhap(1, '2023-04-21')
go

--Cau 4---
CREATE TRIGGER tg_Nhap
ON Nhap
AFTER INSERT
AS
BEGIN
DECLARE @SoLuongN int, @MaVT int
SELECT @SoLuongN=SoLuongN, @MaVT=MaVT FROM inserted
IF EXISTS (Select * FROM Ton WHERE @MaVT=MaVT)
	BEGIN
	UPDATE Ton
	SET SoLuongT=SoLuongT+@SoLuongN
	WHERE MaVT=@MaVT
	END
ELSE
	BEGIN
	RAISERROR ( N'Mã VT chưa có trong bản tồn',18,1)
	ROLLBACK
	END
END
go
INSERT INTO Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN) VALUES
(4, 2, 10000, 1000, '2023-04-21')
SELECT * FROM Ton