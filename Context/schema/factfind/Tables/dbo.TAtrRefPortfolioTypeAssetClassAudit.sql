CREATE TABLE [dbo].[TAtrRefPortfolioTypeAssetClassAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrRefPortfolioTypeId] [int] NOT NULL,
[AtrRefAssetClassId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAtrRefPortfolioTypeAssetClassAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRefPortfolioTypeAssetClassId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRefPortfolioTypeAssetClassAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrRefPortfolioTypeAssetClassAudit] ADD CONSTRAINT [PK_TAtrRefPortfolioTypeAssetClassAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRefPortfolioTypeAssetClassAudit_AtrRefPortfolioTypeAssetClassId_ConcurrencyId] ON [dbo].[TAtrRefPortfolioTypeAssetClassAudit] ([AtrRefPortfolioTypeAssetClassId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
