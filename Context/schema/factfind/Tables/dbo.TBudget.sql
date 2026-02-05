CREATE TABLE [dbo].[TBudget]
(
[BudgetId] [int] NOT NULL IDENTITY(1, 1),
[ClientId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Category] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Amount] [money] NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[CreatedByUserId] [int] NOT NULL,
[UpdatedOn] [datetime] NOT NULL,
[UpdatedByUserId] [int] NOT NULL,
[ConcurrencyId] [bigint] NOT NULL CONSTRAINT [DF_TBudget_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TBudget] ADD CONSTRAINT [PK_TBudgetItem_1] PRIMARY KEY CLUSTERED  ([BudgetId])
GO
ALTER TABLE [dbo].[TBudget] ADD CONSTRAINT [uc_BudgetCategory] UNIQUE NONCLUSTERED  ([ClientId], [Category])
GO
