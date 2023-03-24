CREATE DATABASE QLBanHang
GO
USE  QLBanHang
GO

CREATE TABLE Hangsx (
  mahangsx NCHAR(10) PRIMARY KEY,
  tenhang NVARCHAR(20),
  diachi VARCHAR(30),
  sodt VARCHAR(20),
  email VARCHAR(30)
);
CREATE TABLE Sanpham (
  masp NCHAR(10) PRIMARY KEY,
  mahangsx NCHAR(10),
  tensp NVARCHAR(20),
  soluong INT,
  mausac NVARCHAR(20),
  giaban MONEY,
  donvitinh NCHAR(10),
  mota VARCHAR(255),
  FOREIGN KEY (mahangsx) REFERENCES Hangsx(mahangsx)
);
CREATE TABLE Nhanvien (
  manv NCHAR(10) PRIMARY KEY,
  tennv NVARCHAR(20),
  gioitinh NCHAR(10),
  diachi NVARCHAR(30),
  sodt NVARCHAR(20),
  email NVARCHAR(30),
  phong NVARCHAR(30)
);
CREATE TABLE Nhap (
  sohdn NCHAR(10) PRIMARY KEY,
  masp NCHAR(10),
  manv NCHAR(10),
  ngaynhap DATE,
  soluongN INT,
  dongiaN MONEY,
  FOREIGN KEY (masp) REFERENCES Sanpham(masp),
  FOREIGN KEY (manv) REFERENCES Nhanvien(manv)
);
CREATE TABLE Xuat (
  sohdx NCHAR(10) PRIMARY KEY,
  masp NCHAR(10),
  manv NCHAR(10),
  ngayxuat DATE,
  soluongX INT,
  FOREIGN KEY (masp) REFERENCES Sanpham(masp),
  FOREIGN KEY (manv) REFERENCES Nhanvien(manv)
);
INSERT INTO Hangsx(mahangsx, tenhang, diachi, sodt, email)
VALUES('H01','Samsung','Korea','011-08271717','ss@gmail.com.kr'),
('H02','OPPO','China','081-08626262','oppo@gmail.com.cn') ,
('H03','Vinfone',N'Việt nam','084-098262626','vf@gmail.com.vn') 
 
INSERT INTO Sanpham(masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota) 
VALUES('SP01','H02','F1 Plus',100,N'Xám',7000000,N'Chiếc',N'Hàng cận cao cấp'),
('SP02','H01','Galaxy Note 11',50,N'Đỏ',1900000,N'Chiếc',N'Hàng cao cấp'),
('SP03', 'H02', 'F3 lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
('SP04', 'H03', 'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông'),
('SP05', 'H01', 'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp');

INSERT INTO Nhanvien VALUES
('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'),
('NV02', N'Lê Văn Nam', 'Nam', N'Bắc Ninh', '0972525252', 'nam@gmail.com', N'Vật tư'),
('NV03', N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0328388388', 'hb@gmail.com', N'Kế toán');

INSERT INTO Nhap VALUES
('N01', 'SP02', 'NV01', '02-05-2019', 10, 17000000),
('N02', 'SP01','NV02','04-07-2020',30,6000000),
('N03', 'SP04','NV02','05-17-2020',20,1200000),
('N04', 'SP01','NV03','03-22-2020',10,6200000),
('N05', 'SP05','NV01','07-07-2020',20,7000000);

INSERT INTO Xuat VALUES
('X01', 'SP03', 'NV02', '06-14-2020', 5),
('X02', 'SP01', 'NV03', '03-05-2019', 3),
('X03', 'SP02', 'NV01', '12-12-2020', 1),
('X04', 'SP03', 'NV02', '06-02-2020', 2),
('X05', 'SP05', 'NV01', '05-18-2020', 1);




 

