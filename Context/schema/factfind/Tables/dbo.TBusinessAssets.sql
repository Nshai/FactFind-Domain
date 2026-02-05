CREATE TABLE [dbo].[TBusinessAssets]
(
[BusinessAssetsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Property] [money] NULL,
[Equipment] [money] NULL,
[Vehicles] [money] NULL,
[BankAndBuilding] [money] NULL,
[OtherInvestments] [money] NULL,
[TotalAssets] [money] NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBusinessAssets__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TBusinessAssets_CRMContactId] ON [dbo].[TBusinessAssets] ([CRMContactId])
GO
