CREATE TABLE [dbo].[TExWebAccountAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ExWebUserId] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ExWebPassword] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExWebAccountAudit_ConcurrencyId] DEFAULT ((1)),
[ExWebAccountId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExWebAccountAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TExWebAccountAudit] ADD CONSTRAINT [PK_TExWebAccountAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
