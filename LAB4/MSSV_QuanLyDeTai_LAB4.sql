-- 2. TRUY VẤN
-- Q1: Cho biết họ tên và mức lương của các giáo viên nữ
SELECT
  HOTEN,
  LUONG
FROM
  GIAOVIEN
WHERE
  PHAI = N'Nữ';

-- Q2: Cho biết họ tên của các giáo viên và lương của họ sau khi tăng lương 10%
SELECT
  HOTEN,
  LUONG * 1.1 AS LUONG_SAU_TANG
FROM
  GIAOVIEN;

-- Q3: Cho biết mã của các giáo viên có họ tên bắt đầu bằng "Nguyễn" và lương trên $2000 hoặc giáo viên là trưởng bộ môn nhận chức sau 1995
SELECT
  MAGV
FROM
  GIAOVIEN
WHERE
  HOTEN LIKE N'Nguyễn%'
  AND LUONG > 2000
UNION
SELECT
  BM.TRUONGBM AS MAGV
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
WHERE
  YEAR(BM.NGNHANCHUC) > 1995;

-- Q4: Cho biết tên những giáo viên khoa công nghệ thông tin
SELECT
  GV.HOTEN AS HOTEN_GV_CNTT,
  GV.MAGV AS MAGV
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON (GV.MABM = BM.MABM)
  JOIN KHOA K ON (BM.MAKHOA = K.MAKHOA)
WHERE
  K.TENKHOA = N'Công nghệ thông tin';

-- Q5: Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó
SELECT
  BM.MABM,
  BM.TENBM,
  GV.MAGV AS MA_TRUONGBM,
  GV.HOTEN AS HOTEN_TRUONGBM
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV;

-- Q6: Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc
SELECT
  GV.MAGV,
  GV.HOTEN,
  BM.*
FROM
  GIAOVIEN GV,
  BOMON BM
WHERE
  GV.MABM = BM.MABM;

-- Q7: Cho biết tên đề tài và giáo viên chủ nhiệm đề tài
SELECT
  TENDT,
  GVCNDT
FROM
  DETAI;

-- Q8: Với mỗi khoa cho biết thông tin trưởng khoa
SELECT
  K.TENKHOA,
  GV.MAGV AS MAGV_TRUONGKHOA,
  GV.HOTEN AS HOTEN_TRUONGKHOA
FROM
  KHOA K,
  GIAOVIEN GV
WHERE
  K.TRUONGKHOA = GV.MAGV;

-- Q9: Cho biết các giáo viên của bộ môn "Vi sinh" có tham gia đề tài 006
SELECT
  GV.MAGV AS MAGV
FROM
  GIAOVIEN GV,
  BOMON BM
WHERE
  GV.MABM = BM.MABM
  AND BM.TENBM = N'Vi sinh'
INTERSECT
SELECT
  GVCNDT AS MAGV
FROM
  DETAI
WHERE
  MADT = '006';

-- Q10: Với những đề tài thuộc cấp quản lý "Thành phố", cho biết mã đề tài, đề tài thuộc về chủ đề nào, họ tên người chủ nhiệm đề tài cùng với ngày sinh ngày sinh và địa chỉ của người ấy
SELECT
  DT.MADT,
  DT.MACD,
  GV.HOTEN,
  GV.NGAYSINH,
  GV.DIACHI
FROM
  DETAI DT
  JOIN CHUDE CD ON DT.MACD = CD.MACD
  JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
WHERE
  DT.CAPQL = N'Thành phố';

-- Q11: Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
SELECT
  GV.HOTEN,
  QLCM.HOTEN AS HOTEN_QLCM
FROM
  GIAOVIEN AS GV,
  GIAOVIEN AS QLCM
WHERE
  GV.GVQLCM = QLCM.MAGV;

-- Q12: Tìm họ tên của từng giáo viên được "Nguyễn Thanh Tùng " phụ trách trực tiếp
SELECT
  HOTEN
FROM
  GIAOVIEN
WHERE
  GVQLCM = (
    SELECT
      MAGV
    FROM
      GIAOVIEN
    WHERE
      HOTEN = N'Nguyễn Thanh Tùng'
  );

-- Q13: CHo biết tên giáo viên là trưởng bộ môn "Hệ thống thông tin"
SELECT
  GV.HOTEN AS TRUONGBM_HTTT
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
WHERE
  BM.TENBM = N'Hệ thống thông tin';

-- Q14: Cho biết tên người chuur nhiệm đề tài của những đề tài thuộc chủ đề quản lý giáo dục
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV,
  DETAI DT,
  CHUDE CD
WHERE
  GV.MAGV = DT.GVCNDT
  AND DT.MACD = CD.MACD
  AND CD.TENCD = N'Quản lý giáo dục';

-- Q15: Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu trong tháng 3/2008
SELECT
  CV.TENCV
FROM
  CONGVIEC CV
  JOIN DETAI DT ON CV.MADT = DT.MADT
WHERE
  DT.TENDT = N'HTTT quản lý các trường ĐH'
  AND MONTH(CV.NGAYBD) = 3
  AND YEAR(CV.NGAYBD) = 2008;

-- Q16: Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó
SELECT
  GV.HOTEN,
  QLCM.HOTEN AS HOTEN_QLCM
FROM
  GIAOVIEN AS GV,
  GIAOVIEN AS QLCM
WHERE
  GV.GVQLCM = QLCM.MAGV;

-- Q17: Cho các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007
SELECT
  *
FROM
  CONGVIEC
WHERE
  NGAYBD BETWEEN '2007-01-01' AND '2007-08-01';

-- Q18: Cho biết họ tên các giáo viên cùng bộ môn với giáo viên "Trần Trà Hương"
SELECT
  HOTEN
FROM
  GIAOVIEN
WHERE
  HOTEN != N'Trần Trà Hương'
  AND MABM = (
    SELECT
      MABM
    FROM
      GIAOVIEN
    WHERE
      HOTEN = N'Trần Trà Hương'
  );

-- Q19: Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài
SELECT DISTINCT
  GV.HOTEN AS TRUONGBM_CNDT
FROM
  GIAOVIEN GV,
  DETAI DT,
  BOMON BM
WHERE
  BM.TRUONGBM = DT.GVCNDT
  AND GV.MAGV = BM.TRUONGBM;

-- Q20: Cho biết tên những giáo viên vừa là trưởng khoa vừa là trưởng bộ môn
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV,
  KHOA K,
  BOMON BM
WHERE
  K.TRUONGKHOA = BM.TRUONGBM
  AND GV.MAGV = K.TRUONGKHOA;

-- Q21: Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài
SELECT DISTINCT
  GV.HOTEN AS TRUONGBM_CNDT
FROM
  GIAOVIEN GV,
  DETAI DT,
  BOMON BM
WHERE
  BM.TRUONGBM = DT.GVCNDT
  AND GV.MAGV = BM.TRUONGBM;

-- Q22: Cho nbieets mã số các trưởng khoa có chủ nhiệm đề tài
SELECT DISTINCT
  DT.GVCNDT AS TRUONGKHOA_CNDT
FROM
  DETAI DT,
  KHOA K
WHERE
  K.TRUONGKHOA = DT.GVCNDT;

-- Q23: Cho biết mã số các giáo viên thuộc bộ môn "HTTT" hoặc có tham gia đề tài mã 001
SELECT
  GV.MAGV
FROM
  GIAOVIEN GV
WHERE
  MABM = 'HTTT'
UNION
SELECT
  MAGV
FROM
  THAMGIADT
WHERE
  MADT = '001';

-- Q24: Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002
SELECT
  MAGV
FROM
  GIAOVIEN
WHERE
  MAGV != '002'
  AND MABM = (
    SELECT
      MABM
    FROM
      GIAOVIEN
    WHERE
      MAGV = '002'
  );

-- Q25: Tìm những giáo viên là trưởng bộ môn
SELECT
  GV.MAGV,
  GV.HOTEN
FROM
  GIAOVIEN GV,
  BOMON BM
WHERE
  BM.TRUONGBM = GV.MAGV;

