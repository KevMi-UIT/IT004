--TRUY VẤN
--Q1. Cho biết họ tên và mức lương của các giáo viên nữ.
SELECT HOTEN, LUONG
FROM GIAOVIEN
WHERE PHAI = N'Nữ'

--Q2. Cho biết họ tên của các giáo viên và lương của họ sau khi tăng 10%.
SELECT HOTEN, LUONG*1.1 AS LuongSauKhiTang
FROM GIAOVIEN

--Q3. Cho biết mã của các giáo viên có họ tên bắt đầu là "Nguyễn" và lương trên $2000 hoặc, giáo viên là trưởng bộ môn nhận chức sau năm 1995.
(
SELECT MAGV
FROM GIAOVIEN
WHERE HOTEN LIKE N'Nguyễn%' AND LUONG > 2000
)
UNION
(
SELECT TRUONGBM
FROM BOMON
WHERE YEAR(NGNHANCHUC) > 1995
)

--Q4. Cho biết tên những giáo viên khoa Công nghệ thông tin.
SELECT HOTEN
FROM KHOA K, GIAOVIEN GV, BOMON BM
WHERE K.MAKHOA = BM.MAKHOA AND BM.MABM = GV.MABM
AND	  K.TENKHOA = N'Công nghệ thông tin'

--Q5. Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó.
SELECT *
FROM BOMON BM LEFT JOIN GIAOVIEN GV
ON GV.MAGV = BM.TRUONGBM

--Q6. Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc.
SELECT *
FROM GIAOVIEN GV LEFT JOIN BOMON BM
ON GV.MABM = BM.MABM

--Q7. Cho biết tên đề tài và giáo viên chủ nhiệm đề tài.
SELECT TENDT, HOTEN
FROM DETAI DT INNER JOIN GIAOVIEN GV
ON DT.GVCNDT = GV.MAGV

--Q8. Với mỗi khoa cho biết thông tin trưởng khoa. 
SELECT *
FROM KHOA K LEFT JOIN GIAOVIEN GV
ON K.TRGKHOA = GV.MAGV

--Q9. Cho biết các giáo viên của bộ môn “Vi sinh” có tham gia đề tài 006.
SELECT DISTINCT HOTEN
FROM GIAOVIEN GV, BOMON BM, THAMGIADT TG
WHERE GV.MABM = BM.MABM AND GV.MAGV = TG.MAGV
AND	  BM.TENBM = N'Vi sinh' AND TG.MADT = '006'

--Q10. Với những đề tài thuộc cấp quản lý “Thành phố”, cho biết mã đề tài, đề tài thuộc về chủ đề nào, họ tên người chủ nhiệm đề tài cùng với ngày sinh và địa chỉ của người ấy.
SELECT MADT, TENCD, HOTEN, NGSINH, DIACHI
FROM DETAI DT, CHUDE CD, GIAOVIEN GV
WHERE DT.MACD = CD.MACD AND DT.GVCNDT = GV.MAGV
AND	  DT.CAPQL = N'Thành phố'

--Q11. Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó.
SELECT GV1.HOTEN, GV2.HOTEN AS GVQLCM
FROM GIAOVIEN GV1 LEFT JOIN GIAOVIEN GV2
ON GV1.GVQLCM = GV2.MAGV

--Q12. Tìm họ tên của những giáo viên được “Nguyễn Thanh Tùng” phụ trách trực tiếp.
SELECT HOTEN
FROM GIAOVIEN GV1
WHERE GVQLCM = (SELECT MAGV
				FROM GIAOVIEN GV2
				WHERE GV2.HOTEN = N'Nguyễn Thanh Tùng')

--Q13. Cho biết tên giáo viên là trưởng bộ môn Hệ thống thông tin.
SELECT HOTEN
FROM GIAOVIEN GV INNER JOIN BOMON BM
ON BM.TRUONGBM = GV.MAGV
WHERE TENBM = N'Hệ thống thông tin'

--Q14. Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục.
SELECT DISTINCT HOTEN
FROM DETAI DT INNER JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
		      INNER JOIN CHUDE CD ON DT.MACD = CD.MACD
WHERE TENCD = N'Quản lý giáo dục'

--Q15. Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu trong tháng 3/2008.
SELECT TENCV
FROM DETAI DT INNER JOIN CONGVIEC CV
ON DT.MADT = CV.MADT
WHERE TENDT = N'HTTT quản lý các trường DH' AND MONTH(CV.NGAYBD) = 3 AND YEAR(CV.NGAYBD) = 2008

--Q16. Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó.
SELECT GV1.HOTEN, GV2.HOTEN AS GVQLCM
FROM GIAOVIEN GV1 LEFT JOIN GIAOVIEN GV2
ON GV1.GVQLCM = GV2.MAGV

--Q17. Cho các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007.
SELECT *
FROM CONGVIEC
WHERE NGAYBD >= '2007-01-01' AND NGAYBD <= '2007-08-01'

--Q18. Cho biết họ tên các giáo viên cùng bộ môn với giáo viên “Trần Trà Hương”.
SELECT HOTEN
FROM GIAOVIEN GV1
WHERE MABM = (SELECT MABM
			  FROM GIAOVIEN GV2
			  WHERE HOTEN = N'Trần Trà Hương' AND GV1.MAGV <> GV2.MAGV)

--Q19. Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài.
SELECT DISTINCT HOTEN
FROM GIAOVIEN GV INNER JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
			     INNER JOIN DETAI DT ON GV.MAGV = DT.GVCNDT

--Q20. Cho biết tên những giáo viên vừa là trưởng khoa và vừa là trưởng bộ môn.
SELECT HOTEN
FROM GIAOVIEN GV INNER JOIN KHOA K ON GV.MAGV = K.TRGKHOA
			     INNER JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM

--Q21. Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài.
SELECT DISTINCT HOTEN
FROM BOMON BM INNER JOIN DETAI DT ON BM.TRUONGBM = DT.GVCNDT
			  INNER JOIN GIAOVIEN GV ON BM.TRUONGBM = GV.MAGV

