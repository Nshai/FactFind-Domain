CREATE TABLE [dbo].[TAtrAssetClassCombinedBak]
(
[Guid] [uniqueidentifier] NOT NULL,
[AtrAssetClassId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Allocation] [decimal] (5, 2) NULL,
[Ordering] [tinyint] NULL,
[AtrPortfolioGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL
)
GO
