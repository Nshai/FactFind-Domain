CREATE TABLE [dbo].[TInvestmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Capital] [int] NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[InvestmentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInvestmentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentAudit] ADD CONSTRAINT [PK_TInvestmentAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TInvestmentAudit_InvestmentId_ConcurrencyId] ON [dbo].[TInvestmentAudit] ([InvestmentId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
