CREATE TABLE [dbo].[TRefAssetClass]
(
[RefAssetClassId] [int] NOT NULL IDENTITY(1, 1),
[AssetClassName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FundsDBName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[FundsAllowedFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAssetC_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAssetClass] ADD CONSTRAINT [PK_TRefAssetClass_2__63] PRIMARY KEY NONCLUSTERED  ([RefAssetClassId]) WITH (FILLFACTOR=80)
GO