-- Q26: Cho biết họ tên và mức lương của các giáo viên
SELECT
  HOTEN,
  LUONG
FROM
  GIAOVIEN;

-- Q27: Cho biết SLGV và tổng lương của họ
SELECT
  COUNT(*) AS SLGV,
  SUM(LUONG) AS TongLuong
FROM
  GIAOVIEN;

-- Q28: Cho biết SLGV và lương TB của từng bộ môn
SELECT
  COUNT(*) AS SLGV,
  AVG(LUONG) AS LuongTB
FROM
  GIAOVIEN
GROUP BY
  MABM;

-- Q29: Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó
SELECT
  CD.TENCD,
  COUNT(*) AS SLDT
FROM
  CHUDE CD
  JOIN DETAI DT ON CD.MACD = DT.MACD
GROUP BY
  CD.MACD,
  CD.TENCD;

-- Q30: Cho biết tên giáo viên và số lượng đề tài giáo viên đó tham gia
SELECT
  GV.HOTEN,
  COUNT(DISTINCT TGDT.MADT) AS SLDTTG
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
GROUP BY
  GV.MAGV,
  GV.HOTEN;

-- Q31: Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm
SELECT
  GV.HOTEN,
  COUNT(*) AS SLDTCN
FROM
  GIAOVIEN GV
  JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
GROUP BY
  GV.MAGV,
  GV.HOTEN;

-- Q32: Với mỗi giáo viên, cho tên giáo viên và số người thân của giáo viên đó
SELECT
  GV.HOTEN,
  COUNT(NT.TEN) AS SO_NGUOI_THAN
FROM
  GIAOVIEN GV
  LEFT JOIN NGUOITHAN NT ON GV.MAGV = NT.MAGV
GROUP BY
  GV.MAGV,
  GV.HOTEN;

-- Q33: Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên
SELECT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
GROUP BY
  GV.MAGV,
  GV.HOTEN
HAVING
  COUNT(DISTINCT TGDT.MADT) >= 3;

-- Q34: Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh
SELECT
  COUNT(DISTINCT TGDT.MAGV) AS SLGV_THAMGIA_UDHHX
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  DT.TENDT = N'Ứng dụng hóa học xanh'
GROUP BY
  DT.MADT;

-- Q35: Cho biết mức lương cao nhất của các giảng viên
-- C1: 
SELECT
  MAX(LUONG) AS MAX_LUONG
FROM
  GIAOVIEN;

-- C2: 
SELECT DISTINCT
  LUONG AS MAX_Luong
FROM
  GIAOVIEN GV
WHERE
  LUONG >= ALL (
    SELECT
      LUONG
    FROM
      GIAOVIEN
  );

-- Q36: Cho biết những giáo viên có lương cao nhất
-- C1
SELECT
  GV.MAGV,
  GV.HOTEN,
  GV.LUONG
FROM
  GIAOVIEN GV
WHERE
  LUONG = (
    SELECT
      MAX(LUONG)
    FROM
      GIAOVIEN
  );

-- C2
SELECT
  GV.MAGV,
  GV.HOTEN,
  GV.LUONG
FROM
  GIAOVIEN GV
WHERE
  GV.LUONG >= ALL (
    SELECT
      LUONG
    FROM
      GIAOVIEN
  );

-- Q37: Cho biết lương cao nhất trong bộ môn HTTT
--C1
SELECT
  MAX(LUONG) AS LUONG_MAX_HTTT
FROM
  (
    SELECT
      *
    FROM
      GIAOVIEN
    WHERE
      MABM = 'HTTT'
  ) AS GV_HTTT;

--C2
SELECT DISTINCT
  LUONG AS MAX_LUONG_HTTT
FROM
  GIAOVIEN
WHERE
  LUONG >= ALL (
    SELECT
      LUONG
    FROM
      GIAOVIEN
    WHERE
      MABM = 'HTTT'
  );

-- C3
SELECT
  MAX(LUONG)
FROM
  GIAOVIEN
WHERE
  MABM = 'HTTT';

-- Q38: Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin
--C1
SELECT
  TOP 1 GV.HOTEN AS GV_GIA_NHAT
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE
  BM.TENBM = N'Hệ thống thông tin'
ORDER BY
  GV.NGSINH;

--C2
SELECT
  HOTEN
FROM
  (
    SELECT
      *
    FROM
      GIAOVIEN
    WHERE
      MABM IN (
        SELECT
          MABM
        FROM
          BOMON
        WHERE
          TENBM = N'Hệ thống thông tin'
      )
  ) AS GV
WHERE
  GV.NGSINH = (
    SELECT
      MIN((GV2.NGSINH))
    FROM
      GIAOVIEN GV2
      JOIN BOMON BM ON GV2.MABM = BM.MABM
    WHERE
      BM.TENBM = N'Hệ thống thông tin'
  );

-- Q39: Cho biết tên giáo viên nhỏ tuổi nhất khoa CNTT
--C1
SELECT
  TOP 1 GV.HOTEN AS GV_GIA_NHAT
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE
  BM.MAKHOA = 'CNTT'
ORDER BY
  GV.NGAYSINH DESC;

--C2
SELECT
  HOTEN
FROM
  (
    SELECT
      *
    FROM
      GIAOVIEN
    WHERE
      MABM IN (
        SELECT
          MABM
        FROM
          BOMON
        WHERE
          MAKHOA = 'CNTT'
      )
  ) AS GV
WHERE
  GV.NGAYSINH IN (
    SELECT
      MAX((GV2.NGAYSINH))
    FROM
      GIAOVIEN GV2
      JOIN BOMON BM ON GV2.MABM = BM.MABM
    WHERE
      BM.MAKHOA = 'CNTT'
  );

-- Q40: Cho biết tên giáo viên và tên khoa của gv có lương cao nhất
--C1
SELECT
  GV.HOTEN,
  K.TENKHOA,
  GV.LUONG
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
  JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
WHERE
  GV.LUONG = (
    SELECT
      MAX(LUONG)
    FROM
      GIAOVIEN
  );

--C2
SELECT
  GV.HOTEN,
  K.TENKHOA,
  GV.LUONG
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
  JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
WHERE
  GV.LUONG >= ALL (
    SELECT
      (LUONG)
    FROM
      GIAOVIEN
  );

-- Q41: Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ
SELECT
  GV.MAGV,
  GV.HOTEN,
  GV.MABM,
  GV.LUONG
FROM
  GIAOVIEN GV
WHERE
  GV.LUONG = (
    SELECT
      MAX(LUONG)
    FROM
      GIAOVIEN GV2
    WHERE
      GV.MABM = GV2.MABM
  );

-- Q42: Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia
SELECT
  TENDT
FROM
  DETAI
WHERE
  MADT NOT IN (
    SELECT DISTINCT
      MADT
    FROM
      THAMGIADT
    WHERE
      MAGV = (
        SELECT
          MAGV
        FROM
          GIAOVIEN
        WHERE
          HOTEN = N'Nguyễn Hoài An'
      )
  );

---Cách 2
SELECT
  TENDT,
  DT.MADT
FROM
  DETAI DT
  LEFT JOIN THAMGIADT TG ON DT.MADT = TG.MADT
EXCEPT
SELECT
  TENDT,
  DT.MADT
FROM
  THAMGIADT TG,
  DETAI DT,
  GIAOVIEN GV
WHERE
  TG.MADT = DT.MADT
  AND TG.MAGV = GV.MAGV
  AND GV.HOTEN = N'Nguyễn Hoài An'
  ---CACH 3
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  LEFT JOIN THAMGIADT TG ON TG.MADT = DT.MADT
WHERE
  TG.MAGV IS NULL
  OR NOT EXISTS (
    SELECT
      *
    FROM
      GIAOVIEN GV02
    WHERE
      GV02.MAGV = TG.MAGV
      AND GV02.HOTEN = N'Nguyễn Hoài An'
  );

-- Q43: Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài và tên người chủ nhiệm đề tài
SELECT
  TENDT,
  HOTEN AS GVCNDT
