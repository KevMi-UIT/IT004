-- 1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006. 
(
  SELECT
    SANPHAM.MASP,
    TENSP
  FROM
    SANPHAM
    LEFT JOIN CTHD ON SANPHAM.MASP = CTHD.MASP
    LEFT JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
  WHERE
    NUOCSX = 'Trung Quoc'
  GROUP BY
    SANPHAM.MASP,
    TENSP
)
EXCEPT
(
  SELECT
    SANPHAM.MASP,
    TENSP
  FROM
    SANPHAM
    LEFT JOIN CTHD ON SANPHAM.MASP = CTHD.MASP
    LEFT JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
  WHERE
    NUOCSX = 'Trung Quoc'
    AND YEAR (NGHD) = '2006'
  GROUP BY
    SANPHAM.MASP,
    TENSP
);

-- 2. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT
  COUNT(*) AS SOHD
FROM
  HOADON
WHERE
  MAKH IS NULL;

-- 3. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT
  COUNT(DISTINCT MASP) AS SOSP
FROM
  HOADON AS HD
  INNER JOIN CTHD ON HD.SOHD = CTHD.SOHD
WHERE
  YEAR (NGHD) = '2006';

-- 4. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
(
  SELECT
    MAX(TRIGIA)
  FROM
    HOADON
)
UNION
(
  SELECT
    MIN(TRIGIA)
  FROM
    HOADON
);

-- 5. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT
  AVG(TRIGIA) AS TRIGIATB
FROM
  HOADON
WHERE
  YEAR (NGHD) = '2006';

-- 6. Tính doanh thu bán hàng trong năm 2006.
SELECT
  SUM(TRIGIA) AS DOANHTHU
FROM
  HOADON
WHERE
  YEAR (NGHD) = '2006';

-- 7. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT
  SOHD,
  TRIGIA
FROM
  HOADON
WHERE
  YEAR (NGHD) = '2006'
  AND TRIGIA = (
    SELECT
      MAX(TRIGIA)
    FROM
      HOADON
  );

-- 8. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT
  HOTEN,
  SOHD,
  TRIGIA
FROM
  HOADON AS HD
  INNER JOIN KHACHHANG AS KH ON HD.MAKH = KH.MAKH
WHERE
  YEAR (NGHD) = '2006'
  AND TRIGIA = (
    SELECT
      MAX(TRIGIA)
    FROM
      HOADON
  );

-- 9. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.
SELECT
  TOP (3) *
FROM
  KHACHHANG
ORDER BY
  DOANHSO DESC;

-- 10. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất
SELECT
  TOP (3)
WITH
  TIES MASP,
  TENSP
FROM
  SANPHAM
ORDER BY
  GIA DESC;

-- 11. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
WITH
  SPTOP3 AS (
    SELECT
      TOP (3)
    WITH
      TIES MASP,
      NUOCSX,
      TENSP
    FROM
      SANPHAM
    ORDER BY
      GIA DESC
  )
SELECT
  MASP,
  TENSP
FROM
  SPTOP3
WHERE
  NUOCSX = 'Thai Lan';

-- 12. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT
  TOP (3)
WITH
  TIES MASP,
  NUOCSX,
  TENSP
FROM
  SANPHAM
WHERE
  NUOCSX = 'Trung Quoc';

ORDER BY
  GIA DESC;

-- 13. In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).
SELECT
  TOP (3) *
FROM
  KHACHHANG
ORDER BY
  DOANHSO DESC;

-- 14. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT
  COUNT(MASP) AS TONGSP
FROM
  SANPHAM
WHERE
  NUOCSX = 'Trung Quoc';

-- 15. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT
  NUOCSX,
  COUNT(MASP) AS TONGSP
FROM
  SANPHAM
GROUP BY
  NUOCSX;

-- 16. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT
  NUOCSX,
  MAX(GIA) AS GIACAO,
  MIN(GIA) AS GIATHAP,
  AVG(GIA) AS GIATB
FROM
  SANPHAM
GROUP BY
  NUOCSX;

-- 17. Tính doanh thu bán hàng mỗi ngày
SELECT
  NGHD,
  SUM(TRIGIA) AS DOANHTHU
FROM
  HOADON
GROUP BY
  NGHD;

-- 18. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT
  MASP,
  SUM(SL) TONGSL
