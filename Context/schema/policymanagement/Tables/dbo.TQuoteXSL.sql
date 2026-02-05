CREATE TABLE [dbo].[TQuoteXSL]
(
[QuoteXSLId] [int] NOT NULL IDENTITY(1, 1),
[XSLIdentifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[RefApplicationId] [int] NULL,
[RefXSLTypeId] [int] NOT NULL,
[XSLData] [text] COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TQuoteXSL_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteXSL_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuoteXSL] ADD CONSTRAINT [PK_TQuoteXSL] PRIMARY KEY NONCLUSTERED  ([QuoteXSLId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TQuoteXSL] ON [dbo].[TQuoteXSL] ([XSLIdentifier]) WITH (FILLFACTOR=80)
GO