--Q22. Cho biết mã số các trưởng khoa có chủ nhiệm đề tài.
SELECT DISTINCT TRGKHOA
FROM KHOA INNER JOIN DETAI
ON KHOA.TRGKHOA = DETAI.GVCNDT

--Q23. Cho biết mã số các giáo viên thuộc bộ môn HTTT hoặc có tham gia đề tài mã 001.
SELECT DISTINCT GIAOVIEN.MAGV
FROM GIAOVIEN INNER JOIN THAMGIADT
ON GIAOVIEN.MAGV = THAMGIADT.MAGV
WHERE MABM = 'HTTT' OR MADT = '001'

--Q24. Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002.
SELECT GV1.HOTEN
FROM GIAOVIEN GV1
WHERE GV1.MAGV <> '002'
AND	  GV1.MABM = (SELECT GV2.MABM
				  FROM GIAOVIEN GV2
				  WHERE GV2.MAGV = '002')

--Q25. Tìm những giáo viên là trưởng bộ môn. 
SELECT HOTEN, TENBM
FROM GIAOVIEN INNER JOIN BOMON 
ON MAGV = TRUONGBM

--Q26. Cho biết họ tên và mức lương của các giáo viên. 
SELECT HOTEN, LUONG
FROM GIAOVIEN

--Q27. Cho biết số lượng giáo viên viên và tổng lương của họ. 
SELECT COUNT(MAGV) AS SoLuongGiaoVien, SUM(LUONG) AS TongLuong
FROM GIAOVIEN

--Q28. Cho biết số lượng giáo viên và lương trung bình của từng bộ môn. 
SELECT MABM, COUNT(MAGV) AS SoLuongGiaoVien, AVG(LUONG) AS LuongTrungBinh
FROM GIAOVIEN
GROUP BY MABM

--Q29. Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó. 
SELECT TENCD, COUNT(MADT) AS SoLuongDeTai
FROM CHUDE LEFT JOIN DETAI
ON CHUDE.MACD = DETAI.MACD
GROUP BY TENCD

--Q30. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó tham gia. 
SELECT HOTEN, COUNT(DISTINCT MADT) AS SoLuongDeTai
FROM GIAOVIEN LEFT JOIN THAMGIADT
ON GIAOVIEN.MAGV = THAMGIADT.MAGV
GROUP BY HOTEN

--Q31. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm. 
SELECT HOTEN, COUNT(MADT) AS SoLuongDeTai
FROM GIAOVIEN LEFT JOIN DETAI
ON GIAOVIEN.MAGV = DETAI.GVCNDT
GROUP BY HOTEN

--Q32. Với mỗi giáo viên cho tên giáo viên và số người thân của giáo viên đó. 
SELECT HOTEN, COUNT(TEN) AS SoNguoiThan
FROM GIAOVIEN LEFT JOIN NGUOITHAN
ON GIAOVIEN.MAGV = NGUOITHAN.MAGV
GROUP BY HOTEN

--Q33. Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên.
SELECT HOTEN
FROM GIAOVIEN INNER JOIN THAMGIADT
ON GIAOVIEN.MAGV = THAMGIADT.MAGV
GROUP BY HOTEN
HAVING COUNT(DISTINCT MADT) >= 3

--Q34. Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh. 
SELECT COUNT(DISTINCT MAGV) AS SoLuongGiaoVien
FROM THAMGIADT INNER JOIN DETAI
ON THAMGIADT.MADT = DETAI.MADT
WHERE TENDT = N'Ứng dụng hóa học xanh'

--Q35. Cho biết mức lương cao nhất của các giảng viên. 
SELECT MAX(LUONG) AS LuongCaoNhat
FROM GIAOVIEN

--Q36. Cho biết những giáo viên có lương lớn nhất. 
SELECT HOTEN
FROM GIAOVIEN
WHERE LUONG = (SELECT MAX(LUONG) FROM GIAOVIEN)

--Q37. Cho biết lương cao nhất trong bộ môn “HTTT”. 
SELECT MAX(LUONG) AS LuongCaoNhat
FROM GIAOVIEN
WHERE MABM = 'HTTT'

--Q38. Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin. 
SELECT TOP 1 WITH TIES HOTEN
FROM GIAOVIEN INNER JOIN BOMON
ON GIAOVIEN.MABM = BOMON.MABM
WHERE TENBM = N'Hệ thống thông tin'
ORDER BY YEAR(NGSINH)

--Q39. Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin.
SELECT TOP 1 WITH TIES HOTEN
FROM BOMON BM INNER JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
			  INNER JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE TENKHOA = N'Công nghệ thông tin'
ORDER BY YEAR(NGSINH) DESC

--Q40. Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất.
SELECT HOTEN, TENKHOA
FROM BOMON BM INNER JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
			  INNER JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE LUONG = (SELECT MAX(LUONG) FROM GIAOVIEN)

--Q41. Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ.
--Cách 1: Lồng tương quan
SELECT *
FROM GIAOVIEN GV1
WHERE GV1.LUONG >= ALL (SELECT GV2.LUONG
						FROM GIAOVIEN GV2
						WHERE GV2.MABM = GV1.MABM)

--Cách 2:
SELECT *
FROM GIAOVIEN GV1
WHERE NOT EXISTS (SELECT *
				  FROM GIAOVIEN GV2
				  WHERE GV2.MABM = GV1. MABM
				  AND GV2. LUONG > GV1.LUONG)

--Cách 3:
SELECT GV1.MAGV, GV1.LUONG, GV2.MABM, MAX(GV2.LUONG)
FROM GIAOVIEN GV1, GIAOVIEN GV2
WHERE GV1.MABM = GV2.MABM
GROUP BY GV1.MAGV, GV1.LUONG, GV2.MABM
HAVING MAX(GV2.LUONG) <= GV1.LUONG

--Cách 4:
SELECT GV1.*
FROM GIAOVIEN GV1
WHERE GV1.LUONG >= ALL (SELECT MAX(GV2.LUONG)
						FROM GIAOVIEN GV2
						WHERE GV1.MABM = GV2.MABM)

--Cách 5:
SELECT GV1.*
FROM GIAOVIEN GV1, (SELECT GV2.MABM, MAX(GV2.LUONG) AS MAXLUONG
					FROM GIAOVIEN GV2
					GROUP BY GV2.MABM) AS TEMP
