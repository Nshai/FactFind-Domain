CREATE TABLE [dbo].[TRefCurrency]
(
[RefCurrencyId] [int] NOT NULL IDENTITY(1, 1),
[CurrencyCode] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Symbol] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCurrency_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCurrency] ADD CONSTRAINT [PK_TRefCurrency] PRIMARY KEY CLUSTERED  ([RefCurrencyId]) WITH (FILLFACTOR=80)
GO
