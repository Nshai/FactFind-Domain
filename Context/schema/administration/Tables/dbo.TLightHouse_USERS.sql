CREATE TABLE [dbo].[TLightHouse_USERS]
(
[UserId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Password] [varchar] (24) COLLATE Latin1_General_CI_AS NOT NULL,
[PasswordHistory] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Email] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Telephone] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GroupId] [int] NOT NULL,
[SyncPassword] [bit] NULL,
[ExpirePasswordOn] [datetime] NULL,
[SuperUser] [bit] NOT NULL,
[SuperViewer] [bit] NOT NULL,
[FailedAccessAttempts] [tinyint] NOT NULL,
[WelcomePage] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Reference] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NULL,
[SearchData] [text] COLLATE Latin1_General_CI_AS NULL,
[RecentData] [text] COLLATE Latin1_General_CI_AS NULL,
[RecentWork] [text] COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NULL,
[SupportUserFg] [bit] NOT NULL,
[ActiveRole] [int] NULL,
[CanLogCases] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
