CREATE TABLE [dbo].[TValuationXSL]
(
[ValuationXSLId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[XSL] [varchar] (7000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValuationXSL_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValuationXSL] ADD CONSTRAINT [PK_TValuationXSL] PRIMARY KEY CLUSTERED  ([ValuationXSLId]) WITH (FILLFACTOR=80)
GO
