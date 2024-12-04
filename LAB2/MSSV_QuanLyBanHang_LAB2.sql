-- 1. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM
ALTER TABLE SANPHAM ADD GHICHU VARCHAR(20);

-- 2. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG
ALTER TABLE KHACHHANG ADD LOAIKH TINYINT;

-- 3. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành VARCHAR(100)
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU VARCHAR(100);

-- 4. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM
DROP COLUMN GHICHU;

-- 5. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, …
ALTER TABLE KHACHHANG
ALTER COLUMN LOAIKH NVARCHAR (10);

-- 6. Đơn vị tính của sản phẩm chỉ có thể là (“cay”, ”hop”, ”cai”, ”quyen”, ”chuc”)
ALTER TABLE SANPHAM ADD CONSTRAINT CHK_DVT CHECK (
  DVT = 'cay'
  OR DVT = 'hop'
  OR DVT = 'cai'
  OR DVT = 'chuc'
  OR DVT = 'quyen'
);

-- 7. Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE SANPHAM ADD CONSTRAINT CHK_GIA CHECK (GIA >= 500);

-- 8. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm
ALTER TABLE CTHD ADD CONSTRAINT CHK_SL CHECK (SL >= 1);

-- 9. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
ALTER TABLE KHACHHANG ADD CONSTRAINT CHK_NGSINH_NGDK CHECK (DATEDIFF (DAY, NGSINH, NGDK) > 0);

-- 1. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
SELECT
  * INTO SANPHAM1
FROM
  SANPHAM;

SELECT
  * INTO KHACHHANG1
FROM
  KHACHHANG;

-- 10. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
UPDATE SANPHAM1
SET
  GIA = GIA * 1.05
WHERE
  NUOCSX = 'Thai Lan';

-- 11. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1
SET
  GIA = GIA * 0.95
WHERE
  NUOCSX = 'Trung Quoc'
  AND GIA < 10000;

-- 12. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1)
UPDATE KHACHHANG1
SET
  LOAIKH = 'Vip'
WHERE
  (
    DATEDIFF (DAY, NGDK, '1/1/2007') > 0
    AND DOANHSO >= 10000000
  )
  OR (
    DATEDIFF (DAY, NGDK, '1/1/2007') <= 0
    AND DOANHSO >= 2000000
  );

-- 13. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT
  MASP,
  TENSP
FROM
  SANPHAM
WHERE
  NUOCSX = 'Trung Quoc';

-- 14. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”
SELECT
  MASP,
  TENSP
FROM
  SANPHAM
WHERE
  DVT IN ('cay', 'quyen');

-- CACH 3:
-- CACH 4:
-- 15. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”
SELECT
  *
FROM
  SANPHAM
WHERE
  MASP LIKE 'B%'
  AND MASP LIKE '%01';

-- 16. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
-- CACH 1
SELECT
  *
FROM
  SANPHAM
WHERE
  NUOCSX = 'Trung Quoc'
  AND GIA >= 30000
  AND GIA <= 40000;

-- CACH 2
SELECT
  *
FROM
  SANPHAM
WHERE
  NUOCSX = 'Trung Quoc'
  AND (GIA BETWEEN 30000 AND 40000);

-- 17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT
  *
FROM
  SANPHAM
WHERE
  NUOCSX IN ('Trung Quoc', 'Thai Lan')
  AND (GIA BETWEEN 30000 AND 40000);

-- 18. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
-- CACH 1
SET
  DATEFORMAT DMY
SELECT
  *
FROM
  HOADON
WHERE
  DATEDIFF (DAY, '1/1/2007', NGHD) >= 0
  AND DATEDIFF (DAY, '2/1/2007', NGHD) <= 0;

-- NGAY HOA DON SAU 1/1/2007 VA TRUOC NGAY 2/1/2007
-- 19. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
--CACH 1
SET
  DATEFORMAT DMY
SELECT
  SOHD,
  TRIGIA
FROM
  HOADON
WHERE
  DATEDIFF (DAY, '1/1/2007', NGHD) >= 0
  AND DATEDIFF (DAY, '31/1/2007', NGHD) <= 0
ORDER BY
  NGHD ASC,
  TRIGIA DESC;

-- CACH 2
SET
  DATEFORMAT DMY
SELECT
  SOHD,
  TRIGIA
FROM
  HOADON
WHERE
  MONTH (NGHD) = 1
  AND YEAR (NGHD) = 2007
ORDER BY
  NGHD ASC,
  TRIGIA DESC;

-- 20. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT
  *
FROM
  KHACHHANG KH,
  HOADON HD
WHERE
  KH.MAKH = HD.MAKH
  AND DATEDIFF (DAY, '1/1/2007', NGHD) = 0;

-- 21. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT
  *
FROM
  HOADON HD,
  NHANVIEN NV
WHERE
  HD.MANV = NV.MANV
  AND DATEDIFF (
    DAY,
    CONVERT(DATETIME, '10/28/2006', 101),
    CONVERT(DATETIME, NGHD, 101)
  ) = 0
  AND NV.HOTEN = 'Nguyen Van B';

-- 22. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
-- CACH 1
SELECT
  *
FROM
  SANPHAM SP,
  HOADON HD,
  CTHD CT,
  KHACHHANG KH
WHERE
  SP.MASP = CT.MASP
  AND HD.SOHD = CT.SOHD
  AND HD.MAKH = KH.MAKH
  AND KH.HOTEN = 'Nguyen Van A'
  AND MONTH (HD.NGHD) = '10'
  AND YEAR (HD.NGHD) = '2006';

-- CACH 2
SELECT
  *
FROM
  SANPHAM SP,
  (
    SELECT
      HD.SOHD,
      HD.MAKH,
      CT.MASP,
      NGHD
    FROM
      HOADON HD,
      CTHD CT
    WHERE
      HD.SOHD = CT.SOHD
  ) AS HDCT,
  KHACHHANG KH
WHERE
  SP.MASP = HDCT.MASP
  AND HDCT.MAKH = KH.MAKH
  AND KH.HOTEN = 'Nguyen Van A'
  AND MONTH (HDCT.NGHD) = '10'
  AND YEAR (HDCT.NGHD) = '2006';

-- 23. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT
  *
FROM
  HOADON HD,
  CTHD CT,
  SANPHAM SP
WHERE
  HD.SOHD = CT.SOHD
  AND CT.MASP = SP.MASP
  AND SP.MASP IN ('BB01', 'BB02');
