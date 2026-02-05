CREATE TABLE [dbo].[TSystemEntityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[PrimaryInfo] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[SecondaryInfo] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[SystemEntityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSystemEntityAudit] ADD CONSTRAINT [PK_TSystemEntityAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSystemEntityAudit_SystemEntityId_ConcurrencyId] ON [dbo].[TSystemEntityAudit] ([SystemEntityId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
