--Cau1--
CREATE DATABASE QLBH;

USE QLBH;

CREATE TABLE MATHANG (
  mahang INT PRIMARY KEY,
  tenhang VARCHAR(50) NOT NULL,
  soluong INT NOT NULL
);

CREATE TABLE NHATKYBANHANG (
  stt INT PRIMARY KEY,
  ngay DATE NOT NULL,
  nguoimua VARCHAR(50) NOT NULL,
  mahang INT NOT NULL,
  soluong INT NOT NULL,
  giaban FLOAT NOT NULL,
  FOREIGN KEY (mahang) REFERENCES MATHANG(mahang)
);

--Cau2--
Insert into MATHANG (MaHang, tenHang,SoLuong)
VALUES ('1','Keo','100'),('2','Banh','200'),('3','Thuoc','100')

Insert into NHATKYBANHANG  (STT, Ngay, NguoiMua, MaHang, SoLuong, GiaBan)
Values ('1','1999-02-09','ab','2','230','50000')
GO
--Cau3a--
CREATE TRIGGER trg_nhatkybanhang_insert
ON NHATKYBANHANG
AFTER INSERT
AS
BEGIN
	UPDATE MATHANG
	SET soluong = MATHANG.soluong - inserted.soluong
	FROM MATHANG
	INNER JOIN inserted ON MATHANG.mahang = inserted.mahang
	END;
	go
	--Cau3b--
	CREATE TRIGGER trg_nhatkybanhang_update
	ON NHATKYBANHANG
	AFTER UPDATE
	AS
	BEGIN
		IF UPDATE(soluong)
		BEGIN
		UPDATE MATHANG
		SET soluong = MATHANG.soluong + deleted.soluong - inserted.soluong
		FROM MATHANG
		INNER JOIN deleted ON MATHANG.mahang = deleted.mahang
		INNER JOIN inserted ON MATHANG.mahang = inserted.mahang
	END
END;
go
--Cau3c--
CREATE TRIGGER trg_nhatkybanhang_insertt
ON NHATKYBANHANG
FOR INSERT
AS
BEGIN
	DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT

	SELECT @mahang = mahang, @soluong = soluong
	FROM inserted

	SELECT @soluong_hien_co = soluong
	FROM MATHANG
	WHERE mahang = @mahang

	IF @soluong <= @soluong_hien_co
	BEGIN
		UPDATE MATHANG
		SET soluong = soluong - @soluong
		WHERE mahang = @mahang
		END
		ELSE
		BEGIN
		RAISERROR('Số lượng hàng bán ra phải nhỏ hơn hoặc bằng số lượng hàng hiện có!', 16, 1)
		ROLLBACK TRANSACTION
	END
END;
go
--Cau3d--
CREATE TRIGGER tr_nhatkybanhang_update
ON NHATKYBANHANG
FOR UPDATE
AS
BEGIN
IF (SELECT COUNT(*) FROM inserted) > 1
BEGIN
	RAISERROR('Chỉ được cập nhật 1 bản ghi tại một thời điểm!', 16, 1)
	ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT
		SELECT @mahang = mahang, @soluong = soluong
		FROM inserted

		SELECT @soluong_hien_co = soluong
		FROM MATHANG
		WHERE mahang = @mahang

		UPDATE MATHANG
		SET soluong = soluong + (SELECT soluong FROM deleted) - @soluong
		WHERE mahang = @mahang
	END
END;
go
--Cau3e--
CREATE TRIGGER tg_nhatkybanhang_delete
ON NHATKYBANHANG
FOR DELETE
AS
BEGIN
	IF (SELECT COUNT(*) FROM deleted) > 1
	BEGIN
		RAISERROR('Chỉ được xóa 1 bản ghi tại một thời điểm!', 16, 1)
		ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
		DECLARE @mahang INT, @soluong INT
		SELECT @mahang = mahang, @soluong = soluong
		FROM deleted
		UPDATE MATHANG
		SET soluong = soluong + @soluong
		WHERE mahang = @mahang
	END
END;
go
--Cau3f--
CREATE TRIGGER tg_nhatkybanhang_update
ON NHATKYBANHANG
FOR UPDATE
AS
BEGIN
	DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT

	SELECT @mahang = mahang, @soluong = soluong
	FROM inserted

	SELECT @soluong_hien_co = soluong
	FROM MATHANG
	WHERE mahang = @mahang

	IF @soluong > @soluong_hien_co
	BEGIN
		RAISERROR('Số lượng cập nhật không được vượt quá số lượng hiện có!', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE IF @soluong = @soluong_hien_co
	BEGIN
		RAISERROR('Không cần cập nhật số lượng!', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		UPDATE MATHANG
		SET soluong = soluong + (SELECT soluong FROM deleted) - @soluong
		WHERE mahang = @mahang
	END
END;
go
--Cau3g--
CREATE PROCEDURE p_xoa_mathang
@mahang INT
AS
BEGIN
IF NOT EXISTS (SELECT * FROM MATHANG WHERE mahang = @mahang)
BEGIN
PRINT 'Mã hàng không tồn tại!'
RETURN
END

BEGIN TRANSACTION

DELETE FROM NHATKYBANHANG WHERE mahang = @mahang
DELETE FROM MATHANG WHERE mahang = @mahang

COMMIT TRANSACTION

PRINT 'Xóa mặt hàng thành công!'
END


--Cau3i--
-- Test cho câu 2
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
-- Test cho câu 3a
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(6, '2022-04-22', 'Nguyễn Thị F', 1, 3, 15000)
SELECT * FROM MATHANG
-- Test cho câu 3b
UPDATE NHATKYBANHANG SET soluong = 2 WHERE stt = 2
SELECT * FROM MATHANG
-- Test cho câu 3c
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(8, '2022-04-23', 'Trương Văn G', 2, 10, 12000)
SELECT * FROM MATHANG
-- Test cho câu 3d
UPDATE NHATKYBANHANG SET soluong = 10 WHERE stt = 1
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
-- Test cho câu 3e
DELETE FROM NHATKYBANHANG WHERE stt = 4
SELECT * FROM MATHANG
-- Test cho câu 3f
UPDATE NHATKYBANHANG SET soluong = 70 WHERE stt = 5
SELECT * FROM MATHANG
-- Test cho câu 3g
go
EXEC p_xoa_mathang 1 
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG

