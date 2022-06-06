/* BÀI 2: Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên 
   bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và 
   có tối đa 15 kí tự. */
SELECT * 
FROM nhan_vien
WHERE ho_ten like 'h%' OR 
	  ho_ten like 't%' OR
      ho_ten like 'k%' AND
      LENGTH(ho_ten) < 15;
  
  
/* BÀI 3: Hiển thị thông tin của tất cả khách hàng có độ tuổi 
   từ 18 đến 50 tuổi và có 
   địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”. */
SELECT *
FROM khach_hang
WHERE ((YEAR(NOW()) - YEAR(ngay_sinh)) BETWEEN 18 AND 50)
AND (dia_chi LIKE '%Quảng Trị' OR dia_chi LIKE '%Đà Nẵng');


/* BÀI 4: Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu
lần. Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt phòng của
khách hàng. Chỉ đếm những khách hàng nào có Tên loại khách hàng là
“Diamond”. */
SELECT khach_hang.ho_ten, COUNT(hop_dong.ma_khach_hang) AS 'Số lần đặt phòng'
FROM khach_hang
JOIN hop_dong ON hop_dong.ma_khach_hang = khach_hang.ma_khach_hang
JOIN loai_khach ON loai_khach.ma_loai_khach = khach_hang.ma_loai_khach
WHERE loai_khach.ten_loai_khach = 'Diamond'
GROUP BY hop_dong.ma_khach_hang
ORDER BY COUNT(hop_dong.ma_khach_hang);


/* BÀI 5: Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong,
ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien (Với
tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng *
Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem,
hop_dong_chi_tiet) cho tất cả các khách hàng đã từng đặt phòng. (những
khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra). */
SELECT k.ma_khach_hang, k.ho_ten, lk.ten_loai_khach, h.ma_hop_dong, 
	   d.ten_dich_vu, h.ngay_lam_hoat_dong, h.ngay_ket_thuc,
       SUM(d.chi_phi_thue + hop_dong_chi_tiet.so_luong * dich_vu_di_kem.gia) AS 'Tổng tiền'
FROM khach_hang k
LEFT JOIN loai_khach lk ON k.ma_loai_khach = lk.ma_loai_khach
LEFT JOIN hop_dong h ON h.ma_khach_hang = k.ma_khach_hang
LEFT JOIN dich_vu d ON h.ma_dich_vu = d.ma_dich_vu
LEFT JOIN hop_dong_chi_tiet ON hop_dong_chi_tiet.ma_hop_dong = h.ma_hop_dong
LEFT JOIN dich_vu_di_kem ON dich_vu_di_kem.ma_dich_vu_di_kem = hop_dong_chi_tiet.ma_dich_vu_di_kem
GROUP BY h.ma_hop_dong;


/* BÀI 6: Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue,
ten_loai_dich_vu của tất cả các loại dịch vụ chưa từng được khách hàng
thực hiện đặt từ quý 1 của năm 2021 (Quý 1 là tháng 1, 2, 3). */
SELECT d.ma_dich_vu, d.ten_dich_vu, d.dien_tich, d.chi_phi_thue, ld.ten_loai_dich_vu
FROM dich_vu d
JOIN loai_dich_vu ld ON d.ma_loai_dich_vu = ld.ma_loai_dich_vu
WHERE NOT EXISTS
(SELECT *
FROM hop_dong
WHERE (hop_dong.ngay_lam_hoat_dong BETWEEN '2021-1-1' AND '2021-3-31')
AND hop_dong.ma_dich_vu = d.ma_dich_vu);


/* BÀI 7: Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich,
so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu của tất cả các loại
dịch vụ đã từng được khách hàng đặt phòng trong năm 2020 nhưng
chưa từng được khách hàng đặt phòng trong năm 2021. */
SELECT d.ma_dich_vu, d.ten_dich_vu, d.dien_tich, d.so_nguoi_toi_da, d.chi_phi_thue, ld.ten_loai_dich_vu
FROM dich_vu d
JOIN loai_dich_vu ld ON d.ma_loai_dich_vu = ld.ma_loai_dich_vu
JOIN hop_dong ON hop_dong.ma_dich_vu = d.ma_dich_vu
WHERE YEAR(hop_dong.ngay_lam_hoat_dong) = 2020
AND NOT EXISTS
(SELECT *
FROM hop_dong
WHERE YEAR(hop_dong.ngay_lam_hoat_dong) = 2021
AND hop_dong.ma_dich_vu = d.ma_dich_vu)
GROUP BY d.ma_dich_vu;

 
/* BÀI 8: Hiển thị thông tin ho_ten khách hàng có trong hệ thống, với yêu cầu
ho_ten không trùng nhau. Học viên sử dụng theo 3 cách khác nhau để thực hiện yêu cầu trên. */

