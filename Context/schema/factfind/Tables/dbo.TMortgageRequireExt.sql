CREATE TABLE [dbo].[TMortgageRequireExt]
(
[MortgageRequireExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[MortgageRequiredFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageRequireExt_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageRequireExt] ADD CONSTRAINT [PK_TMortgageRequireExt] PRIMARY KEY NONCLUSTERED  ([MortgageRequireExtId]) WITH (FILLFACTOR=80)
GO
