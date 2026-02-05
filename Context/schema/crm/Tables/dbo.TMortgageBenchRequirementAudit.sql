CREATE TABLE [dbo].[TMortgageBenchRequirementAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageBenchRequirementAudit_ConcurrencyId] DEFAULT ((1)),
[MortgageBenchRequirementId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageBenchRequirementAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageBenchRequirementAudit] ADD CONSTRAINT [PK_TMortgageBenchRequirementAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgageBenchRequirementAudit_MortgageBenchRequirementId_ConcurrencyId] ON [dbo].[TMortgageBenchRequirementAudit] ([MortgageBenchRequirementId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
