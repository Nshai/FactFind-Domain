CREATE TABLE [dbo].[TRefPlanType2ProdSubType]
(
[RefPlanType2ProdSubTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[ProdSubTypeId] [int] NULL,
[RefPortfolioCategoryId] [int] NULL,
[RefPlanDiscriminatorId] [int] NULL,
[DefaultCategory] [varchar] (255) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanType2ProdSubType_ConcurrencyId] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefPlanType2ProdSubType_IsArchived] DEFAULT ((0)),
[IsConsumerFriendly] [bit] NULL,
[RegionCode] [varchar] (2) NOT NULL CONSTRAINT [DF_TRefPlanType2ProdSubType_RegionCode] DEFAULT (('GB')) 
)
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubType] ADD CONSTRAINT [PK_TRefPlanType2ProdSubType] PRIMARY KEY CLUSTERED  ([RefPlanType2ProdSubTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefPlanType2ProdSubType_ProdSubTypeId] ON [dbo].[TRefPlanType2ProdSubType] ([ProdSubTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefPlanType2ProdSubType_RefPlanTypeId] ON [dbo].[TRefPlanType2ProdSubType] ([RefPlanTypeId])
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubType] WITH CHECK ADD CONSTRAINT [FK_TRefPlanType2ProdSubType_ProdSubTypeId_ProdSubTypeId] FOREIGN KEY ([ProdSubTypeId]) REFERENCES [dbo].[TProdSubType] ([ProdSubTypeId])
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubType] WITH CHECK ADD CONSTRAINT [FK_TRefPlanType2ProdSubType_RefPlanTypeId_RefPlanTypeId] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubType] WITH CHECK ADD CONSTRAINT [FK_TRefPlanType2ProdSubType_RefPortfolioCategoryId_RefPortfolioCategoryId] FOREIGN KEY ([RefPortfolioCategoryId]) REFERENCES [dbo].[TRefPortfolioCategory] ([RefPortfolioCategoryId])
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubType] WITH CHECK ADD CONSTRAINT [FK_TRefPlanType2ProdSubType_RefPlanDiscriminatorId_RefPlanDiscriminatorId] FOREIGN KEY ([RefPlanDiscriminatorId]) REFERENCES [dbo].[TRefPlanDiscriminator] ([RefPlanDiscriminatorId])
GO
