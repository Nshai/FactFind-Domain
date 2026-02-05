CREATE TABLE [dbo].[TRefRuleCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefRuleCategoryId] [int] NOT NULL,
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefRuleCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefRuleCategoryAudit] ADD CONSTRAINT [PK_TRefRuleCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
