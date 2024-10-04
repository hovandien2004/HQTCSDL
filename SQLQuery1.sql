--Viết thủ tục dùng để hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn
--trong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm
--trên như hình sau:
create proc sp_hienthi
as
select *
from [order] 
order by [order].oDate desc
--loi goi
sp_hienthi

--Viết thủ tục dùng để hiển thị các mặt hàng chưa được mua lần nào.
alter proc sp_haha
as
	select *
	from product
	where pid not in (select distinct pid
						from orderdetail
						)
sp_haha

--Viết thủ tục với tham số truyền vào là tháng, năm. Thủ tục dùng để hiển thị các hóa đơn
--được lập và số tiền bán được trong tháng, năm truyền vào.
alter proc sp_Order_thang_nam
    @thang int,
    @nam int
AS
BEGIN
    SELECT o.oID, oDate, SUM(od.odQTY * p.pPrice) AS tongtien
    FROM [Order] o
    JOIN OrderDetail od ON o.oID = od.oID
    JOIN Product p ON od.pID = p.pID
    WHERE MONTH(o.oDate) = @thang 
		AND YEAR(o.oDate) = @nam
    GROUP BY o.oID, oDate;
END
--loi goi
sp_Order_thang_nam 3,2006

--Viết thủ tục với tham số truyền vào là năm. Thủ tục dùng để hiển thị doanh thu của mỗi
--tháng trong năm truyền vào
create proc sp_select_doanhthu
    @nam int
AS
BEGIN
    SELECT MONTH(o.oDate) AS Thang, SUM(od.odQTY * p.pPrice) AS doanhthu
    FROM [Order] o
    JOIN OrderDetail od ON o.oID = od.oID
    JOIN Product p ON od.pID = p.pID
    WHERE YEAR(o.oDate) = @nam
    GROUP BY MONTH(o.oDate)
END
sp_select_doanhthu 2006

--Viết thủ tục dùng để thêm mới một sản phẩm. Thủ tục có các tham số là các thông tin của
--sản phẩm và một tham số @ketqua sẽ trả về chuỗi rỗng nếu thêm mới sản phẩm thành
--công, ngược lại tham số này trả về chuỗi cho biết lý do không thêm mới được.
create proc sp_add_Sanpham
    @pID INT,
    @pName NVARCHAR(100),
    @pPrice int,
    @ketqua NVARCHAR(255) OUTPUT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Product (pID, pName, pPrice) VALUES (@pID, @pName, @pPrice);
        SET @ketqua = '';
    END TRY
    BEGIN CATCH
        SET @ketqua = ERROR_MESSAGE();
    END CATCH
END

declare @kq nvarchar(255)
execute sp_add_Sanpham 7, N'May AO', 6, @kq output
select @kq

--h

CREATE PROCEDURE sp_update
    @pID INT,
    @pName NVARCHAR(100),
    @pPrice int,
    @ketqua NVARCHAR(255) OUTPUT
AS
BEGIN
    BEGIN TRY
        UPDATE Product
        SET pName = @pName, pPrice = @pPrice
        WHERE pID = @pID;
        SET @ketqua = '';
    END TRY
    BEGIN CATCH
        SET @ketqua = ERROR_MESSAGE();
    END CATCH
END

--
declare @kq nvarchar(255)
execute sp_update 7, N'May AO', 9, @kq output
select @kq

--Viết thủ tục dùng để xóa một sản phẩm. Thủ tục có các tham số là mã của sản phẩm và một tham số @ketqua sẽ trả về
-- chuỗi rỗng nếu xóa sản phẩm thành công, ngược lại tham số này trả về chuỗi cho biết lý do không xóa sản phẩm được.


CREATE PROCEDURE DeleteProduct
    @pID INT,
    @ketqua NVARCHAR(255) OUTPUT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Product WHERE pID = @pID;
        SET @ketqua = '';
    END TRY
    BEGIN CATCH
        SET @ketqua = ERROR_MESSAGE();
    END CATCH
END
declare @kq nvarchar(255)
execute DeleteProduct 7, @kq output
select @kq

--
CREATE PROCEDURE ShowCustomerPurchaseCount
AS
BEGIN
    SELECT c.cID, c.cName, COUNT(o.oID) AS PurchaseCount
    FROM Customer c
    LEFT JOIN [Order] o ON c.cID = o.cID
    GROUP BY c.cID, c.cName;
END