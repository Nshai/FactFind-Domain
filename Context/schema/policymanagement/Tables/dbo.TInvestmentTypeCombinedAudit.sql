CREATE TABLE [dbo].[TInvestmentTypeCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[InvestmentTypeId] [int] NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[InvestmentCategoryId] [int] NOT NULL,
[InvestmentCategoryGuid] [uniqueidentifier] NOT NULL,
[DefaultRiskRating] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentTypeCombinedAudit_Guid] DEFAULT (newid()),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInvestmentTypeCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentTypeCombinedAudit] ADD CONSTRAINT [PK_TInvestmentTypeCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentTypeCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TInvestmentTypeCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
