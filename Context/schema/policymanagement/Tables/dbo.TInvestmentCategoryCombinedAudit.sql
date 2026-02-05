CREATE TABLE [dbo].[TInvestmentCategoryCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[InvestmentCategoryId] [int] NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[OrderNbr] [int] NULL,
[ChartSeriesColour] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentCategoryCombinedAudit_Guid] DEFAULT (newid()),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInvestmentCategoryCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentCategoryCombinedAudit] ADD CONSTRAINT [PK_TInvestmentCategoryCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentCategoryCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TInvestmentCategoryCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
