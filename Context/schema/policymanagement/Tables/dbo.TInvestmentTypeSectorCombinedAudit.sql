CREATE TABLE [dbo].[TInvestmentTypeSectorCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[InvestmentTypeSectorId] [int] NOT NULL,
[CategoryId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[InvestmentTypeId] [int] NOT NULL,
[InvestmentTypeGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentTypeSectorCombinedAudit_Guid] DEFAULT (newid()),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInvestmentTypeSectorCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentTypeSectorCombinedAudit] ADD CONSTRAINT [PK_TInvestmentTypeSectorCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentTypeSectorCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TInvestmentTypeSectorCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
