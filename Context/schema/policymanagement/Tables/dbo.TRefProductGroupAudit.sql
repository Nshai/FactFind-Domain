CREATE TABLE [dbo].[TRefProductGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProductGroupName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefProductGroupAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProductGroupAudit_ConcurrencyId] DEFAULT ((1)),
[RefProductGroupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefProductGroupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefProductGroupAudit] ADD CONSTRAINT [PK_TRefProductGroupAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefProductGroupAudit_RefProductGroupId_ConcurrencyId] ON [dbo].[TRefProductGroupAudit] ([RefProductGroupId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
