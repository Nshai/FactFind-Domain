CREATE TABLE [dbo].[TQuoteItem]
(
[QuoteItemId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[PortalQuoteRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[KeyXML] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ExpiryDate] [datetime] NULL,
[CommissionAmount] [money] NULL,
[CommissionNote] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ProductDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsMarked] [bit] NOT NULL CONSTRAINT [DF_TQuoteItem_IsMarked] DEFAULT ((0)),
[CanApply] [bit] NOT NULL CONSTRAINT [DF_TQuoteItem_CanApply] DEFAULT ((0)),
[ProductRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProviderCodeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[WarningMessage] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[QuoteDetailId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteItem_ConcurrencyId] DEFAULT ((1)),
[PolicyBusinessId] [int] NULL
)
GO
ALTER TABLE [dbo].[TQuoteItem] ADD CONSTRAINT [PK_TQuoteItem] PRIMARY KEY NONCLUSTERED  ([QuoteItemId])
GO
CREATE NONCLUSTERED INDEX [IX_TQuoteItem_QuoteDetailId] ON [dbo].[TQuoteItem] ([QuoteDetailId])
GO
CREATE CLUSTERED INDEX [IDX_TQuoteItem] ON [dbo].[TQuoteItem] ([QuoteId])
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteItem_QuoteId_PolicyBusinessId] ON [dbo].[TQuoteItem] ([QuoteId], [PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX IX_TQuoteItem_PolicyBusinessId ON [dbo].[TQuoteItem] ([PolicyBusinessId]) INCLUDE ([QuoteItemId],[QuoteId])
GO