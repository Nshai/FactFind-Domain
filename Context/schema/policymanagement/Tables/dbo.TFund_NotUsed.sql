CREATE TABLE [dbo].[TFund_NotUsed]
(
[FundId] [int] NOT NULL IDENTITY(1, 1),
[FeedId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Sedol] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MexId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Citicode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FundTypeId] [int] NOT NULL,
[SectorId] [int] NULL,
[ProviderId] [int] NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TFund_UpdatedDate] DEFAULT (getdate()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TFund_CreatedDate] DEFAULT (getdate()),
[IndigoClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFund_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFund_NotUsed] ADD CONSTRAINT [PK_TFund_FundId] PRIMARY KEY NONCLUSTERED  ([FundId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IX_TFund_ProviderIdASC] ON [dbo].[TFund_NotUsed] ([ProviderId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TFund_SectorIdASC] ON [dbo].[TFund_NotUsed] ([SectorId]) WITH (FILLFACTOR=80)
GO
