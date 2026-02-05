CREATE TABLE [dbo].[TInvestmentTypeSectorAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CategoryId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[InvestmentTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentTypeSectorAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL,
[InvestmentTypeSectorId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInvestmentTypeSectorAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentTypeSectorAudit] ADD CONSTRAINT [PK_TInvestmentTypeSectorAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentTypeSectorAudit_InvestmentTypeSectorId_ConcurrencyId] ON [dbo].[TInvestmentTypeSectorAudit] ([InvestmentTypeSectorId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
