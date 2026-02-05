CREATE TABLE [dbo].[THoliday]
(
[HolidayId] [int] NOT NULL IDENTITY(1, 1),
[HolidayDate] [date] NOT NULL,
[HolidayName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[THoliday] ADD CONSTRAINT [PK_THoliday] PRIMARY KEY CLUSTERED  ([HolidayId])
GO
