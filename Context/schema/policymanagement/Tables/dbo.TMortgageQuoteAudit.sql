CREATE TABLE [dbo].[TMortgageQuoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageQuoteAudit_ConcurrencyId] DEFAULT ((1)),
[MortgageQuoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageQuoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PropertyDetailId] [int] NULL,
[QuoteId] [int] NULL,
[AdditionalMteData] [text] COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageQuoteAudit] ADD CONSTRAINT [PK_TMortgageQuoteAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgageQuoteAudit_MortgageQuoteId_ConcurrencyId] ON [dbo].[TMortgageQuoteAudit] ([MortgageQuoteId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
