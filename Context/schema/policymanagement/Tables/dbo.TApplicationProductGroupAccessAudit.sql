CREATE TABLE [dbo].[TApplicationProductGroupAccessAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NOT NULL,
[RefProductGroupId] [int] NOT NULL,
[AllowAccess] [bit] NOT NULL CONSTRAINT [DF_TApplicationProductGroupAccessAudit_AllowAccess] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TApplicationProductGroupAccessAudit_ConcurrencyId] DEFAULT ((1)),
[ApplicationProductGroupAccessId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TApplicationProductGroupAccessAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TApplicationProductGroupAccessAudit] ADD CONSTRAINT [PK_TApplicationProductGroupAccessAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TApplicationProductGroupAccessAudit_ApplicationProductGroupAccessId_ConcurrencyId] ON [dbo].[TApplicationProductGroupAccessAudit] ([ApplicationProductGroupAccessId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
