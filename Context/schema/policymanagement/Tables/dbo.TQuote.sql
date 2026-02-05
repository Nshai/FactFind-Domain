CREATE TABLE [dbo].[TQuote]
(
[QuoteId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationId] [int] NOT NULL,
[ExternalReference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[RefProductTypeId] [int] NOT NULL,
[RefQuoteStatusId] [int] NOT NULL,
[Term] [int] NULL,
[MessageDateTime] [datetime] NOT NULL,
[QuoteAdviserPartyId] [int] NULL,
[AccountUserId] [int] NOT NULL,
[LoggedOnUserId] [int] NOT NULL,
[QuoteClientId1] [int] NULL,
[QuoteClientTitle1] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId1] [int] NULL,
[QuoteClientId2] [int] NULL,
[QuoteClientTitle2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId2] [int] NULL,
[PolicyBusinessId] [int] NULL,
[NumberofQuoteRequests] [int] NULL,
[NumberofQuoteResponses] [int] NULL,
[DataXML] [varchar] (6000) COLLATE Latin1_General_CI_AS NULL,
[SummaryXML] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NULL,
[SequentialRefLegacy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SequentialRef]  AS (case when [SequentialRefLegacy] IS NULL then 'IOQ'+right(replicate('0',(8))+CONVERT([varchar],[QuoteId]),(8)) collate Latin1_General_CI_AS else [SequentialRefLegacy] end),
[Guid] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuote_ConcurrencyId] DEFAULT ((1)),
[QuoteSystemProductType] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[QuoteInternal] [xml] NULL,
[IsLegacyQuote] [bit] NOT NULL CONSTRAINT [DF_TQuote_IsLegacyQuote] DEFAULT ((0)),
[QuoteRequestedAmount] [money] NULL
)
GO
ALTER TABLE [dbo].[TQuote] ADD CONSTRAINT [PK_TQuote] PRIMARY KEY CLUSTERED  ([QuoteId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TQuote_CRMContactId1_IsLegacyQuote] ON [dbo].[TQuote] ([CRMContactId1], [IsLegacyQuote])
GO
CREATE NONCLUSTERED INDEX [IX_TQuote_IsLegacyQuote] ON [dbo].[TQuote] ([IsLegacyQuote]) INCLUDE ([AccountUserId], [MessageDateTime], [NumberofQuoteRequests], [PolicyBusinessId], [QuoteClientId1], [QuoteId], [RefApplicationId], [RefProductTypeId], [RefQuoteStatusId])
GO
CREATE NONCLUSTERED INDEX [IX_TQuote_QuoteClientId1_IsLegacyQuote] ON [dbo].[TQuote] ([QuoteClientId1], [IsLegacyQuote]) INCLUDE ([AccountUserId], [MessageDateTime], [NumberofQuoteRequests], [PolicyBusinessId], [QuoteId], [RefApplicationId], [RefProductTypeId], [RefQuoteStatusId])
GO
CREATE NONCLUSTERED INDEX IX_TQuote_PolicyBusinessId ON [dbo].[TQuote] ([PolicyBusinessId]) INCLUDE ([QuoteId])
go
CREATE NONCLUSTERED INDEX [IX_TQuote_IndigoClientId_QuoteId] ON [dbo].[TQuote] ([IndigoClientId], [QuoteId])
GO
create index IX_TQuote_QuoteClientId2 on TQuote (QuoteClientId2)
GO