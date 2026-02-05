CREATE TABLE [dbo].[TInsuredItem]
(
[InsuredItemId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[RefInsuredItemTypeId] [int] NOT NULL,
[Description] [varchar] (255)  NULL,
[RefHomeContentCoverCategoryId] [int] NOT NULL,
[Value] [money] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInsuredItem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TInsuredItem] ADD CONSTRAINT [PK_TInsuredItem] PRIMARY KEY CLUSTERED  ([InsuredItemId])
GO
ALTER TABLE [dbo].[TInsuredItem] WITH CHECK ADD CONSTRAINT [FK_TInsuredItem_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
ALTER TABLE [dbo].[TInsuredItem] WITH CHECK ADD CONSTRAINT [FK_TInsuredItem_TRefHomeContentCoverCategory] FOREIGN KEY ([RefHomeContentCoverCategoryId]) REFERENCES [dbo].[TRefHomeContentCoverCategory] ([RefHomeContentCoverCategoryId])
GO
ALTER TABLE [dbo].[TInsuredItem] WITH CHECK ADD CONSTRAINT [FK_TInsuredItem_TRefInsuredItemType] FOREIGN KEY ([RefInsuredItemTypeId]) REFERENCES [dbo].[TRefInsuredItemType] ([RefInsuredItemTypeId])
GO