-- Cách 1: 
SELECT DISTINCT ho_ten
FROM khach_hang;

-- Cách 2:
SELECT ho_ten
FROM khach_hang
GROUP BY ho_ten;

-- Cách 3:
SELECT ho_ten
FROM khach_hang
UNION
SELECT ho_ten
FROM khach_hang;


/* BÀI 9: Thực hiện thống kê doanh thu theo tháng, nghĩa là tương ứng với mỗi
tháng trong năm 2021 thì sẽ có bao nhiêu khách hàng thực hiện đặt
phòng. */
SELECT tmp.month, contract_month.So_luong_khach_hang
FROM 
  ( SELECT 1 AS `month`
	UNION SELECT 2 AS `month`
	UNION SELECT 3 AS `month`
	UNION SELECT 4 AS `month`
	UNION SELECT 5 AS `month`
	UNION SELECT 6 AS `month`
	UNION SELECT 7 AS `month`
	UNION SELECT 8 AS `month`
	UNION SELECT 9 AS `month`
	UNION SELECT 10 AS `month`
	UNION SELECT 11 AS `month`
	UNION SELECT 12 AS `month`) 
AS tmp
LEFT JOIN
  ( SELECT MONTH(hop_dong.ngay_lam_hoat_dong) AS month, COUNT(hop_dong.ma_khach_hang) AS So_luong_khach_hang
	FROM hop_dong
    WHERE YEAR(hop_dong.ngay_lam_hoat_dong) = 2021
    GROUP BY month ) AS contract_month ON contract_month.month = tmp.month;
    
    
/* BÀI 10: Hiển thị thông tin tương ứng với từng hợp đồng thì đã sử dụng bao nhiêu
dịch vụ đi kèm. Kết quả hiển thị bao gồm ma_hop_dong,
ngay_lam_hop_dong, ngay_ket_thuc, tien_dat_coc,
so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở
dich_vu_di_kem). */
SELECT hop_dong.ma_hop_dong, hop_dong.ngay_lam_hoat_dong, hop_dong.ngay_ket_thuc, hop_dong.tien_dat_coc,
		COUNT(hop_dong_chi_tiet.ma_dich_vu_di_kem) AS 'Số lượng dịch vụ đi kèm'
FROM hop_dong
LEFT JOIN hop_dong_chi_tiet ON hop_dong.ma_hop_dong = hop_dong_chi_tiet.ma_hop_dong
GROUP BY hop_dong.ma_hop_dong;


/* BÀI 11: Hiển thị thông tin các dịch vụ đi kèm đã được sử dụng bởi những khách
hàng có ten_loai_khach là “Diamond” và có dia_chi ở “Vinh” hoặc
“Quảng Ngãi”. */
SELECT khach_hang.ho_ten, khach_hang.dia_chi,
	   loai_khach.ten_loai_khach,
	   dich_vu_di_kem.ma_dich_vu_di_kem, dich_vu_di_kem.ten_dich_vu_di_kem, dich_vu_di_kem.gia, dich_vu_di_kem.don_vi, dich_vu_di_kem.trang_thai
FROM dich_vu_di_kem
JOIN hop_dong_chi_tiet ON hop_dong_chi_tiet.ma_dich_vu_di_kem = dich_vu_di_kem.ma_dich_vu_di_kem
JOIN hop_dong ON hop_dong.ma_hop_dong = hop_dong_chi_tiet.ma_hop_dong
JOIN khach_hang ON hop_dong.ma_khach_hang = khach_hang.ma_khach_hang
JOIN loai_khach ON khach_hang.ma_loai_khach = loai_khach.ma_loai_khach
WHERE loai_khach.ten_loai_khach = 'Diamond'
AND (khach_hang.dia_chi LIKE '%Vinh' OR khach_hang.dia_chi LIKE '%Quãng Ngãi');


/* BÀI 12: Hiển thị thông tin ma_hop_dong, ho_ten (nhân viên), ho_ten (khách hàng), 
so_dien_thoai (khách hàng), ten_dich_vu,
so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở
dich_vu_di_kem), tien_dat_coc của tất cả các dịch vụ đã từng được
khách hàng đặt vào 3 tháng cuối năm 2020 nhưng chưa từng được
khách hàng đặt vào 6 tháng đầu năm 2021. */
SELECT hop_dong.ma_hop_dong, hop_dong.tien_dat_coc,
	   nhan_vien.ho_ten AS 'Tên Nhân Viên', 
       khach_hang.ho_ten 'Tên Khách Hàng', khach_hang.so_dien_thoai, 
       dich_vu.ten_dich_vu,
       COUNT(hop_dong_chi_tiet.ma_dich_vu_di_kem) AS 'Số lượng dịch vụ đi kèm'