FROM
  CTHD
  INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE
  YEAR (NGHD) = '2006'
  AND MONTH (NGHD) = '10'
GROUP BY
  MASP;

-- 19. Tính doanh thu bán hàng của từng tháng trong năm 2006
SELECT
  MONTH (NGHD) AS THANG,
  SUM(TRIGIA) AS DOANHTHU
FROM
  HOADON
WHERE
  YEAR (NGHD) = '2006'
GROUP BY
  MONTH (NGHD);

-- 20. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT
  SOHD
FROM
  CTHD
GROUP BY
  SOHD
HAVING
  COUNT(DISTINCT MASP) >= 4;

-- 21.Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT
  SOHD
FROM
  CTHD
  INNER JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP
WHERE
  NUOCSX = 'Viet Nam'
GROUP BY
  SOHD,
  NUOCSX
HAVING
  COUNT(DISTINCT CTHD.MASP) = 3;

-- 22. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
WITH
  KHMUA AS (
    SELECT
      KH.MAKH,
      HOTEN,
      COUNT(SOHD) AS TONGSOHD
    FROM
      HOADON AS HD
      INNER JOIN KHACHHANG AS KH ON HD.MAKH = KH.MAKH
    GROUP BY
      KH.MAKH,
      HOTEN
  )
SELECT
  MAKH,
  HOTEN
FROM
  KHMUA
WHERE
  TONGSOHD = (
    SELECT
      MAX(TONGSOHD)
    FROM
      KHMUA
  );

-- 23. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
WITH
  DOANHSO AS (
    SELECT
      MONTH (NGHD) AS THANG,
      SUM(TRIGIA) AS DOANHTHU
    FROM
      HOADON
    WHERE
      YEAR (NGHD) = '2006'
    GROUP BY
      MONTH (NGHD)
  )
SELECT
  THANG
FROM
  DOANHSO
WHERE
  DOANHTHU = (
    SELECT
      MAX(DOANHTHU)
    FROM
      DOANHSO
  );

-- 24. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
WITH
  SLSP2006 AS (
    SELECT
      SP.MASP,
      TENSP,
      SUM(SL) TONGSL
    FROM
      CTHD
      INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
      INNER JOIN SANPHAM AS SP ON CTHD.MASP = SP.MASP
    WHERE
      YEAR (NGHD) = '2006'
    GROUP BY
      SP.MASP,
      TENSP
  )
SELECT
  MASP,
  TENSP
FROM
  SLSP2006
WHERE
  TONGSL = (
    SELECT
      MIN(TONGSL)
    FROM
      SLSP2006
  );

-- 25. * Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
WITH
  NUOCGIACAO AS (
    SELECT
      NUOCSX,
      MAX(GIA) AS GIACAO
    FROM
      SANPHAM
    GROUP BY
      NUOCSX
  )
SELECT
  MASP,
  TENSP
FROM
  SANPHAM AS SP
  INNER JOIN NUOCGIACAO ON (
    SP.NUOCSX = NUOCGIACAO.NUOCSX
    AND SP.GIA = NUOCGIACAO.GIACAO
  );

-- 26. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
WITH
  NUOCGIAKHAC AS (
    SELECT
      NUOCSX,
      COUNT(DISTINCT GIA) AS GIAKHAC
    FROM
      SANPHAM
    GROUP BY
      NUOCSX
  )
SELECT
  NUOCSX
FROM
  NUOCGIAKHAC
WHERE
  GIAKHAC >= 3;

-- 27. * Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
WITH
  KHDSCAO AS (
    SELECT
      TOP (10) *
    FROM
      KHACHHANG
    ORDER BY
      DOANHSO DESC
  ),
  KHMUA AS (
    SELECT
      KH.MAKH,
      COUNT(SOHD) AS TONGSOHD
    FROM
      HOADON AS HD
      INNER JOIN KHACHHANG AS KH ON HD.MAKH = KH.MAKH
    GROUP BY
      KH.MAKH
  )
SELECT
  KHDSCAO.MAKH,
  KHDSCAO.HOTEN
FROM
  KHDSCAO
  INNER JOIN KHMUA ON KHDSCAO.MAKH = KHMUA.MAKH
WHERE
  TONGSOHD = (
    SELECT
      MAX(TONGSOHD)
    FROM
      KHMUA
  );
