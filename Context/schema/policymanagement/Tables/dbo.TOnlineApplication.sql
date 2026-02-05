CREATE TABLE [dbo].[TOnlineApplication]
(
[OnlineApplicationId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NULL,
[OnlineProductId] [int] NULL,
[OnlineApplicationStatusId] [int] NULL,
[SavedXml] [text] COLLATE Latin1_General_CI_AS NULL,
[SavedDate] [datetime] NULL,
[RequestXml] [text] COLLATE Latin1_General_CI_AS NULL,
[RequestDate] [datetime] NULL,
[ResponseXml] [text] COLLATE Latin1_General_CI_AS NULL,
[ResponseDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
