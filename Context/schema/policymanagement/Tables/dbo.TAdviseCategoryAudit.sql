CREATE TABLE [dbo].[TAdviseCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AdviseCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GroupId] [int] NULL,
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TAdviseCategoryAudit_IsPropagated] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviseCategoryAudit] ADD CONSTRAINT [PK_TAdviseCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviseCategoryAudit_AdviseCategoryId] ON [dbo].[TAdviseCategoryAudit] ([AdviseCategoryId])
GO