FROM
  DETAI DT
  JOIN GIAOVIEN GV ON GV.MAGV = DT.GVCNDT
WHERE
  MADT NOT IN (
    SELECT DISTINCT
      MADT
    FROM
      THAMGIADT
    WHERE
      MAGV = (
        SELECT
          MAGV
        FROM
          GIAOVIEN
        WHERE
          HOTEN = N'Nguyễn Hoài An'
      )
  );

-- Q44: Cho biết tên những giáo viên khoa công thệ thông tin mà chưa tham gia đề tài nào
SELECT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
  JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE
  K.TENKHOA = N'Công nghệ thông tin'
  AND GV.MAGV NOT IN (
    SELECT DISTINCT
      MAGV
    FROM
      THAMGIADT
  );

-- Q45: Tìm những giáo viên không tham gia bất kỳ đề tài nào
SELECT
  *
FROM
  GIAOVIEN
WHERE
  MAGV NOT IN (
    SELECT DISTINCT
      MAGV
    FROM
      THAMGIADT
  );

-- Q46: Cho biết giáo viên có lương lớn hơn hương của giáo viên Nguyễn Hoài An
SELECT
  *
FROM
  GIAOVIEN
WHERE
  LUONG > (
    SELECT
      LUONG
    FROM
      GIAOVIEN
    WHERE
      HOTEN = N'Nguyễn Hoài An'
  );

-- Q47: Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài
SELECT
  GV.MAGV,
  GV.HOTEN
FROM
  GIAOVIEN GV
  RIGHT JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
WHERE
  GV.MAGV IN (
    SELECT DISTINCT
      MAGV
    FROM
      THAMGIADT
  );

-- Q48: Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn
SELECT
  *
FROM
  GIAOVIEN GV1
WHERE
  MAGV IN (
    SELECT
      MAGV
    FROM
      GIAOVIEN GV2
    WHERE
      GV1.HOTEN = GV2.HOTEN
      AND GV1.PHAI = GV2.PHAI
      AND GV1.MABM = GV2.MABM
      AND GV1.MAGV != GV2.MAGV
  );

--CACH 2
SELECT
  *
FROM
  GIAOVIEN GV1,
  GIAOVIEN GV2
WHERE
  GV1.HOTEN = GV2.HOTEN
  AND GV1.PHAI = GV2.PHAI
  AND GV1.MABM = GV2.MABM
  AND GV1.MAGV <> GV2.MAGV
  -- Q49: Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn "Công nghệ phần mềm"
SELECT
  MAGV,
  HOTEN,
  LUONG,
  GV.MABM
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE
  TENBM != N'Công nghệ phần mềm'
  AND LUONG > ANY (
    SELECT
      LUONG
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      TENBM = N'Công nghệ phần mềm'
  );

-- Q50: Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn "Hệ thống thông tin"
SELECT
  *
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON BM.MABM = GV.MABM
WHERE
  TENBM != N'Hệ thống thông tin'
  AND LUONG > ALL (
    SELECT
      LUONG
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.TENBM = N'Hệ thống thông tin'
  );

-- Q51: Cho biết tên khoa có đông giáo viên nhất
SELECT
  K.TENKHOA
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
  JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
GROUP BY
  K.TENKHOA,
  K.MAKHOA
HAVING
  COUNT(*) >= ALL (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
      JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
    GROUP BY
      K.TENKHOA,
      K.MAKHOA
  );

-- Q52: Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất
SELECT
  HOTEN
FROM
  GIAOVIEN
WHERE
  MAGV IN (
    SELECT
      GVCNDT
    FROM
      DETAI DT
    GROUP BY
      GVCNDT
    HAVING
      COUNT(*) >= ALL (
        SELECT
          COUNT(*)
        FROM
          DETAI
        GROUP BY
          GVCNDT
      )
  );

-- Q53: Cho biết mã bộ môn có nhiều giáo viên nhất
SELECT
  MABM
FROM
  GIAOVIEN
GROUP BY
  MABM
HAVING
  COUNT(*) >= ALL (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN
    GROUP BY
      MABM
  );

-- Q54: Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất
SELECT
  HOTEN,
  TENBM
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE
  GV.MAGV IN (
    SELECT
      MAGV
    FROM
      THAMGIADT
    GROUP BY
      MAGV
    HAVING
      COUNT(DISTINCT MADT) >= ALL (
        SELECT
          COUNT(DISTINCT MADT)
        FROM
          THAMGIADT
        GROUP BY
          MAGV
      )
  );

-- Q55: Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT
SELECT
  HOTEN
FROM
  GIAOVIEN
WHERE
  MAGV IN (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
    WHERE
      GV.MABM = 'HTTT'
    GROUP BY
      GV.MAGV
    HAVING
      COUNT(DISTINCT MADT) >= ALL (
        SELECT
          COUNT(DISTINCT MADT)
        FROM
          GIAOVIEN GV
          JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
        WHERE
          GV.MABM = 'HTTT'
        GROUP BY
          GV.MAGV
      )
  );

-- Q56: Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất
SELECT
  HOTEN,
  TENBM
FROM
  GIAOVIEN
  JOIN BOMON ON GIAOVIEN.MABM = BOMON.MABM
WHERE
  MAGV IN (
    SELECT
      MAGV
    FROM
      NGUOITHAN
    GROUP BY
      MAGV
    HAVING
      COUNT(*) >= ALL (
        SELECT
          COUNT(*)
        FROM
          NGUOITHAN
        GROUP BY
          MAGV
      )
  );

-- Q57: Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất
SELECT
  GIAOVIEN.HOTEN
FROM
  BOMON
  LEFT JOIN GIAOVIEN ON BOMON.MABM = GIAOVIEN.MABM
  JOIN DETAI ON DETAI.GVCNDT = GIAOVIEN.MAGV
GROUP BY
  DETAI.GVCNDT,
  GIAOVIEN.HOTEN
HAVING
  COUNT(*) >= ALL (
    SELECT
      COUNT(*)
    FROM
      BOMON
      LEFT JOIN GIAOVIEN ON BOMON.MABM = GIAOVIEN.MABM
      JOIN DETAI ON DETAI.GVCNDT = GIAOVIEN.MAGV
    GROUP BY
      DETAI.GVCNDT
  );

-- Q58: Cho biết tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề
-- C1: dùng except
SELECT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  NOT EXISTS (
    SELECT
      MACD
    FROM
      CHUDE
    EXCEPT
    SELECT
      MACD
    FROM
      THAMGIADT TGDT2
      JOIN DETAI DT ON TGDT2.MADT = DT.MADT
    WHERE
      TGDT2.MAGV = GV.MAGV
  );

-- C2: dùng not exists
SELECT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  NOT EXISTS (
    SELECT
      MACD
    FROM
      CHUDE
    WHERE
      NOT EXISTS (
        SELECT
          MACD
        FROM
          THAMGIADT TGDT2
          JOIN DETAI DT ON TGDT2.MADT = DT.MADT
        WHERE
          TGDT2.MAGV = GV.MAGV
          AND DT.MACD = CHUDE.MACD
      )
  );

-- C3: dùng COUNT
SELECT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
  JOIN DETAI DT ON DT.MADT = TGDT.MADT
GROUP BY
  GV.MAGV,
  GV.HOTEN
HAVING
  COUNT(DISTINCT MACD) = (
    SELECT
      COUNT(*)
    FROM
      CHUDE
  );

-- Q59: Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia
-- C1: dùng except 
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
    WHERE
      GV.MABM = 'HTTT'
    EXCEPT
    SELECT DISTINCT
      TGDT2.MAGV
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON TGDT2.MAGV = GV2.MAGV
    WHERE
      GV2.MABM = 'HTTT'
      AND TGDT2.MADT = TGDT.MADT
  );

