CREATE TABLE [dbo].[TQuoteXSLAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[XSLIdentifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[RefApplicationId] [int] NULL,
[RefXSLTypeId] [int] NOT NULL,
[XSLData] [text] COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TQuoteXSLAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteXSLAudit_ConcurrencyId] DEFAULT ((1)),
[QuoteXSLId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteXSLAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteXSLAudit] ADD CONSTRAINT [PK_TQuoteXSLAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteXSLAudit_QuoteXSLId_ConcurrencyId] ON [dbo].[TQuoteXSLAudit] ([QuoteXSLId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
