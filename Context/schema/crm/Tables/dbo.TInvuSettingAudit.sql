CREATE TABLE [dbo].[TInvuSettingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[FilePath] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInvuSettingAudit_ConcurrencyId] DEFAULT ((1)),
[InvuSettingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInvuSettingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvuSettingAudit] ADD CONSTRAINT [PK_TInvuSettingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TInvuSettingAudit_InvuSettingId_ConcurrencyId] ON [dbo].[TInvuSettingAudit] ([InvuSettingId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
