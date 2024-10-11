-- 1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN ADD GHICHU VARCHAR(20);

ALTER TABLE HOCVIEN ADD DIEMTB TINYINT;

ALTER TABLE HOCVIEN ADD XEPLOAI CHAR(2);

-- 2. Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”
ALTER TABLE HOCVIEN ADD CONSTRAINT CHK_MAHV CHECK (MAHV LIKE MALOP + "%");

-- 3. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE HOCVIEN ADD CONSTRAINT CHK_HOCVIEN_GIOITINH CHECK (GIOITINH in ("Nam", "Nu"));

ALTER TABLE GIAOVIEN ADD CONSTRAINT CHK_GIAOVIEN_GIOITINH CHECK (GIOITINH in ("Nam", "Nu"));

-- 4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_DIEM CHECK (DIEM BETWEEN 0 AND 10);

-- 5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_KQUA CHECK (
  DIEM >= 5
  AND KQUA = "Dat"
  OR DIEM < 5
  AND KQUA = "Khong dat"
);

-- 6. Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_LANTHI CHECK (LANTHI BETWEEN 1 AND 3);

-- 7. Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY ADD CONSTRAINT CHK_HOCKY CHECK (HOCKY BETWEEN 1 AND 3);