WHERE GV1.MABM = TEMP.MABM AND GV1.LUONG = TEMP.MAXLUONG

--Q42. Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia.
SELECT TENDT
FROM DETAI
WHERE MADT NOT IN (SELECT DISTINCT MADT
				   FROM THAMGIADT
				   WHERE MAGV IN (SELECT MAGV
								  FROM GIAOVIEN
								  WHERE HOTEN = N'Nguyễn Hoài An'))

--Q43. Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài, tên người chủ nhiệm đề tài.
SELECT TENDT, HOTEN AS NguoiChuNhiemDeTai
FROM DETAI INNER JOIN GIAOVIEN
ON DETAI.GVCNDT = GIAOVIEN.MAGV
WHERE MADT NOT IN (SELECT DISTINCT MADT
				   FROM THAMGIADT
				   WHERE MAGV IN (SELECT MAGV
								  FROM GIAOVIEN
								  WHERE HOTEN = N'Nguyễn Hoài An'))

--Q44. Cho biết tên những giáo viên khoa Công nghệ thông tin mà chưa tham gia đề tài nào.
SELECT HOTEN
FROM BOMON INNER JOIN GIAOVIEN ON GIAOVIEN.MABM = BOMON.MABM
		   INNER JOIN KHOA ON BOMON.MAKHOA = KHOA.MAKHOA
WHERE TENKHOA = N'Công nghệ thông tin'
AND	  MAGV NOT IN (SELECT DISTINCT MAGV
				   FROM THAMGIADT)

--Q45. Tìm những giáo viên không tham gia bất kỳ đề tài nào.
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (SELECT DISTINCT MAGV
				   FROM THAMGIADT)

--Q46. Cho biết giáo viên có lương lớn hơn lương của giáo viên “Nguyễn Hoài An” 
SELECT HOTEN
FROM GIAOVIEN
WHERE LUONG > (SELECT LUONG
			   FROM GIAOVIEN
			   WHERE HOTEN = N'Nguyễn Hoài An')

--Q47. Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài 
SELECT HOTEN
FROM GIAOVIEN INNER JOIN BOMON
ON GIAOVIEN.MAGV = BOMON.TRUONGBM
WHERE MAGV IN (SELECT MAGV
			   FROM THAMGIADT)

--Q48. Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn 
SELECT *
FROM GIAOVIEN GV1
WHERE MAGV IN (SELECT GV2.MAGV
			   FROM GIAOVIEN GV2
			   WHERE GV1.HOTEN = GV2.HOTEN AND GV1.PHAI = GV2.PHAI AND GV1.MABM = GV2.MABM AND GV1.MAGV <> GV2.MAGV)

--Q49. Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn “Công nghệ phần mềm” 
SELECT HOTEN
FROM GIAOVIEN
WHERE LUONG > ANY (SELECT LUONG
				   FROM GIAOVIEN INNER JOIN BOMON
				   ON GIAOVIEN.MABM = BOMON.MABM
				   WHERE TENBM = N'Công nghệ phần mềm')

--Q50. Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn “Hệ thống thông tin” 
SELECT HOTEN
FROM GIAOVIEN
WHERE LUONG > ALL (SELECT LUONG
				   FROM GIAOVIEN INNER JOIN BOMON
				   ON GIAOVIEN.MABM = BOMON.MABM
				   WHERE TENBM = N'Hệ thống thông tin')

--Q51. Cho biết tên khoa có đông giáo viên nhất 
SELECT TENKHOA
FROM BOMON INNER JOIN KHOA ON BOMON.MAKHOA = KHOA.MAKHOA
		   INNER JOIN GIAOVIEN ON BOMON.MABM = GIAOVIEN.MABM
GROUP BY TENKHOA
HAVING COUNT(*) >= ALL (SELECT COUNT (*)
						FROM BOMON INNER JOIN KHOA ON BOMON.MAKHOA = KHOA.MAKHOA
								   INNER JOIN GIAOVIEN ON BOMON.MABM = GIAOVIEN.MABM
						GROUP BY TENKHOA)

--Q52. Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất 
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV IN (SELECT GVCNDT
			   FROM DETAI
			   GROUP BY GVCNDT
			   HAVING COUNT (*) >= ALL (SELECT COUNT(*)
										FROM DETAI
										GROUP BY GVCNDT))

--Q53. Cho biết mã bộ môn có nhiều giáo viên nhất 
SELECT MABM
FROM GIAOVIEN
GROUP BY MABM
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM GIAOVIEN
						GROUP BY MABM)

--Q54. Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất. 
SELECT HOTEN, TENBM
FROM GIAOVIEN INNER JOIN BOMON
ON GIAOVIEN.MABM = BOMON.MABM
WHERE MAGV IN (SELECT MAGV
			   FROM THAMGIADT
			   GROUP BY MAGV
			   HAVING COUNT(DISTINCT MADT) >= ALL (SELECT COUNT(DISTINCT MADT)
												   FROM THAMGIADT
												   GROUP BY MAGV))

--Q55. Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT. 
SELECT HOTEN
FROM GIAOVIEN 
WHERE MABM = 'HTTT'
AND   MAGV IN (SELECT MAGV
			   FROM THAMGIADT
			   GROUP BY MAGV
			   HAVING COUNT(DISTINCT MADT) >= ALL (SELECT COUNT(DISTINCT MADT)
												   FROM THAMGIADT
												   GROUP BY MAGV))

--Q56. Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất. 
SELECT HOTEN, TENBM
FROM GIAOVIEN INNER JOIN BOMON
ON GIAOVIEN.MABM = BOMON.MABM
WHERE MAGV IN (SELECT MAGV
			   FROM NGUOITHAN
			   GROUP BY MAGV
			   HAVING COUNT(*) >= ALL (SELECT COUNT(*)
									   FROM NGUOITHAN
									   GROUP BY MAGV))

--Q57. Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất. 
SELECT HOTEN
FROM BOMON INNER JOIN GIAOVIEN ON BOMON.TRUONGBM = GIAOVIEN.MAGV
		   INNER JOIN DETAI ON BOMON.TRUONGBM = DETAI.GVCNDT
