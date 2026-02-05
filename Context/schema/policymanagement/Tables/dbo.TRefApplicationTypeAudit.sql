CREATE TABLE [dbo].[TRefApplicationTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefApplicationTypeAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplicationTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefApplicationTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefApplicationTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefApplicationTypeAudit] ADD CONSTRAINT [PK_TRefApplicationTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefApplicationTypeAudit_RefApplicationTypeId_ConcurrencyId] ON [dbo].[TRefApplicationTypeAudit] ([RefApplicationTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
