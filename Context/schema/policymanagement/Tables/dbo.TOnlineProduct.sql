CREATE TABLE [dbo].[TOnlineProduct]
(
[OnlineProductId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PacId] [int] NULL,
[OnlineConnectionDetailId] [int] NULL,
[ConcurrencyId] [int] NULL
)
GO
