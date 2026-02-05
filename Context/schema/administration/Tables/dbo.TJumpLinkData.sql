CREATE TABLE [dbo].[TJumpLinkData]
(
[JumpLinkDataId] [uniqueidentifier] NOT NULL,
[TenantId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[Type] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedTime] [datetime] NOT NULL CONSTRAINT [DF_TJumpLinkData_CreatedTime]  DEFAULT (getdate()),
[ExpiryTime] [datetime] NULL,
[RedirectURI] [nvarchar] (4000) NULL
)
GO
