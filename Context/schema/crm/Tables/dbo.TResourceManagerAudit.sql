CREATE TABLE [dbo].[TResourceManagerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ResourceListId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[DefaultFG] [bit] NOT NULL,
[IndClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[ResourceManagerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TResourceM_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TResourceManagerAudit] ADD CONSTRAINT [PK_TResourceManagerAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TResourceManagerAudit_ResourceManagerId_ConcurrencyId] ON [dbo].[TResourceManagerAudit] ([ResourceManagerId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
