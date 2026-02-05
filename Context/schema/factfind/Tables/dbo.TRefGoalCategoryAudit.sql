CREATE TABLE [dbo].[TRefGoalCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefGoalCategoryId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TRefGoalCategory_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefGoalCategoryAudit] ADD CONSTRAINT [PK_TRefGoalCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
