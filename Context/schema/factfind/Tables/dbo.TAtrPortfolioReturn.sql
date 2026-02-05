CREATE TABLE [dbo].[TAtrPortfolioReturn]
(
[AtrPortfolioReturnId] [int] NOT NULL IDENTITY(1, 1),
[AtrPortfolioGuid] [uniqueidentifier] NOT NULL,
[AtrRefPortfolioTermId] [int] NOT NULL,
[LowerReturn] [decimal] (10, 4) NULL,
[MidReturn] [decimal] (10, 4) NULL,
[UpperReturn] [decimal] (10, 4) NULL,
[Guid] [uniqueidentifier] NULL CONSTRAINT [DF_TAtrPortfolioReturn_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrPortfolioReturn_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrPortfolioReturn] ADD CONSTRAINT [PK_TAtrPortfolioReturn] PRIMARY KEY NONCLUSTERED  ([AtrPortfolioReturnId]) WITH (FILLFACTOR=80)
GO
