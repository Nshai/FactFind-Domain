CREATE TABLE [dbo].[TFullQuotePropertyDetails]
(
[FullQuotePropertyDetailsId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[PropertytobeMortgagedId] [int] NULL,
[HouseType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PropertyType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Bedrooms] [int] NULL,
[DiningRooms] [int] NULL,
[AdditionalRooms] [int] NULL,
[Kitchens] [int] NULL,
[Bathrooms] [int] NULL,
[numfloors] [int] NULL,
[FloorInBlock] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FlatsInBlock] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TenureType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Walls] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Roof] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuotePropertyDetails_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFullQuotePropertyDetails] ADD CONSTRAINT [PK_TFullQuotePropertyDetails] PRIMARY KEY NONCLUSTERED  ([FullQuotePropertyDetailsId])
GO