-- C2: dùng not exists
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
    WHERE
      GV.MABM = 'HTTT'
      AND NOT EXISTS (
        SELECT
          TGDT2.MAGV
        FROM
          THAMGIADT TGDT2
        WHERE
          TGDT2.MADT = TGDT.MADT
          AND TGDT2.MAGV = GV.MAGV
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
  JOIN (
    SELECT
      MAGV
    FROM
      GIAOVIEN
    WHERE
      GIAOVIEN.MABM = 'HTTT'
  ) AS T ON T.MAGV = TGDT.MAGV
GROUP BY
  DT.MADT,
  DT.TENDT
HAVING
  COUNT(DISTINCT TGDT.MAGV) = (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN
    WHERE
      GIAOVIEN.MABM = 'HTTT'
  );

-- Q60: Cho biết tên đề tài có tất cả giảng viên bộ môn "Hệ thống thông tin tham gia"
-- C1: dùng except
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.TENBM = N'Hệ thống thông tin'
    EXCEPT
    SELECT DISTINCT
      TGDT2.MAGV
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON TGDT2.MAGV = GV2.MAGV
      JOIN BOMON BM ON BM.MABM = GV2.MABM
    WHERE
      BM.TENBM = N'Hệ thống thông tin'
      AND TGDT2.MADT = TGDT.MADT
  );

-- C2: dùng not exist 
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.TENBM = N'Hệ thống thông tin'
      AND NOT EXISTS (
        SELECT
          TGDT2.MAGV
        FROM
          THAMGIADT TGDT2
        WHERE
          TGDT2.MADT = TGDT.MADT
          AND TGDT2.MAGV = GV.MAGV
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
  JOIN (
    SELECT
      MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.TENBM = N'Hệ thống thông tin'
  ) AS T ON T.MAGV = TGDT.MAGV
GROUP BY
  DT.MADT,
  DT.TENDT
HAVING
  COUNT(DISTINCT TGDT.MAGV) = (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN GV1
      JOIN BOMON BM1 ON GV1.MABM = BM1.MABM
    WHERE
      BM1.TENBM = N'Hệ thống thông tin'
  );

-- Q61: Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD
-- C1: dùng except
SELECT DISTINCT
  TGDT.MAGV
FROM
  THAMGIADT TGDT
WHERE
  NOT EXISTS (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      MACD = 'QLGD'
    EXCEPT
    SELECT
      DT.MADT
    FROM
      DETAI DT
      JOIN THAMGIADT TGDT1 ON DT.MADT = TGDT1.MADT
    WHERE
      TGDT1.MAGV = TGDT.MAGV
      AND DT.MACD = 'QLGD'
  );

-- C2: dùng not exist 
SELECT DISTINCT
  TGDT.MAGV
FROM
  THAMGIADT TGDT
WHERE
  NOT EXISTS (
    SELECT
      MADT
    FROM
      DETAI DT1
    WHERE
      MACD = 'QLGD'
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TGDT1
        WHERE
          TGDT1.MAGV = TGDT.MAGV
          AND TGDT1.MADT = DT1.MADT
      )
  );

-- C3: dùng COUNT
SELECT
  TGDT.MAGV
FROM
  THAMGIADT TGDT
  JOIN DETAI DT ON TGDT.MADT = DT.MADT
  AND DT.MACD = 'QLGD'
GROUP BY
  (MAGV)
HAVING
  COUNT(DISTINCT DT.MADT) = (
    SELECT
      COUNT(*)
    FROM
      DETAI
    WHERE
      MACD = 'QLGD'
    GROUP BY
      MACD
  );

-- Q62: Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia
-- C1: dùng except
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  GV.HOTEN != N'Trần Trà Hương'
  AND NOT EXISTS (
    SELECT DISTINCT
      TGDT1.MADT
    FROM
      THAMGIADT TGDT1
      JOIN GIAOVIEN GV1 ON TGDT1.MAGV = GV1.MAGV
      AND GV1.HOTEN = N'Trần Trà Hương'
    EXCEPT
    SELECT DISTINCT
      TGDT2.MADT
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON TGDT2.MAGV = GV2.MAGV
    WHERE
      TGDT2.MAGV = TGDT.MAGV
      AND TGDT2.MADT IN (
        SELECT DISTINCT
          TGDT1.MADT
        FROM
          THAMGIADT TGDT1
          JOIN GIAOVIEN GV1 ON TGDT1.MAGV = GV1.MAGV
          AND GV1.HOTEN = N'Trần Trà Hương'
      )
  );

-- C2: dùng not exist 
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  GV.HOTEN != N'Trần Trà Hương'
  AND NOT EXISTS (
    SELECT DISTINCT
      TGDT1.MADT
    FROM
      THAMGIADT TGDT1
      JOIN GIAOVIEN GV1 ON TGDT1.MAGV = GV1.MAGV
      AND GV1.HOTEN = N'Trần Trà Hương'
    WHERE
      NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TGDT2
        WHERE
          TGDT.MAGV = TGDT2.MAGV
          AND TGDT1.MADT = TGDT2.MADT
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
  AND GV.HOTEN != N'Trần Trà Hương'
WHERE
  TGDT.MADT IN (
    SELECT DISTINCT
      MADT
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON GV2.MAGV = TGDT2.MAGV
      AND GV2.HOTEN = N'Trần Trà Hương'
  )
GROUP BY
  GV.MAGV,
  GV.HOTEN
HAVING
  COUNT(DISTINCT TGDT.MADT) = (
    SELECT
      COUNT(DISTINCT MADT)
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON GV2.MAGV = TGDT2.MAGV
      AND GV2.HOTEN = N'Trần Trà Hương'
  );

-- Q63: Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn Hóa hữu cơ tham gia
-- C1: dùng except
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.TENBM = N'Hóa hữu cơ'
    EXCEPT
    SELECT DISTINCT
      TGDT2.MAGV
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON TGDT2.MAGV = GV2.MAGV
      JOIN BOMON BM ON BM.MABM = GV2.MABM
    WHERE
      BM.TENBM = N'Hóa hữu cơ'
      AND TGDT2.MADT = TGDT.MADT
  );

-- C2: dùng not exist 
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.TENBM = N'Hóa hữu cơ'
      AND NOT EXISTS (
        SELECT
          TGDT2.MAGV
        FROM
          THAMGIADT TGDT2
        WHERE
          TGDT2.MADT = TGDT.MADT
          AND TGDT2.MAGV = GV.MAGV
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
  JOIN (
    SELECT
      MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.TENBM = N'Hóa hữu cơ'
  ) AS T ON T.MAGV = TGDT.MAGV
GROUP BY
  DT.MADT,
  DT.TENDT
HAVING
  COUNT(DISTINCT TGDT.MAGV) = (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN GV1
      JOIN BOMON BM1 ON GV1.MABM = BM1.MABM
    WHERE
      BM1.TENBM = N'Hóa hữu cơ'
  );

-- Q64: Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006
-- C1: dùng except
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = '006'
  AND NOT EXISTS (
    SELECT
      SOTT
    FROM
      CONGVIEC
    WHERE
      MADT = '006'
    EXCEPT
    SELECT
      STT
    FROM
      THAMGIADT TGDT1
    WHERE
      MADT = '006'
      AND TGDT1.MAGV = TGDT.MAGV
  );

-- C2: dùng not exist 
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = '006'
  AND NOT EXISTS (
    SELECT
      CV1.SOTT
    FROM
      CONGVIEC CV1
    WHERE
      MADT = '006'
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TGDT1
        WHERE
          TGDT1.MAGV = TGDT.MAGV
          AND TGDT1.MADT = '006'
          AND TGDT1.STT = CV1.SOTT
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = '006'
GROUP BY
  GV.MAGV,
  GV.HOTEN
HAVING
  COUNT(*) = (
    SELECT
      COUNT(*)
    FROM
      CONGVIEC
    WHERE
      MADT = '006'
  );

---CACH KHAC - ON TAP
-- Q64: Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006
SELECT
  *
FROM
  GIAOVIEN GV
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      CONGVIEC CV
    WHERE
      MADT = '006'
      AND NOT EXISTS ( --
        SELECT
          *
        FROM
          THAMGIADT TG
        WHERE
          TG.MADT = CV.MADT
          AND TG.STT = CV.SOTT
          AND TG.MAGV = GV.MAGV
      )
  ) ---TIM TAT CA GIAO VIEN THAM GIA DETAI 006
  ----VÍ DỤ: TÌM GIÁO VIÊN THAM GIA TẤT CẢ ĐỀ TÀI 
  ---~ ỨNG VỚI MỖI GIÁO VIÊN: KHÔNG TỒN TẠI ĐỀ TÀI NÀO MÀ GV ĐÓ KO THAM GIA ~ TÌM TẤT CẢ ĐỀ TÀI GV ĐÓ KO THAM GIA
  ----						ỨNG VỚI MỖI ĐỀ TÀI: KHÔNG TỒN TẠI SỰ THAM GIA CỦA GV ĐÓ 
  -- Q65: Cho biết các giáo viên nào đã tham gia tất cả các đề tài của chủ đề Ứng dụng công nghệ
  -- C1: dùng except
SELECT DISTINCT
  TGDT.MAGV
FROM
  THAMGIADT TGDT
WHERE
  NOT EXISTS (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      MACD = (
        SELECT
          MACD
        FROM
          CHUDE
        WHERE
          TENCD = N'Ứng dụng công nghệ'
      )
    EXCEPT
    SELECT
      DT.MADT
    FROM
      DETAI DT
      JOIN THAMGIADT TGDT1 ON DT.MADT = TGDT1.MADT
    WHERE
      TGDT1.MAGV = TGDT.MAGV
      AND DT.MACD = (
        SELECT
          MACD
        FROM
          CHUDE
        WHERE
          TENCD = N'Ứng dụng công nghệ'
      )
  );

-- C2: dùng not exist 
SELECT DISTINCT
  TGDT.MAGV
FROM
  THAMGIADT TGDT
WHERE
  NOT EXISTS (
    SELECT
      MADT
    FROM
      DETAI DT1
    WHERE
      MACD = (
        SELECT
          MACD
        FROM
          CHUDE
        WHERE
          TENCD = N'Ứng dụng công nghệ'
      )
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TGDT1
        WHERE
          TGDT1.MAGV = TGDT.MAGV
          AND TGDT1.MADT = DT1.MADT
      )
  );

