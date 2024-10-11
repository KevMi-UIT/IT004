-- 1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN ADD GHICHU VARCHAR(20);

ALTER TABLE HOCVIEN ADD DIEMTB TINYINT;

ALTER TABLE HOCVIEN ADD XEPLOAI CHAR(2);

-- 2. Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”
-- ALTER TABLE HOCVIEN ADD CONSTRAINT CHK_MAHV CHECK (MAHV LIKE MALOP + '%');
ALTER TABLE HOCVIEN ADD CONSTRAINT CHK_MAHV CHECK (LEFT (MAHV, 3) = MALOP);

-- 3. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE HOCVIEN ADD CONSTRAINT CHK_HOCVIEN_GIOITINH CHECK (GIOITINH in ('Nam', 'Nu'));

ALTER TABLE GIAOVIEN ADD CONSTRAINT CHK_GIAOVIEN_GIOITINH CHECK (GIOITINH in ('Nam', 'Nu'));

-- 4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_DIEM CHECK (DIEM BETWEEN 0 AND 10);

-- 5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_KQUA CHECK (
  DIEM >= 5
  AND KQUA = 'Dat'
  OR DIEM < 5
  AND KQUA = 'Khong dat'
);

-- 6. Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_LANTHI CHECK (LANTHI BETWEEN 1 AND 3);

-- 7. Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY ADD CONSTRAINT CHK_HOCKY CHECK (HOCKY BETWEEN 1 AND 3);

-- 8. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHK_HOCVI CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'));

-- 9. Lớp trưởng của một lớp phải là học viên của lớp đó.
-- ALTER TABLE LOP ADD CONSTRAINT CHK_LOPTRUONG_LOP CHECK ();
--
-- 10. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”.
--
--
-- 11. Học viên ít nhất là 18 tuổi
ALTER TABLE HOCVIEN ADD CONSTRAINT CHK_HOCVIEN_TUOI CHECK (
  DATEDIFF (DAY, NGSINH, DATEADD (YEAR, -18, GETDATE ())) >= 0
);

-- 12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD CONSTRAINT CHK_TUNGAY_DENNGAY CHECK (DATEDIFF (DAY, TUNGAY, DENNGAY) > 0);

-- 13. Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHK_GIAOVIEN_TUOI CHECK (
  DATEDIFF (DAY, NGSINH, DATEADD (YEAR, -22, GETDATE ())) >= 0
);

-- 14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC ADD CONSTRAINT CHK_TCLT_TCTH CHECK (ABS(TCLT - TCTH) <= 3);

-- 15. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này.
--
--
-- 16. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
-- ALTER TABLE GIANGDAY ADD CONSTRAINT CHK_SO_LAN_HOC (
--   (
--     COUNT(*)
--     GROUP BY
--       (MALOP, YEAR (TUNGAY), HOCKY)
--   ) <= 3
-- )
--
-- 17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó.
