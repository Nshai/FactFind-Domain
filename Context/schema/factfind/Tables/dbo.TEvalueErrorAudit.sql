CREATE TABLE [dbo].[TEvalueErrorAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[EvalueErrorDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EvalueErrorXML] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueErrorAudit_ConcurrencyId] DEFAULT ((1)),
[EvalueErrorId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueErrorAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueErrorAudit] ADD CONSTRAINT [PK_TEvalueErrorAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
