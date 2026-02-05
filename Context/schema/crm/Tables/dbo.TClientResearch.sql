CREATE TABLE [dbo].[TClientResearch]
(
[ClientResearchId] [int] NOT NULL IDENTITY(1, 1),
[CalculatorId] [int] NOT NULL,
[CRMContactId] [int] NULL,
[UserId] [int] NOT NULL,
[Date] [datetime] NOT NULL CONSTRAINT [DF_TClientResearch_Date] DEFAULT (getdate()),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientResearch_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TClientResearch] ADD CONSTRAINT [PK_TClientResearch] PRIMARY KEY CLUSTERED  ([ClientResearchId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TClientResearch_CalculatorIdASC] ON [dbo].[TClientResearch] ([CalculatorId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TClientResearch] ADD CONSTRAINT [FK_TClientResearch_CalculatorId_CalculatorId] FOREIGN KEY ([CalculatorId]) REFERENCES [dbo].[TCalculator] ([CalculatorId])
GO
