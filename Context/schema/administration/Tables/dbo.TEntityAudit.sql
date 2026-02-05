CREATE TABLE [dbo].[TEntityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Db] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEntityAud_ConcurrencyId_1__56] DEFAULT ((1)),
[EntityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEntityAud_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
)
GO
ALTER TABLE [dbo].[TEntityAudit] ADD CONSTRAINT [PK_TEntityAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TEntityAudit_EntityId_ConcurrencyId] ON [dbo].[TEntityAudit] ([EntityId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

