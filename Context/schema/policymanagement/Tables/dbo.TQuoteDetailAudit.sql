CREATE TABLE [dbo].[TQuoteDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteDetailAudit_ConcurrencyId] DEFAULT ((1)),
[QuoteDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[QuoteSystemProductType] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[QuoteDetailInternal] [xml] NULL
)
GO
ALTER TABLE [dbo].[TQuoteDetailAudit] ADD CONSTRAINT [PK_TQuoteDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteDetailAudit_QuoteDetailId_ConcurrencyId] ON [dbo].[TQuoteDetailAudit] ([QuoteDetailId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
