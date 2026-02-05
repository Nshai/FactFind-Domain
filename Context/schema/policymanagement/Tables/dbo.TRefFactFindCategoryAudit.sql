CREATE TABLE [dbo].[TRefFactFindCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identfier] [varchar] (24) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefFactFindCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[RefFactFindCategoryId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFactFindCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFactFindCategoryAudit] ADD CONSTRAINT [PK_TRefFactFindCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
