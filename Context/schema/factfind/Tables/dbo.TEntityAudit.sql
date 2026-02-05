CREATE TABLE [dbo].[TEntityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[DataStore] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Type] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Cols] [tinyint] NULL,
[Path] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[NavigationItemId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEntityAudit_ConcurrencyId] DEFAULT ((1)),
[EntityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEntityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEntityAudit] ADD CONSTRAINT [PK_TEntityAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
