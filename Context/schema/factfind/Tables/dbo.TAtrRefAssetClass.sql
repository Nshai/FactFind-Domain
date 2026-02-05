CREATE TABLE [dbo].[TAtrRefAssetClass]
(
[AtrRefAssetClassId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ShortName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordering] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefAssetClass_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrRefAssetClass] ADD CONSTRAINT [PK_TAtrRefAssetClass] PRIMARY KEY NONCLUSTERED  ([AtrRefAssetClassId]) WITH (FILLFACTOR=80)
GO
