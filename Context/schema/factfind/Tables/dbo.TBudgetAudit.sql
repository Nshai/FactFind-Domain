CREATE TABLE [dbo].[TBudgetAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[BudgetId] [int] NOT NULL,
[ClientId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Category] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Amount] [money] NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[CreatedByUserId] [int] NOT NULL,
[UpdatedOn] [datetime] NOT NULL,
[UpdatedByUserId] [int] NOT NULL,
[ConcurrencyId] [bigint] NOT NULL CONSTRAINT [DF_TBudgetAudit_ConcurrencyId] DEFAULT ((0)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBudgetAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBudgetAudit] ADD CONSTRAINT [PK_TBudgetAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBudgetAudit_BudgetId_ConcurrencyId] ON [dbo].[TBudgetAudit] ([BudgetId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
