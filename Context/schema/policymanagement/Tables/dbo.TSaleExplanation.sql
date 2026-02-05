CREATE TABLE [dbo].[TSaleExplanation]
(
[SaleExplanationId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSaleExplanation_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSaleExplanation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSaleExplanation] ADD CONSTRAINT [PK_TSaleExplanation] PRIMARY KEY CLUSTERED  ([SaleExplanationId]) WITH (FILLFACTOR=80)
GO