-- C3: dùng COUNT
SELECT
  TGDT.MAGV
FROM
  THAMGIADT TGDT
  JOIN DETAI DT ON TGDT.MADT = DT.MADT
  AND DT.MACD = (
    SELECT
      MACD
    FROM
      CHUDE
    WHERE
      TENCD = N'Ứng dụng công nghệ'
  )
GROUP BY
  (MAGV)
HAVING
  COUNT(DISTINCT DT.MADT) = (
    SELECT
      COUNT(*)
    FROM
      DETAI
    WHERE
      MACD = (
        SELECT
          MACD
        FROM
          CHUDE
        WHERE
          TENCD = N'Ứng dụng công nghệ'
      )
    GROUP BY
      MACD
  );

-- Q66: Cho biết tên giáo viên nào đã tham gia tất cả các đề tài do Trần Trà Hương làm chủ nhiệm
-- C1: dùng except
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  GV.HOTEN != N'Trần Trà Hương'
  AND NOT EXISTS (
    SELECT
      DT1.MADT
    FROM
      DETAI DT1
    WHERE
      DT1.GVCNDT = (
        SELECT
          MAGV
        FROM
          GIAOVIEN
        WHERE
          HOTEN = N'Trần Trà Hương'
      )
    EXCEPT
    SELECT DISTINCT
      TGDT2.MADT
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON TGDT2.MAGV = GV2.MAGV
    WHERE
      TGDT2.MAGV = TGDT.MAGV
      AND TGDT2.MADT IN (
        SELECT
          DT2.MADT
        FROM
          DETAI DT2
        WHERE
          DT2.GVCNDT = (
            SELECT
              MAGV
            FROM
              GIAOVIEN
            WHERE
              HOTEN = N'Trần Trà Hương'
          )
      )
  );

-- C2: dùng not exist 
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  GV.HOTEN != N'Trần Trà Hương'
  AND NOT EXISTS (
    SELECT
      DT1.MADT
    FROM
      DETAI DT1
    WHERE
      DT1.GVCNDT = (
        SELECT
          MAGV
        FROM
          GIAOVIEN
        WHERE
          HOTEN = N'Trần Trà Hương'
      )
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TGDT2
        WHERE
          TGDT.MAGV = TGDT2.MAGV
          AND DT1.MADT = TGDT2.MADT
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
  AND GV.HOTEN != N'Trần Trà Hương'
WHERE
  TGDT.MADT IN (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      GVCNDT = (
        SELECT
          MAGV
        FROM
          GIAOVIEN
        WHERE
          HOTEN = N'Trần Trà Hương'
      )
  )
GROUP BY
  GV.MAGV,
  GV.HOTEN
HAVING
  COUNT(DISTINCT TGDT.MADT) = (
    SELECT
      COUNT(*)
    FROM
      DETAI
    WHERE
      GVCNDT = (
        SELECT
          MAGV
        FROM
          GIAOVIEN
        WHERE
          HOTEN = N'Trần Trà Hương'
      )
  );

-- Q66: Cho biết tên giáo viên nào đã tham gia tất cả các đề tài do Trần Trà Hương làm chủ nhiệm
--- ỨNG VỚI MỖI GIÁO VIÊN, KHÔNG TỒN TẠI ĐỀ TÀI NÀO DO TTH LÀM CHỦ NHIỆM, MÀ GV ĐÓ KO THAM GIA
---ỨNG VỚI MỖI ĐỀ TÀI DO TTH LÀM CHỦ NHIỆM, KHÔNG TỒN TẠI SỰ THAM GIA CỦA GV ĐÓ
SELECT
  *
FROM
  GIAOVIEN GV01
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      DETAI DT,
      GIAOVIEN GV02
    WHERE
      DT.GVCNDT = GV02.MAGV
      AND GV02.HOTEN = N'Trần Trà Hương'
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TG
        WHERE
          GV01.MAGV = TG.MAGV
          AND DT.MADT = TG.MADT
      )
  )
  -- Q67: Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia
  -- C1: dùng except 
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.MAKHOA = 'CNTT'
    EXCEPT
    SELECT DISTINCT
      TGDT2.MAGV
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON TGDT2.MAGV = GV2.MAGV
      JOIN BOMON BM ON GV2.MABM = BM.MABM
    WHERE
      BM.MAKHOA = 'CNTT'
      AND TGDT2.MADT = TGDT.MADT
  );

-- C2: dùng not exists
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.MAKHOA = 'CNTT'
      AND NOT EXISTS (
        SELECT
          TGDT2.MAGV
        FROM
          THAMGIADT TGDT2
        WHERE
          TGDT2.MADT = TGDT.MADT
          AND TGDT2.MAGV = GV.MAGV
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
  JOIN (
    SELECT
      MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.MAKHOA = 'CNTT'
  ) AS T ON T.MAGV = TGDT.MAGV
GROUP BY
  DT.MADT,
  DT.TENDT
HAVING
  COUNT(DISTINCT TGDT.MAGV) = (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.MAKHOA = 'CNTT'
  );

-- Q68: Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài Nghiên cứu tế bào gốc
-- C1: dùng except
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      TENDT = N'Nghiên cứu tế bào gốc'
  )
  AND NOT EXISTS (
    SELECT
      SOTT
    FROM
      CONGVIEC
    WHERE
      MADT = (
        SELECT
          MADT
        FROM
          DETAI
        WHERE
          TENDT = N'Nghiên cứu tế bào gốc'
      )
    EXCEPT
    SELECT
      STT
    FROM
      THAMGIADT TGDT1
    WHERE
      MADT = (
        SELECT
          MADT
        FROM
          DETAI
        WHERE
          TENDT = N'Nghiên cứu tế bào gốc'
      )
      AND TGDT1.MAGV = TGDT.MAGV
  );

