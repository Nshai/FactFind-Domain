CREATE TABLE [dbo].[TCalculator]
(
[CalculatorId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Definition] [varchar] (7000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCalculator_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCalculator] ADD CONSTRAINT [PK_TCalculator] PRIMARY KEY CLUSTERED  ([CalculatorId]) WITH (FILLFACTOR=80)
GO
