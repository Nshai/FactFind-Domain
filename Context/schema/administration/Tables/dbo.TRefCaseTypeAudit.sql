CREATE TABLE [dbo].[TRefCaseTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CaseTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCaseTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefCaseTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCaseTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCaseTypeAudit] ADD CONSTRAINT [PK_TRefCaseTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