-- C2: dùng not exist 
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      TENDT = N'Nghiên cứu tế bào gốc'
  )
  AND NOT EXISTS (
    SELECT
      CV1.SOTT
    FROM
      CONGVIEC CV1
    WHERE
      MADT = TGDT.MADT
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TGDT1
        WHERE
          TGDT1.MAGV = TGDT.MAGV
          AND TGDT1.MADT = CV1.MADT
          AND TGDT1.STT = CV1.SOTT
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      TENDT = N'Nghiên cứu tế bào gốc'
  )
GROUP BY
  GV.MAGV,
  GV.HOTEN
HAVING
  COUNT(*) = (
    SELECT
      COUNT(*)
    FROM
      CONGVIEC
    WHERE
      MADT = (
        SELECT
          MADT
        FROM
          DETAI
        WHERE
          TENDT = N'Nghiên cứu tế bào gốc'
      )
  );

-- Q69: Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí trên 100 triệu
-- C1: dùng except
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
WHERE
  NOT EXISTS (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      KINHPHI > 100
    EXCEPT
    SELECT DISTINCT
      TGDT1.MADT
    FROM
      THAMGIADT TGDT1
    WHERE
      TGDT1.MAGV = TGDT.MAGV
      AND TGDT1.MADT IN (
        SELECT
          MADT
        FROM
          DETAI
        WHERE
          KINHPHI > 100
      )
  );

-- C2: dùng not exist 
SELECT DISTINCT
  GV.HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
WHERE
  NOT EXISTS (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      KINHPHI > 100
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TGDT1
        WHERE
          TGDT1.MAGV = TGDT.MAGV
          AND TGDT1.MADT = DETAI.MADT
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  HOTEN
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
  JOIN DETAI DT ON TGDT.MADT = DT.MADT
WHERE
  TGDT.MADT IN (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      KINHPHI > 100
  )
GROUP BY
  GV.MAGV,
  GV.HOTEN
HAVING
  COUNT(DISTINCT TGDT.MADT) = (
    SELECT
      COUNT(*)
    FROM
      DETAI
    WHERE
      KINHPHI > 100
  );

-- Q70: Cho biết tên đề tài nào nào mà được tất cả các giáo viên của khoa Sinh học tham gia
-- C1: dùng except 
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.MAKHOA = (
        SELECT
          MAKHOA
        FROM
          KHOA
        WHERE
          TENKHOA = N'Sinh học'
      )
    EXCEPT
    SELECT DISTINCT
      TGDT2.MAGV
    FROM
      THAMGIADT TGDT2
      JOIN GIAOVIEN GV2 ON TGDT2.MAGV = GV2.MAGV
      JOIN BOMON BM ON GV2.MABM = BM.MABM
    WHERE
      BM.MAKHOA = (
        SELECT
          MAKHOA
        FROM
          KHOA
        WHERE
          TENKHOA = N'Sinh học'
      )
      AND TGDT2.MADT = TGDT.MADT
  );

-- C2: dùng not exists
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE
  NOT EXISTS (
    SELECT
      GV.MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.MAKHOA = (
        SELECT
          MAKHOA
        FROM
          KHOA
        WHERE
          TENKHOA = N'Sinh học'
      )
      AND NOT EXISTS (
        SELECT
          TGDT2.MAGV
        FROM
          THAMGIADT TGDT2
        WHERE
          TGDT2.MADT = TGDT.MADT
          AND TGDT2.MAGV = GV.MAGV
      )
  );

-- c2.2	: not exists -- KO TON TAI DE TAI NAO MA KHONG DUOC THAM GIA BOI TAT CA GV KHOA SINH HOC 
-- Q70: Cho biết tên đề tài nào nào mà được tất cả các giáo viên của khoa Sinh học tham gia
SELECT
  *
FROM
  DETAI DT
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      GIAOVIEN GV
      INNER JOIN BOMON BM ON GV.MABM = BM.MABM
      INNER JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
    WHERE
      K.TENKHOA = N'Sinh học'
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TG
        WHERE
          GV.MAGV = TG.MAGV
          AND DT.MADT = TG.MADT
      )
  )
SELECT
  *
FROM
  DETAI DT
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      GIAOVIEN GV
      INNER JOIN BOMON BM ON GV.MABM = BM.MABM
      INNER JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
    WHERE
      NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TG
        WHERE
          GV.MAGV = TG.MAGV
          AND DT.MADT = TG.MADT
          AND K.TENKHOA = N'Sinh học'
      )
  )
  -- C3: dùng COUNT
SELECT DISTINCT
  DT.TENDT
FROM
  DETAI DT
  JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
  JOIN (
    SELECT
      MAGV
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.MAKHOA = (
        SELECT
          MAKHOA
        FROM
          KHOA
        WHERE
          TENKHOA = N'Sinh học'
      )
  ) AS T ON T.MAGV = TGDT.MAGV
GROUP BY
  DT.MADT,
  DT.TENDT
HAVING
  COUNT(DISTINCT TGDT.MAGV) = (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN GV
      JOIN BOMON BM ON GV.MABM = BM.MABM
    WHERE
      BM.MAKHOA = (
        SELECT
          MAKHOA
        FROM
          KHOA
        WHERE
          TENKHOA = N'Sinh học'
      )
  );

-- Q71: Cho biết mã số, họ tên, ngày sinh của giáo viên tham gia tất cả các công việc của đề tài Ứng dụng hóa học xanh
-- C1: dùng except
SELECT DISTINCT
  GV.MAGV,
  GV.HOTEN,
  GV.NGAYSINH
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      TENDT = N'Ứng dụng hóa học xanh'
  )
  AND NOT EXISTS (
    SELECT
      SOTT
    FROM
      CONGVIEC
    WHERE
      MADT = TGDT.MADT
    EXCEPT
    SELECT
      STT
    FROM
      THAMGIADT TGDT1
    WHERE
      MADT = TGDT.MADT
      AND TGDT1.MAGV = TGDT.MAGV
  );

-- C2: dùng not exist 
SELECT DISTINCT
  GV.MAGV,
  GV.HOTEN,
  GV.NGAYSINH
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      TENDT = N'Ứng dụng hóa học xanh'
  )
  AND NOT EXISTS (
    SELECT
      CV1.SOTT
    FROM
      CONGVIEC CV1
    WHERE
      MADT = TGDT.MADT
      AND NOT EXISTS (
        SELECT
          *
        FROM
          THAMGIADT TGDT1
        WHERE
          TGDT1.MAGV = TGDT.MAGV
          AND TGDT1.MADT = CV1.MADT
          AND TGDT1.SOTT = CV1.SOTT
      )
  );

-- C3: dùng COUNT
SELECT DISTINCT
  GV.MAGV,
  GV.HOTEN,
  GV.NGAYSINH
FROM
  GIAOVIEN GV
  JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE
  TGDT.MADT = (
    SELECT
      MADT
    FROM
      DETAI
    WHERE
      TENDT = N'Ứng dụng hóa học xanh'
  )
GROUP BY
  GV.MAGV,
  GV.HOTEN
HAVING
  COUNT(*) = (
    SELECT
      COUNT(*)
    FROM
      CONGVIEC
    WHERE
      MADT = (
        SELECT
          MADT
        FROM
          DETAI
        WHERE
          TENDT = N'Ứng dụng hóa học xanh'
      )
  );

-- Q72: Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của giáo viên tham gia tất cả các đề tài thuộc chủ đề Nghiên cứu phát triển
-- C1: dùng except
SELECT
  MAGV,
  HOTEN,
  BM.TENBM,
  (
    SELECT
      GV2.HOTEN
    FROM
      GIAOVIEN GV2
    WHERE
      GV2.MAGV = GV.GVQLCM
  ) AS TEN_GVQLCM
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE
  GV.MAGV IN (
    SELECT DISTINCT
      TGDT.MAGV
    FROM
      THAMGIADT TGDT
    WHERE
      NOT EXISTS (
        SELECT
          MADT
        FROM
          DETAI
        WHERE
          MACD = (
            SELECT
              MACD
            FROM
              CHUDE
            WHERE
              TENCD = N'Nghiên cứu phát triển'
          )
        EXCEPT
        SELECT
          DT.MADT
        FROM
          DETAI DT
          JOIN THAMGIADT TGDT1 ON DT.MADT = TGDT1.MADT
        WHERE
          TGDT1.MAGV = TGDT.MAGV
          AND DT.MACD = (
            SELECT
              MACD
            FROM
              CHUDE
            WHERE
              TENCD = N'Nghiên cứu phát triển'
          )
      )
  );

