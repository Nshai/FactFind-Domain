CREATE TABLE [dbo].[TRefFinancialPlanningAssetColourAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AssetDescription] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AssetSeriesNumber] [int] NULL,
[AssetColour] [varchar] (7) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[RefFinancialPlanningAssetColourId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFinancialPlanningAssetColourAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFinancialPlanningAssetColourAudit] ADD CONSTRAINT [PK_TRefFinancialPlanningAssetColourAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefFinancialPlanningAssetColourAudit_RefFinancialPlanningAssetColourId_ConcurrencyId] ON [dbo].[TRefFinancialPlanningAssetColourAudit] ([RefFinancialPlanningAssetColourId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
