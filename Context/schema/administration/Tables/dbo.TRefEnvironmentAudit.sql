CREATE TABLE [dbo].[TRefEnvironmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEnvironmentAudit_ConcurrencyId] DEFAULT ((1)),
[RefEnvironmentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefEnvironmentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEnvironmentAudit] ADD CONSTRAINT [PK_TRefEnvironmentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
