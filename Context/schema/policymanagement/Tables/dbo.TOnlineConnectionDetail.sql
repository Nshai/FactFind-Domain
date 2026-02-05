CREATE TABLE [dbo].[TOnlineConnectionDetail]
(
[OnlineConnectionDetailId] [int] NOT NULL IDENTITY(1, 1),
[ConnectionName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Url] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Async] [bit] NULL,
[Timeout] [int] NULL,
[Username] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[MessagePrefix] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MessageSuffix] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UrlEncode] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
