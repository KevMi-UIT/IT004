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
  KQ_NOKQUA AS (
    SELECT
      MAHV,
      MAMH,
      MAX(LANTHI) AS LANTHICUOI
    FROM
      KETQUATHI
    GROUP BY
      MAHV,
      MAMH
  ),
  FINALKQ AS (
    SELECT
      KETQUATHI.MAHV,
      KETQUATHI.MAMH,
      KQUA
    FROM
      KQ_NOKQUA
      INNER JOIN KETQUATHI ON (
        KQ_NOKQUA.MAHV = KETQUATHI.MAHV
        AND KQ_NOKQUA.MAMH = KETQUATHI.MAMH
        AND KQ_NOKQUA.LANTHICUOI = KETQUATHI.LANTHI
      )
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
WITH
  KQ_NOKQUA AS (
    SELECT
      MAHV,
      MAMH,
      MAX(LANTHI) AS LANTHICUOI
    FROM
      KETQUATHI
    GROUP BY
      MAHV,
      MAMH
  ),
  FINALKQ AS (
    SELECT
      KETQUATHI.MAHV,
      KETQUATHI.MAMH,
      KQUA
    FROM
      KQ_NOKQUA
      INNER JOIN KETQUATHI ON (
        KQ_NOKQUA.MAHV = KETQUATHI.MAHV
        AND KQ_NOKQUA.MAMH = KETQUATHI.MAMH
        AND KQ_NOKQUA.LANTHICUOI = KETQUATHI.LANTHI
      )
  ),
  DSLOPTRG AS (
    SELECT
      MAHV,
      HO,
      TEN
    FROM
      LOP
      INNER JOIN HOCVIEN ON LOP.TRGLOP = HOCVIEN.MAHV
  )
SELECT
  HO,
  TEN
FROM
  FINALKQ
  INNER JOIN DSLOPTRG ON FINALKQ.MAHV = DSLOPTRG.MAHV
WHERE
  KQUA = 'Khong Dat'
GROUP BY
  HO,
  TEN
HAVING
  COUNT(MAMH) > 3;

-- 26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
WITH
  DSHV910 AS (
    SELECT
      *
    FROM
      KETQUATHI
    WHERE
      DIEM BETWEEN 9 AND 10
  )
SELECT
  TOP (1)
WITH
  TIES HOCVIEN.MAHV,
  HOCVIEN.HO + HOCVIEN.TEN AS HOTEN,
  COUNT(MAMH) AS SODIEM910
FROM
  DSHV910
  INNER JOIN HOCVIEN ON DSHV910.MAHV = HOCVIEN.MAHV
GROUP BY
  HOCVIEN.MAHV
ORDER BY
  SODIEM910 DESC;

-- 27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
WITH
  DSHV910 AS (
    SELECT
      *
    FROM
      KETQUATHI
    WHERE
      DIEM BETWEEN 9 AND 10
  ),
  COUNT910_LOP AS (
    SELECT
      HOCVIEN.MALOP,
      HOCVIEN.MAHV,
      HOCVIEN.HO,
      HOCVIEN.TEN,
      COUNT(MAMH) AS SODIEM910
    FROM
      DSHV910
      INNER JOIN HOCVIEN ON DSHV910.MAHV = HOCVIEN.MAHV
    GROUP BY
      HOCVIEN.MALOP,
      HOCVIEN.HO,
      HOCVIEN.TEN,
      HOCVIEN.MAHV
  ),
  MAX910_LOP AS (
    SELECT
      MALOP,
      MAX(SODIEM910) AS MAX_SODIEM910
    FROM
      COUNT910_LOP
    GROUP BY
      MALOP
  )
SELECT
  HO,
  TEN
FROM
  MAX910_LOP
  INNER JOIN COUNT910_LOP ON (
    MAX910_LOP.MALOP = COUNT910_LOP.MALOP
    AND MAX910_LOP.MAX_SODIEM910 = COUNT910_LOP.SODIEM910
  );

-- 28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
WITH
  PHANCONG_MH AS (
    SELECT
      HOCKY,
      NAM,
      MAGV,
      COUNT(MAMH) AS SL_MH
    FROM
      GIANGDAY
    GROUP BY
      HOCKY,
      NAM,
      MAGV
  ),
  PHANCONG_LOP AS (
    SELECT
      HOCKY,
      NAM,
      MAGV,
      COUNT(MALOP) AS SL_MALOP
    FROM
      GIANGDAY
    GROUP BY
      HOCKY,
      NAM,
      MAGV
  )
SELECT
  PHANCONG_MH.HOCKY,
  PHANCONG_MH.NAM,
  PHANCONG_MH.MAGV,
  HOTEN,
  SL_MH,
  SL_MALOP
FROM
  PHANCONG_MH
  INNER JOIN PHANCONG_LOP ON (
    PHANCONG_MH.HOCKY = PHANCONG_LOP.HOCKY
    AND PHANCONG_MH.NAM = PHANCONG_LOP.NAM
    AND PHANCONG_MH.MAGV = PHANCONG_LOP.MAGV
  )
  INNER JOIN GIAOVIEN ON PHANCONG_MH.MAGV = GIAOVIEN.MAGV;

-- 29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
WITH
  PHANCONG_LOP AS (
    SELECT
      HOCKY,
      NAM,
      MAGV,
      COUNT(MALOP) AS SL_MALOP
    FROM
      GIANGDAY
    GROUP BY
      HOCKY,
      NAM,
      MAGV
  ),
  MAX_PHANCONG_LOP AS (
    SELECT
      HOCKY,
      NAM,
      MAX(SL_MALOP) AS MAX_SL_MALOP
    FROM
      PHANCONG_LOP
    GROUP BY
      HOCKY,
      NAM
  )
SELECT
  PHANCONG_LOP.HOCKY,
  PHANCONG_LOP.NAM,
  GIAOVIEN.MAGV,
  GIAOVIEN.HOTEN
FROM
  PHANCONG_LOP
  INNER JOIN MAX_PHANCONG_LOP ON (
    PHANCONG_LOP.HOCKY = MAX_PHANCONG_LOP.HOCKY
    AND PHANCONG_LOP.NAM = MAX_PHANCONG_LOP.NAM
    AND PHANCONG_LOP.SL_MALOP = MAX_PHANCONG_LOP.MAX_SL_MALOP
  )
  INNER JOIN GIAOVIEN ON PHANCONG_LOP.MAGV = GIAOVIEN.MAGV;

-- 30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
WITH
  KQTHIKD AS (
    SELECT
      MAMH,
      COUNT(MAHV) AS SOHV
    FROM
      KETQUATHI
    WHERE
      KQUA = 'Khong Dat'
      AND LANTHI = '1'
    GROUP BY
      MAMH
  )
SELECT
  TOP (1)
WITH
  TIES MONHOC.MAMH,
  TENMH
FROM
  KQTHIKD
  INNER JOIN MONHOC ON KQTHIKD.MAMH = MONHOC.MAMH
ORDER BY
  SOHV DESC;

-- 31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
WITH
  KQLANTHI1 AS (
    SELECT
      *
    FROM
      KETQUATHI
    WHERE
      LANTHI = '1'
  )
SELECT DISTINCT
  HOCVIEN.MAHV,
  HO,
  TEN
FROM
  KETQUATHI
  INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE
  HOCVIEN.MAHV NOT IN (
    SELECT
      MAHV
    FROM
      KQLANTHI1
    WHERE
      KQUA = 'Khong Dat'
  );

-- 32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
WITH
  KQ_NOKQUA AS (
    SELECT
      MAHV,
      MAMH,
      MAX(LANTHI) AS LANTHICUOI
    FROM
      KETQUATHI
    GROUP BY
      MAHV,
      MAMH
  ),
  FINALKQ AS (
    SELECT
      KETQUATHI.MAHV,
      KETQUATHI.MAMH,
      KQUA
    FROM
      KQ_NOKQUA
      INNER JOIN KETQUATHI ON (
        KQ_NOKQUA.MAHV = KETQUATHI.MAHV
        AND KQ_NOKQUA.MAMH = KETQUATHI.MAMH
        AND KQ_NOKQUA.LANTHICUOI = KETQUATHI.LANTHI
      )
  )
SELECT DISTINCT
  HOCVIEN.MAHV,
  HO,
  TEN
FROM
  KETQUATHI
  INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE
  HOCVIEN.MAHV NOT IN (
    SELECT
      MAHV
    FROM
      FINALKQ
    WHERE
      KQUA = 'Khong Dat'
  );

-- 33. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).
WITH
  KQLANTHI1 AS (
    SELECT
      *
    FROM
      KETQUATHI
    WHERE
      LANTHI = '1'
      AND KQUA = 'Dat'
  )