GROUP BY HOTEN
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM BOMON INNER JOIN DETAI
						ON BOMON.TRUONGBM = DETAI.GVCNDT
						GROUP BY TRUONGBM)

--Q58. Cho biết tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề. 
--Cách 1: GROUP BY- HAVING
SELECT GV.HOTEN, COUNT(DISTINCT DT.MACD)
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE GV.MAGV = TG.MAGV AND TG.MADT = DT.MADT
GROUP BY GV.HOTEN, DT.MADT
HAVING COUNT(DISTINCT DT.MACD) = (SELECT COUNT(*) FROM CHUDE)

--Cách 2: NOT EXISTS - NOT IN
SELECT *
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT *
				  FROM CHUDE CD
				  WHERE CD.MACD NOT IN (SELECT DT.MACD
										FROM THAMGIADT TG, DETAI DT
										WHERE TG.MADT = DT.MADT AND TG.MAGV = GV.MAGV))

--Cách 3: NOT EXISTS - NOT EXISTS
SELECT *
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT *
				  FROM CHUDE CD
				  WHERE NOT EXISTS (SELECT DT.MACD
									FROM THAMGIADT TG, DETAI DT
									WHERE TG.MADT = DT.MADT AND TG.MAGV = GV.MAGV AND DT.MACD = CD.MACD))

--Q59. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia. 
SELECT TENDT
FROM DETAI
WHERE NOT EXISTS (SELECT *
				  FROM GIAOVIEN
				  WHERE MABM = 'HTTT'
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MADT = DETAI.MADT AND THAMGIADT.MAGV = GIAOVIEN.MAGV))

--Q60. Cho biết tên đề tài có tất cả giảng viên bộ môn “Hệ thống thông tin” tham gia 
SELECT TENDT
FROM DETAI
WHERE NOT EXISTS (SELECT *
				  FROM GIAOVIEN INNER JOIN BOMON
				  ON GIAOVIEN.MABM = BOMON.MABM
				  WHERE TENBM = N'Hệ thống thông tin'
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MADT = DETAI.MADT AND THAMGIADT.MAGV = GIAOVIEN.MAGV))

--Q61. Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD. 
SELECT *
FROM GIAOVIEN
WHERE NOT EXISTS (SELECT *
				  FROM DETAI
				  WHERE MACD = 'QLGD'
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MADT = DETAI.MADT AND GIAOVIEN.MAGV = THAMGIADT.MAGV))

--Q62. Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia. 
--Cách 1: GROUP BY - HAVING
SELECT GV1.HOTEN
FROM GIAOVIEN GV1, THAMGIADT TG1, (SELECT TG2.MADT, GV2.MAGV
								   FROM GIAOVIEN GV2, THAMGIADT TG2
								   WHERE TG2.MAGV = GV2.MAGV AND GV2.HOTEN = N'Trần Trà Hương') AS TEMP
WHERE GV1.MAGV = TG1.MAGV AND TG1.MADT = TEMP.MADT AND GV1.MAGV <> TEMP.MAGV
GROUP BY GV1.HOTEN, TEMP.MADT
HAVING COUNT (DISTINCT TEMP.MADT) = (SELECT COUNT (DISTINCT TG3.MADT)
									 FROM GIAOVIEN GV3, THAMGIADT TG3
									 WHERE GV3.MAGV = TG3.MAGV AND GV3.HOTEN = N'Trần Trà Hương')

--Cách 2: NOT EXISTS - NOT IN
SELECT GV1.HOTEN
FROM GIAOVIEN GV1
WHERE NOT EXISTS (SELECT *
				  FROM GIAOVIEN GV2, THAMGIADT TG2
				  WHERE GV2.MAGV = TG2.MAGV AND GV2.HOTEN = N'Trần Trà Hương'
				  AND TG2.MADT NOT IN (SELECT TG3.MADT
									   FROM THAMGIADT TG3
									   WHERE TG3.MAGV = GV1.MAGV AND TG3.MADT = TG2.MADT AND TG3.MAGV <> TG2.MAGV))
									
--Cách 3: NOT EXISTS - NOT EXISTS
SELECT GV1.HOTEN
FROM GIAOVIEN GV1
WHERE NOT EXISTS (SELECT *
				  FROM GIAOVIEN GV2, THAMGIADT TG2
				  WHERE GV2.MAGV = TG2.MAGV AND GV2.HOTEN = N'Trần Trà Hương'
				  AND NOT EXISTS (SELECT TG3.MADT
								  FROM THAMGIADT TG3
							      WHERE TG3.MAGV = GV1.MAGV AND TG3.MADT = TG2.MADT AND TG3.MAGV <> TG2.MAGV))

--Q63. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn Hóa Hữu Cơ tham gia. 
SELECT TENDT
FROM DETAI DT
	JOIN THAMGIADT TG ON TG.MADT = DT.MADT
	JOIN GIAOVIEN GV ON GV.MAGV = TG.MAGV
	JOIN BOMON BM ON BM.MABM = GV.MABM
WHERE TENBM = N'Hóa Hữu Cơ'
GROUP BY TENDT
HAVING COUNT(DISTINCT GV.MAGV) =(SELECT COUNT(*)
								 FROM GIAOVIEN GV JOIN BOMON BM 
								 ON BM.MABM = GV.MABM
								 WHERE TENBM = N'Hóa Hữu Cơ')

--Q64. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006. 
SELECT DISTINCT HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS (SELECT *
				  FROM CONGVIEC
				  WHERE CONGVIEC.MADT = '006'
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MAGV = GIAOVIEN.MAGV AND THAMGIADT.MADT = CONGVIEC.MADT
									AND CONGVIEC.SOTT = THAMGIADT.STT))

--Q65. Cho biết giáo viên nào đã tham gia tất cả các đề tài của chủ đề Ứng dụng công nghệ. 
SELECT HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS (SELECT *
				  FROM DETAI
				  WHERE DETAI.MACD = (SELECT MACD
									  FROM CHUDE
									  WHERE TENCD = N'Ứng dụng công nghệ')
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MAGV = GIAOVIEN.MAGV AND THAMGIADT.MADT = DETAI.MADT))

