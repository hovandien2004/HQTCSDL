--Bài 1:
declare @a float, @b float, @c float, @x1 float, @x2 float
set @a = 1
set @b = 5
set @c = 2
if @a = 0
	begin
		if @b = 0
			begin
				if @c = 0
					print 'Phuong trinh vo so nghiem'
				else 
					print 'Phuong trinh vo nghiem'
			end
		else
			print 'Phuong trinh co 1 nghiem duy nhat: x= ' + cast(-@c/@b as nvarchar)
	end
else
	begin
		declare @delta float
		set @delta = @b*@b - 4*@a*@c
		if @delta > 0
			begin
				set @x1 = (-@b+sqrt(@delta))/(2*@a)
				set @x2 = (-@b-sqrt(@delta))/(2*@a)
				print 'Phuong trinh co 2 nghiem phan biet: x1 = ' +  cast(@x1 as nvarchar) + ', x2 = ' + cast(@x2 as nvarchar)
			end
		else
			if @delta = 0
				print 'Phuong trinh co nghiem kep: x1 = x2 = ' + cast(-@b/2*@a as nvarchar) 
			else
				print 'phuong trinh vo nghiem'
	end

--Bài 2:
declare @n int, @tc int = 0, @tl int = 0, @m int
set @n = 5
set @m = @n
while @n > 0
	begin
		if @n%2 = 0
			set @tc = @tc + @n
		else 
			set @tl = @tl + @n
		set @n = @n - 1
	end
	print 'Tong le nho hon ' + cast(@m as nvarchar) + ': ' + cast(@tl as nvarchar)
	print 'Tong chan nho hon ' + cast(@m as nvarchar) + ': ' + cast(@tc as nvarchar)

--Bài 3:
declare @t float = 0, @nn int = 5, @x int = 2
while @nn > 0
begin
	set @t = sqrt(@x + @t)
	set @nn = @nn - 1
end
print 'S = ' + cast(@t as nvarchar)