-- C2: dùng not exist 
SELECT
  MAGV,
  HOTEN,
  BM.TENBM,
  (
    SELECT
      GV2.HOTEN
    FROM
      GIAOVIEN GV2
    WHERE
      GV2.MAGV = GV.GVQLCM
  ) AS TEN_GVQLCM
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE
  GV.MAGV IN (
    SELECT DISTINCT
      TGDT.MAGV
    FROM
      THAMGIADT TGDT
    WHERE
      NOT EXISTS (
        SELECT
          MADT
        FROM
          DETAI DT1
        WHERE
          MACD = (
            SELECT
              MACD
            FROM
              CHUDE
            WHERE
              TENCD = N'Nghiên cứu phát triển'
          )
          AND NOT EXISTS (
            SELECT
              *
            FROM
              THAMGIADT TGDT1
            WHERE
              TGDT1.MAGV = TGDT.MAGV
              AND TGDT1.MADT = DT1.MADT
          )
      )
  );

-- C3: dùng COUNT
SELECT
  MAGV,
  HOTEN,
  BM.TENBM,
  (
    SELECT
      GV2.HOTEN
    FROM
      GIAOVIEN GV2
    WHERE
      GV2.MAGV = GV.GVQLCM
  ) AS TEN_GVQLCM
FROM
  GIAOVIEN GV
  JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE
  GV.MAGV IN (
    SELECT
      TGDT.MAGV
    FROM
      THAMGIADT TGDT
      JOIN DETAI DT ON TGDT.MADT = DT.MADT
      AND DT.MACD = (
        SELECT
          MACD
        FROM
          CHUDE
        WHERE
          TENCD = N'Nghiên cứu phát triển'
      )
    GROUP BY
      (MAGV)
    HAVING
      COUNT(DISTINCT DT.MADT) = (
        SELECT
          COUNT(*)
        FROM
          DETAI
        WHERE
          MACD = (
            SELECT
              MACD
            FROM
              CHUDE
            WHERE
              TENCD = N'Nghiên cứu phát triển'
          )
        GROUP BY
          MACD
      )
  );

-- Q73. Cho biết họ tên, ngày sinh, tên khoa, tên trưởng khoa của giáo viên tham gia tất cả các đề tài có giáo viên “Nguyễn Hoài An” tham gia.
SELECT
  g.HOTEN,
  g.NGSINH,
  k.TENKHOA,
  TK.HOTEN
FROM
  GIAOVIEN g
  JOIN BOMON b ON g.MABM = b.MABM
  JOIN KHOA k ON k.MAKHOA = b.MAKHOA
  JOIN GIAOVIEN TK ON TK.MAGV = K.TRUONGKHOA
WHERE
  G.HOTEN NOT LIKE N'Nguyễn Hoài An'
  AND NOT EXISTS (
    (
      SELECT
        T.MADT
      FROM
        THAMGIADT t
        JOIN GIAOVIEN g2 ON g2.MAGV = t.MAGV
      WHERE
        g2.HOTEN = N'Nguyễn Hoài An'
    )
    EXCEPT
    (
      SELECT
        t1.MADT
      FROM
        GIAOVIEN g1
        JOIN THAMGIADT t1 ON g1.MAGV = t1.MAGV
        JOIN BOMON b1 ON g1.MABM = b1.MABM
        JOIN KHOA k1 ON k1.MAKHOA = b1.MAKHOA
        JOIN GIAOVIEN TK1 ON TK1.MAGV = K1.TRUONGKHOA
      WHERE
        g.HOTEN = G1.HOTEN
        AND g.NGSINH = G1.NGSINH
        AND K1.TENKHOA = K.TENKHOA
        AND TK.HOTEN = TK1.HOTEN
    )
  )
  -- Q74. Cho biết họ tên giáo viên khoa “Công nghệ thông tin” tham gia tất cả các công việc của đề tài có trưởng bộ môn của bộ môn đông nhất khoa “Công nghệ thông tin” làm chủ nhiệm.
SELECT
  g1.HOTEN
FROM
  GIAOVIEN g1
  JOIN BOMON b1 ON g1.MABM = b1.MABM
  JOIN KHOA k1 ON k1.MAKHOA = b1.MAKHOA
WHERE
  k1.TENKHOA = N'Công nghệ thông tin'
  AND NOT EXISTS (
    (
      SELECT
        c.MADT,
        c.SOTT
      FROM
        DETAI d
        JOIN CONGVIEC c ON d.MADT = c.MADT
    )
    EXCEPT
    (
      SELECT
        t.MADT,
        t.STT
      FROM
        GIAOVIEN g
        JOIN THAMGIADT t ON g.MAGV = t.MAGV
      WHERE
        g1.HOTEN = g.HOTEN
        AND g.MAGV = (
          SELECT
            b.TRUONGBM
          FROM
            BOMON b
            JOIN KHOA k ON b.MAKHOA = k.MAKHOA
            JOIN GIAOVIEN g ON g.MABM = b.MABM
          WHERE
            k.TENKHOA = N'Công nghệ thông tin'
            AND g1.HOTEN = g.HOTEN
          GROUP BY
            (b.TRUONGBM)
          HAVING
            COUNT(g.MAGV) >= ALL (
              SELECT
                COUNT(g.magv)
              FROM
                BOMON b
                JOIN KHOA k ON b.MAKHOA = k.MAKHOA
                JOIN GIAOVIEN g ON g.MABM = b.MABM
              WHERE
                k.TENKHOA = N'Công nghệ thông tin'
              GROUP BY
                (b.TRUONGBM)
            )
        )
    )
  );

-- Q75: Cho biết họ tên giáo viên và tên bộ môn họ làm trường bộ môn nếu có
SELECT
  GV.HOTEN,
  (
    SELECT
      TENBM
    FROM
      BOMON BM
    WHERE
      GV.MAGV = BM.TRUONGBM
  ) AS TENBM_LATRUONGBM
FROM
  GIAOVIEN GV;

-- Hay
SELECT
  HOTEN,
  TENBM AS TENBM_LATRUONGBM
FROM
  GIAOVIEN
  LEFT JOIN BOMON ON GIAOVIEN.MAGV = BOMON.TRUONGBM;

-- Q76. Cho danh sách tên bộ môn và họ tên trưởng bộ môn đó nếu có
SELECT
  TENBM,
  (
    SELECT
      HOTEN
    FROM
      GIAOVIEN GV
    WHERE
      BM.TRUONGBM = GV.MAGV
  ) AS HOTEN_TRUONGBM
FROM
  BOMON BM;

-- Hay
SELECT
  TENBM,
  HOTEN AS HOTEN_TRUONGBM
FROM
  BOMON BM
  LEFT JOIN GIAOVIEN GV ON BM.TRUONGBM = GV.MAGV;

-- Q77. Cho danh sách tên giáo viên và các đề tài giáo viên đó chủ nhiệm nếu có
SELECT
  HOTEN,
  TENDT
FROM
  GIAOVIEN GV
  LEFT JOIN DETAI DT ON GVCNDT = MAGV;

-- Q78. Xuất ra thông tin của giáo viên (MAGV, HOTEN) và mức lương của giáo viên. Mức lương được xếp theo quy tắc: Lương của giáo viên < $1800 : “THẤP” ; Từ $1800 đến $2200: TRUNG BÌNH; Lương > $2200: “CAO"
SELECT
  MAGV,
  HOTEN,
  LUONG,
  (
    CASE
      WHEN LUONG < 1800 THEN N'THẤP'
      WHEN LUONG <= 2200 THEN N'TRUNG BÌNH'
      WHEN LUONG > 2200 THEN N'CAO'
    END
  ) AS XEPLOAI_LUONG
FROM
  GIAOVIEN;

