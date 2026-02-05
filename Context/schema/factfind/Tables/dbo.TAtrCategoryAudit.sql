CREATE TABLE [dbo].[TAtrCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Guid] [uniqueidentifier] NOT NULL,
[TenantId] [int] NOT NULL,
[TenantGuid] [uniqueidentifier] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrCategoryAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[AtrCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrCategoryAudit] ADD CONSTRAINT [PK_TAtrCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrCategoryAudit_AtrCategoryId_ConcurrencyId] ON [dbo].[TAtrCategoryAudit] ([AtrCategoryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