SELECT
  HOCVIEN.MAHV,
  HO + ' ' + TEN AS HOTEN
FROM
  KQLANTHI1 AS KQLANTHI1_1
  INNER JOIN HOCVIEN ON KQLANTHI1_1.MAHV = HOCVIEN.MAHV
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      MONHOC
    WHERE
      NOT EXISTS (
        SELECT
          *
        FROM
          KQLANTHI1 AS KQLANTHI1_2
        WHERE
          KQLANTHI1_1.MAHV = KQLANTHI1_2.MAHV
          AND MONHOC.MAMH = KQLANTHI1_2.MAMH
      )
  );

-- 34. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi sau cùng).
WITH
  KQ_NOKQUA AS (
    SELECT
      MAHV,
      MAMH,
      MAX(LANTHI) AS LANTHICUOI
    FROM
      KETQUATHI
    GROUP BY
      MAHV,
      MAMH
  ),
  FINALKQ AS (
    SELECT
      KETQUATHI.MAHV,
      KETQUATHI.MAMH,
      KQUA
    FROM
      KQ_NOKQUA
      INNER JOIN KETQUATHI ON (
        KQ_NOKQUA.MAHV = KETQUATHI.MAHV
        AND KQ_NOKQUA.MAMH = KETQUATHI.MAMH
        AND KQ_NOKQUA.LANTHICUOI = KETQUATHI.LANTHI
      )
  )
SELECT
  HOCVIEN.MAHV,
  HO + ' ' + TEN AS HOTEN
FROM
  FINALKQ AS FINALKQ_1
  INNER JOIN HOCVIEN ON FINALKQ_1.MAHV = HOCVIEN.MAHV
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      MONHOC
    WHERE
      NOT EXISTS (
        SELECT
          *
        FROM
          FINALKQ AS FINALKQ_2
        WHERE
          FINALKQ_1.MAHV = FINALKQ_2.MAHV
          AND MONHOC.MAMH = FINALKQ_2.MAMH
      )
  );

-- 35. ** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
WITH
  MAXDIEM AS (
    SELECT
      MAMH,
      MAX(DIEM) DIEMMAX
    FROM
      KETQUATHI
    GROUP BY
      MAMH
  )
SELECT
  HOCVIEN.MAHV,
  HO + ' ' + TEN AS HOTEN,
  KETQUATHI.MAMH
FROM
  MAXDIEM
  INNER JOIN KETQUATHI ON (
    MAXDIEM.MAMH = KETQUATHI.MAMH
    AND MAXDIEM.DIEMMAX = KETQUATHI.DIEM
  )
  INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV;
