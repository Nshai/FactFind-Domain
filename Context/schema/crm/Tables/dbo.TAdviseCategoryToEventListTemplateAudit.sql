CREATE TABLE [dbo].[TAdviseCategoryToEventListTemplateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviseCategoryId] [int] NOT NULL,
[EventListTemplateId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AdviseCategoryToEventListTemplateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviseCategoryToEventListTemplateAudit] ADD CONSTRAINT [PK_TAdviseCategoryToEventListAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
