CREATE TABLE [dbo].[TSystemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[SystemPath] [varchar] (256) COLLATE Latin1_General_CI_AS NULL,
[SystemType] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[ParentId] [int] NULL,
[Url] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[EntityId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[SystemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSystemAud_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Order] [int] NULL
)
GO
ALTER TABLE [dbo].[TSystemAudit] ADD CONSTRAINT [PK_TSystemAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSystemAudit_SystemId_ConcurrencyId] ON [dbo].[TSystemAudit] ([SystemId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
