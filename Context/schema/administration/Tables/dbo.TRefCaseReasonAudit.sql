CREATE TABLE [dbo].[TRefCaseReasonAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CaseReasonName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCaseReasonAudit_ConcurrencyId] DEFAULT ((1)),
[RefCaseReasonId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCaseReasonAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCaseReasonAudit] ADD CONSTRAINT [PK_TRefCaseReasonAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
