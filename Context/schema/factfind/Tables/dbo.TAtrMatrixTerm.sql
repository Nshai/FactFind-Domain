CREATE TABLE [dbo].[TAtrMatrixTerm]
(
[AtrMatrixTermId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Starting] [tinyint] NULL,
[Ending] [tinyint] NULL,
[IndigoClientId] [int] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrMatrixTerm_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrMatrixTerm] ADD CONSTRAINT [PK_TAtrMatrixTerm] PRIMARY KEY NONCLUSTERED  ([AtrMatrixTermId])
GO
