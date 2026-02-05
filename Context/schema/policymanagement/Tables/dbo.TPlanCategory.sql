CREATE TABLE [dbo].[TPlanCategory]
(
[PlanCategoryId] [int] NOT NULL IDENTITY(1, 1),
[PlanCategoryName] [varchar] (255) NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefPlanCategory_RetireFg] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanCa_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPlanCategory] ADD CONSTRAINT [PK_TRefPlanCategory] PRIMARY KEY CLUSTERED  ([PlanCategoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TPlanCategory_IndigoClientId] ON [dbo].[TPlanCategory] ([IndigoClientId])
GO
