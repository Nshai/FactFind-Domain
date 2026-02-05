CREATE TABLE [dbo].[TAtrCategoryCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrCategoryCombinedAudit_Guid] DEFAULT (newid()),
[AtrCategoryId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[TenantGuid] [uniqueidentifier] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrCategoryCombinedAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrCategoryCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrCategoryCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrCategoryCombinedAudit] ADD CONSTRAINT [PK_TAtrCategoryCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
