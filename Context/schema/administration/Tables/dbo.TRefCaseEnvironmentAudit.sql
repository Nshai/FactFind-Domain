CREATE TABLE [dbo].[TRefCaseEnvironmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CaseEnvironmentName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCaseEnvironmentAudit_ConcurrencyId] DEFAULT ((1)),
[RefCaseEnvironmentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCaseEnvironmentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCaseEnvironmentAudit] ADD CONSTRAINT [PK_TRefCaseEnvironmentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
