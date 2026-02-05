CREATE TABLE [dbo].[TFinancialPlanningOutputType]
(
[FinancialPlanningOutputTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[ToolName] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningOutputType_ConcurrencyId] DEFAULT ((1)),
[OutputIdentifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningOutputType] ADD CONSTRAINT [PK_TFinancialPlanningOutputType] PRIMARY KEY CLUSTERED  ([FinancialPlanningOutputTypeId])
GO
