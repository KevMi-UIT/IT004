-- 19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT
  MAKHOA,
  TENKHOA
FROM
  KHOA
WHERE
  NGTLAP = (
    SELECT
      MIN(NGTLAP)
    FROM
      KHOA
  );

-- 20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT
  COUNT(*) AS SOGV
FROM
  GIAOVIEN
WHERE
  HOCHAM IN ('GS', 'PGS');

-- 21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT
  MAKHOA,
  COUNT(*) AS SOGV
FROM
  GIAOVIEN
WHERE
  HOCVI IN ('CN', 'KS', 'ThS', 'TS', 'PTS')
GROUP BY
  MAKHOA;

-- 22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
WITH
  FINALKQ AS (
    SELECT
      MAHV,
      MAMH,
      MAX(LANTHI) AS LANTHICUOI,
      KQUA
    FROM
      KETQUATHI
    GROUP BY
      MAHV,
      MAMH,
      KQUA
  ),
  MHKHONGDAT AS (
    SELECT
      MH.MAMH,
      COUNT(MAHV) AS KHONGDAT
    FROM
      FINALKQ AS KQ
      INNER JOIN MONHOC AS MH ON KQ.MAMH = MH.MAMH
    WHERE
      KQUA = 'Khong Dat'
    GROUP BY
      MH.MAMH
  ),
  MHDAT AS (
    SELECT
      MH.MAMH,
      COUNT(MAHV) AS DAT
    FROM
      FINALKQ AS KQ
      INNER JOIN MONHOC AS MH ON KQ.MAMH = MH.MAMH
    WHERE
      KQUA = 'Dat'
    GROUP BY
      MH.MAMH
  )
SELECT
  MHDAT.MAMH,
  TENMH,
  KHONGDAT,
  DAT
FROM
  MONHOC
  INNER JOIN MHKHONGDAT ON MONHOC.MAMH = MHKHONGDAT.MAMH
  INNER JOIN MHDAT ON MHKHONGDAT.MAMH = MHDAT.MAMH;

-- 23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT
  MAGV,
  HOTEN
FROM
  LOP
  INNER JOIN GIAOVIEN ON LOP.MAGVCN = GIAOVIEN.MAGV
WHERE
  EXISTS (
    SELECT
      *
    FROM
      GIANGDAY
    WHERE
      GIAOVIEN.MAGV = GIANGDAY.MAGV
  );

-- 24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT
  HO + ' ' + TEN AS HOTEN
FROM
  HOCVIEN
  INNER JOIN LOP ON HOCVIEN.MALOP = LOP.MALOP
WHERE
  LOP.TRGLOP = HOCVIEN.MAHV
  AND LOP.SISO = (
    SELECT
      MAX(SISO)
    FROM
      LOP
  );

-- 25. * Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
-- 26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
-- 27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
-- 28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
-- 29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
-- 30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
-- 31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
-- 32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
-- 33. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).
-- 34. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi sau cùng).
-- 35. ** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
