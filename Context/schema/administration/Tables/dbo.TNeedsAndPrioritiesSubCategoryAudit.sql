CREATE TABLE [dbo].[TNeedsAndPrioritiesSubCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal][int] NULL,
[TenantId] [int] NOT NULL,
[NeedsAndPrioritiesSubCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TNeedsAndPrioritiesSubCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNeedsAndPrioritiesSubCategoryAudit] ADD CONSTRAINT [PK_TNeedsAndPrioritiesSubCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
