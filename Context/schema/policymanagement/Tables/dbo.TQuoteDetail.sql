CREATE TABLE [dbo].[TQuoteDetail]
(
[QuoteDetailId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NULL,
[XMLSentId] [int] NULL,
[SumAssuredAmount] [money] NULL,
[PremiumAmount] [money] NULL,
[CoverBasis] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[NumberofQuoteRequests] [int] NULL,
[NumberofQuoteResponses] [int] NULL,
[TransactionId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AdviceProcessId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PortalTransactionId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PollingStartTime] [datetime] NULL,
[ExpiryDate] [datetime] NULL,
[RefQuoteStatusId] [int] NULL,
[RequoteProductDetails] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[OriginalQuoteDetailId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteDetail_ConcurrencyId] DEFAULT ((1)),
[QuoteSystemProductType] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[QuoteDetailInternal] [xml] NULL
)
GO
ALTER TABLE [dbo].[TQuoteDetail] ADD CONSTRAINT [PK_TQuoteDetail] PRIMARY KEY NONCLUSTERED  ([QuoteDetailId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TQuoteDetail] ON [dbo].[TQuoteDetail] ([QuoteId]) WITH (FILLFACTOR=80)
GO