FROM hop_dong
JOIN nhan_vien ON nhan_vien.ma_nhan_vien = hop_dong.ma_nhan_vien
JOIN khach_hang ON khach_hang.ma_khach_hang = hop_dong.ma_khach_hang
JOIN dich_vu ON dich_vu.ma_dich_vu = hop_dong.ma_dich_vu
JOIN hop_dong_chi_tiet ON hop_dong_chi_tiet.ma_hop_dong = hop_dong.ma_hop_dong
WHERE (hop_dong.ngay_lam_hoat_dong BETWEEN '2020-10-1' AND '2020-12-31')
AND (hop_dong.ngay_lam_hoat_dong NOT BETWEEN '2021-1-1' AND '2021-6-30');



/* BÀI 13: Hiển thị thông tin các Dịch vụ đi kèm được sử dụng nhiều nhất bởi các
Khách hàng đã đặt phòng. (Lưu ý là có thể có nhiều dịch vụ có số lần sử
dụng nhiều như nhau). */	
SELECT dich_vu_di_kem.ten_dich_vu_di_kem, MAX(temp.so_lan_dung) AS 'Số lượng dùng'
FROM dich_vu_di_kem
JOIN 
(SELECT hop_dong_chi_tiet.ma_dich_vu_di_kem, COUNT(hop_dong_chi_tiet.ma_dich_vu_di_kem) AS so_lan_dung 
 FROM hop_dong_chi_tiet
 GROUP BY hop_dong_chi_tiet.ma_dich_vu_di_kem) AS temp ON temp.ma_dich_vu_di_kem = dich_vu_di_kem.ma_dich_vu_di_kem;
 
 
 
 /* BÀI 14: Hiển thị thông tin tất cả các Dịch vụ đi kèm chỉ mới được sử dụng một
lần duy nhất. Thông tin hiển thị bao gồm ma_hop_dong,
ten_loai_dich_vu, ten_dich_vu_di_kem, so_lan_su_dung (được tính
dựa trên việc count các ma_dich_vu_di_kem). */
SELECT hop_dong.ma_hop_dong, 
	   loai_dich_vu.ten_loai_dich_vu,
       dich_vu_di_kem.ten_dich_vu_di_kem,
       COUNT(dich_vu_di_kem.ma_dich_vu_di_kem) AS So_lan_su_dung
FROM hop_dong
JOIN dich_vu ON dich_vu.ma_dich_vu = hop_dong.ma_dich_vu
JOIN loai_dich_vu ON loai_dich_vu.ma_loai_dich_vu = dich_vu.ma_loai_dich_vu
JOIN hop_dong_chi_tiet ON hop_dong_chi_tiet.ma_hop_dong = hop_dong.ma_hop_dong
JOIN dich_vu_di_kem ON dich_vu_di_kem.ma_dich_vu_di_kem = hop_dong_chi_tiet.ma_dich_vu_di_kem
GROUP BY dich_vu_di_kem.ma_dich_vu_di_kem
HAVING So_lan_su_dung = 1;


/* BÀI 15: Hiển thi thông tin của tất cả nhân viên bao gồm ma_nhan_vien, ho_ten,
ten_trinh_do, ten_bo_phan, so_dien_thoai, dia_chi mới chỉ lập được
tối đa 3 hợp đồng từ năm 2020 đến 2021. */
SELECT nhan_vien.ma_nhan_vien, nhan_vien.ho_ten, 
	   trinh_do.ten_trinh_do, 
       bo_phan.ten_bo_phan,
       nhan_vien.so_dien_thoai, nhan_vien.dia_chi
FROM nhan_vien
JOIN trinh_do ON trinh_do.ma_trinh_do = nhan_vien.ma_trinh_do
JOIN bo_phan ON bo_phan.ma_bo_phan = nhan_vien.ma_bo_phan
JOIN hop_dong ON hop_dong.ma_nhan_vien = nhan_vien.ma_nhan_vien
WHERE hop_dong.ngay_lam_hoat_dong BETWEEN '2020-1-1' AND '2021-12-31'
GROUP BY hop_dong.ma_nhan_vien
HAVING COUNT(hop_dong.ma_nhan_vien) <= 3;


/* BÀI 16: Xóa những Nhân viên chưa từng lập được hợp đồng nào từ năm 2019
đến năm 2021. */
DELETE FROM nhan_vien
WHERE NOT EXISTS
(SELECT nhan_vien.ma_nhan_vien
FROM hop_dong
WHERE hop_dong.ngay_lam_hoat_dong BETWEEN '2019-1-1' AND '2021-12-31' 
AND hop_dong.ma_nhan_vien = nhan_vien.ma_nhan_vien);


/* BÀI 17: Cập nhật thông tin những khách hàng có ten_loai_khach từ Platinum
lên Diamond, chỉ cập nhật những khách hàng đã từng đặt phòng với
Tổng Tiền thanh toán trong năm 2021 là lớn hơn 10.000.000 VNĐ. */
