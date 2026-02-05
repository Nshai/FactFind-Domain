CREATE TABLE [dbo].[TAtrAssetClass]
(
[AtrAssetClassId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Allocation] [decimal] (5, 2) NULL,
[Ordering] [tinyint] NULL,
[AtrRefAssetClassId] [int] NULL,
[AtrPortfolioGuid] [uniqueidentifier] NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrAssetClass_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAssetClass_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrAssetClass] ADD CONSTRAINT [PK_TAtrAssetClass] PRIMARY KEY NONCLUSTERED  ([AtrAssetClassId]) WITH (FILLFACTOR=80)
GO
