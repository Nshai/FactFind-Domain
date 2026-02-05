CREATE TABLE [dbo].[TMortgageRequireExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[MortgageRequiredFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageRequireExtAudit_ConcurrencyId] DEFAULT ((1)),
[MortgageRequireExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageRequireExtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageRequireExtAudit] ADD CONSTRAINT [PK_TMortgageRequireExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgageRequireExtAudit_MortgageRequireExtId_ConcurrencyId] ON [dbo].[TMortgageRequireExtAudit] ([MortgageRequireExtId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
