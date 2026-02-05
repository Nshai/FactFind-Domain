CREATE TABLE [dbo].[TUserSessionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[SessionId] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[DelegateId] [int] NULL,
[DelegateSessionId] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Sequence] [int] NOT NULL CONSTRAINT [DF_TUserSessionAudit_Sequence] DEFAULT ((0)),
[IP] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[LastAccess] [datetime] NULL,
[Search] [text] COLLATE Latin1_General_CI_AS NULL,
[Recent] [text] COLLATE Latin1_General_CI_AS NULL,
[RecentWork] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserSessionAudit_ConcurrencyId] DEFAULT ((1)),
[UserSessionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TUserSessionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserSessionAudit] ADD CONSTRAINT [PK_TUserSessionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=90)
GO