--Q66. Cho biết tên giáo viên nào đã tham gia tất cả các đề tài của do Trần Trà Hương làm chủ nhiệm. 
SELECT HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS (SELECT *
				  FROM DETAI
				  WHERE DETAI.GVCNDT = (SELECT MAGV
										FROM GIAOVIEN
										WHERE HOTEN = N'Trần Trà Hương')
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MADT = DETAI.MADT AND THAMGIADT.MAGV = GIAOVIEN.MAGV))

--Q67. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia. 
SELECT TENDT
FROM DETAI
WHERE NOT EXISTS (SELECT *
				  FROM GIAOVIEN
				  WHERE GIAOVIEN.MABM IN (SELECT MABM
										  FROM BOMON
										  WHERE BOMON.MAKHOA = 'CNTT')
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MAGV = GIAOVIEN.MAGV AND THAMGIADT.MADT = DETAI.MADT))

--Q68. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài Nghiên cứu tế bào gốc. 
SELECT DISTINCT HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS (SELECT *
				  FROM CONGVIEC
				  WHERE CONGVIEC.MADT = (SELECT MADT
										 FROM DETAI
										 WHERE TENDT = N'Nghiên cứu tế bào gốc')
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MAGV = GIAOVIEN.MAGV AND THAMGIADT.MADT = CONGVIEC.MADT
									AND CONGVIEC.SOTT = THAMGIADT.STT))

--Q69. Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí trên 100 triệu? 
SELECT HOTEN
FROM GIAOVIEN JOIN THAMGIADT
ON GIAOVIEN.MAGV = THAMGIADT.MAGV
WHERE NOT EXISTS (SELECT *
				  FROM DETAI
				  WHERE KINHPHI > 100
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MADT = DETAI.MADT AND THAMGIADT.MAGV = GIAOVIEN.MAGV))

--Q70. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa Sinh Học tham gia. 
SELECT TENDT
FROM DETAI
WHERE NOT EXISTS (SELECT *
				  FROM GIAOVIEN
				  WHERE GIAOVIEN.MABM IN (SELECT MABM
										  FROM BOMON
										  WHERE BOMON.MAKHOA = (SELECT MAKHOA
																FROM KHOA
																WHERE TENKHOA = N'Sinh Học'))
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MAGV = GIAOVIEN.MAGV AND THAMGIADT.MADT = DETAI.MADT))

--Q71. Cho biết mã số, họ tên, ngày sinh của giáo viên tham gia tất cả các công việc của đề tài “Ứng dụng hóa học xanh”. 
SELECT DISTINCT MAGV, HOTEN, NGSINH
FROM GIAOVIEN 
WHERE NOT EXISTS (SELECT *
				  FROM CONGVIEC CV
				  WHERE	NOT EXISTS (SELECT *
									FROM THAMGIADT TGDT
									WHERE TGDT.MADT = (SELECT MADT
													   FROM DETAI
													   WHERE TENDT = N'Ứng dụng hóa học xanh')
													   AND TGDT.MADT = CV.MADT AND TGDT.MAGV = GIAOVIEN.MAGV
													   AND TGDT.STT = CV.SOTT))

--Q72. Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của giáo viên tham gia tất cả các đề tài thuộc chủ đề “Nghiên cứu phát triển”.
SELECT DISTINCT MAGV, HOTEN, TENBM, (SELECT HOTEN FROM GIAOVIEN GV WHERE GV.MAGV = GIAOVIEN.GVQLCM) AS NguoiQuanLyChuyenMon
FROM GIAOVIEN INNER JOIN BOMON ON GIAOVIEN.MABM = BOMON.MABM
WHERE NOT EXISTS (SELECT *
				  FROM DETAI
				  WHERE DETAI.MACD = (SELECT MACD
									  FROM CHUDE
									  WHERE TENCD = N'Nghiên cứu phát triển')
				  AND	NOT EXISTS (SELECT *
									FROM THAMGIADT
									WHERE THAMGIADT.MAGV = GIAOVIEN.MAGV AND THAMGIADT.MADT = DETAI.MADT))

--Q73. Cho biết họ tên, ngày sinh, tên khoa, tên trưởng khoa của giáo viên tham gia tất cả các đề tài có giáo viên  “Nguyễn Hoài An” tham gia. 
SELECT GV1.HOTEN, GV1.NGSINH, TENKHOA, TRGK.HOTEN
FROM BOMON INNER JOIN GIAOVIEN GV1 ON BOMON.MABM = GV1.MABM
		   INNER JOIN KHOA ON BOMON.MAKHOA = KHOA.MAKHOA
		   INNER JOIN GIAOVIEN TRGK ON TRGK.MAGV = KHOA.TRGKHOA
WHERE NOT EXISTS (SELECT *
				  FROM GIAOVIEN GV2, THAMGIADT TG2
				  WHERE GV2.MAGV = TG2.MAGV AND GV2.HOTEN = N'Nguyễn Hoài An'
				  AND NOT EXISTS (SELECT TG3.MADT
								  FROM THAMGIADT TG3
							      WHERE TG3.MAGV = GV1.MAGV AND TG3.MADT = TG2.MADT AND TG3.MAGV <> TG2.MAGV))

/*
Q74. Cho biết họ tên giáo viên khoa “Công nghệ thông tin” tham gia tất cả các công việc của đề tài có trưởng bộ 
môn của bộ môn đông nhất khoa “Công nghệ thông tin” làm chủ nhiệm. 
*/
SELECT GV1.HOTEN
FROM GIAOVIEN GV1 JOIN BOMON BM1 ON GV1.MABM = BM1.MABM
				  JOIN KHOA K1 ON K1.MAKHOA = BM1.MAKHOA
