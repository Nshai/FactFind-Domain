CREATE TABLE [dbo].[TUserHashAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[HashValue] [char] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserHashAudit_ConcurrencyId] DEFAULT ((1)),
[UserHashId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TUserHashAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserHashAudit] ADD CONSTRAINT [PK_TUserHashAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TUserHashAudit_UserHashId_ConcurrencyId] ON [dbo].[TUserHashAudit] ([UserHashId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
