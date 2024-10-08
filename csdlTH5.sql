USE [master]
GO
/****** Object:  Database [StudentTest]    Script Date: 9/19/2024 10:24:27 PM ******/
CREATE DATABASE [StudentTest]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'StudentTest', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\StudentTest.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'StudentTest_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\StudentTest_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [StudentTest] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StudentTest].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [StudentTest] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [StudentTest] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [StudentTest] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [StudentTest] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [StudentTest] SET ARITHABORT OFF 
GO
ALTER DATABASE [StudentTest] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [StudentTest] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [StudentTest] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [StudentTest] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [StudentTest] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [StudentTest] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [StudentTest] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [StudentTest] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [StudentTest] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [StudentTest] SET  DISABLE_BROKER 
GO
ALTER DATABASE [StudentTest] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [StudentTest] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [StudentTest] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [StudentTest] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [StudentTest] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [StudentTest] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [StudentTest] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [StudentTest] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [StudentTest] SET  MULTI_USER 
GO
ALTER DATABASE [StudentTest] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [StudentTest] SET DB_CHAINING OFF 
GO
ALTER DATABASE [StudentTest] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [StudentTest] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [StudentTest] SET DELAYED_DURABILITY = DISABLED 
GO
USE [StudentTest]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 9/19/2024 10:24:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Student](
	[RN] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Age] [tinyint] NULL,
	[Status] [varchar](10) NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[RN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StudentTest]    Script Date: 9/19/2024 10:24:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentTest](
	[RN] [int] NULL,
	[TestID] [int] NULL,
	[Date] [datetime] NULL,
	[Mark] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Test]    Script Date: 9/19/2024 10:24:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Test](
	[TestID] [int] NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_Test] PRIMARY KEY CLUSTERED 
(
	[TestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Student] ([RN], [Name], [Age], [Status]) VALUES (1, N'Nguyen Hong Ha', 21, NULL)
INSERT [dbo].[Student] ([RN], [Name], [Age], [Status]) VALUES (2, N'Truong Ngoc Anh', 31, NULL)
INSERT [dbo].[Student] ([RN], [Name], [Age], [Status]) VALUES (3, N'Tuan Minh', 26, NULL)
INSERT [dbo].[Student] ([RN], [Name], [Age], [Status]) VALUES (4, N'Dan Truong', 23, NULL)
INSERT [dbo].[StudentTest] ([RN], [TestID], [Date], [Mark]) VALUES (1, 1, CAST(N'2006-07-17 00:00:00.000' AS DateTime), 8)
INSERT [dbo].[StudentTest] ([RN], [TestID], [Date], [Mark]) VALUES (1, 2, CAST(N'2006-07-18 00:00:00.000' AS DateTime), 5)
INSERT [dbo].[StudentTest] ([RN], [TestID], [Date], [Mark]) VALUES (1, 3, CAST(N'2006-07-19 00:00:00.000' AS DateTime), 7)
INSERT [dbo].[StudentTest] ([RN], [TestID], [Date], [Mark]) VALUES (2, 1, CAST(N'2006-07-17 00:00:00.000' AS DateTime), 7)
INSERT [dbo].[StudentTest] ([RN], [TestID], [Date], [Mark]) VALUES (2, 2, CAST(N'2006-07-18 00:00:00.000' AS DateTime), 4)
INSERT [dbo].[StudentTest] ([RN], [TestID], [Date], [Mark]) VALUES (2, 3, CAST(N'2006-07-19 00:00:00.000' AS DateTime), 2)
INSERT [dbo].[StudentTest] ([RN], [TestID], [Date], [Mark]) VALUES (3, 1, CAST(N'2006-07-17 00:00:00.000' AS DateTime), 10)
INSERT [dbo].[StudentTest] ([RN], [TestID], [Date], [Mark]) VALUES (3, 3, CAST(N'2006-07-18 00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Test] ([TestID], [Name]) VALUES (1, N'EPC')
INSERT [dbo].[Test] ([TestID], [Name]) VALUES (2, N'DWMX')
INSERT [dbo].[Test] ([TestID], [Name]) VALUES (3, N'SQL1')
INSERT [dbo].[Test] ([TestID], [Name]) VALUES (4, N'SQL2')
ALTER TABLE [dbo].[StudentTest]  WITH CHECK ADD  CONSTRAINT [FK_StudentTest_Student] FOREIGN KEY([RN])
REFERENCES [dbo].[Student] ([RN])
GO
ALTER TABLE [dbo].[StudentTest] CHECK CONSTRAINT [FK_StudentTest_Student]
GO
ALTER TABLE [dbo].[StudentTest]  WITH CHECK ADD  CONSTRAINT [FK_StudentTest_Test] FOREIGN KEY([TestID])
REFERENCES [dbo].[Test] ([TestID])
GO
ALTER TABLE [dbo].[StudentTest] CHECK CONSTRAINT [FK_StudentTest_Test]
GO
USE [master]
GO
ALTER DATABASE [StudentTest] SET  READ_WRITE 
GO
