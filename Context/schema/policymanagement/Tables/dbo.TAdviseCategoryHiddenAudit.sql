CREATE TABLE [dbo].[TAdviseCategoryHiddenAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviseCategoryHiddenId] [int] NOT NULL,
[AdviseCategoryId] [int] NOT NULL,
[GroupId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseCategoryHiddenAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviseCategoryHiddenAudit] ADD CONSTRAINT [PK_TAdviseCategoryHiddenAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
