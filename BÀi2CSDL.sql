--Viết thủ tục để lấy ra danh sách khách hàng
create procedure sp_khachHang_SelectAll
As
	begin
		select * 
		from tbl_KhachHang
	end
-- Lời gọi
sp_khachHang_SelectAll

--Viết thủ tục với tham số truyền vào là giới tính. Thủ tục dùng để lấy ra các khách khách hàng có giới tính cùng với giới tính truyền vào
create proc sp_KhachHang_Select_GT
	@GT bit
as
	select *
	from tbl_KhachHang
	where GT = @GT

-- Lời gọi
sp_KhachHang_Select_GT 1
sp_KhachHang_Select_GT 0

--Viết thủ tục với tham số truyền vào là họ. THủ tục dùng để lấy ra ds KH có họ giống với họ truyền vào
create proc sp_KhachHang_Select_Ho
	@HO nvarchar(50)
as
	select *
	from tbl_KhachHang
	where TenKH like N''+@HO+'%'
--Lời gọi
sp_KhachHang_Select_Ho N'Lê'

--Viết thủ tục với tham số truyền vào là tháng, năm. Thủ tục dùng để lấy ra các hóa đơn được lập trong tháng, năm truyền vào. DS gồm có MaHD, NgayLap, TongTien(=sl bán*dongia)
create proc sp_HoaDon_Select_Thang_Nam
	@thang int, 
	@Nam int
as
	select tbl_HoaDon.MaHD, NgayLap, sum(SL*DonGia) as TongTien
	from tbl_HoaDon inner join tbl_CTHD on tbl_HoaDon.MaHD = tbl_CTHD.MaHD
	where MONTH(NgayLap) = @thang
	and YEAR(NgayLap) = @Nam
	group by tbl_HoaDon.MaHD, NgayLap

sp_HoaDon_Select_Thang_Nam 2,2022

--Viết thủ tục với tham số tổng tiền. thủ tục dùng để lấy ra các hóa đơn có tổng tiền lớn hơn tổng tiền truyên vào.
create proc sp_HoaDon_ThongKe_TongTien
	@TongTien int
as
	select tbl_HoaDon.MaHD, NgayLap, sum(SL*DonGia) as TongTien
	from tbl_HoaDon inner join tbl_CTHD on tbl_HoaDon.MaHD = tbl_CTHD.MaHD
	group by tbl_HoaDon.MaHD, NgayLap
	having sum(SL*DonGia) > @TongTien
--Lời gọi
sp_HoaDon_ThongKe_TongTien 105

--Viết thủ tục dùng để thêm mới 1 mặt hàng. với các thông số thêm mới của mặt hàng chính là tham số truyền vào
create proc sp_Hang_Insert
	@MaHang int,
	@TenHang nvarchar(50),
	@SL int,
	@DonGia int,
	@NhaSX nvarchar(50),
	@NgaySx date
as 
	insert into tbl_Hang
	values(@MaHang, @TenHang,@SL,@DonGia,@NhaSX,@NgaySx)

--Lời gọi
sp_Hang_Insert 8, N'Loa', 5, 25, N'SoundMax', '2022-2-2'

--Viết thủ tục dùng để cập nhật 1 mặt hàng. Với các thông số cập nhật của mặt hàng chính là tham số truyền vào và một tham số @Ketqua dể cho biết cập nhật thành công hay khong
create proc sp_Hang_Update
	@MaHang int,
	@TenHang nvarchar(50),
	@SL int,
	@DonGia int,
	@NhaSX nvarchar(50),
	@NgaySx date,
	@KetQua nvarchar(255) output
as
	if (not exists (select * from tbl_Hang where MaHang = @MaHang))
		set @KetQua = N'Mã mặt hàng này không tồn tại!'
	else
	begin
		begin try
			update tbl_Hang
			set TenHang = @TenHang,
				SL = @SL,
				DonGia = @DonGia,
				NhaSX = @NhaSX,
				NgaySX = @NgaySx
			where MaHang = @MaHang
			if @@ERROR <> 0
				set @KetQua = N'Lỗi cập nhật dữ liệu'
			else 
				set @KetQua = N'Cập nhật thành công'
		end try
		begin catch
			set @KetQua = N'Lỗi cập nhật dữ liệu!!!'
		end catch
	end
--Lời gọi
declare @kq nvarchar(255)
execute sp_Hang_Update 9, N'Loa', 5, 25, N'SoundMax', '2022-2-2', @kq output
select @kq

--Viết thủ tục với tham số truyền vào là tháng, năm và tham số trả về @SoMatHang. Thủ tục dùng trả về số các mặt hàng đã bán được trong tháng, năm truyền vào
create proc sp_Hang_SelectHangBan_ThangBan
	@thang int, 
	@Nam int, 
	@SoMatHang int output
as
	select tbl_Hang.MaHang, TenHang, tbl_CTHD.SL as SlBan, tbl_CTHD.DonGia as DonGiaBan
	from tbl_Hang inner join tbl_CTHD on tbl_Hang.MaHang = tbl_CTHD.MaHang inner join tbl_HoaDon
									  on tbl_HoaDon.MaHD = tbl_CTHD.MaHD
	where MONTH(NgayLap) = @thang
		and Year(NgayLap) = @Nam
	set @SoMatHang = @@ROWCOUNT
--lời gọi
declare @so int
execute sp_Hang_SelectHangBan_ThangBan 2,2022,@so output
select @so

--Viết thủ tục với tham số truyền vào là năm. thủ tục dùng để thống kê mỗi tháng trong năm truyền vào có doanh thu là bao nhiêu
create proc sp_HoaDon_ThongKeTHang_Nam
	@nam int
as
	select MONTH(NgayLap) as Thang, sum(SL*DonGia) as DoanhThu
	from tbl_HoaDon inner join tbl_CTHD on tbl_HoaDon.MaHD = tbl_CTHD.MaHD
	where YEAR(NgayLap) = @nam
	group by MONTH(NgayLap)
--lời gọi
sp_HoaDon_ThongKeTHang_Nam 2022