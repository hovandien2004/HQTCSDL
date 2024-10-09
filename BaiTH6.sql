--a.Viết thủ tục dùng để hiển thị các thông tin  gồm oID, oDate, 
--oPrice của tất cả các hóa đơn trong bảng Order, danh sách phải sắp 
--xếp theo thứ tự ngày tháng
create proc sp_Order_SelectAll_DateDesc
as
	select *
	from [Order]
	order by [Order].oDate DESC
--loi goi
sp_Order_SelectAll_DateDesc
--b.Viết thủ tục dùng để hiển thị danh sách các khách hàng đã mua hàng
--, và danh sách sản phẩm được mua bởi các khách đó 
create proc sp_Customer_Product_selectall
as
select Customer.cID, Customer.cName, Product.pID, Product.pName
from Customer join [Order] on Customer.cID=[Order].cID
	join OrderDetail on [Order].oID=OrderDetail.oID
	join Product on OrderDetail.pID=Product.pID
--loi goi
sp_Customer_Product_selectall
--c.Viết thủ tục dùng để hiển thị tên những khách hàng không mua bất
--kỳ một sản phẩm nào 
--c1:left join
alter proc sp_khachhang_khongmua
as
	select Customer.cID, Customer.cName, oID
	from Customer left join [Order] on Customer.cID = [Order].cID
	where oID is NULL
--loi goi
sp_khachhang_khongmua
--c2: not in
create proc kh_khong_mua
as
	select c.cID, c.cName
	from Customer as c
	where c.cID not in(select distinct o.cID
					from [Order] as o)
-- loi goi
kh_khong_mua
--d.	Viết thủ tục dùng để hiển thị các mặt hàng chưa được mua lần nào.
--c1
create proc SelectByProductIsZero
as
	select Product.pID, Product.pName
	from Product left join OrderDetail on Product.pID = OrderDetail.pID
	where OrderDetail.pID is NULL
--loi goi
SelectByProductIsZero
--c2:
create proc D
as
	 select Product.pID, Product.pName 
	 from Product
	 where Product.pID not in ( Select distinct pID from OrderDetail)
 --loi goi
 D
 --e.Viết thủ tục với tham số truyền vào là tháng, năm. Thủ tục dùng để hiển 
 --thị các hóa đơn được lập và số tiền bán được trong tháng, năm truyền vào.
 create proc bh_Order_thang_nam
      @Month int,
	  @Year int
as
    select [Order].oID, oDate, sum(odQTY*pPrice) as oTotalPrice
	from [Order] inner join OrderDetail 
	on [Order].oID = OrderDetail.oID inner join
	Product on OrderDetail.pID = Product.pID
	WHere Month(oDate)=@Month
	and Year(oDate)=@Year
	Group by [Order].oID, oDate
--loigoi
bh_Order_thang_nam 3,2006
--f.Viết thủ tục với tham số truyền vào là năm. Thủ tục dùng để hiển thị 
--doanh thu của mỗi tháng trong năm truyền vào
create proc SelectOrderYear
	@nam int
 as
	 select month(o.oDate) as 'thang' , sum(od.odQTY * p.pPrice)  'Tongtien'
	 from [Order] o inner join OrderDetail od on o.oID = od.oID
	 inner join Product p on od.pID = p.pID
	 where YEAR(o.oDate) = @nam
	 group by MONTH(o.oDate)
--loi goi
 SelectOrderYear 2006
 --g.Viết thủ tục dùng để thêm mới một sản phẩm. Thủ tục có các tham số là các
 --thông tin của sản phẩm và một tham số @ketqua sẽ trả về chuỗi rỗng nếu thêm
 --mới sản phẩm thành công, ngược lại tham số này trả về chuỗi cho biết lý do 
 --không thêm mới được.
 create proc cau_g
	@pID int, 
	@pName nvarchar(25), 
	@pPrice int, 
	@ketqua nvarchar(50) output
 as
	if exists(select pID from Product where pID = @pID)
		set @ketqua = 'da ton tai san pham'
	else 
		begin
			insert into Product values(@pID, @pName,@pPrice)
			if @@ERROR <> 0
				set @ketqua = 'loi cap nhap du lieu'
			else 
				set @ketqua = ''
		end
--loi goi
declare @ketqua nvarchar(50)
execute cau_g 7,'maytinh',90, @ketqua output
select @ketqua
--h.Viết thủ tục dùng để cập nhật một sản phẩm. Thủ tục có các tham số là các
--thông tin của sản phẩm và một tham số @ketqua sẽ trả về chuỗi rỗng nếu Cập 
--nhật sản phẩm thành công, ngược lại tham số này trả về chuỗi cho biết lý do
--không cập nhật được.
alter proc sp_cap_nhat
	@pID int,
	@pName nvarchar(25),
	@pPrice int,
	@ketqua nvarchar(255) output
as 
	if not exists ( select pID from Product where pID= @pID)
		set @ketqua=N'Da ton tai san pham nay'
	else 
		begin
			update Product
			set pName=@pName,
				pPrice = @pPrice
			where pID = @pID
			if @@ERROR<>0 
				set @ketqua = N'Loi cap nhat du lieu'
			else 
				set @ketqua = N'Cap nhat thanh cong'
		end 
--loi goi
declare @ketqua nvarchar(50)
execute sp_cap_nhat 7,'maytinh',49, @ketqua output
select @ketqua
--i.	Viết thủ tục dùng để xóa một sản phẩm. Thủ tục có các tham số là mã của sản phẩm và một tham số @ketqua sẽ trả về chuỗi rỗng nếu xóa sản phẩm thành công, ngược lại tham số này trả về chuỗi cho biết lý do không xóa sản phẩm được.
alter proc sp_xoasp
	@pID int,
	@ketqua nvarchar(200) output
