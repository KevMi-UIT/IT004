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

-- ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_KQUA CHECK (
--   KQUA = CASE
--     WHEN DIEM BETWEEN 5 AND 10  THEN 'Dat'
--     ELSE 'Khong dat'
--   END
-- );
-- 
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
--
--
-- 18. Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC trong cùng một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và (“B”,”A”).
--
--
-- 19. Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa
UPDATE GIAOVIEN
SET
  MUCLUONG = MUCLUONG * 1.2;

-- 20. Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
-- not done
-- SELECT
--   MAHV,
--   MAMH,
--   MAX(DIEM)
-- FROM
--   KETQUATHI
-- ORDER BY
--   NGTHI DESC;
--
-- WITH
--   HOCVIEN_KETQUATHI AS (
--     SELECT
--       MAHV,
--       MAX(DIEMTB) AS DIEMTB_MAX
--     FROM
--       (
--         SELECT
--           MAHV,
--           DIEMTB
--         FROM
--           -- (SELECT MAHV, DIEMTB FROM  KETQUATHI GROUP BY MAHV, MAMH)
--         ORDER BY
--           DIEM DESC
--       )
--     GROUP BY
--       MAHV
--   )
-- UPDATE HOCVIEN
-- SET
--   DIEMTB = HOCVIEN_KETQUATHI.DIEMTB_MAX;
--
-- 21. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN
SET
  GHICHU = 'Cam thi'
FROM
  HOCVIEN,
  KETQUATHI
WHERE
  (
    HOCVIEN.MAHV = KETQUATHI.MAHV
    AND KETQUATHI.LANTHI = 3
    AND KETQUATHI.DIEM < 5
  );

-- 22. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
--   a. Nếu DIEMTB ≥ 9 thì XEPLOAI = “XS”
--   b. Nếu 8 ≤ DIEMTB < 9 thì XEPLOAI = “G”
--   c. Nếu 6.5 ≤ DIEMTB < 8 thì XEPLOAI = “K”
--   d. Nếu 5 ≤ DIEMTB < 6.5 thì XEPLOAI = “TB”
--   e. Nếu DIEMTB < 5 thì XEPLOAI = “Y”
UPDATE HOCVIEN
SET
  XEPLOAI = CASE
    WHEN DIEMTB >= 9 THEN 'XS'
    WHEN DIEMTB >= 8 THEN 'G'
    WHEN DIEMTB >= 6.5 THEN 'K'
    WHEN DIEMTB >= 5 THEN 'TB'
    ELSE 'y'
  END;

-- 23. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT DISTINCT
  MAHV,
  HOTEN = HO + ' ' + TEN,
  NGSINH,
  LOP.MALOP
FROM
  HOCVIEN
  INNER JOIN LOP on HOCVIEN.MAHV = LOP.TRGLOP;

-- 24. In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT DISTINCT
  HOCVIEN.MAHV,
  HOTEN = HO + ' ' + TEN,
  LANTHI,
  DIEM
FROM
  HOCVIEN
  INNER JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE
  MAMH = 'CTRR';

-- 25. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT DISTINCT
  HOCVIEN.MAHV,
  HOTEN = HO + ' ' + TEN,
  MAMH
FROM
  HOCVIEN
  INNER JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE
  LANTHI = 1
  AND KQUA = 'Dat';

-- 26. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1)
SELECT DISTINCT
  HOCVIEN.MAHV,
  HOTEN = HO + ' ' + TEN
FROM
  HOCVIEN
  INNER JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE
  MAMH = 'CTRR'
  AND LANTHI = 1
  AND KQUA = 'Khong Dat';

-- 27. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
WITH
  GIAOVIEN_TTT AS (
    SELECT
      MAGV
    FROM
      GIAOVIEN
    WHERE
      HOTEN = 'Tran Tam Thanh'
  )
SELECT DISTINCT
  MAMH
FROM
  GIANGDAY
  INNER JOIN GIAOVIEN_TTT ON GIANGDAY.MAGV = GIAOVIEN_TTT.MAGV
WHERE
  HOCKY = 1
  AND YEAR (TUNGAY) = 2006;

-- 28. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
WITH
  GIAOVIEN_CN AS (
    SELECT
      MAGVCN
    FROM
      LOP
    WHERE
      MALOP = 'K11'
  )
SELECT DISTINCT
  MAMH
FROM
  GIANGDAY
  INNER JOIN GIAOVIEN_CN ON GIANGDAY.MAGV = GIAOVIEN_CN.MAGVCN
WHERE
  HOCKY = 1
  AND YEAR (TUNGAY) = 2006;

-- 29.Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT DISTINCT
  HOTEN = HOCVIEN.HO + ' ' + HOCVIEN.TEN
FROM
  GIANGDAY
  INNER JOIN GIAOVIEN ON GIANGDAY.MAGV = GIAOVIEN.MAGV
  INNER JOIN MONHOC ON GIANGDAY.MAMH = MONHOC.MAMH
  INNER JOIN LOP ON GIANGDAY.MALOP = LOP.MALOP
  INNER JOIN HOCVIEN ON LOP.TRGLOP = HOCVIEN.MAHV
WHERE
  GIAOVIEN.HOTEN = 'Nguyen To Lan'
  AND MONHOC.TENMH = 'Co so du lieu';

-- 30.In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
WITH
  DS_MAMH_TRUOC AS (
    SELECT
      MAMH_TRUOC
    FROM
      MONHOC
      INNER JOIN DIEUKIEN ON MONHOC.MAMH = DIEUKIEN.MAMH
    WHERE
      TENMH = 'Co so du lieu'
  )
SELECT DISTINCT
  TENMH
FROM
  DS_MAMH_TRUOC
  INNER JOIN MONHOC ON DS_MAMH_TRUOC.MAMH_TRUOC = MONHOC.MAMH;

-- 31.Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
WITH
  LOP_K11_K12 AS (
    SELECT
      MALOP
    FROM
      LOP
    WHERE
      MALOP = 'K11'
      OR MALOP = 'K12'
  ),
  GV_CTRR AS (
    SELECT
      MALOP,
      HOTEN
    FROM
      GIANGDAY
      INNER JOIN GIAOVIEN ON GIANGDAY.MAGV = GIAOVIEN.MAGV
    WHERE
      MAMH = 'CTRR'
  )
SELECT DISTINCT
  HOTEN
FROM
  GV_CTRR AS GV_CTRR_1
WHERE
  NOT EXISTS (
    SELECT
      MALOP
    FROM
      LOP_K11_K12
    EXCEPT
    (
      SELECT
        MALOP
      FROM
        GV_CTRR AS GV_CTRR_2
      WHERE
        GV_CTRR_1.HOTEN = GV_CTRR_2.HOTEN
    )
  );
