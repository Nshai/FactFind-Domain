CREATE TABLE [dbo].[TQuoteItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[PortalQuoteRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[KeyXML] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ExpiryDate] [datetime] NULL,
[CommissionAmount] [money] NULL,
[CommissionNote] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ProductDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsMarked] [bit] NOT NULL CONSTRAINT [DF_TQuoteItemAudit_IsMarked] DEFAULT ((0)),
[CanApply] [bit] NOT NULL CONSTRAINT [DF_TQuoteItemAudit_CanApply] DEFAULT ((0)),
[ProductRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProviderCodeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[WarningMessage] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[QuoteDetailId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteItemAudit_ConcurrencyId] DEFAULT ((1)),
[QuoteItemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteItemAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PolicyBusinessId] [int] NULL
)
GO
ALTER TABLE [dbo].[TQuoteItemAudit] ADD CONSTRAINT [PK_TQuoteItemAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteItemAudit_QuoteItemId_ConcurrencyId] ON [dbo].[TQuoteItemAudit] ([QuoteItemId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
