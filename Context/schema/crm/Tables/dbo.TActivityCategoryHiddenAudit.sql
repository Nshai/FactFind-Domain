CREATE TABLE [dbo].[TActivityCategoryHiddenAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActivityCategoryHiddenId] [int] NOT NULL,
[ActivityCategoryId] [int] NOT NULL,
[GroupId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityCategoryHiddenAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityCategoryHiddenAudit] ADD CONSTRAINT [PK_TActivityCategoryHiddenAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