-- Q79. Xuất ra thông tin giáo viên (MAGV, HOTEN) và xếp hạng dựa vào mức lương. Nếu giáo viên có lương cao nhất thì hạng là 1.
SELECT
  MAGV,
  HOTEN,
  (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN GV2
    WHERE
      GV2.LUONG >= GV1.LUONG
      AND GV2.MAGV != GV1.MAGV
  ) AS HANG
FROM
  GIAOVIEN GV1;

-- Q80. Xuất ra thông tin thu nhập của giáo viên. Thu nhập của giáo viên được tính bằng LƯƠNG + PHỤ CẤP. Nếu giáo viên là trưởng bộ môn thì PHỤ CẤP là 300, và giáo viên là trưởng khoa thì PHỤ CẤP là 600.
SELECT
  MAGV,
  HOTEN,
  (
    CASE
      WHEN GV.MAGV IN (
        SELECT
          TRUONGBM
        FROM
          BOMON
      )
      AND GV.MAGV IN (
        SELECT
          TRUONGKHOA
        FROM
          KHOA
      ) THEN LUONG + 300 + 600
      WHEN GV.MAGV IN (
        SELECT
          TRUONGBM
        FROM
          BOMON
      ) THEN LUONG + 300
      WHEN GV.MAGV IN (
        SELECT
          TRUONGKHOA
        FROM
          KHOA
      ) THEN LUONG + 600
      ELSE LUONG
    END
  ) AS THUNHAP
FROM
  GIAOVIEN GV;

-- Q81. Xuất ra năm mà giáo viên dự kiến sẽ nghĩ hưu với quy định: Tuổi nghỉ hưu của Nam là 60, của Nữ là 55
SELECT
  MAGV,
  HOTEN,
  (
    CASE PHAI
      WHEN 'Nam' THEN YEAR(NGSINH) + 60
      WHEN N'Nữ' THEN YEAR(NGSINH) + 55
    END
  ) AS NAMNGHIHUU_DUKIEN
FROM
  GIAOVIEN;

-- Q82. Cho biết danh sách tất cả giáo viên (magv, hoten) và họ tên giáo viên là quản lý chuyên môn của họ.
SELECT
  GV1.MAGV,
  GV1.HOTEN,
  GV2.HOTEN AS GVQLCM
FROM
  GIAOVIEN GV1
  LEFT JOIN GIAOVIEN GV2 ON GV1.GVQLCM = GV2.MAGV;

-- 3. RÀNG BUỘC TOÀN VẸN
-- R1. Tên tài phải duy nhất
ALTER TABLE DETAI
ADD UNIQUE (TENDT);

GO;

-- R2. Trưởng bộ môn phải sinh sau trước 1975
--            THEM         XOA            SUA
-- BOMON      +            -              +(TRUONGBM)
-- GIAOVIEN   -            -              +(NGSINH)
CREATE
TRIGGER TRG_TRUONGBM_1975_BOMON_THEM_SUA ON BOMON FOR
INSERT
,
UPDATE AS BEGIN IF EXISTS (
  SELECT
    *
  FROM
    inserted
  WHERE
    TRUONGBM IS NULL
) RETURN DECLARE @TRUONGBM CHAR(3)
SELECT
  @TRUONGBM = TRUONGBM
FROM
  inserted IF EXISTS (
    SELECT
      *
    FROM
      GIAOVIEN
    WHERE
      MAGV = @TRUONGBM
      AND YEAR(NGSINH) > 1975
  ) BEGIN RAISERROR (N'NGSINH cua truong bo mon phai <= 1975', 16, 1) ROLLBACK TRANSACTION END END;

GO;

CREATE
TRIGGER TRG_TRUONGBM_1975_GIAOVIEN_SUA ON GIAOVIEN FOR
UPDATE AS BEGIN IF EXISTS (
  SELECT
    *
  FROM
    inserted
    INNER JOIN BOMON ON inserted.MAGV = BOMON.TRUONGBM
  WHERE
    YEAR(inserted.NGSINH) > 1975
) BEGIN RAISERROR (N'NGSINH cua truong bo mon phai <= 1975', 16, 1) ROLLBACK TRANSACTION END END;

GO;

-- R3. Một bộ môn có tối thiểu 1 giáo viên nữ
--			  THEM       XOA               SUA
-- BOMON      +          -                 -
-- GIAOVIEN   -          +                 +(PHAI, MABM)
CREATE
TRIGGER TRG_BOMON_1_GVNU_BOMON ON BOMON FOR
INSERT
  AS BEGIN IF NOT EXISTS (
    SELECT
      *
    FROM
      inserted
      INNER JOIN GIAOVIEN ON inserted.TRUONGBM = GIAOVIEN.MABM
    WHERE
      GIAOVIEN.PHAI = N'Nữ'
  ) BEGIN RAISERROR (N'Phai them truong bo mon nu vao!', 16, 1) ROLLBACK TRANSACTION END END;

GO;

CREATE
TRIGGER TRG_BOMON_1_GVNU_GIAOVIEN_XOA ON GIAOVIEN FOR
DELETE AS BEGIN DECLARE @MABM CHAR(4)
SELECT
  @MABM = MABM
FROM
  deleted IF (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN
    WHERE
      MABM = @MABM
      AND PHAI = N'Nữ'
  ) < 1 BEGIN RAISERROR (
    'Khong duoc xoa giao vien vi do la giao vien nu duy nhat',
    16,
    1
  ) ROLLBACK TRANSACTION END END;

GO;

CREATE
TRIGGER TRG_BOMON_1_GVNU_GIAOVIEN_SUA ON GIAOVIEN FOR
UPDATE AS BEGIN DECLARE @MABM CHAR(4)
SELECT
  @MABM = MABM
FROM
  deleted IF (
    SELECT
      COUNT(*)
    FROM
      GIAOVIEN
    WHERE
      MABM = @MABM
      AND PHAI = N'Nữ'
  ) < 1 BEGIN RAISERROR (
    'Khong duoc doi MABM / sua phai giao vien vi do la giao vien nu duy nhat',
    16,
    1
  ) ROLLBACK TRANSACTION END END;

GO;

-- R4. Một giáo viên phải có ít nhất 1 số điện thoại
-- R5. Một giáo viên có tối đa 3 số điện thoại
-- R6. Một bộ môn phải có tối thiểu 4 giáo viên
-- R7. Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn.
-- R8. Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn.
-- R9. Giáo viên và giáo viên quản lý chuyên môn của giáo viên đó phải thuộc về 1 bộ môn. 
-- R10. Mỗi giáo viên chỉ có tối đa 1 vợ chồng
-- R11. Giáo viên là Nam thì chỉ có vợ chồng là Nữ hoặc ngược lại.
-- R12. Nếu thân nhân có quan hệ là “con gái” hoặc “con trai” với giáo viên thì năm sinh của giáo viên phải nhỏ hơn năm sinh của thân nhân.
-- R13. Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài.
---				THEM	XOA		SUA
--GIAOVIEN		-		-       -*	
--DETAI         +       -       +(MAGVDT)
GO;

CREATE
TRIGGER TRG_GIAOVIEN_MAX_3_DE_TAI_DETAI_THEM ON DETAI FOR
INSERT
,
UPDATE AS BEGIN DECLARE @MADT CHAR(3)
SELECT
  @MADT = MADT
FROM
  inserted IF (
    SELECT
      COUNT(*)
    FROM
      DETAI
    WHERE
      MADT = @MADT
  ) > 3 BEGIN RAISERROR ('Toi da 3 de tai', 16, 1) ROLLBACK TRANSACTION END END;

-- R14. Một đề tài phải có ít nhất một công việc
-- R15. Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó.
-- R16. Lương của trưởng bộ môn phải lớn hơn lương của các giáo viên trong bộ môn.
-- R17. Bộ môn ban nào cũng phải có trưởng bộ môn và trưởng bộ môn phải là một giáo viên trong trường.
-- R18. Một giáo viên chỉ quản lý tối đa 3 giáo viên khác.
-- R19. Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó.
