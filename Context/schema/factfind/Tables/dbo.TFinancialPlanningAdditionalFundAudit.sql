CREATE TABLE [dbo].[TFinancialPlanningAdditionalFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FundId] [int] NOT NULL,
[FinancialPlanningId] [int] NOT NULL,
[UnitQuantity] [int] NOT NULL,
[UnitPrice] [money] NOT NULL,
[FundDetails] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningAdditionalFundAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningAdditionalFundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningAdditionalFundAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningAdditionalFundAudit] ADD CONSTRAINT [PK_TFinancialPlanningAdditionalFundAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningAdditionalFundAudit_FinancialPlanningAdditionalFundId_ConcurrencyId] ON [dbo].[TFinancialPlanningAdditionalFundAudit] ([FinancialPlanningAdditionalFundId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
