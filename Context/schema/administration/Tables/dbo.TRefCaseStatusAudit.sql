CREATE TABLE [dbo].[TRefCaseStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CaseStatusName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[DefaultFg] [bit] NOT NULL CONSTRAINT [DF_TRefCaseStatusAudit_DefaultFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCaseStatusAudit_ConcurrencyId] DEFAULT ((1)),
[RefCaseStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCaseStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCaseStatusAudit] ADD CONSTRAINT [PK_TRefCaseStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