WHERE K1.TENKHOA = N'Công nghệ thông tin'
AND   NOT EXISTS (SELECT *
				  FROM CONGVIEC CV2
				  WHERE CV2.MADT IN (SELECT MADT
									 FROM DETAI DT3
									 WHERE DT3.GVCNDT IN (SELECT TRUONGBM
													      FROM BOMON BM4 JOIN KHOA K4 ON BM4.MAKHOA = K4.MAKHOA
																	     JOIN GIAOVIEN GV4 ON BM4.MABM = GV4.MABM
														  WHERE K4.TENKHOA = N'Công nghệ thông tin' 
														  GROUP BY BM4.TRUONGBM
														  HAVING COUNT(GV4.MAGV) >= ALL (SELECT COUNT(GV5.MAGV)
																					     FROM BOMON BM5 JOIN KHOA K5 ON BM5.MAKHOA = K5.MAKHOA
																									  JOIN GIAOVIEN GV5 ON GV5.MABM = BM5.MABM
																					     WHERE K5.TENKHOA = N'Công nghệ thông tin'
																					     GROUP BY BM5.MABM)))
				  AND NOT EXISTS (SELECT *
								  FROM THAMGIADT TG6
								  WHERE GV1.MAGV = TG6.MAGV AND CV2.MADT = TG6.MADT AND TG6.STT = CV2.SOTT))

--Q75. Cho biết họ tên giáo viên và tên bộ môn họ làm trưởng bộ môn nếu có
SELECT HOTEN, TENBM
FROM GIAOVIEN LEFT JOIN BOMON
ON GIAOVIEN.MAGV = BOMON.TRUONGBM

--Q76. Cho danh sách tên bộ môn và họ tên trưởng bộ môn đó nếu có 
SELECT TENBM, HOTEN
FROM GIAOVIEN RIGHT JOIN BOMON
ON GIAOVIEN.MAGV = BOMON.TRUONGBM

--Q77. Cho danh sách tên giáo viên và các đề tài giáo viên đó chủ nhiệm nếu có 
SELECT HOTEN, TENDT
FROM GIAOVIEN LEFT JOIN DETAI
ON GIAOVIEN.MAGV = DETAI.GVCNDT

--Q78. Xóa các đề tài thuộc chủ đề “NCPT”. 
DELETE FROM DETAI
WHERE MACD = 'NCPT'

/*
Q79. Xuất ra thông tin của giáo viên (MAGV, HOTEN) và mức lương của giáo viên. Mức lương được xếp theo  
quy tắc: Lương của giáo viên < $1800 : “THẤP” ;  Từ $1800 đến $2200: TRUNG BÌNH; Lương > $2200: “CAO” 
*/
SELECT MAGV, HOTEN, CASE WHEN LUONG < 1800 THEN N'THẤP'
						 WHEN LUONG >= 1800 AND LUONG <= 2200 THEN N'TRUNG BÌNH'
						 WHEN LUONG > 2200 THEN N'CAO'
						 END  AS MucLuong
FROM GIAOVIEN

--Q80. Xuất ra thông tin giáo viên (MAGV, HOTEN) và xếp hạng dựa vào mức lương. Nếu giáo viên có lương cao  nhất thì hạng là 1. 
SELECT MAGV, HOTEN, RANK () OVER (ORDER BY LUONG DESC) AS Hang
FROM GIAOVIEN

/*
Q81. Xuất ra thông tin thu nhập của giáo viên. Thu nhập của giáo viên được tính bằng LƯƠNG + PHỤ CẤP. 
Nếu giáo viên là trưởng bộ môn thì PHỤ CẤP là 300, và giáo viên là trưởng khoa thì PHỤ CẤP là 600. 
*/
SELECT HOTEN, CASE MAGV WHEN KHOA.TRGKHOA THEN LUONG + 600
						WHEN BOMON.TRUONGBM THEN LUONG + 300
						WHEN GIAOVIEN.MAGV THEN LUONG
						END AS LUONG
FROM GIAOVIEN LEFT JOIN KHOA ON GIAOVIEN.MAGV = KHOA.TRGKHOA
			  LEFT JOIN BOMON ON GIAOVIEN.MAGV = BOMON.TRUONGBM

--Q82. Xuất ra năm mà giáo viên dự kiến sẽ nghĩ hưu với quy định: Tuổi nghỉ hưu của Nam là 60, của Nữ là 55.
SELECT HOTEN, CASE PHAI WHEN 'Nam' THEN YEAR(NGSINH) + 60
						WHEN N'Nữ' THEN YEAR(NGSINH) + 55
						END AS NamNghiHuu
FROM GIAOVIEN

--RÀNG BUỘC TOÀN VẸN
--R1. Tên tài phải duy nhất  
ALTER TABLE DETAI ADD CONSTRAINT TEN_DT_DUY_NHAT UNIQUE (MADT)

