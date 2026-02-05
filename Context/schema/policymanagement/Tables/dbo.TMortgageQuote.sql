CREATE TABLE [dbo].[TMortgageQuote]
(
[MortgageQuoteId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[OpportunityId] [int] NULL,
[SessionGuid] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[CRMRef] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[UserRef] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PXIData] [text] COLLATE Latin1_General_CI_AS NULL,
[ResponseData] [text] COLLATE Latin1_General_CI_AS NULL,
[AssetDetails] [text] COLLATE Latin1_General_CI_AS NULL,
[SessionStart] [datetime] NULL,
[SessionEnd] [datetime] NULL,
[ObjectiveId] [int] NULL,
[ApplicationLinkId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageQuote_ConcurrencyId] DEFAULT ((1)),
[PropertyDetailId] [int] NULL,
[QuoteId] [int] NULL,
[AdditionalMteData] [text] COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageQuote] ADD CONSTRAINT [PK_TMortgageQuote] PRIMARY KEY NONCLUSTERED  ([MortgageQuoteId])
GO
