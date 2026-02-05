CREATE TABLE [dbo].[TAtrMatrix]
(
[AtrMatrixId] [int] NOT NULL IDENTITY(1, 1),
[AtrRefMatrixDurationId] [int] NULL,
[ImmediateIncome] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RiskProfileGuid] [uniqueidentifier] NOT NULL,
[AtrPortfolioGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[AtrMatrixTermGuid] [uniqueidentifier] NULL,
[Guid] [uniqueidentifier] NULL CONSTRAINT [DF_TAtrMatrix_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrMatrix_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrMatrix] ADD CONSTRAINT [PK_TAtrMatrix] PRIMARY KEY NONCLUSTERED  ([AtrMatrixId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrMatrix_Guid] ON [dbo].[TAtrMatrix] ([Guid]) WITH (FILLFACTOR=80)
GO
