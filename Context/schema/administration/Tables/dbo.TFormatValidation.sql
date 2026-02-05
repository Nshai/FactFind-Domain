CREATE TABLE [dbo].[TFormatValidation]
(
[FormatValidationId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Entity] [varchar] (50)  NOT NULL,
[RuleType] [int] NOT NULL,
[ValidationExpression] [varchar] (7000)  NOT NULL,
[ErrorMessage] [varchar] (100)  NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFormatValidation] ADD CONSTRAINT [PK_TFormatValidation] PRIMARY KEY CLUSTERED  ([FormatValidationId])
GO
ALTER TABLE [dbo].[TFormatValidation] WITH CHECK ADD CONSTRAINT [FK_TFormatValidation_IndigoClientId_IndigoClientId] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
