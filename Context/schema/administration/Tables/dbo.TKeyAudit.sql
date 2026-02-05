CREATE TABLE [dbo].[TKeyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RightMask] [int] NOT NULL,
[SystemId] [int] NOT NULL,
[UserId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[RoleId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[KeyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TKeyAudit_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TKeyAudit] ADD CONSTRAINT [PK_TKeyAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TKeyAudit_KeyId_ConcurrencyId] ON [dbo].[TKeyAudit] ([KeyId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
