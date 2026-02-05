CREATE TABLE [dbo].[TRefQuoteStatus]
(
[RefQuoteStatusId] [int] NOT NULL IDENTITY(1, 1),
[QuoteStatusName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefQuoteStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefQuoteStatus] ADD CONSTRAINT [PK_TRefQuoteStatus] PRIMARY KEY NONCLUSTERED  ([RefQuoteStatusId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefQuoteStatus] ON [dbo].[TRefQuoteStatus] ([RefQuoteStatusId]) WITH (FILLFACTOR=80)
GO
