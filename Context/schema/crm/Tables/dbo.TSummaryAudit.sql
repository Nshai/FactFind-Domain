CREATE TABLE [dbo].[TSummaryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Property] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Comment] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[TargetIncome] [money] NULL,
[TargetLumpSum] [money] NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[SummaryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSummaryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSummaryAudit] ADD CONSTRAINT [PK_TSummaryAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSummaryAudit_SectionDefinitionId_ConcurrencyId] ON [dbo].[TSummaryAudit] ([SummaryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