--R2. Trưởng bộ môn phải sinh trước 1975 
/*
					Them		Xoa		Sua
BOMON				 +			 -		+(TRUONGBM)
GIAOVIEN			 -			 -		+(NGSINH)
*/
CREATE TRIGGER TRGBM_1975_BOMON
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
			   FROM GIAOVIEN GV INNER JOIN inserted I
			   ON GV.MAGV = I.TRUONGBM
			   WHERE YEAR(GV.NGSINH) > 1975)
	BEGIN
		RAISERROR(N'Trưởng bộ môn phải sinh trước 1975', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER TRGBM_1975_GIAOVIEN
ON GIAOVIEN
FOR UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
			   FROM BOMON BM INNER JOIN inserted I
			   ON BM.TRUONGBM = I.MAGV
			   WHERE YEAR(I.NGSINH) > 1975)
	BEGIN
		RAISERROR(N'Trưởng bộ môn phải sinh trước 1975', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R3. Một bộ môn có tối thiểu 1 giáo viên nữ 
/*
					Them		Xoa		Sua
BOMON				 +			 -		-(*)
GIAOVIEN			 -			 +		+(MABM, PHAI)
*/
CREATE TRIGGER BM_CO_1_GV_NU_BOMON
ON BOMON
FOR INSERT
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM inserted I INNER JOIN GIAOVIEN GV
		ON I.MABM = GV.MABM
		WHERE PHAI = N'Nữ') < 1
	BEGIN
		RAISERROR(N'Bộ môn này chưa có giáo viên nữ', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER BM_CO_1_GV_NU_GIAOVIEN_DELETE
ON GIAOVIEN
FOR DELETE
AS
BEGIN
	DECLARE @MaBM char(4)
	SELECT @MaBM FROM deleted
	IF (SELECT COUNT(*)
		FROM GIAOVIEN
		WHERE MABM = @MaBM AND PHAI = N'Nữ') < 1
	BEGIN
		RAISERROR(N'Không được xóa giáo viên nữ duy nhất của bộ môn', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER BM_CO_1_GV_NU_GIAOVIEN_UPDATE
ON GIAOVIEN
FOR UPDATE
AS
BEGIN
	DECLARE @MaBM char(4)
	SELECT @MaBM FROM deleted
	IF (SELECT COUNT(*)
		FROM GIAOVIEN
		WHERE MABM = @MaBM AND PHAI = N'Nữ') < 1
	BEGIN
		RAISERROR(N'Không được thay đổi bộ môn/phái của giáo viên nữ duy nhất', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R4. Một giáo viên phải có ít nhất 1 số điện thoại 
/*
					Them		Xoa		Sua
GV_DT				 -			 +		-(*)
GIAOVIEN			 +			 -		-(*)
*/
CREATE TRIGGER GV_CO_1_SODT_DIENTHOAI
ON GV_DT
FOR DELETE
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM deleted D INNER JOIN GV_DT
		ON D.MAGV = GV_DT.MAGV) < 1
	BEGIN
		RAISERROR(N'Không được xóa số điện thoại duy nhất của giáo viên', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER GV_CO_1_SODT_GIAOVIEN
ON GIAOVIEN
FOR INSERT
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM inserted I INNER JOIN GV_DT
		ON I.MAGV = GV_DT.MAGV) < 1
	BEGIN
		RAISERROR(N'Giáo viên chưa có số điện thoại', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R5. Một giáo viên có tối đa 3 số điện thoại 
/*
					Them		Xoa		Sua
GV_DT				 +			 -		-(*)
GIAOVIEN			 -			 -		 -
*/
CREATE TRIGGER GV_CO_TOIDA_3_SODT
ON GV_DT
FOR INSERT
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM inserted I INNER JOIN GV_DT
		ON I.MAGV = GV_DT.MAGV) > 3
	BEGIN
		RAISERROR(N'Một giáo viên có tối đa 3 số điện thoại', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R6. Một bộ môn phải có tối thiểu 4 giáo viên 
/*
					Them		Xoa		Sua
BOMON				 +			 -		-(*)
GIAOVIEN			 -			 +		+(MABM)
*/
CREATE TRIGGER BM_CO_4_GV_BOMON
ON BOMON
FOR INSERT
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM inserted I INNER JOIN GIAOVIEN GV
		ON I.MABM = GV.MABM) < 4
	BEGIN
		RAISERROR(N'Bộ môn chưa đủ 4 giáo viên', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER BM_CO_4_GV_GIAOVIEN
ON GIAOVIEN
FOR DELETE, UPDATE
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM deleted D INNER JOIN GIAOVIEN GV
		ON D.MABM = GV.MABM) < 4
	BEGIN
		RAISERROR(N'Bộ môn chưa đủ 4 giáo viên', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R7. Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn. 
/*
					Them		Xoa		Sua
BOMON				 -			 -		+(TRUONGBM)
GIAOVIEN			 +			 -		+(MABM, NGSINH)
*/
CREATE TRIGGER TRGBM_LON_TUOI_BOMON
ON BOMON
FOR UPDATE
AS
BEGIN
	DECLARE @TRGBM char(3), @MaBM char(4)
	SELECT @TRGBM, @MaBM FROM inserted
	IF EXISTS (SELECT MAGV
			   FROM GIAOVIEN GV1
			   WHERE GV1.MAGV = @TRGBM AND NGSINH > ANY (SELECT NGSINH
														 FROM GIAOVIEN GV2
														 WHERE GV2.MABM = @MaBM))
	BEGIN
		RAISERROR(N'Trưởng bộ môn không phải là người lớn tuổi nhất trong bộ môn', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER TRGBM_LON_TUOI_GIAOVIEN
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaBM char(4)
	SELECT @MaBM FROM inserted
	IF EXISTS (SELECT MAGV
			   FROM inserted
			   WHERE NGSINH < (SELECT NGSINH
							   FROM GIAOVIEN
							   WHERE MAGV = (SELECT TRUONGBM
											 FROM BOMON
											 WHERE MABM = @MaBM)))
	BEGIN
		RAISERROR(N'Trưởng bộ môn không phải là người lớn tuổi nhất trong bộ môn', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R8. Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn.
/*
					Them		Xoa		Sua
BOMON				 +			 -		+(TRUONGBM)
GIAOVIEN			 +			 -		+(GVQLCM)
*/
CREATE TRIGGER TRUONGBM_GVQLCM_BOMON
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @TRGBM char(3)
	SELECT @TRGBM FROM inserted
	IF EXISTS (SELECT MAGV
			   FROM GIAOVIEN
			   WHERE GVQLCM = @TRGBM)
	BEGIN
		RAISERROR(N'Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER TRUONGBM_GVQLCM_GIAOVIEN
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT TRUONGBM
			   FROM BOMON
			   WHERE TRUONGBM = (SELECT GVQLCM
								 FROM inserted))
	BEGIN
		RAISERROR(N'Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R9. Giáo viên và giáo viên quản lý chuyên môn của giáo viên đó phải thuộc về 1 bộ môn.  
/*
					Them		Xoa		Sua
GIAOVIEN			 +			 -		+(GVQLCM, MABM)
*/
CREATE TRIGGER GV_GVQLCM
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
			   FROM inserted
			   WHERE MABM <> (SELECT MABM
							  FROM GIAOVIEN
							  WHERE MAGV = (SELECT GVQLCM
											FROM inserted)))
	BEGIN
		RAISERROR(N'Giáo viên và giáo viên quản lý chuyên môn của giáo viên đó phải thuộc về 1 bộ môn', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R10. Mỗi giáo viên chỉ có tối đa 1 vợ chồng 
--TRONG DATABASE, BẢNG NGUOITHAN KHÔNG CÓ THUỘC TÍNH QUAN HỆ

--R11. Giáo viên là Nam thì chỉ có vợ chồng là Nữ hoặc ngược lại. 
--TRONG DATABASE, BẢNG NGUOITHAN KHÔNG CÓ THUỘC TÍNH QUAN HỆ

--R12. Nếu thân nhân có quan hệ là “con gái” hoặc “con trai” với giáo viên thì năm sinh của giáo viên phải nhỏ hơn năm sinh của thân nhân. 
--TRONG DATABASE, BẢNG NGUOITHAN KHÔNG CÓ THUỘC TÍNH QUAN HỆ

--R13. Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài. 
/*
					Them		Xoa		Sua
DETAI				 +			 -		+(GVCNDT)
GIAOVIEN			 -			 -		-
*/
CREATE TRIGGER GV_3_DT
ON DETAI
FOR INSERT, UPDATE
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM DETAI DT INNER JOIN inserted I
		ON DT.GVCNDT = I.GVCNDT) > 3
	BEGIN
		RAISERROR(N' Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R14. Một đề tài phải có ít nhất một công việc 
/*
					Them		Xoa		Sua
DETAI				 +			 -		-(*)
CONGVIEC			 -			 +		-(*)
*/
CREATE TRIGGER DT_1_CV_DETAI
ON DETAI
FOR INSERT
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM CONGVIEC CV INNER JOIN inserted I
		ON CV.MADT = I.MADT) < 1
	BEGIN
		RAISERROR(N'Một đề tài phải có ít nhất một công việc', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER DT_1_CV_CONGVIEC
ON CONGVIEC
FOR DELETE
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM CONGVIEC CV INNER JOIN deleted D
		ON CV.MADT = D.MADT) < 1
	BEGIN
		RAISERROR(N'Một đề tài phải có ít nhất một công việc', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R15. Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó. 
/*
					Them		Xoa		Sua
GIAOVIEN			 +			 -		+(GVQLCM, LUONG)
*/
CREATE TRIGGER LUONG_GV_GVQLCM
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
			   FROM inserted
			   WHERE LUONG > (SELECT LUONG
							  FROM GIAOVIEN
							  WHERE MAGV = (SELECT GVQLCM
											FROM inserted)))
	BEGIN
		RAISERROR(N'Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R16. Lương của trưởng bộ môn phải lớn hơn lương của các giáo viên trong bộ môn. 
/*
					Them		Xoa		Sua
BOMON				 +			 -		+(TRUONGBM)
GIAOVIEN			 +			 -		+(LUONG)
*/
CREATE TRIGGER LUONG_TRGBM_BOMON
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @TRGBM char(3), @MaBM char(4)
	SELECT @TRGBM, @MaBM FROM inserted
	IF EXISTS (SELECT *
			   FROM GIAOVIEN
			   WHERE MAGV = @TRGBM AND LUONG < ANY (SELECT LUONG
													FROM GIAOVIEN
													WHERE MABM = @MaBM))
	BEGIN
		RAISERROR(N'Lương của trưởng bộ môn phải lớn hơn lương của các giáo viên trong bộ môn', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER LUONG_TRGBM_GIAOVIEN
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaBM char(4)
	SELECT @MaBM FROM inserted
	IF EXISTS (SELECT *
			   FROM inserted
			   WHERE LUONG > (SELECT LUONG
							  FROM GIAOVIEN
							  WHERE MAGV = (SELECT TRUONGBM
											FROM BOMON
											WHERE MABM = @MaBM)))
	BEGIN
		RAISERROR(N'Lương của trưởng bộ môn phải lớn hơn lương của các giáo viên trong bộ môn', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R17. Bộ môn ban nào cũng phải có trưởng bộ môn và trưởng bộ môn phải là một giáo viên trong trường. 
--TRONG DATABASE, TRƯỞNG BỘ MÔN CÓ THỂ LÀ NULL

--R18. Một giáo viên chỉ quản lý tối đa 3 giáo viên khác. 
/*
					Them		Xoa		Sua
GIAOVIEN			 +			 -		+(GVQLCM)
*/
CREATE TRIGGER GVQLCM_3_GV
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM inserted I INNER JOIN GIAOVIEN GV
		ON I.GVQLCM = GV.GVQLCM) > 3
	BEGIN
		RAISERROR(N'Một giáo viên chỉ quản lý tối đa 3 giáo viên khác', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--R19. Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó.
/*
					Them		Xoa		Sua
DETAI				 -			 -		+(GVCNDT)
GIAOVIEN			 -			 -		+(MABM)
THAMGIADT			 +			 -		-(*)
*/
CREATE TRIGGER TGDT_DETAI
ON DETAI
FOR UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
			   FROM inserted I INNER JOIN GIAOVIEN GV
			   ON I.GVCNDT = GV.MAGV
			   WHERE GV.MABM <> (SELECT MABM
								 FROM GIAOVIEN
								 WHERE MAGV = (SELECT MAGV
											   FROM THAMGIADT TG INNER JOIN inserted I
											   ON TG.MADT = I.MADT)))
	BEGIN
		RAISERROR(N'Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER TGDT_GIAOVIEN
ON GIAOVIEN
FOR UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
			   FROM inserted
			   WHERE MABM <> (SELECT MABM
							  FROM GIAOVIEN
							  WHERE MAGV = (SELECT GVCNDT
											FROM DETAI DT INNER JOIN THAMGIADT TG ON DT.MADT = TG.MADT
														  INNER JOIN inserted I ON TG.MAGV = I.MAGV)))
	BEGIN
		RAISERROR(N'Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó', 16, 1)
		ROLLBACK TRANSACTION
	END
END
		
CREATE TRIGGER TGDT_THAMGIADT
ON THAMGIADT
FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT *
			   FROM inserted I INNER JOIN GIAOVIEN GV
			   ON I.MAGV = GV.MAGV
			   WHERE GV.MABM <> (SELECT MABM
								 FROM GIAOVIEN
								 WHERE MAGV = (SELECT GVCNDT
											   FROM DETAI DT INNER JOIN inserted I
											   ON DT.MADT = I.MADT)))
	BEGIN
		RAISERROR(N'Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó', 16, 1)
		ROLLBACK TRANSACTION
	END
END