as 
	if not exists ( select pID from Product where pID= @pID)
		set @ketqua=N'Da ton tai san pham nay'
	else 
		begin
			delete from Product
			where pID = @pID
			if @@ERROR<>0 
				set @ketqua = N'Loi xoa du lieu'
			else 
				set @ketqua = N'Xoa thanh cong'
		end 
--loi goi
declare @ketqua nvarchar(50)
execute sp_xoasp 7, @ketqua output
select @ketqua

--j.Viết thủ tục dùng để hiển thị các khách hàng đã đến mua bao nhiêu lần.
create proc sp_Count
as 
BEGIN
    SELECT c.cID, c.cName, COUNT(o.oID) AS PurchaseCount
    FROM Customer c
    LEFT JOIN [Order] o ON c.cID = o.cID
    GROUP BY c.cID, c.cName
END

sp_Count
--k. Viết thủ tục dùng để hiển thị chi tiết của từng hóa đơn như sau :
create proc sp_HienThi_HoaDon
as
	begin
		select od.oID, o.oDate, odqty, pname, pPrice
		from [Order] o inner join OrderDetail od on o.oID = od.oID
					inner join Product p on od.pID = p.pID
	end
sp_HienThi_HoaDon

--l.Viết thủ tục dùng để hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một
--hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá
--bán của từng loại được tính = odQTY*pPrice) như sau:
create proc sp_HienThi_TinhHoaDon
as
begin
	select od.oID, o.oDate, sum(odqty*pPrice) as Total
	from [Order] o inner join OrderDetail od on o.oID = od.oID
					inner join Product p on od.pID = p.pID
	group by od.oID, o.oDate
end
sp_HienThi_TinhHoaDon

--m.Viết thủ tục dùng để hiển thị tên và giá của các sản phẩm có giá cao nhất như sau:
create proc sp_Max_price_product
as
begin
    SELECT p.pID, p.pName, p.pPrice
    FROM Product p
    WHERE p.pPrice = (SELECT MAX(pPrice) 
						FROM Product)
end
sp_Max_price_product

--n.Viết thủ tục với tham số truyền vào là số tiền. Thủ tục dùng để hiển thị những hóa đơn có
--tổng thành tiền trên số tiền truyền vào.
create proc sp_Tien
	@tien int
as
begin
	select o.oID, sum(odqty*pPrice) as tongtien
	from [Order] o inner join OrderDetail od on o.oID = od.oID
					inner join Product p on od.pID = p.pID
	group by o.oID
	having sum(odqty*pPrice) > @tien
end
sp_Tien 30

--o.Viết thủ tục dùng để hiển thị những hóa đơn có tổng thành tiền là cao nhất.
create proc sp_Max_TongThanhTien
as
begin
    select o.oID, sum(odqty*pPrice) as tongtien
	from [Order] o inner join OrderDetail od on o.oID = od.oID
					inner join Product p on od.pID = p.pID
	group by o.oID
    having sum(odqty*pPrice) = (SELECT MAX(sum(pPrice*odQTY)) 
								FROM [Order] o inner join OrderDetail od on o.oID = od.oID
												inner join Product p on od.pID = p.pID
								group by o.oID
						)
end
--o.
CREATE PROCEDURE sp_Max_TongThanhTien1
AS
BEGIN
    SELECT o.oID, SUM(od.odQTY * p.pPrice) AS TotalPrice
    FROM [Order] o
    JOIN OrderDetail od ON o.oID = od.oID
    JOIN Product p ON od.pID = p.pID
    GROUP BY o.oID
    HAVING SUM(od.odQTY * p.pPrice) = (
        SELECT MAX(TotalPrice)
        FROM (SELECT SUM(od.odQTY * p.pPrice) AS TotalPrice
              FROM [Order] o
              JOIN OrderDetail od ON o.oID = od.oID
              JOIN Product p ON od.pID = p.pID
              GROUP BY o.oID) AS subquery
    )
END
sp_Max_TongThanhTien1

--p.Viết thủ tục dùng để hiển thị ra các khách hàng tới mua hàng với số lần họ đã tới mua
--hàng. Nếu khách hàng nào chưa mua hàng lần nào thì số lần họ tới mua là 0.
create proc sp_SoLanMuaHang
as
begin
    select c.cID, c.cName, COUNT(o.oID) AS solanmuahang
    from Customer c
    LEFT JOIN [Order] o ON c.cID = o.cID
    group by c.cID, c.cName
end
sp_SoLanMuaHang
--q.Viết thủ tục với tham số truyền vào là @nam. Thủ tục dùng để thống kê mỗi tháng trong
--năm truyền vào có tổng doanh thu là bao nhiêu. (Nếu tháng nào không hoạt động thì ghi
--tổng doanh thu là 0).
create proc sp_DoanhThu_Thang
    @nam int
as
begin
    select MONTH(o.oDate) AS Month,
           ISNULL(SUM(od.odQTY * p.pPrice), 0) AS TotalRevenue
    from [Order] o
    LEFT JOIN OrderDetail od ON o.oID = od.oID
    LEFT JOIN Product p ON od.pID = p.pID
    where YEAR(o.oDate) = @nam
    group by MONTH(o.oDate)
    order by Month
END
sp_DoanhThu_Thang 2006 