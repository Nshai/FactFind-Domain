CREATE TABLE [dbo].[TTaxConsequence]
(
[TaxConsequenceId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TTaxConsequence_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TTaxConsequence] ADD CONSTRAINT [PK_TTaxConsequence] PRIMARY KEY CLUSTERED  ([TaxConsequenceId]) WITH (FILLFACTOR=80)
GO
