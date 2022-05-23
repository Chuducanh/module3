USE QuanLyBanHang;

ALTER TABLE Orderr MODIFY oTotalPrice FLOAT;

-- THÊM DỮ LIỆU VÀO TABLE --
INSERT INTO Customer
VALUES (1, 'Minh Quan', 10),
	   (2, 'Ngoc Oanh', 20),
       (3, 'Hong Ha', 50);
       
INSERT INTO Orderr(cID, oDate)
VALUES (1, '2006-3-21'),
	   (2, '2006-3-23'),
       (1, '2006-3-16');
       
INSERT INTO Product(pName, pPrice)
VALUES ('may giat', 3),
	   ('Tu Lanh', 5),
       ('Dieu Hoa', 7),
       ('Quat', 1),
       ('Bep dien', 2);
       
INSERT into OrderDetail
VALUES (1,1,3),
	   (1,3,7),
       (1,4,2),
       (2,1,1),
       (3,1,8),
       (2,5,4),
       (2,3,3);

-- HIỂN THỊ THÔNG TIN --

-- hiển thị danh sách Order --
SELECT oID, oDate, ototalPrice
FROM Orderr;


-- hiển thị danh sách tên những người đã mua hàng và sản phẩm đã mua --
SELECT cName, pName
FROM Customer 
INNER JOIN Orderr ON Customer.cID = Orderr.cid
INNER JOIN OrderDetail ON Orderr.oID = orderdetail.oID
INNER JOIN Product ON OrderDetail.pID = product.pID;


-- hiển thị danh sách tên những người không mua hàng --
SELECT * 
FROM Customer 
WHERE NOT EXISTS (SELECT * from orderr WHERE Orderr.cid = customer.cid);

/* hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn 
(giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice) */
SELECT Orderr.oID, Orderr.oDate, SUM(Product.pPrice* OrderDetail.odQTY) AS total_price 
FROM Orderr
INNER JOIN OrderDetail ON Orderr.oiD= OrderDetail.oid
INNER JoIN Product ON Product.pID= orderDetail.pID
GROUP BY Orderr.oId; 