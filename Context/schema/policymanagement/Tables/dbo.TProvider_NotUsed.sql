CREATE TABLE [dbo].[TProvider_NotUsed]
(
[ProviderId] [int] NOT NULL IDENTITY(1, 1),
[ProviderName] [varchar] (255)  NOT NULL,
[FeedId] [varchar] (255)  NOT NULL,
[FundTypeId] [int] NOT NULL,
[Address_Line_1] [varchar] (255)  NULL,
[Address_Line_2] [varchar] (255)  NULL,
[City] [varchar] (255)  NULL,
[Country] [varchar] (255)  NULL,
[Postcode_1] [varchar] (255)  NULL,
[Postcode_2] [varchar] (255)  NULL,
[Telephone_Nbr] [varchar] (255)  NULL,
[Fax_Nbr] [varchar] (255)  NULL,
[EmailAddress] [varchar] (255)  NULL,
[WebAddress] [varchar] (255)  NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TProvider_NotUsed_UpdatedDate] DEFAULT (getdate()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TProvider_NotUsed_CreatedDate] DEFAULT (getdate()),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProvider_NotUsed_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProvider_NotUsed] ADD CONSTRAINT [PK_TProvider_ProviderId] PRIMARY KEY CLUSTERED  ([ProviderId])
GO
ALTER TABLE [dbo].[TProvider_NotUsed] WITH CHECK ADD CONSTRAINT [FK_TProvider_FundTypeId_FundTypeId] FOREIGN KEY ([FundTypeId]) REFERENCES [dbo].[TFundType] ([FundTypeId])
GO
