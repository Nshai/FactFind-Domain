CREATE TABLE [dbo].[TOnlineApplicationStatus]
(
[OnlineApplicationStatusId] [int] NOT NULL IDENTITY(1, 1),
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
